Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C333FBA9
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 00:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQXGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 19:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQXGa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 19:06:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E8DC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=9c+rShko5sFHYcRm3nF5srH87JjPvQORl/mALUU7cL4=; b=32nNwcf0RbiPeGgMju8eMIU10Y
        6KzOwmmntvHTB9O0BEdCIZJHArxjrOJz4PGOdrIgDO9DL9MybgCDYpdVx93Jh2LeIPMuoBfVWJubl
        josSXPxiu9tps3h8oJ+8slnWx78Awfj/ghGBpsQ2U5AA448Ek1YoRbtEU/e4J1EEljyKfcBTCzNvR
        JaXCdGclJ2r3sk5qXigxsV4sXKtYw0GtJnW3LDz/QBUlJ3uh79+Sb+j6rodAPE3Dard3nxlEItCz9
        PeTp9xiKu07+LfORPJm0Ja3o3A/xxLroMiCnztWojkUminCwxfwM5vrkJFWBF9P/Hk0OcxpWUQHXb
        cL9FF1bCVraE1Ypm5tAGaxAMzrVAz4gT58bBo/lC8W6WG4PHJEmWFb72CnnweBtwyPwq0BFRr7SJW
        nNdv2IlXQnmFZcNgw5CI7a7vpGVThhiSRgBC8CLkCx9bFKJm14HYwdRE23A6EAt/lcTROUFQ591xl
        WYZFlgpeZ3l3JFx1goiKLUC/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMfFA-0001NT-8P; Wed, 17 Mar 2021 23:06:24 +0000
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615826736.git.metze@samba.org>
 <60a6919e-259b-fcc8-86fd-d85105545675@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH 00/10] Complete setup before calling
 wake_up_new_task() and improve task->comm
Message-ID: <0784fd4d-cf3a-f638-0fd3-f631be1e490a@samba.org>
Date:   Thu, 18 Mar 2021 00:06:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <60a6919e-259b-fcc8-86fd-d85105545675@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

>> now that we have an explicit wake_up_new_task() in order to start the
>> result from create_io_thread(), we should things up before calling
>> wake_up_new_task().
>>
>> There're also some improvements around task->comm:
>> - We return 0 bytes for /proc/<pid>/cmdline
>> - We no longer allow a userspace process to change
>>   /proc/<pid>/[task/<tid>]/comm
>> - We dynamically generate comm names (up to 63 chars)
>>   via io_wq_worker_comm(), similar to wq_worker_comm()
>>
>> While doing this I noticed a few places we check for
>> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
>> have something like a PS_IS_KERNEL_THREAD_MASK() macro
>> that should be used in generic places and only
>> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
>> difference matters.
>>
>> There are also quite a number of cases where we use
>> same_thread_group(), I guess these need to be checked.
>> Should that return true if userspace threads and their iothreds
>> are compared?

Can you comment more deeply here and recheck this in the code
I just noticed possible problems by reading the code and playing
with git grep. I don't have time right now to build my own 5.12 kernel
and play with it. (I'm planing to do some livepath tricks to inject
backported io_uring into an older kernel...).

For a lot of things regarding PF_KTHREAD v. PF_IO_WORKER and
same_thread_group() I'm just unsure what the correct behavior would be.

It would help if you could post dumps of things like:
ps axf -o user,pid,tid,comm,cmd
ls -laR /proc/$pid/

Currently I can only guess how things will look like.

>> I've compiled but didn't test, I hope there's something useful...
> 
> Looks pretty good to me. Can I talk you into splitting this into
> a series for 5.12, and then a 5.13 on top? It looks a bit mixed
> right now. For 5.12, basically just things we absolutely need for
> release. Any cleanups or improvements on top should go to 5.13.

I'll rebase tomorrow. Actually I'd like to see all of them in 5.12
because it would means that do the admin visible change only once.

The WARN_ON() fixes are not strictly needed, but for me it would be
strange to defer them.
io_wq_worker_comm() patches are not strictly required,
but they would make the new design more consistent and
avoid changing things again in 5.13.

But I'll let you decide...

Thanks!
metze
