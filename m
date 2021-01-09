Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9952F0166
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbhAIQQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbhAIQQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:16:20 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762B9C061786;
        Sat,  9 Jan 2021 08:15:39 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so10170064wma.5;
        Sat, 09 Jan 2021 08:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tv4KROsuRFWlCs9u0SePAVeXz4l1DwM+0/bdhQze184=;
        b=S5ybtHR4gAD4diOgf5HIvFj2yJgcSAC6eU9kmhNVtYxR5rvJECnYmCtDD4cXo9X8mV
         eUhSkRtxFMk2gAh9Swtzm46owPtLlKJqwnnwShKMbNMrm9qnj9snau+VSM+r/H7YaVFK
         qdVHK8weVtljEkQao82MzRYD41bI8kvr2vSgKZzPr3kS4HSdDQYtREVsEzm2hd0Ey9JW
         SUbba1xCLENRlGtL8Nxdx8FzUkGlYuUhkeZAxX+jhhR/jspaTo7UvhaNvNuloCxqzoMV
         K0pB82UkUcaWf2so9aVbzCgJRnC7WtAXvJooVH7pjbykwQf5P6Y/cb3177kCPeuEfyMp
         3zOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Tv4KROsuRFWlCs9u0SePAVeXz4l1DwM+0/bdhQze184=;
        b=MYF4t7g7EvHPYPn1bpicI5W5L1X2753DxN/Nv4Vcis5QVcbJoIfiKIyajSkyxpFu2N
         GdQBOtCr1jJ8blzcwYs+KlBDUtZwwOzveDsfgv4rV1mhngEBeQyXe+wJGnM6A6U8M6Ta
         zGzk4mEiNWcGQeFoqdAa+AFDqVA8W090JrBVmEbXaI5FZKNjD2m81+EHCw/P7VQx1Fkc
         +hxNd1tlJH8mlRPDd83IoiNkimPN2LTaTyrwu6dts4N67tH8MD+bDWmTfrBTzclotoh4
         TPD3DUXoLSJhUC1kHhQ49OmOIpuxaxvUXRk3AkkefLfBGALDRYDCjL4HkAph7tBkS1P6
         QC9g==
X-Gm-Message-State: AOAM530AdD70fOC43LbJWq6Ui7VZtZRPqVblMC1ZND7/oTw/fIWEOhsh
        vXCaa+CXm1JEpMwIuLi1EtHJoVpLBJXpuN9e
X-Google-Smtp-Source: ABdhPJz4OLgQHyPrkIpt89QF9gpLWaWvTsMJfCVH7CqJe+fbvqJCoBx0oe9a5NUkGwObjxJeiz4T0g==
X-Received: by 2002:a1c:2d8a:: with SMTP id t132mr7512098wmt.119.1610208938268;
        Sat, 09 Jan 2021 08:15:38 -0800 (PST)
Received: from [192.168.8.114] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id z63sm16614465wme.8.2021.01.09.08.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 08:15:37 -0800 (PST)
Subject: Re: general protection fault in io_sqe_files_unregister
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+9ec0395bc17f2b1e3cc1@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000ee606405b873772a@google.com>
 <20210109115030.11184-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <0156ca8e-0914-3fff-1f2f-a48f14cf46b1@gmail.com>
Date:   Sat, 9 Jan 2021 16:12:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210109115030.11184-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/01/2021 11:50, Hillf Danton wrote:
> Sat, 09 Jan 2021 00:29:16 -0800
>> syzbot found the following issue on:
>>
>> HEAD commit:    71c061d2 Merge tag 'for-5.11-rc2-tag' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ec3f67500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9ec0395bc17f2b1e3cc1
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+9ec0395bc17f2b1e3cc1@syzkaller.appspotmail.com
>>
>> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>> CPU: 1 PID: 9107 Comm: syz-executor.2 Not tainted 5.11.0-rc2-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:__list_add include/linux/list.h:71 [inline]
>> RIP: 0010:list_add_tail include/linux/list.h:100 [inline]
>> RIP: 0010:io_sqe_files_set_node fs/io_uring.c:7243 [inline]
>> RIP: 0010:io_sqe_files_unregister+0x42a/0x770 fs/io_uring.c:7279
>> Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 07 03 00 00 4c 89 ea 4c 89 ad 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 f4 02 00 00 49 8d 7f 18 48 8d 85 80 00 00 00 48
>> RSP: 0018:ffffc9000982fcf8 EFLAGS: 00010247
>> RAX: dffffc0000000000 RBX: ffff88814763fe90 RCX: ffffc9000d28d000
>> RDX: 0000000000000000 RSI: ffffffff81d82695 RDI: 0000000000000003
>> RBP: ffff88814763fe00 R08: 0000000000000001 R09: 0000000000000001
>> R10: ffffffff81d82684 R11: 0000000000000000 R12: 00000000fffffffc
>> R13: 0000000000000004 R14: ffff88814763fe80 R15: fffffffffffffff4
>> FS:  00007f6532203700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00000000200000d8 CR3: 0000000014ad5000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  __io_uring_register fs/io_uring.c:9916 [inline]
>>  __do_sys_io_uring_register+0x1185/0x4080 fs/io_uring.c:10000
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45e219
>> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f6532202c68 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
>> RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 000000000045e219
>> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000003
>> RBP: 00007f6532202ca0 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00000000016afb5f R14: 00007f65322039c0 R15: 000000000119bf8c
>> Modules linked in:
>> ---[ end trace 6e4aada9e44ca3d1 ]---
> 
> Fix typo in 1ffc54220c44

Thanks for the suggestion, but it was already fixed

#syz fix: io_uring: Fix return value from alloc_fixed_file_ref_node

> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7255,8 +7255,8 @@ static int io_sqe_files_unregister(struc
>  	if (!data)
>  		return -ENXIO;
>  	backup_node = alloc_fixed_file_ref_node(ctx);
> -	if (!backup_node)
> -		return -ENOMEM;
> +	if (IS_ERR(backup_node))
> +		return PTR_ERR(backup_node);
>  
>  	spin_lock_bh(&data->lock);
>  	ref_node = data->node;
> 

-- 
Pavel Begunkov
