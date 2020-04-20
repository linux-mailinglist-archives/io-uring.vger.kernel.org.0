Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B292F1B0BA4
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 14:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgDTM5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 08:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726991AbgDTM5Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 08:57:16 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5BC061A0C;
        Mon, 20 Apr 2020 05:57:15 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 131so7796994lfh.11;
        Mon, 20 Apr 2020 05:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tPm2xK5bXSP7N2DNmYSwv/w1hgHQV6Cc27y/pzZWfQY=;
        b=B0oZRtfsKT7z9b3Vnxi9c3bmbk/Nj8q1tD10VTGCsuYbEzUjoz7Q30/MfNtaZQFpgb
         0FoasdcaN9HKu5elzPTO1bmNS3Sip5ei0B9PB4vrm5eqLfURo8KldRjIrb3FB4eKE5Za
         ohV8ap6wPiYCT26sK2gy2cWRfdCJII3i7qh923rXHkgLTzNuL3bfIZdzHpru0rl9A+3c
         pWqVSuq7by22grwljlYs5d6fuLlBdDFf1xlDJ4SlcjcdmvbNMuKEYelVDf0yeTm+Zgyi
         W8qq37vSfnmu+VgI4KBDFCHM2tEGL7Hjaqf0pTH/q77rWMdJADethOlL6kITp/0GR2CT
         /KHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tPm2xK5bXSP7N2DNmYSwv/w1hgHQV6Cc27y/pzZWfQY=;
        b=PgZCYpNVh0yP0z/lzWgkVYKPvavbSqB5J+tABgIFL3jBvmrWYsSH9zl/C8TfFCRH4C
         ubL4MZGz8Sg0LGogYtt1ITStZXeS+jXpepjEmFBYwNZgKUlO9ntuEJhESpxl5+N3tOTK
         aj5RFTXxZFVr8U9aMcHkXxEnYkzYObu1w/ccec/MQft+/FKwLRVsV+fIGfvYeF53rki7
         HRFa4vkXBTJjUX6T05bj1ezlhjJae2HCyJZxhivwm6/X7rBiy2V3hnTeZicAeN/fUxD9
         AqMe5lBeY8LBBLSkgXloZGMx9oRUxqoFYuMQb1j7aa1atxZJDpEmjT4pP5/d+MI1bXA+
         UFpA==
X-Gm-Message-State: AGi0PuYJUkN3C+bZlHyenx8gKP0CeYS4LZ6I9l07SN/vbQ6H/NaC5VDL
        xq3WhyrrYaO+vYMLEIMoJj0=
X-Google-Smtp-Source: APiQypIC+ldoKXDKJzz2e+OC3ev8yJpC22Qj1o+rjgeQ5HKOAXbZ8o48IGcUY4rEcOpJOSRobdqb+g==
X-Received: by 2002:a19:f614:: with SMTP id x20mr10421974lfe.84.1587387433857;
        Mon, 20 Apr 2020 05:57:13 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id d3sm846814lfq.63.2020.04.20.05.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 05:57:13 -0700 (PDT)
Subject: Re: INFO: rcu detected stall in io_uring_release
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000009dcd905a3954340@google.com>
 <20200419040626.628-1-hdanton@sina.com> <20200420114719.GA2659@kadam>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <98a6f295-c7b4-390b-c618-b5f0043f4c1a@gmail.com>
Date:   Mon, 20 Apr 2020 15:57:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420114719.GA2659@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/2020 2:47 PM, Dan Carpenter wrote:
> On Sun, Apr 19, 2020 at 12:06:26PM +0800, Hillf Danton wrote:
>>
>> Sat, 18 Apr 2020 11:59:13 -0700
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    8f3d9f35 Linux 5.7-rc1
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=115720c3e00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=66243bb7126c410cefe6
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>
>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com
>>>
>>> rcu: INFO: rcu_preempt self-detected stall on CPU
>>> rcu: 	0-....: (10500 ticks this GP) idle=57e/1/0x4000000000000002 softirq=44329/44329 fqs=5245 
>>> 	(t=10502 jiffies g=79401 q=2096)
>>> NMI backtrace for cpu 0
>>> CPU: 0 PID: 23184 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>>  <IRQ>
>>>  __dump_stack lib/dump_stack.c:77 [inline]
>>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>>>  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
>>>  nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
>>>  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
>>>  rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
>>>  print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
>>>  check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
>>>  rcu_pending kernel/rcu/tree.c:3225 [inline]
>>>  rcu_sched_clock_irq.cold+0x55d/0xcfa kernel/rcu/tree.c:2296
>>>  update_process_times+0x25/0x60 kernel/time/timer.c:1727
>>>  tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
>>>  tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1320
>>>  __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
>>>  __hrtimer_run_queues+0x5ca/0xed0 kernel/time/hrtimer.c:1584
>>>  hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1646
>>>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1113 [inline]
>>>  smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1138
>>>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>>  </IRQ>
>>> RIP: 0010:io_ring_ctx_wait_and_kill+0x98/0x5a0 fs/io_uring.c:7301
>>> Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 3a ea 9d ff f3 90 <41> 80 3c 24 00 0f 85 53 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
>>> RSP: 0018:ffffc9000897fdf0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
>>> RAX: ffff888024082080 RBX: ffff88808df8e000 RCX: 1ffff9200112ffab
>>> RDX: 0000000000000000 RSI: ffffffff81d549c6 RDI: ffff88808df8e300
>>> RBP: ffffed1011bf1c2c R08: 0000000000000001 R09: ffffed1011bf1c61
>>> R10: ffff88808df8e307 R11: ffffed1011bf1c60 R12: ffffed1011bf1c22
>>> R13: ffff88808df8e160 R14: ffff88808df8e110 R15: ffffffff81d54ed0
>>>  io_uring_release+0x3e/0x50 fs/io_uring.c:7324
>>>  __fput+0x33e/0x880 fs/file_table.c:280
>>>  task_work_run+0xf4/0x1b0 kernel/task_work.c:123
>>>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>>  exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
>>>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>>>  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
>>>  do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
>>>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>
>> Make io ring ctx's percpu_ref balanced.
>>
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5904,6 +5904,7 @@ static int io_submit_sqes(struct io_ring
>>  fail_req:
>>  			io_cqring_add_event(req, err);
>>  			io_double_put_req(req);
>> +			--submitted;
>>  			break;
>>  		}
> 
> 
> fs/io_uring.c
>   5880          for (i = 0; i < nr; i++) {
>   5881                  const struct io_uring_sqe *sqe;
>   5882                  struct io_kiocb *req;
>   5883                  int err;
>   5884  
>   5885                  sqe = io_get_sqe(ctx);
>   5886                  if (unlikely(!sqe)) {
>   5887                          io_consume_sqe(ctx);
>   5888                          break;
>   5889                  }
>   5890                  req = io_alloc_req(ctx, statep);
>   5891                  if (unlikely(!req)) {
>   5892                          if (!submitted)
>   5893                                  submitted = -EAGAIN;
>   5894                          break;
>   5895                  }
>   5896  
>   5897                  err = io_init_req(ctx, req, sqe, statep, async);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> On the success path io_init_req() takes some references like:
> 
> 	get_cred(req->work.creds);

If a req have got into io_init_req(), than it'll be put at some point
with io_put_req(). io_req_work_drop_env() called from there will clean
up req->work.creds.

>  
> That one is probably buggy and should be put if the call to:
> 
> 	return io_req_set_file(state, req, fd, sqe_flags);
> 
> fails...  But io_req_set_file() takes some other references if it
> succeeds like percpu_ref_get(req->fixed_file_refs); and it's not clear
> that those are released if io_submit_sqe() fails.

The same should happen with req->fixed_file_refs, though I don't
remember in details.

> 
>   5898                  io_consume_sqe(ctx);
>   5899                  /* will complete beyond this point, count as submitted */
>   5900                  submitted++;

Regarding, "--submitted" patch -- we take 1 ctx->refs per request, which
is put in io_put_req(). So after a request passes the line above (5900),
it's ref will be eventually dropped in io_put_req() and friends.

And it's a bit more peculiar because io_submit_sqes() batch-takes N refs
first, and then puts unused back at the end.

>   5901  
>   5902                  if (unlikely(err)) {
>   5903  fail_req:
>   5904                          io_cqring_add_event(req, err);
>   5905                          io_double_put_req(req);
>   5906                          break;
>   5907                  }
>   5908  
>   5909                  trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
>   5910                                                  true, async);
>   5911                  err = io_submit_sqe(req, sqe, statep, &link);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> here
> 
>   5912                  if (err)
>   5913                          goto fail_req;
>   5914          }
> 
> regards,
> dan carpenter
> 

-- 
Pavel Begunkov
