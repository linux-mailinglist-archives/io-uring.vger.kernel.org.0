Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A632F6CE6
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhANVLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhANVLW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:11:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE62C061575;
        Thu, 14 Jan 2021 13:10:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id a6so5691285wmc.2;
        Thu, 14 Jan 2021 13:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KAEkFJhnYi0ddkau1rngyVSw0P6Eomgp1P4QiKEtk7c=;
        b=i5tUb96oSzXpMSXkKCvjS6ZRRKunBgelqXSudCVjBmp8lNjbHhJ2Wad7g8FoWhkpUa
         YwphC3s0B5wSjEVYjtL+dWygLg9oUIpttb0gqnpi2y5/0rBROg92ow247JYSvKDGxs0a
         DJL0JjcqmZal4UA2EUCscHFdcFC2sVd3Y7VeLRhPNsHQCHDhuoPFiHvUv01ND21xMWjJ
         rz42oR17aaMS6raBvTbYBMhdhFFZ+rXF8Ql47BcesPHUSGNT+qJpRTViqgUjt/z2iIQN
         8SPo/kDdr6iWMF32ciECHq8AJYG4GhUqtVirkQpekq3jJQl8GSbMfNUz3ZTPMvIlfpTs
         ez1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KAEkFJhnYi0ddkau1rngyVSw0P6Eomgp1P4QiKEtk7c=;
        b=pMS3y/VqkPwl7OzE3Tp+HJ2WtFsh44LenOEsxqsXCffwD4Ho6YjJ5kVKjfA/5qzBNY
         OLWNMxR76EgfNApYPFlWCWSuP5wMbaGN/fS/ED2M74Ub7OSg16R9osTkSXw1nO5ITpkL
         cd0+arZqbPtm0vltNSyA4oDrPPMS/Dktc4V1c7SGVtwQC5SNU15wF1aGZ/+xPA/h+XKq
         DXb3SksRu+PcVBraIh1lsOyOdUvBcw+/OkvfbHfCSOHNOWbBV09IY61BKTvP8zYTpGfx
         EVjAJgFndgZJMKdzms/1H1qGLFIFV2JtXoSl8mqBidOu3lm21StdZjGwLh3r+jdgqXcT
         Vqjw==
X-Gm-Message-State: AOAM531BCrTcpL6I9mUFZDOI2MLc38BS/Eh30629kv99V8NXiYHXeRyN
        2MU/5dBChMQVB+LzQ3LjT2EI+WB7KmdhAQ==
X-Google-Smtp-Source: ABdhPJxRyAVxaMVUlmGBWMqUpHVk+41u/sDn8bQS7pXGWuvipiDZ+PEFKaus7HAlEKWAk+V51H4fnA==
X-Received: by 2002:a7b:c92b:: with SMTP id h11mr5596496wml.99.1610658641061;
        Thu, 14 Jan 2021 13:10:41 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id h16sm9939666wmb.41.2021.01.14.13.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:10:40 -0800 (PST)
Subject: Re: general protection fault in io_disable_sqo_submit
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000006c2105b8c5b9b9@google.com>
 <20210114074017.1753-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e39d8a49-fe85-fc35-2f3c-51a387fd2858@gmail.com>
Date:   Thu, 14 Jan 2021 21:07:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210114074017.1753-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 07:40, Hillf Danton wrote:
> Wed, 13 Jan 2021 02:37:15 -0800
>> syzbot found the following issue on:
>>
>> HEAD commit:    7c53f6b6 Linux 5.11-rc3
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1606a757500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
>> dashboard link: https://syzkaller.appspot.com/bug?extid=ab412638aeb652ded540
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adb0d0d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1527be48d00000
>>
>> The issue was bisected to:
>>
>> commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Fri Jan 8 20:57:25 2021 +0000
>>
>>     io_uring: stop SQPOLL submit on creator's death
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b3b248d00000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1473b248d00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1073b248d00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
>> Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
>>
>> RDX: 0000000000000001 RSI: 0000000020000300 RDI: 00000000000000ff
>> RBP: 0000000000011fc2 R08: 0000000000000001 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
>> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
>> general protection fault, probably for non-canonical address 0xdffffc0000000022: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000110-0x0000000000000117]
>> CPU: 1 PID: 8473 Comm: syz-executor814 Not tainted 5.11.0-rc3-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
>> RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
>> Code: fa 48 c1 ea 03 80 3c 02 00 75 62 48 8b 9b c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 14 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83
>> RSP: 0018:ffffc9000154fd78 EFLAGS: 00010007
>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815976e0
>> RDX: 0000000000000022 RSI: 0000000000000004 RDI: 0000000000000114
>> RBP: ffff8880149ee480 R08: 0000000000000001 R09: 0000000000000003
>> R10: fffff520002a9fa1 R11: 1ffffffff1d308df R12: fffffffffffffff4
>> R13: 0000000000000001 R14: ffff8880149ee054 R15: ffff8880149ee000
>> FS:  0000000000be4880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000020000304 CR3: 0000000014b50000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  io_uring_create fs/io_uring.c:9711 [inline]
>>  io_uring_setup+0x12b1/0x38e0 fs/io_uring.c:9739
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x441309
>> Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007ffea5e64578 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441309
>> RDX: 0000000000000001 RSI: 0000000020000300 RDI: 00000000000000ff
>> RBP: 0000000000011fc2 R08: 0000000000000001 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
>> R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
>> Modules linked in:
>> ---[ end trace 0941172fec2041bb ]---
>> RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
>> RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
>> Code: fa 48 c1 ea 03 80 3c 02 00 75 62 48 8b 9b c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 14 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83
>> RSP: 0018:ffffc9000154fd78 EFLAGS: 00010007
>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815976e0
>> RDX: 0000000000000022 RSI: 0000000000000004 RDI: 0000000000000114
>> RBP: ffff8880149ee480 R08: 0000000000000001 R09: 0000000000000003
>> R10: fffff520002a9fa1 R11: 1ffffffff1d308df R12: fffffffffffffff4
>> R13: 0000000000000001 R14: ffff8880149ee054 R15: ffff8880149ee000
>> FS:  0000000000be4880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000020000304 CR3: 0000000014b50000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> Fix d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")
> by setting ctx->sqo_dead as part of cleanup in case of failing to
> create io uring context, to quiesce the warning added in the commit.

Thanks, but it was fixed the day before

-- 
Pavel Begunkov
