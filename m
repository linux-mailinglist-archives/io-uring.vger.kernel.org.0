Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0F31F5C1
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 09:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBSIVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 03:21:02 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:57680 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhBSIVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 03:21:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UOxXGkc_1613722815;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UOxXGkc_1613722815)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 16:20:16 +0800
Subject: Re: [PATCH v2 5.12] io_uring: don't hold uring_lock when calling
 io_run_task_work*
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1613659199-14196-1-git-send-email-haoxu@linux.alibaba.com>
 <258bcc46-41ea-4af1-4351-7d0a9e2b105a@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d07b6cde-716c-2195-24c7-7c1571fdfac7@linux.alibaba.com>
Date:   Fri, 19 Feb 2021 16:20:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <258bcc46-41ea-4af1-4351-7d0a9e2b105a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/19 上午9:12, Jens Axboe 写道:
> On 2/18/21 7:39 AM, Hao Xu wrote:
>> Abaci reported the below issue:
>> [  141.400455] hrtimer: interrupt took 205853 ns
>> [  189.869316] process 'usr/local/ilogtail/ilogtail_0.16.26' started with executable stack
>> [  250.188042]
>> [  250.188327] ============================================
>> [  250.189015] WARNING: possible recursive locking detected
>> [  250.189732] 5.11.0-rc4 #1 Not tainted
>> [  250.190267] --------------------------------------------
>> [  250.190917] a.out/7363 is trying to acquire lock:
>> [  250.191506] ffff888114dbcbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_req_task_submit+0x29/0xa0
>> [  250.192599]
>> [  250.192599] but task is already holding lock:
>> [  250.193309] ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
>> [  250.194426]
>> [  250.194426] other info that might help us debug this:
>> [  250.195238]  Possible unsafe locking scenario:
>> [  250.195238]
>> [  250.196019]        CPU0
>> [  250.196411]        ----
>> [  250.196803]   lock(&ctx->uring_lock);
>> [  250.197420]   lock(&ctx->uring_lock);
>> [  250.197966]
>> [  250.197966]  *** DEADLOCK ***
>> [  250.197966]
>> [  250.198837]  May be due to missing lock nesting notation
>> [  250.198837]
>> [  250.199780] 1 lock held by a.out/7363:
>> [  250.200373]  #0: ffff888114dbfbe8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_register+0xad/0x210
>> [  250.201645]
>> [  250.201645] stack backtrace:
>> [  250.202298] CPU: 0 PID: 7363 Comm: a.out Not tainted 5.11.0-rc4 #1
>> [  250.203144] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> [  250.203887] Call Trace:
>> [  250.204302]  dump_stack+0xac/0xe3
>> [  250.204804]  __lock_acquire+0xab6/0x13a0
>> [  250.205392]  lock_acquire+0x2c3/0x390
>> [  250.205928]  ? __io_req_task_submit+0x29/0xa0
>> [  250.206541]  __mutex_lock+0xae/0x9f0
>> [  250.207071]  ? __io_req_task_submit+0x29/0xa0
>> [  250.207745]  ? 0xffffffffa0006083
>> [  250.208248]  ? __io_req_task_submit+0x29/0xa0
>> [  250.208845]  ? __io_req_task_submit+0x29/0xa0
>> [  250.209452]  ? __io_req_task_submit+0x5/0xa0
>> [  250.210083]  __io_req_task_submit+0x29/0xa0
>> [  250.210687]  io_async_task_func+0x23d/0x4c0
>> [  250.211278]  task_work_run+0x89/0xd0
>> [  250.211884]  io_run_task_work_sig+0x50/0xc0
>> [  250.212464]  io_sqe_files_unregister+0xb2/0x1f0
>> [  250.213109]  __io_uring_register+0x115a/0x1750
>> [  250.213718]  ? __x64_sys_io_uring_register+0xad/0x210
>> [  250.214395]  ? __fget_files+0x15a/0x260
>> [  250.214956]  __x64_sys_io_uring_register+0xbe/0x210
>> [  250.215620]  ? trace_hardirqs_on+0x46/0x110
>> [  250.216205]  do_syscall_64+0x2d/0x40
>> [  250.216731]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  250.217455] RIP: 0033:0x7f0fa17e5239
>> [  250.218034] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
>> [  250.220343] RSP: 002b:00007f0fa1eeac48 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> [  250.221360] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fa17e5239
>> [  250.222272] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000008
>> [  250.223185] RBP: 00007f0fa1eeae20 R08: 0000000000000000 R09: 0000000000000000
>> [  250.224091] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> [  250.224999] R13: 0000000000021000 R14: 0000000000000000 R15: 00007f0fa1eeb700
>>
>> This is caused by calling io_run_task_work_sig() to do work under
>> uring_lock while the caller io_sqe_files_unregister() already held
>> uring_lock.
>> To fix this issue, briefly drop uring_lock when calling
>> io_run_task_work_sig(), and there are two things to concern:
>>    - hold uring_lock in io_ring_ctx_free() when calling io_sqe_files_unregister()
>>        this is for consistency of lock/unlock.
>>    - add new fixed file ref node before dropping uring_lock
>>        it's not safe to do io_uring_enter-->percpu_ref_get() with a dying one.
>>    - check if file_data->refs is dying to avoid parallel io_sqe_files_unregister
> 
> This no longer applies to for-5.12/io_uring - care to recheck and respin?
> 
Sorry, I'll send a new one against latest for-5.12/io_uring soon.
