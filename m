Return-Path: <io-uring+bounces-383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92BAB82A051
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 19:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0F6C1C20B57
	for <lists+io-uring@lfdr.de>; Wed, 10 Jan 2024 18:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33084D584;
	Wed, 10 Jan 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lyVtLBn/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037174D580
	for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-35d374bebe3so2010435ab.1
        for <io-uring@vger.kernel.org>; Wed, 10 Jan 2024 10:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704911710; x=1705516510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j6k+ge/Y7eNmieyBVc7Hr7rclzJ+YEiEF0K74wZsOxc=;
        b=lyVtLBn/OZncjLNhEcNJEswvud3uUyCOomXL9TQMA5dJg8f1yr+zY1r/1tkAvFL2oY
         SLrmOTcALJJnc/vwpqBtEovQNuc22+KI1rVJP+wsKthd0cfKRbLl9rEGX91Y46eXHz6W
         yruZ/vtYfRxEqC+vKCX1/I42ZajiK8w/NsaYtGvsUe43td3Da9EPRQKQ5Cd+/jbW06YF
         LoVlTk2bOgzSynjsVwNJ5XrnlgvWhFZ9YmBkc03fOoXUxReFFKVSsDM5O1//KbvHwoV+
         xILqU75/v2GxncTpZzO1mfwAK+GY4af49iuL+HGMwVavOIOW8NNhiLrAW1qDIxtLtSXK
         2rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704911710; x=1705516510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j6k+ge/Y7eNmieyBVc7Hr7rclzJ+YEiEF0K74wZsOxc=;
        b=qiudpHqDeoZaH/BgeIvNyE1UpcgI4jlhi05qC4VAcE1M9W00HztVUS4iXl0N5rg2eA
         sk8ppp7K06w0jzBAG+YpNvaIDKDvh5V1L1PpAlBi3v7RlyteVftdfJCggiBi/FUbu0eN
         wbaWz2rbI4N/NOaGPb51zdtibqGZRHboenTCn+ttasLKQXjBDfNYc7if3S2I1Olxl10L
         Out8byoH7rMb08EX9Y96ktAD1apDiOl9f4dkdxe3KJ2+CZfQLZvkNpqBx7eCdu2tAWkW
         UogvBXDv1xreuE7w/6Jm0KATG68Kg/daHwTP/+MweRMj8C76RhNWFWYqo65cbAd3E0/3
         7buQ==
X-Gm-Message-State: AOJu0YyP7Pb3PVzgvb+y1C52CtIZsjtSuQ23vDBOhjWUWy8mAmAVykvU
	iUiPY/Kz97/Ac+ZxfA5skZP4LNZwEWKKfw==
X-Google-Smtp-Source: AGHT+IF3R9jP5q3s9NFTShv6tgY95thgY3nLlxzA/Y8ttLZa57jyz1oaNEMhuKo68WzfYqSWl9WZ+w==
X-Received: by 2002:a6b:c810:0:b0:7bc:2c5:4f6a with SMTP id y16-20020a6bc810000000b007bc02c54f6amr9675iof.1.1704911710022;
        Wed, 10 Jan 2024 10:35:10 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id du8-20020a056638604800b0046dc14af0cesm1431199jab.153.2024.01.10.10.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 10:35:09 -0800 (PST)
Message-ID: <eeca0783-a25a-494d-ad41-9ee67c21c82d@kernel.dk>
Date: Wed, 10 Jan 2024 11:35:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: cleanup io_rw_done()
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>
References: <8182cb84-0fca-43b8-b36f-0287e20184cd@kernel.dk>
 <ZZ7ivQcfP4rgtbS0@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZZ7ivQcfP4rgtbS0@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/24 11:32 AM, Keith Busch wrote:
> On Wed, Jan 10, 2024 at 10:09:19AM -0700, Jens Axboe wrote:
>> +static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
>> +{
>> +	if (ret == -EIOCBQUEUED) {
>> +		return;
>> +	} else if (ret >= 0) {
>> +end_io:
>> +		INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
>> +				io_complete_rw, kiocb, ret);
>> +	} else {
>> +		switch (ret) {
>> +		case -ERESTARTSYS:
>> +		case -ERESTARTNOINTR:
>> +		case -ERESTARTNOHAND:
>> +		case -ERESTART_RESTARTBLOCK:
>> +			/*
>> +			 * We can't just restart the syscall, since previously
>> +			 * submitted sqes may already be in progress. Just fail
>> +			 * this IO with EINTR.
>> +			 */
>> +			ret = -EINTR;
>> +			WARN_ON_ONCE(1);
>> +			break;
>> +		}
>> +		goto end_io;
>> +	}
>> +}
> 
> Are you just trying to get the most common two conditions at the top? A
> little rearringing and you can remove the 'goto'. Maybe just my opinion,
> but I find using goto for flow control harder to read if there's a
> structured alternative.
> 
> static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
> {
> 	if (ret == -EIOCBQUEUED)
> 		return;
> 
> 	if (unlikely(ret < 0)) {
> 		switch (ret) {
> 		case -ERESTARTSYS:
> 		case -ERESTARTNOINTR:
> 		case -ERESTARTNOHAND:
> 		case -ERESTART_RESTARTBLOCK:
> 			/*
> 			 * We can't just restart the syscall, since previously
> 			 * submitted sqes may already be in progress. Just fail
> 			 * this IO with EINTR.
> 			 */
> 			ret = -EINTR;
> 			WARN_ON_ONCE(1);
> 			break;
> 		}
> 	}
> 
> 	INDIRECT_CALL_2(kiocb->ki_complete, io_complete_rw_iopoll,
> 			io_complete_rw, kiocb, ret);
> }

This does look nicer! I'll fold that in, thanks Keith.

-- 
Jens Axboe


