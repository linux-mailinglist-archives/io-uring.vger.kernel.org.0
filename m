Return-Path: <io-uring+bounces-719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0628C862D2B
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 22:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 731FEB20A18
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 21:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BE91367;
	Sun, 25 Feb 2024 21:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OieyayzJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DC911C94
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708896820; cv=none; b=K50c1c/JyM+zSgPMxluf/q7QEstEmxggpRNpD+a1ZEDgvdF5xQ0Qj3+ITGrEjv32cFHEMHW6YVsEMm3Ix2p3UJy2KnXa4JTxmcCJB6XT6iW24+nRdb4jdIS/do4N6c+8lS4ZOoIg2us9cirSJYFn7T6Kv60it/gajpdTj1CntNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708896820; c=relaxed/simple;
	bh=FatHeajF4Kb3kRHBH+ii2gutCWexuQz/nam6X+HAGvs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=RqWdL/rNmfdKm87XlOE5SzrexCx31xqYzTRnZ5vq5tSOg9OYPhFf79vQE88PZWHN5wGTlXcjJWmqAws98cD19n7fxyTSNmiGMV8cX8d88Zwwm3yoHlH8i+5D3DygWA+b5GGsxvPcDK7Tz8eX8EtXrzIe7Cm668wRrpWgEuXLclE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OieyayzJ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-58962bf3f89so1015280a12.0
        for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 13:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708896816; x=1709501616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WmGlu2oTlxufRVngGBMEDrf60IG2kSJI4mrZSNNRKsg=;
        b=OieyayzJOIqtekUGit7yTDRbtEpUbt58y8QkeFsG4c8rmzIswI8dh84OEibGLOe1bH
         Xkzf9McCIVXW/dpMYY10uWnb7otLgpHjTHiqB0HdR9kPqDKbX3gaW/eCc3JX+iCv3PIS
         NwR4uM+aLArcYfqyotdu+xAqojVTvc4u6EhENYJmJCIuhYoEtz1Qf8lBHhVeOr87fYrN
         4GooZu/1xjvW87jxiWWTXLNkBxBJeSmA+N/rhse5yBQUMGwYrOOyYF4/fNJ5v0f4oR8W
         Yd0WWanb+s+VFGLMnx1sQQe1xRapCZZQx0sYWwp3OyaJnjIefNwG1XVL2Y8IxmOOKShT
         F90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708896816; x=1709501616;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmGlu2oTlxufRVngGBMEDrf60IG2kSJI4mrZSNNRKsg=;
        b=pk7sjYHKME+2pXxFOVHo4b8Atzu4aWmMluMdxPAupQpAJ949mLxqzyIWQtHAVpHWhx
         8dBtEfRUS1Sr/dcrrjQbMZd9km+ODKTcilrfuJp0rzwrpDZX8Q3LYVOtGKU5u8UXZC7Y
         nDA7n7ov3F7bBvrv68/aGctSC0ltc9zTru8LYQph8o+wrD6OUlup4ffrdYj5wmD8VYvW
         kmNJy4rLqKiPazfQXGmt2Nb93QwAh8Ma9uY7YLf7unWKs9QVM/sf6X3TvxYQdWgeonwh
         C6/Q4J0CelmuObx0gSGz7RRU0fNRwnfnBGv3XuaBNXFZlguDLMCfXWAYEEbhDn5EzNKE
         ak8w==
X-Forwarded-Encrypted: i=1; AJvYcCXll/mGsNNftZOAnHp4sALLEmlnIS6Lal96aZ8jfueP2kjz18za795iD321L8R9kPoZm0kJWnK2GmABzq/I3OWc2bPNq+BkXI8=
X-Gm-Message-State: AOJu0YxvNyvTXbCl1ac2cm6/qU4hWGKLLw8YSiZ44QHucZoTXkMTz8Vz
	RY3vyR3vaX8ylUnAhrgFMau1dmifmpi7MMamxCveUGlx2K9/J91z053zHS2YDglviD77+jmdIGc
	e
X-Google-Smtp-Source: AGHT+IH55ct043Fx2LDwC09CxvZt5aKI1Y2QnaQTSKeT1CmvziqlWH1Sa0/0cs/WP4I4OsBXaBhfUw==
X-Received: by 2002:a17:902:8d85:b0:1db:3ee6:e432 with SMTP id v5-20020a1709028d8500b001db3ee6e432mr6153014plo.3.1708896816618;
        Sun, 25 Feb 2024 13:33:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e17-20020a170902f1d100b001dc0d1fb3b1sm2610610plc.58.2024.02.25.13.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 13:33:36 -0800 (PST)
Message-ID: <0be7ea7a-12e5-4967-beea-279fa98f87cf@kernel.dk>
Date: Sun, 25 Feb 2024 14:33:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
 <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
 <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
 <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
In-Reply-To: <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/24 2:11 PM, Jens Axboe wrote:
> On 2/25/24 9:43 AM, Jens Axboe wrote:
>> If you are motivated, please dig into it. If not, I guess I will take a
>> look this week. 
> 
> The straight forward approach - add a nr_short_wait and ->in_short_wait
> and ensure that the idle governor factors that in. Not sure how
> palatable it is, would be nice fold iowait under this, but doesn't
> really work with how we pass back the previous state.

Split into 3 separate patches here. No changes from the previous email.
Tested it, and it works.

https://git.kernel.dk/cgit/linux/log/?h=iowait

-- 
Jens Axboe


