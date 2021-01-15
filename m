Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6762F8950
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 00:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbhAOXWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 18:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAOXWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 18:22:34 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F313C061757;
        Fri, 15 Jan 2021 15:21:53 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c5so10848394wrp.6;
        Fri, 15 Jan 2021 15:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NtIJzoratsbFsoUpE4igHln5vILl6gskgGYWm4W0Djk=;
        b=h/z/vdBdTuoKtOuqIfPWzKw58X27hkT8Cj/pKZoVtTg+RTz12RodNk7224QAPCxQic
         xNIHihtgVtg1lfUj6J2KNVW3Mu4OmAD3Vcq5OfVmssjNAY13HAKl1EN3lTVi4mSqWCuS
         P17JoWTh0kCF3ThPwPaXSBYTGToFs199UIuMnWKeDfZ4ws6qhG5v4YWbjh4usrI6/IoW
         va07bB5rD3ACpYNGjn4VBjksvN81MBD6PAachBArctx5NOkdWPkLgHVvOmLuXGdIetWD
         cHkdMEUWbki9kxJHI2c45n8WVc7r+4CQxRAd9t/XvRqgbzMqYyXP9ekl7UgS4N6SRrpG
         l5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NtIJzoratsbFsoUpE4igHln5vILl6gskgGYWm4W0Djk=;
        b=jtdZORD0zw6IjFiJIGlu+H2tcpa4RO7WU6oP4qtoNOjnWIYaNQYSCNHjAr3efJAC8O
         7POggYubSmqPTTwNZ6XGqHiFjJee+emRgIBz9qQ3ZcW8bYIdpFJdw+b1owqp/jsXkVpo
         6KfHG3hTp3vvJliyAPPRBvoIZvCBUP1TiRuU2SlIaCZDiFhrE5lDeuJ1zcuUqm/HaMSU
         RmcF9DhQsbKX+NfopWNhR1xCbOu1ggM6TJzwFtoEZvmA1DF+LtexsDgDnpIo/+VK33zM
         SX2TVeoXweDlqaHpaEkfybn2/qIqRqU1/DEjKo0HpgSEGjr/iBVobJ5RWghK5IhackTm
         wLTQ==
X-Gm-Message-State: AOAM533YFWvUuVTJJi1QGm1GYQIagIKmG9oiz2Gu0555WU/4Y+cyhCZd
        CWc4xrjEMid0jWkaYPQmWRg=
X-Google-Smtp-Source: ABdhPJxLA0WH5JVNC344iygyt26zv7uQJukO6nIWvunocOYy9AvP9zJxA7fwQ1PWCTFVMhTv4QhT9g==
X-Received: by 2002:a05:6000:124e:: with SMTP id j14mr15710847wrx.310.1610752912242;
        Fri, 15 Jan 2021 15:21:52 -0800 (PST)
Received: from [192.168.8.125] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id o23sm17765966wro.57.2021.01.15.15.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 15:21:51 -0800 (PST)
Subject: Re: WARNING in io_disable_sqo_submit
To:     syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000f054d005b8f87274@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e8b106ee-6fa7-a309-1cec-e0cb5f12ac67@gmail.com>
Date:   Fri, 15 Jan 2021 23:18:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000f054d005b8f87274@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/01/2021 23:08, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7c53f6b6 Linux 5.11-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a76f70d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 9094 at fs/io_uring.c:8884 io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884

This one is a false positive warn_once, I'll fix it up


> Modules linked in:
> CPU: 1 PID: 9094 Comm: syz-executor.5 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884
> Code: b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83 8b 14 01 00 00 01 48 89 ef 5b 5d e9 ef bc 23 07 e8 5a e5 9a ff <0f> 0b e9 35 ff ff ff e8 3e a1 dd ff eb dc e8 67 a1 dd ff e9 65 ff
> RSP: 0018:ffffc9000188fea0 EFLAGS: 00010212
> RAX: 0000000000000044 RBX: ffff888079dbe000 RCX: ffffc90013b54000
> RDX: 0000000000040000 RSI: ffffffff81d7e466 RDI: ffff888079dbe0d0
> RBP: ffff8880201c0c80 R08: 0000000000000000 R09: 00000000278d0001
> R10: ffffffff81d7e705 R11: 0000000000000001 R12: ffff888079dbe000
> R13: ffff8880278d0001 R14: ffff888079dbe040 R15: ffff888079dbe0d0
> FS:  00007fe461a71700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000080 CR3: 0000000011fd1000 CR4: 0000000000350ee0
> Call Trace:
>  io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9099
>  filp_close+0xb4/0x170 fs/open.c:1280
>  close_fd+0x5c/0x80 fs/file.c:626
>  __do_sys_close fs/open.c:1299 [inline]
>  __se_sys_close fs/open.c:1297 [inline]
>  __x64_sys_close+0x2f/0xa0 fs/open.c:1297
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fe461a70c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000045e219
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
> RBP: 000000000119bfb0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
> R13: 00007ffc626b58ff R14: 00007fe461a719c0 R15: 000000000119bf8c

-- 
Pavel Begunkov
