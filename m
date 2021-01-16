Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D42F8B37
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 05:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAPEcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 23:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPEcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 23:32:05 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7774C061757;
        Fri, 15 Jan 2021 20:31:24 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c124so9053134wma.5;
        Fri, 15 Jan 2021 20:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gxpLILV7ArL6pMN8l8E4IEWbfLlyirnAvXp5Iekqnkc=;
        b=gYuPkJD/Meks2aw/ZgKNpoN59QLqXiJYy4+doCPZ4xla0hl6YJ3OZMqkKhitx1fRrY
         WbJEpzqHDTZ35KvkglikkV6zrrB3A8/SaO4WTdSybggiCG7t2BjTxAdkxxR6TNdIXHJ3
         3/ELlbFtZVnKFwICVXn7p76PPqQi1YH1zORc+b8GhTC/B1hay+HyELcqgn0Vk+qTcnV1
         Skn4iiSv5belEao66+gI/EK15seyqCNbCu1Jg4Yz/ZU73yqozwb2OHmR8+waTq5S/xuQ
         YHoSRhjW1f2izFLsRJB1KcPMUekSZu5rD9OK2hMbmaoLcfmxWctNTE7SNKDXZhD+1tLu
         mvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gxpLILV7ArL6pMN8l8E4IEWbfLlyirnAvXp5Iekqnkc=;
        b=QofZikVdm1FMG5AS36T5AupHrwvirbyV9oQfjiUqlKF67Fu9I5UUDkynPLhjQqQCBJ
         T883E1Xlz+Z4qpsnZC02rY90yJMdl9mux4qaSDkf42R3uSeNhvcFW7qJZHAdO3iUeKd4
         NN4ay1ykJTlAJBDI9wG/ISSHBeX6rB8jlFOoySeXrCI8/air0G/IG8dgiTfLnxR9eyqh
         fU3ERVqVQzog/7YUMXrMgH7b9G67OmG/xICim/WvKuWgsIOITlcgHSSCKbZ/RXWSxB3W
         FwNQWgdOSV2vYmfe5t6a+VpJz+kkWO+ganMPlV+s8mfS/jpllsYxWFOCx9HKgtPmMNtX
         3EPg==
X-Gm-Message-State: AOAM532C2mrfeI2FYLCp3zXgEcV9UNc1kEAXKn0NHW4b381VDo8c1tjb
        4k1DWEtdvdQXxbCsVXR6vDA=
X-Google-Smtp-Source: ABdhPJzt9062J5Pn16dXBirEMTKk27F28EXCjDPAvfypgR9ZH1ohh0d8M90ltYWvbeZ+nOeuJwcaVg==
X-Received: by 2002:a1c:f302:: with SMTP id q2mr11070988wmq.15.1610771483722;
        Fri, 15 Jan 2021 20:31:23 -0800 (PST)
Received: from [192.168.8.125] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id m5sm16697250wrz.18.2021.01.15.20.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:31:23 -0800 (PST)
Subject: Re: WARNING in io_uring_flush
To:     syzbot <syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000002c365205b8f26d09@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b3fa541c-72d6-4667-3e26-421eb4985812@gmail.com>
Date:   Sat, 16 Jan 2021 04:27:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0000000000002c365205b8f26d09@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/01/2021 15:57, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    14662050 Merge tag 'linux-kselftest-fixes-5.11-rc4' of git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a09ed0d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c066f800cf2824be
> dashboard link: https://syzkaller.appspot.com/bug?extid=a32b546d58dde07875a1
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com

I know a case how it can happen, and if that's the only way then this
is a false positive. I'll put up a patch and we'll if syzbot will
trigger it again.

> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 11100 at fs/io_uring.c:9096 io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
> Modules linked in:
> CPU: 1 PID: 11100 Comm: syz-executor.3 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
> Code: e9 58 fe ff ff e8 6a 21 9b ff 49 c7 84 24 a0 00 00 00 00 00 00 00 e9 aa fe ff ff e8 44 9c dd ff e9 91 fd ff ff e8 4a 21 9b ff <0f> 0b e9 51 ff ff ff e8 3e 9c dd ff e9 06 fd ff ff 4c 89 f7 e8 31
> RSP: 0018:ffffc90000fd7aa0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880758de140 RSI: ffffffff81d7aac6 RDI: 0000000000000003
> RBP: ffff8880264d8500 R08: 0000000000000000 R09: 0000000028eda801
> R10: ffffffff81d7aa15 R11: 0000000000000000 R12: ffff888035f73000
> R13: ffff888028eda801 R14: ffff888035f73040 R15: ffff888035f730d0
> FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f16cd441710 CR3: 000000006924f000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  filp_close+0xb4/0x170 fs/open.c:1280
>  close_files fs/file.c:401 [inline]
>  put_files_struct fs/file.c:416 [inline]
>  put_files_struct+0x1cc/0x350 fs/file.c:413
>  exit_files+0x7e/0xa0 fs/file.c:433
>  do_exit+0xc22/0x2ae0 kernel/exit.c:820
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x3e9/0x20a0 kernel/signal.c:2770
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: Unable to access opcode bytes at RIP 0x45e1ef.
> RSP: 002b:00007f49d69f3c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffe0 RBX: 0000000000000006 RCX: 000000000045e219
> RDX: ffffffffffffffef RSI: 0000000020d7cfcb RDI: 0000000000000007
> RBP: 000000000119bfd8 R08: 0000000000000000 R09: 00000000ffffffd8
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
> R13: 00007fff13b97d2f R14: 00007f49d69f49c0 R15: 000000000119bf8c
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

-- 
Pavel Begunkov
