Return-Path: <io-uring+bounces-6394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B9EA332F6
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 476637A2EE4
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F52D204582;
	Wed, 12 Feb 2025 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ilxVUGHe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C094B205AC3
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 22:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739400989; cv=none; b=UgAv14LDF5fJj3Te49qhKnDj5dlP+gww0ejuyeqK2GVtWVU3bJrAohYoSocxnQ2lTCXE9iok+ktmAVkvYySf/H3km+c8LU8vQiyUxTY2kdzg8syJi3XhbMazyo7EGf7kflhXIa9OIMeersbW3atorRo2WyCaEzl39K10uy0h4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739400989; c=relaxed/simple;
	bh=TtCSZ9PU0y4KtRj3ggkH95VbA6oHb4jzeQ2JJh2U7xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gkCsz7AXYVzopcnDXjTgAi0OxN4vapxM5Pj7L/9/o1cNbwbVeLXsLYRTHoyQhK94lij77Xh4tyLmxsDe9SMMNtfcPDLtwBWbqEdOT0OGHhNpCigtS5wWemHSIjzkN0ALaCd7MRjpMUMZ/7Oiu9wNZpzTXpZp9QooaBPpH0POrkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ilxVUGHe; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cfc8772469so658425ab.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739400987; x=1740005787; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6crXAQ5HG6XND+cuiRn8Ub17v1QBJPvBhK2mWdn7zxg=;
        b=ilxVUGHeU2IJluN8N8cdazdEbga8PkSvbVjKakU8t/QlwJHKDT+0EZdaj7GzjOPVQ7
         IWdig6VkLqW7lcD+euAhPfr+BuNGoL//Y08X0A7xqUkvX3uBYSH4QoJ+QJhqZl6iDSnD
         gaEpsGWowiGY6kxsccho+RIYGdkz2IQch9myTfpwd8YP1hrEP85PABT1f9fhmWQeImay
         obA5bpjJY4ueyX65PV60ZymdqgIYChMMa8ukhfuwiYAXJUOfYyH932lZm4qQCzsbSL2Y
         7sQU62NN29hk+rbZJ/xI6+mYaZtTvuyzD8qDC5PrBZUMM26ZCVWGYjSI599694dpF+Hd
         cB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739400987; x=1740005787;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6crXAQ5HG6XND+cuiRn8Ub17v1QBJPvBhK2mWdn7zxg=;
        b=Xe5Y00cBF369dqXCpdj2A3cY0K+WkZbYEi6RXisOY22gxSfYx4Qc3KPn+OZK25OJgu
         OOQr/E/gUB/5NO/RJS6GvQTc6SYpVlWX9XNfj/TJgDL6eFAukyJacxKP+SeXj2HDiyaF
         AcZzLgQCx70j2lq5A1g+w1Aq9Xws6XtyqoeOEDMqFK/E2ExQPQZVjBLnxhJQeCOAElFM
         pOcTR2H1M0suX0tfQMtR5dsrnuTcMa/L8torvaSriJizt5vQjIQvuyQSmLT+pPRpH+cD
         G2VI6zDfbOWQwfOMvhHp/AOa85vm4spKPxb/HBSnqO0qauqK1ZbRtt6i7auKvf0z0/vq
         qvNg==
X-Forwarded-Encrypted: i=1; AJvYcCUrA8XL87vjPuop4iyu1WB2vJarpyOt/1aMr0+20b04BCMEEaYMVZAc6gTwK2pKBDVs+AGeviIvWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfxqoeyLUy4BhzL512URrz2MLKVLbDAUhFH4STcX0Fcdwf88j+
	1xHpXTTIee/dpNB8o1rDNZnz2xyjBymPwzv6YpMkyRrWTN8iAtQzPKwN8yv2KI4=
X-Gm-Gg: ASbGncuxjLqmWP5o0wa+wYsNtQNx+HWfYvvWAqbOynOK8LVIiHqF/yf5AcxKlqd7oPN
	ARf8OKdmnv61eriaVw5aFvkiP4rhR7nUwL2QrvqjCp4Sm3+00M+xGLphIsZOIGJCgdcM5B2rwem
	5Os6wUTWdOC0XX/bwvZOIET8rbCRmzSqxXtUZQXRggTBJ6kREl+lPfPKeFIIz0rI+IgXRwq2EaN
	DpuCnhyiptdMZ0IOxYDuHj+cr/MdrtoQW++1WBFL9ib8gkQ9nX7cWXMD9TSpAqSdx1RJynvpXKG
	V39FE22TQP6L
X-Google-Smtp-Source: AGHT+IGkGuQWkf/UDr2yQCtpCwnkbCGHJUXYuR+UAuvbLOsnAslc5I8O1+gMQmnd+HhDnCm7pKWfUg==
X-Received: by 2002:a05:6e02:12cf:b0:3d0:24c0:bd4d with SMTP id e9e14a558f8ab-3d17bff94f9mr53501605ab.18.1739400986796;
        Wed, 12 Feb 2025 14:56:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18a227795sm2032215ab.62.2025.02.12.14.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 14:56:26 -0800 (PST)
Message-ID: <119dbfb9-ab02-43b9-8a46-5b94e897375e@kernel.dk>
Date: Wed, 12 Feb 2025 15:56:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Caleb Sander <csander@purestorage.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <50caa50c-5126-4072-8cfc-33b83b524489@kernel.dk>
 <CADUfDZroLajE4sF6=oYopg=gNtv3Zko78ZcJv4eQ5SBxMxDOiw@mail.gmail.com>
 <e315e4f5-a3f0-48be-8400-05bfaf8714f8@kernel.dk>
 <CADUfDZp5w_LuXn9suUnqNr5ePdvrUP1-f5UN3B_iVTtUn2kFbg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZp5w_LuXn9suUnqNr5ePdvrUP1-f5UN3B_iVTtUn2kFbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 3:52 PM, Caleb Sander wrote:
> On Wed, Feb 12, 2025 at 2:34?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/12/25 2:58 PM, Caleb Sander wrote:
>>> On Wed, Feb 12, 2025 at 1:02?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2/12/25 1:55 PM, Jens Axboe wrote:
>>>>> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
>>>>>> In our application issuing NVMe passthru commands, we have observed
>>>>>> nvme_uring_cmd fields being corrupted between when userspace initializes
>>>>>> the io_uring SQE and when nvme_uring_cmd_io() processes it.
>>>>>>
>>>>>> We hypothesized that the uring_cmd's were executing asynchronously after
>>>>>> the io_uring_enter() syscall returned, yet were still reading the SQE in
>>>>>> the userspace-mapped SQ. Since io_uring_enter() had already incremented
>>>>>> the SQ head index, userspace reused the SQ slot for a new SQE once the
>>>>>> SQ wrapped around to it.
>>>>>>
>>>>>> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
>>>>>> index in userspace upon return from io_uring_enter(). By overwriting the
>>>>>> nvme_uring_cmd nsid field with a known garbage value, we were able to
>>>>>> trigger the err message in nvme_validate_passthru_nsid(), which logged
>>>>>> the garbage nsid value.
>>>>>>
>>>>>> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
>>>>>> SQE copying until it's needed"). With this commit reverted, the poisoned
>>>>>> values in the SQEs are no longer seen by nvme_uring_cmd_io().
>>>>>>
>>>>>> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
>>>>>> to async_data at prep time. The commit moved this memcpy() to 2 cases
>>>>>> when the request goes async:
>>>>>> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
>>>>>> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
>>>>>>
>>>>>> This patch set fixes a bug in the EAGAIN case where the uring_cmd's sqe
>>>>>> pointer is not updated to point to async_data after the memcpy(),
>>>>>> as it correctly is in the REQ_F_FORCE_ASYNC case.
>>>>>>
>>>>>> However, uring_cmd's can be issued async in other cases not enumerated
>>>>>> by 5eff57fa9f3a, also leading to SQE corruption. These include requests
>>>>>> besides the first in a linked chain, which are only issued once prior
>>>>>> requests complete. Requests waiting for a drain to complete would also
>>>>>> be initially issued async.
>>>>>>
>>>>>> While it's probably possible for io_uring_cmd_prep_setup() to check for
>>>>>> each of these cases and avoid deferring the SQE memcpy(), we feel it
>>>>>> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
>>>>>> As discussed recently in regard to the ublk zero-copy patches[1], new
>>>>>> async paths added in the future could break these delicate assumptions.
>>>>>
>>>>> I don't think it's particularly delicate - did you manage to catch the
>>>>> case queueing a request for async execution where the sqe wasn't already
>>>>> copied? I did take a quick look after our out-of-band conversation, and
>>>>> the only missing bit I immediately spotted is using SQPOLL. But I don't
>>>>> think you're using that, right? And in any case, lifetime of SQEs with
>>>>> SQPOLL is the duration of the request anyway, so should not pose any
>>>>> risk of overwriting SQEs. But I do think the code should copy for that
>>>>> case too, just to avoid it being a harder-to-use thing than it should
>>>>> be.
>>>>>
>>>>> The two patches here look good, I'll go ahead with those. That'll give
>>>>> us a bit of time to figure out where this missing copy is.
>>>>
>>>> Can you try this on top of your 2 and see if you still hit anything odd?
>>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index bcfca18395c4..15a8a67f556e 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -177,10 +177,13 @@ static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
>>>>         ioucmd->sqe = cache->sqes;
>>>>  }
>>>>
>>>> +#define SQE_COPY_FLAGS (REQ_F_FORCE_ASYNC|REQ_F_LINK|REQ_F_HARDLINK|REQ_F_IO_DRAIN)
>>>
>>> I believe this still misses the last request in a linked chain, which
>>> won't have REQ_F_LINK/REQ_F_HARDLINK set?
>>
>> Yeah good point, I think we should just be looking at link->head instead
>> to see if the request is a link, or part of a linked submission. That
>> may overshoot a bit, but that should be fine - it'll be a false
>> positive. Alternatively, we can still check link flags and compare with
>> link->last instead...
> 
> Yeah, checking link.head sounds good to me. I don't think it should
> catch any extra requests. link.head will still be NULL when ->prep()
> is called on the first request of the chain, since it is set in
> io_submit_sqe() after io_init_req() (which calls ->prep()).

It'll catch potentially extra ones in the sense that you can submit a
link chain with other requests that aren't related.

>> But the whole thing still feels a bit iffy. The whole uring_cmd setup
>> with an SQE that's sometimes the actual SQE, and sometimes a copy when
>> needed, does not fill me with joy.
>>
>>> IOSQE_IO_DRAIN also causes subsequent operations to be issued async;
>>> is REQ_F_IO_DRAIN set on those operations too?
>>
>> The first 8 flags are directly set in the io_kiocb at init time. So if
>> IOSQE_IO_DRAIN is set, then REQ_F_IO_DRAIN will be set as they are one
>> and the same.
> 
> Sorry, I meant that a request marked IOSQE_IO_DRAIN/REQ_F_IO_DRAIN
> potentially causes both that request and any following requests to be
> submitted async. The first request waits for any outstanding requests
> to complete, and the following requests wait for the request marked
> IOSQE_IO_DRAIN to complete. I know REQ_F_IO_DRAIN = IOSQE_IO_DRAIN is
> already set on the first request, but will it also be set on any
> following requests that have to wait on that one?

Yeah good point. All of this works nicely in io_uring as-is, because
post ->prep() everything _must_ be stable. But uring_cmd violates that,
which is why we need to jump through hoops here.

Might in fact just be better to know exactly how much of the SQE that
needs copying here, and have it reside in stable storage post prep. A
bit tricky with the various sub-types of requests that can be in there
however.

-- 
Jens Axboe

