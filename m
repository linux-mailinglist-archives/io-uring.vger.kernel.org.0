Return-Path: <io-uring+bounces-6821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F235A46C34
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B883F188C00B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAAB10F2;
	Wed, 26 Feb 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UmLj0m6S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB212755E0
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601228; cv=none; b=L8eFqZGU55CVFgKhlHDa47XLNWpPsxkSiZmhK4NbNqw2To2JNQzlFfppWaf4W76gpO57MWoIfHdGCx7bap49H3i7mbZt1+Pp56KrJiX1FhklZbVgnojvEri7GQC2NkNBbMI7b4P6rNmhO0KQQ3BaWWTjtBgGjGNOfre79O012hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601228; c=relaxed/simple;
	bh=QdYH96x02EZEzcryceRvvZJy1m3JRL1a19eQWqIC3qM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HwSuHMhd2MFmVgdLBOAGjEKZiN7PPzILqpW6xy3oZCsf4NryF2zXmL5R5h1P/QgCPn2bFtkM1ktVE0m6ls4yqyuIJ5CnouKPTbGYjqudZXR6Yy5xVcbfyjPlw2INnAWiZ4WL0OFCJlRyhPJW+YkR+3S1xrd63Xt/pFfqGOOqfrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UmLj0m6S; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d2b3c0b3fbso1631995ab.3
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740601226; x=1741206026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XQY1cNnksnM7mm0vxRtHto+/6pTEYFjzebFLJCOPIWo=;
        b=UmLj0m6SVEJIr454v6ZGkuWUifJ71Nq8N2mJ2hLj3fgsPIYBP21ghvvxU5lI9B8tzW
         rITpWSyK58FN/4HUsVagp00b18gjdhpVQQjdKV4/Ef1DV3AoCpNxhLS9WxGPJyOHXIvx
         Yk70kblubI1ykF9jUnv6qBjVGur3i+It4lNCC93bHHVqngYV7h57argg1x3yMDvuBzsR
         nD7YDUa4LEr9LOLpR/Ry8MUj2PUoWBKrjYCGFiww+3H7yIlkmuiXPqGaJwJgu+FoX8LU
         rZ1yYliHta01Rcpweisole+oKIzrHRewSJNhMqvg8PqBR7tShZGebT0+JqUUnL3rYUE2
         v7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740601226; x=1741206026;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XQY1cNnksnM7mm0vxRtHto+/6pTEYFjzebFLJCOPIWo=;
        b=XzW/l9avmgQWFL1YeS3zIEJcspUP1xY0lhyx5NaCNVkbze0W1o4zeZEi69+JOusXkK
         Nax+l5DYiGGmakk20VsKBjc2ZYLzt0sfdOKogTqRtZTWzbF+Oqdy9FvjPZlnHdaZovtz
         fv4UVULPDjkARm7BqI487Xs+2Uk3qYB8JviEo80Vcp9X0KeanUM0QPtQX/MHh3X/+kgy
         weh4PgNFQ0J6O2mjiTWWoAQbRmbUTB4H+d/qU1+TkbWajzI8j1i/CpA4bDQMCubZyR1Y
         PuNtAIzD3EH3P+GCDA0Z0vLpO65ZbjwukUNwjFc0BJdyn0K9XMgqG8sFEu+adMfxFk0f
         K4TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQYp2KiMYRMSqh3eBUE4BTXZ3huIKLvmPEPS0NbOnSkGHGx/8BJx907CYDk8BGyhDtQ/eDa/bRUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMW3oFKsXz2rUiFkF4dNNoGgJ9ouCMoLKjZa6Rj34x0UGhCFgK
	yUHmhSRy+k/4XeUgYlswPuQCtNt0O6oXOk7FVNXOlyt7WsFfNV0CDg03/gHinJg=
X-Gm-Gg: ASbGncuJj8EICkwjRbaddFBF+WRL+uY535VY1/SueFIYv7sFWnP9xL8SCdyzeo+bkgq
	TLDjupNKR6NM9swBDpf2ZanVksfIdbKQHuz1hZVjkbOm0ngXmMgkcDWe+ECpWpJRfxZIfkMOmbP
	EltH3mLkDz91Mz07sukd/YfX/tTT93gU3RhhEjJ9XUBAzUIpxzw4JyinzrYCb69eBBHiGoNxUZ0
	Xf1evF3uRzPgmk3heyeOalkr93KAQU2kLsPOY4FQqGJHcbvoorwjcheeT/dqfq7/v2HeLA3fNzp
	gF2AqAiXvFjGnF0ykdBljg==
X-Google-Smtp-Source: AGHT+IEjEF0cObp94jBCRKJ95+V93f7YSBkOAprO1IawkzEuP1JiGipJ09HNY+mWwbaEPnO8tYx5IQ==
X-Received: by 2002:a05:6e02:1447:b0:3cf:b365:dcf8 with SMTP id e9e14a558f8ab-3d30489daf5mr95555765ab.21.1740601225972;
        Wed, 26 Feb 2025 12:20:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f061f38dc5sm7088173.86.2025.02.26.12.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 12:20:25 -0800 (PST)
Message-ID: <d1ff0d23-07a4-4123-b30f-446cf849814a@kernel.dk>
Date: Wed, 26 Feb 2025 13:20:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 1/6] io_uring/rw: move fixed buffer import to issue path
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-2-kbusch@meta.com>
 <8b65adec-8888-40ae-b6c8-358fa836bcc6@kernel.dk>
Content-Language: en-US
In-Reply-To: <8b65adec-8888-40ae-b6c8-358fa836bcc6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 12:04 PM, Jens Axboe wrote:
> On 2/26/25 11:20 AM, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> Registered buffers may depend on a linked command, which makes the prep
>> path too early to import. Move to the issue path when the node is
>> actually needed like all the other users of fixed buffers.
> 
> Conceptually I think this patch is fine, but it does bother me with
> random bool arguments. We could fold in something like the (totally
> tested) below diff to get rid of that. What do you think?
> 
> +static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> +		      int ddir)
> +{
> +	int ret;
> +
> +	ret = __io_prep_rw(req, sqe, ddir);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	return io_rw_do_import(req, ITER_DEST);

Oops, should be 'ddir' here too of course. Updated below, does pass my
testing fwiw.


diff --git a/io_uring/rw.c b/io_uring/rw.c
index 728d695d2552..4ac2d004b352 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -248,8 +248,8 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	return ret;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      int ddir, bool do_import)
+static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			int ddir)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
@@ -285,14 +285,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
 
-	if (do_import && !io_do_buffer_select(req)) {
-		struct io_async_rw *io = req->async_data;
-
-		ret = io_import_rw_buffer(ddir, req, io, 0);
-		if (unlikely(ret))
-			return ret;
-	}
-
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {
 		u64 attr_ptr;
@@ -307,27 +299,52 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return ret;
 }
 
+static int io_rw_do_import(struct io_kiocb *req, int ddir)
+{
+	if (!io_do_buffer_select(req)) {
+		struct io_async_rw *io = req->async_data;
+		int ret;
+
+		ret = io_import_rw_buffer(ddir, req, io, 0);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return 0;
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int ddir)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ddir);
+	if (unlikely(ret))
+		return ret;
+
+	return io_rw_do_import(req, ddir);
+}
+
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_DEST, true);
+	return io_prep_rw(req, sqe, ITER_DEST);
 }
 
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_SOURCE, true);
+	return io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
 static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		       int ddir)
 {
-	const bool do_import = !(req->flags & REQ_F_BUFFER_SELECT);
 	int ret;
 
-	ret = io_prep_rw(req, sqe, ddir, do_import);
+	ret = io_prep_rw(req, sqe, ddir);
 	if (unlikely(ret))
 		return ret;
-	if (do_import)
-		return 0;
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return io_rw_do_import(req, ddir);
 
 	/*
 	 * Have to do this validation here, as this is in io_read() rw->len
@@ -364,12 +381,12 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_DEST, false);
+	return io_prep_rw(req, sqe, ITER_DEST);
 }
 
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_SOURCE, false);
+	return io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
 /*
@@ -385,7 +402,7 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
-	ret = io_prep_rw(req, sqe, ITER_DEST, false);
+	ret = io_prep_rw(req, sqe, ITER_DEST);
 	if (unlikely(ret))
 		return ret;
 

-- 
Jens Axboe

