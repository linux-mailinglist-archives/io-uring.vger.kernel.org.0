Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307171EB01A
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 22:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgFAUSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 16:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgFAUSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 16:18:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34D9C061A0E;
        Mon,  1 Jun 2020 13:18:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r2so8394851ioo.4;
        Mon, 01 Jun 2020 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=3Etucp5jXOKPVYJSqKlWrGyEijEkPKIqobEIUC5SShc=;
        b=XhfBgYaCUoigt1rdTKIY7P13k0scHxWeBeMWwnq0jKdLZ2Q6IweCYcSIJGF5Eh5BN9
         cJu1asq40TuVw6CW0SwxqxeW0E1OwpOtCqWRKyaK6PLbehH2pg7U7xUh0FhD12ojlpH6
         1YjsNWweekHjXQFPeVdzhzbkJNvF6wKbgnug8tAMEo7HCz709Z6tAi16gtUwMfB3m1cu
         8huB+yMu8v415W9CcWAEHbXZPdfqpVefa0P8YZh87pwB7Pb4bIqvsqRPqfOXQOnuXa2G
         ezBfhGIZyN2yf3hCwuqnkNN+X+HoVxSreDarpEoo92Z1s5Eb8FUFf6HRz8eSZYuE9MB3
         fWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=3Etucp5jXOKPVYJSqKlWrGyEijEkPKIqobEIUC5SShc=;
        b=H+hsi+x7q2qM+NuOqteP1wGYydS9WsrNF8qjgL46/54YQln89JYM4mZ7oL0iWHDF5m
         BdEzeKF+01ZtGXpaSn1bEs3KbDV0FCW4zIva2SgrzaQHba+ypn+kMdfi53z5zaV2M4v0
         +7PC99HIZ0rqzmA/mu4eiLFRoatyi7pLJF7Vjndy9ESS+lVHknIrwa9ScG0+RrRSyfZ2
         hI5BOl8rug/lU8WCfzOtFf2qjaTXi8+jCi+lbK3eu+cCig72l+JAgX7FjmguXCeR3mZj
         xNsccScOH/SQi/M4uBmiuHtvJRs0n0bu2HaJ2xW86VLRPTKi5qOMNzQiX33vGSazakFt
         5+PQ==
X-Gm-Message-State: AOAM531Ber+utXz4WQfso2ByDB6GaTK2I1BR/ZmB7qjmVUAVwObVif91
        BfsQgN/s11lfEGl2UAuzAxU+nCLPQT3ShYjgTlVkSV8/DCM=
X-Google-Smtp-Source: ABdhPJxpx4//lV+kZiqVfHqXADeMaqV6MKr8TsMcA31HdUg1DZel267goZCfmesY4hesOn/TWw2nZLZeiHzMGF30/rQ=
X-Received: by 2002:a05:6602:2c45:: with SMTP id x5mr19895363iov.80.1591042724239;
 Mon, 01 Jun 2020 13:18:44 -0700 (PDT)
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
Date:   Mon, 1 Jun 2020 22:18:33 +0200
Message-ID: <CA+icZUVGJ8jfRqz2iCxLrkvmky79_9N7pGH71eFpg=s+=D4Urw@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
> >>>>>> with Linux v5.7 final I switched to linux-block.git/for-next and r=
everted...
> >>>>>>
> >>>>>> "block: read-ahead submission should imply no-wait as well"
> >>>>>>
> >>>>>> ...and see no boot-slowdowns.
> >>>>>
> >>>>> Can you try with these patches applied instead? Or pull my async-re=
adahead
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
> >> Actually, can you just re-test with the current async-buffered.6 branc=
h?
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
> > -Werror=3Dstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
> > -fno-common -fshort-wchar -fno-PIE
> > -Werror=3Dimplicit-function-declaration -Werror=3Dimplicit-int
> > -Wno-format-security -std=3Dgnu89 -no-integrated-as
> > -Werror=3Dunknown-warning-option -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
> > -mno-avx -m64 -mno-80387 -mstack-alignment=3D8 -mtune=3Dgeneric
> > -mno-red-zone -mcmodel=3Dkernel -Wno-sign-compare
> > -fno-asynchronous-unwind-tables -mretpoline-external-thunk
> > -fno-delete-null-pointer-checks -Wno-address-of-packed-member -O2
> > -Wframe-larger-than=3D2048 -fstack-protector-strong
> > -Wno-format-invalid-specifier -Wno-gnu -mno-global-merge
> > -Wno-unused-const-variable -g -gz=3Dzlib -pg -mfentry -DCC_USING_FENTRY
> > -Wdeclaration-after-statement -Wvla -Wno-pointer-sign
> > -Wno-array-bounds -fno-strict-overflow -fno-merge-all-constants
> > -fno-stack-check -Werror=3Ddate-time -Werror=3Dincompatible-pointer-typ=
es
> > -fmacro-prefix-map=3D./=3D -fcf-protection=3Dnone -Wno-initializer-over=
rides
> > -Wno-format -Wno-sign-compare -Wno-format-zero-length
> > -Wno-tautological-constant-out-of-range-compare
> > -DKBUILD_MODFILE=3D'"kernel/sys"' -DKBUILD_BASENAME=3D'"sys"'
> > -DKBUILD_MODNAME=3D'"sys"' -c -o kernel/sys.o kernel/sys.c
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
> --
> Jens Axboe
>

Looks good.

$ cat systemd-analyze_time_5.7.0-2-amd64-clang.txt
Startup finished in 6.054s (kernel) + 42.626s (userspace) =3D 48.680s
graphical.target reached after 42.605s in userspace

$ cat systemd-analyze_blame_5.7.0-2-amd64-clang.txt
25.777s udisks2.service
24.527s accounts-daemon.service
18.228s polkit.service
17.593s avahi-daemon.service
17.554s NetworkManager.service
17.526s rtkit-daemon.service
17.417s dev-sdc2.device
17.200s switcheroo-control.service
17.186s wpa_supplicant.service
17.174s systemd-logind.service
15.714s smartmontools.service
14.255s zramswap.service
13.495s NetworkManager-wait-online.service
11.092s rsyslog.service
 8.900s networking.service
 7.817s gpm.service
 6.571s ModemManager.service
 6.403s packagekit.service
 5.701s e2scrub_reap.service
 3.714s alsa-restore.service
 3.509s systemd-udevd.service
 3.286s apparmor.service
 3.028s atd.service
 2.361s exim4.service
 1.532s systemd-tmpfiles-setup.service
 1.213s systemd-journal-flush.service
 1.163s keyboard-setup.service
 1.011s bluetooth.service
 1.008s binfmt-support.service
  995ms systemd-modules-load.service
  987ms pppd-dns.service
  919ms systemd-journald.service
  875ms upower.service
  856ms systemd-sysusers.service
  750ms systemd-udev-trigger.service
  728ms dev-hugepages.mount
  725ms dev-mqueue.mount
  724ms sys-kernel-debug.mount
  723ms sys-kernel-tracing.mount
  648ms modprobe@drm.service
  640ms ifupdown-wait-online.service
  609ms systemd-timesyncd.service
  579ms systemd-tmpfiles-setup-dev.service
  521ms systemd-backlight@backlight:intel_backlight.service
  477ms systemd-remount-fs.service
  454ms systemd-sysctl.service
  441ms systemd-random-seed.service
  389ms console-setup.service
  306ms systemd-rfkill.service
  266ms kmod-static-nodes.service
  244ms user@1000.service
  150ms proc-sys-fs-binfmt_misc.mount
  131ms systemd-update-utmp.service
   98ms systemd-user-sessions.service
   26ms user-runtime-dir@1000.service
   15ms systemd-update-utmp-runlevel.service
    6ms sys-fs-fuse-connections.mount
    3ms ifupdown-pre.service

$ cat systemd-analyze_critical-chain_5.7.0-2-amd64-clang.txt
The time when unit became active or started is printed after the "@" charac=
ter.
The time the unit took to start is printed after the "+" character.

graphical.target @42.605s
=E2=94=94=E2=94=80multi-user.target @42.604s
  =E2=94=94=E2=94=80exim4.service @40.240s +2.361s
    =E2=94=94=E2=94=80network-online.target @40.237s
      =E2=94=94=E2=94=80NetworkManager-wait-online.service @26.740s +13.495=
s
        =E2=94=94=E2=94=80NetworkManager.service @9.177s +17.554s
          =E2=94=94=E2=94=80dbus.service @9.170s
            =E2=94=94=E2=94=80basic.target @9.081s
              =E2=94=94=E2=94=80sockets.target @9.080s
                =E2=94=94=E2=94=80dbus.socket @9.080s
                  =E2=94=94=E2=94=80sysinit.target @8.814s

=E2=94=94=E2=94=80systemd-backlight@backlight:intel_backlight.service @23.0=
30s +521ms
                      =E2=94=94=E2=94=80system-systemd\x2dbacklight.slice @=
22.251s
                        =E2=94=94=E2=94=80system.slice @2.429s
                          =E2=94=94=E2=94=80-.slice @2.429s

Hope this helps you.

- Sedat -
