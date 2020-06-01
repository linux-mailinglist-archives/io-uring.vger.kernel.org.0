Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642471EA648
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFAOwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAOwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:52:06 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E36C05BD43;
        Mon,  1 Jun 2020 07:52:06 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r2so9620098ila.4;
        Mon, 01 Jun 2020 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Nf/blbPcrjBbFJHwPsvnL7cuUdcfeFMZRwjvi+vCyzg=;
        b=ualx6ZL38OrIJJfwQl60gf2szUZBoDOZTp79Cl/jJORME+w6e5oR8eOOw8z8tilIm4
         MMb72CWlV3RDBQXETAr6LMDDB/FaKCaTsFBQdPlOozVEWdWQElTTkgbNXQqT8qBzscEv
         kg79J0DBl8PUPtNNHQcBvN2Kytc9tuGLO2DWhPMcDnVCZrBnyp42eUZUIv47/OQKG14M
         7rOosR0Ms7aQl91glMZxtHOGxe82lUk/PzteE2Xy4R8cjJJFlSh/2CU+qP+S3uhkS6gE
         muMuzc+SPGa8OVa5FR1yFnyDRush8Q9lgzR/bFdhnz86Nqi7pGmkg7+QojphOAqzQZRF
         Fwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Nf/blbPcrjBbFJHwPsvnL7cuUdcfeFMZRwjvi+vCyzg=;
        b=YqwaO8O2iwnZUPg40tWSnCAEnOaFas8J2ur62a3HEQg9fBtg7bBT/qGY9OmO3naIFk
         DlVMGZ+kysvSwgYjqaveP+hMDg++VHPKdqBKuWTMS+yWejBIdO6LU9R9grHw69ZyhwQD
         0wDKj4fABZJ1TnwhSqqHenSr8zpFATNSW8O9OIqBDo1fNxvnLwrj3KPrxjH6uHfA1iO+
         pjbN1cZK+PuXOa8XsJcGJNTD7rIl2gXpXhmDiyTavII5J9Rw9ZP/0wsv7p3ISZxgpOgU
         OuoPj4o3yundsDFe1VKDDRROYPltkkZM/ks+GT0KI+UFGqF4zklep+AExZr5BH+hetrj
         kGcw==
X-Gm-Message-State: AOAM532vm3SKi0ljGp/QgwtjIJ4KSJh5umP3EnQ4XugWZKu3U3dZ9BFO
        WuxicHMv72JUFKHlCd1sJNkQjk0SJ1j44RigWmI=
X-Google-Smtp-Source: ABdhPJzuPgyweQpwToozBwO+cc4t75unYUQT+9VfnEQEns6ZiF7ewa1T1PYSUr42PH/d0Ek4caDOm730eDAky6ToB/c=
X-Received: by 2002:a92:9603:: with SMTP id g3mr12388953ilh.204.1591023125764;
 Mon, 01 Jun 2020 07:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk> <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
 <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
 <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk> <CA+icZUUfxAc9LaWSzSNV4tidW2KFeVLkDhU30OWbQP-=2bYFHw@mail.gmail.com>
 <b24101f1-c468-8f6b-9dcb-6dc59d0cd4b9@kernel.dk> <455dd2c1-7346-2d43-4266-1367c368cee1@kernel.dk>
 <CA+icZUVVL4W46Df5=eQVsb8S6A=_A0ho0jFVf3mde1wpx7kynQ@mail.gmail.com> <412ec6a7-90c9-5856-bafe-12c8fe2135e7@kernel.dk>
In-Reply-To: <412ec6a7-90c9-5856-bafe-12c8fe2135e7@kernel.dk>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 1 Jun 2020 16:51:55 +0200
Message-ID: <CA+icZUX9Pv9w=48TPFku0147AYWhFtgyj9+sjrqAEpXVLAL1UQ@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 1, 2020 at 4:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/1/20 8:43 AM, Sedat Dilek wrote:
> > On Mon, Jun 1, 2020 at 4:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 6/1/20 8:14 AM, Jens Axboe wrote:
> >>> On 6/1/20 8:13 AM, Sedat Dilek wrote:
> >>>> On Mon, Jun 1, 2020 at 4:04 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 6/1/20 7:35 AM, Sedat Dilek wrote:
> >>>>>> Hi Jens,
> >>>>>>
> >>>>>> with Linux v5.7 final I switched to linux-block.git/for-next and reverted...
> >>>>>>
> >>>>>> "block: read-ahead submission should imply no-wait as well"
> >>>>>>
> >>>>>> ...and see no boot-slowdowns.
> >>>>>
> >>>>> Can you try with these patches applied instead? Or pull my async-readahead
> >>>>> branch from the same location.
> >>>>>
> >>>>
> >>>> Yes, I can do that.
> >>>> I pulled from linux-block.git#async-readahead and will report later.
> >>>>
> >>>> Any specific testing desired by you?
> >>>
> >>> Just do your boot timing test and see if it works, thanks.
> >>
> >> Actually, can you just re-test with the current async-buffered.6 branch?
> >> I think the major surgery should wait for 5.9, we can do this a bit
> >> easier without having to touch everything around us.
> >>
> >
> > With linux-block.git#async-readahead:
> >
> >   mycompiler -Wp,-MD,kernel/.sys.o.d -nostdinc -isystem
> > /home/dileks/src/llvm-toolchain/install/lib/clang/10.0.1rc1/include
> > -I./arch/x86/include -I./arch/x86/include/generated  -I./include
> > -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi
> > -I./include/uapi -I./include/generated/uapi -include
> > ./include/linux/kconfig.h -include ./include/linux/compiler_types.h
> > -D__KERNEL__ -Qunused-arguments -Wall -Wundef
> > -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing
> > -fno-common -fshort-wchar -fno-PIE
> > -Werror=implicit-function-declaration -Werror=implicit-int
> > -Wno-format-security -std=gnu89 -no-integrated-as
> > -Werror=unknown-warning-option -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
> > -mno-avx -m64 -mno-80387 -mstack-alignment=8 -mtune=generic
> > -mno-red-zone -mcmodel=kernel -Wno-sign-compare
> > -fno-asynchronous-unwind-tables -mretpoline-external-thunk
> > -fno-delete-null-pointer-checks -Wno-address-of-packed-member -O2
> > -Wframe-larger-than=2048 -fstack-protector-strong
> > -Wno-format-invalid-specifier -Wno-gnu -mno-global-merge
> > -Wno-unused-const-variable -g -gz=zlib -pg -mfentry -DCC_USING_FENTRY
> > -Wdeclaration-after-statement -Wvla -Wno-pointer-sign
> > -Wno-array-bounds -fno-strict-overflow -fno-merge-all-constants
> > -fno-stack-check -Werror=date-time -Werror=incompatible-pointer-types
> > -fmacro-prefix-map=./= -fcf-protection=none -Wno-initializer-overrides
> > -Wno-format -Wno-sign-compare -Wno-format-zero-length
> > -Wno-tautological-constant-out-of-range-compare
> > -DKBUILD_MODFILE='"kernel/sys"' -DKBUILD_BASENAME='"sys"'
> > -DKBUILD_MODNAME='"sys"' -c -o kernel/sys.o kernel/sys.c
> > fs/9p/vfs_addr.c:112:4: error: use of undeclared identifier 'filp'
> >                         filp->private_data);
> >                         ^
> > 1 error generated.
> > make[5]: *** [scripts/Makefile.build:267: fs/9p/vfs_addr.o] Error 1
> > make[4]: *** [scripts/Makefile.build:488: fs/9p] Error 2
> > make[3]: *** [Makefile:1735: fs] Error 2
> > make[3]: *** Waiting for unfinished jobs....
> >
> > I guess block.git#async-buffered.6 needs the same revert of "block:
> > read-ahead submission should imply no-wait as well".
>
> Sorry, forgot to push out the updated version. But as per previous
> email, I think that major work should wait. Just try the updated
> async-buffered.6 branch instead.
>

Hehe, I was looking at git.k.o URLs.

I just pulled from
<https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.6>.

- Sedat -
