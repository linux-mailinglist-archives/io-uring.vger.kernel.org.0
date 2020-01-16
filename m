Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454F713FC3F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 23:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732959AbgAPWge (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 17:36:34 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36156 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732827AbgAPWge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 17:36:34 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so10654247pgc.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 14:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZTGrxCfWigTKBvZDD9T1N8tmVjlQ5hSV9C5ZWdAstA=;
        b=HqCiaQwZXKWIyAnAbm2X9fOnqjR35IjQa37JAIIslPc2+KZPDZGTWsRsziiR8CReCR
         VrA8uq8SAT7kTTGmFpHWimy4FInd6EG5v/oqHfCaM963oZ2V20166ykadadqL4y3QW6U
         6qk1iY8hmUrbfcvXE0CohHR/bS+38tWcDGNxkA4/Zrt58omtJPQbvI0mjlwJy6qaTyXF
         oqCJKv/bnKkEzigC9+pZYY5e1F1FyAl8HbLD32yDq3RNfotWndc3gSUaONnQTxtEHWZ/
         qgUoFhijSCFscI/ZYg53uFryEYdE4ewCMSglpeMl1tLeRb596hlzNnVE0u6ZAUKjRdMk
         6ycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZTGrxCfWigTKBvZDD9T1N8tmVjlQ5hSV9C5ZWdAstA=;
        b=bBJ+IOF/qDcr38/4D2fSoGBPS2FHpRs65QWzJK7dPBpkKKIrjmSI04QNL2GO+mD8Dx
         dMpLxtxYl59g1kqC6y1RAHE8BrgLNFV1sISryO6yQYO3itEK7sAvAqvHMWIlmcwe4LeO
         B+dWOWhIjwsl5J8aN91fwpK9e6ojricVffbra2TltHRJ+Oo2R/yDYxpGqNd+E7xb0HQ5
         zbKGLuOcgevbuYhEMbuao07GWCLimxX+tHN914s37U2qvZFdXHz4dJXSfXo7MNlUBWEN
         90C6HmwSNptfKH8O7FhguamoR99fD1zdJbn5jv9LTSKlThRHnbUxpY++iGSi9loou6EA
         rQsQ==
X-Gm-Message-State: APjAAAUubHeieMaSL6Xskld+/hoUpffAgddP4/G7fiIBiNvG0YNSHj50
        GEar0GSjIBNEHg7nZSyE4DmYQiGKVixWCg==
X-Google-Smtp-Source: APXvYqz2LELoiBN/+/6xSs8AXLZrbMt5BS9tlGg8K3fXoSIL34E6qkNQnMrOVagqSXXC75mDOfzCuw==
X-Received: by 2002:a65:5608:: with SMTP id l8mr42690173pgs.210.1579214193389;
        Thu, 16 Jan 2020 14:36:33 -0800 (PST)
Received: from ?IPv6:2600:380:4b47:9bfd:1d3:1b90:b928:43bd? ([2600:380:4b47:9bfd:1d3:1b90:b928:43bd])
        by smtp.gmail.com with ESMTPSA id fa21sm4792010pjb.17.2020.01.16.14.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 14:36:32 -0800 (PST)
Subject: Re: [PATCH] io_uring: add support for probing opcodes
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
Cc:     =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <e02f00e0-e2fb-7060-13fe-c6bd0f2a5e6a@kernel.dk>
 <3c9dacf6-05a9-5561-dd8e-59a26e3e2916@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cde63537-fcc9-644a-9086-b392fb0ffedc@kernel.dk>
Date:   Thu, 16 Jan 2020 15:36:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3c9dacf6-05a9-5561-dd8e-59a26e3e2916@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 3:35 PM, Stefan Metzmacher wrote:
> Am 16.01.20 um 18:23 schrieb Jens Axboe:
>> The application currently has no way of knowing if a given opcode is
>> supported or not without having to try and issue one and see if we get
>> -EINVAL or not. And even this approach is fraught with peril, as maybe
>> we're getting -EINVAL due to some fields being missing, or maybe it's
>> just not that easy to issue that particular command without doing some
>> other leg work in terms of setup first.
>>
>> This adds IORING_REGISTER_PROBE, which fills in a structure with info
>> on what it supported or not. This will work even with sparse opcode
>> fields, which may happen in the future or even today if someone
>> backports specific features to older kernels.
> 
> That's funny I was just thinking about exactly that topic before
> I opened the io-uring mail folder:-)
> 
> That's will make it much easier to write a portable
> vfs backend for samba that doesn't depend on the kernel
> features at build time.
> 
>> +	p->last_op = IORING_OP_LAST - 1;
>> +	/* stock kernel isn't sparse, so everything is supported */
>> +	for (i = 0; i < nr_args; i++) {
>> +		p->ops[i].op = i;
> 
> Shouldn't there be an if (i <= p->last_op) before we pretent to support
> an opcode? Or we need to truncate nr_args

Yeah, I made some edits, just didn't post v2 yet. Below is the current
one:


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

