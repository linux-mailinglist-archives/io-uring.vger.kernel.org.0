Return-Path: <io-uring+bounces-4387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6449BA9B5
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 651671F218FB
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65B4800;
	Mon,  4 Nov 2024 00:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yk3Igf6A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19081382;
	Mon,  4 Nov 2024 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730679234; cv=none; b=CwyKAnS4oKHFvHV7CZgoLo4hvk0YxAlYxtkIJkHliMnfabf3ja2R+D9tKF8cKeCzjC4p3aqylFmfAIHzs6103b6UjuCGiK087dNmPhkl+NdjZL85/0O6Q5fBm5QNV8UzdRma/4eUWZkCd0Cna6dbkNqF6iiupqdXc7IFxaDFTEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730679234; c=relaxed/simple;
	bh=V++SIrL4pMEI5pNUJcrMt1+JJeKlvbC3HnCBqGa7ds0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dEAFLCvLGXhif4mSlIImS7k2ill9EA0rq1dilNMHwejSS9lduHGRGzX7APEvzQzcHdBopb5KPGglkvC1sCfOUcWlddWYPPVQzhyuZFNqEzeTlByobSQ6j0lbGBFGAscRZDeI2VBm06MdvPOMbfJmDqo+fvVcUeLcETNq/zc32aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yk3Igf6A; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4314f38d274so45272965e9.1;
        Sun, 03 Nov 2024 16:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730679231; x=1731284031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qHtR0AfGexz+ECaBa1rWLsytx49UMV+ptX5eA/FmtyM=;
        b=Yk3Igf6AFDcgb4TiiUDwxvxcfCEfGG7ntI5NCocEiqWCGXMTurM353uTTrPIClYSgZ
         BjuRb+S8WD2YM8AxIaIb+b8KEnkhmDaAQ3a9EcCQYaECuJtc0vt9fwRaCKJuWEkJ/VY9
         Zrfjs6ZcKuiMhprrLOMb+Y5v8Q07nYj9QkgfcsWWX+606q6HVrcu0sh76FFbeS8XhZ22
         vc8sSuJpyQZzZRvUiAHJfyTDe+KlfBBBatdxLi2GqY+puWFdcqRrF7JjEoJc2+XSIN/I
         T0ZbjjNccItstKKINAgYQrsQpEs0Hfrv04x4AGdH7NW5na4H5lKN1kub5QOBUci0q8u2
         591g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730679231; x=1731284031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHtR0AfGexz+ECaBa1rWLsytx49UMV+ptX5eA/FmtyM=;
        b=rF6YSvhdiMc/IBY6cAReCX73NtIDqDWOAkIcUOAWmpGJJrEVOL+sj2ExXPnEkijiWb
         90S2ATYIJ3mpsBn0jVntjcqAZNGh/dg93ytcpmSRCPLVj8G22LB37RKeX6OgM/ndq9Ru
         qDD9CHlwt6t2Ukmt/EdU4Fe/8jOIIJtLd3ydCyWu7Biq6seH6NZmBWSfnOtM2O+9zLGX
         LXGtJoTMi6fwVI1A2kmCUhhpqi4BnaB4vrDHbqsQuNOXL0NaVJi0tGHZbnNX7hky8EvC
         x6c+tzT4lR1oH6WsEUlIv5K/i2ZK4QbAjheR7KUBVjbvp2Qgxnzlbu46/7tYS9Mf1dYw
         Pc6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdRWO6FXzzzDpu0zklk637PepN8PNhEVdrTcsIC17mow9n3geVSEwsyNJjUTiywdJFI4ZOnzZBxWiK1w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+y2I5j4aoPmXHvwlzBH6tN4Acz4N07R5LBPsI0C9MbQiJPPF1
	wRRDwZwhjxQ279DTMWJodpjzaQxo18/p4ORLcCJC4LYm0g332NeH
X-Google-Smtp-Source: AGHT+IFWaY88FKDr62Jz6iapJJrl387wL7YmSC/0yid8IHAKqK3QFl/b8mcZDksathVD+kVP7aFJGA==
X-Received: by 2002:a05:600c:a07:b0:431:4b88:d407 with SMTP id 5b1f17b1804b1-432868a5b83mr98239235e9.5.1730679231335;
        Sun, 03 Nov 2024 16:13:51 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bb78b809sm186294235e9.1.2024.11.03.16.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 16:13:50 -0800 (PST)
Message-ID: <35cdcdbf-aebb-4928-9ebd-e5123881c116@gmail.com>
Date: Mon, 4 Nov 2024 00:13:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/cmd: let cmds to know about dying task
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org
Cc: io-uring@vger.kernel.org
References: <20241031163257.3616106-1-maharmstone@fb.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241031163257.3616106-1-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 16:32, Mark Harmstone wrote:
...
>   struct io_wq_work_node {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 39c3c816ec78..78a8ba5d39ae 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>   {
>   	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> +	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
> +
> +	if (req->task != current)
> +		flags |= IO_URING_F_TASK_DEAD;

Actually, the patch is broken. I have no clue why Bernd changed
it and left my name, here was the original:

https://lore.kernel.org/io-uring/d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com/

also now it'll also conflict with patches Jens is queuing, I'll send
a replacement btrfs can take.

-- 
Pavel Begunkov

