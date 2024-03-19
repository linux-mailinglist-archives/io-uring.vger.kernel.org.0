Return-Path: <io-uring+bounces-1139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF26387FF2E
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 14:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3294BB259C5
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 13:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385BE8172E;
	Tue, 19 Mar 2024 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gA9LlWVZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6887280612;
	Tue, 19 Mar 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710856705; cv=none; b=aTdhVn7cqtXGrln29sgunxufHn4geWTq1A9y58v44HBM+NTEh8RKRcaAQiw6KcJOuriBFrpTfqoDgGaMprxFrk2upa6OE+DMVAwXL4XpQ5RnU7nR2PPzq305888aw0BHmCBby2KgbXyTLqrSrDj8tFs/3HuxTRW1v+Mzq0urTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710856705; c=relaxed/simple;
	bh=OVjzTOVyPNf+wcJag2OMOZeywBVyZAixmPWNMf44ywE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvMBvmFlW4ghtLWSdv+tgMIOG0Y3WPe5wSGYknWs1xMdTmx3GpDwVisj5A+DRapqop9wkTdO6eAre/4hMzBkOEEP0Wjn18+cdr0a1V57/bk025Lm3YTnvwzyzMNdCixNnsqfB/ba/poVLqJQT5ooDIqXCSSe0fKvkk7tYi1d42M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gA9LlWVZ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a46ba938de0so334499966b.3;
        Tue, 19 Mar 2024 06:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710856702; x=1711461502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hT6iTN2em5tEDaXXNgOGojNNtDEqq+qxwwOncA5QWiE=;
        b=gA9LlWVZyGCsmS+uJIkcDWbQY2I8R+n5/zso4RHlxOFXsurfeD2zi/q2abdAgxeSrt
         WxLddZcyFnBOnBNgnK0/sBLbgLmwriTE/1k+d0X36ErZyGcSE0R8S9HdzxG9IjGKz9Ly
         51gaUOVqc6FZlSDoURTpJjHSsoFrXcvbJhmZlkjT0Qgi/gpwSGWfKMY5bzA4vUmIVtHe
         8k4IWfhD3UvYjp1FQQMru1M/gLRzCkCyCJXxX/GJPFsxzt9nHZcsWAOocChym8Pvqd20
         TtQONv+Udhfcc9nx7+1nhrqPlMrrN7tav/wbqcjsi9ZL2mqEJMcxQQ0w+E22kBzhM8ng
         XgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710856702; x=1711461502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hT6iTN2em5tEDaXXNgOGojNNtDEqq+qxwwOncA5QWiE=;
        b=uNCJSonoXBFcLCCtqJERC08tEhzOlWbksyTws552eP/45uA+e8F0iXI5qHRWhjvjuM
         biuNYr/ZrXr73yerNjiJJ3GoXdtyrrU6AM1gWSwspq+dwqh4iHrCuCIzRua3faPsoLTH
         XtXWg2aO/r/Q8rXonU/kHDAAi8uFd4mRq7MLVL8VazgDl9ZtL1jhDQLynhsP4ybrmIf1
         QTRtCiayxPeBIynB+yDf7gVg0SMFKuMpSQ5Gghp72LFxSSUs4ZPuCPjLvLlMWkEDO9yI
         VgT+dUNZXrSizKwDIPX3LzF0SBpVl0C8Z2Vq1IfBMyOzB5gGp/sqn/ecEWqbqcTQHukD
         4vyA==
X-Forwarded-Encrypted: i=1; AJvYcCXCAMCVm6p8I3ZD4nAr5vVIHlTzz/hLHWXEB7ZEqVdLFnNasdu1AvV1DNC8xv7vuRQlinVfymN4gX1H07CvLXlWtAZsDEupXYRXTYwVDPm20r1d9qt5BZWpbZPUIm0Nz2UGYFw0VRc=
X-Gm-Message-State: AOJu0YwNH/2OpZNc39LVQ+FIIogx7b3VPdjJpqKMrSgy0yV97q9w7jUV
	Oa4UyEt8wMS6jzY9SH25fWSc7HsF7d3pu+uFQuJUvWA1KLamyA8D
X-Google-Smtp-Source: AGHT+IE/NwSPtsSi0jKx8EbIMiFVN10KYe5MqHlLvrRVHJsjGi/XcSI8TG9Jtyecsw/wz4C82ew/BQ==
X-Received: by 2002:a17:906:d8c:b0:a46:181f:c1c3 with SMTP id m12-20020a1709060d8c00b00a46181fc1c3mr9487236eji.70.1710856701481;
        Tue, 19 Mar 2024 06:58:21 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.160])
        by smtp.gmail.com with ESMTPSA id mb1-20020a170906eb0100b00a46d6e51a6asm1130574ejb.40.2024.03.19.06.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 06:58:21 -0700 (PDT)
Message-ID: <bfc6afa9-501f-40b6-929a-3aa8c0298265@gmail.com>
Date: Tue, 19 Mar 2024 13:55:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: netdev@vger.kernel.org, kernel@pengutronix.de,
 linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
 <7b82679f-9b69-4568-a61d-03eb1e4afc18@gmail.com>
 <ZfgvNjWP8OYMIa3Y@pengutronix.de>
 <0a556650-9627-48ee-9707-05d7cab33f0f@gmail.com>
 <Zflt3EVf744LOA6i@pengutronix.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zflt3EVf744LOA6i@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/24 10:50, Sascha Hauer wrote:
> On Mon, Mar 18, 2024 at 01:19:19PM +0000, Pavel Begunkov wrote:
>> On 3/18/24 12:10, Sascha Hauer wrote:
>>> On Fri, Mar 15, 2024 at 05:02:05PM +0000, Pavel Begunkov wrote:
>>>> On 3/15/24 10:01, Sascha Hauer wrote:
>>>>> It can happen that a socket sends the remaining data at close() time.
>>>>> With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
>>>>> out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
>>>>> current task. This flag has been set in io_req_normal_work_add() by
>>>>> calling task_work_add().
>>>>
>>>> The entire idea of task_work is to interrupt syscalls and let io_uring
>>>> do its job, otherwise it wouldn't free resources it might be holding,
>>>> and even potentially forever block the syscall.
>>>>
>>>> I'm not that sure about connect / close (are they not restartable?),
>>>> but it doesn't seem to be a good idea for sk_stream_wait_memory(),
>>>> which is the normal TCP blocking send path. I'm thinking of some kinds
>>>> of cases with a local TCP socket pair, the tx queue is full as well
>>>> and the rx queue of the other end, and io_uring has to run to receive
>>>> the data.
>>
>> There is another case, let's say the IO is done via io-wq
>> (io_uring's worker thread pool) and hits the waiting. Now the
>> request can't get cancelled, which is done by interrupting the
>> task with TIF_NOTIFY_SIGNAL. User requested request cancellations
>> is one thing, but we'd need to check if io_uring can ever be closed
>> in this case.
>>
>>
>>>> If interruptions are not welcome you can use different io_uring flags,
>>>> see IORING_SETUP_COOP_TASKRUN and/or IORING_SETUP_DEFER_TASKRUN.
>>>
>>> I tried with different combinations of these flags. For example
>>> IORING_SETUP_TASKRUN_FLAG | IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
>>> makes the issue less likely, but nevertheless it still happens.
>>>
>>> However, reading the documentation of these flags, they shall provide
>>> hints to the kernel for optimizations, but it should work without these
>>> flags, right?
>>
>> That's true, and I guess there are other cases as well, like
>> io-wq and perhaps even a stray fput.
>>
>>
>>>> Maybe I'm missing something, why not restart your syscall?
>>>
>>> The problem comes with TLS. Normally with synchronous encryption all
>>> data on a socket is written during write(). When asynchronous
>>> encryption comes into play, then not all data is written during write(),
>>> but instead the remaining data is written at close() time.
>>
>> Was it considered to do the final cleanup in workqueue
>> and only then finalising the release?
> 
> No, but I don't really understand what you mean here. Could you
> elaborate?

The suggestion is instead of executing the release and that final
flush off of the context you're in, namely userspace task,
you can spin up a kernel task (they're not getting any signals)
and execute it from there.

void deferred_release_fn(struct work_struct *work)
{
	do_release();
	...
}

struct work_struct work;
INIT_WORK(&work, deferred_release_fn);
queue_work(system_unbound_wq, &work);


There is a catch. Even though close() is not obliged to close
the file / socket immediately, but it still not nice when you
drop the final ref but port and other bits are not released
until some time after. So, you might want to wait for that
deferred release to complete before returning to the
userspace.

I'm assuming it's fine to run it by a kernel task since
IIRC fput might delay release to it anyway, but it's better
to ask net maintainers. In theory it shouldn't need
mm,fs,etc that user task would hold.

-- 
Pavel Begunkov

