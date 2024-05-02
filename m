Return-Path: <io-uring+bounces-1704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AECE8B9C0E
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 16:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008FB281D06
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 14:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E508E12DDBF;
	Thu,  2 May 2024 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nzl6r5jd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA713C3CA;
	Thu,  2 May 2024 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714658940; cv=none; b=X/rv/cuE15hWUaGfAfUqqSQWFqVTc0ZeVRdZZSYkL6prWCoIZtCJFhmy91anNcUwdqVMYNQocNBkiezKqAV0p8FLUDuk8O5EqdgHcAIhvTA/yJNhJD9+id5XbxU1j7Q/l/WhAtS4D5aQkN53ylm923ZISPrND+ivNFtKPrJk2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714658940; c=relaxed/simple;
	bh=v3yYV10fOk69u1sV4Gu93nsx8mcu8tSFXIY1ZchUVDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tk9Yif+kjEUN/e9ubJZlvhNKw5gPZA/+X4S2fNMdm1vLn7vmoK7M36wLJnSMfrrmH/zw1TfoDS+F0WMlL9t+U83fgClPAJlJMN6zrbA5gd4jjpGyE0MSNDb9K4zEN3Moox3S9eYBRn5zfADC30dKeuK+rkR2U6B5pK1bXmWDKHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nzl6r5jd; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a597de5a715so28230966b.2;
        Thu, 02 May 2024 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714658937; x=1715263737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dG1Y2UTVEYcck7yqnR/l1oFReUoaO7wGNhzOSuGwNBQ=;
        b=Nzl6r5jdev+l+4JEOj0RS802n1USvp+BYdMN3fq0TIJZI5ce+1mPoq9Zgp7wfi0YkC
         knc0iyltSa/wYdGguyZcVLMxIcye9xyRZVAiG8XuSmEGeQlI5HEqVgLyD3pfJ1VvIj2O
         tlxZAP04TU7UQtQfJC4l3VgsX7k5Ad2UfvTm5uwg6a20k5LtXQhnby1svebA4Gact4sV
         HEA5HteiS5glhZyCSOUzhNXHhNd4VVPpgUn1HAJUqyzjhFtm5OQ9VJ3veJRN9h8RphPh
         ohvg8wpiZUENzdqv2VKulk1NPa8k8FBWTwAemjqZPIpzEYItfDRf1s7lcg+RLxboGvHt
         +Ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714658937; x=1715263737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dG1Y2UTVEYcck7yqnR/l1oFReUoaO7wGNhzOSuGwNBQ=;
        b=eE97EEVJMT24dMFo0eZVX46/Qge64jrZjnnBFn0zErEgUkzf3pHYhHq3goLTZDZqx9
         He7XcAWwFVPgbElUqRLoVFvKNKqs9kXB8zFkeGZSPqG5Qpu+RWK4ASvAmNYPFuCz3Crr
         fRahbA+oXhFvIEmumTkZBxikhIylPiRRJ0P62u3ZW16qFDYpMW76scFnZABkyRi2vwpw
         vm+Dv7pKGP311H12EboNBhv+wF3GjB3PVb0J3Zvw2VrTym5QiRZowd+DuHfvC3vqBzGw
         3bvzk30rPQjJd4cuMdjyqQQREQLucatDQsKJ5kMa9E+h53EQbtxLIHz6EBCEDrfbioHX
         PxaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJy+6SO2k9p8Zi9+IFbK1S6aL0G0KEaQkwXzfRQ1rPC36BDRXWk43r5vA1KSo8vAQWnl2LOYidUpGVvwyuucJkbev92YzopQaf3a+usDjpEd8ZzsxNnW+tW1zi22wsjwXSWm2gKQ==
X-Gm-Message-State: AOJu0YzRqwN1vPLVXJlhX6nT5Vkb0K+bjDf29ZDbkCWyur+pPR/3YiOE
	eWxzTNuGPXH4MU1aS7F+EQsL8CESToK0rUuH6fLdXRyJm2SZtkQg
X-Google-Smtp-Source: AGHT+IFXsV6mWaUov14PtswbwTmjPVUmBbZwy/a0opAqCyvZmi1h2MsfFU1FbGlbRYp0UgkzGNToyg==
X-Received: by 2002:a50:934f:0:b0:56b:ec47:a846 with SMTP id n15-20020a50934f000000b0056bec47a846mr3372722eda.25.1714658936651;
        Thu, 02 May 2024 07:08:56 -0700 (PDT)
Received: from [192.168.42.210] ([163.114.131.65])
        by smtp.gmail.com with ESMTPSA id eo4-20020a056402530400b00571d5c4a220sm567149edb.7.2024.05.02.07.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 07:08:56 -0700 (PDT)
Message-ID: <bc3f89dd-fa94-4f0f-b7e9-d6ac37a7c185@gmail.com>
Date: Thu, 2 May 2024 15:09:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
 <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
 <Ziey53aADgxDrXZw@redhat.com>
 <6077165e-a127-489e-9e47-6ec10b9d85d4@gmail.com> <ZjBffAzunso3lhsJ@fedora>
 <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com> <ZjEHhRoGP8z4syuP@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZjEHhRoGP8z4syuP@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 16:00, Ming Lei wrote:
> On Tue, Apr 30, 2024 at 01:27:10PM +0100, Pavel Begunkov wrote:
>> On 4/30/24 04:03, Ming Lei wrote:
>>> On Mon, Apr 29, 2024 at 04:32:35PM +0100, Pavel Begunkov wrote:
>>>> On 4/23/24 14:08, Kevin Wolf wrote:
>>>>> Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
>>>>>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>>>>>> SQE group is defined as one chain of SQEs starting with the first sqe that
>>>>>>> has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
>>>>>>> doesn't have it set, and it is similar with chain of linked sqes.
>>>>>>>
>>>>>>> The 1st SQE is group leader, and the other SQEs are group member. The group
>>>>>>> leader is always freed after all members are completed. Group members
>>>>>>> aren't submitted until the group leader is completed, and there isn't any
>>>>>>> dependency among group members, and IOSQE_IO_LINK can't be set for group
>>>>>>> members, same with IOSQE_IO_DRAIN.
>>>>>>>
>>>>>>> Typically the group leader provides or makes resource, and the other members
>>>>>>> consume the resource, such as scenario of multiple backup, the 1st SQE is to
>>>>>>> read data from source file into fixed buffer, the other SQEs write data from
>>>>>>> the same buffer into other destination files. SQE group provides very
>>>>>>> efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
>>>>>>> submitted in single syscall, no need to submit fs read SQE first, and wait
>>>>>>> until read SQE is completed, 2) no need to link all write SQEs together, then
>>>>>>> write SQEs can be submitted to files concurrently. Meantime application is
>>>>>>> simplified a lot in this way.
>>>>>>>
>>>>>>> Another use case is to for supporting generic device zero copy:
>>>>>>>
>>>>>>> - the lead SQE is for providing device buffer, which is owned by device or
>>>>>>>      kernel, can't be cross userspace, otherwise easy to cause leak for devil
>>>>>>>      application or panic
>>>>>>>
>>>>>>> - member SQEs reads or writes concurrently against the buffer provided by lead
>>>>>>>      SQE
>>>>>>
>>>>>> In concept, this looks very similar to "sqe bundles" that I played with
>>>>>> in the past:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
>>>>>>
>>>>>> Didn't look too closely yet at the implementation, but in spirit it's
>>>>>> about the same in that the first entry is processed first, and there's
>>>>>> no ordering implied between the test of the members of the bundle /
>>>>>> group.
>>>>>
>>>>> When I first read this patch, I wondered if it wouldn't make sense to
>>>>> allow linking a group with subsequent requests, e.g. first having a few
>>>>> requests that run in parallel and once all of them have completed
>>>>> continue with the next linked one sequentially.
>>>>>
>>>>> For SQE bundles, you reused the LINK flag, which doesn't easily allow
>>>>> this. Ming's patch uses a new flag for groups, so the interface would be
>>>>> more obvious, you simply set the LINK flag on the last member of the
>>>>> group (or on the leader, doesn't really matter). Of course, this doesn't
>>>>> mean it has to be implemented now, but there is a clear way forward if
>>>>> it's wanted.
>>>>
>>>> Putting zc aside, links, graphs, groups, it all sounds interesting in
>>>> concept but let's not fool anyone, all the different ordering
>>>> relationships between requests proved to be a bad idea.
>>>
>>> As Jens mentioned, sqe group is very similar with bundle:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-bundle
>>>
>>> which is really something io_uring is missing.
>>
>> One could've said same about links, retrospectively I argue that it
>> was a mistake, so I pretty much doubt arguments like "io_uring is
>> missing it". Another thing is that zero copy, which is not possible
>> to implement by returning to the userspace.
>>
>>>> I can complaint for long, error handling is miserable, user handling
>>>> resubmitting a part of a link is horrible, the concept of errors is
>>>> hard coded (time to appreciate "beautifulness" of IOSQE_IO_HARDLINK
>>>> and the MSG_WAITALL workaround). The handling and workarounds are
>>>> leaking into generic paths, e.g. we can't init files when it's the most
>>>> convenient. For cancellation we're walking links, which need more care
>>>> than just looking at a request (is cancellation by user_data of a
>>>> "linked" to a group request even supported?). The list goes on
>>>
>>> Only the group leader is linked, if the group leader is canceled, all
>>> requests in the whole group will be canceled.
>>>
>>> But yes, cancelling by user_data for group members can't be supported,
>>> and it can be documented clearly, since user still can cancel the whole
>>> group with group leader's user_data.
>>
>> Which means it'd break the case REQ_F_INFLIGHT covers, and you need
>> to disallow linking REQ_F_INFLIGHT marked requests.
> 
> Both io_match_linked() and io_match_task() only iterates over req's
> link chain, and only the group leader can appear in this link chain,
> which is exactly the usual handling.
> 
> So care to explain it a bit what the real link issue is about sqe group?

Because of ref deps when a task exits it has to cancel REQ_F_INFLIGHT
requests, and therefore they should be discoverable. The flag is only
for POLL_ADD requests polling io_uring fds, should be good enough if
you disallow such requests from grouping.

>>>> And what does it achieve? The infra has matured since early days,
>>>> it saves user-kernel transitions at best but not context switching
>>>> overhead, and not even that if you do wait(1) and happen to catch
>>>> middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
>>>> timers and what not is effectively useless with links.
>>>
>>> Not only the context switch, it supports 1:N or N:M dependency which
>>
>> I completely missed, how N:M is supported? That starting to sound
>> terrifying.
> 
> N:M is actually from Kevin's idea.
> 
> sqe group can be made to be more flexible by:
> 
>      Inside the group, all SQEs are submitted in parallel, so there isn't any
>      dependency among SQEs in one group.
>      
>      The 1st SQE is group leader, and the other SQEs are group member. The whole
>      group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
>      the two flags can't be set for group members.
>      
>      When the group is in one link chain, this group isn't submitted until
>      the previous SQE or group is completed. And the following SQE or group
>      can't be started if this group isn't completed.
>      
>      When IOSQE_IO_DRAIN is set for group leader, all requests in this group
>      and previous requests submitted are drained. Given IOSQE_IO_DRAIN can
>      be set for group leader only, we respect IO_DRAIN for SQE group by
>      always completing group leader as the last on in the group.
>      
>      SQE group provides flexible way to support N:M dependency, such as:
>      
>      - group A is chained with group B together by IOSQE_IO_LINK
>      - group A has N SQEs
>      - group B has M SQEs
>      
>      then M SQEs in group B depend on N SQEs in group A.

In other words, linking groups together with basically no extra rules.
Fwiw, sounds generic, but if there are complications with IOSQE_IO_DRAIN
that I don't immediately see, it'd be more reasonable to just disable it.

>>> is missing in io_uring, but also makes async application easier to write by
>>> saving extra context switches, which just adds extra intermediate states for
>>> application.
>>
>> You're still executing requests (i.e. ->issue) primarily from the
>> submitter task context, they would still fly back to the task and
>> wake it up. You may save something by completing all of them
>> together via that refcounting, but you might just as well try to
>> batch CQ, which is a more generic issue. It's not clear what
>> context switches you save then.
> 
> Wrt. the above N:M example, one io_uring_enter() is enough, and
> it can't be done in single context switch without sqe group, please
> see the liburing test code:
> 
> https://lore.kernel.org/io-uring/ZiHA+pN28hRdprhX@fedora/T/#ma755c500eab0b7dc8c1473448dd98f093097e066
> 
>>
>> As for simplicity, using the link example and considering error
>> handling, it only complicates it. In case of an error you need to
>> figure out a middle req failed, collect all failed CQEs linked to
>> it and automatically cancelled (unless SKIP_COMPLETE is used), and
>> then resubmit the failed. That's great your reads are idempotent
>> and presumably you don't have to resubmit half a link, but in the
>> grand picture of things it's rather one of use cases where a generic
>> feature can be used.
> 
> SQE group doesn't change the current link implementation, and N:M
> dependency is built over IOSQE_IO_LINK actually.
> 
>>
>>>> So, please, please! instead of trying to invent a new uber scheme
>>>> of request linking, which surely wouldn't step on same problems
>>>> over and over again, and would definitely be destined to overshadow
>>>> all previous attempts and finally conquer the world, let's rather
>>>> focus on minimasing the damage from this patchset's zero copy if
>>>> it's going to be taken.
>>>
>>> One key problem for zero copy is lifetime of the kernel buffer, which
>>> can't cross OPs, that is why sqe group is introduced, for aligning
>>> kernel buffer lifetime with the group.
>>
>> Right, which is why I'm saying if we're leaving groups with zero
>> copy, let's rather try to make them simple and not intrusive as
>> much as possible, instead of creating an unsupportable overarching
>> beast out of it, which would fail as a generic feature.
> 
> Then it degraded to the original fused command, :-)

I'm not arguing about restricting it to 1 request in a group apart
from the master/leader/etc., if that's what you mean. The argument
is rather to limit the overhead and abstraction leakage into hot
paths.

For example that N:M, all that sounds great on paper until it sees
the harsh reality. And instead of linking groups together, you
can perfectly fine be sending one group at a time and queuing the
next group from the userspace when the previous completes. And
that would save space in io_kiocb, maybe(?) a flag, maybe something
else.

Regardless of interoperability with links, I'd also prefer it to
be folded into the link code structure and state machine, so
it's not all over in the submission/completion paths adding
overhead for one narrow feature, including un-inlining the
entire submission path.

E.g. there should be no separate hand coded duplicated SQE
/ request assembling like in io_init_req_group(). Instead
it should be able to consume SQEs and requests it's given
from submit_sqes(), and e.g. process grouping in
io_submit_sqe() around the place requests are linked.

-- 
Pavel Begunkov

