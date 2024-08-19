Return-Path: <io-uring+bounces-2834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B98A957852
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 137C1283FC8
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A793715990E;
	Mon, 19 Aug 2024 23:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="VHzqy/gv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD59D14D43D
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724108632; cv=none; b=euq8NVJCvorNPUrjBWAYJc26885c7yy/iGX7SVY06tdHx1dH3EWOdfqf9VzsIKogZgTx1mVMF5mP3TSfhc2JpPskI+8jk8ycGYxKz9R9aIb0tewbawcT2Na638m5fXLNRNoSzcJLRqbz3HTwN0L4MGLsJKAaFrcOR5HPrRxvi68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724108632; c=relaxed/simple;
	bh=DWDrPAgyt3q3qqpf/Bm5RscRhfde6eGy0s0ZIh+s1Fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uevTwU5grrLo7vhZ2aNes94zm8KqHJEskSmtpKzlqN3l3q299QFg6pHZE6NLChCGjWyXkNqrlB9Ib+xBcXZ35hMucID1aMQsCjMzQKuaQ4HCPw3eRDCW6cHAu4JdfOP3KIXmVDa0vBvMgEH42QwBqEX5Ipso4xgWzXly8xuDTyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=VHzqy/gv; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2705d31a35cso1114589fac.0
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724108630; x=1724713430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7FF2xPFNcpfo//VjsVucyjCndxHBHqcNrJYQAzj6ak=;
        b=VHzqy/gv3yH2QEk3etqyQsqbigissQcF1HPP3noQn80J78AWxZERmY+J7yxg0mgk61
         2wfWOUDetftY45397KtSts8j1a8+LDgkeNN0BaAD4queoKs9TiGmfph/3KDfSuiuK+JZ
         k5+kaOSN6mwlfejSyOMtUKQggxKTmiu1e4adA4SALf1JZB8Gua8uPzlxwH+ATeYZb8ke
         CLPpqdFh7t5K2daV/mw5ozfnQmWxApj9/ydGcANYfugD8G9gR3uKW1xVFlrEM2cqeMLo
         Rv9TXh/7ogUNGJZNZtJ99sdGYom4WE88sRTe8t5ov4FVadb2XvCjv3jMZYBes0hYVfyQ
         QbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724108630; x=1724713430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7FF2xPFNcpfo//VjsVucyjCndxHBHqcNrJYQAzj6ak=;
        b=pHGY39BcysaDHXT9mngmfRgOhYMe6D0fd6PpiNKysVj1hNKs+vA91sXWu/3UpxPbKT
         UIbXFzaF2VM5/KolE3+W9A8ZasF2o2mQEVTPVy+e4mVnNGRKSI9EZuNwoNTaPcsGQW1J
         oUWAFvVoefMFfy9EFT5MGJbS79IiP8ihMruF+1f/OtFZ2H3eBKQYUQuM1GsZdM1Cqzl1
         /KLrbAV+M82sbRKvIokO0AIJ+NbDf/0M6Dsa84uHxrdGO+/gFVedCgEim0XXZx/ckYEk
         DahSWywNcaRQhPfq50jlsfdNVIc7HvFCZQYsQjvicQQCR/uUm6Ki3c7CBVC/sAXbnBX7
         q1mA==
X-Gm-Message-State: AOJu0YxFeL+1xcoOaowVwSV+gEIuaoZeNC2eeCDiGjtkc0vwVixEfDlP
	2Jasjg4JwqUWo1w13LaCn6wjLNP4tePz90bspdtXT5pBEGez+mvJ65emgUFLq2aiOzoOKLkJEKs
	vmEY=
X-Google-Smtp-Source: AGHT+IHtSLvx/QNXMgK5YXXCbPc+LjVNDq/28CfjoPvtJBpLho+Kxunpr3xkXl/MceIr8XErkbESyQ==
X-Received: by 2002:a05:6870:d626:b0:25e:8509:160e with SMTP id 586e51a60fabf-2701c349877mr15873424fac.3.1724108629652;
        Mon, 19 Aug 2024 16:03:49 -0700 (PDT)
Received: from [192.168.1.13] (174-21-189-109.tukw.qwest.net. [174.21.189.109])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61ce869sm6988325a12.24.2024.08.19.16.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 16:03:49 -0700 (PDT)
Message-ID: <5c209f2e-34c5-4afa-9ecf-842f33d6baf0@davidwei.uk>
Date: Mon, 19 Aug 2024 16:03:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set
 in_iowait
Content-Language: en-GB
To: Jeff Moyer <jmoyer@redhat.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <20240816223640.1140763-1-dw@davidwei.uk>
 <x49bk1s9c35.fsf@segfault.usersys.redhat.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <x49bk1s9c35.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-16 18:23, Jeff Moyer wrote:
> Hi, David,
> 
> David Wei <dw@davidwei.uk> writes:
> 
>> io_uring sets current->in_iowait when waiting for completions, which
>> achieves two things:
>>
>> 1. Proper accounting of the time as iowait time
>> 2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
>>
>> For block IO this makes sense as high iowait can be indicative of
>> issues.
> 
> It also let's you know that the system isn't truly idle.  IOW, it would
> be doing some work if it didn't have to wait for I/O.  This was the
> reason the metric was added (admins being confused about why their
> system was showing up idle).

I see. Thanks for the historical context.

> 
>> But for network IO especially recv, the recv side does not control
>> when the completions happen.
>>
>> Some user tooling attributes iowait time as CPU utilisation i.e. not
> 
> What user tooling are you talking about?  If it shows iowait as busy
> time, the tooling is broken.  Please see my last mail on the subject:
>   https://lore.kernel.org/io-uring/x49cz0hxdfa.fsf@segfault.boston.devel.redhat.com/

Our internal tooling for example considers CPU util% to be (100 -
idle%), but it also has a CPU busy% defined as (100 - idle% - iowait%).
It is very unfortunate that everyone uses CPU util% for monitoring, with
all sorts of alerts, dashboards and load balancers referring to this
value. One reason is that, depending on context, high iowait time may or
may not be a problem, so it isn't as simple as redefining CPU util% to
exclude iowait.

> 
>> idle, so high iowait time looks like high CPU util even though the task
>> is not scheduled and the CPU is free to run other tasks. When doing
>> network IO with e.g. the batch completion feature, the CPU may appear to
>> have high utilisation.
> 
> Again, iowait is idle time.

That's fair. I think it is simpler to have a single "CPU util" metric
defined as (100 - idle%), and have a switch that userspace explicitly
flips to say "I want iowait to be considered truly idle or not". This
means things such as load balancers can be built around a single metric,
rather than having to consider both util/busy and needing to understand
"does iowait mean anything?".

> 
>> This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
>> enter. If set, then current->in_iowait is not set. By default this flag
>> is not set to maintain existing behaviour i.e. in_iowait is always set.
>> This is to prevent waiting for completions being accounted as CPU
>> utilisation.
>>
>> Not setting in_iowait does mean that we also lose cpufreq optimisations
>> above because in_iowait semantics couples 1 and 2 together. Eventually
>> we will untangle the two so the optimisations can be enabled
>> independently of the accounting.
>>
>> IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
>> support. This will be used by liburing to check for this feature.
> 
> If I receive a problem report where iowait time isn't accurate, I now
> have to somehow figure out if an application is setting this flag.  This
> sounds like a support headache, and I do wonder what the benefit is.
> From what you've written, the justification for the patch is that some
> userspace tooling misinterprets iowait.  Shouldn't we just fix that?

Right, I understand your concerns. That's why by default this flag is
not set and io_uring behaves as before with in_iowait always set.

Unfortunately, "just fix userspace" for us is a huge ask because a whole
pyramid of both code and human understanding has been built on the
current definition of "CPU utilisation". This is extremely time
consuming to change, nor is it something that we (io_uring) want to take
on imo. Why not give the option for people to indicate whether they want
iowait showing up or not?

> 
> It may be that certain (all?) network functions, like recv, should not
> be accounted as iowait.  However, I don't think the onus should be on
> applications to tell the kernel about that--the kernel should just
> figure that out on its own.
> 
> Am I alone in these opinions?

Why should the onus be on the kernel? I think it is more difficult for
the kernel to figure out exactly what semantics userspace wants and it
is simpler for userspace to select their preference.

From my experience, userspace apps either assigns a thread with an
io_uring instance to network IO or disk IO, but never both. If there is
a valid case for doing both types in the same io_uring, then it would be
trivial to add wait helpers that sets IORING_ENTER_NO_IOWAIT on a per
wait basis.

I do agree with you that this is not ideal. What io_uring really wants
is to decouple the iowait accounting from the cpufreq optimisation that
gets enabled in the presence of in_iowait, which is a bigger ask and out
of scope of this patch. When _someone_ decides to fix the wider iowait
issue, I'm happy to revisit this patch.

> 
> Cheers,
> Jeff
> 

