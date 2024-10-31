Return-Path: <io-uring+bounces-4274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 840DE9B7E4E
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:25:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1528B285620
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580D519DFAB;
	Thu, 31 Oct 2024 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxlBwNhy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0451014901B;
	Thu, 31 Oct 2024 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730388344; cv=none; b=S5hW8dnqN5ZXrEP9hD3bfZOs0W7xDTBJQCcoc/Cv/eDqhS5qKp1X40PUCuxPV8mNSHNt9iqeT90ScpJ/wo099TrxOS4iZ7dxGRdqPRup8zDKxjYHZwFG1vSsHSYR7Vawrs0Qlgsd2qk4Yr1zA8e3sfGMmBsW6eDsWvLoVaCh08g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730388344; c=relaxed/simple;
	bh=Yxqn4MKUlmE5FvElEFTTG0aCAYi+S/ks5h/B1al1GbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k4parfoF+LE8EaWnRu4sF0sd/Cmbo4YoaYPgkhpberCJHedVICil1WnOMgzL5K2MW0DrjAC3prrotICnNXjgTZUMWoGEiuIkjx/CoFWh6atbF28MROKMPi8hLle20kUynRU5HTqhbaluCVXjhstWIfEFDgiInLRbYLU/iK/g6zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TxlBwNhy; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a99f629a7aaso166869666b.1;
        Thu, 31 Oct 2024 08:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730388339; x=1730993139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZJ38uUiV0IwfSglZx/QA5nl2rkQcw/rwuRnrc1ojIo=;
        b=TxlBwNhyvlFdVn/3QnFEo0U99AV42N5Xovo0011pmb9N+poOUP/WXHET6vCJnPV84b
         VAdZ3622rpCUjpBgv9Fh1AAIxPH2Vj2uZz0ctU7vrkEAsjbUGuq0pwbNIPBPgBnPGTuK
         FOBLTEot2jP7BTfYKo6S1r52uUW8ko3rkROWWGgAR0lSymE3EmKpLjEVPYaEOO2XnAxV
         1GUo0rPSwZ1QBUe5Z/5b7LVBE2nDW9n+whxxeC9ur4/PClU5sPbvoymCOttG42Tr+URY
         tfT1U2w4gNMuFkNeep1Vz8UZE9sKZd/Wc/NS3wKUIA2O22QkEMMDrc9dHCaaTQXLut4o
         TuQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730388339; x=1730993139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZJ38uUiV0IwfSglZx/QA5nl2rkQcw/rwuRnrc1ojIo=;
        b=JHtLxP//1r+OMz+s6H6SuG1Q4y8/DJAEmiU99BdXKpRTH021wwpyv8S10Lkg5/EQl7
         dUuI3C9q5IlNsDuBtxQ0vZ/oqSdKuP6TW3BrE3WUfdmj1ck3zDmjW9W5/7sPmQqQLqFj
         NkZPjEdSAuqGrd0Z/qo86eouvnwxF3HRjnXWAxZI8AEVK9rRys37qyXK4pZf0n1SFu3S
         CsTmP1RbdES3Dr9P/vB3zQE9+V547tWNeMrKzZNtpf9SiTDMyckeW1JlbIUX/UaOoJR8
         B+DnEUC0DLxVnsBsjS2ISc7MUgmJVfSymAFKvducTQcKLhAmUIWqoYYEWg2aRBi3+2WB
         2E9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbaxxx8HR+Rh5B65RWMnIIvshW2Kc2KasOSrcoKYwW70vhspx6B5PAAjcL4EXDHHas0m2rzkXbT8J/3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGJ+faSmwbYz8wiH2D9uNYOD3d+HHgGEMiGyCI7Rzg/NwkDJ4L
	DPhExt0rJciBz1xeFwPFvjMRzfYviH6gu7Ay+69hY5Xoi6y57gGf
X-Google-Smtp-Source: AGHT+IHZCZKPvnqTOLw9+9qhMkvj4J5Nhm7BSMwiTaS2/AMHRv/aYnmaKwNnsoAhNH5WPQe3Dn6coA==
X-Received: by 2002:a17:907:9446:b0:a99:f209:cea3 with SMTP id a640c23a62f3a-a9e55a4f2b9mr273180766b.11.1730388339050;
        Thu, 31 Oct 2024 08:25:39 -0700 (PDT)
Received: from [192.168.42.226] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e566436basm79966466b.179.2024.10.31.08.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 08:25:38 -0700 (PDT)
Message-ID: <bc9c365a-16fc-46b2-bc92-4c6dfbc3ada6@gmail.com>
Date: Thu, 31 Oct 2024 15:25:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
 <1f40a907-9c53-408d-997e-da49e5751c66@gmail.com>
 <6e6893cd-890d-46b0-9164-01801a4145bc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6e6893cd-890d-46b0-9164-01801a4145bc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 14:29, Jens Axboe wrote:
> On 10/31/24 7:25 AM, Pavel Begunkov wrote:
>> On 10/30/24 02:43, Jens Axboe wrote:
>>> On 10/29/24 8:03 PM, Ming Lei wrote:
>>>> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>>>>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>>>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
>> ...
>>>>> +    node->buf = imu;
>>>>> +    node->kbuf_fn = kbuf_fn;
>>>>> +    return node;
>>>>
>>>> Also this function needs to register the buffer to table with one
>>>> pre-defined buf index, then the following request can use it by
>>>> the way of io_prep_rw_fixed().
>>>
>>> It should not register it with the table, the whole point is to keep
>>> this node only per-submission discoverable. If you're grabbing random
>>> request pages, then it very much is a bit finicky
>>
>> Registering it into the table has enough of design and flexibility
>> merits: error handling, allowing any type of dependencies of requests
>> by handling it in the user space, etc.
> 
> Right, but it has to be a special table. See my lengthier reply to Ming.

Mind pointing the specific part? I read through the thread and didn't
see why it _has_ to be a special table.
And by "special" I assume you mean the property of it being cleaned up
/ flushed by the end of submission / syscall, right?

> The initial POC did install it into a table, it's just a one-slot table,

By "table" I actually mean anything that survives beyond the current
syscall / submission and potentially can be used by requests submitted
with another syscall.

> io_submit_state. I think the right approach is to have an actual struct
> io_rsrc_data local_table in the ctx, with refs put at the end of submit.
> Same kind of concept, just allows for more entries (potentially), with
> the same requirement that nodes get put when submit ends. IOW, requests
> need to find it within the same submit.
> 
> Obviously you would not NEED to do that, but if the use case is grabbing
> bvecs out of a request, then it very much should not be discoverable
> past the initial assignments within that submit scope.
> 
>>> and needs to be of
>>> limited scope.
>>
>> And I don't think we can force it, neither with limiting exposure to
>> submission only nor with the Ming's group based approach. The user can
>> always queue a request that will never complete and/or by using
>> DEFER_TASKRUN and just not letting it run. In this sense it might be
>> dangerous to block requests of an average system shared block device,
>> but if it's fine with ublk it sounds like it should be fine for any of
>> the aforementioned approaches.
> 
> As long as the resource remains valid until the last put of the node,
> then it should be OK. Yes the application can mess things up in terms of

It should be fine in terms of buffers staying alive. The "dangerous"
part I mentioned is about abuse of a shared resource, e.g. one
container locking up all requests of a bdev so that another container
can't do any IO, maybe even with an fs on top. Nevertheless, it's ublk,
I don't think we need to concern about that much since io_uring is
on the other side from normal user space.

> latency if it uses one of these bufs for eg a read on a pipe that never
> gets any data, but the data will remain valid regardless. And that's
> very much a "doctor it hurts when I..." case, it should not cause any

Right, I care about malicious abuse when it can affect other users,
break isolation / fairness, etc., I'm saying that there is no
difference between all the approaches in this aspect, and if so
it should also be perfectly ok from the kernel's perspective to allow
to leave a buffer in the table long term. If the user wants to screw
itself and doesn't remove the buffer that's the user's choice to
shoot itself in the leg.

 From this angle, that I look at the auto removal you add not as some
security / etc. concern, but just as a QoL / performance feature so
that the user doesn't need to remove the buffer by hand.

FWIW, instead of having another table, we can just mark a sub range
of the main buffer table to be cleared every time after submission,
just like we separate auto slot allocation with ranges.

> safety issues. It'll just prevent progress for the other requests that
> are using that buffer, if they need the final put to happen before
> making progress.

-- 
Pavel Begunkov

