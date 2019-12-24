Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D812A31D
	for <lists+io-uring@lfdr.de>; Tue, 24 Dec 2019 17:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfLXQPx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Dec 2019 11:15:53 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37918 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQPw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Dec 2019 11:15:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so10946742pfc.5
        for <io-uring@vger.kernel.org>; Tue, 24 Dec 2019 08:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8ZFhLPXLlBJL8SSlH+PM7okGlCh7sQWWNQWWlaQ7fE=;
        b=V1zIOvaUHX0GmK3y0T7nNIiIMcW+RSvFSND44+hviy8C4Fc4kkoAkou07TjMHMy74r
         Cu89rD7oGqMKYg5Q1+iROijn90IzsGrwvdimCoVfzzmdZxrn6IIc/pUuoAsBKpHzmBfa
         cD1ji9S2N0prmDASwZmhaMXWrFn6WKwMWIx+mF9OVwbV1xwadQQoSatFRzBU3DODWCFo
         QlJgatEpe9onWHgi1U9gRkWd/bd6SSMQBMpHYoZfQkHlu5ehc51YU8C+BLvuSNUUuXaM
         KpiuCmuENZuKcqijktxDCuMD9LDsMWeBCQ/VM8EbbiIiQ4bC5nyRcFZIyFVt3FDQDkKb
         Ci/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8ZFhLPXLlBJL8SSlH+PM7okGlCh7sQWWNQWWlaQ7fE=;
        b=ZxuPgA/YqSMNmoE6wfKFJMxBHyG6Z/0pl2hw7iCjF4JRKwtA/6+4QDhMX3fS28jyYa
         XwsJRmAgslcSyFN8DEc2+ztqRiet3URdvDnrHYOUviFzDgtZCNLy7D+/fgEJjeyyb0wd
         xVBKf61e7AGbRXA1Wkve8rrcLtFrmNg0vZPbAXe/NcPkTbT9nG0ztPzw+sai3HlIwFTS
         7xK62iBh52/ShBfnedDUSHtfjdDt+1/VvqXTQOh0Ay8rWFdz07S47wIyVWgRzWSSRNb4
         l+yj8ubTuqIhiWqzIDodPDjF001okBDtphj1oRLcrpAKf66bcmIS0NNTM8tRkAK6JCha
         6gNA==
X-Gm-Message-State: APjAAAWGasMTnPUl7CJt6sFfcdd2rBSdGI1J+RiUD+xFxIhGW13xVitq
        DcVKqmonvyq/NbtEEnq7XnL1AA==
X-Google-Smtp-Source: APXvYqw6g6gplyQ1hHNRJ73slacOCfaonn8zAyu4KmDsSe34TWrzIB2Cny4kGA6Qg8vemm5X0Idahw==
X-Received: by 2002:aa7:86ce:: with SMTP id h14mr36482045pfo.31.1577204151781;
        Tue, 24 Dec 2019 08:15:51 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a19sm4009190pju.11.2019.12.24.08.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:15:51 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in io_wq_flush (2)
To:     Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+8e7705a7ae1bdce77c07@syzkaller.appspotmail.com>,
        viro@zeniv.linux.org.uk
References: <20191221143036.1984-1-hdanton@sina.com>
 <20191224112822.8664-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79cc8245-3f55-a100-099c-25f0cd9cffbe@kernel.dk>
Date:   Tue, 24 Dec 2019 09:15:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191224112822.8664-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/24/19 4:28 AM, Hillf Danton wrote:
> 
> On Sat, 21 Dec 2019 07:37:42 -0700 Jens Axboe wrote:
>>
>> On 12/21/19 7:30 AM, Hillf Danton wrote:
>>>
>>> On Fri, 20 Dec 2019 23:58:08 -0800
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
>>>> git tree:       linux-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12e1823ee00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=8e7705a7ae1bdce77c07
>>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>>
>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>> Reported-by: syzbot+8e7705a7ae1bdce77c07@syzkaller.appspotmail.com
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: use-after-free in io_wq_flush+0x1f7/0x210 fs/io-wq.c:1009
>>>> Read of size 8 at addr ffff8880a8453d00 by task kworker/0:1/12
>>>>
>>>> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted  
>>>> 5.5.0-rc2-next-20191220-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
>>>> Google 01/01/2011
>>>> Workqueue: events io_ring_file_ref_switch
>>>> Call Trace:
>>>>   __dump_stack lib/dump_stack.c:77 [inline]
>>>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>>>   print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
>>>>   __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
>>>>   kasan_report+0x12/0x20 mm/kasan/common.c:639
>>>>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
>>>>   io_wq_flush+0x1f7/0x210 fs/io-wq.c:1009
>>>>   io_destruct_skb+0x8e/0xc0 fs/io_uring.c:4668
>>>>   skb_release_head_state+0xeb/0x260 net/core/skbuff.c:652
>>>>   skb_release_all+0x16/0x60 net/core/skbuff.c:663
>>>>   __kfree_skb net/core/skbuff.c:679 [inline]
>>>>   kfree_skb net/core/skbuff.c:697 [inline]
>>>>   kfree_skb+0x101/0x420 net/core/skbuff.c:691
>>>>   io_ring_file_put fs/io_uring.c:4836 [inline]
>>>>   io_ring_file_ref_switch+0x68a/0xac0 fs/io_uring.c:4881
>>>>   process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
>>>>   worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>>>>   kthread+0x361/0x430 kernel/kthread.c:255
>>>>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>>>>
>>>> Allocated by task 9937:
>>>>   save_stack+0x23/0x90 mm/kasan/common.c:72
>>>>   set_track mm/kasan/common.c:80 [inline]
>>>>   __kasan_kmalloc mm/kasan/common.c:513 [inline]
>>>>   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
>>>>   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
>>>>   kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
>>>>   kmalloc include/linux/slab.h:555 [inline]
>>>>   kzalloc include/linux/slab.h:669 [inline]
>>>>   io_wq_create+0x52/0xa40 fs/io-wq.c:1024
>>>>   io_sq_offload_start fs/io_uring.c:5244 [inline]
>>>>   io_uring_create fs/io_uring.c:6002 [inline]
>>>>   io_uring_setup+0xf4a/0x2080 fs/io_uring.c:6062
>>>>   __do_sys_io_uring_setup fs/io_uring.c:6075 [inline]
>>>>   __se_sys_io_uring_setup fs/io_uring.c:6072 [inline]
>>>>   __x64_sys_io_uring_setup+0x54/0x80 fs/io_uring.c:6072
>>>>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>
>>>> Freed by task 9935:
>>>>   save_stack+0x23/0x90 mm/kasan/common.c:72
>>>>   set_track mm/kasan/common.c:80 [inline]
>>>>   kasan_set_free_info mm/kasan/common.c:335 [inline]
>>>>   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
>>>>   kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
>>>>   __cache_free mm/slab.c:3426 [inline]
>>>>   kfree+0x10a/0x2c0 mm/slab.c:3757
>>>>   io_wq_destroy+0x2ce/0x3c0 fs/io-wq.c:1116
>>>>   io_finish_async+0x128/0x1b0 fs/io_uring.c:4657
>>>>   io_ring_ctx_free fs/io_uring.c:5569 [inline]
>>>>   io_ring_ctx_wait_and_kill+0x330/0x9a0 fs/io_uring.c:5644
>>>>   io_uring_release+0x42/0x50 fs/io_uring.c:5652
>>>>   __fput+0x2ff/0x890 fs/file_table.c:280
>>>>   ____fput+0x16/0x20 fs/file_table.c:313
>>>>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>>>>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>>>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
>>>>   prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>>>>   syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
>>>>   do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
>>>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>
>>>> The buggy address belongs to the object at ffff8880a8453d00
>>>>   which belongs to the cache kmalloc-192 of size 192
>>>> The buggy address is located 0 bytes inside of
>>>>   192-byte region [ffff8880a8453d00, ffff8880a8453dc0)
>>>> The buggy address belongs to the page:
>>>> page:ffffea0002a114c0 refcount:1 mapcount:0 mapping:ffff8880aa400000  
>>>> index:0x0
>>>> raw: 00fffe0000000200 ffffea0002644808 ffffea0002482f08 ffff8880aa400000
>>>> raw: 0000000000000000 ffff8880a8453000 0000000100000010 0000000000000000
>>>> page dumped because: kasan: bad access detected
>>>>
>>>> Memory state around the buggy address:
>>>>   ffff8880a8453c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>>   ffff8880a8453c80: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
>>>>> ffff8880a8453d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>                     ^
>>>>   ffff8880a8453d80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>>>   ffff8880a8453e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>> ==================================================================
>>>
>>> Erase ctx's io_wq before destroying.
>>>
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4651,12 +4651,13 @@ static void io_sq_thread_stop(struct io_
>>>  
>>>  static void io_finish_async(struct io_ring_ctx *ctx)
>>>  {
>>> +	struct io_wq *io_wq;
>>> +
>>>  	io_sq_thread_stop(ctx);
>>>  
>>> -	if (ctx->io_wq) {
>>> -		io_wq_destroy(ctx->io_wq);
>>> -		ctx->io_wq = NULL;
>>> -	}
>>> +	io_wq = xchg(&ctx->io_wq, NULL);
>>> +	if (io_wq)
>>> +		io_wq_destroy(io_wq);
>>>  }
>>>  
>>>  #if defined(CONFIG_UNIX)
>>
>> I actually think we can just kill the flush off the skb put path, it's
>> not needed.
>>
> Hi Jens
> 
> I want to fix the race if it's still out there.

Can you check the current tree? I killed the flush from the skb destruct,
it's not needed.

-- 
Jens Axboe

