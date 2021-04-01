Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB1351830
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhDARoQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbhDARiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8151BC02FEA3
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 09:09:20 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n198so501021iod.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 09:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=48dyaiUyVqMwLE0OwYdfA5ySCjDx5Xf12eY4xzzdxXs=;
        b=Q/SR523Ar1LWM4oiRWdcYVGDmBiu+zeFT7gA4UE9r2y+wh90OYXx0JJGDPcwMu5adH
         uaxbD0Pu9f5900tZeP3hEe5v2db7lKqxdaDTGAE/r7ppii0REDgnpsq6WNA0PbdjmASs
         de+PdzOIIxIaRBSOh6zS9hLprKOaCN962rHWHBbcMLKOPqJaWZnw7i9AAS1x73820wX4
         8sdjPlS3OXDG74thkV/VB4/we1prlMFDH0VAhEh7RXO01Mzf/ywd8gl8j+WVw6mGPw+B
         rI1wrqE5kG1B24gee8UOlunMIzDWGoXzeN2be49I1Kr/MgV80/4Up2UOB+FRq0EsQwSm
         ieQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=48dyaiUyVqMwLE0OwYdfA5ySCjDx5Xf12eY4xzzdxXs=;
        b=ptTndcpNSw2KvSbiv7vJ1mgpp3Vle9953ekZYzOB8Y/tZGDx31TeUEG7ezNFkjkf/B
         Y0hbRQNL91MFvsPoZx2s9SOcLVFVyIYMJRVM+YQTI3U2iw6dLDJyaPijgRUPi4qqeWv6
         AxUyS6UZxbKSiAGDwxeIyuzxKnFIHJKVo/5hGRXhMgWJ7bvvOlq2ldeGlN/Qzz82ZXiS
         tYI9GGV2ZtUqZUpxeFEuaoWH1e0FSUAQtmDAdJW0f8G10eRip9x6eeHJx1E197fcXS3R
         2OtJV7D9MvqUB46LrzBDe0X0XXQNSTzi61wuvCJpnHG1wo72LVP5foTE6UjIPgGDgSJ2
         2UmA==
X-Gm-Message-State: AOAM533jeuEg33MSsC/CytK3SzT4iSFxY9aJG0mfLi/4hEZyWpbv2RhA
        osIpd90GW3pTMG2Cg1bmSFV1eMLdPKd6Zw==
X-Google-Smtp-Source: ABdhPJx71PWvRQl21JSc09Uw5jU8+9y4mYpLpsKeo9v5KDSxkuD5Ozc7hcvTXmb/nzJ5eqed0eNeZw==
X-Received: by 2002:a5e:c102:: with SMTP id v2mr7178492iol.137.1617293359632;
        Thu, 01 Apr 2021 09:09:19 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b4sm2637045ilj.11.2021.04.01.09.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:09:19 -0700 (PDT)
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        io-uring@vger.kernel.org
References: <0000000000003a565e05bee596f2@google.com>
 <20210401154515.k24qdd2lzhtneu47@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
Date:   Thu, 1 Apr 2021 10:09:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210401154515.k24qdd2lzhtneu47@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/21 9:45 AM, Christian Brauner wrote:
> On Thu, Apr 01, 2021 at 02:09:20AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    d19cc4bf Merge tag 'trace-v5.12-rc5' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1018f281d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c88a7030da47945a3cc3
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f50d11d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137694a1d00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 8409 at fs/namespace.c:1186 mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
>> Modules linked in:
>> CPU: 1 PID: 8409 Comm: syz-executor035 Not tainted 5.12.0-rc5-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:mntput_no_expire+0xaca/0xcb0 fs/namespace.c:1186
>> Code: ff 48 c7 c2 e0 cb 78 89 be c2 02 00 00 48 c7 c7 a0 cb 78 89 c6 05 e5 6d e5 0b 01 e8 ff e1 f6 06 e9 3f fd ff ff e8 c6 a5 a8 ff <0f> 0b e9 fc fc ff ff e8 ba a5 a8 ff e8 55 dc 94 ff 31 ff 89 c5 89
>> RSP: 0018:ffffc9000165fc78 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: 1ffff920002cbf95 RCX: 0000000000000000
>> RDX: ffff88802072d4c0 RSI: ffffffff81cb4b8a RDI: 0000000000000003
>> RBP: ffff888011656900 R08: 0000000000000000 R09: ffffffff8fa978af
>> R10: ffffffff81cb4884 R11: 0000000000000000 R12: 0000000000000008
>> R13: ffffc9000165fcc8 R14: dffffc0000000000 R15: 00000000ffffffff
>> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000055a722053160 CR3: 000000000bc8e000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  mntput fs/namespace.c:1232 [inline]
>>  cleanup_mnt+0x523/0x530 fs/namespace.c:1132
>>  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>>  exit_task_work include/linux/task_work.h:30 [inline]
>>  do_exit+0xbfc/0x2a60 kernel/exit.c:825
>>  do_group_exit+0x125/0x310 kernel/exit.c:922
>>  __do_sys_exit_group kernel/exit.c:933 [inline]
>>  __se_sys_exit_group kernel/exit.c:931 [inline]
>>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x446af9
>> Code: Unable to access opcode bytes at RIP 0x446acf.
>> RSP: 002b:00000000005dfe48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>> RAX: ffffffffffffffda RBX: 00000000004ce450 RCX: 0000000000446af9
>> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
>> RBP: 0000000000000001 R08: ffffffffffffffbc R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ce450
>> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> 
> [+Cc Jens + io_uring]
> 
> Hm, this reproducer uses io_uring and it's the io_uring_enter() that
> triggers this reliably. With this reproducer I've managed to reproduce
> the issue on v5.12-rc4, and v5.12-rc3, v5.12-rc2 and v5.12-rc1.
> It's not reproducible at
> 9820b4dca0f9c6b7ab8b4307286cdace171b724d
> which is the commit immediately before the first v5.12 io_uring merge.
> It's first reproducible with the first io_uring merge for v5.12, i.e.
> 5bbb336ba75d95611a7b9456355b48705016bdb1

Thanks, that's good info. I'll take a look at it and see if I can
reproduce.

-- 
Jens Axboe

