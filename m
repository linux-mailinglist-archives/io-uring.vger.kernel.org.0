Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD7382AD0
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 13:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhEQLW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 07:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbhEQLW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 07:22:57 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11946C061573;
        Mon, 17 May 2021 04:21:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k5-20020a05600c4785b0290174b7945d7eso2945815wmo.2;
        Mon, 17 May 2021 04:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bFTFQv745ERLPtvmkjRJFOSlUXURZ42YEvz7ciOZXyQ=;
        b=aJu2rKRhT3BbOt5WqR9wlf9OdaLurI2snVvX/fshY/DEZRzu2RnxhRvVHoqUJ1cU0e
         Tyu28TGZoaeqCesXy514h8gxZdScim5XgpiKa6eoE+B/EuMm3yhEQZN8APmePLSUNknP
         POL3LxwbL8vRg1rLWQ9yRhfFytq/GNxS9KYHe4DYjyXlR3kMYZOXJJP4Q8AVkpLtVb0j
         yHJUquYRQiRku8qvz2d7TXEWcsP/e3nt3ZgOLk8sB7Ldb6GdFrjH09J3k7i9Y2ZNWWev
         kg/wtYFR/Pn0bh0nzqnY4CRD66DGwC/YWGv+94PO9PqRwknLxr+A4DOdq8pPCsn005fl
         vZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bFTFQv745ERLPtvmkjRJFOSlUXURZ42YEvz7ciOZXyQ=;
        b=cPiQy+ll/PQvvML6vXEQl/bdkLo0dh3SZGYQSy/IKthU3MFAzpMLDejHQtswxQ91rF
         2c/ikkY5o2yYh0XybArS0DMJbKwQYmn7hD5Zsf5WPdzupnROdA+SJ17YkaqLtzGt4A6a
         Ud84MqzrR5BQ4PE9DggV2DHMlC6ru6pGALmU709dzXmOcQPNTuDI2FCZRefIjjqiA1ga
         It5KorzgAb5S/t1mqIOpZ7GDdC+HDAf1Ga3xiIoSd92ueNTzOOZq6vUE4sO9RTzSEo8V
         x55cyXDincn8OowCAevWPAil48Uxtqe0nadC8IXKoIvXPawm3hXNqctI9qswE2cfjG4p
         6ZKA==
X-Gm-Message-State: AOAM530X1V6vH6LlteXw1Q2qEM3Wslpum2xnaCSuGr4/Z2CUWK0o6Hb6
        MlpjJc5r7NMPaa9AWwXoCEU=
X-Google-Smtp-Source: ABdhPJxJXeFNpoiUHNVPpWQSV2lFdh0m+8coAbbzYcc2is3lDVWj2ksoiOTTjJnz1JgzYLES3R4SHw==
X-Received: by 2002:a7b:cb45:: with SMTP id v5mr65104488wmj.48.1621250499861;
        Mon, 17 May 2021 04:21:39 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c093:600::2:e1e0])
        by smtp.gmail.com with ESMTPSA id n7sm16267130wri.14.2021.05.17.04.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 04:21:39 -0700 (PDT)
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in corrupted
 (3)
To:     syzbot <syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006acb3105c28321f7@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a6a87693-f994-6e56-78a2-6e39e1060484@gmail.com>
Date:   Mon, 17 May 2021 12:21:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0000000000006acb3105c28321f7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/21 10:22 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11aa7a65d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=807beec6b4d66bf1
> dashboard link: https://syzkaller.appspot.com/bug?extid=a84b8783366ecb1c65d0
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a031b3d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fc54fdd00000
> 
> The issue was bisected to:

#syz test: https://github.com/isilence/linux.git syz_test10

> 
> commit ea6a693d862d4f0edd748a1fa3fc6faf2c39afb2
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Apr 15 15:47:13 2021 +0000
> 
>     io_uring: disable multishot poll for double poll add cases
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=104b5795d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=124b5795d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=144b5795d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com
> Fixes: ea6a693d862d ("io_uring: disable multishot poll for double poll add cases")
> 
> BUG: unable to handle page fault for address: ffffffffc1defce0
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD bc8f067 P4D bc8f067 PUD bc91067 PMD 0 
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8479 Comm: iou-wrk-8440 Not tainted 5.13.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0xffffffffc1defce0
> Code: Unable to access opcode bytes at RIP 0xffffffffc1defcb6.
> RSP: 0018:ffffc9000161f8f8 EFLAGS: 00010246
> RAX: ffffffffc1defce0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880187eb8c0
> RBP: ffff8880187eb8c0 R08: 0000000000000000 R09: 0000000000002000
> R10: ffffffff81df1723 R11: 0000000000004000 R12: 0000000000000000
> R13: ffff8880187eb918 R14: ffff8880187eb900 R15: ffffffffc1defce0
> FS:  0000000001212300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffc1defcb6 CR3: 00000000139d9000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> Modules linked in:
> CR2: ffffffffc1defce0
> ---[ end trace a41da77ef833bc79 ]---
> RIP: 0010:0xffffffffc1defce0
> Code: Unable to access opcode bytes at RIP 0xffffffffc1defcb6.
> RSP: 0018:ffffc9000161f8f8 EFLAGS: 00010246
> RAX: ffffffffc1defce0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880187eb8c0
> RBP: ffff8880187eb8c0 R08: 0000000000000000 R09: 0000000000002000
> R10: ffffffff81df1723 R11: 0000000000004000 R12: 0000000000000000
> R13: ffff8880187eb918 R14: ffff8880187eb900 R15: ffffffffc1defce0
> FS:  0000000001212300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffc1defcb6 CR3: 00000000139d9000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
