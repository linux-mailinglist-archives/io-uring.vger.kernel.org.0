Return-Path: <io-uring+bounces-4004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADCD9AF2E5
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A37DDB21895
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2A4189911;
	Thu, 24 Oct 2024 19:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VhyWKAi1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C322B67F
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 19:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799449; cv=none; b=s+WoDNMLB1G1JP4jcrn3dldRTyhmTscoGJ7dvQsp0TEoMlG/WrHnY0OpgxH7jS4YMfvzo+aw30sW/ub+deDmVWCvEmgYsJIFZj1MJ/Sic/03ro5KQXtjzz4MgpP3FCNel2ttQq0p/PWyyV+d8wnhbOGJpPVM6oICWd5s2cCyjgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799449; c=relaxed/simple;
	bh=HeQLY1YNmSxDp2MVRo2paBCjex/wQ2yGMBpg+xPkL7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwxjXkbwcMiu9IrFFdA/EOMNYHpiA3u54YyRHBXNXhC1tPCciXVDQH4uBNR1aEs51ZMddIYlcRA4kz1T13alnnxU6Gs+uCv2ZLzfCwOWlNi1hDnBPjhZURZHJpRpm6FrMfhL/rOXgppoX3fysT6H25mCtvn1gjFFE8O8c7g2Ejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VhyWKAi1; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83ab5b4b048so56586639f.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 12:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729799444; x=1730404244; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YNwRvfMSB823uDx6N+SlBsOJRRSNRkVGgkXr3XRsTPY=;
        b=VhyWKAi1QHYMxH6GM3KHvKfIHc4bXofXx20PNsn/itelUeFrA97d2n3ZZ2AycEVX2c
         IuXgMfG/C/WfBhCJtGRQLN3J2GadjXEBgf/OrRO/2WLpUgi2o5jKIlmvVp2lrgdXf3z8
         pfzpgjrub45TkyyJ768KaejyG8EPxe0F4rfI+/r2cMmtoTkRDo2UOslISm1M5ccB3sLa
         k+TxCI0KprtkQ+p/H14F9YRfGP10YlYKW8zyd8QhtH7o24nMKNhxlriLoTvPOpbBIPai
         aaum/SPD0MwdOg4Fj+DCKwtVb1675Ncjar62wMQiwBShfDyiDmb7JinVNRuvVciXnEAk
         Ga0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729799444; x=1730404244;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YNwRvfMSB823uDx6N+SlBsOJRRSNRkVGgkXr3XRsTPY=;
        b=id5VKVg1/0bS5jKhvD/MPOU9qlGizmBmgiC7aryeBFucwO3/vTv1HLP8sT46PVysR4
         SiLI06LrEEPg4UXpqA+k/5SoYQ5SVG0s6vIVH74TGGPK7NWLP8pCiXKZqtaY3PcaWMjl
         hG+F6+mDr99MyH4VvoUKuFrV1eGJ1WwvLz1y8cXaYBoK83r5eusLng4hRVlOnaxzAA3z
         jcjZVodybLMXSLLNhi9oF16AAdEbQqSrJydqxhSL8zpkdJqXnIz/7bGxjeaqPE6do0Zz
         v+ZJ1q/34sz66n4vgy3RX32dpcnCW39GZkQLLMnXjYwBaikFlCHR7Lo4SMVaKVbysCPU
         dQaA==
X-Gm-Message-State: AOJu0Yxeur4KKe+stY41RDJSpMWV4MvpPRYuRhTPsY3+IhL5zHgchtLT
	uUfbOGR3wxaaw3A+x4EbJh256HvNfsYA0WS06mZMp3UvxXpeH63WywPp9vBMk5U=
X-Google-Smtp-Source: AGHT+IGsmXUG+zs3PgF7kWrMoT6qAg1AA5ffEeIw21xkm/koXWYIAAgORnaIQPqLb4BA4TUnPOupAg==
X-Received: by 2002:a05:6602:2c09:b0:831:e9a8:ce2a with SMTP id ca18e2360f4ac-83b0401edc2mr365137639f.3.1729799443866;
        Thu, 24 Oct 2024 12:50:43 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a52fa87sm2787176173.13.2024.10.24.12.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 12:50:43 -0700 (PDT)
Message-ID: <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
Date: Thu, 24 Oct 2024 13:50:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241024170829.1266002-1-axboe@kernel.dk>
 <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 12:13 PM, Jann Horn wrote:
> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
>> the existing rings. It takes a struct io_uring_params argument, the same
>> one which is used to setup the ring initially, and resizes rings
>> according to the sizes given.
> [...]
>> +        * We'll do the swap. Clear out existing mappings to prevent mmap
>> +        * from seeing them, as we'll unmap them. Any attempt to mmap existing
>> +        * rings beyond this point will fail. Not that it could proceed at this
>> +        * point anyway, as we'll hold the mmap_sem until we've done the swap.
>> +        * Likewise, hold the completion * lock over the duration of the actual
>> +        * swap.
>> +        */
>> +       mmap_write_lock(current->mm);
> 
> Why does the mmap lock for current->mm suffice here? I see nothing in
> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.

Ehm does ->mmap() not hold ->mmap_sem already? I was under that
understanding. Obviously if it doesn't, then yeah this won't be enough.
Checked, and it does.

Ah I see what you mean now, task with different mm. But how would that
come about? The io_uring fd is CLOEXEC, and it can't get passed.

-- 
Jens Axboe

