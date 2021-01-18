Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679BB2FA26D
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 15:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391541AbhARODI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 09:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391506AbhARMal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 07:30:41 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0340C061573;
        Mon, 18 Jan 2021 04:30:00 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id h17so13243685wmq.1;
        Mon, 18 Jan 2021 04:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FzGV10dI6ZpCA2nzpn5G+6o7uEH+RKuRyEulvqsPDU4=;
        b=hy/V2TiCpAJ7z7YjhEPWYKcx/gU9FQkGAA8OtyaIlQIJIvYF7CMtzIy9K5mo6IhR/D
         b+myXUK7kh6b3H9Va+O286n3sgbzYF8qak27rCm61GAuFMOpFFF9dmq/T2xx5rOspCCe
         6ELJuoMA9gmVNuop8B1Zxk9/ZclehfSRer93OXEWdb9egwxBhouvOhQwOqbVlBETXu0c
         WTu5jcvBqo+140REppGtOL1dkP4qLFZFXNp2oG4ysG47XPxuCVjY4AcyDdOxHAoSJ5oh
         A6BLjuzpzwTpn7L5EVqyyZHgrQNeAuX8h7UEHYIBzLabiAmrga+WZGDXmAxbGmWcX3Wq
         jtjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FzGV10dI6ZpCA2nzpn5G+6o7uEH+RKuRyEulvqsPDU4=;
        b=SuCH812THrSQ+fSFCbCquN7VJVTBlBANF62Tq+9DK13fsjZpGQDEOUSzmo4SITdDu1
         axQYkIgD38hg7JzqNtq3S1a7L8ob2/ZFVmLexTAXX8D2nrAR7kiZIeKPUNzJl6Hq8Hgz
         HxFkSbc7L2grIeHU317LLl+kFXyQutX+FfhpOHxZ4D0LZRT8vD5mbcCHO55u1unLibdT
         zu4sjUENuyqcdCgXgGICwJQzP3YIr1zSx7AqCgxxajdPHXBN9Zjn6UIxowlmLLIlc/4o
         1DN7yzMPV2KzEr1ilrLO6cH8mRbo5R9DmJITxNqVd7R5i8LU8NF3vYe0PD7a2ZjT0A6N
         UjrA==
X-Gm-Message-State: AOAM530JjMW0x24/gnTTmv/3pzWLLD2L3sD/KQzguQfiT4cThffuweAL
        wSv/SPwSrOCjG8rg3QCANQ8=
X-Google-Smtp-Source: ABdhPJwxQxNCtvGlqGznn2AdXtcobkjDpAbRbMwujkdc/FtV9D6ONVzOIgDt4qsSel8AXEevNXIGwA==
X-Received: by 2002:a1c:808d:: with SMTP id b135mr20212219wmd.157.1610972999713;
        Mon, 18 Jan 2021 04:29:59 -0800 (PST)
Received: from [192.168.8.130] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id a6sm9979264wmj.27.2021.01.18.04.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 04:29:59 -0800 (PST)
Subject: Re: WARNING in io_disable_sqo_submit
To:     syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000219cec05b9252334@google.com>
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
Message-ID: <1e51be0f-98a1-6dd2-63da-02e92e79a4ef@gmail.com>
Date:   Mon, 18 Jan 2021 12:26:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000219cec05b9252334@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/01/2021 04:27, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    a1339d63 Merge tag 'powerpc-5.11-4' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17532a58d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f207c7500000
> 

#syz test: git://git.kernel.dk/linux-block io_uring-5.11

> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 9113 at fs/io_uring.c:8917 io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
> Modules linked in:
> CPU: 1 PID: 9113 Comm: syz-executor.0 Not tainted 5.11.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
> Code: e0 07 83 c0 03 38 d0 7c 04 84 d2 75 2e 83 8b 14 01 00 00 01 4c 89 e7 e8 31 0a 24 07 5b 5d 41 5c e9 98 e1 9a ff e8 93 e1 9a ff <0f> 0b e9 00 ff ff ff e8 a7 a1 dd ff e9 37 ff ff ff e8 6d a1 dd ff
> RSP: 0018:ffffc9000311fe98 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888024b43000 RCX: 0000000000000000
> RDX: ffff888147071bc0 RSI: ffffffff81d7e82d RDI: ffff888024b430d0
> RBP: ffff8880115d1900 R08: 0000000000000000 R09: 0000000014555c01
> R10: ffffffff81d7eae5 R11: 0000000000000001 R12: ffff888024b43000
> R13: ffff888014555c01 R14: ffff888024b43040 R15: ffff888024b430d0
> FS:  00007f85abf55700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd3adeb5000 CR3: 00000000115d2000 CR4: 0000000000350ef0
> Call Trace:
>  io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9134
>  filp_close+0xb4/0x170 fs/open.c:1280
>  close_fd+0x5c/0x80 fs/file.c:626
>  __do_sys_close fs/open.c:1299 [inline]
>  __se_sys_close fs/open.c:1297 [inline]
>  __x64_sys_close+0x2f/0xa0 fs/open.c:1297
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f85abf54c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000045e219
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 000000000119bfb0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
> R13: 00007ffe5217973f R14: 00007f85abf559c0 R15: 000000000119bf8c
> 

-- 
Pavel Begunkov
