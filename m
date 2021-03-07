Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18971330133
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 14:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCGNZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 08:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhCGNYu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 08:24:50 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FE1C06174A;
        Sun,  7 Mar 2021 05:24:50 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f12so8504362wrx.8;
        Sun, 07 Mar 2021 05:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aoQCQxfYrJhsDppqEQCGpKQO31vQ8nMQSN5uxsYQeEI=;
        b=MeF1eJe5FABxzb0tKWSuGAzLZJLTRTXMMU2+MUjAQXX4ggbPEjG4HnEnggAWk/jtrp
         Nd7DaFU0Dp742+ergMafwcx/0ovFSNSp/LRY71RYTrNkJ5Qi7tRjEsfNWSnczwK6U/TW
         P6g/8oZ0ItUjcG6OvQP2CoA1onKtP3cTaNA5Ts2QjwBy/UWRakVp75yBcoCPE7GDiRlZ
         jCApTWTBfd1rq1nadKdVU+KemmTj7NeJyC2MbNvV+MGFAN4gt6VVHwUi9TtxE4A0vroV
         GjoQLCpaf/EYpyTfvQUeiiBuYuMeme9BDlfI6JfLSVheyM3QDE0OFXaHcKA69wohx4AC
         Ajjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aoQCQxfYrJhsDppqEQCGpKQO31vQ8nMQSN5uxsYQeEI=;
        b=nwnMOAScrzkKtOQvknLjq7W85tilOPToGLHshcDk5QNguRgSqGsyZ1tKBMhgM13OE/
         NIeJk+plShSswBnh5ekkLRBJ09PLjdtfxeWSbYpGi5BpBpvZhriHH1ItXzlRMljAmuxf
         jCqoVOns7Tyovhlrgvq5nm9pENoeDNk6NV0577W3I0V6SAUYgM80uExzpkjYGLOm04+Z
         x0980S8GeikcbewAvmfiEGZLxrXrzBaUceH/uqj/MY2P3bQcer2VSOy3yJyEDbQGNlNS
         2o98aeiftblBFU0bS5cJiPqyD614KuwlTPvPnWuFWVPqgxCf7PQfiIBchmMSYEtQHvCK
         IkzQ==
X-Gm-Message-State: AOAM530EtRBWI/+u7OrmNGtPn6RqLOgy4NdeKiV72eREruiBk/t50fvR
        5PKYqEan2GYPBX6AHRL4OjI=
X-Google-Smtp-Source: ABdhPJw0shq5dZvjCALMIoU4qO2e5H/8cQPpiU1qdWR9tJW1z1gpGAHRkkcDOWvta+YTKJCLkyxEZQ==
X-Received: by 2002:a5d:4ac4:: with SMTP id y4mr18037199wrs.86.1615123489258;
        Sun, 07 Mar 2021 05:24:49 -0800 (PST)
Received: from [192.168.8.114] ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id l22sm13562834wrb.4.2021.03.07.05.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 05:24:48 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000430bf505bcef3b00@google.com>
 <824f3c6e-9ae7-af14-fac5-2448afa7446a@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <282ce2ab-1429-815c-c11f-e3e9d36ef750@gmail.com>
Date:   Sun, 7 Mar 2021 13:20:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <824f3c6e-9ae7-af14-fac5-2448afa7446a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/03/2021 12:39, Pavel Begunkov wrote:
> On 07/03/2021 09:49, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    a38fd874 Linux 5.12-rc2
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=143ee02ad00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
>> dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com
> 
> Legit error, park() might take an sqd lock, and then we take it again.
> I'll patch it up

I was wrong, it looks fine, io_put_sq_data() and io_sq_thread_park()
don't nest. I wonder if that's a false positive due to conditional
locking as below

if (sqd->thread == current)
	return;
mutex_lock(&sqd->lock);

> 
>>
>> ============================================
>> WARNING: possible recursive locking detected
>> 5.12.0-rc2-syzkaller #0 Not tainted
>> --------------------------------------------
>> kworker/u4:7/7615 is trying to acquire lock:
>> ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_stop fs/io_uring.c:7099 [inline]
>> ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_put_sq_data fs/io_uring.c:7115 [inline]
>> ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139
>>
>> but task is already holding lock:
>> ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
>> ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082
>>
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>>
>>        CPU0
>>        ----
>>   lock(&sqd->lock);
>>   lock(&sqd->lock);
>>
>>  *** DEADLOCK ***
>>
>>  May be due to missing lock nesting notation
>>
>> 3 locks held by kworker/u4:7/7615:
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>>  #1: ffffc900023a7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
>>  #2: ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
>>  #2: ffff888144a02870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082
>>
>> stack backtrace:
>> CPU: 1 PID: 7615 Comm: kworker/u4:7 Not tainted 5.12.0-rc2-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events_unbound io_ring_exit_work
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:79 [inline]
>>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>>  print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
>>  check_deadlock kernel/locking/lockdep.c:2872 [inline]
>>  validate_chain kernel/locking/lockdep.c:3661 [inline]
>>  __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
>>  lock_acquire kernel/locking/lockdep.c:5510 [inline]
>>  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>>  __mutex_lock_common kernel/locking/mutex.c:946 [inline]
>>  __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1093
>>  io_sq_thread_stop fs/io_uring.c:7099 [inline]
>>  io_put_sq_data fs/io_uring.c:7115 [inline]
>>  io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139
>>  io_ring_ctx_free fs/io_uring.c:8408 [inline]
>>  io_ring_exit_work+0x82/0x9a0 fs/io_uring.c:8539
>>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
> 

-- 
Pavel Begunkov
