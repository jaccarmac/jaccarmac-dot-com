;; guix pack -f docker fossil --entry-point=bin/fossil
;; guix shell podman
;; sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 jaccarmac
;; mkdir -p ~/.config/containers
;; curl -o ~/.config/containers/policy.json https://src.fedoraproject.org/rpms/containers-common/raw/main/f/default-policy.json
;; podman load -i /gnu/store/svl2bxkkbdqg5il5bxm1q1xmbdzkk1sv-fossil-docker-pack.tar.gz
;; podman run --rm -v /home/jaccarmac/src/fossils:/var -p 8080 fossil server --nojail /var/jaccarmac-dot-com.fossil

;; slime "guix shell sbcl sbcl-cl-sqlite sbcl-chipz -- sbcl"

(require 'sqlite)
(import 'sqlite:with-open-database)
(import 'sqlite:execute-single)
(require 'chipz)
(import 'chipz:decompress)
(import 'chipz:zlib)

(defun trunk-manifest-of (path)
  (with-open-database (db path)
    (let* ((trunk (execute-single db "SELECT t.rid FROM tagxref t
                                      RIGHT JOIN leaf l ON t.rid = l.rid
                                      WHERE t.value = 'trunk'"))
           (compressed (execute-single db "SELECT content FROM artifact
                                           WHERE rid = ?" trunk)))
      (sb-ext:octets-to-string (decompress nil 'zlib compressed :input-start 4)))))


;; For repositories with multiple trunk leaves, like Fossil itself, we need to
;; sort by mtime descending and/or check for the closed tag on a given checkin.

;; https://www.reddit.com/r/googlecloud/comments/117dd9i/cloud_run_broken_by_design/j9ddq8a/
;; Move to Cloud Run or maybe not.
