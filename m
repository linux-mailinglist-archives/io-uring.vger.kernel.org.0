Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC071A291A
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 21:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgDHTGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 15:06:41 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53615 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgDHTGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 15:06:41 -0400
Received: by mail-pj1-f67.google.com with SMTP id l36so219219pjb.3
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 12:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0pD6qzKffhWOqzPsdlB/MNuQ0xXQibcbINTJzSP/tt4=;
        b=vGhlfpKWdCpkUve6ulepzrj+vfUkQATzWnVTRADOW3DScQ/0B+Q1haDDnbioQXPuci
         eMIhc9Sz5WkYZ2mlWYWAlAa/V/59NluZklYjmIzBS2lA0MagDcGkPF7wYc2Xza2eaTTZ
         OpTbJZaKOKUzJN6i81BD4Jc3zcr7yr7EW8uBpH2fj+GgZEkJMMUaJ3RdPadcBaskJfEv
         /QOLYU9nH72Ne7rpy+hl+iGIVGv5MG/7FTVDlUn1ERU5Q7PczjmpWWgzRU9AKlaT90d6
         NQqDxr7Vg/guukHeVRiGrgWuaiJbwHZC6k4qv2sY49Tr63X+AjwwPIwwzYRiayoHBbvC
         jIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0pD6qzKffhWOqzPsdlB/MNuQ0xXQibcbINTJzSP/tt4=;
        b=Of8en0+p0MTFT4ZTHkmj/FdqnJ4DjrSppMB2sNOWv9wKl844s+QBE42LwsLQlUBPrO
         PgN/u/0G7dH24NkaWN+oJzOfxf4MRxCQAAu1Ul5f11Lihdtudoxd1N138TYdhUQUwRfE
         QLM1yMw9/rM5jgluP/bhB2kuIeAo+DFvGV7SDcOjvko4iCgThFYkbncslKcHfCajUdvJ
         BbtOh0p+7ofnrNnoOyu1nZqIlfPDoDB1HpLIP//os801ynetgKHQ6YYVeFVaGp6BMGjq
         VO8YTtIvd/6/j7YdLILfEiHF/6p7T+6BnAqybApQHOdQ4ynxwCagNkmYEAATjfAC+aQ4
         M+pg==
X-Gm-Message-State: AGi0PuboViB5h4v0WdlfYrg324nqkRCJwkZ0s6Y2mMHcRD+Pat4rncDx
        1fmnSYxeXSKuk4qrVOXGPSup4g==
X-Google-Smtp-Source: APiQypLkyUBXfvqUgRxJD/ELmgNgwUn7Y22DadOiDXBp9YThfDYWc/xmICWDfnjKxFlFDExVzIxgUQ==
X-Received: by 2002:a17:902:a701:: with SMTP id w1mr7697175plq.165.1586372786694;
        Wed, 08 Apr 2020 12:06:26 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id j4sm16983467pfg.133.2020.04.08.12.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 12:06:26 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
From:   Jens Axboe <axboe@kernel.dk>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
Message-ID: <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
Date:   Wed, 8 Apr 2020 12:06:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 11:48 AM, Jens Axboe wrote:
> On 4/8/20 11:40 AM, Oleg Nesterov wrote:
>> Jens, I am sorry. I tried to understand your explanations but I can't :/
>> Just in case, I know nothing about io_uring.
>>
>> However, I strongly believe that
>>
>> 	- the "task_work_exited" check in 4/4 can't help, the kernel
>> 	  will crash anyway if a task-work callback runs with
>> 	  current->task_works == &task_work_exited.
>>
>> 	- this check is not needed with the patch I sent.
>> 	  UNLESS io_ring_ctx_wait_and_kill() can be called by the exiting
>> 	  task AFTER it passes exit_task_work(), but I don't see how this
>> 	  is possible.
>>
>> Lets forget this problem, lets assume that task_work_run() is always safe.
>>
>> I still can not understand why io_ring_ctx_wait_and_kill() needs to call
>> task_work_run().
>>
>> On 04/07, Jens Axboe wrote:
>>>
>>> io_uring exit removes the pending poll requests, but what if (for non
>>> exit invocation), we get poll requests completing before they are torn
>>> down. Now we have task_work queued up that won't get run,
>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> this must not be possible. If task_work is queued it will run, or we
>> have another bug.
>>
>>> because we
>>> are are in the task_work handler for the __fput().
>>
>> this doesn't matter...
>>
>>> For this case, we
>>> need to run the task work.
>>
>> This is what I fail to understand :/
> 
> Actually debugging this just now to attempt to get to the bottom of it.
> I'm running with Peter's "put fput work at the end at task_work_run
> time" patch (with a head == NULL check that was missing). I get a hang
> on the wait_for_completion() on io_uring exit, and if I dump the
> task_work, this is what I get:
> 
> dump_work: dump cb
> cb=ffff88bff25589b8, func=ffffffff812f7310	<- io_poll_task_func()
> cb=ffff88bfdd164600, func=ffffffff812925e0	<- some __fput()
> cb=ffff88bfece13cb8, func=ffffffff812f7310	<- io_poll_task_func()
> cb=ffff88bff78393b8, func=ffffffff812b2c40
> 
> and we hang because io_poll_task_func() got queued twice on this task
> _after_ we yanked the current list of work.
> 
> I'm adding some more debug items to figure out why this is, just wanted
> to let you know that I'm currently looking into this and will provide
> more data when I have it.

Here's some more data. I added a WARN_ON_ONCE() for task->flags &
PF_EXITING on task_work_add() success, and it triggers with the
following backtrace:

[  628.291061] RIP: 0010:__io_async_wake+0x14a/0x160
[  628.300452] Code: 8b b8 c8 00 00 00 e8 75 df 00 00 ba 01 00 00 00 48 89 ee 48 89 c7 49 89 c6 e8 82 dd de ff e9 59 ff ff ff 0f 0b e9 52 ff ff ff <0f> 0b e9 40 ff ff ff 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00
[  628.337930] RSP: 0018:ffffc9000c830a40 EFLAGS: 00010002
[  628.348365] RAX: 0000000000000000 RBX: ffff88bfe85fc200 RCX: ffff88bff58491b8
[  628.362610] RDX: 0000000000000001 RSI: ffff88bfe85fc2b8 RDI: ffff889fc929f000
[  628.376855] RBP: ffff88bfe85fc2b8 R08: 00000000000000c3 R09: ffffc9000c830ad0
[  628.391087] R10: 0000000000000000 R11: ffff889ff01000a0 R12: ffffc9000c830ad0
[  628.405317] R13: ffff889fb405fc00 R14: ffff889fc929f000 R15: ffff88bfe85fc200
[  628.419549] FS:  0000000000000000(0000) GS:ffff889fff5c0000(0000) knlGS:0000000000000000
[  628.435706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  628.447178] CR2: 00007f40a3c4b8f0 CR3: 0000000002409002 CR4: 00000000003606e0
[  628.461427] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  628.475675] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  628.489924] Call Trace:
[  628.494810]  <IRQ>
[  628.498835]  ? __io_queue_sqe.part.97+0x750/0x750
[  628.508229]  ? tcp_ack_update_rtt.isra.55+0x113/0x430
[  628.518320]  __wake_up_common+0x71/0x140
[  628.526152]  __wake_up_common_lock+0x7c/0xc0
[  628.534681]  sock_def_readable+0x3c/0x70
[  628.542516]  tcp_data_queue+0x2d9/0xb50
[  628.550175]  tcp_rcv_established+0x1ce/0x620
[  628.558703]  ? sk_filter_trim_cap+0x4f/0x200
[  628.567232]  tcp_v6_do_rcv+0xbe/0x3b0
[  628.574545]  tcp_v6_rcv+0xa8d/0xb20
[  628.581516]  ip6_protocol_deliver_rcu+0xb4/0x450
[  628.590736]  ip6_input_finish+0x11/0x20
[  628.598396]  ip6_input+0xa0/0xb0
[  628.604845]  ? tcp_v6_early_demux+0x90/0x140
[  628.613371]  ? tcp_v6_early_demux+0xdb/0x140
[  628.621902]  ? ip6_rcv_finish_core.isra.21+0x66/0x90
[  628.631816]  ipv6_rcv+0xc0/0xd0
[  628.638092]  __netif_receive_skb_one_core+0x50/0x70
[  628.647833]  netif_receive_skb_internal+0x2f/0xa0
[  628.657226]  napi_gro_receive+0xe7/0x150
[  628.665068]  mlx5e_handle_rx_cqe+0x8c/0x100
[  628.673416]  mlx5e_poll_rx_cq+0xef/0x95b
[  628.681252]  mlx5e_napi_poll+0xe2/0x610
[  628.688913]  net_rx_action+0x132/0x360
[  628.696403]  __do_softirq+0xd3/0x2e6
[  628.703545]  irq_exit+0xa5/0xb0
[  628.709816]  do_IRQ+0x79/0xd0
[  628.715744]  common_interrupt+0xf/0xf
[  628.723057]  </IRQ>
[  628.727256] RIP: 0010:cpuidle_enter_state+0xac/0x410

which means that we've successfully added the task_work while the
process is exiting. Maybe I can work-around this by checking myself
instead of relying on task_work_add() finding work_exited on the list.

-- 
Jens Axboe

