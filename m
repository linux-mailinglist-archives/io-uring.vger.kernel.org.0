Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7A34B846
	for <lists+io-uring@lfdr.de>; Sat, 27 Mar 2021 17:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhC0QmL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Mar 2021 12:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhC0QmA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Mar 2021 12:42:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC76AC0613B1
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 09:41:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g10so2392125plt.8
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b17SAdPX6nFOb6T7BOu2u77iGyZqgb6X+sWCVvCBRdc=;
        b=Q+gE3B/6OXFXCQX+tZc1x4wvsgXzQa2ctNK6mgR5uqOVImk4Xx2if+48CuJ4ej6tlx
         1/RCN+0K/loG6qQIplmww0cdU5kXQ5GUEUF6OEtih8TRvJwU2OSBkPd/7JKlnaU7GkiJ
         tlxoO9zhL5yCBeUmdzxf8pKMahsgTW56Wo9w8xYbkLev3BhlJwmZ3p2NEVbdILLQHxpx
         XiF1RrxJbri+nMBF5aHzYIMYj+QSj1OHDPsNPHxWmAVahncPqZBp403IjsxvbUslvHHn
         2EaI5pw2N3jVry15oa7ehnmHD+20i/lSKWDHszUZ02xXOjTEpRib+rLZPlCHSuMSGbsZ
         A1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b17SAdPX6nFOb6T7BOu2u77iGyZqgb6X+sWCVvCBRdc=;
        b=G2M+1cWgPjP2Wy27hdNcZ/N2gWiWjBVjvdjS9RcM4Riupy5Zk5m4bVJ5c8iQgwhGnP
         zJNgPMwzAldEQziCHtijTFK3+Ljer9A1ZelS1b34m3/2oYpKCYwFwoIYMAmB38N10HHV
         53rjscX5q4PMrMuCGfljyWPBl/3HluVoLPC0ZK+CKGvK84+xXPE3YgvOJRL3ZUyv3ZJZ
         5miG2/onId6JPAHInMjWNe6iXlzbq5730c0ZegBfHf4yGT3dH98Yk26DBu8nFfM66oTZ
         v9dznaf6yV6QADTva17fNRRJ0D7XnlsNe1l6yrb1aQHhZcJ1zKs/HWS/+kQklSiW3zVi
         f5sQ==
X-Gm-Message-State: AOAM531C6yxn4X9xPwM63RcTpNIIR5AL3TJerjEzVKylsVif+wlnMYbb
        DTRew1kHW8V4Biu5sFh7H9/GHSOvJkOE+g==
X-Google-Smtp-Source: ABdhPJxtUI6V9nWEGUXivlaCxukhiQQHXADM1rRWTRwRuEufVyOFAFdwHTmULi8JUApZhHcCs9ZQxg==
X-Received: by 2002:a17:902:b908:b029:e6:3e0a:b3cc with SMTP id bf8-20020a170902b908b02900e63e0ab3ccmr20843430plb.68.1616863319379;
        Sat, 27 Mar 2021 09:41:59 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g7sm11951769pgb.10.2021.03.27.09.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 09:41:58 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <548d1761-731d-2960-ee84-2e5ede73bdeb@kernel.dk>
Date:   Sat, 27 Mar 2021 10:41:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 7:46 PM, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
>> root@ub1704-166:~# LANG=C gdb --pid 1320
>> GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
>> Copyright (C) 2020 Free Software Foundation, Inc.
>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>> This is free software: you are free to change and redistribute it.
>> There is NO WARRANTY, to the extent permitted by law.
>> Type "show copying" and "show warranty" for details.
>> This GDB was configured as "x86_64-linux-gnu".
>> Type "show configuration" for configuration details.
>> For bug reporting instructions, please see:
>> <http://www.gnu.org/software/gdb/bugs/>.
>> Find the GDB manual and other documentation resources online at:
>>     <http://www.gnu.org/software/gdb/documentation/>.
>>
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

Confirmed, it stops complaining about the arch at that point.

> I'm wondering if we should decouple the PF_KTHREAD and PF_IO_WORKER
> cases even more and keep as much of a userspace-like copy_thread as
> possible.

Probably makes sense, the only thing they really share is the func+arg
setup. Hence PF_IO_WORKER threads likely just use the rest of the init,
where it doesn't conflict with the frame setup.

-- 
Jens Axboe

