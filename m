Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B6C2D0540
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 14:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgLFNf3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 08:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbgLFNf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 08:35:27 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6479AC0613D0;
        Sun,  6 Dec 2020 05:34:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r3so10058470wrt.2;
        Sun, 06 Dec 2020 05:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hn9CunhGBfggzx6rrK8ZCKCU1OAb5Tv9YC9HbId8v5Y=;
        b=G8lfpOAuN8acmx7f/UamrGAfa9UPtqW1eWOD3YN+0ci3VKzyLUev8VS0915pHXubbY
         cmKdI1B4XUBmRJyTTxmDcluSYgHaQeFJf3P5nkYLbhAGAe2E9ql/oPjZOocNYCFfOS7X
         T43gDp/nRg52YT6pKFHmkI3AMZYaOU6DzwAzN/iw3cA95zLmv2RZ5Z41htla7eEoLaya
         ahWygVR8LKnXUIDVzawwWuBtnLPphKUXnZqwT2zsv0LEzVCLFqqkepj8u0U11pxgz/Ya
         9AFL9pUYjM6ua/Bk8EHiNNSNTfLp93t7H47DJ5sS+QBJTG0f3huNTMzq+fQzREHca38i
         KEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hn9CunhGBfggzx6rrK8ZCKCU1OAb5Tv9YC9HbId8v5Y=;
        b=CfNjwzSMZD7eFfTFu7c4gUw67mQhlYFFQWWG0xdqE0/Z8GXUBbdpU2uPMWcNtZCccU
         dMCqyCuPanNSl7k8V+FcQh3prdBxNnezt+sVGc9PzZ0/ZdCRjhH1XqOFXzlYTajytzxc
         j8Ub/JSwarnxhJnEJu5+x6y1xVGvW4GS0E2/PMJ0ABQuwD9qVhHYWvCh+N33FhdR8hJt
         XRkT5ev0FV6/oytRfzbVbSkO6GCkzalNLfeHf/C30HbJuE0+wL5fT5ttLxW+WMzMQQJM
         4JuK0A7ynAAtXfDAQ82Z6PGrKk86YgBXAmAdYpXocubhkdWJi/KfrksCic+iTEHTihs4
         IROQ==
X-Gm-Message-State: AOAM531ZFtQbpbKBrSY6YGny21lxHtjZIYKxbOX25ZDXpiXNmXPRSi2E
        WX9zH1zf/NuovEZSDwzaR3M=
X-Google-Smtp-Source: ABdhPJyKTG3+4TLlJkPHvSIHX3nwSYoSvPJfVduC4T4b0q/ihSMQ4Gw9D30rS1LJ97btmCtAWuSJsA==
X-Received: by 2002:a5d:528a:: with SMTP id c10mr14393469wrv.270.1607261668138;
        Sun, 06 Dec 2020 05:34:28 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id h83sm11071018wmf.9.2020.12.06.05.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 05:34:27 -0800 (PST)
Subject: Re: memory leak in prepare_creds
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000ca5cfb05ade37394@google.com>
 <20201128080016.9132-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <86f70001-fd2c-d17a-d79b-d2809a79ca0b@gmail.com>
Date:   Sun, 6 Dec 2020 13:31:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201128080016.9132-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/11/2020 08:00, Hillf Danton wrote:
> On Fri, 27 Nov 2020 19:47:15 -0800
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    99c710c4 Merge tag 'platform-drivers-x86-v5.10-2' of git:/..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12a77ddd500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c7a27a77f20fbc95
>> dashboard link: https://syzkaller.appspot.com/bug?extid=71c4697e27c99fddcf17
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d6161d500000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f15e65500000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com
>>
>> BUG: memory leak
>> unreferenced object 0xffff888101401300 (size 168):
>>   comm "syz-executor355", pid 8461, jiffies 4294953658 (age 32.400s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<00000000caa0de2b>] prepare_creds+0x25/0x390 kernel/cred.c:258
>>     [<000000001821b99d>] copy_creds+0x3a/0x230 kernel/cred.c:358
>>     [<0000000022c32914>] copy_process+0x661/0x24d0 kernel/fork.c:1971
>>     [<00000000d3adca2d>] kernel_clone+0xf3/0x670 kernel/fork.c:2456
>>     [<00000000d11b7286>] __do_sys_clone+0x76/0xa0 kernel/fork.c:2573
>>     [<000000008280baad>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<00000000685d8cf0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88810b0a6f20 (size 32):
>>   comm "syz-executor355", pid 8461, jiffies 4294953658 (age 32.400s)
>>   hex dump (first 32 bytes):
>>     b0 6e 93 00 81 88 ff ff 00 00 00 00 00 00 00 00  .n..............
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<000000007d750ba1>] kmalloc include/linux/slab.h:557 [inline]
>>     [<000000007d750ba1>] kzalloc include/linux/slab.h:664 [inline]
>>     [<000000007d750ba1>] lsm_cred_alloc security/security.c:533 [inline]
>>     [<000000007d750ba1>] security_prepare_creds+0xa5/0xd0 security/security.c:1632
>>     [<00000000ba63fcc7>] prepare_creds+0x277/0x390 kernel/cred.c:285
>>     [<000000001821b99d>] copy_creds+0x3a/0x230 kernel/cred.c:358
>>     [<0000000022c32914>] copy_process+0x661/0x24d0 kernel/fork.c:1971
>>     [<00000000d3adca2d>] kernel_clone+0xf3/0x670 kernel/fork.c:2456
>>     [<00000000d11b7286>] __do_sys_clone+0x76/0xa0 kernel/fork.c:2573
>>     [<000000008280baad>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<00000000685d8cf0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fail to spot the cred leak.
>>
>> BUG: memory leak
>> unreferenced object 0xffff888101ea2200 (size 256):
>>   comm "syz-executor355", pid 8470, jiffies 4294953658 (age 32.400s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     20 59 03 01 81 88 ff ff 80 87 a8 10 81 88 ff ff   Y..............
>>   backtrace:
>>     [<000000002e0a7c5f>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
>>     [<000000002e0a7c5f>] __alloc_file+0x1f/0x130 fs/file_table.c:101
>>     [<000000001a55b73a>] alloc_empty_file+0x69/0x120 fs/file_table.c:151
>>     [<00000000fb22349e>] alloc_file+0x33/0x1b0 fs/file_table.c:193
>>     [<000000006e1465bb>] alloc_file_pseudo+0xb2/0x140 fs/file_table.c:233
>>     [<000000007118092a>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
>>     [<000000007118092a>] anon_inode_getfile+0xaa/0x120 fs/anon_inodes.c:74
>>     [<000000002ae99012>] io_uring_get_fd fs/io_uring.c:9198 [inline]
>>     [<000000002ae99012>] io_uring_create fs/io_uring.c:9377 [inline]
>>     [<000000002ae99012>] io_uring_setup+0x1125/0x1630 fs/io_uring.c:9411
>>     [<000000008280baad>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<00000000685d8cf0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
> Put file as part of the error handling after getting a new one.

Looks genuine to me, would you send a real patch?

> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9182,6 +9182,7 @@ static int io_uring_get_fd(struct io_rin
>  {
>  	struct file *file;
>  	int ret;
> +	int fd;
>  
>  #if defined(CONFIG_UNIX)
>  	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
> @@ -9190,28 +9191,29 @@ static int io_uring_get_fd(struct io_rin
>  		return ret;
>  #endif
>  
> -	ret = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
> +	ret = fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
>  	if (ret < 0)
>  		goto err;
>  
>  	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
>  					O_RDWR | O_CLOEXEC);
>  	if (IS_ERR(file)) {
> -err_fd:
> -		put_unused_fd(ret);
>  		ret = PTR_ERR(file);
> +		put_unused_fd(fd);
>  		goto err;
>  	}
>  
>  #if defined(CONFIG_UNIX)
>  	ctx->ring_sock->file = file;
>  #endif
> -	if (unlikely(io_uring_add_task_file(ctx, file))) {
> -		file = ERR_PTR(-ENOMEM);
> -		goto err_fd;
> +	ret = io_uring_add_task_file(ctx, file);
> +	if (ret) {
> +		fput(file);
> +		put_unused_fd(fd);
> +		goto err;
>  	}
>  	fd_install(ret, file);
> -	return ret;
> +	return 0;
>  err:
>  #if defined(CONFIG_UNIX)
>  	sock_release(ctx->ring_sock);
> 

-- 
Pavel Begunkov
