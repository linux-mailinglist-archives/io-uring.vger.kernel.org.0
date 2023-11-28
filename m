Return-Path: <io-uring+bounces-159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECDA7FBF14
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 17:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF2FC1C20BED
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 16:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E70137D36;
	Tue, 28 Nov 2023 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cyTXT8+C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2344410CA
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 08:19:07 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7b3867bfcc5so18570539f.0
        for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 08:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701188346; x=1701793146; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fJ9CvBFLcS4e8dYxcVCJmKmG4rKyLYxn+rJAYEOUpJo=;
        b=cyTXT8+CIdwDCvdZB9gr6Mh1t143QT37aKkTAA6+0Krzmkz9MIwfccCY6osXAEFqme
         ER/jNpL/iFBfzsTZmIaQl/ypXDD8nfFyRmVJxOer+0+nZSR59y8lTYjxvLHgRrmQ3a9S
         nVX6UZQ7kdcWNYtSpdzwMbPUSoFSxtIxo1rKhXcT4ZvsWmeouu8WTqt/mrqBfrsYfEAg
         +KL1zA1207D4kfPVJ3YXmg5+tlHL1I0K5SXIbee3W967tx5hlrGbTCv6vH/MJrIjZI7b
         PZrL/fhmZcoMyrqaSTQ4B/0xL8YAuwv7JEhQhqoanwH1t5c1HdcpTulmaI8TJWI2jWqo
         12LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701188346; x=1701793146;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ9CvBFLcS4e8dYxcVCJmKmG4rKyLYxn+rJAYEOUpJo=;
        b=Bwx58v+1rKGcvvZBlCzTKr6co3VkoGRhVgeuuQCHnkTDAlp47Dj/w+CDpOuo42VVZN
         XQKn0SCPu3/kWd0aciJ49mx77KInDcVyGXVl53lZTPTPzAlIxqeK9y3mBVzqSTX7bjcB
         IiUrlxL1bv8nmJrhk9UmOwVOuaQpDi7EZM76SjdmMb7qKXRKjYNJi/mLhorHXw4rqA0V
         XCeg/2sk6bm6x0H628TygQeM8VrjXRuYOlrMxHNW46+IrDrys/R7ehpd3NC5yc/2bifM
         Z+oHOgp77tWjNKCboQNeziVoIupy5vOmFZ4c3/sYqYAvXcl/MvGPqthFB1tNe8m883LU
         Mn0Q==
X-Gm-Message-State: AOJu0Yz68B5A5/09are2477zB+BdEGYktL9jY0S7K1yohDn37uxomIpS
	YyB8BE7ygwZKV75sIvdSl11FSA==
X-Google-Smtp-Source: AGHT+IHdGvZspsn8vCu9X3rpKC5dEvz8FNIrT6yj1mcSIn16OZc0fQwCiohd3gkDW1YMP/NArHXNkw==
X-Received: by 2002:a5d:8b98:0:b0:790:958e:a667 with SMTP id p24-20020a5d8b98000000b00790958ea667mr16809490iol.2.1701188346297;
        Tue, 28 Nov 2023 08:19:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q7-20020a02c8c7000000b00451b5feb80fsm2931488jao.8.2023.11.28.08.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 08:19:05 -0800 (PST)
Message-ID: <af45ad55-c002-4bbd-9226-88439bbd4916@kernel.dk>
Date: Tue, 28 Nov 2023 09:19:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: risky use of task work, especially wrt fdget()
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com>
 <fadbb6b5-a288-40e2-9bb8-7299ea14f0a7@kernel.dk>
In-Reply-To: <fadbb6b5-a288-40e2-9bb8-7299ea14f0a7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/28/23 8:58 AM, Jens Axboe wrote:
> On 11/27/23 2:53 PM, Jann Horn wrote:
>> Hi!
>>
>> I noticed something that I think does not currently cause any
>> significant security issues, but could be problematic in the future:
>>
>> io_uring sometimes processes task work in the middle of syscalls,
>> including between fdget() and fdput(). My understanding of task work
>> is that it is expected to run in a context similar to directly at
>> syscall entry/exit: task context, no locks held, sleeping is okay, and
>> it doesn't execute in the middle of some syscall that expects private
>> state of the task_struct to stay the same.
>>
>> An example of another user of task work is the keyring subsystem,
>> which does task_work_add() in keyctl_session_to_parent() to change the
>> cred pointers of another task.
>>
>> Several places in io_uring process task work while holding an fdget()
>> reference to some file descriptor. For example, the io_uring_enter
>> syscall handler calls io_iopoll_check() while the io_ring_ctx is only
>> referenced via fdget(). This means that if there were another kernel
>> subsystem that uses task work to close file descriptors, io_uring
>> would become unsafe. And io_uring does _almost_ that itself, I think:
>> io_queue_worker_create() can be run on a workqueue, and uses task work
>> to launch a worker thread from the context of a userspace thread; and
>> this worker thread can then accept commands to close file descriptors.
>> Except it doesn't accept commands to close io_uring file descriptors.
>>
>> A closer miss might be io_sync_cancel(), which holds a reference to
>> some normal file with fdget()/fdput() while calling into
>> io_run_task_work_sig(). However, from what I can tell, the only things
>> that are actually done with this file pointer are pointer comparisons,
>> so this also shouldn't have significant security impact.
>>
>> Would it make sense to use fget()/fput() instead of fdget()/fdput() in
>> io_sync_cancel(), io_uring_enter and io_uring_register? These
>> functions probably usually run in multithreaded environments anyway
>> (thanks to the io_uring worker threads), so I would think fdget()
>> shouldn't bring significant performance savings here?
> 
> Let me run some testing on that. It's a mistake to think that it's
> usually multithreaded, generally if you end up using io-wq then it's not
> a fast path. A fast networked setup, for example, would never touch the
> threads and hence no threading would be implied by using io_uring. Ditto
> on the storage front, if you're just reading/writing or eg doing polled
> IO. That said, those workloads are generally threaded _anyway_ - not
> because of io_uring, but because that's how these kinds of workloads are
> written to begin with.
> 
> So probably won't be much of a concern to do the swap. The only
> "interesting" part of the above mix of cancel/register/enter is
> obviously the enter part. The rest are not really fast path.

Did all three and ran the usual testing, which just so happens to be
multithreaded to begin with anyway. No discernable change from using
fget/fput over fdget/fdput.

IOW, we may as well do this. Do you want to send a patch? Or I can send
out mine, up to you.

-- 
Jens Axboe


