Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189EA307C53
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhA1R0D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhA1RXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:23:19 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF58C061574;
        Thu, 28 Jan 2021 09:22:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id z6so6159544wrq.10;
        Thu, 28 Jan 2021 09:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cmZOIvIi8bofhn0TZQeaQ2LsskOECrmX+BsvEebrKcI=;
        b=Nf7bcA3ngq1y2KUJN9/hgr09WEAtN29oFIMqcLC1ygSALt4q1ov1XRoqzzrJ5Bg37n
         WRMFQvHMqFtaAwUEbIJCKGYJkyQcLqVe7owC8R0+IdMHF1OL4kiIWMTUXxkGI/s7Jvjd
         aZb2fZtgMNQ4WqRF86E9/rJBlYl05xMp7dJSQevoxQwfz6iznLT0nIvcNEaEh7J+6TBG
         E0TDpPr2JXDaAh4GbZsFDDw8Pfbm2xpqXh2F0asGQByZJKJGt5kvtVM23d6YV/NWpqWH
         PFCwoybK4cnpiEgt+Dh5xk5VoeupJE/Mff9WyAOhJ/rRwYRquguw3dchJrB32TaKJjPz
         oVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cmZOIvIi8bofhn0TZQeaQ2LsskOECrmX+BsvEebrKcI=;
        b=SGcGxRsNNhZGvit/SPM2hmPL3ut2FQSNOaVP7svyz3glpisEnNYts3kdpymU+8BAeg
         2e1tDMbcvcvW+5kh+JjqxwSjutmqBx9fhn97XpDlL8v5aK62CM03MVXsiA+qRuZjd7ks
         UKnW2CjyCIxL3LJlDFIOyDI8U9IwPvtwX953klrugqEMCGjP8QULmU3R2Dk2nL2z29r4
         psylK7r2B2d9hN59DTIZkHJOef97/A7wWFXi8PjE8xEwxOuyNwGIdu1rrkwH6/A9kHUH
         G+8qKzmPhHFzHKh/qr4x9ooz4AM8kOusSxhV/pSEI5zrYFcJkULkWwtGi+gyutJGRgSh
         tOOg==
X-Gm-Message-State: AOAM531/D7ItV+infoAiyJt2BwDs4n4RW0ftR06kNvxpK0jiI4jRkzyy
        050wcPPrIFhhZpVHV+KkrRJLZdcyw9o=
X-Google-Smtp-Source: ABdhPJwoF0PdXu8LU66GzCiRXpeQcStbn/xoQb78LtHrMN992IjIGamK1XEi8Cy99Z4kPYS6meDczA==
X-Received: by 2002:a5d:4046:: with SMTP id w6mr39118wrp.369.1611854558235;
        Thu, 28 Jan 2021 09:22:38 -0800 (PST)
Received: from [192.168.8.160] ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id o13sm8264074wrh.88.2021.01.28.09.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:22:37 -0800 (PST)
Subject: Re: WARNING in io_uring_cancel_task_requests
To:     syzbot <syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000619ae405b9f8cf6e@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <02244f62-d5a2-d27f-9535-87af192eca73@gmail.com>
Date:   Thu, 28 Jan 2021 17:18:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000619ae405b9f8cf6e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/01/2021 16:59, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d03154e8 Add linux-next specific files for 20210128
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=159d08a0d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
> dashboard link: https://syzkaller.appspot.com/bug?extid=3e3d9bd0c6ce9efbc3ef
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.

This is not interesting either, we can just kill the warning, there
is a better one queued for 5.12.

I'll send patches for both reports later.

> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 21359 at fs/io_uring.c:9042 io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
> Modules linked in:
> CPU: 0 PID: 21359 Comm: syz-executor.0 Not tainted 5.11.0-rc5-next-20210128-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
> Code: 00 00 e9 1c fe ff ff 48 8b 7c 24 18 e8 f4 b4 da ff e9 f2 fc ff ff 48 8b 7c 24 18 e8 e5 b4 da ff e9 64 f2 ff ff e8 eb 16 97 ff <0f> 0b e9 ed f2 ff ff e8 df b4 da ff e9 c8 f5 ff ff 4c 89 ef e8 52
> RSP: 0018:ffffc9000c5a7950 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88806e79f000 RCX: 0000000000000000
> RDX: ffff88806c9d5400 RSI: ffffffff81dbfe65 RDI: ffff88806e79f0d0
> RBP: ffff88806e79f0e8 R08: 0000000000000000 R09: ffff88806c9d5407
> R10: ffffffff81dbf0df R11: 0000000000000000 R12: ffff88806e79f000
> R13: ffff88806c9d5400 R14: ffff88801cdbb800 R15: ffff88802a151018
> FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000749138 CR3: 0000000011ffd000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
>  filp_close+0xb4/0x170 fs/open.c:1295
>  close_files fs/file.c:403 [inline]
>  put_files_struct fs/file.c:418 [inline]
>  put_files_struct+0x1cc/0x350 fs/file.c:415
>  exit_files+0x7e/0xa0 fs/file.c:435
>  do_exit+0xc22/0x2ae0 kernel/exit.c:820
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x427/0x20f0 kernel/signal.c:2773
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: Unable to access opcode bytes at RIP 0x45e1ef.
> RSP: 002b:00007f33ed289be8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: 0000000000000004 RBX: 0000000020000200 RCX: 000000000045e219
> RDX: 0000000020ff8000 RSI: 0000000020000200 RDI: 0000000000002d38
> RBP: 000000000119c080 R08: 00000000200002c0 R09: 00000000200002c0
> R10: 0000000020000280 R11: 0000000000000206 R12: 0000000020ff8000
> R13: 0000000020ff1000 R14: 00000000200002c0 R15: 0000000020000280
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
