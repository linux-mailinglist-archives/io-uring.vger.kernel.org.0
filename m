Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C534B398
	for <lists+io-uring@lfdr.de>; Sat, 27 Mar 2021 02:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC0BrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 21:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhC0Bqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 21:46:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B688CC0613AA;
        Fri, 26 Mar 2021 18:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=zEstXzMJGafn67YkaxQTkCQBDliNHBByxcWjp2tUFlE=; b=EwRTLaJMCgi8LYaJyfjFWwiilV
        SZeWZQSCnb+XGPJ+ufISWvwZ99cSCeL+qZJE9zVTqVCSeaAhFMMKy/ecGMkXz6BaUHeRK/2hBVIwK
        Pe6qZuc8gOH9RjpIZACLZM6JG8vJVAakaEr7uQXRF/suzWtM8quVn3Y9lseL0SSj9adAzHlPidv7t
        GaULLE5s5gh35XT7Zke1u2boHBnPOsxe4w96W+oaucQO4d4SnaX0SsZJdakJFL6RP4p6qL4WnDn7i
        iASfVA/Lk2FgWp/ItAN1VTMt2e9clYVbZn6Gt1IsvCqJxOiRni7wQmyIWFe4l7kZNaXkUsofNfBfn
        f3aXtYsnREWGs6D6lXWtSjb+K2tHmejUZmK+LVaQEdZ4erDVyJRs7k3Hi1bPn4Cxty+5ceTHMhfRA
        DCa0VSoN80yv29aMjoECzuiZlO+pwF7bcsJVfGnbodnyR+1xedJVv3yejMvQOWulvLR0PE96HwgWx
        ehb0pKj3AlA/WFUYOIGojBxP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPy20-0006uS-JI; Sat, 27 Mar 2021 01:46:28 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
Date:   Sat, 27 Mar 2021 02:46:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

> root@ub1704-166:~# LANG=C gdb --pid 1320
> GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
> Copyright (C) 2020 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.
> Type "show copying" and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
>     <http://www.gnu.org/software/gdb/documentation/>.
> 
> For help, type "help".
> Type "apropos word" to search for commands related to "word".
> Attaching to process 1320
> [New LWP 1321]
> [New LWP 1322]
> 
> warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
> 
> warning: Architecture rejected target-supplied description
> syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
> 38      ../sysdeps/unix/sysv/linux/x86_64/syscall.S: No such file or directory.
> (gdb)

Ok, the following makes gdb happy again:

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -163,6 +163,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
        /* Kernel thread ? */
        if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
                memset(childregs, 0, sizeof(struct pt_regs));
+               if (p->flags & PF_IO_WORKER)
+                       childregs->cs = current_pt_regs()->cs;
                kthread_frame_init(frame, sp, arg);
                return 0;
        }

I'm wondering if we should decouple the PF_KTHREAD and PF_IO_WORKER cases even more
and keep as much of a userspace-like copy_thread as possible.

metze
