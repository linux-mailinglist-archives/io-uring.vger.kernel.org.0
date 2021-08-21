Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE53F3A09
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 11:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhHUJxd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 05:53:33 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:58828 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhHUJxc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 05:53:32 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43168 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHNgJ-00016f-Of; Sat, 21 Aug 2021 05:52:51 -0400
Message-ID: <57f28a37c6bffacdadd4d98a7c6abc258dd752d4.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Date:   Sat, 21 Aug 2021 05:52:50 -0400
In-Reply-To: <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
         <87eeda7nqe.fsf@disp2133>
         <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
         <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
         <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
         <87y2bh4jg5.fsf@disp2133>
         <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
         <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
         <87pmwmn5m0.fsf@disp2133>
         <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
         <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
         <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
         <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
         <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
         <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-08-17 at 12:24 -0600, Jens Axboe wrote:
> 
> And assuming that works, then I suspect this one would fix your issue
> even with a piped core dump:
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 07afb5ddb1c4..852737a9ccbf 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -41,6 +41,7 @@
>  #include <linux/fs.h>
>  #include <linux/path.h>
>  #include <linux/timekeeping.h>
> +#include <linux/io_uring.h>
>  
>  #include <linux/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -603,6 +604,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>         };
>  
>         audit_core_dumps(siginfo->si_signo);
> +       io_uring_task_cancel();
>  
>         binfmt = mm->binfmt;
>         if (!binfmt || !binfmt->core_dump)
> 
That is what my patch is doing. Function call is inserted at a
different place... I am not sure if one location is better than the
other or if it matters at all but there is an extra change required to
make it work...

diff --git a/fs/coredump.c b/fs/coredump.c
index 07afb5ddb1c4..614fe7a54c1a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/path.h>
 #include <linux/timekeeping.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -625,6 +626,8 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 		need_suid_safe = true;
 	}
 
+	io_uring_task_cancel();
+
 	retval = coredump_wait(siginfo->si_signo, &core_state);
 	if (retval < 0)
 		goto fail_creds;



