Return-Path: <io-uring+bounces-8323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9ABAD73A7
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 16:22:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 439163B4CD0
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 14:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E336C42048;
	Thu, 12 Jun 2025 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="me5AL/mF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1A0253925
	for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749737904; cv=none; b=XpzZ1dQKtOd+CpXnTD1El1aAGM7LNXw58ylSZOloy5fz84y1pC8MbwtAQdsv4eD7mCZSZ2eRTK7AzCwdsBMsn8X/tqSsZJ7ihGTRVLsB7gNPN9xQz7SLyNGPcR7/6LkBUz3u8B4pzlhy8vGfpFFyrbD3Q8/zbM3E+YWkitN5erE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749737904; c=relaxed/simple;
	bh=liZOjN/skN4ViXxZuHQfYn5lZGMP6J7E/huH386lbWA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QxBMZT2aU284KGD12NCvYeooWas6k+2p91kPHudJLGhI2zfY1+R1bI0PvWhb5d7l0w5BBkV7z9GYMMdcUgp2wHA/+e0PA95qaL2OQ+EvJObRu048/ciC+RLx/wHPvVmDqIu6S7czem/2mPrZ+l6leTvYICntigZiO42027XuvVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=me5AL/mF; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddd1cf40cfso4003675ab.1
        for <io-uring@vger.kernel.org>; Thu, 12 Jun 2025 07:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749737898; x=1750342698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ieRVVbbpzyIyxumHH9mgrbkXSdDhm8D2wGY4UAh8eC4=;
        b=me5AL/mFhFUg/V0hWbMiO0VFXn04B1+xNSX4kW/N6tV6VIDkKT8ENhCTwbuv/I5uje
         xGPu215SQUgAWPSs7RbGnYFVGiW9a9wT7PT0edRpAFcGZZ4744mqOCf5YsvfzQMQSPs8
         TxjRwb6+Q146H6pdhyqK6lMBeQqCWRYvElrJlcWrzH+R1Rwk/NCdJK/uP3Jpe6u5TAKf
         /dn6CeDr/QVgvlisnA1gzx4Dokp4c0QfNqIbmAJXhYgPu/gXB5r42KkJU5fLZHFTkUW1
         oPM0gamjmjGnHOZh4OZAYwFVi8xc8PR00PGsGhW2WU63CcrVmcXyMmDeUILMga98tfDH
         2gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749737898; x=1750342698;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ieRVVbbpzyIyxumHH9mgrbkXSdDhm8D2wGY4UAh8eC4=;
        b=ptpqU52THmsLBCPSAwXpEyKeJQm9YVb+80yC3sSWz99kMq5TWE1hzARbYh+FQ3V+aE
         oMqvQVIbmhPY0b8Gq9dIqA+rxI4ySTtjzAvlqt/WK7Az6eSV/m63qM/Du3pQBgwrcQjC
         1PykPd1w4IE8Bgpame4aqxfzaFBYj7jr71/94VSahu59+y+gzeff2ePjEO+HYuqq9gYQ
         7GTO7rHeWNMqVavWJv1Wb7tv+UQw3JrJ200NQM84Mu/jt0ExwUA1XX0PCOHZAPYhhYhs
         eFFW5PjQW5B7IqI2nhboW3cNtjBZdHa19mu/Lowv4K9CUnOpXiLoTWtJKWadjqYg9pe9
         uZfg==
X-Gm-Message-State: AOJu0Yz6Hqt1Ow1DfZkkZ2hUV8noK1bqIjKoPQ29eqGWImnd8NHYU5nR
	6VEIT0SZBJuCJqr0+AsAtTo8weyfHKpGXINvtREE8UxwF64QvuxFAanmpGFB5rSdlcQ0ISKJ5GM
	lp7UB
X-Gm-Gg: ASbGncsO+BjMpb4p1uTyD4YzfZfHiQOFxzLefJ1GmehCzP1YjsqisIALqRK5gB8lVKa
	y2comr/v4Qtgaf/gbK3oU8XyW7vNaGB8PLaRzUnUS34e+8fIlolVNly8b/EaYv1ekkwXobUHh+l
	gIbtLhOp2WBMz6J9N2rIE/JKHkpnxao/j/X7oy6RarTVYNmnk9j4TTrxBoFfohNoNEVpjOPI/b+
	Wrt83t0nCSf4A7Zc2N7mFXGcxXnlYvPnrdW+9nMjvsMRxu+rnc1ypmdZTiVHrMNeND4kAL5rqcz
	YgfQRX6hQ0uQcWWSzZnbYTRMYNPEi/AOJquHt/UpL3VJFBEib/7LkiBdXW7LJUqLhs2FGg==
X-Google-Smtp-Source: AGHT+IGtQE59cTTn1l0iXEsnFfFvc4o/vTQiTwlxVmAaSIojMCLRZMn7idkRWDm/qi0ZnVohlGTzDw==
X-Received: by 2002:a05:6e02:216b:b0:3dc:7cc1:b731 with SMTP id e9e14a558f8ab-3ddfa78b3a5mr40040925ab.0.1749737898299;
        Thu, 12 Jun 2025 07:18:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddfbaf9cf7sm4343775ab.62.2025.06.12.07.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 07:18:17 -0700 (PDT)
Message-ID: <8df4ced5-7c26-44f3-b2c3-a0ee1e337ebb@kernel.dk>
Date: Thu, 12 Jun 2025 08:18:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] io_uring: consistently use rcu semantics with sqpoll
 thread
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Keith Busch <kbusch@meta.com>
Cc: superman.xpt@gmail.com, Keith Busch <kbusch@kernel.org>
References: <20250611205343.1821117-1-kbusch@meta.com>
 <174967568374.462788.11409454167475921556.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <174967568374.462788.11409454167475921556.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 3:01 PM, Jens Axboe wrote:
> 
> On Wed, 11 Jun 2025 13:53:43 -0700, Keith Busch wrote:
>> The sqpoll thread is dereferenced with rcu read protection in one place,
>> so it needs to be annotated as an __rcu type, and should consistently
>> use rcu helpers for access and assignment to make sparse happy.
>>
>> Since most of the accesses occur under the sqd->lock, we can use
>> rcu_dereference_protected() without declaring an rcu read section.
>> Provide a simple helper to get the thread from a locked context.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: consistently use rcu semantics with sqpoll thread
>       commit: 89f607e88c9f885187a0144d0b540fb257b912ea

Folded in the below, looks like that one was missed. We should probably
have renamed ->thread to avoid this kind of stuff, but oh well.

diff --git a/io_uring/register.c b/io_uring/register.c
index cc23a4c205cd..a59589249fce 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -273,6 +273,8 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
+			struct task_struct *tsk;
+
 			/*
 			 * Observe the correct sqd->lock -> ctx->uring_lock
 			 * ordering. Fine to drop uring_lock here, we hold
@@ -282,8 +284,9 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 			mutex_unlock(&ctx->uring_lock);
 			mutex_lock(&sqd->lock);
 			mutex_lock(&ctx->uring_lock);
-			if (sqd->thread)
-				tctx = sqd->thread->io_uring;
+			tsk = sqpoll_task_locked(sqd);
+			if (tsk)
+				tctx = tsk->io_uring;
 		}
 	} else {
 		tctx = current->io_uring;

-- 
Jens Axboe

