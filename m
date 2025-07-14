Return-Path: <io-uring+bounces-8660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 460F6B03ABB
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 11:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FF30176CB8
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 09:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CA2234973;
	Mon, 14 Jul 2025 09:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftmH0aHG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6138823B63C
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 09:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752485091; cv=none; b=TwWoZ0ZyZOCoL6s3tn63d3qVxYZUPNA2/fvphXSPPghKDsDxECMzIAff4ceDRxsnRmimWcQBdAvHCt4ig82eJ/gI5g/29tCwwzkqLr/y1d5e2/ryGcG0AtoACXnLdJUdLbcbnIXzLYtr9fHMoxLI/+aJQZBppSTjkahBuwN7vIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752485091; c=relaxed/simple;
	bh=apOleQib9bq7Du0Zqt0R7XxMWoLEy0Wd/aqpCJcVcQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rVWgA7k6oUsRz64ZBWHqNQ/sAc0DIy4wuBre3W+LHjpavxwwRe2uOOn/wjxUbJ2JcZ0xEDiYYuTzoUAiTSSfqc0lu3sPuEyE+z1uGdoPXZrqZFaKJ98b0HVBqzF4aHk+umii4cEownPF4IhWvfPuhLfAnNEKE3OPSVRp/hKtPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftmH0aHG; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a16e5so7912629a12.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 02:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752485088; x=1753089888; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P7sJErr7/fsTTI+16WGvNgN0t0MlEJw86ym9gX4c8tc=;
        b=ftmH0aHG2lRFLdla2OtJI7YtBxriGurNA7mCK+W571jeSzkw+jZGRFMl6PE6NY84ze
         DAozf7xcRmHxPL65TaLtu0ZLnG1MzzLfL9kpzPaTdPeGICs3xSAxG6VJN5Dur5v1YNgv
         DciiT3ups873MyhD5ARXXorhnlBx+67iN3zmg9AKGa2jKuyeq7u3VD6DEAjedxP7KKPu
         jp/hMVMk5mIkpvyLCMn6nVl9FqAhltpqkXLNe8z9YP9IDXhWYGX2ELObmTLWkn9zWBAC
         yrYWlM8CBs8C1i1X1itZZz7cmOZmtCKZ3MjiptVe0NB6wzZXoKftneqSnDHmC1NuEgN6
         Oxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752485088; x=1753089888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7sJErr7/fsTTI+16WGvNgN0t0MlEJw86ym9gX4c8tc=;
        b=MYhprz6OGTexNvbJNAUURMtSe8gA68bi3UJ9D73FBZz2UblPz4fh7EOlUT/LoVgcmo
         nZ5hRp2GUJ867htlu8n2tI9fvjTTqHE/2cb3vxvBIq7UMJpmbq/1mlGVPXwTAUVi6Pv0
         VP+YTqQeY4yIRhRU6GAqL81Su16KwaTrsk/73DmG78N4cgryq5kBS/aoLXYnFDT3ciwH
         lyFngO+PHEpnM5wML88K1P/SVGJyR4Rm7K69tLgyZlbiatUOUFJ1Kz1mOT0wrcc1Semk
         Uvt8RAQ0LKTGTpjnSfk4CS6qwO7NYP1ildTC1mUpnYxyFTNykYuOwYoGnJYBP4I30fXD
         Njag==
X-Forwarded-Encrypted: i=1; AJvYcCWSUaTVQo1DafkJKA+iIz83tT2+aIka5gGIwuzunl5O1g7Xt1UNxzKaNxpJZeWVnzRJGE3WGvRiSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YztI3wY6Ji9TxaEDdNW+vnusrdI/tAxoPo7Z6DtReHuubJD6lJi
	Q/Y4k/NbSwRnPOMbPAJvsoDAnqyFNcaOkV/3PKQcnP0oiNWtdRjwKuMohJfh8w==
X-Gm-Gg: ASbGncsznggm2Aed7UEgfgjTspSA2YLg6frDTOta2w588m0xWohX7jxkEYITmycSTAu
	ttiUGGB3wKlyMB8j6ezRuCcq5YVs1gNi4gxdVHHji044P7maON1844ib4pHHwWBmpDvPkH9qZRy
	6PsCixbZcj+zN8CzCSN2/xLa7hNJIlDT7HZPTHLnNcSwH2bOq087LFzpCBE3/zWfYIUcLhVSyXf
	shpupdDn98LOqdywrnUErzbD/P22W0G8j2f/t0IMShBLaPHr637zcyhEciwkwRC0J/1VEHmfs/k
	NmZbx+YvDQktUnllHQfVTDhU4DleJTPMw6kvgVfjofxcxnR0IlJThNdneTJV1cmtR5MgdDtBOrs
	sDFeXBHHcebUctlFrcJbeE9wVP3meWYzMvCU=
X-Google-Smtp-Source: AGHT+IFm636AZDiIjNSWOyYcW+ARP4YiZ8uwNsfFthl2rAsQNL1u/JtYVx8dIiE90ZOO9Nz4J0bB6Q==
X-Received: by 2002:a17:907:3d9e:b0:ae3:a8ee:59ea with SMTP id a640c23a62f3a-ae6fc0efca1mr1195153066b.54.1752485087336;
        Mon, 14 Jul 2025 02:24:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:f749])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7e9235esm801470466b.12.2025.07.14.02.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 02:24:46 -0700 (PDT)
Message-ID: <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
Date: Mon, 14 Jul 2025 10:26:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
 <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/25 21:59, Jens Axboe wrote:
> On 7/12/25 5:39 AM, Pavel Begunkov wrote:
>> On 7/12/25 00:59, Jens Axboe wrote:
>>> No functional changes in this patch, just in preparation for being able
>>> to flag completions as having completed via being triggered from poll.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    include/linux/io_uring_types.h | 3 +++
>>>    io_uring/poll.c                | 1 +
>>>    2 files changed, 4 insertions(+)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index 80a178f3d896..b56fe2247077 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -505,6 +505,7 @@ enum {
>>>        REQ_F_HAS_METADATA_BIT,
>>>        REQ_F_IMPORT_BUFFER_BIT,
>>>        REQ_F_SQE_COPIED_BIT,
>>> +    REQ_F_POLL_WAKE_BIT,
>>>          /* not a real bit, just to check we're not overflowing the space */
>>>        __REQ_F_LAST_BIT,
>>> @@ -596,6 +597,8 @@ enum {
>>>        REQ_F_IMPORT_BUFFER    = IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>>>        /* ->sqe_copy() has been called, if necessary */
>>>        REQ_F_SQE_COPIED    = IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
>>> +    /* request went through poll wakeup machinery */
>>> +    REQ_F_POLL_WAKE        = IO_REQ_FLAG(REQ_F_POLL_WAKE_BIT),
>>>    };
>>>      typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>> index c7e9fb34563d..e1950b744f3b 100644
>>> --- a/io_uring/poll.c
>>> +++ b/io_uring/poll.c
>>> @@ -423,6 +423,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>                else
>>>                    req->flags &= ~REQ_F_SINGLE_POLL;
>>>            }
>>> +        req->flags |= REQ_F_POLL_WAKE;
>>
>> Same, it's overhead for all polled requests for a not clear gain.
>> Just move it to the arming function. It's also not correct to
>> keep it here, if that's what you care about.
> 
> Not too worried about overhead, for an unlocked or. The whole poll

You know, I wrote this machinery and optimised it, I'm not saying it
to just piss you off, I still need it to work well for zcrx :)
Not going into details, but it's not such a simple unlocked or. And
death by a thousand is never old either.

> machinery is pretty intense in that regard. But yeah, do agree that just
> moving it to arming would be better and more appropriate too.
> 
> I'm still a bit split on whether this makes any sense at all, 2-3 really

Right, that what I meant by unclear benefit. You're returning
information from past when it's be already irrelevant, especially
so for socket tx with how they handle their wait queue wakeups.

-- 
Pavel Begunkov


