Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91588452A30
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 06:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhKPGBw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240118AbhKPGBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:42 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BBEC0611FE;
        Mon, 15 Nov 2021 21:42:49 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id y7so16552769plp.0;
        Mon, 15 Nov 2021 21:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9m5mY4Ir11w/zrxUgoXRmOQA6YWYJV+7fBqTFmvYDJ8=;
        b=Gk52qAmukeILt+Z85X6dzczGbu79c1p3NieBJNOO34A91qDODEMW0Mr/y3WPMl2Uw7
         kS2uCDzj8GXhqDSALm9w523gGn0kaVUhc6YgyMKZSgeYA+4caUHA4F6Wjv4eYw9PyYYs
         E3qEahuq5GmUTSBFLvygBRFvZxujKgsDlAsu7W00AFIcayKI6BFRvECIbY9MedCUJlrX
         NpDcPblOJK3KghUyz4OepUVvaKAmu26DgUJ45ZX+/huW4tebQETXLzPIBhBgqSs/+CPF
         G3j9lMGevalo8uIdhwu2/tCM+My+bpKIZhr/Ny9x0HVWIU3dPYRYntw41pkke3OHFQvT
         Txxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9m5mY4Ir11w/zrxUgoXRmOQA6YWYJV+7fBqTFmvYDJ8=;
        b=y3xX2EOqRGDp5D//DXX1GShhMhzD+tQOtztVAcNdBSVpXk3akTTBQzwhJsdvr7Z2Jv
         tuMqaVpjc/agqiNO6qOufKDVb9ZlDiYwGgItJfGX52vJOMoeMjCBxJKa8mW68zGCbKut
         6sFLtIOI5mmAaXoXLSv70TXC5yamOT0UQrWLIUhlMJFJLcgXGqv1UlH9S9LlNrPjtniO
         WN233n8Ok5141fGzq4fkZQCA29XMWUEa9ayqQXI3hrHUk6xZT8F2VMPSXBjSTSBCzsuX
         BEc0IIegoDPXNAKlnkvei4DBhpKR69HGD3NIECGr5X9TfrJDau6tNCKDOxQ26GXwdITY
         cv6w==
X-Gm-Message-State: AOAM533Ao1EvB+AqBoF0pdLskjyVON5WI+IgJgg2G2DdhkBaLOPo1mhf
        O1MGSz7QQLhcmc+uxp8PvcDKExIeDl8=
X-Google-Smtp-Source: ABdhPJyAHF2SFmea7g28GZKoITtfRE8lZMMxjXe5h83cj6X7/sl/AnJIQaH7JdjBxqwNJ1Zzgx70Qw==
X-Received: by 2002:a17:90a:5917:: with SMTP id k23mr72424906pji.111.1637041368569;
        Mon, 15 Nov 2021 21:42:48 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id l28sm14027251pgu.45.2021.11.15.21.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:48 -0800 (PST)
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
Subject: [PATCH bpf-next v1 3/8] io_uring: Implement eBPF iterator for registered files
Date:   Tue, 16 Nov 2021 11:12:32 +0530
Message-Id: <20211116054237.100814-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7590; h=from:subject; bh=4UYxWbGiq/sKKUnwuIEWRtr0AZqHxKqyXPv77YH/sHg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6lWQYf/gzn1knBEAdQjsAn3cbdKR+Up62zDhc W4k4mUuJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RytrpEA Cauy4Jmn2ObLRVsjUaSh0Iq1nJQpFOz43qV8XL0spPojOttz/VC0LwkE8nOlBAIbWpTTZfODq22tM7 /vVBSSsAVh69WB/gKECy94TLOzW9iOdPhc9PWDar7tgcDHRc1rdRBgADkh9c/6Ljf5lhfEX9KskJIH 7eQbFOkQHHtZ1Drv/YIXtLxqBH24xU0xvzjPrd3rlwkOr18V7coPfSyebSpFPs2EMpPjR/LsixWRJU IzS1IHF1dgxIYqXlB6qdvgSIndO84D84PYCCMWrgG3mKTUEAHDwbEWUmjvv2LjwNsxa1wPYo4g2I0+ /vS6+noI1aCcyOUyD06pfvoVEFSa5isUb5tG4+cxSoqkj4nv03+MtijLpe6DOJ8TGxxzdg//mMT78A SfDANOv6SH8yiivjKpntGEES3xV+Lu9ts30+yFCPpdRZnc4M1uE1y61tX/SMsviXo8opa4Of/V/A6c x/Xpo9US36ogzL9+KdHF11sQJM9MusJq6fVylPHd9V9xsfLsxvAcgjEinwusm8rpyOqAyL8EIXBJEr SpSApGu/nmWQZdXzyXGF+VMrKp6roh4hu6+K4APcLaeKG2ylNZB7a8q8DjBnZc3kyhMyP3FiE4ZC// YTBOvEztGUwYWmnodZpius+WwV7JCJqV6Xs4cFecSwHI71sk+VTHxJD+0+rQ==
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

      CPU 0                             CPU 1

      vfs_read
      mutex_lock(&seq_file->lock)       io_read
					mutex_lock(&ctx->uring_lock)
      mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
					mutex_lock(&seq_file->lock)

The trylock also protects the case where io_uring tries to read from
iterator attached to itself (same ctx), where the order of locks would
be:
 io_uring_enter
  mutex_lock(&ctx->uring_lock) <-----------.
  io_read                                   \
   seq_read                                  \
    mutex_lock(&seq_file->lock)              /
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
 fs/io_uring.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e9df6767e29..7ac479c95d4e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11132,6 +11132,7 @@ __initcall(io_uring_init);
 BTF_ID_LIST(btf_io_uring_ids)
 BTF_ID(struct, io_ring_ctx)
 BTF_ID(struct, io_mapped_ubuf)
+BTF_ID(struct, file)
 
 struct bpf_io_uring_seq_info {
 	struct io_ring_ctx *ctx;
@@ -11312,11 +11313,148 @@ const struct bpf_func_proto bpf_page_to_pfn_proto = {
 	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
 };
 
+/* io_uring iterator for registered files */
+
+struct bpf_iter__io_uring_file {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct io_ring_ctx *, ctx);
+	__bpf_md_ptr(struct file *, file);
+	unsigned long index;
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
+		     unsigned long index)
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
2.33.1

