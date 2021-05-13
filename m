Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98D937FF92
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 23:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhEMVE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 17:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhEMVE6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 17:04:58 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93F4C061574;
        Thu, 13 May 2021 14:03:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x5so28124820wrv.13;
        Thu, 13 May 2021 14:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9MhDBHQ11hDldH6MDOJoiTUDCTHB+WEqxchIZghbcyg=;
        b=Ki38mtOICZjMluksRQeBO/wgp4JwGvNkt6B2gZ6orvoHMez0c0Eu5rjMRo69ZxPOlL
         zlmkHvhXeFbAG1PxwvBkWQabumk/1Ajaqb3u38sOMzLAAPh3SwdgOgf2GQctIhX4Dfmr
         MGkWNEERR9cFUF8vh2svKBhyBWkFsa5oQwH4jlfaMM4YMd/EOGnOZZZjFJO5iWmV2fHD
         +1NNGJorb6X6IV2qrheTyKLP+s/iVY4ZJkPbdTJlDPHgeNIY+OA1MRhI2iiVihKVYnMw
         jhh+ihMWQfjVRI489Rk318ATddOkN3uMHMvEu+6XoeXK9xp1VHsZcXcxKzv9WsbPZgqN
         PX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9MhDBHQ11hDldH6MDOJoiTUDCTHB+WEqxchIZghbcyg=;
        b=mGoT+0OOpf7f76aJM1Iy1y5DFPJ+1744+QOOuGR9hYndNysngPnFq54MChIn0L9DhT
         +IwqiFZNgdN197DNcvKNzDpMe6VllK2xMsD8RVzDMY72wBKafKWZQ+n0Pc+v4v3GyLdm
         xpPx0E/FjjTgb0QA69A/P48+tOLEWEaA2+ByhpwMkfdSy0NZVWEkh5DR/HCrRU071Ylj
         ZTo45K0mXuutGSzd+J5qZG0Almn4s3GAWxjw7L9QHfni+ipwApQQrR1gGhoZM81kKKkB
         dR5NFmEKhcyt10wuxO/mvFdyZ5iCPTefMAi2okU+pClPhc66+9RVfUJHrOKC4ckbHkFp
         w8Qg==
X-Gm-Message-State: AOAM533aCq+1WYo++gXWOa2Q2DSMob13nTxB68wd8QSQQol60AWDE3xd
        M0OvHoBI9jv7LMcmXAnSrSk=
X-Google-Smtp-Source: ABdhPJx2bYDE2pgnjHSH85hlgL5f0D15mPVm/ZsY4CBCI016xG7533+cCZzPWq80CS2zwE9q6NeWxA==
X-Received: by 2002:adf:ea82:: with SMTP id s2mr16753023wrm.397.1620939826504;
        Thu, 13 May 2021 14:03:46 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id p1sm4147974wrs.50.2021.05.13.14.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 14:03:46 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_link_timeout_fn
To:     syzbot <syzbot+5a864149dd970b546223@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000011220705c229aa98@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8915be59-5ac9-232d-878e-b09c141059d5@gmail.com>
Date:   Thu, 13 May 2021 22:03:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <00000000000011220705c229aa98@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/12/21 11:38 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in io_req_complete_failed

Let's get more info on it

#syz test: https://github.com/isilence/linux.git syz_test6

> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 req_ref_put_and_test fs/io_uring.c:1505 [inline]
> WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 io_put_req fs/io_uring.c:2171 [inline]
> WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 io_req_complete_failed+0x2ee/0x5a0 fs/io_uring.c:1649
> Modules linked in:
> CPU: 1 PID: 10153 Comm: syz-executor.3 Not tainted 5.12.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:req_ref_put_and_test fs/io_uring.c:1505 [inline]
> RIP: 0010:io_put_req fs/io_uring.c:2171 [inline]
> RIP: 0010:io_req_complete_failed+0x2ee/0x5a0 fs/io_uring.c:1649
> Code: 58 bd da ff be 01 00 00 00 4c 89 f7 e8 5b 78 fe ff e9 09 fe ff ff e8 f1 32 97 ff 4c 89 ef e8 a9 fd 65 ff eb cb e8 e2 32 97 ff <0f> 0b e9 c8 fd ff ff 4c 89 f7 e8 23 0b db ff e9 3c fd ff ff 4c 89
> RSP: 0018:ffffc9000afbfd10 EFLAGS: 00010293
> 
> RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
> RDX: ffff88801f5e0000 RSI: ffffffff81dd35ae RDI: 0000000000000003
> RBP: ffff888043314dc0 R08: 000000000000007f R09: ffff888043314e1f
> R10: ffffffff81dd3374 R11: 000000000000000f R12: ffffffffffffffea
> R13: ffff888043314e1c R14: ffff888043314e18 R15: 00000000ffffffea
> FS:  00007fac1b577700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f04f797dd40 CR3: 0000000012dfb000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __io_queue_sqe+0x61e/0x10f0 fs/io_uring.c:6440
>  __io_req_task_submit+0x103/0x120 fs/io_uring.c:2037
>  __tctx_task_work fs/io_uring.c:1908 [inline]
>  tctx_task_work+0x24e/0x550 fs/io_uring.c:1922
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:161
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  handle_signal_work kernel/entry/common.c:145 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x24a/0x280 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
>  do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665f9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> 
> 
> Tested on:
> 
> commit:         a298232e io_uring: fix link timeout refs
> git tree:       git://git.kernel.dk/linux-block.git io_uring-5.13
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f82965d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ae2e6c63d6410fd3
> dashboard link: https://syzkaller.appspot.com/bug?extid=5a864149dd970b546223
> compiler:       
> 

-- 
Pavel Begunkov
