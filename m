Return-Path: <io-uring+bounces-10328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C065C2DAD4
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C7A94E0EF5
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8E6310625;
	Mon,  3 Nov 2025 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ukNjzSjM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D257328CF42
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762194575; cv=none; b=Z2cabu41IiR1XfntrOJ9SGaT/9UE6WFSNjMhU+U2J/HvZP5UfIEuHR1N9kZwvKU9nQFvyAMWF1NaV6+CKzb5o79ITb/cDJi6HFyw55wY9RJJukZeAo3Q1mozN31ldakYFBlyNRkukx0e+5U3CGAsyfTXdr/QEp1ENVXJ2b06h+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762194575; c=relaxed/simple;
	bh=wmAoFKWLR75h67tOzpzFWAsENGf3eJMEMC/hDrfVXjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzleMIJ+KkTQqpNlDDlbvd0YXnN/nSyBYvpkswVtZxBHyfdmr8VGCpzpio6ei9AgD8VoaynLkHnILBnS7hDQon059yVVgeEE0kYCWam4IRvUzztANFimgbTTpD8FVbrdFMqIySolWt1jqA0tkc9F01rk8d0JTsrv7UgwVdCvipw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ukNjzSjM; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b6cf07258e3so3046073a12.0
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762194573; x=1762799373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PitSUlDm1go9vcuGwrxc/qigK0RG9QByQoNdiaE+6vo=;
        b=ukNjzSjMp8FXrdxXksyuuuTwyVobQBLBdIuqVY4PVD8hRIiSVhxXtfN/rGbg5mPauc
         9+QgzcYCiScNDOeciF5E10LcP9P6z5lluX3sNpf7cpWE3ev+JQHMSwgRPOEU0hHejdvX
         MpaQoLYHZwJFtGldxlQRPCI798l9eL1n6tarvNCTsV5S+r2qx75ay5OWHQ3L5IZ0fKPr
         B2jJKUi/4ii6lDq0m3IaPAmcE7Jtjeg/RZTK1TOghh6Js0bolulbvcRCnxyYUUUR7Bvj
         3kvFM7HiIaikqcmr8FeG822uDwNnIqM7PD4lwC/4nR15qxTKt/eSaMDStw+4iEut4K7T
         YicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762194573; x=1762799373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PitSUlDm1go9vcuGwrxc/qigK0RG9QByQoNdiaE+6vo=;
        b=QJSSG+uxH0+LejTqJFYqFh537DyOhzoQtryrtqX4Xdp2TV+o+iXFVU20q6HRhNRR4b
         rEVwh2cFQyM9CZzwh7KdsRdx4NFuaFYoxeErX4ue3Wx55fJ0A5kHKh0vYdvjz42Z2aGk
         bcEkq1q65VmYYSoXxbgsHXczPw7ZvGKPZ+yXHrXwR02LUibO9qeYVr7CzjTI6MTYLVFk
         hIXg44ACf/4aWNYz9/wPPL7Pi/Z5y+SVadTBa8qiuBbJpaqUeGVcsHoDRIjiy8/6plR4
         5k4fWK2s4JwFWnhImMEFi5Zq1DZXOF1LgosglNQDXw6aDYzN6aXkK2rBKF/vCIk0fSzX
         /hYA==
X-Forwarded-Encrypted: i=1; AJvYcCWAgV4P5nujErlQpglsaScg6+R5eeUqX3TnYRILInBYcKwj47l0ipogrLmbV1M6TSKU4gb2B4ZBvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMxzz4VW5pwnP439N6LD8kOHrwazDszbCksC39TBbhNoh/GzVb
	71PBpk7tRFITsUwTxvN4JjJ/1rAPcpJF7Rna7fl2p1uM7HliEs7hyOCN91fQO/k4Gtk=
X-Gm-Gg: ASbGncvlRwApPX8tDqC87Xg58JgrpjB7frq0caCdV8Zb6HtW8hDTqekh3ujytnUvWGq
	y+lLNOuO/aX/9wpr0p9RTFWIBdhqBP0pgek71A7FBbO9TzX7zTyByaye6kZ0mD6nNxJfLWOp6pg
	e9Z3MhDrDGbkhcVRcoLqoJGlUMBw0eWtpaxIZIeGw7wH8OQVewN1vDjY3dLTVAksMOG19LKX5/1
	DO54ULHnE5sTO3SLHOTlPA6rc0bamz4ZhgUoNJvuM/C7y0PeXHLCqgj2BuM2sOtp2LNwNpdTMXD
	FACAX83W10lx6EaWQrMUHFmbPfUM3iZx5Ba3KWY7eMbYOW8hofOveQoQWNvU96TbEUQcEg4ssro
	TtKN/d6T8tT7Xqh9LjYgA13jlKNgeJpioT4dsbFOGqE2va0CS3Foyp7nBq1KL+MDnqqd7cRQiyS
	VpX5s8PsqoKWxkoAQg8nK4x0Aj8rXhAqMGTlW0Jxba99ppmqW0fw==
X-Google-Smtp-Source: AGHT+IGW2nkRcJ3o/X5DXan+YDTZlhzqN1S6emKnORTiA21dPoo0N/2D2LoJeQBefEjC3aZZYzoH/g==
X-Received: by 2002:a17:902:c40f:b0:295:a1a5:baee with SMTP id d9443c01a7336-295a1a5c06cmr51543855ad.4.1762194572902;
        Mon, 03 Nov 2025 10:29:32 -0800 (PST)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952699c9dbsm130124765ad.84.2025.11.03.10.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 10:29:32 -0800 (PST)
Message-ID: <1f708620-303f-4466-b248-3490a8e9e424@davidwei.uk>
Date: Mon, 3 Nov 2025 10:29:31 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251101022449.1112313-1-dw@davidwei.uk>
 <20251101022449.1112313-3-dw@davidwei.uk>
 <c374df85-23ec-4324-b966-9f2b3a74489a@gmail.com>
 <c8d945a3-4b12-4c04-9c68-4c5ad6173af5@davidwei.uk>
 <7805c473-448a-430c-a53b-a42e8d2c24bf@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <7805c473-448a-430c-a53b-a42e8d2c24bf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-11-03 10:21, Pavel Begunkov wrote:
> On 11/3/25 17:47, David Wei wrote:
>> On 2025-11-03 05:51, Pavel Begunkov wrote:
>>> On 11/1/25 02:24, David Wei wrote:
>>>> netdev ops must be called under instance lock or rtnl_lock, but
>>>> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
>>>> Fix this by taking the instance lock using netdev_get_by_index_lock().
>>>>
>>>> Extended the instance lock section to include attaching a memory
>>>> provider. Could not move io_zcrx_create_area() outside, since the dmabuf
>>>> codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.
>>>
>>> It's probably fine for now, but this nested waiting feels
>>> uncomfortable considering that it could be waiting for other
>>> devices to finish IO via dmabuf fences.
>>>
>>
>> Only the dmabuf path requires ifq->dev in io_zcrx_create_area(); I could
>> split this into two and then unlock netdev instance lock between holding
>> a ref and calling net_mp_open_rxq().
>>
>> So the new ordering would be:
>>
>>    1. io_zcrx_create_area() for !IORING_ZCRX_AREA_DMABUF
>>    2. netdev_get_by_index_lock(), hold netdev ref, unlock netdev
>>    3. io_zcrx_create_area() for IORING_ZCRX_AREA_DMABUF
>>    4. net_mp_open_rxq()
> 
> To avoid dragging it on, can you do it as a follow up please? And
> it's better to avoid splitting on IORING_ZCRX_AREA_DMABUF, either it
> works for both or it doesn't at all.
> 

Of course, follow ups are always my preference.

