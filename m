Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213ED650A09
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 11:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiLSKXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 05:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiLSKXV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 05:23:21 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D502BFF
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 02:23:20 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fc4so20226191ejc.12
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 02:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/AiKe3vQEkI0Q6pU6RbKUrOerB0ZWbqhZIpsAS0Gtl4=;
        b=N7RGcYFzPLzdRQkRRzR98B+N8oujd7FtHrUqfKy3OMKSHuvMux8QdNWSstYG9mBidc
         e+an/vHTAE70QIuLkunmB6nHtLwTlEhhwwYQfgu0QQhKRaz2M25S0qtnp2v6UZRDc8Iw
         M9S2GVB/wl/3qwHaHLCzRwfCBdovhnKF6HIVarweP/K1W75WCGf28TZ9XHAy2rpjpha2
         PAWWDxGA/OTbeF1c5qAhdTTFudPw1xSxv2NNp4a8pV9brRqj6okL0wvHqrnOumGaSUx2
         aFsI8PoUSm29D0NDjWmh5hbb6TzqFfC7w9v9Fq3ucmBAu8PkMyFKj5qLiYuhXjkruXys
         WMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AiKe3vQEkI0Q6pU6RbKUrOerB0ZWbqhZIpsAS0Gtl4=;
        b=Uz2BAUmWMwsH4S4jyIoFCd1Hp2/vMGWT7YU2TXqsjSB7uC555786k3aQ9DHEsGTmBV
         BniY5DyLmgvZOrOoamhkb/vxrXGp3hNd255jvtwWFleHDF2IbUECyasYUmjd/Np5EFc1
         ER2W30P1+OGORsQwwmI8+Y5NPHi+sxP2aoR5WJfPJ2B6+P6xS4+LQcFKlPo7Od+mnS5Q
         Uzk8AD+RHvErv6KxaxoHn8F/JYcnF6T9/572WiUWcGm4Vi3pALgB+VX9oyz3Z6pmIJl7
         i367ER4DCBF/mfMdXLNhSZ8Wm7AmnFJWSFgNG4yftAUPS84yshU7Oophq4889hov7Llj
         ohOQ==
X-Gm-Message-State: AFqh2kp6VVJ1PBuQ0fUbavnhKsJ7kGYrsb18CWN5TNE/qlrkQmlxknrO
        5YXAWQ04KaiR33roetIAD+EQpqk5TXc=
X-Google-Smtp-Source: AMrXdXtuF3M0VhwGY3lf7ri6VQCwiXSwvHoImVNC2MNbxcbW8WXY9PYkLvy2oooWJGfmt24+Ti+D0g==
X-Received: by 2002:a17:906:3a09:b0:82f:ba57:f806 with SMTP id z9-20020a1709063a0900b0082fba57f806mr831199eje.23.1671445398820;
        Mon, 19 Dec 2022 02:23:18 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090628c400b007c0a7286ac8sm4182292ejd.69.2022.12.19.02.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 02:23:18 -0800 (PST)
Message-ID: <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
Date:   Mon, 19 Dec 2022 11:23:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: User-triggerable 6.1 crash [was: io_uring/net: fix cleanup double
 free free_iov init]
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
References: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
From:   Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26. 09. 22, 15:35, Pavel Begunkov wrote:
> Having ->async_data doesn't mean it's initialised and previously we vere
> relying on setting F_CLEANUP at the right moment. With zc sendmsg
> though, we set F_CLEANUP early in prep when we alloc a notif and so we
> may allocate async_data, fail in copy_msg_hdr() leaving
> struct io_async_msghdr not initialised correctly but with F_CLEANUP
> set, which causes a ->free_iov double free and probably other nastiness.
> 
> Always initialise ->free_iov. Also, now it might point to fast_iov when
> fails, so avoid freeing it during cleanups.
> 
> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
> Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Hi,

it's rather easy to crash 6.1 with this patch now. Compile 
liburing-2.2/test/send_recvmsg.c with -m32, run it as an ordinary user 
and see the below WARNING followed by many BUGs.

It dies in this kfree() in io_recvmsg():
         if (mshot_finished) {
                 io_netmsg_recycle(req, issue_flags);
                 /* fast path, check for non-NULL to avoid function call */
                 if (kmsg->free_iov)
                         kfree(kmsg->free_iov);
                 req->flags &= ~REQ_F_NEED_CLEANUP;
         }


WARNING: CPU: 1 PID: 739 at mm/slub.c:3567 kfree (mm/slub.c:3567 
mm/slub.c:4558)
Modules linked in:
CPU: 1 PID: 739 Comm: send_recvmsg.t Not tainted 6.0.0-rc6-default+ #31 
090abe0ed83c945329aed053e1acb9f3614bf165
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:kfree (mm/slub.c:3567 mm/slub.c:4558)
Code: 68 fd ff ff 41 f7 c4 ff 0f 00 00 75 be 49 8b 04 24 a9 00 00 01 00 
74 b3 49 8b 44 24 48 a8 01 74 aa 48 83 e8 01 49 39 c4 74 a1 <0f> 0b 80 
3d 2e 14 9a 01 00 0f 84 3a 39 8f 00 be 00 f0 ff ff 31 ed
All code
========
    0:   68 fd ff ff 41          push   $0x41fffffd
    5:   f7 c4 ff 0f 00 00       test   $0xfff,%esp
    b:   75 be                   jne    0xffffffffffffffcb
    d:   49 8b 04 24             mov    (%r12),%rax
   11:   a9 00 00 01 00          test   $0x10000,%eax
   16:   74 b3                   je     0xffffffffffffffcb
   18:   49 8b 44 24 48          mov    0x48(%r12),%rax
   1d:   a8 01                   test   $0x1,%al
   1f:   74 aa                   je     0xffffffffffffffcb
   21:   48 83 e8 01             sub    $0x1,%rax
   25:   49 39 c4                cmp    %rax,%r12
   28:   74 a1                   je     0xffffffffffffffcb
   2a:*  0f 0b                   ud2             <-- trapping instruction
   2c:   80 3d 2e 14 9a 01 00    cmpb   $0x0,0x19a142e(%rip)        # 
0x19a1461
   33:   0f 84 3a 39 8f 00       je     0x8f3973
   39:   be 00 f0 ff ff          mov    $0xfffff000,%esi
   3e:   31 ed                   xor    %ebp,%ebp

Code starting with the faulting instruction
===========================================
    0:   0f 0b                   ud2
    2:   80 3d 2e 14 9a 01 00    cmpb   $0x0,0x19a142e(%rip)        # 
0x19a1437
    9:   0f 84 3a 39 8f 00       je     0x8f3949
    f:   be 00 f0 ff ff          mov    $0xfffff000,%esi
   14:   31 ed                   xor    %ebp,%ebp
RSP: 0018:ffffbce7c0e17980 EFLAGS: 00010246
RAX: 0017ffffc0001000 RBX: ffffffffbd06ea69 RCX: ffff9ccb84548c00
RDX: ffffeae904969b88 RSI: ffffeae900000000 RDI: ffffffffbd06ea69
RBP: ffffbce7c0e17c20 R08: 0000000000000035 R09: 0000000080100002
R10: 0000000000000001 R11: 0000000000000001 R12: ffffeae904969b80
R13: 0000000000590005 R14: ffff9ccb8aeedd00 R15: ffff9ccb84548c00
FS:  0000000000000000(0000) GS:ffff9ccbc0c80000(0063) knlGS:00000000f7bffb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7d51830 CR3: 000000010177c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
io_recvmsg (io_uring/net.c:809)
io_issue_sqe (io_uring/io_uring.c:1740)
io_req_task_submit (io_uring/io_uring.c:1920 io_uring/io_uring.c:1258)
handle_tw_list (io_uring/io_uring.c:1023)
tctx_task_work (io_uring/io_uring.c:1072 io_uring/io_uring.c:1086)
task_work_run (include/linux/sched.h:2056 (discriminator 1) 
kernel/task_work.c:179 (discriminator 1))
io_run_task_work_sig (io_uring/io_uring.h:242 io_uring/io_uring.h:260 
io_uring/io_uring.c:2349)
__do_sys_io_uring_enter (io_uring/io_uring.c:2365 
io_uring/io_uring.c:2446 io_uring/io_uring.c:3261)
__do_fast_syscall_32 (arch/x86/entry/common.c:112 
arch/x86/entry/common.c:178)
do_fast_syscall_32 (arch/x86/entry/common.c:203)
entry_SYSENTER_compat_after_hwframe (arch/x86/entry/entry_64_compat.S:122)
RIP: 0023:0xf7fb0549
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


> ---
>   io_uring/net.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 2af56661590a..6b69eff6887e 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -124,20 +124,22 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_cache_entry *entry;
> +	struct io_async_msghdr *hdr;
>   
>   	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
>   	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
> -		struct io_async_msghdr *hdr;
> -
>   		hdr = container_of(entry, struct io_async_msghdr, cache);
> +		hdr->free_iov = NULL;
>   		req->flags |= REQ_F_ASYNC_DATA;
>   		req->async_data = hdr;
>   		return hdr;
>   	}
>   
> -	if (!io_alloc_async_data(req))
> -		return req->async_data;
> -
> +	if (!io_alloc_async_data(req)) {
> +		hdr = req->async_data;
> +		hdr->free_iov = NULL;
> +		return hdr;
> +	}
>   	return NULL;
>   }
>   
> @@ -192,7 +194,6 @@ int io_send_prep_async(struct io_kiocb *req)
>   	io = io_msg_alloc_async_prep(req);
>   	if (!io)
>   		return -ENOMEM;
> -	io->free_iov = NULL;
>   	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
>   	return ret;
>   }
> @@ -209,7 +210,6 @@ static int io_setup_async_addr(struct io_kiocb *req,
>   	io = io_msg_alloc_async(req, issue_flags);
>   	if (!io)
>   		return -ENOMEM;
> -	io->free_iov = NULL;
>   	memcpy(&io->addr, addr_storage, sizeof(io->addr));
>   	return -EAGAIN;
>   }
> @@ -479,7 +479,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   
>   		if (msg.msg_iovlen == 0) {
>   			sr->len = 0;
> -			iomsg->free_iov = NULL;
>   		} else if (msg.msg_iovlen > 1) {
>   			return -EINVAL;
>   		} else {
> @@ -490,7 +489,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   			if (clen < 0)
>   				return -EINVAL;
>   			sr->len = clen;
> -			iomsg->free_iov = NULL;
>   		}
>   
>   		if (req->flags & REQ_F_APOLL_MULTISHOT) {
> @@ -913,7 +911,9 @@ void io_send_zc_cleanup(struct io_kiocb *req)
>   
>   	if (req_has_async_data(req)) {
>   		io = req->async_data;
> -		kfree(io->free_iov);
> +		/* might be ->fast_iov if *msg_copy_hdr failed */
> +		if (io->free_iov != io->fast_iov)
> +			kfree(io->free_iov);
>   	}
>   	if (zc->notif) {
>   		zc->notif->flags |= REQ_F_CQE_SKIP;

-- 
js

