Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA53351818
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhDARn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbhDARh3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:37:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE17DC0F26D1;
        Thu,  1 Apr 2021 07:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=qsREKFlh59lQ4zdk5VkHPiTTnXwKjF0VPiMuSccVscw=; b=ktFjLEl9BtTHht4JW3GOztN5r5
        4Q+b3DFeFQT6GjH9r7Zd5BKSgYHxlGH1Yn1HvH4sAiuHWioIHXVbe7xL1zsf3bqa2v+J9LuBx8sss
        /Mq3g48+G9wfQxT5NF6Y8eAg4CjiW1ESTRYUGwOF6QyjG2UFrTS4FQC8JTDpe9dynG/fg8A/i9TCk
        sjKZgRqjLmxLjn8NvKnTkfdkVSdVASm5Erp3RpZnYqHiy2zNZnrROY3/qIje3z+tchV75RxnnKfE0
        8wlEZtfrG1tkNdlX2IdkS0LJanPg30Qs0VDeigjzwiwhoT5jamAojf5mfZg4O6wrZNEmzzpp4k+7F
        AiUgd/8Zk7Zqg/s4TMaNSeEQNJOa6KhMT4U6CxFvNTqBxDqudRRf2UtVlMk74SX1UswKzkvhbNkcJ
        Q/1O+1sQORmrERLtQqjTgQQse7nME4eLZWI1VL8EimhxU9gxJG1tbwg8ML4PagKIGd77Jr+yIERZO
        F4i+vnbnBhUeIJupWJfjxwW0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRym4-0007U6-Qv; Thu, 01 Apr 2021 14:58:20 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
Date:   Thu, 1 Apr 2021 16:58:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> For help, type "help".
>> Type "apropos word" to search for commands related to "word".
>> Attaching to process 1320
>> [New LWP 1321]
>> [New LWP 1322]
>>
>> warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
>>
>> warning: Architecture rejected target-supplied description
>> syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
>> 38      ../sysdeps/unix/sysv/linux/x86_64/syscall.S: No such file or directory.
>> (gdb)
> 
> Ok, the following makes gdb happy again:
> 
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -163,6 +163,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>         /* Kernel thread ? */
>         if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>                 memset(childregs, 0, sizeof(struct pt_regs));
> +               if (p->flags & PF_IO_WORKER)
> +                       childregs->cs = current_pt_regs()->cs;
>                 kthread_frame_init(frame, sp, arg);
>                 return 0;
>         }
> 
> I'm wondering if we should decouple the PF_KTHREAD and PF_IO_WORKER cases even more
> and keep as much of a userspace-like copy_thread as possible.

Would it be possible to fix this remaining problem before 5.12 final?
(I don't think my change would be the correct fix actually
and other architectures may have similar problems).

Thanks!
metze



