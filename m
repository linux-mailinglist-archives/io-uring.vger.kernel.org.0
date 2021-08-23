Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E829C3F49EA
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 13:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhHWLhg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 07:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236623AbhHWLhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 07:37:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EAEC0611C2;
        Mon, 23 Aug 2021 04:36:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g135so1025027wme.5;
        Mon, 23 Aug 2021 04:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=q/+BtTfaussj3pnFQMFQKjGG14QLE4MIEje0Y1Rob/g=;
        b=ZckAnTPI8lekky2wkcRR7yKflDP+H3kUkiq0EYMOVtqdL1Rg5dg+Shymqd6f6/2Ntn
         2xQYnFPFqwovuYSjPOUPLZLVcx2eELxItovPtcmvYmaCTMazO1TEQLGQReDq6oRTlk90
         eS3LfOw35mtcXi7iLhc+fstqGwCkhAFefC1DdXsJFt64ZdikkXAP88kPCE7gnyr72qgG
         lLDY4bzeVl+tJ4/ki2fDCZU6rc9llqiXVecpDL3jeLnZcrjtTeDN5PTQhWVbWBr1iLLh
         BUjxY7bJoalTReTMnM9sJDSLHM/2yqiN8uZTEBMP4PHmnFH7y9kMl5iPdpgidqpuJCYb
         yH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q/+BtTfaussj3pnFQMFQKjGG14QLE4MIEje0Y1Rob/g=;
        b=Q1mofXDxU2v7fYRCgmFowk+8kbov/z+giOVwDmkfQX/w7BqTQAQKylsjrwFHvBYWzz
         rjLa/IYAYymdAbnSl2YppwYxTVS5N/bQmXEAma3C+Dfge0dbPIFDugotJJ3c6XQF6Dxs
         roVKUy5MHUKxCjP/73dqPnu7ZKjBwfHWmHOZlGhESt/GdkGKQf3ZdGO83/fQCRRfTBPX
         jhY18ARwvfaR9wP7JK/e8BC/c2f8HIDx44B2bvhhAwbCibk/g0llx7cBhjef25r4h//L
         cQuNUpR6YrWCvVz6zPwhn4MCebjtr4YpvzquN9l7e4rMAYlJgVnHBSBFi5+193OqWUJ3
         kHVQ==
X-Gm-Message-State: AOAM531z911VRoRfs5DoNV2mJaLfMpfyycuqIvd7+JjodXTE42iMpE3t
        //SsUCtdhcPLRo5ehSjlrYscJe/dkwo=
X-Google-Smtp-Source: ABdhPJyE6D5Cqd3vP0lUzvOavUpGm6KuzXuUckHGAnKz9P7lwxzXRaCWDLwG/jS2+1AZ8U+UogKpmQ==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr16037427wmh.32.1629718597644;
        Mon, 23 Aug 2021 04:36:37 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id h6sm14608363wmq.5.2021.08.23.04.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 04:36:37 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_try_cancel_userdata
To:     syzbot <syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000dd79fc05ca367b9d@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c6ff4faf-bb08-d61a-8054-16b9010545eb@gmail.com>
Date:   Mon, 23 Aug 2021 12:36:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000dd79fc05ca367b9d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 10:17 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    86ed57fd8c93 Add linux-next specific files for 20210820
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1565bd55300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f64eccb415bd479d
> dashboard link: https://syzkaller.appspot.com/bug?extid=b0c9d1588ae92866515f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com

false positive, will delete the warning with explanation

p.s. easily reproducible, we'll add a test covering cancel from io-wq 

> 
> WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
> Modules linked in:
> CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
> Code: 07 e8 e5 9d 95 ff 48 8b 7c 24 08 e8 ab 02 58 07 e9 6f fe ff ff e8 d1 9d 95 ff 41 bf 8e ff ff ff e9 5f fe ff ff e8 c1 9d 95 ff <0f> 0b 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 80 3c 02
> RSP: 0018:ffffc900055f7a88 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888181aa83c0 RCX: 0000000000000000
> RDX: ffff88803fb88000 RSI: ffffffff81e0dacf RDI: ffff888181aa8410
> RBP: ffff88803fb88000 R08: ffffffff899ad660 R09: ffffffff81e23c44
> R10: 0000000000000027 R11: 000000000000000e R12: 1ffff92000abef53
> R13: 0000000000000000 R14: ffff8880b34d0000 R15: ffff888181aa8420
> FS:  00007f7a08d50700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2c72e000 CR3: 0000000168b9b000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  io_async_cancel fs/io_uring.c:6014 [inline]
>  io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
>  io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
>  io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
>  io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
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
