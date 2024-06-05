Return-Path: <io-uring+bounces-2131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE25B8FD69E
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 21:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEFE31C22269
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 19:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7471B1514D2;
	Wed,  5 Jun 2024 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HwU7jKxM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B01514E6
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 19:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717616200; cv=none; b=boJb1nbm6RlmjTLCT8Rg3p8+WPdMdQUabTZmtNUrCnzpBuJP/zeLebjTNqbzgqbSy7qgy5YWryH9VyudSbK1gTi2hhMEHHL72RqwyBXt3h55CeTrJujl7P47Zbe0JdS5blZ+I2rYDqtliH7Q4QNnw+Cirr8Ez1JqgjkemorY/Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717616200; c=relaxed/simple;
	bh=vS7npmT6KX0w2F+7R/og1G8aMIM/7lQ5Op7KWO0cst0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X/lWf+prTS9B+6u9AO+6LVlvnjr2bpdTdC1ra77tnXAvjZQP8XoITEnDe1GGSS0FhFvPzZlnDGVHskz5cpkKMG0zabmCzpLCr5sfVyjChuBFsyamD2Y471wkXB38Qgo/VygukTb2Oke4QZDBiT/GKPd7OlTaMtdjJJn3JCVOq+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HwU7jKxM; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d1fc46a23cso5299b6e.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 12:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717616197; x=1718220997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1OS5mxGMpOsHdVRQtaO20JZTurCKXl0TfsMKwlv9F7U=;
        b=HwU7jKxMyZZ3cE/2fiLJRl+ZqKP4g2wx+mthy1NgQEgE5lGmb/h5No7U9ReDxMk3rI
         BdbK0eqhcNiQlmpl8hd9JZUGHwJlWisyj6N711CX+8qzVtgFXD3hAi62P6eL/tJuHCll
         B7g9ixE2IjV0idseBQ/i9MpTiFztGn7ywmRmtWAtkHUCwJ0UG79uSArC3sfgVSfa/h3L
         x2IP2olkoVOGm9GuYo4u1dEAvS7ZilbnOr06u8PDggxGAYUVbqhYyr5fpb2oUsUtGt6C
         bZuwsz/eioM3BjJW5WLmWF4jmrJ9uYmD5M+CAD5oUDxGW8Cy2DmapTWCT08WE/7vgE5I
         Z48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717616197; x=1718220997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1OS5mxGMpOsHdVRQtaO20JZTurCKXl0TfsMKwlv9F7U=;
        b=PQE4CF3YT0sH9EYxLcHdJKB38Mp/1xncmdmHOIq1NFQJcPX/wwZFxF3vqSKFYAXLwU
         eosVRIWOWiveJrvz1tfpyc5KwU9E8opbdeprr1TS35gvsSloKyOVyW/TiEFtsf34oM93
         YTKRkXtQcDyzHIikSecBZFHghb428/CAjS2L5bG3lsNOA4ZSs9Q/1ERR8A21Wbf1kOf8
         qEOd82j/mGWARB/zl2pCgQjlvWgNYKhYPUiKr0DMXRnx3HQ7XMGdx8nLAdxb0Goj6jd2
         TGqRKk8rthAhxLQPLRC2z6MqyBsQ1kxMpkFTRxS/V/OvW6b7ZgEIh5brjewNsN/6XLXQ
         eb0w==
X-Forwarded-Encrypted: i=1; AJvYcCWSDY0Dx8h9t+qi8IGDrsQ6iB8fIxWH0HqCSwakkFyAau4689JUzjlg7KePKRtJqGPkcw5RKjb+ummi0kYk5+VRI5hp6kdd/bw=
X-Gm-Message-State: AOJu0Yyy+0G5vplzlaL3KZp9tTXcGb36lJy0U9wt6aHuCr0EAiOu5qxV
	jcZt23Zpt6PYISjL36euzMBPxeeWy2nluYhQmNhoKcvQgU3UpGLwCCP0eXgsi+EYiK+k+m45qaw
	k
X-Google-Smtp-Source: AGHT+IEAqPzfWHmfJ0YoWBU91OsD5wM+/M8IF8QOa8/6JbGJ/zNfGBVz6uS9524lQyUWtlvfg/rbgQ==
X-Received: by 2002:a05:6808:1794:b0:3c8:2af6:1125 with SMTP id 5614622812f47-3d204261742mr3289631b6e.1.1717616196461;
        Wed, 05 Jun 2024 12:36:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1e1a45d5esm2289185b6e.43.2024.06.05.12.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 12:36:35 -0700 (PDT)
Message-ID: <e7ea61b8-a65b-461b-a927-e85f47918cbe@kernel.dk>
Date: Wed, 5 Jun 2024 13:36:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
 <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
 <6c8ca196-2444-4c82-a8c0-a93f45fe47da@gmail.com>
 <e89d6035-8a96-413b-9d80-f4092d18738a@kernel.dk>
 <2027706f-971f-4552-aa0a-95c1db675cb2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2027706f-971f-4552-aa0a-95c1db675cb2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 1:20 PM, Pavel Begunkov wrote:
> On 6/5/24 17:41, Jens Axboe wrote:
>> On 6/5/24 9:50 AM, Pavel Begunkov wrote:
>>> On 6/4/24 19:57, Jens Axboe wrote:
>>>> On 6/3/24 7:53 AM, Pavel Begunkov wrote:
>>>>> On 5/30/24 16:23, Jens Axboe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> For v1 and replies to that and tons of perf measurements, go here:
>>>>>
>>>>> I'd really prefer the task_work version rather than carving
>>>>> yet another path specific to msg_ring. Perf might sounds better,
>>>>> but it's duplicating wake up paths, not integrated with batch
>>>>> waiting, not clear how affects different workloads with target
>>>>> locking and would work weird in terms of ordering.
>>>>
>>>> The duplication is really minor, basically non-existent imho. It's a
>>>> wakeup call, it's literally 2 lines of code. I do agree on the batching,
>>>
>>> Well, v3 tries to add msg_ring/nr_overflow handling to local
>>> task work, that what I mean by duplicating paths, and we'll
>>> continue gutting the hot path for supporting msg_ring in
>>> this way.
>>
>> No matter how you look at it, there will be changes to the hot path
>> regardless of whether we use local task_work like in the original, or do
>> the current approach.
> 
> The only downside for !msg_ring paths in the original was
> un-inlining of local tw_add().

You're comparing an incomplete RFC to a more complete patchset, that
will not be the only downside once you're done with the local task_work
approach when the roundtrip is avoided. And that is my comparison base,
not some half finished POC that I posted for comments.

>>> Does it work with eventfd? I can't find any handling, so next
>>> you'd be adding:
>>>
>>> io_commit_cqring_flush(ctx);
>>
>> That's merely because the flagging should be done in io_defer_wake(),
>> moving that code to the common helper as well.
> 
> Flagging? If you mean io_commit_cqring_flush() then no,
> it shouldn't and cannot be there. It's called strictly after
> posting a CQE (or queuing an overflow), which is after tw
> callback execution.

I meant the SQ ring flagging and eventfd signaling, which is currently
done in local work adding. That should go in io_defer_wake().

-- 
Jens Axboe


