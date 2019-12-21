Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7612895B
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfLUOC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 09:02:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45761 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfLUOC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 09:02:28 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so6427569pgk.12
        for <io-uring@vger.kernel.org>; Sat, 21 Dec 2019 06:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Lc+T/FNxbn2ck1uy8M9pSQdxYkpPnlZqGKQGiC0A2o=;
        b=Aq5/F4sIrm5dfV542L953T1FmPHcqItoJmm2EIFZGpVQG33isOI5UNIr8NvYlciJeC
         gq2JHaLel1Y0yAeVNPLZjMAQp1i2b2I1rR2vEj2s2FRP3eOgrbIYWn8gA2SyUPMY0Jux
         w5P1bE/0lz0d6I39Kf6HbzwG+07RVDQ7YiKVBEoDrzUrr9+KVxA4fDjI2zIkjF1zbzZu
         7JjotrKEoNx0w0aRjWjHGU1uoSXdoT7gT81XVUHOCJuoZaLtg3sdM9oNqBWtMQjKl58k
         e4QbswW2zTJKVJrMjyYm5K95L+z6v9I1sBWUQp6/0Sz5RlM+j47xaswFV2bJqMv/yp4V
         Twaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Lc+T/FNxbn2ck1uy8M9pSQdxYkpPnlZqGKQGiC0A2o=;
        b=JNHsLLgI4+NsyEE2AXPSRR0VpRUT3xX5ASiXm1LlEwU4ns/iDvxrOBuGhTyKRIj1w+
         hVJTJRgrxc/1oyi0Fktip/Z1jpRYJFBnVwNizwE7x9aYonfJeg8wWe1NcuQtF+6eVwcH
         4g16FgUZznu63dHNjxZmMdPfd1ymm0tNZXMjriDjOGsrSWzteskBqQzqWWf5k7waebGs
         DHs8Pmhzo3XnYwwNuxgOVzG3MwD2+d09Nj34Kn9H2iVZkSPsSzPPNakp7/C+bNcLDYBT
         74KniV4yL2OvriuSgg/Ol6anIxXuY//Myps5PS3+u7NfncmyOqLzXFx0wguvvKeHRnQ1
         nTjw==
X-Gm-Message-State: APjAAAWI9ItIVkatxGVAMJpRTYckiWEL1weWSAh02cEm7b7Fzi8dZPq4
        pZB7mDNVGH5w4/GgjkPh3T5mVA==
X-Google-Smtp-Source: APXvYqwNUe16DaQdazgidIHMcdaImKxGvQ4eoQK+A96GKZTFrbxfU7+5A9OnYW6DowHegnfgQpZ76g==
X-Received: by 2002:a65:6842:: with SMTP id q2mr21438814pgt.345.1576936947397;
        Sat, 21 Dec 2019 06:02:27 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 65sm17954237pfu.140.2019.12.21.06.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 06:02:26 -0800 (PST)
Subject: Re: WARNING in percpu_ref_exit (2)
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20191221134330.7376-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <94c867f3-7310-573f-9fbd-088d4a75d6a3@kernel.dk>
Date:   Sat, 21 Dec 2019 07:02:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191221134330.7376-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/19 6:43 AM, Hillf Danton wrote:
> 
> On Sat, 21 Dec 2019 00:05:07 -0800
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12a18cc6e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8c4a14856e657b43487c
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b8f351e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b51925e00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 11482 at lib/percpu-refcount.c:111  
>> percpu_ref_exit+0xab/0xd0 lib/percpu-refcount.c:111
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 1 PID: 11482 Comm: syz-executor051 Not tainted  
>> 5.5.0-rc2-next-20191220-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
>> Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>   panic+0x2e3/0x75c kernel/panic.c:221
>>   __warn.cold+0x2f/0x3e kernel/panic.c:582
>>   report_bug+0x289/0x300 lib/bug.c:195
>>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>>   fixup_bug arch/x86/kernel/traps.c:169 [inline]
>>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> RIP: 0010:percpu_ref_exit+0xab/0xd0 lib/percpu-refcount.c:111
>> Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 1d 48 c7 43 08 03 00  
>> 00 00 e8 01 41 e5 fd 5b 41 5c 41 5d 5d c3 e8 f5 40 e5 fd <0f> 0b eb bf 4c  
>> 89 ef e8 29 2c 23 fe eb d9 e8 82 2b 23 fe eb a7 4c
>> RSP: 0018:ffffc9000cb17968 EFLAGS: 00010293
>> RAX: ffff8880a3390640 RBX: ffff8880a83a8010 RCX: ffffffff83901432
>> RDX: 0000000000000000 RSI: ffffffff8390149b RDI: ffff8880a83a8028
>> RBP: ffffc9000cb17980 R08: ffff8880a3390640 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000607f51435750
>> R13: ffff8880a83a8018 R14: ffff888097b95000 R15: ffff888097b95228
>>   io_sqe_files_unregister+0x7d/0x2f0 fs/io_uring.c:4623
>>   io_ring_ctx_free fs/io_uring.c:5575 [inline]
>>   io_ring_ctx_wait_and_kill+0x430/0x9a0 fs/io_uring.c:5644
>>   io_uring_release+0x42/0x50 fs/io_uring.c:5652
>>   __fput+0x2ff/0x890 fs/file_table.c:280
>>   ____fput+0x16/0x20 fs/file_table.c:313
>>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>>   exit_task_work include/linux/task_work.h:22 [inline]
>>   do_exit+0x909/0x2f20 kernel/exit.c:797
>>   do_group_exit+0x135/0x360 kernel/exit.c:895
>>   get_signal+0x47c/0x24f0 kernel/signal.c:2734
>>   do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
>>   exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
>>   prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>>   syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
>>   do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Flush work before killing.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4618,10 +4618,10 @@ static int io_sqe_files_unregister(struc
>  	if (!data)
>  		return -ENXIO;
>  
> +	flush_work(&data->ref_work);
>  	percpu_ref_kill_and_confirm(&data->refs, io_file_ref_kill);
>  	wait_for_completion(&data->done);
>  	percpu_ref_exit(&data->refs);
> -	flush_work(&data->ref_work);
>  
>  	__io_sqe_files_unregister(ctx);
>  	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);

Oh indeed, good catch! Thanks, I'll fold this in.

-- 
Jens Axboe

