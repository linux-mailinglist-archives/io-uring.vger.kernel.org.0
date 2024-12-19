Return-Path: <io-uring+bounces-5570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B3F9F7FF4
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 17:36:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15AD31889B88
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 16:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE67B22686A;
	Thu, 19 Dec 2024 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fbXPtg9L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8776022756F
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 16:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734626142; cv=none; b=AwKBTujaWTOwrlrE+xTY68c6P8ZYz4vkLHABNB/HxkCWRgRo3Pe67qlxI86fc073e8IHx+VpSP4fHXq0hFJwwtX9P2+wi+3nfN54y0Yn5vLWhEjEoygX8itxymaNyqIqX3Dcib0mbd8rb7RlozVACe7PvLBuFcD6gvqslRJrok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734626142; c=relaxed/simple;
	bh=7bO4WPA4wryezRS/z7FnCmY+iPdajr/3Okq7SboOhKM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=QmKgiUmlio9y7h2UT3eIbvx/K7svc+3VBguUIRHU42ysmg+XLVjgEQf+ehsPJYoUWOKFRY6FtCCiv8nU03zhBUT+w3GgZttdjEL7XxGob3XLRFNUsTHTz7qvxm/xQQ6Id0ggtZShA2c206jMxYvimj+NKUcv++IloTxTNnKRicU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fbXPtg9L; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a777958043so3168215ab.2
        for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 08:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734626138; x=1735230938; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YR7DLUqAh5NiynL/OaUekwuRjjnNHtNoO7ZVBIB2fgs=;
        b=fbXPtg9LSkXjNGyfjy90Fr0XM+SMrbG6aeN8OPcWFpQfIeMNTxl6mJDmFFQmiPoEgI
         08QVfyXgr1t+q6VUeGp5rowVjuD1zV1fitgkwDw4NxG9imhNSc/WKxAatgnl0rVeI6++
         3jWUBZAuLvur8nMsSp1ZaDVWHBdfpmNRfhySDu7Y6I/Xxd68AlvVs9Vj5yKDO1oPIbme
         J/BOpWM1irzNPaxiSSAOsCb8YZCQ36WfHbsl7BAHSCI6AP2eSqIUcHzWIrFVI9DicFYC
         QEwPjHZGu9aCA7vDzVNvEt2vfu+S5vPm5c1XsJTb/EVpy6UcctFHl+A6KfOvR2eGVe84
         UrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734626138; x=1735230938;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YR7DLUqAh5NiynL/OaUekwuRjjnNHtNoO7ZVBIB2fgs=;
        b=i7OyR7dnGsRL/uEbiU9yo2ARA8OG9LBwAraUwajtPNJ71WJG8skijgeAOJdPpHI5nf
         svoI6KnLaTDETVyzX7Bri0wdbS+dgoUuAJzYVpK1nsuIicBTxppXpBPnF3ALuGDHR+t3
         xMXGIVNEYFg396zpJ+Ax/zjhfDAjw+H7jRphHIc+e/tVdL1Q9wR9RiKYFW6PEq+Qsm72
         X0WB6aNKKEGcG5YYAhajloLE1r+/dbCCSetbhvg+cS0WxwNSL/9wdjg/jpJ/UDcdEnxW
         gbG4i6iTBg/SOd4pO5lPBnMT4c7rXxU6WMNXJK08oTRkcOMTR60o6r00AJuHz70GBeoy
         6pOg==
X-Gm-Message-State: AOJu0Yw+0xH7keChJeg4G829/xue5wKdIg7lg4v921OHYBk4M6mWoXdR
	4rFDa+/wriRPv5UuAIRHGgp7Ma40hP5W8fdR95oUN9JoSIMZ/sjIw/+yGT4i6qcIux9xEXq80Yu
	k
X-Gm-Gg: ASbGncuRqJttRV4WCpaJZ3fWJGC5ZWKsxsRtA0ruHbLYnIoSek5St5dpLJjNFqPM+ch
	dbLuQfuSrDx8VNpS9B5Fe42cFl/2TTxeXcx9UQBuCosZ/POHz654K0pBKRkQm+oQkJoAMMD0Ssb
	6hB7aMF6Z1v6hDjGVsD5Ns66w2XYxJENvOx1mLyjWCGQTP7/Nl69JvOl24WCtgLSt3zutQWXaoR
	+5A0Mkahii72tB8zNbRvkmUalK+B27pQjOi2BE/kuzZhZWmuXCr
X-Google-Smtp-Source: AGHT+IGCul44ZQ0gnRsWVryasb8fsrn3LhS5bA0vb8t3jRbCpK+n0v6SMHJayn3jg3gpGomxfe9yUA==
X-Received: by 2002:a05:6e02:2491:b0:3a7:e83c:2d07 with SMTP id e9e14a558f8ab-3bdc1845c9dmr67030935ab.14.1734626137984;
        Thu, 19 Dec 2024 08:35:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c199a3csm357079173.93.2024.12.19.08.35.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 08:35:36 -0800 (PST)
Message-ID: <79bbd300-b8b0-4fe4-9f56-1309c4aa5374@kernel.dk>
Date: Thu, 19 Dec 2024 09:35:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/register: limit ring resizing to DEFER_TASKRUN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

With DEFER_TASKRUN, we know the ring can't be both waited upon and
resized at the same time. This is important for CQ resizing. Allowing SQ
ring resizing is more trivial, but isn't the interesting use case. Hence
limit ring resizing in general to DEFER_TASKRUN only for now. This isn't
a huge problem as CQ ring resizing is generally the most useful on
networking type of workloads where it can be hard to size the ring
appropriately upfront, and those should be using DEFER_TASKRUN for
better performance.

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/register.c b/io_uring/register.c
index 1e99c783abdf..fdd44914c39c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -414,6 +414,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
 	    current != ctx->submitter_task)
 		return -EEXIST;
+	/* limited to DEFER_TASKRUN for now */
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
 	if (copy_from_user(&p, arg, sizeof(p)))
 		return -EFAULT;
 	if (p.flags & ~RESIZE_FLAGS)

-- 
Jens Axboe


