Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1552452A2E
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 06:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhKPGBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbhKPGBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:42 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B94C061230;
        Mon, 15 Nov 2021 21:42:43 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h24so14827845pjq.2;
        Mon, 15 Nov 2021 21:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7/48XSbc+QYyvhIocYNNlFlwQkZZg5dYk++cl9LFjI=;
        b=kxTKhY3S7wY5ISxCXPhcu0fx14Ls+CFmG7WuijhxsRkI09c/aYHd2L+eSeQSg80ds6
         X76pTO+ChPlH3uBCLlmEkOfpQGWgjOklrPsmiAJUkLDt97XMr+VFJrer+fRNalsdn30C
         BnY4b5+XfXh1e/ZjBG8LwmRyMW5n8TRqzh49D4ELFGyFJCKnwIFBg0f50D/X8gSyvCo7
         bkr1VPK85dtNq2bAta1uilm9l6oFJou1+J/X3/MPtlIa7GAeI+TZyq9TqQzndNEiL6ec
         lE1msupB0s0ytp3LrSKvA7DSCU/xHIAJKw/I8zx/VLKVqoo4d0YWNaamy2CeYtkHhXOV
         Lz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7/48XSbc+QYyvhIocYNNlFlwQkZZg5dYk++cl9LFjI=;
        b=gbwY2rQcZl+AjrZAlgWHTRVvrfO/95+WBYleLqGLpja61oT1sZ6zaoct3w/Wbw3EZx
         kOWt2BlSkgxuW51o1qiqi+ijze0jrfz7YGdUqsL0bXNnB7UaF6u/4ZZFmFpHbZaJWvaQ
         FIS1cSWA7R4BIR7kUDUGZu0a7KtM2oh7o1dW282HzKj6UccQ5bbzrnzHe7R82rN0PADq
         og8E5hZrD9DOQzOPcL6NeSG7yA+e/vRweMuz8BbW3kbeufYDJ3X7b9kPby71maAEd25T
         2gZdeK8v7y4E6/tXAwsa57Nd/OxxcNDtwesAKbwehbInxtE1C7cmVUuuslHd9jh2UX14
         Si8g==
X-Gm-Message-State: AOAM530wyt4iF/6T+DiI+suayEXcnNT7TEwAZjz2sTkpU+OI2wbD25Em
        99yMPkoNlZbZv3UHXkVGZ+Cvka7SA04=
X-Google-Smtp-Source: ABdhPJyyejB2Wot1eo6b34zzmSb+bIPf0Lc5QZDOj5KqnfjJJA64rO4YJDbwhs69c5FZpRIfQEUFfg==
X-Received: by 2002:a17:902:a510:b0:143:7fd1:b18a with SMTP id s16-20020a170902a51000b001437fd1b18amr42432776plq.2.1637041362748;
        Mon, 15 Nov 2021 21:42:42 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id k20sm18029500pfc.83.2021.11.15.21.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:42 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for registered buffers
Date:   Tue, 16 Nov 2021 11:12:30 +0530
Message-Id: <20211116054237.100814-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8956; h=from:subject; bh=7cwbGmPSBXXPemkSOeSEyifdpu0D8KtxLknvhUQNWO0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6sKksl/3ag5OKTN8ybRlXgYgNJ7rKWSW7Jcuy PE0a0fCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RyoCRD/ 938mDGdY4hNEHcWDHx34dFo4g6s/HgP29nssd+R7u9IAorl8S3kPwFQeC0m6ZKt/nucLCRKoFco0Of ewa56i0uI+mVndzHKbh5/uVaw2qmOc0JeI6af2nZIc0t+6iPqnSTuxaQrynVTR3weH9gLEcNCPfyy/ vFjytzFWTdRhRwhA7UhGD2LKWpJCgx1vQmqqmeCZc8c/n28x42DxstkWhfqm5zGtPKoBWY5YTwEbkP PKpogHmXhhi5ZtfM8gklHOWC2sK3pQEXBIsj5YW0iXNlmWA/tt8MFkHnpmh1ozo04fLsQoiOMHOz1C 4ewIdOa2JBKN3iLeQPtvAX7FZumFmpVf6LM3rYr2002ad9VjRJbQ47Se0l2DESIyzfb7w1dojG8dNS HBs2UPUIqTbGx5NdJSWP2/AxV+fzcPNgeEYa9iKLgexVHrMh4X8tunWgRWMVNe1wNcRzOl3QYZmAeY edRUeUicY0vjiU8BOu6QTDuEeejoOY4olgNRWXII5ceqGSgPE6cF8ZaL5+eU1iCU6D3o/NTyKfMOlL Ug/8510bbCc/CDYzdvdAxQfKHz2lsv2q2DsEq5v3tGG9YVVorLZJAHuPZpj4VsdLblwQKHiU3Sr5hM alhmNM1HRGqbZ69/IkkrfZMg3RGasaTLfSrVgJA8jo5O0yszwEXDCGLFeJiQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change adds eBPF iterator for buffers registered in io_uring ctx.
It gives access to the ctx, the index of the registered buffer, and a
pointer to the io_uring_ubuf itself. This allows the iterator to save
info related to buffers added to an io_uring instance, that isn't easy
to export using the fdinfo interface (like exact struct page composing
the registered buffer).

The primary usecase this is enabling is checkpoint/restore support.

Note that we need to use mutex_trylock when the file is read from, in
seq_start functions, as the order of lock taken is opposite of what it
would be when io_uring operation reads the same file.  We take
seq_file->lock, then ctx->uring_lock, while io_uring would first take
ctx->uring_lock and then seq_file->lock for the same ctx.

This can lead to a deadlock scenario described below:

      CPU 0				CPU 1

      vfs_read
      mutex_lock(&seq_file->lock)	io_read
					mutex_lock(&ctx->uring_lock)
      mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
					mutex_lock(&seq_file->lock)

The trylock also protects the case where io_uring tries to read from
iterator attached to itself (same ctx), where the order of locks would
be:
 io_uring_enter
  mutex_lock(&ctx->uring_lock) <-----------.
  io_read				    \
   seq_read				     \
    mutex_lock(&seq_file->lock)		     /
    mutex_lock(&ctx->uring_lock) # deadlock-`

In both these cases (recursive read and contended uring_lock), -EDEADLK
is returned to userspace.

In the future, this iterator will be extended to directly support
iteration of bvec Flexible Array Member, so that when there is no
corresponding VMA that maps to the registered buffer (e.g. if VMA is
destroyed after pinning pages), we are able to reconstruct the
registration on restore by dumping the page contents and then replaying
them into a temporary mapping used for registration later. All this is
out of scope for the current series however, but builds upon this
iterator.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/io_uring.c                  | 179 +++++++++++++++++++++++++++++++++
 include/linux/bpf.h            |   2 +
 include/uapi/linux/bpf.h       |   3 +
 tools/include/uapi/linux/bpf.h |   3 +
 4 files changed, 187 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b07196b4511c..46a110989155 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -81,6 +81,7 @@
 #include <linux/tracehook.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/btf_ids.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -11125,3 +11126,181 @@ static int __init io_uring_init(void)
 	return 0;
 };
 __initcall(io_uring_init);
+
+#ifdef CONFIG_BPF_SYSCALL
+
+BTF_ID_LIST(btf_io_uring_ids)
+BTF_ID(struct, io_ring_ctx)
+BTF_ID(struct, io_mapped_ubuf)
+
+struct bpf_io_uring_seq_info {
+	struct io_ring_ctx *ctx;
+	unsigned long index;
+};
+
+static int bpf_io_uring_init_seq(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	struct bpf_io_uring_seq_info *info = priv_data;
+	struct io_ring_ctx *ctx = aux->ctx;
+
+	info->ctx = ctx;
+	return 0;
+}
+
+static int bpf_io_uring_iter_attach(struct bpf_prog *prog,
+				    union bpf_iter_link_info *linfo,
+				    struct bpf_iter_aux_info *aux)
+{
+	struct io_ring_ctx *ctx;
+	struct fd f;
+	int ret;
+
+	f = fdget(linfo->io_uring.io_uring_fd);
+	if (unlikely(!f.file))
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (unlikely(f.file->f_op != &io_uring_fops))
+		goto out_fput;
+
+	ret = -ENXIO;
+	ctx = f.file->private_data;
+	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
+		goto out_fput;
+
+	ret = 0;
+	aux->ctx = ctx;
+
+out_fput:
+	fdput(f);
+	return ret;
+}
+
+static void bpf_io_uring_iter_detach(struct bpf_iter_aux_info *aux)
+{
+	percpu_ref_put(&aux->ctx->refs);
+}
+
+/* io_uring iterator for registered buffers */
+
+struct bpf_iter__io_uring_buf {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct io_ring_ctx *, ctx);
+	__bpf_md_ptr(struct io_mapped_ubuf *, ubuf);
+	unsigned long index;
+};
+
+static void *__bpf_io_uring_buf_seq_get_next(struct bpf_io_uring_seq_info *info)
+{
+	if (info->index < info->ctx->nr_user_bufs)
+		return info->ctx->user_bufs[info->index++];
+	return NULL;
+}
+
+static void *bpf_io_uring_buf_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+	struct io_mapped_ubuf *ubuf;
+
+	/* Indicate to userspace that the uring lock is contended */
+	if (!mutex_trylock(&info->ctx->uring_lock))
+		return ERR_PTR(-EDEADLK);
+
+	ubuf = __bpf_io_uring_buf_seq_get_next(info);
+	if (!ubuf)
+		return NULL;
+
+	if (*pos == 0)
+		++*pos;
+	return ubuf;
+}
+
+static void *bpf_io_uring_buf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+
+	++*pos;
+	return __bpf_io_uring_buf_seq_get_next(info);
+}
+
+DEFINE_BPF_ITER_FUNC(io_uring_buf, struct bpf_iter_meta *meta,
+		     struct io_ring_ctx *ctx, struct io_mapped_ubuf *ubuf,
+		     unsigned long index)
+
+static int __bpf_io_uring_buf_seq_show(struct seq_file *seq, void *v, bool in_stop)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+	struct bpf_iter__io_uring_buf ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, in_stop);
+	if (!prog)
+		return 0;
+
+	ctx.meta = &meta;
+	ctx.ctx = info->ctx;
+	ctx.ubuf = v;
+	ctx.index = info->index ? info->index - !in_stop : 0;
+
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_io_uring_buf_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_io_uring_buf_seq_show(seq, v, false);
+}
+
+static void bpf_io_uring_buf_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+
+	/* If IS_ERR(v) is true, then ctx->uring_lock wasn't taken */
+	if (IS_ERR(v))
+		return;
+	if (!v)
+		__bpf_io_uring_buf_seq_show(seq, v, true);
+	else if (info->index) /* restart from index */
+		info->index--;
+	mutex_unlock(&info->ctx->uring_lock);
+}
+
+static const struct seq_operations bpf_io_uring_buf_seq_ops = {
+	.start = bpf_io_uring_buf_seq_start,
+	.next  = bpf_io_uring_buf_seq_next,
+	.stop  = bpf_io_uring_buf_seq_stop,
+	.show  = bpf_io_uring_buf_seq_show,
+};
+
+static const struct bpf_iter_seq_info bpf_io_uring_buf_seq_info = {
+	.seq_ops          = &bpf_io_uring_buf_seq_ops,
+	.init_seq_private = bpf_io_uring_init_seq,
+	.fini_seq_private = NULL,
+	.seq_priv_size    = sizeof(struct bpf_io_uring_seq_info),
+};
+
+static struct bpf_iter_reg io_uring_buf_reg_info = {
+	.target            = "io_uring_buf",
+	.feature	   = BPF_ITER_RESCHED,
+	.attach_target     = bpf_io_uring_iter_attach,
+	.detach_target     = bpf_io_uring_iter_detach,
+	.ctx_arg_info_size = 2,
+	.ctx_arg_info = {
+		{ offsetof(struct bpf_iter__io_uring_buf, ctx),
+		  PTR_TO_BTF_ID },
+		{ offsetof(struct bpf_iter__io_uring_buf, ubuf),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info	   = &bpf_io_uring_buf_seq_info,
+};
+
+static int __init io_uring_iter_init(void)
+{
+	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
+	io_uring_buf_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[1];
+	return bpf_iter_reg_target(&io_uring_buf_reg_info);
+}
+late_initcall(io_uring_iter_init);
+
+#endif
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 56098c866704..ddb9d4520a3f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1509,8 +1509,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
 	extern int bpf_iter_ ## target(args);			\
 	int __init bpf_iter_ ## target(args) { return 0; }
 
+struct io_ring_ctx;
 struct bpf_iter_aux_info {
 	struct bpf_map *map;
+	struct io_ring_ctx *ctx;
 };
 
 typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6297eafdc40f..3323defa99a1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u32   io_uring_fd;
+	} io_uring;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6297eafdc40f..3323defa99a1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -91,6 +91,9 @@ union bpf_iter_link_info {
 	struct {
 		__u32	map_fd;
 	} map;
+	struct {
+		__u32   io_uring_fd;
+	} io_uring;
 };
 
 /* BPF syscall commands, see bpf(2) man-page for more details. */
-- 
2.33.1

