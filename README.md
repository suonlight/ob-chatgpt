# Introduction

`ob-chatgpt` is an Emacs package that allows you to query OpenAI's GPT-3 language model directly from within org-babel code blocks. This package uses https://github.com/joshcho/ChatGPT.el under the hood. With `ob-chatgpt`, you can write and execute code blocks that communicate with chatgpt, allowing you to harness the power of the largest language model to date in your org-mode documents.

# Installation

To install `ob-chatgpt`, you will need to have `ChatGPT.el` installed. You can find installation instructions for `ChatGPT.el` at https://github.com/joshcho/ChatGPT.el.

## Doom Emacs

In `packages.el`,

``` emacs-lisp
(package! chatgpt :recipe (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el")))
(package! ob-chatgpt :recipe (:host github :repo "suonlight/ob-chatgpt" :files ("dist" "*.el")))
```

In `config.el`,

``` emacs-lisp
(use-package! chatgpt
  :defer t
  :bind ("C-c q" . chatgpt-query)
  :config
  (setq chatgpt-repo-path (expand-file-name "straight/repos/ChatGPT.el/" doom-local-dir))
  (set-popup-rule! (regexp-quote "*ChatGPT*")
    :side 'bottom :size .5 :ttl nil :quit t :modeline nil))

(use-package! ob-chatgpt
  :after '(org chatgpt))
```

# Usage

Once you have `ob-chatgpt` installed, you can start using it in your org-mode documents. To use `ob-chatgpt`, you simply need to create an org-babel code block and specify `chatgpt` as the language. For example:

```
#+BEGIN_SRC chatgpt
What is the capital of France?
#+END_SRC
```

When you execute this code block, `ob-chatgpt` will send the text "What is the capital of France?" to chatgpt, and return the response to the code block.

# Troubleshooting

A frequent cause of no response from ob-chatgpt or the *ChatGPT* buffer is the need to re-authenticate ChatGPT, as explained in the first three issues found at https://github.com/joshcho/ChatGPT.el#troubleshooting. To address this, employ the following code:

``` emacs-lisp
(chatgpt-reset)
(chatgpt-stop)
(chatgpt-login)
```
