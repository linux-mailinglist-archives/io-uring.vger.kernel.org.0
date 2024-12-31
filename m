Return-Path: <io-uring+bounces-5645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5342D9FEFFF
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 15:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1FC916199D
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 14:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209591AAC9;
	Tue, 31 Dec 2024 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="avSqk49Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328ADEED7
	for <io-uring@vger.kernel.org>; Tue, 31 Dec 2024 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735655699; cv=none; b=hesX15PFgHeY/BGhRx8jRkpvc3h+eYfOgekG9fMd7IuZ++rIUVZ6MC/iyhpSV24EqfajHwfZcYFi9Vnh9fcZEiHxTD0A+4T3PusVVxbY174ugusuIt4Uy8A+m2QLiPzaNXnD8n8Se+7u/5kG2jgLfnD3m1X1GNmGOzfyUzANXIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735655699; c=relaxed/simple;
	bh=gL5mnGRxjQ9PP1zbijawRJUvkXwkWkdGHqWaw3NvbAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JAr0S5tOk7y2BXAT7UKTu3cyAzxPk00Foa0VmdY4ZnvJWX8BbBxfk1XUNPYVIRRcBAjpH4FlIlvHS25ItAPvLdy91AfYAotN8linalvWrk3oCCC6FmovwuIBlXuIVsUezyTJAfN0ARyQ2M5GP/uUAgFfkeD73tBn9rsq5KO04pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=avSqk49Y; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d8c1950da7so4899996a12.3
        for <io-uring@vger.kernel.org>; Tue, 31 Dec 2024 06:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735655695; x=1736260495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEnMhNf0OKKcgAECIAIBXfCwTWXkv0t2+jasYNMOnyk=;
        b=avSqk49Yg/QN9swiPYmQzx/Pf1FXOD6JtPpFnyXjEEY1dvl7kn4BDxNqpAec8cNstT
         29dzhDC+6h3akH6XVQlwV+NMeiHRTftd0bLNAc/p8k5o/NLMJnZuMwUMAUjUdk9pWcIM
         qm83K8ZXDWMIYNlsjqOGNKCxpANwu5+TJJfRcSAXXeSHwpX7ou0pzvVhQaGqsBya8tD8
         UPiv6TFPnL3wQi8P4weNk46RBOT/hGgmBH0dVQqywiLtci9OPQB9N0Fl7Q9Z4nZPpNr7
         ZaTaLPa32I36GUu+A45ARq+oB+bnvhtwMuPw0HNU98I6yqzMuXsjh+m+bCqS8irnubRP
         hmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735655695; x=1736260495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEnMhNf0OKKcgAECIAIBXfCwTWXkv0t2+jasYNMOnyk=;
        b=NOeIihH+Qt/FvYRNa21mdyZxv/4d41/elRcbGV8dKihBj+/KyDcJx9ymRZmSOXnYmz
         8nSpO7sQ4tJ/qzu0gSiSFNFYITowCFKo0Ik3XRTl/zaEuEaXd5OHTMU+Im1RabMQSkYR
         XcQQRM2ZGvqaibKswMKGA44A/BGz6usAQw8ldEzq64QUt+a0yBS5VrkFrxMt0lxXGlR8
         06NPAILaJGrxh3uowTGeOWxPhLcccC5cGfOh8/GKgKxdSFVLUfSh6I+EINLRaY0BT/zP
         DvQr3fL+GLdCyN0/J5tiqcCOsoOgrbVsKdNYKa3TJiqs0M68RaqTq7pkQfk+42oWVGmD
         BPsA==
X-Forwarded-Encrypted: i=1; AJvYcCU3ZYIejIo/IxbYp/4bSB7fMRcJl3tr/OIGKxsbADVkSlMjGvue9037beYItJmxV+8TQfLNDzdDlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRp9qZ/tmfCbgd191Ekc831k3Re+bS1uYQNi554Z85WtcJvC+s
	VQ4Cxq8hGoPtbyRAWDpBw3JJcGZsy7aIY7rqz5INZNL8h0hxLulwJGjoYA==
X-Gm-Gg: ASbGnctPwF67ng/7UmJ5CkMRw97jMTiFQHnCzos/X2/l1K5L3eiic/LqxnORTw4cDPo
	wnO0Ik+zuklIXmG8KNWu0SNrJSQi3dYcogIDM1Ci0p/DC0Usuwx7QE9HpuRZzoTYS9TBhYuXpud
	0bZn1+hgw0NIjllR86fz1b3kAzw1rlWlNSIcj6WEcD+2fycLnPXyOy29Ef94vn4p9rUrbqRxPOi
	oQtrnKL0+7o1FqpgwvnxLBIdIJb2w6NSpiI+mqDBToRSMNjRiJn5DGrP1cpdqWCuw==
X-Google-Smtp-Source: AGHT+IF6QPdX7VmOxNn9o9pUhg8hrmDY2vlKogGnPm9AQpVa2vxn2YtAoPgrqiCYKGgsfpYpAkrmSQ==
X-Received: by 2002:a17:906:c116:b0:aa6:7de9:2637 with SMTP id a640c23a62f3a-aac334f62f2mr3337949566b.46.1735655695109;
        Tue, 31 Dec 2024 06:34:55 -0800 (PST)
Received: from [192.168.42.94] ([85.255.233.186])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f06f847sm1557755066b.202.2024.12.31.06.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Dec 2024 06:34:54 -0800 (PST)
Message-ID: <49d8b20e-ba33-4941-ba82-6160af814a76@gmail.com>
Date: Tue, 31 Dec 2024 14:35:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, josh@joshtriplett.org
References: <20241209234316.4132786-1-krisman@suse.de>
 <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <87wmg3tk7j.fsf@mailhost.krisman.be>
 <1ae79f05-1a07-40aa-acf7-8af98b14b94f@gmail.com>
 <87jzbg7nd3.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87jzbg7nd3.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 23:38, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
> Hi Pavel,
> 
> Sorry for the delay. I took the chance to stay offline for a while on
> the christmas week.

No worries at all

>>> I fully agree this is one of the main problem with the series.  I'm
>>> interested in how we can merge this implementation into the existing
>>> io_uring paths.  My idea, which I hinted in the cover letter, is to have
>>> a flavor of io-wq that executes one linked sequence and then terminates.
>>> When a work is queued there, the newly spawned worker thread will live
>>> only until the end of that link.  This wq is only used to execute the
>>> link following a IORING_OP_CLONE and the user can pass CLONE_ flags to
>>> determine how it is created.  This allows the user to create a detached
>>> file descriptor table in the worker thread, for instance.
>>> It'd allows us to reuse the dispatching infrastructure of io-wq, hide
>>> io_uring internals from the OP_CLONE implementation, and
>>> enable, if I understand correctly, the workarounds to execute
>>> task_works.  We'd need to ensure nothing from the link gets
>>> executed outside of this context.
>>
>> One problem with io-wq is that it's not guaranteed that it's able to
>> serve all types of requests. Though it's limited to multishots atm,
>> which you might not need, but the situation might change. And there
>> is no guarantee that the request is completed by the time it returns
>> from ->issue(), it might even change hands from inside the callback
>> via task_work or by any other mean.
> 
> Multishot is the least of my concerns for this feature, tbh.  I don't
> see how it could be useful in the context of spawning a new thread, so
> in terms of finding sane semantics, we could just reject them at
> submission time if linked from a CLONE.

Right, for multishot that is, but the point here is that io-wq
is an internal detail, and it might get to a point where relying
solely on iowq way of execution would fence you off operations
that you care about. Regardless, it would need to follow common
rules like request refcounting and lifetime

>> It also sounds like you want the cloned task to be a normal
>> io_uring submmiter in terms of infra even though it can't
>> initiate a syscall, which also sounds a bit like an SQPOLL task.
>>
>> And do we really need to execute everything from the new task
>> context, or ops can take a task as an argument and run whenever
>> while final exec could be special cased inside the callback?
> 
> Wouldn't this be similar to the original design of the io-wq/sqpoll, which
> attempted to impersonate the submitter task and resulted in some issues?

The problem there was that it was a kthread, which are not
prepared to run what is basically a random syscall path, and
no amount of whack-a-mole'ing with likes of kthread_use_mm()
was ever enough.

That's the same reason why I'm saying that unless the the new
task is completely initialised and has all resources as far as
the kernel execution goes, there would be no way to run a random
io_uring request from it. "Initialised" would mean here having
->mm and all other task resources to anything valid.

> Executing directly from the new task is much simpler than trying to do the
> operations on the context of another thread.

I agree, if that's about executing e.g. a read request, but if
I'd doubt it if it's about setting a ns to a new not yet running
task.

>>>> requests be run as normal by the original task, each will take the
>>>> half created and not yet launched task as a parameter (in some form),
>>>> modify it, and the final exec would launch it?
>>> A single operation would be a very complex operation doing many things
>>> at once , and much less flexible.  This approach is flexible: you
>>> can combine any (in theory) io_uring operation to obtain the desired
>>> behavior.
>>
>> Ok. And links are not flexible enough for it either. Think of
>> error handling, passing results from one request to another and
>> more complex relations. Unless chains are supposed to be very
>> short and simple, it'd need to be able to return back to user
>> space (the one issuing requests) for error handling.
> 
> We are posting the completions to the submitter ring.  If a request
> fails, we kill the context, but the user is notified of what operation
> failed and need to resubmit the entire link with a new spawn.

That's fine in case of a short simple chain, but there is a
talk of random requests. Let's say a read op fails and you
need to redo it, that's not only expensive but might even be
impossible. E.g. it already consumed data from a pipe / socket.

But the biggest problem is flexibility, any non-trivial relation
between request would need some user processing. Take Josh's
example of linking 2+ exec requests, which instead of relying
on some special status of exec requests can be well implemented
by returning the control back to user, and that would be much
more flexible at that.

> We could avoid links by letting the spawned task linger, and provide a
> way for the user to submit more operations to be executed by this
> specific context.  The new task exists until an op to kill the worker is
> issued or when the execve command executes.  This would allow the user
> to keep multiple partially initialized contexts around for quick
> userspace thread dispatching.  we could provide a mechanism to clone
> these pre-initialized tasks.
> 
> Perhaps it is a stupid idea, but not new - i've seen it discussed
> before: I'm thinking of a workload like a thread scheduler in userspace
> or a network server.  It could keep a partially initialized worker
> thread that never and, when needed, the main task would duplicate it with
> another uring command and make the copy return to userspace, mitigating
> the cost of copying and reinitializing the task.
> 

-- 
Pavel Begunkov


