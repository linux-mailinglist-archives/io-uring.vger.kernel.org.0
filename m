Return-Path: <io-uring+bounces-1972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED0D8D1D04
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 15:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF2C028767B
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 13:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EDE1D688;
	Tue, 28 May 2024 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fvpVnuyI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1887917C7F
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716903099; cv=none; b=OKGtuvRKma75Haz4/v/VjTKtmWaovTQLd1nQ0pgpSApSCjWddkABy5lig6ll4zVH/Z8/5e7DLZW1hVYSCPgczViJ9t0iWMzw3F3cNfmlCd8t2gDG41F051ZVLhDE9gI6FB14ZPxuTpxFndlaosNR4DMpR52e3RsDuaTDo/yo8TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716903099; c=relaxed/simple;
	bh=IU3dTeyiD/GpTZDZj5HSqIwoC4iRP5fhr7yM2twb1T4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tDdKhX16yLttFabz6zgHyjYFdclxtiNtsnqX2xjULzHSke/0cWUijd876aegzmPvsbWJ/mjmQiGCkUPNw0Wuq07qsJco7Q/JA+bTTRpLb64HqT4OM8alZbDDkLQSu0a0GSke23b4iImZ8UMwUA4BTyi7FMyRIRjL/ht6RqgsO9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fvpVnuyI; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-578972defb3so1026530a12.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 06:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716903096; x=1717507896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lp23Md8fpv8FWb4elGsHNqfyJahZjgsWWgFL7d8xn1Q=;
        b=fvpVnuyIkbOllGC/20M2PDUZWIVC25JzjZx7k5gnQBSy83C8FVyjbVhcN4rNknKBx1
         gyEM92ZPxY73lpeT7IcfOXapBp+9DYYIf0gWVbacXa36s4fiezcb0SQtdqqQI8rs4ogi
         HkSwSeG7UJ4Hif0KEVHnAN8o2P+/lTJFEmcEaplZ9sdQfPr/GmsgPjbWdGyjddwqvfFp
         W3g0G5CVXck/t/EuEiOqCVJRdh8MxUAmFNnzucC/GKRL1YdOHDYPuvAyWJa5Bmi98F75
         UxikUdKEbBqG/Fd/LPavrfdQVdja/wKZPBqRb7lgT4rRW7f7sDxAMTXoxUTTov65z+C5
         Zvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716903096; x=1717507896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lp23Md8fpv8FWb4elGsHNqfyJahZjgsWWgFL7d8xn1Q=;
        b=sHXxwC22z3Gw/jLIMLZyOPSEgrTHE+XjWQcStpizGf4fYGITs97o9NjiDWPXGGmDFk
         fVNbkP33gPlSRMp1x8FJ4z7HB3bQxPayKvBv32GJmPcvXsirGWcRSGRX6JmrfUvuJFar
         ifgCauFpWeKYNGPZxDro8sxgbgugH/Y7DHzHKYTYEZcjY3YZyiikGuRu6kbYstLp1CEL
         Pl3ulSgzVtXTJdEfsbzeZc5VHaDmnjCtJ+k1+Dfvx5faWzeG7IP9qKiV4Ipa1KMadVUN
         /IbqqxZzlRgnddENrodbBZ3onH3z5hfJfvO/Dq50I8m5QAHcXNJedRt1tnjYTy38EfOq
         B17g==
X-Forwarded-Encrypted: i=1; AJvYcCWNwRrZ8YYOSP/PuGOAgTrE3+iidKGvLx6qbizBNipXqe1hFq7CqnpHWrGh7zhWSsWLu7yZ3Bm2Ap4ZWt3KT7VYqxDEFuyapp0=
X-Gm-Message-State: AOJu0Yw+IMVg3mrpydnFgSHYRFE1hB+q4OunhcHMCi2j10uIFkz9wpeL
	czixsaa4BP52BsepNFmv4QSzmQ3WVgjQhK69Lxuog/yGxJCXIjX5
X-Google-Smtp-Source: AGHT+IFEH61HOFwNrAw2ZdYM2xKDObuXgrkGT3yohcFFqYGDDA84SYKFnAHz65obA5wyPCQyAexK4Q==
X-Received: by 2002:a17:906:c7c7:b0:a52:3583:b9d0 with SMTP id a640c23a62f3a-a62641aa1cdmr761383366b.3.1716903096132;
        Tue, 28 May 2024 06:31:36 -0700 (PDT)
Received: from [192.168.42.21] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a634e48481esm49997666b.224.2024.05.28.06.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 06:31:35 -0700 (PDT)
Message-ID: <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
Date: Tue, 28 May 2024 14:31:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240524230501.20178-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/24 23:58, Jens Axboe wrote:
> Hi,
> 
> A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to

IORING_SETUP_SINGLE_ISSUER has nothing to do with it, it's
specifically an IORING_SETUP_DEFER_TASKRUN optimisation.

> use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
> generic task_work. This isn't ideal. This patchset attempts to rectify
> that, taking a new approach rather than trying to use the io_uring
> task_work infrastructure to handle it as in previous postings.

Not sure why you'd want to piggyback onto overflows, it's not
such a well made and reliable infra, whereas the DEFER_TASKRUN
part of the task_work approach was fine.

The completion path doesn't usually look at the overflow list
but on cached cqe pointers showing the CQ is full, that means
after you queue an overflow someone may post a CQE in the CQ
in the normal path and you get reordering. Not that bad
considering it's from another ring, but a bit nasty and surely
will bite us back in the future, it always does.

That's assuming you decide io_msg_need_remote() solely based
->task_complete and remove

	return current != target_ctx->submitter_task;

otherwise you can get two linked msg_ring target CQEs reordered.

It's also duplicating that crappy overflow code nobody cares
much about, and it's still a forced wake up with no batching,
circumventing the normal wake up path, i.e. io_uring tw.

I don't think we should care about the request completion
latency (sender latency), people should be more interested
in the reaction speed (receiver latency), but if you care
about it for a reason, perhaps you can just as well allocate
a new request and complete the previous one right away.

> In a sample test app that has one thread send messages to another and
> logging both the time between sender sending and receiver receving and
> just the time for the sender to post a message and get the CQE back,
> I see the following sender latencies with the stock kernel:
> 
> Latencies for: Sender
>      percentiles (nsec):
>       |  1.0000th=[ 4384],  5.0000th=[ 4512], 10.0000th=[ 4576],
>       | 20.0000th=[ 4768], 30.0000th=[ 4896], 40.0000th=[ 5024],
>       | 50.0000th=[ 5088], 60.0000th=[ 5152], 70.0000th=[ 5280],
>       | 80.0000th=[ 5344], 90.0000th=[ 5536], 95.0000th=[ 5728],
>       | 99.0000th=[ 8032], 99.5000th=[18048], 99.9000th=[21376],
>       | 99.9500th=[26496], 99.9900th=[59136]
> 
> and with the patches:
> 
> Latencies for: Sender
>      percentiles (nsec):
>       |  1.0000th=[  756],  5.0000th=[  820], 10.0000th=[  828],
>       | 20.0000th=[  844], 30.0000th=[  852], 40.0000th=[  852],
>       | 50.0000th=[  860], 60.0000th=[  860], 70.0000th=[  868],
>       | 80.0000th=[  884], 90.0000th=[  964], 95.0000th=[  988],
>       | 99.0000th=[ 1128], 99.5000th=[ 1208], 99.9000th=[ 1544],
>       | 99.9500th=[ 1944], 99.9900th=[ 2896]
> 
> For the receiving side the win is smaller as it only "suffers" from
> a single generic task_work, about a 10% win in latencies there.
> 
> The idea here is to utilize the CQE overflow infrastructure for this,
> as that allows the right task to post the CQE to the ring.
> 
> 1 is a basic refactoring prep patch, patch 2 adds support for normal
> messages, and patch 3 adopts the same approach for fd passing.
> 
>   io_uring/msg_ring.c | 151 ++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 138 insertions(+), 13 deletions(-)
> 

-- 
Pavel Begunkov

