Return-Path: <io-uring+bounces-6390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1B1A332C5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31CCF188957A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEED02036F4;
	Wed, 12 Feb 2025 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xMR7NejW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29F5202C38
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 22:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399957; cv=none; b=sH7eVNUu05y7DxsjD9zuhXgNJPjBoAlOD6CZtcCLXKiGASkznhU34Ee9wvcuLtqrJDmc0/0yuQCfqy8ZhtwseYNhACDi9HV9SXGnkf1dtglEkSBR15w9Z6hJZQRRy8xPybIf27V03ojrg6Ivai+hm4q5mJZfBr1s77KKNQq8+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399957; c=relaxed/simple;
	bh=fnVZ2lCPQbrID/bYxkmjhoSHnujt4I2Wy/e4E5JDwyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g6w6gDnZKEKD+D3C1ZCd3regO/JabTaQK52tYWXzvbdJSjpQzoRlLfcxhaBq41e+HJ0DtpqpzRXzxQyyNDLdmorORCRYyXOahRHG/KNn1QkPPPpjIvFQ8RGbFoGjPsUzZdd5ZbBM8yFKlFORw421pzRjgQXiZpKvmM3/ddLwFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xMR7NejW; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855353491d7so6498939f.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739399955; x=1740004755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/ApWdhQdL4i12plffxYfmx5srXyB4Qlw7j9cj3Vdhs=;
        b=xMR7NejWiUU05OXYuNJguz7VoniZpOcx9sZdU9Tq9oOeb04SPLixxMX7Fw2iL+n251
         ksPtvvfdF+UOTlBSzaKzbFVjunwcPe7cYH4EEyybBKuQwK58Dc5jNUyv6ThDjDtyA1MW
         XbaOLuaaJfJpH6EG3vjHk7Sqv0ZOMYxRU4a/ouhjglpJg7rxt//khqal13Uj3NXpcZlz
         8EDEAF718UANQwY7TiIDAcfoGgJMH3aKKlif+X3TjeS5Wt9aNDzrZdONsAXyFLkzOGb9
         YRzVIzcY0VCWkeYNPkjFirAdyw1I9HYJfe2Ch1Sv5OkGpMCRWT8XvmZydGJGrYGyaqim
         ZFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739399955; x=1740004755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/ApWdhQdL4i12plffxYfmx5srXyB4Qlw7j9cj3Vdhs=;
        b=r8DRytxAW76vjLGOFya33WiZGfrAQC5S6P9wMmEdzXmzboXKE74jx5FkIUMShnU1ZU
         XuZ2ncUnOGG3BC+VQ1g6JfwrorhPLGngPlb07yr6eYDSWRkdKxMcsUnbEQm4bNOey+8y
         WoXskFds3urAliB0W6SrOK7C5QXjl84RsHR0cx+G6kPR0Q3UJNfeR0bYgATqlJIVYT8D
         vV/e7VscP5locFFrUsRA4CcHlZup9gdavln5xnpGqNC2fbqqRc+4bZOXNG4/38Nv2zi4
         8RmF9a+oVhjC/7YTAKVdx5hbmNtRLhSAP+q+2h8LHFkx6updyoXMbYu2AMS5kyNm2zJb
         sn4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfY3E7nYcO9WxaDrBNrEOZQFgWd2wcGefuL195mOubqx3MiYPkg9dps/Ugzvs/DzmQmTSaXwgVuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzyNdLYLfRS3PzIajwpO/M765OqmwzS2WfUCqCaGgg9UAxso8C
	mGoNR6gR+mb5i4MicsfZCg44ncaTbzfR0cgXStBZqwgg55MvjW15vtaNkdKMpzE=
X-Gm-Gg: ASbGncudfr7CnhwVdeQeUm26d89h/++Fb52OJXT/5OL8mQDoA6Op6146M6AgivAjuLX
	btor4aXUaxjX3SXq0Gp7wmgCxf2UXMgZwOd4TQH6R+WUKuy+Em1H12JOViJD1eKKuOjZuO5R+sn
	k2r9W9Yud/BBO7OvQL3DFgimglyOWUsfYSny6wrIRGol4ZlNrEQwnqEpXFECXj972EYZmKpPe1E
	B9EpvxPFhLM0SFuQNxeR60+QSi78kpGMcRbEE/QUo9BWC6f3l1ZSoT3INmH9Cw4e91x7it6cXx5
	7R1YMw2LvCAN
X-Google-Smtp-Source: AGHT+IF/BDZz9FHkl0LZyYH+3RLFw1WwUMy5WJeRoZZj4mPNlS6nL4gi8lXQd+YzTUGk97c1/+4D1g==
X-Received: by 2002:a05:6602:6013:b0:84a:5280:596f with SMTP id ca18e2360f4ac-85555dacf8cmr373866339f.9.1739399954792;
        Wed, 12 Feb 2025 14:39:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282b0ed1sm17213173.103.2025.02.12.14.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 14:39:14 -0800 (PST)
Message-ID: <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk>
Date: Wed, 12 Feb 2025 15:39:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Caleb Sander <csander@purestorage.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
 <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 2:54 PM, Caleb Sander wrote:
> On Wed, Feb 12, 2025 at 12:55?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
>>> In our application issuing NVMe passthru commands, we have observed
>>> nvme_uring_cmd fields being corrupted between when userspace initializes
>>> the io_uring SQE and when nvme_uring_cmd_io() processes it.
>>>
>>> We hypothesized that the uring_cmd's were executing asynchronously after
>>> the io_uring_enter() syscall returned, yet were still reading the SQE in
>>> the userspace-mapped SQ. Since io_uring_enter() had already incremented
>>> the SQ head index, userspace reused the SQ slot for a new SQE once the
>>> SQ wrapped around to it.
>>>
>>> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
>>> index in userspace upon return from io_uring_enter(). By overwriting the
>>> nvme_uring_cmd nsid field with a known garbage value, we were able to
>>> trigger the err message in nvme_validate_passthru_nsid(), which logged
>>> the garbage nsid value.
>>>
>>> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
>>> SQE copying until it's needed"). With this commit reverted, the poisoned
>>> values in the SQEs are no longer seen by nvme_uring_cmd_io().
>>>
>>> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
>>> to async_data at prep time. The commit moved this memcpy() to 2 cases
>>> when the request goes async:
>>> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
>>> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
>>>
>>> This patch set fixes a bug in the EAGAIN case where the uring_cmd's sqe
>>> pointer is not updated to point to async_data after the memcpy(),
>>> as it correctly is in the REQ_F_FORCE_ASYNC case.
>>>
>>> However, uring_cmd's can be issued async in other cases not enumerated
>>> by 5eff57fa9f3a, also leading to SQE corruption. These include requests
>>> besides the first in a linked chain, which are only issued once prior
>>> requests complete. Requests waiting for a drain to complete would also
>>> be initially issued async.
>>>
>>> While it's probably possible for io_uring_cmd_prep_setup() to check for
>>> each of these cases and avoid deferring the SQE memcpy(), we feel it
>>> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
>>> As discussed recently in regard to the ublk zero-copy patches[1], new
>>> async paths added in the future could break these delicate assumptions.
>>
>> I don't think it's particularly delicate - did you manage to catch the
>> case queueing a request for async execution where the sqe wasn't already
>> copied? I did take a quick look after our out-of-band conversation, and
>> the only missing bit I immediately spotted is using SQPOLL. But I don't
>> think you're using that, right? And in any case, lifetime of SQEs with
>> SQPOLL is the duration of the request anyway, so should not pose any
>> risk of overwriting SQEs. But I do think the code should copy for that
>> case too, just to avoid it being a harder-to-use thing than it should
>> be.
> 
> Yes, even with the EAGAIN case fixed, nvme_validate_passthru_nsid() is
> still catching the poisoned nsids. However, the log lines now come
> from the application thread rather than the iou-wrk thread.
> Indeed, we are not using SQPOLL. But we are using IOSQE_SQE_GROUP from
> Ming's SQE group patch set[1]. Like IOSQE_IO_LINK, subsequent
> operations in a group are issued only once the first completes. The
> first operation in the group is a UBLK_IO_PROVIDE_IO_BUF from Ming's
> other patch set[2], which should complete synchronously. The
> completion should be processed in __io_submit_flush_completions() ->
> io_free_batch_list() and queue the remaining grouped operations to be
> issued in task work. And all the pending task work should be processed
> during io_uring_enter()'s return to userspace.
> But some NVMe passthru operations must be going async because they are
> observing the poisoned values the application thread writes into the
> io_uring SQEs after io_uring_enter() returns. We don't yet have an
> explanation for how they end up being issued async; ftrace shows that
> in the typical case, all the NVMe passthru operations in the group are
> issued during task work before io_uring_enter() returns to userspace.
> Perhaps a pending signal could short-circuit the task work processing?

I think it'd be a good idea to move testing to the newer patchset, as
the sqe grouping was never really fully vetted or included. It's not
impossible that it's a side effect of that, even though it very well
cold be a generic issue that exists already without those patches. In
any case, that'd move us all to a closer-to-upstream test base, without
having older patches that aren't upstream in the mix.

How are the rings setup for what you're testing? I'm specifically
thinking of the task_work related flags. Is it using DEFER_TASKRUN, or
is it using the older signal style task_work?

-- 
Jens Axboe

