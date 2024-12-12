Return-Path: <io-uring+bounces-5460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7474E9EE504
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 12:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 347CE16653A
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 11:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4EA211714;
	Thu, 12 Dec 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XY5q5ZLl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5F211707;
	Thu, 12 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734002962; cv=none; b=RJ6BiO1TXkWpJ2X9TtQr2k3H0roEcamAuLRKZJrMdf9fMrfbzio47KUqAY/ukR9k3LpbxcLMwl5AetntveZTmtummhwEl1+HDsI6CiA0bEOl5Jn++L+Z03d6IzWy2Iq2UPGowxVKRIQ8zWj8ORL7+8EiBfzsDQnguBihMnHEITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734002962; c=relaxed/simple;
	bh=700lfuz2Kata6V6/0ly9UbNGRZKHY5NoAzOVFNTxBY0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=OZv+vaPCivsdp9CoWDCeBDR0JF9e0MxmPNMoYv3IfFrbOSr0PbYs5XDReum05dvDjJczUFcGJsq/3WYVmrtsQnai+WwDjbPGUM4xCPRjICNfTV7KeV1N4bF5QGWFZidAGtJITZ13a4oxdEtDp5MSHPFqLAzK6LoJasxK0CaenL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XY5q5ZLl; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso73116766b.1;
        Thu, 12 Dec 2024 03:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734002959; x=1734607759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNFc/twScpRJarCe0d/1m4PY3eXbJrI15huGien/OIo=;
        b=XY5q5ZLloT/OmjrqUXjbEMyJYJNmEOFIJxwWhmbVk+yYzvVerkQ58zOGnOZHacStID
         kB4Niye+sknlnbhOeRbXhedetrSm+9J3Z1pu7ckSKQ4cIbbzu/hLqgFSDJV8DrdzSMmz
         8CiFvVC8381yHUSzZyqi7+AAUPp7qHAYq1bVsfh+uLlJ3DCCK6z8xFrEKdNj2sI8wyxK
         zws8XVJhzvdevdlcv0tmfKB/BDysvGjSQgv7apeRPI5Nqa3cuuF9pRg6zzskl5KXfSH3
         JF/UAlrL9xS3CuTy7OfKoxZd7sK8sKD30KLJ2JzofGuLi1BwgZDA0U05KO7D1a2ZiNF8
         NaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734002959; x=1734607759;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNFc/twScpRJarCe0d/1m4PY3eXbJrI15huGien/OIo=;
        b=VqyDJ37K19nw3hoVdUYCiW3AW22s6aan7REK4qGzUNG9616l8wYqcTWPtfU3zJP6/n
         qWo+RNvdJVvejfAojfVFy+GP7NBCEToHrhgWMeK+49HUIIN2yXT/9WNd6oA+HWLcF/lg
         7VX0cy3eF0FeshyG1K+ZHyz9YhiN82sDhINTPFlCcRPLAL1XeMdN1+GI8dRRHvw1zbGk
         zoDB89bWN0+uetV5EEaBRzxYdpT3oGzJfp6Vo3Iu6G4zv0eMNdhxs7LtRt8lFV2pNLZj
         YknlrTiMDmgZM7n5nv8jl0YP4Cb6GwSYBkMSDJeFSSTbi50iz0x0+FssxA1FHDK2G/0O
         DhDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8mrjrxAaPQEsvBS/YnvVRzJoKwQig2GRjb7S0EhG6QUcEHUn8Ha/8uIbpqhD8zkBLOsuaCncHCTFCQy/+@vger.kernel.org, AJvYcCWWSpKaGa5Y2xI4ULqSt9wyWeUI2TiwAo583KRudO0qMYDg6tUitT5ax6L0PYBKLKmdc++RX3D8uw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpxg0mXBFjxRMKMqJcGLqlQp5uAYok1qyKU6WLy3B/doBcYdIX
	FJ1/m3aBACP8+it/CzZ2ThsgC8/8ltQ7lULoYCIQNJAWKSNSDa0r
X-Gm-Gg: ASbGncvsjtJGKnNzQG52Mqrjk5cewGERxGnnv7OwmDsXySAP8Q8wD8xBVgwhnfGOr7S
	KfJ4iw5hYfjIqHfWXopqV5kJ8FAIBx8BkppnNNyNQ7mkgm6B6bNYt5Gm5M0HZuiWLNtWaFiN2df
	nJcLgFONutbfnXBjLW8+hPkiEy1H2ivrkm7qD8tvADLn9uuy/PQ4FB8P+08du9bqgGzVxOZvgct
	LGaPeMBpx/AdMkq16lE03I3guoit5Xl6xPKbcvM+aCyycyLZzCt1DPbSblg0yOeLXA=
X-Google-Smtp-Source: AGHT+IEHUcPQRcDT9i0//UKDwYDXJAjDBxA4AwbXvWkKrF0tFKivjb+tcOsZ2ZLKTdsIRabjbfFaGQ==
X-Received: by 2002:a17:906:18a9:b0:aa6:7d95:f70b with SMTP id a640c23a62f3a-aa6c1b23c65mr362890466b.36.1734002959041;
        Thu, 12 Dec 2024 03:29:19 -0800 (PST)
Received: from [192.168.42.68] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6996487aesm470292866b.12.2024.12.12.03.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 03:29:18 -0800 (PST)
Message-ID: <b5a0393e-dda8-442c-be8b-84f828ddcc51@gmail.com>
Date: Thu, 12 Dec 2024 11:30:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] use-after-free in io_cqring_wait
From: Pavel Begunkov <asml.silence@gmail.com>
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDQ7TcKn8gz8_efnyAEp1JvU1ktRk8PWz-tO0FXUoh8VGQ@mail.gmail.com>
 <54192dd9-d4e6-49ba-82b4-01710d9f7925@gmail.com>
Content-Language: en-US
In-Reply-To: <54192dd9-d4e6-49ba-82b4-01710d9f7925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 11:21, Pavel Begunkov wrote:
> On 12/12/24 10:08, chase xd wrote:
>> Syzkaller hit 'KASAN: use-after-free Read in io_cqring_wait' bug.
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in io_cqring_wait+0x16bc/0x1780
>> io_uring/io_uring.c:2630
>> Read of size 4 at addr ffff88807d128008 by task syz-executor994/8389
> 
> So kernel reads CQ head/tail and get a UAF. The ring was allocated
> while resizing rings and was also deleted while resizing rings, but
> those could be different resize attempts.
> 
> Jens, considering the lack of locking on the normal waiting path,
> while swapping rings what prevents waiters from seeing an old ring?
> I'd assume that's the problem at hand.

Were users asking for both CQ and SQ? Might be worth to consider
leaving only SQ resizing as CQ for !DEFER_TASKRUN is inherently
harder to sync w/o additional overhead.

-- 
Pavel Begunkov


