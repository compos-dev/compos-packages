;;; agent-connectors-test.scm --- each connector says how its turns are paid.
;;;
;;; The usage ledger records an ACP turn as a cost or as an estimate. The
;;; connector decides: 'subscription matches the models that a subscription
;;; pays for, and every other model is billed per token. 'price-provider
;;; names the catalog provider of a bare model id.

(domain! 'testing)
(effects! '(pure))

(define (t--subscription? name m)
  (let ((re (plist-get (connector-config name) 'subscription)))
    (and re (re-match? re m) #t)))

(deftest 'the-default-connector-subscription-pays-for-every-model
  "the default connector's turns are paid by the subscription"
  (lambda ()
    (check-true! (t--subscription? "claude-code" "claude-sonnet-5")
                 "a model of the default connector is on the subscription")
    (check-true! (t--subscription? "claude-code" "default")
                 "the adapter's default model is on the subscription")))

(deftest 'only-the-opencode-go-models-are-on-a-subscription
  "opencode bills its pay-as-you-go models and not its Go models"
  (lambda ()
    (check-true! (t--subscription? "opencode" "opencode-go/deepseek-v4.1-flash")
                 "a Go model is on the subscription")
    (check-false! (t--subscription? "opencode" "opencode/claude-sonnet-5")
                  "a pay-as-you-go model is billed")
    (check-false! (t--subscription? "opencode" "anthropic/claude-sonnet-5")
                  "a model on the user's own provider key is billed")
    (check-true! (t--subscription? "opencode-go" "opencode-go/deepseek-v4.1-flash")
                 "the opencode-go connector has the same subscription")))

(deftest 'the-deepseek-harness-is-billed-under-deepseek
  "deepseek has no subscription and prices its bare ids as deepseek"
  (lambda ()
    (check-false! (t--subscription? "deepseek" "deepseek-v4-pro")
                  "the provider key bills every token")
    (check-equal! (plist-get (connector-config "deepseek") 'price-provider) "deepseek"
                  "a bare id is priced under deepseek")))
