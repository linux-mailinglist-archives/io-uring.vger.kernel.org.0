Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CD713E722
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 18:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbgAPRXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 12:23:40 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37193 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391347AbgAPRXf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 12:23:35 -0500
Received: by mail-il1-f193.google.com with SMTP id t8so18919577iln.4
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 09:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=iVHrCWxYi1DmJLTbem498XLXnDJ34njIEC+GUDuC7lk=;
        b=KkLOPZMaVFA3w9ptQjie5wKrUCO2hsNEENHQ+y0bAT6f7KifccHNQ2YKIvDMA5ayzv
         LzMoCFj+T8Ekv+uiNyx3QLQQVPkq4gQwWNk4qQ+e8jmNeYvegaJaAPVgNBajf5058AZ+
         5P0qwTJRq4GAGtd6EQjxW5+cXp8+WiZkJ2wbjYDUKwSxQJPFZF/IE7C5JeKk2Ogyyp5c
         Ap8K97YlTiNZFe8wDH6IaO0M7zn9SPa+OdPPShyVGOWFt1sNsSbhQOb5UumSBOBxfq4e
         VEDa6xfZgNYsxhGFLMFQmAMTbY0VL7Ms48sbiso4KOflC+QXmPfgiQMhZMZh2vMdPGt6
         i3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=iVHrCWxYi1DmJLTbem498XLXnDJ34njIEC+GUDuC7lk=;
        b=oR+BkZawHwg9kfaJM+Bx+zKL9vQ/bShTL7xoFQIbd8U1GYQe2EgivZcOlvljm5lYo3
         FCbvjWdVdl2aNGS3Y3TkUfQLOeRPYg31NA4DVpM2KQ7gwt4pumj7Exbd+FpYyVHXXc0Z
         KcTGhhYGt9VfW79ts+GaylA/kRtZRxuIYg6XbTcB2oUWcsUG8Hs95Wi+hURKMaeCy1cl
         LBRRJ3Axh9celFBsgOgWh8pgKeEs1wYDrAXEvqO8eLGqxhn61/CaYzyL9S9BhyxplGnu
         bsAs4Kidfn6qE4jy+Ia77wZe6iZxzlCfi385eo//KsaL0JYIDUQYEII3yP4KA1GdXvNX
         BUgw==
X-Gm-Message-State: APjAAAUw8x9vrUYYD/H+b+3CWa7dGi3qKw5LxhBH0/lyomoJulBFjEBP
        1kZDINSsFs1wKcVBZKdxG0ren9fPBPE=
X-Google-Smtp-Source: APXvYqxKZHh5TpFCTQ+y4nlhQ2jvPstPSwZXKMq9wicIRDklAMd3bBCTN2rWBtssRTIDGSN1Iy7wxg==
X-Received: by 2002:a92:d189:: with SMTP id z9mr4120423ilz.191.1579195414433;
        Thu, 16 Jan 2020 09:23:34 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm3783291iom.71.2020.01.16.09.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 09:23:34 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add support for probing opcodes
Message-ID: <e02f00e0-e2fb-7060-13fe-c6bd0f2a5e6a@kernel.dk>
Date:   Thu, 16 Jan 2020 10:23:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee14a0fcd59f..b073bf944423 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6554,6 +6554,42 @@ SYSCALL_DEFINE2(io_uring_setup, u32, entries,
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
+	/* stock kernel isn't sparse, so everything is supported */
+	for (i = 0; i < nr_args; i++) {
+		p->ops[i].op = i;
+		p->ops[i].flags = IO_URING_OP_SUPPORTED;
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
@@ -6570,7 +6606,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
 	if (opcode != IORING_UNREGISTER_FILES &&
-	    opcode != IORING_REGISTER_FILES_UPDATE) {
+	    opcode != IORING_REGISTER_FILES_UPDATE &&
+	    opcode != IORING_REGISTER_PROBE) {
 		percpu_ref_kill(&ctx->refs);
 
 		/*
@@ -6632,6 +6669,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_eventfd_unregister(ctx);
 		break;
+	case IORING_REGISTER_PROBE:
+		ret = -EINVAL;
+		if (!arg)
+			break;
+		ret = io_probe(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -6639,7 +6682,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 
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

