Return-Path: <io-uring+bounces-3440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB739935F0
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 20:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BB352868D3
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 18:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B941D7E47;
	Mon,  7 Oct 2024 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sOJIFcRU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE01C1AAA
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 18:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728325224; cv=none; b=UL6sU1OdWNk2bwCdaKJwY8m1Zd3skuAue2ljNQHqaoCrkqv4zdShURFOOEYvG8Ajta5Hp6IH6GwR5tqKY09s7vCfZXUNyr3pigEsub5BcELsgwIdF2Dmib4ObRFr8RHuYSj1V9wHHTG2in03lAZQOqoGVK/KyT7Ec/kUEks99po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728325224; c=relaxed/simple;
	bh=ojSf5cbidjyO8BtBhVFcTNRnlmrewtRNc0xe7Fx60FY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WA9ggx/wF/J8VtmToiQmY+97epI3pG4AnSQSgV4X0s6MG8/vUhecL8grpcbBowiRbxHwfElWGJoAgs681lOEyusmdwvak0ykZwnU29jrk4tydy5DvkeFKXrR9qqH83hpB1SqcbmPFAkNdM9zGxpnoZhTIxDoA/dMHR5+qLeR7VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sOJIFcRU; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-832525e7449so345692539f.2
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728325222; x=1728930022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u2v+8dRG3UE1nMM69AsVKIVOw5VffZD/lCmj3L+nU2o=;
        b=sOJIFcRUN7YdCEC44GOBihYdDHZCsljQ5usYhbhASaPPWYvOtYn2vFk0d7avOx6+2q
         yBdz5GyghM5S9SueGD+deyzajya/+pYyZ9nqV5nLgr5qw7RR5/z9BbkZwCOVWerFqMcg
         FHd5pU6dU/8QmaarjWeynwpDvMyW1rP8gy1NmqoSMmUkx9m26b9GyRnabfRlu2tWfj9I
         n+Gja60UfP1jROhQltjywXuPrJpiy3Qx8KELVY1fSujRbDaSrGjKxu9tmv8AckRjVeI0
         hZt5uz7sqjRpyzMpHYSUOOMcOnsaV3m5FP3QwLXfP18EKd3lLgyQKBmrMGLQf4pCBJSX
         ExTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728325222; x=1728930022;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2v+8dRG3UE1nMM69AsVKIVOw5VffZD/lCmj3L+nU2o=;
        b=pebYb9d4yNW2YP+2vVgAzPvHRGZNdE+sB+a1AY5HFvESCdhKrZstcS0+VPP8UeM/nt
         KKSrfSoQGLTQlCPGbVnAVHppWQbszWAJqloV8e2gD8tR9wwEWg9xSsHbm+SHhqvW3veG
         jP4nlwDvP24AOuF8FLedqr4Q/HrxG0ihdZC63ogEwE4kW4ii79gam2BQKe+Rdw+8h6M/
         Hs9ElIqwlcDd3hE23Bk6S80FV3mWHslQssgP4mUmTpbSm8xm7pLyLbG1Nm/HATnIqg8X
         dWdmdClQYW55H1Ime96RcKIWvRoHL5EfvUVnrSteG24vgZvgej+BiwhVOkKSSQ15NK9Q
         4VIg==
X-Forwarded-Encrypted: i=1; AJvYcCWkmmEmXHnTh73D4DtZr3GQYbt+1B4eE+Jqf61S012MVI8LrHgV+/Gw/oQLAVcbImDWPbhg7nY3bQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcc4L85kM2jJ/AhvfPR7t8S3++YF483iWivafo+aO4xbqq3I0e
	5aLeuCi1Y28jvgd2UlIQ1sPX0HMBqJ4fZAEz77AiHvy1ZHId8eHgTu7BZti1nCA=
X-Google-Smtp-Source: AGHT+IGyvCO4hk9dD0z++2E+tCl7PlWSCqS+Vxlnqkga5Qs+bR1Yv5xManU/Zq/VXIHQuRZvUimsgg==
X-Received: by 2002:a05:6e02:12c7:b0:39f:6f8c:45f3 with SMTP id e9e14a558f8ab-3a375bae0b2mr106028055ab.16.1728325221940;
        Mon, 07 Oct 2024 11:20:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a37a868967sm14065885ab.67.2024.10.07.11.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 11:20:21 -0700 (PDT)
Message-ID: <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
Date: Mon, 7 Oct 2024 12:20:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
From: Jens Axboe <axboe@kernel.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
 io-uring@vger.kernel.org, cgzones@googlemail.com
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
 <20241006052859.GD4017910@ZenIV>
 <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
Content-Language: en-US
In-Reply-To: <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 12:09 PM, Jens Axboe wrote:
>>>> Questions on the io_uring side:
>>>> 	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
>>>> Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
>>>> Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
>>>> Am I missing something subtle here?
>>>
>>> Right, it could be allowed for fgetxattr on the io_uring side. Anything
>>> that passes in a struct file would be fair game to enable it on.
>>> Anything that passes in a path (eg a non-fd value), it obviously
>>> wouldn't make sense anyway.
>>
>> OK, done and force-pushed into #work.xattr.
> 
> I just checked, and while I think this is fine to do for the 'fd' taking
> {s,g}etxattr, I don't think the path taking ones should allow
> IOSQE_FIXED_FILE being set. It's nonsensical, as they don't take a file
> descriptor. So I'd prefer if we kept it to just the f* variants. I can
> just make this tweak in my io_uring 6.12 branch and get it upstream this
> week, that'll take it out of your hands.
> 
> What do you think?

Like the below. You can update yours if you want, or I can shove this
into 6.12, whatever is the easiest for you.


diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 6cf41c3bc369..4b68c282c91a 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -48,9 +48,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
 	ix->filename = NULL;
 	ix->ctx.kvalue = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -90,6 +87,9 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *path;
 	int ret;
 
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
 	ret = __io_getxattr_prep(req, sqe);
 	if (ret)
 		return ret;
@@ -152,9 +152,6 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
 	ix->filename = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
@@ -183,6 +180,9 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *path;
 	int ret;
 
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
 	ret = __io_setxattr_prep(req, sqe);
 	if (ret)
 		return ret;

-- 
Jens Axboe

