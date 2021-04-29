Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04B36E9C9
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 13:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhD2Lu0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 07:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhD2Lu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 07:50:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E71C06138B;
        Thu, 29 Apr 2021 04:49:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a4so66625113wrr.2;
        Thu, 29 Apr 2021 04:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z6/XNYCpDCxd2T01X3C5oYnHIXvWBFT6Gme1aHiNx7o=;
        b=DSzseGNaAkSIp4f/Xporo0k+PTw8ejBlx3y0VkFdMmGU427Y5gamsLO6UKZovS2R2Y
         J7XXqDzhzlI5k4LKsr9E8/2QoG/FEz/mMY192BhY/1P0a9puQYuAcRPqhSTTzJr0lQNX
         ZYpHqqc6EYwKWDkyyVAenNgGFbQLMwqdVR6VOQ83OFN/pSgmyt0/6qcTG10brIWpNX2A
         93/ZixMx/P/DAWEdAeQD6kPqcysSrF/gL1QI9IZQ8dsPyYlO3lBAXWsejwzNwIAihncl
         Cd3KNUzkgorksTYG/bBlAB3Cb4ojRhSAerifLxVc3AP7jJWrDS5omT0O9EoPbyOpVMn4
         ySJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z6/XNYCpDCxd2T01X3C5oYnHIXvWBFT6Gme1aHiNx7o=;
        b=cmnqSIniYmqxdGtJnRaIyDpa4oXZ/fIs3EBDnyXDOpydIhEmwMucKstXjb8ejMw1FD
         Bj8om4lglFIzHl5JSZokIPprkS8Jry8bVlGgSoqDMEpk/qljCKw950RmGcBPCIW4uQYA
         N7qIgKxn+KqivnOTaNeUqz4kmPRytVgdVQw5hiUc/lyCJJEWEu5AUxc0psIGWxMlGTbL
         CQYHm9G9FcQSkCSPZUkUoSFQaZK2zX+O/v7y+/1R9l5jTJf5epu1Niao0JVsnQzx5M3v
         8kkHZPWxVbc9JFjambp5wInuGSA/JOw4izLp2zDBjRBpE+OGutnNbRmRCv8gN3f/4KAO
         U9Ng==
X-Gm-Message-State: AOAM533hKgL3yMD3HKlxYAYu9zLYacVUeM9/nQx1esPrdlQr8j3dMwX3
        cZIJMKY4kCvayWpoQp9ZRn0=
X-Google-Smtp-Source: ABdhPJwqSykzR/8x8k3TkKv0LDYDxycrpAycLoCGADKMQlblVpHsXMaTeCknwte65fCRj8I6aGPBhQ==
X-Received: by 2002:adf:ffcc:: with SMTP id x12mr26438614wrs.162.1619696977158;
        Thu, 29 Apr 2021 04:49:37 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id l21sm11667546wme.10.2021.04.29.04.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 04:49:36 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_rsrc_node_switch
To:     syzbot <syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000008dfbaf05c11a023c@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <311be205-e56a-cc06-dfed-df9aef527268@gmail.com>
Date:   Thu, 29 Apr 2021 12:49:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000008dfbaf05c11a023c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 11:32 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12c045d5d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=65c207250bba4efe
> dashboard link: https://syzkaller.appspot.com/bug?extid=a4715dd4b7c866136f79
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11893de1d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161c19d5d00000

#syz test: https://github.com/isilence/linux.git syz_test4

> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com
> 
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000440a49
> RDX: 0000000000000010 RSI: 00000000200002c0 RDI: 0000000000000182
> RBP: 00007fff0b88f050 R08: 0000000000000001 R09: 00007fff0b88f038
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00007fff0b88f03a R14: 00000000004b74b0 R15: 000000000000000c
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8397 at fs/io_uring.c:7081 io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
> Modules linked in:
> CPU: 0 PID: 8397 Comm: syz-executor469 Not tainted 5.12.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
> Code: ff 4d 85 e4 74 a4 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 fc 00 99 ff e8 f7 00 99 ff 0f 0b e9 ee fd ff ff e8 eb 00 99 ff <0f> 0b e9 9d fd ff ff 4c 89 f7 e8 7c e0 dc ff eb 8b 4c 89 ef e8 72
> RSP: 0018:ffffc9000164fd90 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff8880196fe000 RCX: 0000000000000000
> RDX: ffff88801c7a1c40 RSI: ffffffff81db5d25 RDI: ffff8880196fe000
> RBP: 0000000000000000 R08: 0000000000000dc0 R09: ffffffff8c0b37d3
> R10: fffffbfff18166fa R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8880196fe808 R15: 0000000000000000
> FS:  0000000001485300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200002c4 CR3: 00000000160b2000 CR4: 0000000000350ef0
> Call Trace:
>  io_uring_create fs/io_uring.c:9611 [inline]
>  io_uring_setup+0xf75/0x2a80 fs/io_uring.c:9689
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x440a49
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff0b88f008 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000440a49
> RDX: 0000000000000010 RSI: 00000000200002c0 RDI: 0000000000000182
> RBP: 00007fff0b88f050 R08: 0000000000000001 R09: 00007fff0b88f038
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00007fff0b88f03a R14: 00000000004b74b0 R15: 000000000000000c
> 

-- 
Pavel Begunkov
