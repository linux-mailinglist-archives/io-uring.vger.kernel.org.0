Return-Path: <io-uring+bounces-11002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF64CCB29AF
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 10:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4A063005ABA
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A80F2FFFB7;
	Wed, 10 Dec 2025 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yy6X1RBs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC582DC320
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765360420; cv=none; b=T7hVf32e6BGNGkWNLNT779YcNQV6GosGemoXpeuxx9oojyMX2mQRfCL4rvvnqJ/Bx0AuiayLcgOTN85J0zZlaWyQUw3EJccr1llAOOh9uNzxbOuWOihcBn9XAYz0IgSCnhy7cN57igpoXv4eiPjYjxo5OHqoNNV2Jdrdi6rcSEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765360420; c=relaxed/simple;
	bh=4CHI7HqFeUWMmsh3q4S7r5uP1l8B0C9u+I4+Pf5zwu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O7CA73CoX3tYUmVor3+u+9Yab3t8laoQ6afj+gKxnrnzhaHRor0F4BzzVWyNjOHNs+beWImEiu030qHK8i8YteUp3q9xaVDv5qQ4CAK2YcTBNILFys3MEaDnI5EN4yZ4t0VolDe+WPg+C3RNuuXAvn6sZiUi7h28dpYt52xdyZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yy6X1RBs; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso7587677b3a.0
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 01:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765360416; x=1765965216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gCtCB4XMM8XAWNztg7b4oA42c8brRq548BRBxP89Yk=;
        b=Yy6X1RBse1qrq4EGiRZ7bCgxodnRhO+aD14H3PTNkv0tm16Up6JXIsC5woNP9s7vAs
         q7QJlPCpQU/KPMC79tDy2APULASRoOuKjD83wFHnhdzbiJl8rCkWbNnlqd7nELIhYZ0I
         +Ov5LgJT7FgoW84iSucbHqxw/62xNv+J4BPWjQwZNq6O15QwexdReh55NmkMFkmVqpat
         G827QtzlH8aqXH0OzOST8GDl9wkJ5uGDM/wQNttVyK8bsidVtgu1ERNQEFfIrzMScOEV
         dMPhoJUaMH1kIUE0pAS6K2EssI/s3JFogxdWZDjmi2DMD11ugZhgsFOAz2rNKFmSnvkg
         sKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765360416; x=1765965216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+gCtCB4XMM8XAWNztg7b4oA42c8brRq548BRBxP89Yk=;
        b=xRSfObHOJQob7pLgzjFYg9MsKDAakR8UbvSmKm2PZd3d39ZjG/T177V3Boe2vExwQj
         x4zOjps9AIlUHRvbdY3+4h4q/zZwYeikZO4xj2Uv806z9/MCGo1mybvEFg1/7IWJT8Bg
         9aIQUwxj4Ck6KrQR/RsO75eyul3LLNii7ylXR88mwMIWWHtJIsJ6p5VG/Ehp0eH1sv/I
         yYHg6MgoVfyjuB32r5MZug4fxoEeRWejfJbkMjKCV5NrmUMPk/6MWCol7VnW9ET+foiJ
         OGGpICttW1aqTlbQ4UwOoGZlixEf3U2T0ms7gLcjaDZNKyO1ux70NvuM7Ad71Mmip4No
         ZhBA==
X-Forwarded-Encrypted: i=1; AJvYcCVuirml/HlvUySYXo8bEzpO5yu1cVKjjBeaxfSGFmancD5W/68MmomHSmgxMeGLalv+PhTliG7v+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjl+b2YAdWIAF5Ruj+9lXLtQrwHFpTkaTcN5EpcHkDJT9Xqnod
	cdECeKB3HhM4Cb/n8T3D6HxHd/MvN4BTz1T7ZjuLkydKJ5LoD8IHUDYpizV7tZYnFJIBot5uNFW
	bcK+j/9F41g==
X-Gm-Gg: ASbGncuRtdB4oxeNeiBfn7NnLaPPa58Vj+mGl+OTkDdICWf0BDrD2jClqWZORNAEwaF
	G4oWLTYhHQv5B4oIgvrPScsQhAr03sT9ybl/RSR33TrFNnGiNGtykHxEMtrz21FeP9eW9S1YRnO
	i35hxH66fmR7YCQlavVRBLk5d0bdK7BNkLsJR7c+02dLNhWUVwu758ozs+1eCZ7ar0T/T12Slqn
	2m9RSypbJBr9mxqht1funTPGFNvYdYPleu6n0ElY/s72p6EdMlyzVvSO/RpSQWm5UkQhgI0ZpS/
	8H45LP4GSH46tObMqLhaHLq3Pt1Y3KS5o0ttDjbcfP0+uqy2EUo27wNkB90t+Vnk7+LBk70jCof
	dkq+EVinsKLXsKAv6Pdy1mPQ+HWe/o80+qCc08YP1+1BJYKk+V7ixlEHRKn3OatMxh76l7KcPJ0
	KiTDkRK4KDtZwfQXj9HvMIkswZ68SSKbXKi1l9gT47PSRj59f7GA==
X-Google-Smtp-Source: AGHT+IE/gLCaBNmmYTHHaBzUTP8V7UIzPPmbRcUbVJLKuu5ppubvtolQ5S/f5IWm8yJjJxWEDg4N6Q==
X-Received: by 2002:a05:6a20:7f91:b0:2dc:40f5:3c6c with SMTP id adf61e73a8af0-366e2251eb6mr1768692637.54.1765360416440;
        Wed, 10 Dec 2025 01:53:36 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686951586sm17296527a12.12.2025.12.10.01.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 01:53:35 -0800 (PST)
Message-ID: <0278628f-5576-434f-ac67-476adabca29a@kernel.dk>
Date: Wed, 10 Dec 2025 02:53:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] blk-mq: delete task running check in
 blk_hctx_poll
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-2-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251210085501.84261-2-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 1:55 AM, Fengnan Chang wrote:
> In blk_hctx_poll, it always check task is running or not, and return 1
> if task is running, it's not reasonable for current caller, especially
> io_uring, which is always running and cause BLK_POLL_ONESHOT is set.
> 
> It looks like there has been this judgment for historical reasons, and
> in very early versions of this function the user would set the process
> state to TASK_UNINTERRUPTIBLE.
> 
> Signed-off-by: Diangang Li <lidiangang@bytedance.com>
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  block/blk-mq.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0b8b72194003..b0eb90c50afb 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -5172,8 +5172,6 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
>  
>  		if (signal_pending_state(state, current))
>  			__set_current_state(TASK_RUNNING);
> -		if (task_is_running(current))
> -			return 1;
>  
>  		if (ret < 0 || (flags & BLK_POLL_ONESHOT))
>  			break;

Applied with the other task-is-running remnants killed, too.

-- 
Jens Axboe


