Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774D536413E
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 14:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhDSMIB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 08:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbhDSMIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 08:08:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA9BC06174A;
        Mon, 19 Apr 2021 05:07:30 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id y204so16651687wmg.2;
        Mon, 19 Apr 2021 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xPeO3RkDuZrVjDiDI8h5kXkPCEdRAXX+jvd/8Nrz93o=;
        b=GXIT9p6+BD6apV7osZ3YxuXINaoTzqCqsF4lgc8KfwKFZJkAzgTwOK/m8eYpeCQiQD
         p4ZWJX6QSSyjw3+T8+7w3uuk8g/yRcdD6FtGZvqswWQgB541A4Zkv+aJfJOzK46ORiNp
         SybZOpzZgVEi3brdIPV6Z/pakkoWVYK4PbgovBFjIyHrJV7Vup4bK00w5A9gkOrTq4qA
         rWChtS+ZLY8rCOQYPrG75M4S95lduf807mepBQKpbtw9gMl9wYsgFpoXK6eCzUudPKJi
         nZQhu3kN3gE67ld6MN8cGedh8CEkA4WUYwUDwT9yMBxvlLz9ZNlB7PPxkPDoJgR4PXap
         3vOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xPeO3RkDuZrVjDiDI8h5kXkPCEdRAXX+jvd/8Nrz93o=;
        b=W/VrW8pbFM1Nj27hE112cJx03C9UNHBIPPB12R/+NUeNms5rQ62Dh7B/Rxq/YHM4sA
         7tTN2jUHQuPz1N1DpFPu/MsJO3wykSGK2hgW3JJZCekVZSY3tYcg/RxmyJgrx40ZGnDk
         3pIcG5yekTU3csch0whVub0pcZGhKYuJOTUQWZ5aq6VHmulYNF5jzXyzGKWJTIfzJ9GH
         FhNElJBGzgXmC/TiBZViR6w+RkYU9KNb/5IstMf4RhFkEHUr7OskEphNF2EtaHq14FTG
         y1xYGaYzZv/NPhVrSh537gKNsq3h2XQa2q876E5ciHUoyqlqtWv9a7JcYvULdX2l+RMW
         KjzA==
X-Gm-Message-State: AOAM531AyTYxJHut4SmUHpyR8oud6TLWFyEpkPqbwC6MgCh0JPuFoUhO
        aNHVbzdYvABo3YLAFVv0KFM=
X-Google-Smtp-Source: ABdhPJw94Rhgmzhj1n5ZHbVOUKKYAnF3N7+CXqP3q0wkaNzYCkLYY+nfBDKA1iwhfTaJhte62VNp2g==
X-Received: by 2002:a7b:c8cf:: with SMTP id f15mr21399621wml.135.1618834048961;
        Mon, 19 Apr 2021 05:07:28 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.103])
        by smtp.gmail.com with ESMTPSA id u11sm14240605wrt.72.2021.04.19.05.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 05:07:28 -0700 (PDT)
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
To:     syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        syzkaller-bugs@googlegroups.com
References: <000000000000ee3bbf05c0443da6@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c12b0100-50be-907b-503d-3aa00223194c@gmail.com>
Date:   Mon, 19 Apr 2021 13:07:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000ee3bbf05c0443da6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/21 8:30 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    c98ff1d0 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=163d7229d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
> dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 169 at lib/percpu-refcount.c:113 __percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
> Modules linked in:
> CPU: 1 PID: 169 Comm: kworker/u4:3 Not tainted 5.12.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:__percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
> Code: fd 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 61 49 83 7c 24 10 00 74 07 e8 a8 4a ab fd <0f> 0b e8 a1 4a ab fd 48 89 ef e8 69 f0 d9 fd 48 89 da 48 b8 00 00
> RSP: 0018:ffffc90001077b48 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802d5ca000 RCX: 0000000000000000
> RDX: ffff88801217a1c0 RSI: ffffffff83c7db28 RDI: ffff88801d58f010
> RBP: 0000607f4607bcb8 R08: 0000000000000000 R09: ffffffff8fa9f977
> R10: ffffffff83c7dac8 R11: 0000000000000009 R12: ffff88801d58f000
> R13: 000000010002865e R14: ffff88801d58f000 R15: ffff88802d5ca8b0
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000044 CR3: 0000000015c02000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  percpu_ref_exit+0x3b/0x140 lib/percpu-refcount.c:134
>  io_ring_ctx_free fs/io_uring.c:8483 [inline]
>  io_ring_exit_work+0xa64/0x12d0 fs/io_uring.c:8620
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 

#syz test: git://git.kernel.dk/linux-block for-5.13/io_uring

-- 
Pavel Begunkov
