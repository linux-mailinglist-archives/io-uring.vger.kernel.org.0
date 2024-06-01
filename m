Return-Path: <io-uring+bounces-2054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3008B8D70A3
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 17:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A889FB21AC9
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 15:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37496153814;
	Sat,  1 Jun 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ei8fQehk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3040415279A
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717254308; cv=none; b=VPLNS/FXeP8er9qbZC+OV/Z98JQ6OCQwpx7I+vLZVR0KT4EEV3+B4gULbtWidJs9TKrGuvOrN6mfTAdpP0/YDQVSSl4DqjZwwIxjijHo7jjdojDeKZ1eAy0tSJAt0nfNhaMgZLKNoA25YqTlJ2NSnMep6nXPY0e/ismXoSBwi64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717254308; c=relaxed/simple;
	bh=JMWMcxKq6dBnGxvg29g2pEZy/Aa38uC56OnO+l1KXMA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qJyS7KFLpYXMY75pPadYxd+TRXT+18grk7CAnJTsRgMLWtYANrlOUWYTuQcuxW7qIlDqNdJ5M/zqMhoXrW3rcOeB7JxxpYFYN4FpGPs80zo7JQGKVEqRylZ7g8j/uwvhEebUbLFiIYv5/cArsYfD6I7zPLMzUSyu2nS/fOceSJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ei8fQehk; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6c82c37cd6bso40482a12.0
        for <io-uring@vger.kernel.org>; Sat, 01 Jun 2024 08:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717254303; x=1717859103; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6X41oNEUx5r3KcwUodP3fm/LfXAKGlGMnYax5kVMjw=;
        b=Ei8fQehkcBy8DvJ+XznYbnndF4jlj59HKd7WIDzfGU9xvcLbznPSnm5S5VLIhw0plB
         1N2rcEITCKUQFprAS1iW+GsnXQlZ6I5ky1Jac4WL7oBS9UMyn8x2rNk0qGNROAoDlYLy
         /lMLYL8K83V7Ib3Q9halwJH01QN6qR1zhdLeW2lEWNqf/LvgPWKxbxcfCm/4P+KBbLC8
         ckk3quZ9JZvSMAfHS7mvYQgc3L6nNVqOuxtQx4z/df1J+OtfuISI1QfuS8z7odm/kTeL
         gJNVZA4h8HzjSDP1pmhl/LbHDcKJyW+MJGZr98WOCRlppZUbeS1hirNCPI0QwJKzg1Si
         /Qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717254303; x=1717859103;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6X41oNEUx5r3KcwUodP3fm/LfXAKGlGMnYax5kVMjw=;
        b=Xjec/RDt0v9jzOUUdFBkYds/40cShllPFtrQeV0xf5dVEwaz8Uig7/8tTXtBJtetcX
         2Vd9i8iErnz58Z6R/gVCeE58OUPHjC2WnUEZcpv5mGzd+8YYYTN0YgwVB4TF71D95VS0
         77X4kd+pg0Aya5JR/+ZvERnOyEBnpSonSWvIjhI6sXS9WTEQPOIXui5BI8aT+Sj/iHqM
         mzXkiXDH+kT0sU0RgV3xF5GttbR1vnccV3OCI7sJqah7Jbrp63EUYFt5cUxdotk50/gn
         4RrE5rv0j9rFx7iaPZS47Pgy5zUId5pa/3M6ULWWXndnYEvauXCp+TQoq586iSAYm7NP
         fGEA==
X-Forwarded-Encrypted: i=1; AJvYcCU5WfgabH0VpJcMhD3tcB9xUolgG/33QzIH4RHx3ZoPkk4m10TtEFPKlnyr9tKCVXkuQjjMmPDkL58yvXROE0i68+vOOuOpvnI=
X-Gm-Message-State: AOJu0YyIg4F6EEYsp9L27gjg1tEtdybczw19eSdJTu8Oqdjz9GsofKPA
	TAgsnrmjnTSNgZ34k9F1qMXVbPlUAq5BVjaQw3hBPxj/YigruC2ceec8dFCgDucQ2DN8uyDH3hU
	q
X-Google-Smtp-Source: AGHT+IEkfDPMRp/ZHi0AOgx2uVYvI4Mq1v08zonwT041dHvQ5Tl7GZ8yYnT439w8m35T2DHyxrMYUw==
X-Received: by 2002:a17:902:f68b:b0:1f6:1bbb:e07d with SMTP id d9443c01a7336-1f636940067mr54044635ad.0.1717254303269;
        Sat, 01 Jun 2024 08:05:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323390e2sm34703065ad.6.2024.06.01.08.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jun 2024 08:05:02 -0700 (PDT)
Message-ID: <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
Date: Sat, 1 Jun 2024 09:05:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise/fadvise 32-bit length
From: Jens Axboe <axboe@kernel.dk>
To: Stefan <source@s.muenzel.net>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
Content-Language: en-US
In-Reply-To: <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/24 8:19 AM, Jens Axboe wrote:
> On 6/1/24 3:43 AM, Stefan wrote:
>> io_uring uses the __u32 len field in order to pass the length to
>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>> 64bit platforms.
>>
>> When using liburing, the length is silently truncated to 32bits (so
>> 8GB length would become zero, which has a different meaning of "until
>> the end of the file" for fadvise).
>>
>> If my understanding is correct, we could fix this by introducing new
>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>> of the length field for length.
> 
> We probably just want to introduce a flag and ensure that older stable
> kernels check it, and then use a 64-bit field for it when the flag is
> set.

I think this should do it on the kernel side, as we already check these
fields and return -EINVAL as needed. Should also be trivial to backport.
Totally untested... Might want a FEAT flag for this, or something where
it's detectable, to make the liburing change straight forward.


diff --git a/io_uring/advise.c b/io_uring/advise.c
index 7085804c513c..cb7b881665e5 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -17,14 +17,14 @@
 struct io_fadvise {
 	struct file			*file;
 	u64				offset;
-	u32				len;
+	u64				len;
 	u32				advice;
 };
 
 struct io_madvise {
 	struct file			*file;
 	u64				addr;
-	u32				len;
+	u64				len;
 	u32				advice;
 };
 
@@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
 	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
 
-	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	ma->addr = READ_ONCE(sqe->addr);
-	ma->len = READ_ONCE(sqe->len);
+	ma->len = READ_ONCE(sqe->off);
+	if (!ma->len)
+		ma->len = READ_ONCE(sqe->len);
 	ma->advice = READ_ONCE(sqe->fadvise_advice);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
@@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
 
-	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	fa->offset = READ_ONCE(sqe->off);
-	fa->len = READ_ONCE(sqe->len);
+	fa->len = READ_ONCE(sqe->addr);
+	if (!fa->len)
+		fa->len = READ_ONCE(sqe->len);
 	fa->advice = READ_ONCE(sqe->fadvise_advice);
 	if (io_fadvise_force_async(fa))
 		req->flags |= REQ_F_FORCE_ASYNC;

-- 
Jens Axboe


