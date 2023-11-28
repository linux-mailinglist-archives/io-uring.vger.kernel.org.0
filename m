Return-Path: <io-uring+bounces-158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D031C7FBEBE
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 16:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D2F61C20B5F
	for <lists+io-uring@lfdr.de>; Tue, 28 Nov 2023 15:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCC73526C;
	Tue, 28 Nov 2023 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w560Ljwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8541495
	for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 07:58:02 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-35cb8fe4666so1032175ab.1
        for <io-uring@vger.kernel.org>; Tue, 28 Nov 2023 07:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701187082; x=1701791882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4wAhSwnTXqPL8DFCSCSo1D+1BXr5do7lM46ckR+Mmfg=;
        b=w560LjwhUX847ndgWUlE7dC7Sx2B8QfuSv/C5KGtQBSlhiHZBsCc+tF1BdqwvE7oBW
         /VJVpDkgzCLomZ4ZfkpYqXrhQ92kuu/iy4Yv8jNXxAgjiJIdN6fyvGlaHbdxu3wC/4we
         d0CEihulT7PVByudMvknrWh7MPI0QYeHe7FjGaQ4Oz+UPs0F0cn3jJsXTC7IdygdBF/k
         8zB6R4SpwBcXyivykIJkdbMZDvEEqB0r0PpnIZ2FChOt97ROk4NIov/VW5GHPM2kkMrB
         fg5hH2E7/D9vVuuWtlPm4OyH9jnKbDwLg1+IWP8PNU1MBxoDO0FEg+Wngu/4TWfK2VIu
         MKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701187082; x=1701791882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4wAhSwnTXqPL8DFCSCSo1D+1BXr5do7lM46ckR+Mmfg=;
        b=ivaAg+sqdKWKumlSKv740b1OfrEFJSSvM65KdkLA2PbwivgaMFvpPI51tz+EU5L0TR
         SC6PYyfMFcAD7Xc4SfNlEmf7z+l4XRC8V8/3AN9W/MFL8OPRORXMr8Bpdku8msd2UtGu
         ypbgCHCr9OORoAcFYYAT2IVCYlliKvsFpQkRRV2CpUiNC81UYeuwDKtFdwGW99Guu1wC
         78QfdHsEvSxhZT8C0s3YdauXJOZn3Gxd/Uv+2nFwiF3lPGt+B1EAx7zFnQm9MF7eInmV
         RR175hoIr2QHGM6U1gRpOk56oswqIC7PqsH+nOhGoWaRTyZSLX55mcW7DT6yIGHVl7qC
         mFeg==
X-Gm-Message-State: AOJu0YyZGxbc9aDdAyiV+68zdpkSG/+JAteYTgHA5Yep0pRRfxuWoT0t
	GhaERQa9kHlyAItr51FAvSK6C8g9MTRn5eE2ZXnE2A==
X-Google-Smtp-Source: AGHT+IFBeeo2doFndHrPVDZookEKt3a/Tb9fkWQtqkqlsaYVIjsLN8dT70/m7FwLRu/1b65C5DqogA==
X-Received: by 2002:a6b:7a07:0:b0:7b3:92ea:3438 with SMTP id h7-20020a6b7a07000000b007b392ea3438mr9084569iom.2.1701187081825;
        Tue, 28 Nov 2023 07:58:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dp21-20020a056602069500b007b39447e11fsm452312iob.21.2023.11.28.07.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 07:58:01 -0800 (PST)
Message-ID: <fadbb6b5-a288-40e2-9bb8-7299ea14f0a7@kernel.dk>
Date: Tue, 28 Nov 2023 08:58:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: risky use of task work, especially wrt fdget()
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/23 2:53 PM, Jann Horn wrote:
> Hi!
> 
> I noticed something that I think does not currently cause any
> significant security issues, but could be problematic in the future:
> 
> io_uring sometimes processes task work in the middle of syscalls,
> including between fdget() and fdput(). My understanding of task work
> is that it is expected to run in a context similar to directly at
> syscall entry/exit: task context, no locks held, sleeping is okay, and
> it doesn't execute in the middle of some syscall that expects private
> state of the task_struct to stay the same.
> 
> An example of another user of task work is the keyring subsystem,
> which does task_work_add() in keyctl_session_to_parent() to change the
> cred pointers of another task.
> 
> Several places in io_uring process task work while holding an fdget()
> reference to some file descriptor. For example, the io_uring_enter
> syscall handler calls io_iopoll_check() while the io_ring_ctx is only
> referenced via fdget(). This means that if there were another kernel
> subsystem that uses task work to close file descriptors, io_uring
> would become unsafe. And io_uring does _almost_ that itself, I think:
> io_queue_worker_create() can be run on a workqueue, and uses task work
> to launch a worker thread from the context of a userspace thread; and
> this worker thread can then accept commands to close file descriptors.
> Except it doesn't accept commands to close io_uring file descriptors.
> 
> A closer miss might be io_sync_cancel(), which holds a reference to
> some normal file with fdget()/fdput() while calling into
> io_run_task_work_sig(). However, from what I can tell, the only things
> that are actually done with this file pointer are pointer comparisons,
> so this also shouldn't have significant security impact.
> 
> Would it make sense to use fget()/fput() instead of fdget()/fdput() in
> io_sync_cancel(), io_uring_enter and io_uring_register? These
> functions probably usually run in multithreaded environments anyway
> (thanks to the io_uring worker threads), so I would think fdget()
> shouldn't bring significant performance savings here?

Let me run some testing on that. It's a mistake to think that it's
usually multithreaded, generally if you end up using io-wq then it's not
a fast path. A fast networked setup, for example, would never touch the
threads and hence no threading would be implied by using io_uring. Ditto
on the storage front, if you're just reading/writing or eg doing polled
IO. That said, those workloads are generally threaded _anyway_ - not
because of io_uring, but because that's how these kinds of workloads are
written to begin with.

So probably won't be much of a concern to do the swap. The only
"interesting" part of the above mix of cancel/register/enter is
obviously the enter part. The rest are not really fast path.

-- 
Jens Axboe


