Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BAA31D9A9
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 13:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhBQMms (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 07:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbhBQMmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 07:42:45 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AB8C0613D6
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:04 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id g6so17221938wrs.11
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5x8n83gPYOt7SmyWSGXUskXg6MirfQUnIDYaX2n5/NA=;
        b=iKRXPSpGXbrRIZ9YzQyiEpzuvyQCW3ITcXTTx5aqT0eWMfivo9ZGCXM5iDWlO5zmxA
         qf5ToZeZVn8dRUqAtVUkPSheWDQ2Onble3pZS7lmHoVJcn13Xz+uRiULjF4ZC5gHHuzx
         uUfZ85Ci8fqODKwG1lf2/EMTgvsJCQ6ClWv6yuk88kfszMJk9dfJ0lgY+Aj5Ff1WzI14
         MvfuHViaMouzuOkj6rwWQq4jkJuPLwDnU/lAAshp+Imr2AfqhUOOhB/ZzeMdDDPUFumj
         pm9vUgqWTVPeagcFJSs6w+FSbh2nP8XHnnf8d74G9uOw/UbSsAqmyfKpjdHZvIf2u9Hl
         0eQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5x8n83gPYOt7SmyWSGXUskXg6MirfQUnIDYaX2n5/NA=;
        b=oi8il48lPY1blp0ZccQK3TLfqfsneI2UXh1C+Zvx9STCu647LtVbVsYlVHVzDBLI/A
         +DcgoBVs5MyB+hJXDs9WeC7o0vuMvqZyJnArg+WEDW3AvU9yt43LyJ6IpJ6SuNhc5rmY
         OS50n2OiKeYdwkKdAn9jzqQIebBgWbv2JhXhABR+S7dp0okT1D7qiwkh7EseQYDplMf0
         VZpU3Xh2GPy+oTzEAejxX1MDm6fUwarsFWwuY08V4Cyv7nqhZGF38zoRVvhPp2r8XxTn
         7Q86BG9bqbUmyFwBWDMZNcjtY4iaCWJtGcin2yfnlPxNAxqUimkLsP36AFWGSpwwHz7N
         yqVA==
X-Gm-Message-State: AOAM530GECOKgQv/PV9Rckc5lqtYvQ2H2hevDRYCDNiUechv366Xt73f
        NVryv98/BQ6ePkcIBDkHod6L9OCRut6FxQ==
X-Google-Smtp-Source: ABdhPJyCtavif7/F9QkARSuXXASDwIwY7q2KzuojEgT9yyAHlVnPmHVACRsDtMV4nQlfDlVXUctXiw==
X-Received: by 2002:a5d:4a0c:: with SMTP id m12mr28953954wrq.274.1613565723197;
        Wed, 17 Feb 2021 04:42:03 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id t9sm3589979wrw.76.2021.02.17.04.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: implement bpf prog registration
Date:   Wed, 17 Feb 2021 12:38:04 +0000
Message-Id: <0d9eb836f8af66caf03e6af3f569a5514dd737f1.1613563964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613563964.git.asml.silence@gmail.com>
References: <cover.1613563964.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[de]register BPF programs through io_uring_register() with new
IORING_ATTACH_BPF and IORING_DETACH_BPF commands.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 82 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c8904bee386..524cf1eb1cec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -82,6 +82,7 @@
 #include <linux/io_uring.h>
 #include <linux/blk-cgroup.h>
 #include <linux/audit.h>
+#include <linux/bpf.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -249,6 +250,10 @@ struct io_restriction {
 	bool registered;
 };
 
+struct io_bpf_prog {
+	struct bpf_prog *prog;
+};
+
 struct io_sq_data {
 	refcount_t		refs;
 	struct mutex		lock;
@@ -388,6 +393,10 @@ struct io_ring_ctx {
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	*user_bufs;
 
+	/* bpf programs */
+	struct io_bpf_prog	*bpf_progs;
+	unsigned		nr_bpf_progs;
+
 	struct user_struct	*user;
 
 	const struct cred	*creds;
@@ -8694,6 +8703,67 @@ static void io_req_cache_free(struct list_head *list)
 	}
 }
 
+static int io_bpf_detach(struct io_ring_ctx *ctx)
+{
+	int i;
+
+	if (!ctx->nr_bpf_progs)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->nr_bpf_progs; ++i) {
+		struct bpf_prog *prog = ctx->bpf_progs[i].prog;
+
+		if (prog)
+			bpf_prog_put(prog);
+	}
+	kfree(ctx->bpf_progs);
+	ctx->bpf_progs = NULL;
+	ctx->nr_bpf_progs = 0;
+	return 0;
+}
+
+static int io_bpf_attach(struct io_ring_ctx *ctx, void __user *arg,
+			 unsigned int nr_args)
+{
+	u32 __user *fds = arg;
+	int i, ret = 0;
+
+	if (!nr_args || nr_args > 100)
+		return -EINVAL;
+	if (ctx->nr_bpf_progs)
+		return -EBUSY;
+
+	ctx->bpf_progs = kcalloc(nr_args, sizeof(ctx->bpf_progs[0]),
+				 GFP_KERNEL);
+	if (!ctx->bpf_progs)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_args; ++i) {
+		struct bpf_prog *prog;
+		u32 fd;
+
+		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (fd == -1)
+			continue;
+
+		prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_IOURING);
+		if (IS_ERR(prog)) {
+			ret = PTR_ERR(prog);
+			break;
+		}
+
+		ctx->bpf_progs[i].prog = prog;
+	}
+
+	ctx->nr_bpf_progs = i;
+	if (ret)
+		io_bpf_detach(ctx);
+	return ret;
+}
+
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
@@ -8708,6 +8778,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	io_finish_async(ctx);
 	io_sqe_buffers_unregister(ctx);
+	io_bpf_detach(ctx);
 
 	if (ctx->sqo_task) {
 		put_task_struct(ctx->sqo_task);
@@ -10151,6 +10222,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RESTRICTIONS:
 		ret = io_register_restrictions(ctx, arg, nr_args);
 		break;
+	case IORING_ATTACH_BPF:
+		ret = io_bpf_attach(ctx, arg, nr_args);
+		break;
+	case IORING_DETACH_BPF:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_bpf_detach(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ac4e1738a9af..d95e04d6d316 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,8 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_ATTACH_BPF			= 13,
+	IORING_DETACH_BPF			= 14,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
-- 
2.24.0

