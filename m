Return-Path: <io-uring+bounces-3659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0487A99CB9D
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 911F6282460
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 13:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7191514CB;
	Mon, 14 Oct 2024 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBfkt/Bx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E896E1AA794
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728912861; cv=none; b=KtKk0sHH/SLtjpMsJSKTHkjtciprDmhGShlZ1oVx+b4ec5sWYQBclrXrXE/hKaexZGGHiQgoyWB3WNPSNin/QDdL5CgASYGtqAtTqL0FXzfT+gaiGbGCu+cdRrGFMTcuIdUtH+reUa5x9Ut68HCBpZ4ertXydK6q4M6o165c85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728912861; c=relaxed/simple;
	bh=v9moFk2rU/YrE1/mMz8Qc0M6cqafWLPSBwnjqC/tJoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owDbRvSC3RLUEnLbt1zKH1eAdH9ZN5SDv47/Na/I3JtqS2inQpeuU890aAt3wpzixnfUvZZ89MiOd6FXZVBj2reGekc3w7ToH6RDcjzty+MIPrtvAN+wnrQDGKiAqHc4+urlLq1CbAYcwaxmUtO4hb74y52GbGbOmb04gUT3zoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBfkt/Bx; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fac6b3c220so53997581fa.2
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 06:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728912858; x=1729517658; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q4tuJHy4se89q6NdFX9TcSZtMJkof4tL625NFTWTUXI=;
        b=MBfkt/Bxz9jwWFCbEG2IqB/jnU+kfgbYxgemPvhdhX9IAi/sdNZGTxAEWiRjyoJSXW
         Av4Nt1OtEKflETZsrj7ITCTMUms2JgnuwPrLj6ZULLaoXQ5gV/gnlLN9/dpJFS0dy2F1
         /jwLIxdpDVE9KvmnMLWfXEi+is+5bchNdKTrKK4HISNXLgLLGYF68CoyIF8I8v/H8rlW
         pgWvLus9BsxNb5JKgDM7C/xcc/g9XHr/90p0UBXlB5BZDiYNz62G8/+PioPB03NyJEvQ
         B1kbtWA8wpfkBuPRnkiI93us8WGuGOa5SEbcJkigtH/0dex729RpHlw5rGamXc+FOL5J
         F7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728912858; x=1729517658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4tuJHy4se89q6NdFX9TcSZtMJkof4tL625NFTWTUXI=;
        b=GEUoNS3/vasJtJ5I4GXOnUXPKaiK5vTy0jjfKa32zr+/1q5AKInPi+nMAo5GKGHvSR
         dTZ+tvg6o2SIwb4FGTDmVgG/c+B1DrACRNvT+FtV622of7fHL7aoKQ8/w4wyCBAZLAbW
         WFMj383T7w/0BBS/7MDod/gOGAVqzMylDD0dB165oI+C1/sTGGz9/DZj7P8v8RDJgWA/
         2eeYM91GpnldM4UWr5mfxIremBuwB08E6JdpfZCoji8wVNYbBCd8iw3nurxbrtQplinm
         QVSJvETUrgu93XhMrqmojzHCb6HgAS6UcAmpLgzHEnqBrrFi7tsG09CrfeiuivvVDEHq
         yX9A==
X-Forwarded-Encrypted: i=1; AJvYcCVJC5Ya25sQ5tGSBvVPN2SSPhbDjwZSRgF5d+dKqQBgEHeaju8HRu9vw+vnu/ysJEgeX3gffnC1KA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAJzr+AfstHe+qy9zXpEr9AzSprl7HjJhhlp/BGV/FzcvdOLgb
	qoyJDBVhtTwgf/xi/OnnyOOdM7/2EB4xmIUow9zwZYfwGxh/Vjnx
X-Google-Smtp-Source: AGHT+IFklXpUHiahajmr0hxBbyuZiT7/00yj7QNgBYCrSTplh9gPbjB5+6xaH8x1Wc19tvXvVqzk+Q==
X-Received: by 2002:a05:6512:2509:b0:539:f10b:ff97 with SMTP id 2adb3069b0e04-539f10c010amr2262479e87.49.1728912857710;
        Mon, 14 Oct 2024 06:34:17 -0700 (PDT)
Received: from [192.168.42.88] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99faa195bfsm274108566b.33.2024.10.14.06.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 06:34:17 -0700 (PDT)
Message-ID: <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
Date: Mon, 14 Oct 2024 14:34:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm> <ZwyFke6PayyOznP_@fedora>
 <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
 <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/24 13:47, Bernd Schubert wrote:
> On 10/14/24 13:10, Miklos Szeredi wrote:
>> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
>>
>>> It also depends on how fuse user code consumes the big CQE payload, if
>>> fuse header needs to keep in memory a bit long, you may have to copy it
>>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>>> returned back asap.
>>
>> Yes.
>>
>> I'm not quite sure how the libfuse interface will work to accommodate
>> this.  Currently if the server needs to delay the processing of a
>> request it would have to copy all arguments, since validity will not
>> be guaranteed after the callback returns.  With the io_uring
>> infrastructure the headers would need to be copied, but the data
>> buffer would be per-request and would not need copying.  This is
>> relaxing a requirement so existing servers would continue to work
>> fine, but would not be able to take full advantage of the multi-buffer
>> design.
>>
>> Bernd do you have an idea how this would work?
> 
> I assume returning a CQE is io_uring_cq_advance()?

Yes

> In my current libfuse io_uring branch that only happens when
> all CQEs have been processed. We could also easily switch to
> io_uring_cqe_seen() to do it per CQE.

Either that one.

> I don't understand why we need to return CQEs asap, assuming CQ
> ring size is the same as SQ ring size - why does it matter?

The SQE is consumed once the request is issued, but nothing
prevents the user to keep the QD larger than the SQ size,
e.g. do M syscalls each ending N requests and then wait for
N * M completions.

> If we indeed need to return the CQE before processing the request,
> it indeed would be better to have a 2nd memory buffer associated with
> the fuse request.

With that said, the usual problem is to size the CQ so that it
(almost) never overflows, otherwise it hurts performance. With
DEFER_TASKRUN you can delay returning CQEs to the kernel until
the next time you wait for completions, i.e. do io_uring waiting
syscall. Without the flag, CQEs may come asynchronously to the
user, so need a bit more consideration.

-- 
Pavel Begunkov

