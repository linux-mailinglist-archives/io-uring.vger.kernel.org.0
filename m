Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF74B4645E2
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346604AbhLAE1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346563AbhLAE1H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:07 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8322C061574;
        Tue, 30 Nov 2021 20:23:46 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so231979pjj.0;
        Tue, 30 Nov 2021 20:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=47uoyKSt85EOPYyE7dejHJdAFCjTvLI61KjOly3mw+k=;
        b=dMm1GreMa/ClrIZdMATDvp15J0mmRyTPEU1Uttr48eLHVmkKoGUbdF5XS+Th7V+4MX
         IJMlfaXulxz9lyFZfVxcoO06HKmTB4NlUKbFkX1B/LzfDwTPRXUgfrIExGYPwyVryAG2
         zI3DI6/Q2cPAflOwZcycGP5O18mOSfh/vx3w/Mj2TR89Al4U7Hy639BbxQ9ezfh2xwZN
         +4xDg1t+Yi2OQnUm9FLlEAX5LrReUUR7wgqGVm+fWVNMLEQIxQi/1DRwTHQOqJt576FT
         OAJo3HGQO+13aHt0uJL5XIyV8Z9CZhc49VrWJtfp9MaSMrtNt/oeDx2ipGPe2WwH4C4A
         yIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=47uoyKSt85EOPYyE7dejHJdAFCjTvLI61KjOly3mw+k=;
        b=N7+lzULBXkanO60fJiZ1uWSBBmiYmqTosS6b+byqiYuC7nQ24IulOWRF0vGQ7fRc0q
         QrytgRl50WKUQwsg7nrFN6dw8jiOhnGsKWaIKgkqPiqpe7yrwwVTdk1nJQB31owgNNoW
         tqruSroYbJVH+ubScTu7MeAwTxuX3cp/sBcwyp9B+GtHL7uQJTGsAlcoTM73LsImWp3r
         6GTbs3TqztVHbYSHFarTVuZ13dVwofvB4fa1rC1mzHOqWDRxotm81wRDIJBWyXoUzmwP
         /oylEZ9l8+/hgTJMThJdpI5X1GVIUeQn+YOYThreeRvZjzDnAcBTH+dyRnVZBARKEzpg
         Jbcg==
X-Gm-Message-State: AOAM531wLfDHVl932Ms8XLNugNuZgIw3xSPNjbutZDlUoBR343w0Ibwz
        b1qMAVzfjVRaiC0VWhour/LdKGiYfd0=
X-Google-Smtp-Source: ABdhPJwEYJACqhXydk0uljG/lDqXq8M+0piSYY1vGPpAsSQnFvs4/BUVn0+eSnPy31RJbfy+Tn3mfA==
X-Received: by 2002:a17:90b:19c8:: with SMTP id nm8mr4411430pjb.163.1638332626160;
        Tue, 30 Nov 2021 20:23:46 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id y25sm16153653pgk.47.2021.11.30.20.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:23:45 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v3 03/10] io_uring: Implement eBPF iterator for registered files
Date:   Wed,  1 Dec 2021 09:53:26 +0530
Message-Id: <20211201042333.2035153-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8089; h=from:subject; bh=SV7KciF1JI0jgl3quwQpGuXagSiM5czyomUPJ39eYiw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYxOddRV/bHejsaQE8htmP9T0ToBH9G+bC7F93j QuMUQc2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MQAKCRBM4MiGSL8RylPHEA CNMVcmCWha2s2S3mHMbKZ7O4i4jDiBJPByHBABe8D1OiPe3l4L/2MTYmHAOz5aqLn+RRW7gQPCR6qU bbUG7nAHt5yk4L564a9SHUj9PBV4DXghg5zUvegqjQtcPbxjmiOaWp8cX/PJJqF+8NSgcmuNQTl5Gr fzPbh7zlo2WXC97pBxQoBAuuwOig+6vhUstrV121b56wpeM8qc8HOWX3D3ZXoQNLd2e36WhSCt1O4k 0hhcI1r5mfw3kcRDUeK/wxuPRUt+30t+TBPkAYF1qhKSYeC258yRoQuOcP8+F5puY4YJbP8omS5ySR huqbtdoH+kkEWrxWFZQ8Jh8p0fHCcXrsHwWyM37ZG2AKL7Lq4YemJuYyf9yMxHoT3zZBRikkw/RqEO 73YyK/ahlDu+yynRocqPvkCAAbdOeFMnEPPhA1vFXL6QxwqH4FRkTvzCh9R+NXVYuKkRww6m0c3a0Z PZezl905D6PZUpAicNOQ2UcfJxeHkCviV/YYxzoUrlzNnRe9ff87/R6BtNBjHBfotONfhy4Igk72t9 5Wy5sQZ0/gtsjPRJGMm2LQ0DT7YWiut51/gWMKA7eS7iYEnIuQ/tEDs0sYkVp8YMrTZ2KIoU50Ylmq eg621i8pmIiGO1z06g942tSK/Ulm1imWuvWWSXu5hA0DMLosoOM88V053Iiw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change adds eBPF iterator for buffers registered in io_uring ctx.
It gives access to the ctx, the index of the registered buffer, and a
pointer to the struct file itself. This allows the iterator to save
info related to the file added to an io_uring instance, that isn't easy
to export using the fdinfo interface (like being able to match
registered files to a task's file set). Getting access to underlying
struct file allows deduplication and efficient pairing with task file
set (obtained using task_file iterator).

The primary usecase this is enabling is checkpoint/restore support.

Note that we need to use mutex_trylock when the file is read from, in
seq_start functions, as the order of lock taken is opposite of what it
would be when io_uring operation reads the same file.  We take
seq_file->lock, then ctx->uring_lock, while io_uring would first take
ctx->uring_lock and then seq_file->lock for the same ctx.

This can lead to a deadlock scenario described below:

The sequence on CPU 0 is for normal read(2) on iterator.  For CPU 1, it
is an io_uring instance trying to do same on iterator attached to
itself.

So CPU 0 does

sys_read
vfs_read
 bpf_seq_read
 mutex_lock(&seq_file->lock)    # A
  io_uring_buf_seq_start
  mutex_lock(&ctx->uring_lock)  # B

and CPU 1 does

io_uring_enter
mutex_lock(&ctx->uring_lock)    # B
 io_read
  bpf_seq_read
  mutex_lock(&seq_file->lock)   # A
  ...

Since the order of locks is opposite, it can deadlock. So we switch the
mutex_lock in io_uring_buf_seq_start to trylock, so it can return an
error for this case, then it will release seq_file->lock and CPU 1 will
make progress.

The trylock also protects the case where io_uring tries to read from
iterator attached to itself (same ctx), where the order of locks would
be:
 io_uring_enter
 mutex_lock(&ctx->uring_lock) <------------.
  io_read				    \
   seq_read				     \
    mutex_lock(&seq_file->lock)		     /
    mutex_lock(&ctx->uring_lock) # deadlock-`

In both these cases (recursive read and contended uring_lock), -EDEADLK
is returned to userspace.

With the advent of descriptorless files supported by io_uring, this
iterator provides the required visibility and introspection of io_uring
instance for the purposes of dumping and restoring it.

In the future, this iterator will be extended to support direct
inspection of a lot of file state (currently descriptorless files
are obtained using openat2 and socket) to dump file state for these
hidden files. Later, we can explore filling in the gaps for dumping
file state for more file types (those not hidden in io_uring ctx).
All this is out of scope for the current series however, but builds
upon this iterator.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/io_uring.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 02e628448ebd..28348fce81dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11132,6 +11132,7 @@ __initcall(io_uring_init);
 BTF_ID_LIST(btf_io_uring_ids)
 BTF_ID(struct, io_ring_ctx)
 BTF_ID(struct, io_mapped_ubuf)
+BTF_ID(struct, file)
 
 struct bpf_io_uring_seq_info {
 	struct io_ring_ctx *ctx;
@@ -11319,11 +11320,152 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
 	.seq_info	   = &bpf_io_uring_buf_seq_info,
 };
 
+/* io_uring iterator for registered files */
+
+struct bpf_iter__io_uring_file {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct io_ring_ctx *, ctx);
+	__bpf_md_ptr(struct file *, file);
+	u64 index;
+};
+
+static void *__bpf_io_uring_file_seq_get_next(struct bpf_io_uring_seq_info *info)
+{
+	struct file *file = NULL;
+
+	if (info->index < info->ctx->nr_user_files) {
+		/* file set can be sparse */
+		file = io_file_from_index(info->ctx, info->index++);
+		/* use info as a distinct pointer to distinguish between empty
+		 * slot and valid file, since we cannot return NULL for this
+		 * case if we want iter prog to still be invoked with file ==
+		 * NULL.
+		 */
+		if (!file)
+			return info;
+	}
+
+	return file;
+}
+
+static void *bpf_io_uring_file_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+	struct file *file;
+
+	/* Indicate to userspace that the uring lock is contended */
+	if (!mutex_trylock(&info->ctx->uring_lock))
+		return ERR_PTR(-EDEADLK);
+
+	file = __bpf_io_uring_file_seq_get_next(info);
+	if (!file)
+		return NULL;
+
+	if (*pos == 0)
+		++*pos;
+	return file;
+}
+
+static void *bpf_io_uring_file_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+
+	++*pos;
+	return __bpf_io_uring_file_seq_get_next(info);
+}
+
+DEFINE_BPF_ITER_FUNC(io_uring_file, struct bpf_iter_meta *meta,
+		     struct io_ring_ctx *ctx, struct file *file,
+		     u64 index)
+
+static int __bpf_io_uring_file_seq_show(struct seq_file *seq, void *v, bool in_stop)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+	struct bpf_iter__io_uring_file ctx;
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
+	/* when we encounter empty slot, v will point to info */
+	ctx.file = v == info ? NULL : v;
+	ctx.index = info->index ? info->index - !in_stop : 0;
+
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_io_uring_file_seq_show(struct seq_file *seq, void *v)
+{
+	return __bpf_io_uring_file_seq_show(seq, v, false);
+}
+
+static void bpf_io_uring_file_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_io_uring_seq_info *info = seq->private;
+
+	/* If IS_ERR(v) is true, then ctx->uring_lock wasn't taken */
+	if (IS_ERR(v))
+		return;
+	if (!v)
+		__bpf_io_uring_file_seq_show(seq, v, true);
+	else if (info->index) /* restart from index */
+		info->index--;
+	mutex_unlock(&info->ctx->uring_lock);
+}
+
+static const struct seq_operations bpf_io_uring_file_seq_ops = {
+	.start = bpf_io_uring_file_seq_start,
+	.next  = bpf_io_uring_file_seq_next,
+	.stop  = bpf_io_uring_file_seq_stop,
+	.show  = bpf_io_uring_file_seq_show,
+};
+
+static const struct bpf_iter_seq_info bpf_io_uring_file_seq_info = {
+	.seq_ops          = &bpf_io_uring_file_seq_ops,
+	.init_seq_private = bpf_io_uring_init_seq,
+	.fini_seq_private = NULL,
+	.seq_priv_size    = sizeof(struct bpf_io_uring_seq_info),
+};
+
+static struct bpf_iter_reg io_uring_file_reg_info = {
+	.target            = "io_uring_file",
+	.feature           = BPF_ITER_RESCHED,
+	.attach_target     = bpf_io_uring_iter_attach,
+	.detach_target     = bpf_io_uring_iter_detach,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	   = bpf_io_uring_iter_show_fdinfo,
+#endif
+	.fill_link_info	   = bpf_io_uring_iter_fill_link_info,
+	.ctx_arg_info_size = 2,
+	.ctx_arg_info = {
+		{ offsetof(struct bpf_iter__io_uring_file, ctx),
+		  PTR_TO_BTF_ID },
+		{ offsetof(struct bpf_iter__io_uring_file, file),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info	   = &bpf_io_uring_file_seq_info,
+};
+
 static int __init io_uring_iter_init(void)
 {
+	int ret;
+
 	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
 	io_uring_buf_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[1];
-	return bpf_iter_reg_target(&io_uring_buf_reg_info);
+	io_uring_file_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
+	io_uring_file_reg_info.ctx_arg_info[1].btf_id = btf_io_uring_ids[2];
+	ret = bpf_iter_reg_target(&io_uring_buf_reg_info);
+	if (ret)
+		return ret;
+	ret = bpf_iter_reg_target(&io_uring_file_reg_info);
+	if (ret)
+		bpf_iter_unreg_target(&io_uring_buf_reg_info);
+	return ret;
 }
 late_initcall(io_uring_iter_init);
 
-- 
2.34.1

