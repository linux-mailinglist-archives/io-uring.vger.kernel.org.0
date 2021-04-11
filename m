Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921A435B25C
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhDKIPD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Apr 2021 04:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhDKIPC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Apr 2021 04:15:02 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D06FC061574;
        Sun, 11 Apr 2021 01:14:46 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 12so5030683wmf.5;
        Sun, 11 Apr 2021 01:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dwa+Nc8DOzjC83V/gUWoFJ20pXbirSmA0qX1YPH9/hE=;
        b=lGWTPORlrxFTX++19KzlNxAoH+HZXci83pa2ODGKyQSTx2AKlo2N198RKo6SA7GHmK
         JdpOLd1wiNVF/bE6OVMzDOJ/tzPdRP35Zs+K1G++73CVClA4jEwhehjeYZdMOKF6LKy7
         Mwr/P52VlseXV8Lvjc0Cfkx6x5iSYfLZ7TkPX34ALjIgFUysugcCH1xPFLQ7vS9pj0+A
         0RHrekGFDppyLqSuH4Wc89aoshxDThfuOmvALpZDKJUWKugUf3Gb/nmH6M1OwE2FM873
         MOgnCgrSBJntvZ0aKpYTlMZT6UJQdMZgqy8t+AMg27lFg2peLhwDkCn0iFgsXXsFvo7w
         gtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Dwa+Nc8DOzjC83V/gUWoFJ20pXbirSmA0qX1YPH9/hE=;
        b=D4zFjGJg6Ct5Zhrkjg+PaFojqDsXonMF0YC69k9eJ/3vH92nTr38KwdZqV0k0ARwHY
         tIJlEh0ImEEFH2E0/vn51xUnS3niLXLu6Phtnnt5e0itW11kUphjgzsh/Q58rcdqrA0M
         DwEAKAt+CFQNkdY4lo72dlQq8oHqvJJ1fiYm5rgkmA/LhOScG9wweYC0sk6qWcBUiuNu
         bl7tsz0lz2qccNoiNuorbATZ+MtP+TWOc1Jn3p1sGym4CR9Mx9ESEhsmzOJM8xjI1TG2
         optJDXMSBiwwzadFiQBYG8kWhd7UebisQXQydEbHZwv1TnQQZ1wCipUZjMEdEeA/f5DN
         /i6w==
X-Gm-Message-State: AOAM533yYNtOLPj1eXnC3eq9oMInCbpDN55l9BTJyO5pXN6DTJOn+7we
        jDmN6jbdZtKJ80IWuBI/NVMNY2NWVKm2Zg==
X-Google-Smtp-Source: ABdhPJxK694muNHSMM4wLnVQR7bnu5vAPZWs6IgjMsuznow6gOwNV4V8gkK7srR8un2acGl+49p89g==
X-Received: by 2002:a7b:c4cf:: with SMTP id g15mr21942951wmk.185.1618128884669;
        Sun, 11 Apr 2021 01:14:44 -0700 (PDT)
Received: from [192.168.8.169] ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id c8sm13399894wrd.55.2021.04.11.01.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 01:14:44 -0700 (PDT)
To:     Hao Sun <sunhao.th@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsb4Ad60ZTyaaObBj2DKxSv1avmTSo3WUrnvH+amuDuhrA@mail.gmail.com>
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
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 io_uring_cancel_task_requests
Message-ID: <461a8447-bc48-145f-c3dc-4b049621afcc@gmail.com>
Date:   Sun, 11 Apr 2021 09:10:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsb4Ad60ZTyaaObBj2DKxSv1avmTSo3WUrnvH+amuDuhrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/04/2021 04:08, Hao Sun wrote:
> Hi
> 
> When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
> the Linux kernel, I found a null-ptr-deref bug in
> io_uring_cancel_task_requests under fault injection condition, but I'm
> not sure about this.
> Sorry, I do not have a reproducing program for this bug.
> I hope that the stack trace information in the crash log can help you
> locate the problem.

Thanks Hao. io_cqring_wait() fails should not anyhow affect
cancellation, so the log doesn't make sense from first sight,
something strange is going on.

> 
> Here is the details:
> commit:   3b9cdafb5358eb9f3790de2f728f765fef100731
> version:   linux 5.11
> git tree:    upstream
> Full log can be found in the attachment.
> cqwait()
> Fault injection log:
> FAULT_INJECTION: forcing a failure.
> name fail_usercopy, interval 1, probability 0, space 0, times 0
> CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x137/0x194 lib/dump_stack.c:120
>  fail_dump lib/fault-inject.c:52 [inline]
>  should_fail+0x23e/0x250 lib/fault-inject.c:146
>  should_fail_usercopy+0x16/0x20 lib/fault-inject-usercopy.c:37
>  _copy_from_user+0x1c/0xd0 lib/usercopy.c:14
>  copy_from_user include/linux/uaccess.h:192 [inline]
>  set_user_sigmask+0x4b/0x110 kernel/signal.c:3015
>  io_cqring_wait+0x2e3/0x8b0 fs/io_uring.c:7250
>  __do_sys_io_uring_enter fs/io_uring.c:9480 [inline]
>  __se_sys_io_uring_enter+0x8fc/0xb70 fs/io_uring.c:9397
>  __x64_sys_io_uring_enter+0x74/0x80 fs/io_uring.c:9397
>  do_syscall_64+0x39/0x80 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46a379
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f046fa19c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 000000000078c080 RCX: 000000000046a379
> RDX: 00000000000066ab RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007f046fa19c90 R08: 0000000020000040 R09: 0000000000000008
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
> 
> Crash log:
> BUG: kernel NULL pointer dereference, address: 0000000000000040
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 49954067 P4D 49954067 PUD 45f92067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
> Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
> 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
> 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
> RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
> RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
> RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
> RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
> R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
> R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
> FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  __io_uring_files_cancel+0x9b/0x200 fs/io_uring.c:9140
>  io_uring_files_cancel include/linux/io_uring.h:65 [inline]
>  do_exit+0x1a8/0x16d0 kernel/exit.c:780
>  do_group_exit+0xc5/0x180 kernel/exit.c:922
>  get_signal+0xd90/0x1470 kernel/signal.c:2773
>  arch_do_signal_or_restart+0x2a/0x260 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x109/0x1a0 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
>  do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46a379
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f046fa19cd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 000000000078c080 RCX: 000000000046a379
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078c088
> RBP: 000000000078c088 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c08c
> R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
> Modules linked in:
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CR2: 0000000000000040
> ---[ end trace 613db1a25ecf6443 ]---
> RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
> Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
> 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
> 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
> RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
> RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
> RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
> RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
> R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
> R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
> FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> 

-- 
Pavel Begunkov
