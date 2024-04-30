Return-Path: <io-uring+bounces-1684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B80B8B75B3
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 14:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 530442849C8
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 12:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B23C140384;
	Tue, 30 Apr 2024 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FyY8zYc+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803D1422B6;
	Tue, 30 Apr 2024 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480017; cv=none; b=XTvwv2xZHKOcCkZuDBKc/2tgjTPT8TO18KautYQ+wjxcQiCWyZKO2GcrjgyCkCaP40HcGvANJ354hAJJ+WEFCplmnRlgFt2MwXJkfm0S2y30sw/kRsc8c5S/yUM1jsO3+TevWOL1cu8SMs08M2GvSTpEd8z++a9IMab6S8TcWdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480017; c=relaxed/simple;
	bh=0Zyxhv6pS0P27aRvASAOqpM/yAyHjaYQOtXcWkJaOSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZgqQFOgvChI5agDo0tYITpa05fLsbym5vMOvUKhRiX7OX4G2w+P/xtcaUJ6GURvyd1KrqOwRjNSZd/ido54sJb9QZkfbRx9ImWKw9vd/f5loyyLDL6g/w6lpomfXlwbAwSf2ZqsjdSWEDYHio7qDZMZA2X3Y9ZDLjmU2uvHqQK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FyY8zYc+; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a58872c07d8so1154365266b.0;
        Tue, 30 Apr 2024 05:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714480014; x=1715084814; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0KbVgk44J6oLC+bEtlvbjHVyuPnoUIfIAwUbxuS8USw=;
        b=FyY8zYc+K8fItcBDtuISyMdFbr9jDUg8GnV+1xuSk1ZA3sIOcki5+rYe8s1NvAhDlP
         dVN/PYsE5dGbmTs09rwxkgoz5lsNWMtRaQJ+mpZAt2fao29+wA64XmW8HWw4SXilNSKk
         A1/PXQj21DcON5LdZOy09m9pOfVmo/vvWBFhAwIwUhoKCC8UUYsw+KarO4hsyxNdxsLm
         v/rfwmruQawhcjRb06vYBrcTpO9yQdZWWE0IvUAG9Rh5lREzWDR8RAKdpG3s6pHW/+/Y
         aYoUofBr2coeKICRS+tstmGoSJZOVdbz6VnkKtztUHsOahzplDbKDUld1uQs4IZlhk75
         CUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714480014; x=1715084814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0KbVgk44J6oLC+bEtlvbjHVyuPnoUIfIAwUbxuS8USw=;
        b=Lb6XkOCu3yQ4DR26kcg/5qT44ERDquS4ZsQhazhN6oUo3TLmZrwL3Q7de6+vrcKYDd
         QFO7rlPE1v0DBFKOBcIXAu/LPfislDnMwNYw8lmp1WuGXo01sQNuJB1xYR7P7EHIHSeT
         wNd+/r36Vtc/625TcPPOiHNV0PJb+QljZh/qQ6xgAxkcOX9tUuAqEtbB5WfQhLYa7iXK
         UDuVCuxWLFI9kSBCWP5CIHfB6xsbyRABUHuY/+CVLrUGMqmZsV2BWEhEBcwV5Dld1c2z
         XXeFY59psex7xr6E5AFpazVKHwKE0w1+KTAZhYyP3NOLWvPPQpCOIaT5At4P9v4YNIeD
         cnpA==
X-Forwarded-Encrypted: i=1; AJvYcCW4KVPo43xlvXbg/PXS5v6LGqxN/G+7DIIjTmG1On9cCYgexB64SJEwTgaHqT9LUWDSSVUfKChQhMoyABQajtGdwpRfJtlRV1jlWHEaJiU38g66rjkuL5zohPgKFXECpETgVqzfTA==
X-Gm-Message-State: AOJu0Yy3DgxkSxAIy/7IlO9Di7q6xiuoOy95B1OMcW3eTr0uoOM7qvSr
	Sk2RvZPQ/pOns3aDAjMeoqzyhrS4Vf1//snVKHBAZdwtd1434boW
X-Google-Smtp-Source: AGHT+IH6bVV01DREWAn8oSlZJkuLd3/G09AfNsJScey8YtX7GhGCl+Bjg0Y5JG/WMCYEmQhXt9jIpw==
X-Received: by 2002:a17:906:41b:b0:a58:de92:5daf with SMTP id d27-20020a170906041b00b00a58de925dafmr2553884eja.3.1714480013551;
        Tue, 30 Apr 2024 05:26:53 -0700 (PDT)
Received: from [192.168.42.150] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id kn9-20020a170906aa4900b00a534000d525sm15080060ejb.158.2024.04.30.05.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 05:26:53 -0700 (PDT)
Message-ID: <0f142448-3702-4be9-aad4-7ae6e1e5e785@gmail.com>
Date: Tue, 30 Apr 2024 13:27:10 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZjBffAzunso3lhsJ@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:03, Ming Lei wrote:
> On Mon, Apr 29, 2024 at 04:32:35PM +0100, Pavel Begunkov wrote:
>> On 4/23/24 14:08, Kevin Wolf wrote:
>>> Am 22.04.2024 um 20:27 hat Jens Axboe geschrieben:
>>>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>>>> SQE group is defined as one chain of SQEs starting with the first sqe that
>>>>> has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
>>>>> doesn't have it set, and it is similar with chain of linked sqes.
>>>>>
>>>>> The 1st SQE is group leader, and the other SQEs are group member. The group
>>>>> leader is always freed after all members are completed. Group members
>>>>> aren't submitted until the group leader is completed, and there isn't any
>>>>> dependency among group members, and IOSQE_IO_LINK can't be set for group
>>>>> members, same with IOSQE_IO_DRAIN.
>>>>>
>>>>> Typically the group leader provides or makes resource, and the other members
>>>>> consume the resource, such as scenario of multiple backup, the 1st SQE is to
>>>>> read data from source file into fixed buffer, the other SQEs write data from
>>>>> the same buffer into other destination files. SQE group provides very
>>>>> efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
>>>>> submitted in single syscall, no need to submit fs read SQE first, and wait
>>>>> until read SQE is completed, 2) no need to link all write SQEs together, then
>>>>> write SQEs can be submitted to files concurrently. Meantime application is
>>>>> simplified a lot in this way.
>>>>>
>>>>> Another use case is to for supporting generic device zero copy:
>>>>>
>>>>> - the lead SQE is for providing device buffer, which is owned by device or
>>>>>     kernel, can't be cross userspace, otherwise easy to cause leak for devil
>>>>>     application or panic
>>>>>
>>>>> - member SQEs reads or writes concurrently against the buffer provided by lead
>>>>>     SQE
>>>>
>>>> In concept, this looks very similar to "sqe bundles" that I played with
>>>> in the past:
>>>>
>>>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle
>>>>
>>>> Didn't look too closely yet at the implementation, but in spirit it's
>>>> about the same in that the first entry is processed first, and there's
>>>> no ordering implied between the test of the members of the bundle /
>>>> group.
>>>
>>> When I first read this patch, I wondered if it wouldn't make sense to
>>> allow linking a group with subsequent requests, e.g. first having a few
>>> requests that run in parallel and once all of them have completed
>>> continue with the next linked one sequentially.
>>>
>>> For SQE bundles, you reused the LINK flag, which doesn't easily allow
>>> this. Ming's patch uses a new flag for groups, so the interface would be
>>> more obvious, you simply set the LINK flag on the last member of the
>>> group (or on the leader, doesn't really matter). Of course, this doesn't
>>> mean it has to be implemented now, but there is a clear way forward if
>>> it's wanted.
>>
>> Putting zc aside, links, graphs, groups, it all sounds interesting in
>> concept but let's not fool anyone, all the different ordering
>> relationships between requests proved to be a bad idea.
> 
> As Jens mentioned, sqe group is very similar with bundle:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-bundle
> 
> which is really something io_uring is missing.

One could've said same about links, retrospectively I argue that it
was a mistake, so I pretty much doubt arguments like "io_uring is
missing it". Another thing is that zero copy, which is not possible
to implement by returning to the userspace.

>> I can complaint for long, error handling is miserable, user handling
>> resubmitting a part of a link is horrible, the concept of errors is
>> hard coded (time to appreciate "beautifulness" of IOSQE_IO_HARDLINK
>> and the MSG_WAITALL workaround). The handling and workarounds are
>> leaking into generic paths, e.g. we can't init files when it's the most
>> convenient. For cancellation we're walking links, which need more care
>> than just looking at a request (is cancellation by user_data of a
>> "linked" to a group request even supported?). The list goes on
> 
> Only the group leader is linked, if the group leader is canceled, all
> requests in the whole group will be canceled.
> 
> But yes, cancelling by user_data for group members can't be supported,
> and it can be documented clearly, since user still can cancel the whole
> group with group leader's user_data.

Which means it'd break the case REQ_F_INFLIGHT covers, and you need
to disallow linking REQ_F_INFLIGHT marked requests.

>> And what does it achieve? The infra has matured since early days,
>> it saves user-kernel transitions at best but not context switching
>> overhead, and not even that if you do wait(1) and happen to catch
>> middle CQEs. And it disables LAZY_WAKE, so CQ side batching with
>> timers and what not is effectively useless with links.
> 
> Not only the context switch, it supports 1:N or N:M dependency which

I completely missed, how N:M is supported? That starting to sound
terrifying.

> is missing in io_uring, but also makes async application easier to write by
> saving extra context switches, which just adds extra intermediate states for
> application.

You're still executing requests (i.e. ->issue) primarily from the
submitter task context, they would still fly back to the task and
wake it up. You may save something by completing all of them
together via that refcounting, but you might just as well try to
batch CQ, which is a more generic issue. It's not clear what
context switches you save then.

As for simplicity, using the link example and considering error
handling, it only complicates it. In case of an error you need to
figure out a middle req failed, collect all failed CQEs linked to
it and automatically cancelled (unless SKIP_COMPLETE is used), and
then resubmit the failed. That's great your reads are idempotent
and presumably you don't have to resubmit half a link, but in the
grand picture of things it's rather one of use cases where a generic
feature can be used.

>> So, please, please! instead of trying to invent a new uber scheme
>> of request linking, which surely wouldn't step on same problems
>> over and over again, and would definitely be destined to overshadow
>> all previous attempts and finally conquer the world, let's rather
>> focus on minimasing the damage from this patchset's zero copy if
>> it's going to be taken.
> 
> One key problem for zero copy is lifetime of the kernel buffer, which
> can't cross OPs, that is why sqe group is introduced, for aligning
> kernel buffer lifetime with the group.

Right, which is why I'm saying if we're leaving groups with zero
copy, let's rather try to make them simple and not intrusive as
much as possible, instead of creating an unsupportable overarching
beast out of it, which would fail as a generic feature.

-- 
Pavel Begunkov

