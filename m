Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225F06E7F95
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbjDSQ0D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbjDSQ0C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:26:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D7910C1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:26:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b7b18a336so11258b3a.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921560; x=1684513560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Um+nb2+lFo5MMa4n2nYjynvYaU31qYFb1VpiGZ7Cvgw=;
        b=5FWfNeq6Pkfl4jfcO6mcHv7Cy/DZQCcih9/9KQIcVFTrpbZNr0Vkjc+0xz5gw6ZqGJ
         mxI5KYgRvhAa7EiAUOf4Sw105aHBOM7PFSbBFni4I6nFsP3V0YvEVNq+2OzZjfz2NEFh
         NPLMXrySfZTij+cZJEo2p8BxFvAItSoQMoZksw+O0L2cO6f29rxUpP1NnoeJWiQnw2I0
         LOVN3a6A6nn0LQq3tHTHX+VXmNJJya60vd0rogsWc5q2SsotxQ0JSRvJsx/4mcnZuy7Z
         IsApdZ0Dp8NonNgHsBTKoQot4+umbcD6JFA3SfibiIoEXqBcIMkWKnQVzx4rb/SKVi6Q
         phUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921560; x=1684513560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Um+nb2+lFo5MMa4n2nYjynvYaU31qYFb1VpiGZ7Cvgw=;
        b=RN01h1phyD+1/s6gdkps+FMCLzgozqZhS0kq8LE7RhY04OIdCDGvuZGw+fjEB40siJ
         87odgtwy8OcNON33FHKhhFV4LbNs30e6oRcNY7UW1R7wLB5/65AJpbB6Ka8K6vZekGaR
         EvCtyiDJHup7db+JaWZgs46icQGou7slYTS/+f+z6kqOxDpArpNvdl+YyN2moS36eEXP
         EY7H1Q2FiqVl2UjGhs5gwYO8VyEgcnchFpxC9ml94yyBXA0iXgno7nzBRZnr2Fx9N6gz
         DoL3GxLWFh/zGE3LLKWf5y1nQ8BJBPzWc8cnJrvnwCiunc6v6QyzeMGh+c2fs5dXS2Dj
         tTyA==
X-Gm-Message-State: AAQBX9fLrHH4ja137CC8bQEnSmJEgcFsBbLrhMEh+B4Xnhk4zkaCjrzF
        WEXBZ5M19QK+oNLkRqecnldVuRaoAvVpCYwobk4=
X-Google-Smtp-Source: AKy350aLEmV9kcjyEyj8hmFPGyvSW3ScKXtJ0sTyJ3Dakmn0pafuiP84gLPK2xjoaNa9+jhzAoYbNw==
X-Received: by 2002:a05:6a00:338f:b0:5e4:f141:568b with SMTP id cm15-20020a056a00338f00b005e4f141568bmr19984482pfb.3.1681921559890;
        Wed, 19 Apr 2023 09:25:59 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] Revert "io_uring: for requests that require async, force it"
Date:   Wed, 19 Apr 2023 10:25:51 -0600
Message-Id: <20230419162552.576489-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit aebb224fd4fc7352cd839ad90414c548387142fd.

In preparation for handling this a bit differently, revert this
cleanup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/advise.c |  4 ++--
 io_uring/fs.c     | 20 ++++++++++----------
 io_uring/net.c    |  4 ++--
 io_uring/splice.c |  7 ++++---
 io_uring/statx.c  |  4 ++--
 io_uring/sync.c   | 14 ++++++--------
 io_uring/xattr.c  | 14 ++++++++------
 7 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/io_uring/advise.c b/io_uring/advise.c
index cf600579bffe..449c6f14649f 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -39,7 +39,6 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ma->addr = READ_ONCE(sqe->addr);
 	ma->len = READ_ONCE(sqe->len);
 	ma->advice = READ_ONCE(sqe->fadvise_advice);
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -52,7 +51,8 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/fs.c b/io_uring/fs.c
index f6a69a549fd4..7100c293c13a 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -74,7 +74,6 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -83,7 +82,8 @@ int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
 				ren->newpath, ren->flags);
@@ -123,7 +123,6 @@ int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return PTR_ERR(un->filename);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -132,7 +131,8 @@ int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_unlink *un = io_kiocb_to_cmd(req, struct io_unlink);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	if (un->flags & AT_REMOVEDIR)
 		ret = do_rmdir(un->dfd, un->filename);
@@ -170,7 +170,6 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return PTR_ERR(mkd->filename);
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -179,7 +178,8 @@ int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
 
@@ -220,7 +220,6 @@ int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -229,7 +228,8 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
 
@@ -265,7 +265,6 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -274,7 +273,8 @@ int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
 				lnk->newpath, lnk->flags);
diff --git a/io_uring/net.c b/io_uring/net.c
index 89e839013837..e85a868290ec 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -91,7 +91,6 @@ int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	shutdown->how = READ_ONCE(sqe->len);
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -101,7 +100,8 @@ int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 2a4bbb719531..53e4232d0866 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -34,7 +34,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -53,7 +52,8 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *in;
 	long ret = 0;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
 		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
@@ -94,7 +94,8 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *in;
 	long ret = 0;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
 		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
diff --git a/io_uring/statx.c b/io_uring/statx.c
index abb874209caa..d8fc933d3f59 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -48,7 +48,6 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -57,7 +56,8 @@ int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/sync.c b/io_uring/sync.c
index 255f68c37e55..64e87ea2b8fb 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -32,8 +32,6 @@ int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sync->off = READ_ONCE(sqe->off);
 	sync->len = READ_ONCE(sqe->len);
 	sync->flags = READ_ONCE(sqe->sync_range_flags);
-	req->flags |= REQ_F_FORCE_ASYNC;
-
 	return 0;
 }
 
@@ -43,7 +41,8 @@ int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	/* sync_file_range always requires a blocking context */
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = sync_file_range(req->file, sync->off, sync->len, sync->flags);
 	io_req_set_res(req, ret, 0);
@@ -63,7 +62,6 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sync->off = READ_ONCE(sqe->off);
 	sync->len = READ_ONCE(sqe->len);
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -74,7 +72,8 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	/* fsync always requires a blocking context */
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = vfs_fsync_range(req->file, sync->off, end > 0 ? end : LLONG_MAX,
 				sync->flags & IORING_FSYNC_DATASYNC);
@@ -92,7 +91,6 @@ int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sync->off = READ_ONCE(sqe->off);
 	sync->len = READ_ONCE(sqe->addr);
 	sync->mode = READ_ONCE(sqe->len);
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -102,8 +100,8 @@ int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	/* fallocate always requiring blocking context */
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
-
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 	ret = vfs_fallocate(req->file, sync->mode, sync->off, sync->len);
 	if (ret >= 0)
 		fsnotify_modify(req->file);
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index e1c810e0b85a..6201a9f442c6 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -75,7 +75,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -110,7 +109,8 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = do_getxattr(mnt_idmap(req->file->f_path.mnt),
 			req->file->f_path.dentry,
@@ -127,7 +127,8 @@ int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 	struct path path;
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 retry:
 	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
@@ -173,7 +174,6 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -222,7 +222,8 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 	ret = __io_setxattr(req, issue_flags, &req->file->f_path);
 	io_xattr_finish(req, ret);
@@ -236,7 +237,8 @@ int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 	struct path path;
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
 
 retry:
 	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
-- 
2.39.2

