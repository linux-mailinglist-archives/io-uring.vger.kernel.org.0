Return-Path: <io-uring+bounces-2016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A638C8D50FA
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 19:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2960D28591A
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A42433C2;
	Thu, 30 May 2024 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xMTsLqXY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95D187560
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717090016; cv=none; b=aVUXvV3NYctIWtJjs8NA9A2Fdok69rAeeT2EuN5mW0rwvYKKYk4cIQNG3VUJ0aEK+jc0oGqZT9Xp3TkUGTGgKxszz4WNna8XFF9Bui7V2wFjksxB+qyxiM26sFvJOmqAv//MgWLJvHfWHUFjhwRAcnNNjyur2sIk/xO7UIXzKDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717090016; c=relaxed/simple;
	bh=/6LjTXDu7CbZwsRn9J0IAsAIx0Rt8NvQku51AFgE3sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBfBRd78sD44rOIljV+nKW3IwPQa+eVkkOI/qsWPvUae7bLB/FqkjbZKV45CEDtQgmBZrJOXfc044XsCEu/V5d5GQ14kobDLSZMCJkxzwuJkun/XanAYfUjSbRsjVrhA55ei7XN7IlLX6p5gTrID1kBhKnEMI8+lh1EUp1WoKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xMTsLqXY; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6f9090cb1ecso55132a34.2
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 10:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717090014; x=1717694814; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyL262HUI/eumvrqhAytpNCfzmfVssZxwMRgLZjf+EE=;
        b=xMTsLqXYNL4GRZEesbRRh69uaZL1xyR0CalIcVDHPN9E/CGM0vWTz0uLRLFSRgxing
         +Jc2U8bhj7Qkv62cS9ltd4EjweMKf1GUN0iAU5oE17u6crzkrxi3a2VXJeEIc6PF5gVD
         yPVKTF77L+yCZazu7rFeQWgkAZmzJMcbt2pHGPOywo5Dn+SpgehvK2bAVk9SWUVyIp9E
         iMWULRinuN3sGKnKgH4yK4Ues3wpBxliruU6WoA3/a/71EDT5xD2LWraTtvP3l5YUqee
         39SPby4OIXxqAYPP9F+e4R9bEwwwZUpXa2MRntKXf5LERKX4e33e7oLeT1f6QuHfI24/
         V++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717090014; x=1717694814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyL262HUI/eumvrqhAytpNCfzmfVssZxwMRgLZjf+EE=;
        b=Vsjy/BpcBCRkzWmx+m2V6/SzG8TdJtTrVf2TS/VIrtTg4NO2awopgJHyzvWNNNf+WM
         Tocc+4m6s05hSeXz+mFw5FH2NNthPIiAYPaltycmN3lk5C9IwRPMqxifXGQgUTQSkf0/
         7vcTFgZiKjH1ZyFiAKIA8NkxYEKXWFu5sU8anteIskstqM6ALLebJTwalRtiuH1jf8gO
         A8N/p5VLCNCkIXdW2vDStCqIQjgk8yF+zq//6FWyJPrNTP9Q++6ZGTZI7HfKSE8CURjT
         jmqWFmzJGS9cfbthogS+TvzDerzhFweikKFXKhI7+YG5KtEC95gzKfxXr7xTWgnP0emK
         LZHg==
X-Forwarded-Encrypted: i=1; AJvYcCUTFT+nhElBNM8GvwQWgxJOV1FmisYp3W8R8AaV7ekyncY2DAiq/XVZTGTA7/56J0VYt9J2IgQhnTl8rQK0TSrd4DKwJSUhEOE=
X-Gm-Message-State: AOJu0Yw9TC3HaJlU9O2+lfp4ynh+XLkhb9KyX27OFS37TJKYPClhYIqS
	BvAQrJ2H5o8n2bE+KTlqp6VnRhvsXJzoNN9XYLUBSFBRNa6cxJcSSaRd7jZe10s=
X-Google-Smtp-Source: AGHT+IHPM+Sum0UCb9oBUyBzm4YvF2v5KhwS+LHQ15UQzZG/KvGFbUm/Dvo9c4ljNRtFqhwKgGLXdg==
X-Received: by 2002:a05:6830:4414:b0:6f0:4f53:5128 with SMTP id 46e09a7af769-6f90af74225mr3097219a34.2.1717090013642;
        Thu, 30 May 2024 10:26:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f910550371sm35572a34.47.2024.05.30.10.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 10:26:53 -0700 (PDT)
Message-ID: <33676efb-c9e9-4ce1-bfff-954f8aac0bac@kernel.dk>
Date: Thu, 30 May 2024 11:26:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
 io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <9db5fc0c-cce5-4d01-af60-f28f55c3aa99@kernel.dk>
 <43205d1f-de49-4115-857f-c2c7db28b418@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <43205d1f-de49-4115-857f-c2c7db28b418@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/24 10:32 AM, Bernd Schubert wrote:
> 
> 
> On 5/30/24 18:21, Jens Axboe wrote:
>> On 5/30/24 10:02 AM, Bernd Schubert wrote:
>>>
>>>
>>> On 5/30/24 17:36, Kent Overstreet wrote:
>>>> On Wed, May 29, 2024 at 08:00:35PM +0200, Bernd Schubert wrote:
>>>>> From: Bernd Schubert <bschubert@ddn.com>
>>>>>
>>>>> This adds support for uring communication between kernel and
>>>>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>>>>> appraoch was taken from ublk.  The patches are in RFC state,
>>>>> some major changes are still to be expected.
>>>>>
>>>>> Motivation for these patches is all to increase fuse performance.
>>>>> In fuse-over-io-uring requests avoid core switching (application
>>>>> on core X, processing of fuse server on random core Y) and use
>>>>> shared memory between kernel and userspace to transfer data.
>>>>> Similar approaches have been taken by ZUFS and FUSE2, though
>>>>> not over io-uring, but through ioctl IOs
>>>>
>>>> What specifically is it about io-uring that's helpful here? Besides the
>>>> ringbuffer?
>>>>
>>>> So the original mess was that because we didn't have a generic
>>>> ringbuffer, we had aio, tracing, and god knows what else all
>>>> implementing their own special purpose ringbuffers (all with weird
>>>> quirks of debatable or no usefulness).
>>>>
>>>> It seems to me that what fuse (and a lot of other things want) is just a
>>>> clean simple easy to use generic ringbuffer for sending what-have-you
>>>> back and forth between the kernel and userspace - in this case RPCs from
>>>> the kernel to userspace.
>>>>
>>>> But instead, the solution seems to be just toss everything into a new
>>>> giant subsystem?
>>>
>>>
>>> Hmm, initially I had thought about writing my own ring buffer, but then 
>>> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
>>> need? From interface point of view, io-uring seems easy to use here, 
>>> has everything we need and kind of the same thing is used for ublk - 
>>> what speaks against io-uring? And what other suggestion do you have?
>>>
>>> I guess the same concern would also apply to ublk_drv. 
>>>
>>> Well, decoupling from io-uring might help to get for zero-copy, as there
>>> doesn't seem to be an agreement with Mings approaches (sorry I'm only
>>> silently following for now).
>>
>> If you have an interest in the zero copy, do chime in, it would
>> certainly help get some closure on that feature. I don't think anyone
>> disagrees it's a useful and needed feature, but there are different view
>> points on how it's best solved.
> 
> We had a bit of discussion with Ming about that last year, besides that
> I got busy with other parts, it got a bit less of personal interest for
> me as our project really needs to access the buffer (additional
> checksums, sending it out over network library (libfabric), possibly
> even preprocessing of some data) - I think it makes sense if I work on
> the other fuse parts first and only come back zero copy a bit later.

Ah I see - yes if you're going to be touching the data anyway, zero copy
is less of a concern. Some memory bandwidth can still be saved if you're
not touching all of it, of course. But if you are, you're probably
better off copying it in the first place.

>>> From our side, a customer has pointed out security concerns for io-uring. 
>>
>> That's just bs and fud these days.
> 
> I wasn't in contact with that customer personally, I had just seen their
> email.It would probably help if RHEL would eventually gain io-uring
> support - almost all of HPC systems are using it or a clone. I was
> always hoping that RHEL would get it before I'm done with
> fuse-over-io-uring, now I'm not so sure anymore.

Not sure what the RHEL status is. I know backports are done on the
io_uring side, but not sure what base they are currently on. I strongly
suspect that would be a gating factor for getting it enabled. If it's
too out of date, then performance isn't going to be as good as current
mainline anyway.

-- 
Jens Axboe


