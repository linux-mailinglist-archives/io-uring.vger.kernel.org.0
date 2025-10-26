Return-Path: <io-uring+bounces-10216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE2EC0A251
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 05:10:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E512D3AEF2B
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 04:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF4F24C66F;
	Sun, 26 Oct 2025 04:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DXkndTTu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC69145B3E
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451845; cv=none; b=WZhtdbNHjRjDwrXhTYetLDmstUyzCQwuiz2AtibiqQeZL3P3B+MR4BguA2al+Z0Qf13SL7SIFkzF+AElCW8kE3wZv9BLHYDmpgPNNK70KCGDSf8cHft6RCaGPj6W+24PVagc269rCg9NOEtcqkMXGNJdMoVk9Gv7HfkXCZT1axw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451845; c=relaxed/simple;
	bh=AgpxVYwn1pQ3rBUhZpRPVe6/W1kVz/lD1kFCSCUd3Rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fF2CFxg1VhtfLktFX/gFwXQp9hPsu18i73EWmqybx/STXxcwQktABIkDTOFB65hEBmkjyf8CbxcV0epyJFeBMdgWSs1oMNw/5o8KLt64INyvYMd1cqotnRVWSpAVb0eZ7XT1S5/H5aTZq3dZ2DQ8W8cwtFf9tXiWk83lae5JHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=DXkndTTu; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29488933a91so28548715ad.2
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 21:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761451842; x=1762056642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6qgDvs7YmNxOVkc3/4Op0G6CwX5vejYhixYA4j+OPrU=;
        b=DXkndTTumd/oI0Y8b9YR79j3miKapPtc3nz7SAZDITrjXEIG4D3ot4Xhy1YlrSmihq
         sPAgrLn7PUUO6IFJFijfft8wc1jDr2T+wLFb6tnbM8wx742THZkj/B1uJ8+HfiX6pKuN
         70144PCBXdMmbgVNinntXLGbHOnPPQkPpJg71Q/6DYggOjaJDH0HHozV/+G4qn0qbEOF
         8aTYFouwnm6ak+imbTq8pC4DinWUsk8dLOgK+dZ9TNbRcUOPgsuOEsggpDgwKhPOrbIX
         xbKukgQYImFFSvCh9c2LE03fzJ91xYxpyA9Q2KSlGloEHAnetOX5fpKrlkdQFuCxJzeP
         /Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761451842; x=1762056642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6qgDvs7YmNxOVkc3/4Op0G6CwX5vejYhixYA4j+OPrU=;
        b=l2SZCcTITdBIEB9T4FqIyMvNf8ytrmJKK7Ip6eNN46NFX9wZ+UvAXszaJzuouL7LAb
         3MDoYsBSMnTP7hnGnSxZ56AFF9zilAknEoSzCOUK2etw6/shusNts/BMhlH846KD9Ruq
         /CV92MT+GcG510DyVjNbweIQsfg7UlZ8ytUYYyxkVz8KusuLzZlldosBGCZyKrW3KY1f
         g6hBkSZNgaY7yx8WG24n622DCa1n07wcZ0U49Qav6w6UIB0MVWyokzHipVR0wY3EdMda
         8Hmrtn1/eXjAbONVxaEsiSHMnQN7wlbE+/99gbcLrdfSw2+r+hQU35H2jDOxtYHeMORf
         QJTA==
X-Forwarded-Encrypted: i=1; AJvYcCXXKvPAKsJ1gmWuVx1dSs49bQe0kgG6xARa7tjMhjeLnukGske5kCyzUeBCr5mtNk955t/lAdd/cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBhyDs/TKpV5g9LklfY0EobIa9o/mtd3neLZslO7tLQzq/1FB/
	MVrp8ZJSPL5I1vsLRAnRejFceqMeVHNf2mNBabhq/PA/CX2Zfr46Ibw4LImuQchx7dk=
X-Gm-Gg: ASbGncveWJakOCrEp9Eu1OOHTRuVGT0nA1Hu18Jxz8a0rERSo54jX7BMrAVpddCekqG
	BqJh23kxKvL+imFXuuBQ5duWoaBJ75wZT3EH+ct6A3iTaIek7LNjpfZiT16htDC5cpXzbkEGmjk
	rvsRMtQxrATal4qONISi2KIu/9pXEAktfYiO2VDQy0J7gsWcOhxG/x6393hKJNm98kDniJsMBk5
	N53/eVkh4n80LoIimvdS0Eehy0BXnuj/2pJ3cV2GpFuLIawmtDbEdJYVxrGb2cXjLCczf/WR742
	uTEVLlz+dzny3ZrABGZs+UvkQKlO3lg3yfir6xnT9dElIrCXodb2GbAtSS0tpwfTkSaLcnGujun
	LM1uy7i03lyBTTgzs4IyH3+gYJ02FnFSu1W+hTrIiHXLrCswPn+jj42vMCG8poRMcSy6L4hBeKW
	nZWFDXboEI65AlQTBHWQpY9wGZGrnJE9j0XXQpGIwHyUCzcXHNiA==
X-Google-Smtp-Source: AGHT+IHT25KbYA8Cz1HCr276xOt3xPKUQTvV4NjXAGqAs5DDgHlwNumJfi/0NShjNtB8CFI5b8dCaA==
X-Received: by 2002:a17:903:32ca:b0:290:b92d:907 with SMTP id d9443c01a7336-290cb376121mr466851585ad.53.1761451842227;
        Sat, 25 Oct 2025 21:10:42 -0700 (PDT)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0a329sm38340405ad.36.2025.10.25.21.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Oct 2025 21:10:41 -0700 (PDT)
Message-ID: <74ce4fb9-3654-4a1d-9b8b-abee8aba9ca9@davidwei.uk>
Date: Sat, 25 Oct 2025 21:10:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] io_uring/zcrx: add refcount to struct io_zcrx_ifq
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-3-dw@davidwei.uk>
 <0a9d9e34-a351-4168-bbdc-3ca3b6c3e17b@kernel.dk>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <0a9d9e34-a351-4168-bbdc-3ca3b6c3e17b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-25 16:37, Jens Axboe wrote:
> On 10/25/25 1:15 PM, David Wei wrote:
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index a816f5902091..22d759307c16 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -730,6 +731,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>   	lockdep_assert_held(&ctx->uring_lock);
>>   
>>   	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
>> +		if (refcount_read(&ifq->refs) > 1)
>> +			continue;
> 
> This is a bit odd, it's not an idiomatic way to use reference counts.
> Why isn't this a refcount_dec_and_test()? Given that both the later grab
> when sharing is enabled and the shutdown here are under the ->uring_lock
> this may not matter, but it'd be a lot more obviously correct if it
> looked ala:
> 
> 		if (refcount_dec_and_test(&ifq->refs)) {
>    			io_zcrx_scrub(ifq);
>    			io_close_queue(ifq);
> 		}
> 
> instead?
> 

Yeah, good idea. Your comments prompted me to try to find a better
solution that gets rid of ifq->proxy. Turns out xarray has 3 bits per
entry that can be 'marked'. With this I can get a cleaner solution. Will
respin tomorrow.

