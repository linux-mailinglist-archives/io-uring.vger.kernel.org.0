Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D811AFDE1
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2020 21:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgDST5T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Apr 2020 15:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgDST5S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Apr 2020 15:57:18 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8048AC061A0F
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 12:57:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b8so3888554pfp.8
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 12:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YumqERvCKOIqM0l6QjCVu8YaX8ML5bpdCVE8/BBsM/o=;
        b=bkl427suLOwECWk6iGg5nqxlva0Lm21z8+YcSYxPMfnxxYk4kXifCAsfsfVP0xM7tl
         sqajdPIGykOuBPwqsxRKX57rAbkXKJB4Ba4itGUQ0cFa8tJ6/hcFajAAt385w5uTF16i
         NLUN8O8xxvgjfaCK7ir4cSzGXKOAxPL5ReLs93AStASzGo7QkYd9Oaxj9WDIbo4tlaDS
         BrjfgbsU1ZwyBjRssJwtq/B1q9XvLgpi3JuMHnEkhyvZJ7E+NJmhIJjlvTT7f2/BZq2l
         RrddBXUrPmYPsNd/LX86JB5UKVSw2PMHiv5bRlMKChIg7HxorXzqkF5m/Ox9l4cDnPvs
         yeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YumqERvCKOIqM0l6QjCVu8YaX8ML5bpdCVE8/BBsM/o=;
        b=X2YhRPfwYg83TBYjeSKzZZzrtZ1/Zit9Jg1XkRRDEv1k165yVuzLtJMOSp9+ddqYQy
         IK1DOYEwq2o38ArFiI3+fXXVHjFc2r+eCGX/7WgAfWdcPZWSu5KlcvKxNWJIXdv8HvFt
         45TmZxhC9bYhtnsV0pH80z5/leJx1jQOH6pyYsLbq03IyemydDNbq7b1u4LIAwrkeXXO
         powp4h6pXh4ZiQTWRg5w1CYzwNUpbYWWihk6Pjjaq8CS0hmRerk4kAm+sTCuOjSoos1q
         YPKLjFxfCxHJPtFhixxHgPsrWZpqKz6JCknYantM4iRpveiWxFuwTvjaxM8W5rXRifE5
         0TKA==
X-Gm-Message-State: AGi0PuanIJ+LC/SuA2otmj8CFbl6r6bjdDkevey4dorFR380dQeWVG/R
        B2EiP/00GvoEGBV+m0wNkHeQ//G+wVgUvg==
X-Google-Smtp-Source: APiQypI9Nu/NqKn50llhvU4NXwGdKoDj2hsBe2DTls8RZ2ERdOAfW5IuQ4pBJ8NgK2mEb4AqK+V+Yg==
X-Received: by 2002:a63:8c4f:: with SMTP id q15mr2043449pgn.434.1587326235960;
        Sun, 19 Apr 2020 12:57:15 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 62sm18191189pfu.181.2020.04.19.12.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 12:57:15 -0700 (PDT)
Subject: Re: INFO: rcu detected stall in io_uring_release
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <20200419040626.628-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0194d769-d3fc-0e63-9820-80a4ef3bf6bd@kernel.dk>
Date:   Sun, 19 Apr 2020 13:57:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419040626.628-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/20 10:06 PM, Hillf Danton wrote:
> 
> Sat, 18 Apr 2020 11:59:13 -0700
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    8f3d9f35 Linux 5.7-rc1
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=115720c3e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
>> dashboard link: https://syzkaller.appspot.com/bug?extid=66243bb7126c410cefe6
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com
>>
>> rcu: INFO: rcu_preempt self-detected stall on CPU
>> rcu: 	0-....: (10500 ticks this GP) idle=57e/1/0x4000000000000002 softirq=44329/44329 fqs=5245 
>> 	(t=10502 jiffies g=79401 q=2096)
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 23184 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  <IRQ>
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>>  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
>>  nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
>>  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
>>  rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
>>  print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
>>  check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
>>  rcu_pending kernel/rcu/tree.c:3225 [inline]
>>  rcu_sched_clock_irq.cold+0x55d/0xcfa kernel/rcu/tree.c:2296
>>  update_process_times+0x25/0x60 kernel/time/timer.c:1727
>>  tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
>>  tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1320
>>  __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
>>  __hrtimer_run_queues+0x5ca/0xed0 kernel/time/hrtimer.c:1584
>>  hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1646
>>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1113 [inline]
>>  smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1138
>>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>  </IRQ>
>> RIP: 0010:io_ring_ctx_wait_and_kill+0x98/0x5a0 fs/io_uring.c:7301
>> Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 3a ea 9d ff f3 90 <41> 80 3c 24 00 0f 85 53 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
>> RSP: 0018:ffffc9000897fdf0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
>> RAX: ffff888024082080 RBX: ffff88808df8e000 RCX: 1ffff9200112ffab
>> RDX: 0000000000000000 RSI: ffffffff81d549c6 RDI: ffff88808df8e300
>> RBP: ffffed1011bf1c2c R08: 0000000000000001 R09: ffffed1011bf1c61
>> R10: ffff88808df8e307 R11: ffffed1011bf1c60 R12: ffffed1011bf1c22
>> R13: ffff88808df8e160 R14: ffff88808df8e110 R15: ffffffff81d54ed0
>>  io_uring_release+0x3e/0x50 fs/io_uring.c:7324
>>  __fput+0x33e/0x880 fs/file_table.c:280
>>  task_work_run+0xf4/0x1b0 kernel/task_work.c:123
>>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>  exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
>>  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>>  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
>>  do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
>>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Make io ring ctx's percpu_ref balanced.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5904,6 +5904,7 @@ static int io_submit_sqes(struct io_ring
>  fail_req:
>  			io_cqring_add_event(req, err);
>  			io_double_put_req(req);
> +			--submitted;
>  			break;
>  		}

Not sure this is right, need to look closer. But if we post a completion
event, the event has been consumed and should be accounted as such.

-- 
Jens Axboe

