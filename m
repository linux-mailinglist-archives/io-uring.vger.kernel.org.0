Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E5B14021F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 03:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388909AbgAQC6X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 21:58:23 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36609 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbgAQC6W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 21:58:22 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so2613155pjb.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 18:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ux4HXHhMkouIZWfMtuB9oVHFAxqP/W5z3LL3cD+y5fQ=;
        b=Z6lS9FS+R82sJPDG45nfIfAXYChxbyMJEKmqutNe+nlht1b38hxaH4KTUpISHs35tU
         WEvQ5j4LaGfiFdEMUVn7LqVvZKj3BVFqQfG2kiXjuSHTursf4g38nR3mH1oT7usrTdEg
         /Hb8SCIIiaMfD6OUiHudyeLEUBcEdJFNUqZZMaWF4lgWms/fv1jRQ/KFY0QfQDrfWrwd
         PBcEY9JPpqMacBd1yJSWey18eqN2pJnJ9q3Ej1V2oUpbfzKmBRuw3R8QuHrRfpA8x2S/
         5vuVo4Noum1zEFpje3hn3p8xCDR/bDycPw+ZFvW6yGuhq1BBrjw/keCNjo1U0TPlMJqd
         RvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ux4HXHhMkouIZWfMtuB9oVHFAxqP/W5z3LL3cD+y5fQ=;
        b=NiPvycmtkQ5O3M7OXspQZTifyOlQo3h4PvdTQfE72UHulyXANaZHvF/OIGyztRlJaY
         JbitVw6ixa2xKU9NB+H/xOb3UXZyMBcNSnQT8g/8scakhzHZaX89qGto/owvKlg+7uSq
         yQlUaIADVxU/leqypZewOWX+1FRLQbLZ4eBS0bWyDFajzcNbRPzTrq68LUuwkZqiM5BR
         UN8fA1xmBOirXR14H8O3uWO7qLdgtT9RAOKiVysbW/AYJRxsZ3rRk+0uKBDMIt9YwP4w
         2lP4n8mGWJgZQ0Rb2gJ2MGZWGzKFnQGjVfQlCLKY2QPtxdE12IxgZngD87fpNTF0QRcP
         ay7g==
X-Gm-Message-State: APjAAAX+jf57MlKVJbCK62wcZlk5D9XgtIdTnJ/g22msq4RoUY9dPg35
        zoeQKPaQDfm3KsimAYSwEnRgOzsJFh0=
X-Google-Smtp-Source: APXvYqxYFS4yJ+tVmhS+9fg4YFmRIp+/x6iIOHgiKFEvoBnaiB8hZqlCXzaWgLREPszQmCr29qPCzQ==
X-Received: by 2002:a17:902:7291:: with SMTP id d17mr17903507pll.227.1579229901628;
        Thu, 16 Jan 2020 18:58:21 -0800 (PST)
Received: from ?IPv6:2600:380:4b14:d397:f0a3:4fc6:c904:323a? ([2600:380:4b14:d397:f0a3:4fc6:c904:323a])
        by smtp.gmail.com with ESMTPSA id n26sm27370292pgd.46.2020.01.16.18.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 18:58:20 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: add support for probing opcodes
Message-ID: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
Date:   Thu, 16 Jan 2020 19:58:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The application currently has no way of knowing if a given opcode is
supported or not without having to try and issue one and see if we get
-EINVAL or not. And even this approach is fraught with peril, as maybe
we're getting -EINVAL due to some fields being missing, or maybe it's
just not that easy to issue that particular command without doing some
other leg work in terms of setup first.

This adds IORING_REGISTER_PROBE, which fills in a structure with info
on what it supported or not. This will work even with sparse opcode
fields, which may happen in the future or even today if someone
backports specific features to older kernels.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes since v1:
- Use io_op_def->not_supported flag. Makes it easier for backports
  since they only need to change one location to ensure everything
  is sane, and io_op_def always needs changing anyway.

- Cap 'nr_args' at OP_LAST

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee14a0fcd59f..b20587bda5d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -561,6 +561,8 @@ struct io_op_def {
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
 	unsigned		unbound_nonreg_file : 1;
+	/* opcode is not supported by this kernel */
+	unsigned		not_supported : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -6554,6 +6556,45 @@ SYSCALL_DEFINE2(io_uring_setup, u32, entries,
 	return io_uring_setup(entries, params);
 }
 
+static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	struct io_uring_probe *p;
+	size_t size;
+	int i, ret;
+
+	size = struct_size(p, ops, nr_args);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+	p = kzalloc(size, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(p, arg, size))
+		goto out;
+	ret = -EINVAL;
+	if (memchr_inv(p, 0, size))
+		goto out;
+
+	p->last_op = IORING_OP_LAST - 1;
+	if (nr_args > IORING_OP_LAST)
+		nr_args = IORING_OP_LAST;
+
+	for (i = 0; i < nr_args; i++) {
+		p->ops[i].op = i;
+		if (!io_op_defs[i].not_supported)
+			p->ops[i].flags = IO_URING_OP_SUPPORTED;
+	}
+	p->ops_len = i;
+
+	ret = 0;
+	if (copy_to_user(arg, p, size))
+		ret = -EFAULT;
+out:
+	kfree(p);
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -6570,7 +6611,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
 	if (opcode != IORING_UNREGISTER_FILES &&
-	    opcode != IORING_REGISTER_FILES_UPDATE) {
+	    opcode != IORING_REGISTER_FILES_UPDATE &&
+	    opcode != IORING_REGISTER_PROBE) {
 		percpu_ref_kill(&ctx->refs);
 
 		/*
@@ -6632,6 +6674,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_eventfd_unregister(ctx);
 		break;
+	case IORING_REGISTER_PROBE:
+		ret = -EINVAL;
+		if (!arg || nr_args > 256)
+			break;
+		ret = io_probe(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -6639,7 +6687,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 
 	if (opcode != IORING_UNREGISTER_FILES &&
-	    opcode != IORING_REGISTER_FILES_UPDATE) {
+	    opcode != IORING_REGISTER_FILES_UPDATE &&
+	    opcode != IORING_REGISTER_PROBE) {
 		/* bring the ctx back to life */
 		percpu_ref_reinit(&ctx->refs);
 out:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fea7da182851..955fd477e530 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -194,6 +194,7 @@ struct io_uring_params {
 #define IORING_UNREGISTER_EVENTFD	5
 #define IORING_REGISTER_FILES_UPDATE	6
 #define IORING_REGISTER_EVENTFD_ASYNC	7
+#define IORING_REGISTER_PROBE		8
 
 struct io_uring_files_update {
 	__u32 offset;
@@ -201,4 +202,21 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+#define IO_URING_OP_SUPPORTED	(1U << 0)
+
+struct io_uring_probe_op {
+	__u8 op;
+	__u8 resv;
+	__u16 flags;	/* IO_URING_OP_* flags */
+	__u32 resv2;
+};
+
+struct io_uring_probe {
+	__u8 last_op;	/* last opcode supported */
+	__u8 ops_len;	/* length of ops[] array below */
+	__u16 resv;
+	__u32 resv2[3];
+	struct io_uring_probe_op ops[0];
+};
+
 #endif

-- 
Jens Axboe

