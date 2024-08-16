Return-Path: <io-uring+bounces-2797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 732FC95510D
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F4172847EC
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495A61BE23E;
	Fri, 16 Aug 2024 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3Cko/I4F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C68A1BDAA0
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723834179; cv=none; b=IFTYrKwa7T9WDGWZgqyYfQgMKFe+O6DRT2xAaX2GNDthpzL96BRtQo8qqsozADobteW7E4SZ6KFP3EB7mXbCM5tWp13kyqkYjE0dDffjWYNWAHo8gbXF5d10WgXn86Lp1IQi+/qJgp7pyjQf4YUrVSzZ4hYrHgmC/VI+8PyJQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723834179; c=relaxed/simple;
	bh=+t73d5TsZt0cB9YPP38d/NbWUzf9nfwmdudW9U1iYck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsoWCxQN2WKHD3DfVd67kUEIW32GIIXyiftqgTyyLcWGpMknQOj65+MYlrk8FMPZtdgB/7tdjJPX5PlyukMQviBWGsu7iiP8IrmoECJDnle3egVrz5VioJGgiAWayD5XbrS7utH49kYe2Ki3Ij3V1XnDvGL4pC4VV0IM8z5UN7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3Cko/I4F; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-39d323ed5ffso21505ab.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723834174; x=1724438974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yetjP0Q1MDuvYEfltwLPFzipp40jRxodgsEUqn+Gecw=;
        b=3Cko/I4Fvc4xtPMiH+rcqH2+PBJsppLzvX1DFcQGMeff/l5MDr7ZwUZBCwimE1li76
         o+4lLZ0/RPot2AlZ0YhjC89SmOg/pr0ykSmCHaqrHZLLBX5n4inf4ZCFKFwVXd0VjbgS
         9VLzNLz6HxLOqXmfJXh8cei2BwCEmjOWdAFP486gMrPGT+I5zCnxBi/mWEabfOB2hzVv
         +YUNa7TDOehzAU7fx948wnDlKAsv8j0HtEZF7Et5L+aFM7GaeIRsKslo1GFPJ/icvOq9
         UyHvGYqzKp/RLLs/EECCgxJazXMwHkupj5loXWX+Cskr9ynQNYfRN5IJUXD06DgTqWdG
         rL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723834174; x=1724438974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yetjP0Q1MDuvYEfltwLPFzipp40jRxodgsEUqn+Gecw=;
        b=wUrn3fCrteoq8vkygKB1JDN7i35CmkhB/g9vsabHhaqdqStcsOW2JIVxL2Wua33Q0J
         ZIeMZlxAqkWtrjjibK7NQYzu+PgSlhpczfVz2HBdltN6tliZH15lhnvBuN/vxVzVxF3g
         TC2MeUQGGKpUdlgHhovSnkSfskkDZesJo4dnfBn51D04s29oiY1TKal8lkLW5hGcn7WF
         5Mjd35eWSFnTSu4n6NlyKs6eJjiKjTHBww9hgYV4gXrCjoLkKniRPJy7qQehvHjU89MQ
         dexAOhQ0FtRao9y4HKOtYzr32oRnKacaZ1lGf53zZqYnmkfNzGsXqHjJ70Db+ZxL2aBT
         vbiA==
X-Forwarded-Encrypted: i=1; AJvYcCVB4Pf8SkdV07vNiLgHVBA0BWaV91F4d9opybesH+y1iYdnTPjGGiOXcMKFmk4ncZ4UeAU8tyNXeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyzbpsCvXD4y537sTWPIuKoVmCIMF+AgAxIatyk81T6sIZR6Glg
	bFOU6M7f6qrrET+TMq6mHKdCCG5Oj4AwLLhk9yFFuAxbrHB3cADT2v57z8cyoyk=
X-Google-Smtp-Source: AGHT+IGEqPdjIpJ2k45SEI3Qq1UpfqWi5Qre00Ja8TBmK7mmWJQfQTLjxGviAMOFDmLLGrO2QQ1/+g==
X-Received: by 2002:a05:6e02:170e:b0:39a:e7b0:78b0 with SMTP id e9e14a558f8ab-39d26c35d2dmr29247685ab.0.1723834174417;
        Fri, 16 Aug 2024 11:49:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1ead54bdsm15196255ab.6.2024.08.16.11.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 11:49:33 -0700 (PDT)
Message-ID: <687efed7-a25e-4962-9e63-f24f9c3e72fe@kernel.dk>
Date: Fri, 16 Aug 2024 12:49:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring: do not set no_iowait if
 IORING_ENTER_NO_WAIT
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816180145.14561-1-dw@davidwei.uk>
 <20240816180145.14561-3-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240816180145.14561-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/24 12:01 PM, David Wei wrote:
> @@ -2414,6 +2414,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>  	iowq.timeout = KTIME_MAX;
> +	if (flags & IORING_ENTER_NO_IOWAIT)
> +		iowq.no_iowait = true;

Oh, and this should be:

	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;

to avoid leaving this field uninitialized by default if the flag isn't
set. The struct isn't initialized to zero.

-- 
Jens Axboe


