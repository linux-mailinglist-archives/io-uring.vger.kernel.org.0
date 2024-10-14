Return-Path: <io-uring+bounces-3670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7DD99D5C9
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92DBC1F2328B
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9003A1AE850;
	Mon, 14 Oct 2024 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKODWITP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB32231C8A
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928071; cv=none; b=a7UEI+nMrP0ZwZ7VsC0f7ovGP6oE1rhE520XCqFfYNad/X7Gth9QA35xbVYA7kl7amLITKV7fDzqqMnieNSXdBy3i5/HzekroBBRPFIF8gym9z8LPupijfFzJb/65SSeUOYrrJaMu7TWJtqsFPdtuHVK5BvLCmTpuS/MQHt7xm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928071; c=relaxed/simple;
	bh=Ae2eFWKs2DICyuhJF5WOveCVqd1vBgj7av8vdTiKu2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6KlqBbgUBbsU4gn4pvgwIvP17rmyF8v96Bsa8MwsKkcl4gp2lfNruNEQg8y/ib/wll0CvsHV6W3we+OfAkR54p3fsM7nJnzHyjdn9Pn8+elXYtUJOPSohsCxt9futze/u4Nerq+cR6xR8jRTOkYFIgGBB/84vzEWxqWsL9UD3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKODWITP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43115887867so30800405e9.0
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728928068; x=1729532868; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HY2pIgVaiomVHdf5KxIuoBCM6/gxyToAISsKl+hhmEc=;
        b=fKODWITPwYb2Bg4a6R+rSTx8TXrhfFi48Iwe8D1V/mLpJ+h90rZTaTn6tezJRzWfBo
         zVdrMiKKPhP5nzvUtRLGlh+WJUPqLjl44BF8TsXgqB+Pdh3qT0Plr8MlJj5Vy2DLV97w
         Pn3ELCxzbb4NdVpRCin4MekgmDrTHVZIYygmF+zQv8hlVZr3z172vSl5rZcmtD7uCMER
         q4h40dKCjVE3Az/jvslE8miyRphzUAghBRYxAd64IoiaKvmmPAAaLm9xFwWynfGcARll
         77lnpAOiqqlav2flsDJE0GDdglTncAuDVR1mjnqKe1DoRzMv2Clmf9a4jil5Z+/zWNxS
         69XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728928068; x=1729532868;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HY2pIgVaiomVHdf5KxIuoBCM6/gxyToAISsKl+hhmEc=;
        b=pCe8kgfADG204MkbmM6g6ZA1qIlhxc/gm0hFCpiRat45i0AR7ZC7/dN3pt2eaY6c1k
         UhT+dVyVLx18NpHlI+ESSVkPm/orBtBnW4batm6GCTbaO2yLOKF/h//QcA68mQa4uMEY
         7cZUZrIDjQ6t7DLQSefGIEUEsC/dpH99/jkTWBYEq42aGw5nxTPvCKIQm+0WXEXbAhIP
         9W9bB5dNGlI+86LgiBQb0GQUYIVvPG0m9G1MK0dtAiIs/ixouC6D27uOzMSmGaEDameo
         iQupdR+Zt94aNiCmg5C4dboO+nHFD7B1lxPKSxMc3ewS9SQ/ru8ydatxNtLpWY3bPsUA
         zERQ==
X-Forwarded-Encrypted: i=1; AJvYcCU06eJLV4T4ZCFe3D2rMIxNSk6eAvZpTI9Qp/MmPWZFiJMclwwWymARS7TLomDaDEC/1xoX4P0LEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoXiuQd1/+jnASEij99gXBolDH0hztXoDW/9fIHo50JfwroSAI
	mB6m9c3dRm18NOgG6rvzdSoRuv9exTIIHGM2Z/19gc2XU/1I3W5c
X-Google-Smtp-Source: AGHT+IEZZX9qF+rhnNqt4XjddoZp2AjgLPUFz9rqrixoYAXs+obQ7LuFMuDihqfmu5UOWYh99Pu3Ww==
X-Received: by 2002:a05:600c:5121:b0:42c:b991:98bc with SMTP id 5b1f17b1804b1-43115a27eddmr136149725e9.0.1728928067668;
        Mon, 14 Oct 2024 10:47:47 -0700 (PDT)
Received: from [192.168.42.172] (82-132-213-68.dab.02.net. [82.132.213.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4311835d7b2sm127955595e9.42.2024.10.14.10.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 10:47:47 -0700 (PDT)
Message-ID: <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
Date: Mon, 14 Oct 2024 18:48:13 +0100
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
 <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
 <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/24 16:21, Bernd Schubert wrote:
> On 10/14/24 15:34, Pavel Begunkov wrote:
>> On 10/14/24 13:47, Bernd Schubert wrote:
>>> On 10/14/24 13:10, Miklos Szeredi wrote:
>>>> On Mon, 14 Oct 2024 at 04:44, Ming Lei <tom.leiming@gmail.com> wrote:
>>>>
>>>>> It also depends on how fuse user code consumes the big CQE payload, if
>>>>> fuse header needs to keep in memory a bit long, you may have to copy it
>>>>> somewhere for post-processing since io_uring(kernel) needs CQE to be
>>>>> returned back asap.
>>>>
>>>> Yes.
>>>>
>>>> I'm not quite sure how the libfuse interface will work to accommodate
>>>> this.  Currently if the server needs to delay the processing of a
>>>> request it would have to copy all arguments, since validity will not
>>>> be guaranteed after the callback returns.  With the io_uring
>>>> infrastructure the headers would need to be copied, but the data
>>>> buffer would be per-request and would not need copying.  This is
>>>> relaxing a requirement so existing servers would continue to work
>>>> fine, but would not be able to take full advantage of the multi-buffer
>>>> design.
>>>>
>>>> Bernd do you have an idea how this would work?
>>>
>>> I assume returning a CQE is io_uring_cq_advance()?
>>
>> Yes
>>
>>> In my current libfuse io_uring branch that only happens when
>>> all CQEs have been processed. We could also easily switch to
>>> io_uring_cqe_seen() to do it per CQE.
>>
>> Either that one.
>>
>>> I don't understand why we need to return CQEs asap, assuming CQ
>>> ring size is the same as SQ ring size - why does it matter?
>>
>> The SQE is consumed once the request is issued, but nothing
>> prevents the user to keep the QD larger than the SQ size,
>> e.g. do M syscalls each ending N requests and then wait for

typo, Sending or queueing N requests. In other words it's
perfectly legal to:

It's perfectly legal to:

ring = create_ring(nr_cqes=N);
for (i = 0 .. M) {
	for (i = 0..N)
		prep_sqe();
	submit_all_sqes();
}
wait(nr=N * M);


With a caveat that the wait can't complete more than the
CQ size, but you can even add a loop atop of the wait.

while (nr_inflight_cqes) {
	wait(nr = min(CQ_size, nr_inflight_cqes);
	process_cqes();
}

Or do something more elaborate, often frameworks allow
to push any number of requests not caring too much about
exactly matching queue sizes apart from sizing them for
performance reasons.

>> N * M completions.
>>
> 
> I need a bit help to understand this. Do you mean that in typical
> io-uring usage SQEs get submitted, already released in kernel

Typical or not, but the number of requests in flight is not
limited by the size of the SQ, it only limits how many
requests you can queue per syscall, i.e. per io_uring_submit().


> and then users submit even more SQEs? And that creates a
> kernel queue depth for completion?
> I guess as long as libfuse does not expose the ring we don't have
> that issue. But then yeah, exposing the ring to fuse-server/daemon
> is planned...

Could be, for example you don't need to care about overflows
at all if the CQ size is always larger than the number of
requests in flight. Perhaps the simplest example:

prep_requests(nr=N);
wait_cq(nr=N);
process_cqes(nr=N);

>>> If we indeed need to return the CQE before processing the request,
>>> it indeed would be better to have a 2nd memory buffer associated with
>>> the fuse request.
>>
>> With that said, the usual problem is to size the CQ so that it
>> (almost) never overflows, otherwise it hurts performance. With
>> DEFER_TASKRUN you can delay returning CQEs to the kernel until
>> the next time you wait for completions, i.e. do io_uring waiting
>> syscall. Without the flag, CQEs may come asynchronously to the
>> user, so need a bit more consideration.
>>
> 
> Current libfuse code has it disabled IORING_SETUP_SINGLE_ISSUER,
> IORING_SETUP_DEFER_TASKRUN, IORING_SETUP_TASKRUN_FLAG and
> IORING_SETUP_COOP_TASKRUN as these are somehow slowing down
> things.

Those flags are not a requirement, you can try to size the
CQ so that overflows are rare, it's just a bit easier to do
with DEFER_TASKRUN.

> Not sure if this thread is optimal to discuss this. I would
> also first like to sort out all the other design topics before
> going into fine-tuning...

-- 
Pavel Begunkov

