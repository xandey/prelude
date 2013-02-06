;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;; setup window size according to resolution
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        ;; use 120 char wide window for largeish displays
        ;; and smaller 80 column windows for smaller displays
        ;; pick whatever numbers make sense for you
        (if (> (x-display-pixel-width) 1280)
            (add-to-list 'default-frame-alist (cons 'width 180))
          (add-to-list 'default-frame-alist (cons 'width 120)))
        ;; for the height, subtract a couple hundred pixels
        ;; from the screen height (for panels, menubars and
        ;; whatnot), then divide by the height of a char to
        ;; get the height we want
        (add-to-list 'default-frame-alist
                     (cons 'height (/ (- (x-display-pixel-height) 100)
                                      (frame-char-height)))))))

(set-frame-size-according-to-resolution)

;; visual line mode always on for text
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; indentation style, i like this better:
(setq c-default-style "linux" c-basic-offset 2)

;; this works on osx, start server each time
(when window-system (load "server")
      (unless (server-running-p) (server-start)))

;; on osx, usr/local/bin is not searched by default for some reason
(if (string-equal "darwin" (symbol-name system-type))
    (add-to-list 'exec-path "/usr/local/bin"))
(if (string-equal "darwin" (symbol-name system-type))
    (add-to-list 'exec-path (concat (getenv "HOME") "/.bin")))

;; turn off delete selection mode
(delete-selection-mode 0)

;; stop emacs from creating ~ files
(setq make-backup-files nil)

;; recent files: <esc> <esc> x
(require 'recentf)
(recentf-mode 1)
(global-set-key (kbd "<escape> <escape> x") 'recentf-open-files)

;; max shell history size
'(comint-input-ring-size 5000)

;; shell stuff:
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; setup tramp to use the hostname in it's cache file:
(if (string-equal "darwin" (symbol-name system-type))
    (setq tramp-persistency-file-name "~/.emacs.d/tramp-darwin")
  (setq tramp-persistency-file-name "~/.emacs.d/tramp-linux"))

;;prelude stuff:
;; remove guru mode and allow arrows:
(defun disable-guru-mode ()
  (guru-mode -1)
  )
(add-hook 'prelude-prog-mode-hook 'disable-guru-mode t)
;; remove whitespace characters
;(whitespace-mode 0)
(add-hook 'prog-mode-hook 'whitespace-turn-off t)

;;matlab loading stuff:
(add-to-list 'load-path (expand-file-name "matlab-emacs" prelude-personal-dir))
(load-library "matlab-load")
(matlab-cedet-setup)

(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))

;; fix for mlint to run ... dynamic lib is wrong or something
;; ref: http://forums.somethingawful.com/showthread.php?threadid=3400187&userid=140079
(if (string-equal "darwin" (symbol-name system-type))
    (setenv "DYLD_LIBRARY_PATH" "/Applications/MATLAB_R2012a.app/bin/maci64" ))
;; add matlab bin directory to pathbin to environemtn path
(if (string-equal "darwin" (symbol-name system-type))
    (setenv "PATH" (concat (getenv "PATH") ":/Applications/MATLAB_R2012a.app/bin:/Applications/MATLAB_R2012a.app/bin/maci64:~/.bin")))

(setq matlab-show-mlint-warnings t)
(setq matlab-highlight-cross-function-variables t)

(setq matlab-show-mlint-warnings t)
(setq matlab-highlight-cross-function-variables t)

(setq matlab-shell-command "~/.bin/mat-nice")
(setq matlab-shell-command-switches '("-nodesktop -nosplash"))
(setq matlab-indent-function-body nil)  ; if you want function bodies indented

(setq default-fill-column 120)
(setq matlab-cont-level 2)
(setq matlab-highlight-cross-function-variables t)
(setq matlab-indent-function-body nil)
(setq matlab-indent-level 2)
;;(setq matlab-shell-ask-MATLAB-for-completions nil)

;; matlab mlint for mac:
(setq mlint-programs (quote ("mlint" "mac/mlint" "maci64/mlint" "/Applications/MATLAB_R2012a.app/bin/maci64/mlint")))
;;(setq mlint-programs (quote ("/Applications/MATLAB_R2012a.app/bin/maci64/mlint" "mac/mlint")))


;; matlab-shell turn off electric-paren
(add-hook 'matlab-shell-mode-hook (lambda () (electric-pair-mode -1)))
