Return-Path: <io-uring+bounces-971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 309A087D12E
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46DFE2819E1
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B8B1773D;
	Fri, 15 Mar 2024 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ub/hJ3xU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CFC46430
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710520074; cv=none; b=c4QbUvDJ/f9cEYK3AOYdiurxRjQFkiWzsHxhBN+qeDQxIuzmyLFGezR/9S5qpNMgHgsCaas3oyvaclSlr7YkKa7CUxe84UWqu7rg21blrFwP5U2VfxK/QZvBAlW37M1FFnIYchkZjRV+wT7Qiw+VrEaetWKM3yPPtae79HwEH8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710520074; c=relaxed/simple;
	bh=Owm9W12k4cwRmZGRsXGbKwAh2e36L+48VeOS2yWxlvA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nEc/40CrvvymQWgJBNTE3XHB4QGCgxpBPxVUqoJGOw/J56O6Rq8qi9zKb7X4pFZeAojKUTsIMkn1/FkGIrTCbL/Sj3ax3b3CSh64EaqGeUzuQZGaMKO/pdDa/Afcq+JbMWD2HR3Xp0ni7OT3nClxFhRalmZ1YnsI1CIIWLXqf4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ub/hJ3xU; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3667b0bb83eso3064945ab.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710520071; x=1711124871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BxPl+IfPmAIFN4ebGEDXEol6JdOpXG5Ei+5Zkl2n5WM=;
        b=Ub/hJ3xUkF+ldobleM6YyY+Ni9fmv9E1CxJ4IPFASHA6swHanp8Kk1mek+75OViF90
         dvKxxNLTzs+Re0xNcrNjtsrs4fKAIeN/pUYWo28z3i+Kcj4CVoue4QfDa+djTWZJ2tKn
         0d3zWYmMf5ml8OoWboME7PttchWkuX9/wtEauCJWYyNkR5ccTj7SpHEkE4j7qBTJ7kFh
         uhcSXu7jhAp38+KVN37Ji/JZ2KMnlbMbKliZAnmnyqRtz7ezxdhCzImDvpHajkpCH+BB
         o3AVRGpd6XvfJE4o6kkJMgfBA7Kdk2XeIV02c1ifXVbeHE3idspUPLyIvSC2/c6O7IkP
         vnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710520071; x=1711124871;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BxPl+IfPmAIFN4ebGEDXEol6JdOpXG5Ei+5Zkl2n5WM=;
        b=MMIwIV14mFy2nsC/3JTBUEFNbYbklMVZLn6nsOpOCJ4sQwUHzJC0Fu+Jvv6zEHzlNj
         a21KoN2rzRCvmPDCCIp+vOQwK75fCI1vznwJBrGF4lWKXns0GDzGudxsJHwSch51nWR0
         GgWNy4LfagKGgmPhJLKJNrdaoAXoNQG6HJa10u3WdfIGt+1f7USSqBopHO3jpBdtLCCi
         3kc/IX2ys2eMXFWT7z9PDY5F8brwZhzDl81pqlUqFIKBby1tq2TNABjrDd+PYScuD52G
         J6Hk9qOpG5AtNnhWbi2VE8lzs39QTTNC72/d9Hx2ItYFhYbglTY8Y2PAMCYYfSzN4vGg
         xUPQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2yrLTdo+Ijiw7oaQ0imPSPzB+62C1VFKw9w+9H1MatbaMLiIkrQoKhREUrJm8abwlD7dVRPAPhwk7zhsoslzYW6aQcamsUC0=
X-Gm-Message-State: AOJu0Yz75zg2ItDeIx6Fg2pjSK5jiJWT/4ccEczhJlDhEq8R2V8lCBbb
	RnFTy7NIyXiUNHAemr6EbT1SiGi3VEdH37pxLciBu4oKZn2+qIX/vo7tFzGSeQY=
X-Google-Smtp-Source: AGHT+IF8xWEgjz4aEgsmi6V88eLgJoCTfJSDZaQ30pMgkIbaxDvfIYVaJFyK2T46SzElSkBCkgY9zw==
X-Received: by 2002:a6b:f801:0:b0:7cb:f105:57a5 with SMTP id o1-20020a6bf801000000b007cbf10557a5mr2508973ioh.1.1710520071049;
        Fri, 15 Mar 2024 09:27:51 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gc12-20020a056638670c00b004775d1fd781sm269586jab.145.2024.03.15.09.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:27:50 -0700 (PDT)
Message-ID: <dfdfcafe-199f-4652-9e79-7fb0e7b2ab4f@kernel.dk>
Date: Fri, 15 Mar 2024 10:27:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
 <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
 <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
In-Reply-To: <70e18e4c-6722-475d-818b-dc739d67f7e7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 10:25 AM, Jens Axboe wrote:
> On 3/15/24 10:23 AM, Pavel Begunkov wrote:
>> On 3/15/24 16:20, Jens Axboe wrote:
>>> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>>>> io_post_aux_cqe(), which is used for multishot requests, delays
>>>> completions by putting CQEs into a temporary array for the purpose
>>>> completion lock/flush batching.
>>>>
>>>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>>>> directly into the CQ and defer post completion handling with a flag.
>>>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>>>> multishot requests, so have conditional locking with deferred flush
>>>> for them.
>>>
>>> This breaks the read-mshot test case, looking into what is going on
>>> there.
>>
>> I forgot to mention, yes it does, the test makes odd assumptions about
>> overflows, IIRC it expects that the kernel allows one and only one aux
>> CQE to be overflown. Let me double check
> 
> Yeah this is very possible, the overflow checking could be broken in
> there. I'll poke at it and report back.

It does, this should fix it:


diff --git a/test/read-mshot.c b/test/read-mshot.c
index 8fcb79857bf0..501ca69a98dc 100644
--- a/test/read-mshot.c
+++ b/test/read-mshot.c
@@ -236,7 +236,7 @@ static int test(int first_good, int async, int overflow)
 		}
 		if (!(cqe->flags & IORING_CQE_F_MORE)) {
 			/* we expect this on overflow */
-			if (overflow && (i - 1 == NR_OVERFLOW))
+			if (overflow && i >= NR_OVERFLOW)
 				break;
 			fprintf(stderr, "no more cqes\n");
 			return 1;

-- 
Jens Axboe


