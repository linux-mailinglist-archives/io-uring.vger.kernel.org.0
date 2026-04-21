Return-Path: <io-uring+bounces-13108-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKvZCH/052nrDQIAu9opvQ
	(envelope-from <io-uring+bounces-13108-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 00:04:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B03A43FF78
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 00:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4A09C304E634
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 22:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E147346AE3;
	Tue, 21 Apr 2026 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="a4sUoow+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB2340DFBB
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776808989; cv=none; b=hm3WW7Umzg/MnETTCWILAHvXMMvIbAFHBuSAKWxKlF8pdDfPMjOpYNY9F7WNh9khCOoWHtyJN53b89F3V8DBVSD5GaGmNR3RZi93WoIqWwO1DovMok/aFkeeoA9NSCtpgkJXxwiiQRSGe5X/I1h8l2PXoQkQOLkz9l6nzeoXSxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776808989; c=relaxed/simple;
	bh=DulkZP6OkKFvgK7vnBoVNZkirYWDHgSsl9Z4ikFaTTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LiOH8rY434XsmBMsZLAeLy/kjOByUTI4DfZZ3wobQoBrKxoAdf0iHhP0GgwReDDBjVWrp28Jczl9euqNMYvTYmzlqMBwTXY/vm4g6WjLHyKu++FusibRyp2Aa7c0FR/g+36x87Q1ShFzwTkdRzhlipdIPC22kxPIOR6Nl6xUtyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=a4sUoow+; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d1872504cbso3883752a34.0
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 15:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776808986; x=1777413786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=scWtAhdEtlUzYlCR/FGENJ8cx0QTOprFgDlIcMVH0MM=;
        b=a4sUoow+Z8MRyVw8kK+ztXeYARgZe1/pON4VcZiuiAzXA6eCoFW5cVw/DZc0U/vx/i
         DrNj7hzaatv9OOpgmXZUNYz6Os/GbT4v2F+A4fo6ygCVjZYj6BTyaoFDBZhvQHfBzl0d
         wkhSwWUN6TG+4RHICjc4lkMKXD2rrMlyzTFD7Lsj8FMZcbTLWbaqlMb+LOLtTTDOs0+1
         /dm3bzsEHg+gMmHnHoMLCzeT104y2E5mtmkEOAl2xud5rBMJsCTkBPNn0c9PT2/LUydl
         vi2D1FkFnEISruBJXwT/iupvylvmxJj9bQX8H04VdHlwWoYRlrjgsaS1cYShpecgiqbo
         Ayew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808986; x=1777413786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scWtAhdEtlUzYlCR/FGENJ8cx0QTOprFgDlIcMVH0MM=;
        b=BEkbQByKg4vdy/RSR7XmtqdYqmxQceoiUY1Iul7JH83mij8et5WBBPjDHqrqFU2LNf
         hwlBG/onGho7NJS3LjZLxw2e+MYBJZmSE5DrQx2X3UEnAVvmhrCc4aYpka+AKuCSTOyx
         +qONKsdfaPPcaI+lyBxXzbd1Dpp/HfOaAHM2k1SBs1mI6n9jqWT0TYky6m1jy0cujetw
         qAwbeC+yoDFUXXApz9EFEQZurku47F/KM3OsjvYX7esqL2RGWC4KsmJo6GciQAi7RzAF
         G7wcwiXovxq6W7meeqVfh5700ufxu7s2ejOCCxl2f/oah7lk2EaAt7gu4u++UI5Ja1jj
         jbCA==
X-Forwarded-Encrypted: i=1; AFNElJ8K2Kfis/fu+8ObPLOY6QYpClTIeUQ8+pwchEiqYDiHQJsAMWYFybHf5MPa4RVylQE9fVifU466/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo337k8RQ9vU1GQPDCcG5Vivnfo5Z72WhGMz7eZLr6JEX4BG4Q
	1fu+iWA2cAJmIv0BY0OpkPmCJpyqJVWRdeAVPYXu6VFyFVRd4WB25pkqtKOwaNOFgF4=
X-Gm-Gg: AeBDiet8aMkNJEeForX9BCZ3L8X0mbTzUH8cco5SqpwoNb4+5NwkKGnxD7NPqfliBt4
	3KfVt+GvJXYZ01lfWK8aZguquA64QoP9LnFDCeLV1FCmGR0l/HaLJBFwZLHKhk5DyuXIMRrbpa0
	raq9eH2mXSZNCIgib3SHuf7aS1DrKc9lOkhTgBwipAGB9kqyyo3EL66GhgLAUqVDnTGqCUQtWN+
	wHwcOjA49GKVlfeLe/DLbIolHYRvCHrWoolo/u/qjSxo13+3qkRqy6Nys/jrCHUXcgdDTlIPYIU
	iY6j6qj1Og4dY2U+Q/3SW+M0CV5ttEDqpOGUjvme3oSBK+eY3JKQNvkwsIhlcFeLn1bJ0PDkvx+
	OXav1TGBXYCv5Sp7gvDPlq5SXdZFoKp2FK0bFC67sjSqXyWj9Bhvz8A3tNhYUuy8NtAp6aiPuMc
	TlttKDXlgcP/2zya9r34mKio2N2x+/Ae7RttjzG1ZcEFHiRHeluNqxk3NE4JcFbVLgUQ/6QTFsd
	3YlLFaLkNOft5VPAQPQ
X-Received: by 2002:a05:6830:6e29:b0:7dc:d7b8:aa80 with SMTP id 46e09a7af769-7dcd7b8b412mr2273005a34.17.1776808985869;
        Tue, 21 Apr 2026 15:03:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dce2b2652bsm1047306a34.9.2026.04.21.15.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 15:03:05 -0700 (PDT)
Message-ID: <65ffff89-b5bf-4170-96ae-b3372e9819a7@kernel.dk>
Date: Tue, 21 Apr 2026 16:03:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Ming Lei <tom.leiming@gmail.com>, io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
 <qyob3dbqkicviyjs77q6mmxldtwm6qdpgwznzw6ulipztphlbl@nb4bzctzlsnw>
 <6c1eaf1c-5c1e-4ca3-a9b6-b0305fcce588@kernel.dk>
 <oxree5gq4nysdwjdk6rfnxd5sy3rwqswjwn6wea4q2ieo2xka2@np4gvh23qsm7>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <oxree5gq4nysdwjdk6rfnxd5sy3rwqswjwn6wea4q2ieo2xka2@np4gvh23qsm7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13108-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0B03A43FF78
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 3:56 PM, Liam R. Howlett wrote:
> * Jens Axboe <axboe@kernel.dk> [260421 17:41]:
>> On 4/21/26 2:28 PM, Liam R. Howlett wrote:
>>> * Jens Axboe <axboe@kernel.dk> [260421 13:47]:
>>>> Hi Ming,
>>>>
>>>> Ran into the below running tests on the current tree:
>>>>
>>>> =============================
>>>> WARNING: suspicious RCU usage
>>>> 7.0.0+ #16 Tainted: G                 N 
>>>> -----------------------------
>>>> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
>>>>
>>>> other info that might help us debug this:
>>>>
>>>>
>>>> rcu_scheduler_active = 2, debug_locks = 1
>>>> 1 lock held by iou-wrk-55535/55536:
>>>>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
>>>>
>>>> stack backtrace:
>>>> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
>>>> Tainted: [N]=TEST
>>>> Hardware name: linux,dummy-virt (DT)
>>>> Call trace:
>>>>  show_stack+0x1c/0x30 (C)
>>>>  dump_stack_lvl+0x68/0x90
>>>>  dump_stack+0x18/0x20
>>>>  lockdep_rcu_suspicious+0x170/0x200
>>>>  mas_walk+0x3f0/0x6a0
>>>>  mas_find+0x1b4/0x6b0
>>>>  ublk_buf_cleanup+0xe0/0x240
>>>>  ublk_cdev_rel+0x34/0x1b0
>>>>  device_release+0xa4/0x350
>>>>  kobject_put+0x138/0x250
>>>>  put_device+0x18/0x30
>>>>  ublk_put_device+0x18/0x28
>>>>  ublk_ctrl_del_dev+0x120/0x2f8
>>>>  ublk_ctrl_uring_cmd+0x598/0x29b8
>>>>  io_uring_cmd+0x1e0/0x468
>>>>  __io_issue_sqe+0xa4/0x748
>>>>  io_issue_sqe+0x80/0xf68
>>>>  io_wq_submit_work+0x26c/0xdc8
>>>>  io_worker_handle_work+0x334/0xf20
>>>>  io_wq_worker+0x278/0x9e8
>>>>  ret_from_fork+0x10/0x20
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>>  ublkb0: unable to read partition table
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 0, async page read
>>>> Buffer I/O error on dev ublkb0, logical block 512, async page read
>>>>
>>>> and I briefly looked at it, but then just gave up as a) the maple tree
>>>> documentation is not that detailed,
>>>
>>> Which documentation is lacking?  I will fix it.
>>>
>>> I have user documentation in the Documentation directory while
>>> technical details are in the code.
>>
>> I went into the core-api/ and leafed through that, didn't have anything
>> on mas_for_each() that pertained to locking. Was hoping I'd find a table
>> of which parts of the API requires what in terms of locking or RCU.
>> There arent a whole lot of in-kernel users of it yet, so looking at
>> other places in the kernel wasn't very useful.
> 
> There's several users and the test code.  Too bad none of them helped.

There are several, but that's not very much for a kernel API. I didn't
look at the test code. If I was writing the code I would dug deeper, but
this isn't what this is. I just found an issue and the bare basics of
poking at the API and docs to check my assumptions.

>> Since this is a merge window regression, I really just passed it to Ming
>> with you on the CC just in case, and didn't spend any more time on it.
>> I'm not the one that's supposed to be finding issues like this...
>>
> 
> I appreciate the response as I'll try to cater the doc to what users
> search for.

A great example is what the llist stuff does in terms of which parts of
the API needs what kind of exclusion against each other, if any. But
maybe not as appropriate here.

And obviously my use case may not be entirely representative in terms of
what a developer might normally want if they were writing new code and
looking to use it. Or convert existing code.

> There are two APIs outlined in the documentation normal api with mtree_
> and the advanced api with mas_.  The locking is outlined in each
> section.

If I was writing code using it, I'm sure it would've been fine. And yes
mas_find() lists it, but I'm just looking at a basic back trace and the
main user, which was mas_for_each().

> I guess a note stating to check your code with lockdep might be in order
> in the documentation.

That's always a good suggestion. And the rcu checking, as you'd probably
use both.

>>>> and b) other in-tree users also just
>>>> call mas_for_each() without either a lock held or RCU read side locked.
>>>
>>> mas_for_each() must hold a lock of some type.
>>
>> That's what I assumed. I missed that the rcu dereference check
>> checks for an external lock too, which I guess you can register
>> with the maple tree. Funky... I guess it's just for lockdep
>> purposes, makes sense then.
> 
> The external lock is so that people can use the tree (which needs to
> allocate) with sleeping locks and not just spinlocks.  Willy wants me to
> kill it one day, though.

Ah, so it's actually used. I'd have to agree with willy on that front.
Though I'm always annoyed at the forced locking that xarray imposes on
you, so...

>> Presumably the current use case is fine, as it's serialized
>> teardown. It just ends up triggering the rcu sanity checks.
> 
> On tear down, we should iterate through and free any resources then
> destroy the tree.  If you erase each element one at a time you will
> rebalance the tree - since it's a b-tree.
> 
> Thanks again for taking the time to tell me where/what you looked so I
> can better answer the questions in the docs.  At least the LLM found it
> for you.

LLM was just a way to save my time. I think I've spent longer writing
emails about it at this point ;-). Thanks for the quick replies, I'm
sure Ming will appreciate it and sort this out.

-- 
Jens Axboe

