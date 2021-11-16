Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B055452A34
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 06:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhKPGB7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbhKPGBn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:43 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C65C061193;
        Mon, 15 Nov 2021 21:42:52 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id np3so14799836pjb.4;
        Mon, 15 Nov 2021 21:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P7YHBodN7FxxKr28EL14BHBK1Op3LrUSznhVoFpHxSg=;
        b=Vx0LsaymW/BH3nFK3ImCZEkLGDhG8b7cXMGwMdEt/3BsXgLEM/ehd5coQVVkrhleol
         Ct8UKkvePleY70M7373gHj5QBHKrEYpfZqT7eAe5akHV8gKcFC1mj++PSVTBnovN6fBk
         g2PXINM9lCyKHMGmayFQCDl+TTBOZybBIRIce842JDEHJzm1geHN5OMLugY3DqZ87QRJ
         jiroE+JVXtWnLQPFeJKoqEMD75bG298hLt+FfIdW2XNomdZOtMqHczE3P7P/yiuardPI
         e/co+FLqTIkxFcseJ162aKMUdS3qnMEsbZaskutqctnOpuePdqGJf5iBf8zefJQfG7iJ
         CgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P7YHBodN7FxxKr28EL14BHBK1Op3LrUSznhVoFpHxSg=;
        b=0I6dzjeksf0MLdyxnP3xssJiiCMap7jCIQQZZb7GefktydpGrxEwhDyryys3VL8oy2
         9Ma808IFtTOKfKskMckYjybGbxYJshgmmb8R4TfDGOqLU0YneeXcymEDeftdC3nd5YIy
         KIS6FVnzKUkgAzGz40elWAxsGI2rRq8WGcGGaWaBI4txETeE9OfyFxYDEDTCRrCvHoVG
         ifNPHc0abC42uLrh8sNq6XveONgDDqvT43MLYcjOPZOhY9t724D75XkmwlEMYozY3uZ4
         xcTIC5CkWcYIvQFeWSWSEGKIaDpxWsQT4W6OGtc7qFCdblczPV01BivLI78NGf9/jElf
         rFEg==
X-Gm-Message-State: AOAM533WymGRabou/nJmBS0JY4AWWgOYAS6gAlIQtk28jkogz2n/gzay
        /B4bjfRBHPG60CJlnOSwkL6nrw0ain8=
X-Google-Smtp-Source: ABdhPJwHG7ivrchw7+i00w5+bYy9YEmxelyGxTw88RyTufsUwJGM5cxq5mqK1o3nczYuzByK4A2dCA==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr5586200pjb.230.1637041371415;
        Mon, 15 Nov 2021 21:42:51 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id j9sm12439968pgt.54.2021.11.15.21.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:51 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org
Subject: [PATCH bpf-next v1 4/8] epoll: Implement eBPF iterator for registered items
Date:   Tue, 16 Nov 2021 11:12:33 +0530
Message-Id: <20211116054237.100814-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10782; h=from:subject; bh=1NPE/ek3S/8oo41vaRgKFoZuG2Bc9SehhcdLlVfzD04=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6HKYlvIkVLhiUHzQs1cWeiY6nMqQDST3wOv1f cZobjnqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RyqiDEA CZ7s3gkblUatbO0TS+0BeayG91r+qANpUFSI88DULe2yOxz19QhLaV6zXNIk2z0HgmmKZYsAzZvLSg f4j2pBe7xHDMA0d1g9jziLX3zRiEhaLzRPAqFz9JlhVBmmlxOPPYxQMHo0Z8FGnwDy8M73XvSyTHEs rfX9AGGeLe2guIhhilv3GWsSLUP4pa3uzmLmZxslIFrSSnAPgKFcj2pfwdA1mazFtUISyJwuhaubgv tAgqdh7GUSMfcrpmeiX4KYs/2kYOrv80ZpMD1iuGSIsaixAjZpvc230Tjn9qFSdTdO60Ijq9uTXMwf oLvczNrmgS949KfxPFSt4lhZGZp7EOHB+u4XVf/XE4iHQtNQWs+6HAa1bgy60ferszi+izQxdV7qSx VsHCmtzqWKHkQ54aAXZUwEqZTYLqHKDpKgnKy282yDyGzSdhVccfa2T9dlwkwau460tQYoRAiBeuzo kNOCH3/UUA0qZA+wJoxjxMhZTyLxwSEZldhfY0hZqPw++4DpYKa9hMI/SC8tzRDOEgeYW++OuYrJuc r3lKBF+L4Y4Q/6rNSUb5OPP58UeeLoSOAdOtSvOBARmT2rAvTz7AormxdjSctpry1a0YpJgESt7C7m A30AObmfiqIMaMKzUPmUf4yl4lyqmL8Vbe2Jr80Yzvrur0LyzaXGe/ZJt0dg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds eBPF iterator for epoll items (epitems) registered in an
epoll instance. It gives access to the eventpoll ctx, and the registered
epoll item (struct epitem). This allows the iterator to inspect the
registered file and be able to use others iterators to associate it with
a task's fdtable.

The primary usecase this is enabling is expediting existing eventpoll
checkpoint/restore support in the CRIU project. This iterator allows us
to switch from a worst case O(n^2) algorithm to a single O(n) pass over
task and epoll registered descriptors.

We also make sure we're iterating over a live file, one that is not
going away. The case we're concerned about is a file that has its
f_count as zero, but is waiting for iterator bpf_seq_read to release
ep->mtx, so that it can remove its epitem. Since such a file will
disappear once iteration is done, and it is being destructed, we use
get_file_rcu to ensure it is alive when invoking the BPF program.

Getting access to a file that is going to disappear after iteration
is not useful anyway. This does have a performance overhead however
(since file reference will be raised and dropped for each file).

The rcu_read_lock around get_file_rcu isn't strictly required for
lifetime management since fput path is serialized on ep->mtx to call
ep_remove, hence the epi->ffd.file pointer remains stable during our
seq_start/seq_stop bracketing.

To be able to continue back from the position we were iterating, we
store the epi->ffi.fd and use ep_find_tfd to find the target file again.
It would be more appropriate to use both struct file pointer and fd
number to find the last file, but see below for why that cannot be done.

Taking reference to struct file and walking RB-Tree to find it again
will lead to reference cycle issue if the iterator after partial read
takes reference to socket which later is used in creating a descriptor
cycle using SCM_RIGHTS. An example that was encountered when working on
this is mentioned below.

  Let there be Unix sockets SK1, SK2, epoll fd EP, and epoll iterator
  ITER.
  Let SK1 be registered in EP, then on a partial read it is possible
  that ITER returns from read and takes reference to SK1 to be able to
  find it later in RB-Tree and continue the iteration.  If SK1 sends
  ITER over to SK2 using SCM_RIGHTS, and SK2 sends SK2 over to SK1 using
  SCM_RIGHTS, and both fds are not consumed on the corresponding receive
  ends, a cycle is created.  When all of SK1, SK2, EP, and ITER are
  closed, SK1's receive queue holds reference to SK2, and SK2's receive
  queue holds reference to ITER, which holds a reference to SK1.
  All file descriptors except EP leak.

To resolve it, we would need to hook into the Unix Socket GC mechanism,
but the alternative of using ep_find_tfd is much more simpler. The
finding of the last position in face of concurrent modification of the
epoll set is at best an approximation anyway. For the case of CRIU, the
epoll set remains stable.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/eventpoll.c                 | 196 ++++++++++++++++++++++++++++++++-
 include/linux/bpf.h            |   5 +-
 include/uapi/linux/bpf.h       |   3 +
 tools/include/uapi/linux/bpf.h |   3 +
 4 files changed, 205 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 06f4c5ae1451..aa21628b6307 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -37,6 +37,7 @@
 #include <linux/seq_file.h>
 #include <linux/compat.h>
 #include <linux/rculist.h>
+#include <linux/btf_ids.h>
 #include <net/busy_poll.h>
 
 /*
@@ -985,7 +986,6 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 	return epir;
 }
 
-#ifdef CONFIG_KCMP
 static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
 {
 	struct rb_node *rbp;
@@ -1005,6 +1005,7 @@ static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long t
 	return NULL;
 }
 
+#ifdef CONFIG_KCMP
 struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd,
 				     unsigned long toff)
 {
@@ -2385,3 +2386,196 @@ static int __init eventpoll_init(void)
 	return 0;
 }
 fs_initcall(eventpoll_init);
+
+#ifdef CONFIG_BPF_SYSCALL
+
+BTF_ID_LIST(btf_epoll_ids)
+BTF_ID(struct, eventpoll)
+BTF_ID(struct, epitem)
+
+struct bpf_epoll_iter_seq_info {
+	struct eventpoll *ep;
+	struct rb_node *rbp;
+	int tfd;
+};
+
+static int bpf_epoll_init_seq(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	struct bpf_epoll_iter_seq_info *info = priv_data;
+
+	info->ep = aux->ep->private_data;
+	info->tfd = -1;
+	return 0;
+}
+
+static int bpf_epoll_iter_attach(struct bpf_prog *prog,
+				 union bpf_iter_link_info *linfo,
+				 struct bpf_iter_aux_info *aux)
+{
+	struct file *file;
+	int ret;
+
+	file = fget(linfo->epoll.epoll_fd);
+	if (!file)
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (unlikely(!is_file_epoll(file)))
+		goto out_fput;
+
+	aux->ep = file;
+	return 0;
+out_fput:
+	fput(file);
+	return ret;
+}
+
+static void bpf_epoll_iter_detach(struct bpf_iter_aux_info *aux)
+{
+	fput(aux->ep);
+}
+
+struct bpf_iter__epoll {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct eventpoll *, ep);
+	__bpf_md_ptr(struct epitem *, epi);
+};
+
+static void *bpf_epoll_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_epoll_iter_seq_info *info = seq->private;
+	struct epitem *epi;
+
+	mutex_lock(&info->ep->mtx);
+	/* already iterated? */
+	if (info->tfd == -2)
+		return NULL;
+	/* partially iterated */
+	if (info->tfd >= 0) {
+		epi = ep_find_tfd(info->ep, info->tfd, 0);
+		if (!epi)
+			return NULL;
+		info->rbp = &epi->rbn;
+		return epi;
+	}
+	WARN_ON(info->tfd != -1);
+	/* first iteration */
+	info->rbp = rb_first_cached(&info->ep->rbr);
+	if (!info->rbp)
+		return NULL;
+	if (*pos == 0)
+		++*pos;
+	return rb_entry(info->rbp, struct epitem, rbn);
+}
+
+static void *bpf_epoll_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpf_epoll_iter_seq_info *info = seq->private;
+
+	++*pos;
+	info->rbp = rb_next(info->rbp);
+	return info->rbp ? rb_entry(info->rbp, struct epitem, rbn) : NULL;
+}
+
+DEFINE_BPF_ITER_FUNC(epoll, struct bpf_iter_meta *meta, struct eventpoll *ep,
+		     struct epitem *epi)
+
+static int __bpf_epoll_seq_show(struct seq_file *seq, void *v, bool in_stop)
+{
+	struct bpf_epoll_iter_seq_info *info = seq->private;
+	struct bpf_iter__epoll ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret;
+
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, in_stop);
+	if (!prog)
+		return 0;
+
+	ctx.meta = &meta;
+	ctx.ep = info->ep;
+	ctx.epi = v;
+	if (ctx.epi) {
+		/* The file we are going to pass to prog may already have its f_count as
+		 * 0, hence before invoking the prog, we always try to get the reference
+		 * if it isn't zero, failing which we skip the file. This is usually the
+		 * case for files that are closed before calling EPOLL_CTL_DEL for them,
+		 * which would wait for us to release ep->mtx before doing ep_remove.
+		 */
+		rcu_read_lock();
+		ret = get_file_rcu(ctx.epi->ffd.file);
+		rcu_read_unlock();
+		if (!ret)
+			return 0;
+	}
+	ret = bpf_iter_run_prog(prog, &ctx);
+	/* fput queues work asynchronously, so in our case, either task_work
+	 * for non-exiting task, and otherwise delayed_fput, so holding
+	 * ep->mtx and calling fput (which will take the same lock) in
+	 * this context will not deadlock us, in case f_count is 1 at this
+	 * point.
+	 */
+	if (ctx.epi)
+		fput(ctx.epi->ffd.file);
+	return ret;
+}
+
+static int bpf_epoll_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_epoll_seq_show(seq, v, false);
+}
+
+static void bpf_epoll_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_epoll_iter_seq_info *info = seq->private;
+	struct epitem *epi;
+
+	if (!v) {
+		__bpf_epoll_seq_show(seq, v, true);
+		/* done iterating */
+		info->tfd = -2;
+	} else {
+		epi = rb_entry(info->rbp, struct epitem, rbn);
+		info->tfd = epi->ffd.fd;
+	}
+	mutex_unlock(&info->ep->mtx);
+}
+
+static const struct seq_operations bpf_epoll_seq_ops = {
+	.start = bpf_epoll_seq_start,
+	.next  = bpf_epoll_seq_next,
+	.stop  = bpf_epoll_seq_stop,
+	.show  = bpf_epoll_seq_show,
+};
+
+static const struct bpf_iter_seq_info bpf_epoll_seq_info = {
+	.seq_ops          = &bpf_epoll_seq_ops,
+	.init_seq_private = bpf_epoll_init_seq,
+	.seq_priv_size    = sizeof(struct bpf_epoll_iter_seq_info),
+};
+
+static struct bpf_iter_reg epoll_reg_info = {
+	.target            = "epoll",
+	.feature           = BPF_ITER_RESCHED,
+	.attach_target     = bpf_epoll_iter_attach,
+	.detach_target     = bpf_epoll_iter_detach,
+	.ctx_arg_info_size = 2,
+	.ctx_arg_info = {
+		{ offsetof(struct bpf_iter__epoll, ep),
+		  PTR_TO_BTF_ID },
+		{ offsetof(struct bpf_iter__epoll, epi),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info	   = &bpf_epoll_seq_info,
+};
+
+static int __init epoll_iter_init(void)
+{
+	epoll_reg_info.ctx_arg_info[0].btf_id = btf_epoll_ids[0];
+	epoll_reg_info.ctx_arg_info[1].btf_id = btf_epoll_ids[1];
+	return bpf_iter_reg_target(&epoll_reg_info);
+}
+late_initcall(epoll_iter_init);
+
+#endif
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fe7b499da781..eb1c9acdc40b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1512,7 +1512,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 struct io_ring_ctx;
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
-	struct io_ring_ctx *ctx;
+	union {
+		struct io_ring_ctx *ctx;
+		struct file *ep;
+	};
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b70e9da3d722..64e18c1dcfca 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -94,6 +94,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32   io_uring_fd;
 	} io_uring;
+	struct {
+		__u32   epoll_fd;
+	} epoll;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b70e9da3d722..64e18c1dcfca 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -94,6 +94,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32   io_uring_fd;
 	} io_uring;
+	struct {
+		__u32   epoll_fd;
+	} epoll;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
-- 
2.33.1

