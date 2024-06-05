Return-Path: <io-uring+bounces-2123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9488FD210
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 17:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3010F280FC1
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 15:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF381D524;
	Wed,  5 Jun 2024 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCsZwcGx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED4419D8A5
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717602604; cv=none; b=iNCgxo5GpZGiMqMON1q+pqVt/MI3rPpNvCaIH/GylagEFtX2RSU6xQIKWghJ5QMTdnkQvH93NmMCvIYLUWB9so3PB2STnpA3B3j+2ONG6sdl1Fpd8YkUSB8GZUAL/i2NVzVTnKBwUVXkOv72XvcDbDcQ0hLH6evnR+Iyik/B4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717602604; c=relaxed/simple;
	bh=6xwbOed/kIqOQwzXoV27iyQQQtzTPDmXfDnOPTD7geA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N4+IFnSrCZLcRbRU5xg83In+AbxfT62jrkTOwY6YgdBYmBg0Domau9MVhCF6qLjT9oZ8cPinluDRl0O9nt5ZL9GwV5TXBVkQ5p73OM2qS8rNPSlmfGC9K5KI1IEXw1HXWGuJT4Xr2DBONoMgXQg+7Cdv118dm+9y6k/ADhW9BJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VCsZwcGx; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2eaa80cb4d3so1340461fa.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 08:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717602601; x=1718207401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zaZ+0eA1zux7qYZJN55z2xQBQG7/yiikSHlYOAfhQM8=;
        b=VCsZwcGxBUnIK0ZddFqc0NxXQdn823kh4lm30dgaulf0fXKxHUC+MX3QpYfpCcOLF2
         V2siMK4PgNRE5+Y6pO6aihhI6580GknJfgwdCZqZ+aSMaMNKIPSg244+JmSGrR439Ohu
         vV4bpHH8Pedfbs90nNtf52vVWitxPJOEKpOhWpL2DOClTZknU4af/AoSnV/+/d8FZeuZ
         3SopH3dTBNSmLjt5OWKF2cjwrYl+BMcYf/g+TbWVW32ckevgTElLclDihr535CJoG6SI
         MqEdK/0b1+k8DaJWvFN8LuCQnd3yCewSFSS5ysmAUfsVx8Ml2fVCQ5FMeMlmWHYJZQBL
         J7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717602601; x=1718207401;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zaZ+0eA1zux7qYZJN55z2xQBQG7/yiikSHlYOAfhQM8=;
        b=cVFn5fLawrxmT8S+3r70EM3FSjP9nbqt7Iw4EJsT3PzMYyNtfg/w5oKq4NHla4EVSS
         8itjAdjFspti1OWf24jG0ZHdj7oTB119I/SEIuuXReVdjoUpiOn4eLEbTTL5H9+nV5rq
         +CjIsoAMd+jIPeBKORbfp26Ns2XjQLaTJYqmou4q1G0ADdnmCWqsjeeyJaKdZ7lRlSUB
         6fgnPIM5yuCWBaSqIEq9NcyMLH91gRYVYCq7fTAsfWfylvFmUK6actoUnmU6XJScX8/P
         /nUfP9A1U1/YjY6KfRcSNkZaWIg31gHteLVWltKUrRMLqVlmDAOxJr/6E81U6na0dX80
         q41A==
X-Forwarded-Encrypted: i=1; AJvYcCV2F7JtQ2JDxcwSNRdRez2Xj8tEIq6xewmVv9Hu96yw/MMon3w7xN4Cr5Dye9KBdLI+gVSxLUcMiReXiznd5HucCXaZlv2QsQQ=
X-Gm-Message-State: AOJu0YzRpIjYjIhe8Ju16JnSVYDbJU9JpPekowfS8/d9UrWwPkfnuwTn
	wRkoyjOaCPMVEeqakidTQJWltYTXnoDDkDI+y64W6lNSC8itIgSh11AG0A==
X-Google-Smtp-Source: AGHT+IGMzgEt2qrwfI8WjpR7fWDeT0v+W6N8PxRJogmPpyN/KCX7QCkf4E1/X9QVp9sFY07D3zvv7g==
X-Received: by 2002:a2e:b013:0:b0:2ea:aca0:2765 with SMTP id 38308e7fff4ca-2eac7980c60mr21808761fa.5.1717602600578;
        Wed, 05 Jun 2024 08:50:00 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c6fc19beasm57483266b.80.2024.06.05.08.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 08:50:00 -0700 (PDT)
Message-ID: <6c8ca196-2444-4c82-a8c0-a93f45fe47da@gmail.com>
Date: Wed, 5 Jun 2024 16:50:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
 <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 19:57, Jens Axboe wrote:
> On 6/3/24 7:53 AM, Pavel Begunkov wrote:
>> On 5/30/24 16:23, Jens Axboe wrote:
>>> Hi,
>>>
>>> For v1 and replies to that and tons of perf measurements, go here:
>>
>> I'd really prefer the task_work version rather than carving
>> yet another path specific to msg_ring. Perf might sounds better,
>> but it's duplicating wake up paths, not integrated with batch
>> waiting, not clear how affects different workloads with target
>> locking and would work weird in terms of ordering.
> 
> The duplication is really minor, basically non-existent imho. It's a
> wakeup call, it's literally 2 lines of code. I do agree on the batching,

Well, v3 tries to add msg_ring/nr_overflow handling to local
task work, that what I mean by duplicating paths, and we'll
continue gutting the hot path for supporting msg_ring in
this way.

Does it work with eventfd? I can't find any handling, so next
you'd be adding:

io_commit_cqring_flush(ctx);

Likely draining around cq_extra should also be patched.
Yes, fixable, but it'll be a pile of fun, and without many
users, it'll take time to discover it all.

> though I don't think that's really a big concern as most usage I'd
> expect from this would be sending single messages. You're not batch
> waiting on those. But there could obviously be cases where you have a
> lot of mixed traffic, and for those it would make sense to have the
> batch wakeups.
> 
> What I do like with this version is that we end up with just one method
> for delivering the CQE, rather than needing to split it into two. And it
> gets rid of the uring_lock double locking for non-SINGLE_ISSUER. I know

You can't get rid of target locking for fd passing, the file tables
are sync'ed by the lock. Otherwise it's only IOPOLL, because with
normal rings it can and IIRC does take the completion_lock for CQE
posting. I don't see a problem here, unless you care that much about
IOPOLL?

> we always try and push people towards DEFER_TASKRUN|SINGLE_ISSUER, but
> that doesn't mean we should just ignore the cases where that isn't true.
> Unifying that code and making it faster all around is a worthy goal in
> and of itself. The code is CERTAINLY a lot cleaner after the change than
> all the IOPOLL etc.
> 
>> If the swing back is that expensive, another option is to
>> allocate a new request and let the target ring to deallocate
>> it once the message is delivered (similar to that overflow
>> entry).
> 
> I can give it a shot, and then run some testing. If we get close enough
> with the latencies and performance, then I'd certainly be more amenable
> to going either route.
> 
> We'd definitely need to pass in the required memory and avoid the return

Right, same as with CQEs

> round trip, as that basically doubles the cost (and latency) of sending

Sender's latency, which is IMHO not important at all

> a message. The downside of what you suggest here is that while that
> should integrate nicely with existing local task_work, it'll also mean
> that we'll need hot path checks for treating that request type as a
> special thing. Things like req->ctx being not local, freeing the request
> rather than recycling, etc. And that'll need to happen in multiple
> spots.

I'm not suggesting feeding that request into flush_completions()
and common completion infra, can be killed right in the tw callback.

-- 
Pavel Begunkov

