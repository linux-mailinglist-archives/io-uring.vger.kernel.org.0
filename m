Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB56B26FF2F
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIRNyD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 09:54:03 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:48359 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRNyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 09:54:02 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 09:54:00 EDT
Received: from mail-qt1-f172.google.com ([209.85.160.172]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MrPVJ-1knbdq0vFn-00oYej; Fri, 18 Sep 2020 15:48:53 +0200
Received: by mail-qt1-f172.google.com with SMTP id b2so4955831qtp.8;
        Fri, 18 Sep 2020 06:48:51 -0700 (PDT)
X-Gm-Message-State: AOAM531xWIKITHj3YUM+JIXBR8vgsqUe9SWmTjS6i03lCHMTteGlgg9h
        Gesw4ojO5qB0qfK1QEzYh9lYuf98x4MuwjzO9A0=
X-Google-Smtp-Source: ABdhPJwdeFcN0FjnibbBFg2qZA4+ButX9r5NAMFGHqmQR0795JOFdGKPWzC17cLOf78yKvN1tKg1lyeC+rdsG229l2M=
X-Received: by 2002:aed:31e5:: with SMTP id 92mr24508630qth.18.1600436930879;
 Fri, 18 Sep 2020 06:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-9-hch@lst.de>
In-Reply-To: <20200918124533.3487701-9-hch@lst.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 18 Sep 2020 15:48:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a07PbzpGfnVew7VAq2=iD418V-ryvOC94qAQzW0nQAbAA@mail.gmail.com>
Message-ID: <CAK8P3a07PbzpGfnVew7VAq2=iD418V-ryvOC94qAQzW0nQAbAA@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm: remove compat_process_vm_{readv,writev}
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Q8EZMOri4TBYhlknoKWRbdN7TbthGP/5lV4QZxZSCS2kXQRegOz
 crn8YMEG3zY+yUU81E38PaQTIpBOkDxjR4XroOZtmLdN0eDr9iw1sb1kp54wedcGz880ckD
 nAjWoeEwJOYtLfmGZr3pB0Z3r3MbVnaLhmYg9e1aO5sQM3zkJ/9qk+SG26nsCUabm4GA8jL
 Uyq9nTZiW2tWCev0Ajn3w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fyZnCuMlQ0U=:T4cV9ojRcQChU1kYa6Faz2
 2fHk2eqskdC7z9+Fqp1AQXIMGBCtnsDqy+BRk/MvcGQaiMrc3w9zYv31f5B5wvzpozAl84u6e
 S8LucqVvth1SJFgI81/CEsjw9YFYm0643XN0VPT6TRGy+l+NL0qG6ZcKKOEFwARMfBu1hSK8o
 Hy/bt+B8Hzb2tazcUxd/poYfDR/AzA/Mwge5rmE9k48648UV8YU1fTJaXyTFNj3gkhdyN//CN
 gZ6kDJLM6GmGVmX3lMP8JJ4XmChZtNGdB6Fa5u7nqnM0lXNM76JtOgnfLhy3mNI6TlRZOdW2y
 sUIVV3YgocvcrS6ShgH8YcWqc7Wj7x3sx/1XKvDPJpASKI2UBE5lR8oE6O6/pQY8eJMhwMwbU
 1wb499zYKc6lTCBsNJcFP/sdiKG2fuS0TfrWJ/xkcoLODp8SyWmY/ASM56WstVzqw2mm4lY21
 4ph1q19i/mvCLZm81ldIWsLHmhohTcLs2+LlBudCW/p0/XajI6RWRK81iPFwavHoiVuwBru9g
 4uhDjuOvpgtcGq9WUZFxckg/jvz8AiBNjMTt3uxe5IsJiN4Nx/rn+wkU5Noofd2jPiuqLy7Mg
 P1bD/Mqc7PIf81rYi3f3WFVZR+dVbuI0MyTaXMyK+T3xcv91hgkhsTwWTcXgwf9klNzctZEB+
 JbB2ZVHAzNpwT6+twOpsW4cxY82CLfJIBuS++bdjsxOzjXUN9NkrBQvzw1LGiykV1ZV6IXNw4
 ku1mt4/uDZy0/S3R/WZVZE8lJUcRgt5Tj5EYKCaNMY8Nt432XGof7zyp1lgau1PjsygTu/w3O
 FLhsC/Gvnrs8k9+5Wyh0c80vAcq515OKa9QV4EWbi00LTPrwKl35WMXHt4sA4nKbVfDSQZS
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 18, 2020 at 2:45 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Now that import_iovec handles compat iovecs, the native syscalls
> can be used for the compat case as well.
>
> diff --git a/arch/x86/entry/syscall_x32.c b/arch/x86/entry/syscall_x32.c
> index a4840b9d50ad14..f2fe0a33bcfdd5 100644
> --- a/arch/x86/entry/syscall_x32.c
> +++ b/arch/x86/entry/syscall_x32.c
> @@ -17,6 +17,8 @@
>  #define __x32_sys_getsockopt   __x64_sys_getsockopt
>  #define __x32_sys_setsockopt   __x64_sys_setsockopt
>  #define __x32_sys_vmsplice     __x64_sys_vmsplice
> +#define __x32_sys_process_vm_readv     __x64_sys_process_vm_readv
> +#define __x32_sys_process_vm_writev    __x64_sys_process_vm_writev
>
>  #define __SYSCALL_64(nr, sym)
>

I forgot this hack existed, and just sent a patch with subject "x86: add
__X32_COND_SYSCALL() macro" instead.

If I understand this right, the macros above should no longer be needed
once my patch gets merged.

        Arnd
