Return-Path: <io-uring+bounces-733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B399086786D
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66330291932
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 14:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2646129A64;
	Mon, 26 Feb 2024 14:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mFX52nlm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EAB128363
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957645; cv=none; b=hnFgs5keW2/3PterDGPsrNgycxpkeWbClfarDujT3xSAlmIPg2aG+jVc/xT2HrYCcJrhmZQZXJA6MIDX0QIOZeGF6FvurvRJQkvlmmKTSL30+DO8hpbXXw6DFOI2ksz1442zUZQf66KNN7nWpjkv9EI/EH74tIIB2wunJKe+fvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957645; c=relaxed/simple;
	bh=1aYz5A/nkMZSX1jt/5nA4EWf61IsxpaLzgXBtTbfB4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wdav9enMcRUwBGJ5OQCzAZqYLvFAmUmh+MuOXbxgl4Ob6DkD0G6w5I9+LzygBXipNP6QqT8tK1VzPM2EK1kmdMgFJMH1mHQO77f6+TMlsEx7UNRXXJc5TLahChNejy3cgxDty3af1iadP6VKDQpWSOhjQi7G8Xxu+bkL2NXFbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mFX52nlm; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7c7b076562cso22885239f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 06:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708957641; x=1709562441; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6KDWiHjAjKmVfFIHeny14eWC022y01Opyyp0WZjULU=;
        b=mFX52nlm83AKnvtWm+keacngnQnl46FuaGcuR2l3dJr7wL+FEP31GMQ5cI3B1uRugz
         KHNTlEPMynpS2yrw4mN5fnPWqR/VaWSSgCCI6bN+ylQw45cOOz1hZkiSSWXScTetUR/b
         KL4Dcp93UNxKHLh3nc5MhkINmNxoVZsYf2vRF+PbB9pxLYH1YSMFn/DcQRWvAEaJ+xAW
         pDmGy+R9juH6d4x3jjIecQqq1hrcXmI2A8voTwW+z49j9Vn3fEMs2DH9413uK0YKjB5m
         ETB9haY8BJpkmt0LhJlra6pLetZWsWE5qdEQo7e9cER2WtyJxxU0F81Mxd8Sd7qWaOR0
         zm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708957641; x=1709562441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6KDWiHjAjKmVfFIHeny14eWC022y01Opyyp0WZjULU=;
        b=JHUrw4NcKOJEpyn+Hf/f+/4MHFUtItv1AExHpTK3PtvV4GNkaG8qkG1BOxO8k5ogT0
         qb7RJT0b4IRG57nWE9ezH848ot1toHL8F7t0j0g07dAQkrU7S6y/3UZnKHwnMRAjxeI2
         SMp40swEbfa01xxy5nm5TGAYy/OMLnxd8PTwf4I7JDOeL4PPrB/G2C73pSwFsbL4cl+E
         Vei9g3tcdBNokWeiPWHOEXCJyG8dFzy/Srr5JUQxK502ZPNgGsKpQK2xouqBmPN5CvGn
         wBofuxzj6l0dsm7XfRzWXGgcB8G/VJKsk5uLeme274c3ldsqZaXbDiWLNfeuzfqSj+9X
         PiCw==
X-Gm-Message-State: AOJu0Yw5Tqrc7HpopIH5n0j/1IT+I2l2KlbhQXQPtxjRI3muO2QZZ61p
	uvIi5k1vf/ict4lI5MJ/sneX0x8w5lsWvLs+A3j8eDx6l2+NWy+HfI4zsvQOqPg=
X-Google-Smtp-Source: AGHT+IH53opMWurvdxuxvluUPhIL9biCAwXWxhsd111pHZpo3vWbTxKiRmnD7kWocHGQC1xW9AgqEg==
X-Received: by 2002:a6b:6d08:0:b0:7c7:ba40:4ba8 with SMTP id a8-20020a6b6d08000000b007c7ba404ba8mr3495139iod.1.1708957641012;
        Mon, 26 Feb 2024 06:27:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l12-20020a02a88c000000b0047483f40014sm649074jam.7.2024.02.26.06.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:27:20 -0800 (PST)
Message-ID: <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
Date: Mon, 26 Feb 2024 07:27:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 7:02 AM, Dylan Yudaken wrote:
> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> This works very much like the receive side, except for sends. The idea
>>>> is that an application can fill outgoing buffers in a provided buffer
>>>> group, and then arm a single send that will service them all. For now
>>>> this variant just terminates when we are out of buffers to send, and
>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>> set, as per usual for multishot requests.
>>>>
>>>
>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>> described, unless I'm missing something?
>>
>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>> try again" where multishot is "send data from this buffer group, and
>> keep sending data until it's empty". Hence it's the mirror of multishot
>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>> it'd be smart to add special meaning to MSG_WAITALL with provided
>> buffers.
>>
> 
> _If_ you have the data upfront these are very similar, and only differ
> in that the multishot approach will give you more granular progress
> updates. My point was that this might not be a valuable API to people
> for only this use case.

Not sure I agree, it feels like attributing a different meaning to
MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
would seem to be confusing. Particularly when we have multishot on the
receive side, and this is identical, just for sends. Receives will keep
receiving as long as there are buffers in the provided group to receive
into, and sends will keep sending for the same condition. Either one
will terminate if we run out of buffers.

If you make MSG_WAITALL be that for provided buffers + send, then that
behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
send _without_ provided buffers. I don't think overloading an existing
flag for this purposes is a good idea, particularly when we already have
the existing semantics for multishot on the receive side.

> You do make a good point about MSG_WAITALL though - multishot send
> doesn't really make sense to me without MSG_WAITALL semantics. I
> cannot imagine a useful use case where the first buffer being
> partially sent will still want the second buffer sent.

Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
make it implied for multishot send. Currently the code doesn't deal with
that.

Maybe if MSG_WAITALL isn't set and we get a short send we don't set
CQE_F_MORE and we just stop. If it is set, then we go through the usual
retry logic. That would make it identical to MSG_WAITALL send without
multishot, which again is something I like in that we don't have
different behaviors depending on which mode we are using.

>>> I actually could imagine it being useful for the previous patches' use
>>> case of queuing up sends and keeping ordering,
>>> and I think the API is more obvious (rather than the second CQE
>>> sending the first CQE's data). So maybe it's worth only
>>> keeping one approach?
>>
>> And here you totally lost me :-)
> 
> I am suggesting here that you don't really need to support buffer
> lists on send without multishot.

That is certainly true, but I also don't see a reason _not_ to support
it. Again mostly because this is how receive and everything else works.
The app is free to issue a single SQE for send without multishot, and
pick the first buffer and send it.

> It's a slightly confusing API (to me) that you queue PushBuffer(A),
> Send(A), PushBuffer(B), Send(B)
> and get back Res(B), Res(A) which are in fact in order A->B.

Now I'm confused again. If you do do the above sequence, the first CQE
posted would be Res(A), and then Res(B)?

> Instead you could queue up PushBuffer(A), Send(Multishot),
> PushBuffer(B), and get back Res(Multishot), Res(Multishot)
> which are in order A -> B.

There should be no difference in ordering of the posted completion
between the two.

-- 
Jens Axboe


