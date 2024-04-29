Return-Path: <io-uring+bounces-1670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2494F8B5DC5
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 17:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91E961F20F02
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 15:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AB07F47F;
	Mon, 29 Apr 2024 15:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7lXeZki"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB87BAF0;
	Mon, 29 Apr 2024 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404744; cv=none; b=R/cMsQjctgI5C/x6dpj6iOkY69PqNkUH9xk5blWNwEKzFCA70u3Eys+TU2c6I/zaexIFW1fUIZ8yZ+WCzJ8QQny76myQwcFNa8PZGa/4bZ3f0xW21xXKlobSX/VjTSFMyXRRW8aRTnwhs0DZE9dKXCL3tttg2asp44/idBbD9T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404744; c=relaxed/simple;
	bh=906gNNSi02+Z9STqL/XwxsLkDrkZJfvfeqO8ZL1J6b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aynlQsAhfRKMLLhZqkwkgc3tx3OniqNJbb/oNn90LKz1i6pLiet0N7Wv7/SLE6fzoZZ7OsbTEFc4YZfVl+z1nbD3D6junuQvTLfzLRxPbZN/hvqaa9U2Zhsq97VRKkBRxAVUNmSa4YtmOswyti378aZQZ7BYTFR/IhUYgUM4B/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7lXeZki; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-34cd9f50ffaso1007397f8f.3;
        Mon, 29 Apr 2024 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714404741; x=1715009541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r0edsNYWEThLoKsjz4oBE1SPbbErkyHbDZZ/TkSXkjM=;
        b=i7lXeZkiy83fXyXY9ijtl2F7cI0QYfS4DV/+UTxxMKDNXhPZj/9Fc+fRWYX4S5v4gL
         oxOtKW8SC1u0/JVgnPNnA6V3/kV7SC+rR2K2Vu/qAX82oP+mZr17i6YsGGLNF5PjMzQE
         LS18WOVrFukqSrjgSQ86Q6yTV805dPf2dB/ofJADxWuVLt5AfHbQ6LMlycRPedFzoCqW
         TlJH0MIBSZsvGAzX+wydXAbOtzHE77FT01MxG57f/j4f5g/Jwp2isZCvdg1oAbOIT8jy
         9uFvyVLXImu+9r+GA8vvG52U0SqRrXP8D7R15IVojsqYp8FbIG1Vjo0zNg7pfKzoks+Q
         AV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714404741; x=1715009541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0edsNYWEThLoKsjz4oBE1SPbbErkyHbDZZ/TkSXkjM=;
        b=ovm+1b2qivDt/8oikPW0rTHF5AwKh65NnqyLWFLxTo6sG60a167DLL++6tj6wHb+s9
         m7Bzwh4nyDZipFN+1+g0q82HtnzHGH0UwGlsfpWKWP+Qy4N+y9qCUxwpvShBTQQ/YrJl
         m9HH2YaXPuCG6oRmbXm78YdbZoYoYbLwovV3nBGFsomDKMhTtwFBaknYV3hBcE7qOBd6
         +HMuS5TI7aOeturwvB6P+loN+jhXBwn92cmHCDUEWnb6/J/An0n3FE7+zeQP1rN5pjCf
         4hjmV8I5lSZwuES7oV5MbOmXVKXrke82uUdSZfdYAOuLq5+9FE12TzLWvA3Ige9CaQan
         a4eg==
X-Forwarded-Encrypted: i=1; AJvYcCVrSurpBZDB7KlNJuJqnHabtLbDsf4jskn/hL9g1auQZ1USX2BaZq/8kDTHUmSzgjZyQ0I9waJryePPC7qlcZPYDzpe/91ckmskYY2mSnUPCu4Zkw4nDGiKoGFkFluh8rcqhFobUw==
X-Gm-Message-State: AOJu0YxzbRBx9H9lgoiFDlwI9g9csvXN4FbCXDr2HCQTum6hQwD3X4WG
	i+LmHSWIONifBtj9LZEsa2FVJhbn0SbnJhwLgHEmYjiy4juFJVxcwSVtlQ==
X-Google-Smtp-Source: AGHT+IFX/JnWL6p57agENsBzpEdnMvHFr/kYY6k+uGKqP/s91Ckg08cUygkEILfmwbOCG10E5IA54g==
X-Received: by 2002:adf:f04e:0:b0:34c:b8fa:9768 with SMTP id t14-20020adff04e000000b0034cb8fa9768mr4717249wro.51.1714404741132;
        Mon, 29 Apr 2024 08:32:21 -0700 (PDT)
Received: from [192.168.42.252] (82-132-212-208.dab.02.net. [82.132.212.208])
        by smtp.gmail.com with ESMTPSA id v18-20020a5d43d2000000b0034a25339e47sm28906372wrr.69.2024.04.29.08.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 08:32:20 -0700 (PDT)
Message-ID: <6077165e-a127-489e-9e47-6ec10b9d85d4@gmail.com>
Date: Mon, 29 Apr 2024 16:32:35 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] io_uring: support SQE group
To: Kevin Wolf <kwolf@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Ziey53aADgxDrXZw@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:08, Kevin Wolf wrote:
> Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>> SQE group is defined as one chain of SQEs starting with the first sqe that
>>> has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
>>> doesn't have it set, and it is similar with chain of linked sqes.
>>>
>>> The 1st SQE is group leader, and the other SQEs are group member. The group
>>> leader is always freed after all members are completed. Group members
>>> aren't submitted until the group leader is completed, and there isn't any
>>> dependency among group members, and IOSQE_IO_LINK can't be set for group
>>> members, same with IOSQE_IO_DRAIN.
>>>
>>> Typically the group leader provides or makes resource, and the other members
>>> consume the resource, such as scenario of multiple backup, the 1st SQE is to
>>> read data from source file into fixed buffer, the other SQEs write data from
>>> the same buffer into other destination files. SQE group provides very
>>> efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
>>> submitted in single syscall, no need to submit fs read SQE first, and wait
>>> until read SQE is completed, 2) no need to link all write SQEs together, then
>>> write SQEs can be submitted to files concurrently. Meantime application is
>>> simplified a lot in this way.
>>>
>>> Another use case is to for supporting generic device zero copy:
>>>
>>> - the lead SQE is for providing device buffer, which is owned by device or
>>>    kernel, can't be cross userspace, otherwise easy to cause leak for devil
>>>    application or panic
>>>
>>> - member SQEs reads or writes concurrently against the buffer provided by lead
>>>    SQE
>>
>> In concept, this looks very similar to "sqe bundles" that I played with
>> in the past:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
>>
>> Didn't look too closely yet at the implementation, but in spirit it's
>> about the same in that the first entry is processed first, and there's
>> no ordering implied between the test of the members of the bundle /
>> group.
> 
> When I first read this patch, I wondered if it wouldn't make sense to
> allow linking a group with subsequent requests, e.g. first having a few
> requests that run in parallel and once all of them have completed
> continue with the next linked one sequentially.
> 
> For SQE bundles, you reused the LINK flag, which doesn't easily allow
> this. Ming's patch uses a new flag for groups, so the interface would be
> more obvious, you simply set the LINK flag on the last member of the
> group (or on the leader, doesn't really matter). Of course, this doesn't
> mean it has to be implemented now, but there is a clear way forward if
> it's wanted.

Putting zc aside, links, graphs, groups, it all sounds interesting in
concept but let's not fool anyone, all the different ordering
relationships between requests proved to be a bad idea.

I can complaint for long, error handling is miserable, user handling
resubmitting a part of a link is horrible, the concept of errors is
hard coded (time to appreciate "beautifulness" of IOSQE_IO_HARDLINK
and the MSG_WAITALL workaround). The handling and workarounds are
leaking into generic paths, e.g. we can't init files when it's the most
convenient. For cancellation we're walking links, which need more care
than just looking at a request (is cancellation by user_data of a
"linked" to a group request even supported?). The list goes on

And what does it achieve? The infra has matured since early days,
it saves user-kernel transitions at best but not context switching
overhead, and not even that if you do wait(1) and happen to catch
middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
timers and what not is effectively useless with links.

So, please, please! instead of trying to invent a new uber scheme
of request linking, which surely wouldn't step on same problems
over and over again, and would definitely be destined to overshadow
all previous attempts and finally conquer the world, let's rather
focus on minimasing the damage from this patchset's zero copy if
it's going to be taken.

Piggy backing bits on top of links should be just fine. May help
to save space in io_kiocb by unionising with links. And half
of the overhead (including completely destroying all inlining
in the submission patch) can be mitigated by folding it into
REQ_F_LINK handling and generally borowing the code structure
for it in the submission path.


> The part that looks a bit arbitrary in Ming's patch is that the group
> leader is always completed before the rest starts. It makes perfect
> sense in the context that this series is really after (enabling zero
> copy for ublk), but it doesn't really allow the case you mention in the
> SQE bundle commit message, running everything in parallel and getting a
> single CQE for the whole group.
> 
> I suppose you could hack around the sequential nature of the first
> request by using an extra NOP as the group leader - which isn't any
> worse than having an IORING_OP_BUNDLE really, just looks a bit odd - but
> the group completion would still be missing. (Of course, removing the
> sequential first operation would mean that ublk wouldn't have the buffer
> ready any more when the other requests try to use it, so that would
> defeat the purpose of the series...)
> 
> I wonder if we can still combine both approaches and create some
> generally useful infrastructure and not something where it's visible
> that it was designed mostly for ublk's special case and other use cases
> just happened to be enabled as a side effect.


-- 
Pavel Begunkov

