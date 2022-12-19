Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87EE650BBF
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 13:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiLSMdO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 07:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiLSMco (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 07:32:44 -0500
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45B110076
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 04:32:17 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id m18so21096320eji.5
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 04:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tygFZKRIR1yySbdXKeFgHSm0dpd1kmVCct+2pY9AUng=;
        b=8RYbcIX9YE+4NY+rSPu5V1wb9CRnbG7YbWysPfFWfEQmSWYYKlNr362JrVjcz5mZ6M
         Xni7v7Hth5jWbbCp72WY5TL/H1lo7WUBldngnOAVBtCPABeYoP8x2+BVP0wXyqY8+KqP
         W1PECY33LpPibK2z0T1AWDqiI8nXIff9Akr8ekS/1qXa+DHlwLcriGGfReNoxiLr5Wvf
         zOPP9BfPWwgen1PN5ZyeDvL9mmMSsnHQYXJm/En5CCPeBPbviLWhnyyeaha5EVnuhqCJ
         2im7s2/Qk7BSnT166xkjsFB9EF7JnCiSS/6i/v9zAUdeovsSEkBy6r+kp+hfhhDbupb1
         bEWw==
X-Gm-Message-State: ANoB5pnmobG7rTOk0j10oaKVhxaMV52Wx5SPuiUIDg+/j493dZw65Da9
        e38dOqbD8LVLN8/vYwLuGxw=
X-Google-Smtp-Source: AA0mqf4sLWvdRYckjggm1D1iTGfl7UmXf2ZMD5wFOxvxzaC8cJH6YoQSW4fxcI7wRygJFo81o4m8gg==
X-Received: by 2002:a17:907:f86:b0:7c4:f4b8:f1c6 with SMTP id kb6-20020a1709070f8600b007c4f4b8f1c6mr18181115ejc.4.1671453136174;
        Mon, 19 Dec 2022 04:32:16 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090653d200b007c1651aeeacsm4281988ejo.181.2022.12.19.04.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 04:32:15 -0800 (PST)
Message-ID: <032f142f-8439-b2e2-5108-4f41e66e3b0c@kernel.org>
Date:   Mon, 19 Dec 2022 13:32:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: User-triggerable 6.1 crash [was: io_uring/net: fix cleanup double
 free free_iov init]
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
References: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
 <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
Content-Language: en-US
In-Reply-To: <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19. 12. 22, 11:23, Jiri Slaby wrote:
> On 26. 09. 22, 15:35, Pavel Begunkov wrote:
>> Having ->async_data doesn't mean it's initialised and previously we vere
>> relying on setting F_CLEANUP at the right moment. With zc sendmsg
>> though, we set F_CLEANUP early in prep when we alloc a notif and so we
>> may allocate async_data, fail in copy_msg_hdr() leaving
>> struct io_async_msghdr not initialised correctly but with F_CLEANUP
>> set, which causes a ->free_iov double free and probably other nastiness.
>>
>> Always initialise ->free_iov. Also, now it might point to fast_iov when
>> fails, so avoid freeing it during cleanups.
>>
>> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
>> Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Hi,
> 
> it's rather easy to crash 6.1 with this patch now. Compile 
> liburing-2.2/test/send_recvmsg.c with -m32, run it as an ordinary user 
> and see the below WARNING followed by many BUGs.
> 
> It dies in this kfree() in io_recvmsg():
>          if (mshot_finished) {
>                  io_netmsg_recycle(req, issue_flags);
>                  /* fast path, check for non-NULL to avoid function call */
>                  if (kmsg->free_iov)
>                          kfree(kmsg->free_iov);
>                  req->flags &= ~REQ_F_NEED_CLEANUP;
>          }

I am attaching a KASAN report instead:

BUG: KASAN: invalid-free in __kmem_cache_free (mm/slub.c:3661 
mm/slub.c:3674)
Free of addr ffff8881049ff328 by task send_recvmsg.t/733

CPU: 3 PID: 733 Comm: send_recvmsg.t Not tainted 6.1.0-default #10 
fd86e1993b1e4baedde4c3e698b88971c38217a0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
print_report (mm/kasan/report.c:285 mm/kasan/report.c:395)
kasan_report_invalid_free (mm/kasan/report.c:162 mm/kasan/report.c:462)
____kasan_slab_free (mm/kasan/common.c:217)
slab_free_freelist_hook (mm/slub.c:1750)
__kmem_cache_free (mm/slub.c:3661 mm/slub.c:3674)
io_recvmsg (io_uring/net.c:812)
io_issue_sqe (include/linux/audit.h:314 include/linux/audit.h:339 
io_uring/io_uring.c:1746)
io_req_task_submit (io_uring/io_uring.c:1922 io_uring/io_uring.c:1264)
handle_tw_list (io_uring/io_uring.c:1028)
tctx_task_work (include/linux/instrumented.h:87 io_uring/io_uring.c:1077 
io_uring/io_uring.c:1091)
task_work_run (kernel/task_work.c:180 (discriminator 1))
io_run_task_work_sig (io_uring/io_uring.h:250 io_uring/io_uring.h:239 
io_uring/io_uring.h:272 io_uring/io_uring.c:2351)
__do_sys_io_uring_enter (io_uring/io_uring.c:2367 
io_uring/io_uring.c:2449 io_uring/io_uring.c:3267)
__do_fast_syscall_32 (arch/x86/entry/common.c:112 
arch/x86/entry/common.c:178)
do_fast_syscall_32 (arch/x86/entry/common.c:203)
entry_SYSENTER_compat_after_hwframe (arch/x86/entry/entry_64_compat.S:122)
RIP: 0023:0xf7f6d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 
10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 
c3 cc 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
All code
========
    0:   03 74 c0 01             add    0x1(%rax,%rax,8),%esi
    4:   10 05 03 74 b8 01       adc    %al,0x1b87403(%rip)        # 
0x1b8740d
    a:   10 06                   adc    %al,(%rsi)
    c:   03 74 b4 01             add    0x1(%rsp,%rsi,4),%esi
   10:   10 07                   adc    %al,(%rdi)
   12:   03 74 b0 01             add    0x1(%rax,%rsi,4),%esi
   16:   10 08                   adc    %cl,(%rax)
   18:   03 74 d8 01             add    0x1(%rax,%rbx,8),%esi
   1c:   00 00                   add    %al,(%rax)
   1e:   00 00                   add    %al,(%rax)
   20:   00 51 52                add    %dl,0x52(%rcx)
   23:   55                      push   %rbp
   24:   89 e5                   mov    %esp,%ebp
   26:   0f 34                   sysenter
   28:   cd 80                   int    $0x80
   2a:*  5d                      pop    %rbp             <-- trapping 
instruction
   2b:   5a                      pop    %rdx
   2c:   59                      pop    %rcx
   2d:   c3                      ret
   2e:   cc                      int3
   2f:   90                      nop
   30:   90                      nop
   31:   90                      nop
   32:   8d b4 26 00 00 00 00    lea    0x0(%rsi,%riz,1),%esi
   39:   8d b4 26 00 00 00 00    lea    0x0(%rsi,%riz,1),%esi

Code starting with the faulting instruction
===========================================
    0:   5d                      pop    %rbp
    1:   5a                      pop    %rdx
    2:   59                      pop    %rcx
    3:   c3                      ret
    4:   cc                      int3
    5:   90                      nop
    6:   90                      nop
    7:   90                      nop
    8:   8d b4 26 00 00 00 00    lea    0x0(%rsi,%riz,1),%esi
    f:   8d b4 26 00 00 00 00    lea    0x0(%rsi,%riz,1),%esi
RSP: 002b:00000000f7bff10c EFLAGS: 00000206 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
</TASK>

Allocated by task 733:
kasan_save_stack (mm/kasan/common.c:46)
kasan_set_track (mm/kasan/common.c:52)
__kasan_slab_alloc (mm/kasan/common.c:325)
kmem_cache_alloc (mm/slab.h:737 mm/slub.c:3398 mm/slub.c:3406 
mm/slub.c:3413 mm/slub.c:3422)
sk_prot_alloc (net/core/sock.c:2024)
sk_alloc (net/core/sock.c:2083)
inet_create (net/ipv4/af_inet.c:319 net/ipv4/af_inet.c:245)
__sock_create (net/socket.c:1516)
__sys_socket (net/socket.c:1605 net/socket.c:1588 net/socket.c:1636)
__ia32_compat_sys_socketcall (net/compat.c:447 net/compat.c:421 
net/compat.c:421)
__do_fast_syscall_32 (arch/x86/entry/common.c:112 
arch/x86/entry/common.c:178)
do_fast_syscall_32 (arch/x86/entry/common.c:203)
entry_SYSENTER_compat_after_hwframe (arch/x86/entry/entry_64_compat.S:122)

The buggy address belongs to the object at ffff8881049ff300
which belongs to the cache UDP of size 1152
The buggy address is located 40 bytes inside of
1152-byte region [ffff8881049ff300, ffff8881049ff780)

The buggy address belongs to the physical page:
page:000000005bc2cfe2 refcount:1 mapcount:0 mapping:0000000000000000 
index:0xffff8881049fe400 pfn:0x1049f8
head:000000005bc2cfe2 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888107526401
flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
raw: 0017ffffc0010200 0000000000000000 dead000000000122 ffff8881018cc140
raw: ffff8881049fe400 0000000080190018 00000001ffffffff ffff888107526401
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff8881049ff200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff8881049ff280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff8881049ff300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
^
ffff8881049ff380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
ffff8881049ff400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=========================================================

-- 
js
suse labs

