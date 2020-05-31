Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7502C1E9610
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 09:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgEaHMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 03:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbgEaHMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 03:12:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FCDC05BD43;
        Sun, 31 May 2020 00:12:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y5so3665033iob.12;
        Sun, 31 May 2020 00:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=ey0Mu/77gCM8lwA4qoVtAlYPuEJOvh0eqiebV8Pkns4=;
        b=DjaUH2Dmc/76nG9XZN6JAFTxvH9L/prwrmYrRQtn2KWA1TALZJe7+T9qMsb7nsJzKN
         RIu77d5c3Uh9TZL/kljzuI2WZvNort7VSoj4KwZ3TEXSQWvRkg/o07e+V6/xJa0LQ6UI
         WdunpR+7cMmETgC2gEUgjTh1UemW+/r8t7q3NcwTeEMtjwQXH5DshQtoTCNZ29tIeshO
         e45pEogvOTCjnuT5ND58BujRDFtufTgFg8RxFKZYy2DDiFbOAVlyqGwMUQhnKM+b6jky
         IUXVIS8s6Kz9AvivswCAqQNJhwgW1KrsoTahaqwOauP0pUqc/k0ecE1HpOlLBqJyC+m7
         HRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=ey0Mu/77gCM8lwA4qoVtAlYPuEJOvh0eqiebV8Pkns4=;
        b=CK9+kzSWQlOuspBJACaXyOT7EAbF1JEJm8bxJ4ne8Vty03dmkzfe/8AvaJKxp3GNiq
         OxggDPsC7Ib4EfYGy8ujX7HSsc0xKeje4oZgmHFM8yFyw24P+02vom/r98UHaIEpFnv/
         s2Rj1bZWysJxCnEWXf/kksBt/fnL6vwei9JSVJ2vLLXf0BDlU6o/bqfukGrCuXVnq2oG
         l2At3QOIMoJMBfUuR7qFQO4aIWQsK8llLtS8AARUovNTQhvYPkrLdNtS8cyWi0oyQijk
         1htZQwvxvWvBoD3FUHDf1UX4GnNXDGT3KhyYu9NBKt+TOVyd5oTFGVxdR0opH3xhMfDT
         NaWA==
X-Gm-Message-State: AOAM533kjt02ygjAV0pqm6xWcBHmlbqNV4jWa/+jr2ck6jnMZALzghmu
        pPi82H8oJOJLQkyo8uCvQ/TzT04rNFaEUEw2JJI=
X-Google-Smtp-Source: ABdhPJw+o/WIatmw938sM1WRneZ+OsKkPqo/jZchMT6rzOFEikxQv/c1LOPQgn3SrLLRQQd2EF/zpBbFVkuMRjdgOQg=
X-Received: by 2002:a05:6602:2dca:: with SMTP id l10mr13834604iow.163.1590909172113;
 Sun, 31 May 2020 00:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk> <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
In-Reply-To: <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 31 May 2020 09:12:46 +0200
Message-ID: <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
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

On Sun, May 31, 2020 at 9:04 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Sun, May 31, 2020 at 3:57 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 5/30/20 12:57 PM, Sedat Dilek wrote:
> > > Here are the numbers with your patchset:
> > >
> > > # cat systemd-analyze-time_5.7.0-rc7-4-amd64-clang_2nd-try.txt
> > > Startup finished in 7.229s (kernel) + 1min 18.304s (userspace) =3D 1m=
in 25.534s
> > > graphical.target reached after 1min 18.286s in userspace
> >
> > Can you see if this makes a difference?
> >
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index c296463c15eb..ccb895f911b1 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -374,8 +374,7 @@ enum req_flag_bits {
> >  #define REQ_INTEGRITY          (1ULL << __REQ_INTEGRITY)
> >  #define REQ_FUA                        (1ULL << __REQ_FUA)
> >  #define REQ_PREFLUSH           (1ULL << __REQ_PREFLUSH)
> > -#define REQ_RAHEAD             \
> > -       ((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
> > +#define REQ_RAHEAD             (1ULL << __REQ_RAHEAD)
> >  #define REQ_BACKGROUND         (1ULL << __REQ_BACKGROUND)
> >  #define REQ_NOWAIT             (1ULL << __REQ_NOWAIT)
> >  #define REQ_CGROUP_PUNT                (1ULL << __REQ_CGROUP_PUNT)
> >
>
> Looks good!
>
> With your patch I now get...
>
> # cat systemd-analyze-time_5.7.0-rc7-6-amd64-clang.txt
> Startup finished in 6.199s (kernel) + 45.143s (userspace) =3D 51.343s
> graphical.target reached after 45.123s in userspace
>
> # cat systemd-analyze-blame_5.7.0-rc7-6-amd64-clang.txt
> 25.029s udisks2.service
> 24.582s accounts-daemon.service
> 19.257s dev-sdc2.device
> 18.016s polkit.service
> 17.857s avahi-daemon.service
> 17.730s NetworkManager.service
> 17.433s rtkit-daemon.service
> 16.558s switcheroo-control.service
> 16.547s wpa_supplicant.service
> 16.538s systemd-logind.service
> 16.078s smartmontools.service
> 14.982s fwupd-refresh.service
> 14.580s NetworkManager-wait-online.service
> 13.630s zramswap.service
> 11.286s fwupd.service
>  8.153s rsyslog.service
>  6.858s gpm.service
>  6.835s e2scrub_reap.service
>  6.449s ModemManager.service
>  6.439s networking.service
>  5.881s packagekit.service
>  3.696s systemd-udevd.service
>  3.322s apparmor.service
>  3.277s exim4.service
>  2.910s alsa-restore.service
>  1.611s systemd-tmpfiles-setup.service
>  1.540s bluetooth.service
>  1.448s systemd-journal-flush.service
>  1.353s keyboard-setup.service
>  1.322s atd.service
>  1.239s systemd-modules-load.service
>  1.216s binfmt-support.service
>  1.060s modprobe@drm.service
>   994ms systemd-journald.service
>   983ms upower.service
>   937ms systemd-sysusers.service
>   914ms ifupdown-wait-online.service
>   904ms pppd-dns.service
>   710ms systemd-udev-trigger.service
>   666ms dev-hugepages.mount
>   650ms dev-mqueue.mount
>   649ms sys-kernel-debug.mount
>   647ms sys-kernel-tracing.mount
>   607ms console-setup.service
>   590ms systemd-tmpfiles-setup-dev.service
>   570ms systemd-timesyncd.service
>   508ms systemd-random-seed.service
>   461ms systemd-backlight@backlight:intel_backlight.service
>   433ms user@1000.service
>   422ms systemd-remount-fs.service
>   365ms systemd-sysctl.service
>   279ms kmod-static-nodes.service
>   246ms proc-sys-fs-binfmt_misc.mount
>   202ms systemd-rfkill.service
>   130ms systemd-user-sessions.service
>   104ms systemd-update-utmp.service
>    25ms user-runtime-dir@1000.service
>    14ms systemd-update-utmp-runlevel.service
>     6ms sys-fs-fuse-connections.mount
>     4ms ifupdown-pre.service
>
> # cat systemd-analyze-critical-chain_5.7.0-rc7-6-amd64-clang.txt
> The time when unit became active or started is printed after the "@" char=
acter.
> The time the unit took to start is printed after the "+" character.
>
> graphical.target @45.123s
> =E2=94=94=E2=94=80multi-user.target @45.122s
>   =E2=94=94=E2=94=80exim4.service @41.842s +3.277s
>     =E2=94=94=E2=94=80network-online.target @41.840s
>       =E2=94=94=E2=94=80NetworkManager-wait-online.service @27.259s +14.5=
80s
>         =E2=94=94=E2=94=80NetworkManager.service @9.522s +17.730s
>           =E2=94=94=E2=94=80dbus.service @9.514s
>             =E2=94=94=E2=94=80basic.target @9.328s
>               =E2=94=94=E2=94=80sockets.target @9.327s
>                 =E2=94=94=E2=94=80dbus.socket @9.327s
>                   =E2=94=94=E2=94=80sysinit.target @9.202s
>
> =E2=94=94=E2=94=80systemd-backlight@backlight:intel_backlight.service @21=
.927s +461ms
>                       =E2=94=94=E2=94=80system-systemd\x2dbacklight.slice=
 @21.925s
>                         =E2=94=94=E2=94=80system.slice @2.529s
>                           =E2=94=94=E2=94=80-.slice @2.529s
>
> Will you send a separate patch on this?
>
> Feel free to add:
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> My kernel-config and dmesg-output are attached.
>
> Thanks Jens!
>

2nd-try (reboot into system with activated WLAN before startup)...

# systemd-analyze --no-pager time
Startup finished in 6.044s (kernel) + 41.370s (userspace) =3D 47.414s
graphical.target reached after 40.431s in userspace

# systemd-analyze --no-pager blame | head -20
24.674s udisks2.service
24.348s accounts-daemon.service
19.504s dev-sdc2.device
18.677s polkit.service
18.283s avahi-daemon.service
18.231s NetworkManager.service
17.918s rtkit-daemon.service
16.948s switcheroo-control.service
16.932s wpa_supplicant.service
16.928s systemd-logind.service
15.335s smartmontools.service
14.063s zramswap.service
11.507s NetworkManager-wait-online.service
11.279s rsyslog.service
 7.490s gpm.service
 6.556s packagekit.service
 6.506s networking.service
 6.446s e2scrub_reap.service
 5.404s ModemManager.service
 3.329s systemd-udevd.service

# systemd-analyze critical-chain
The time when unit became active or started is printed after the "@" charac=
ter.
The time the unit took to start is printed after the "+" character.

graphical.target @40.431s
=E2=94=94=E2=94=80multi-user.target @40.431s
  =E2=94=94=E2=94=80exim4.service @38.726s +1.701s
    =E2=94=94=E2=94=80network-online.target @38.723s
      =E2=94=94=E2=94=80NetworkManager-wait-online.service @27.215s +11.507=
s
        =E2=94=94=E2=94=80NetworkManager.service @8.978s +18.231s
          =E2=94=94=E2=94=80dbus.service @8.971s
            =E2=94=94=E2=94=80basic.target @8.862s
              =E2=94=94=E2=94=80sockets.target @8.861s
                =E2=94=94=E2=94=80dbus.socket @8.861s
                  =E2=94=94=E2=94=80sysinit.target @8.723s

=E2=94=94=E2=94=80systemd-backlight@backlight:intel_backlight.service @20.5=
55s +812ms
                      =E2=94=94=E2=94=80system-systemd\x2dbacklight.slice @=
19.665s
                        =E2=94=94=E2=94=80system.slice @2.473s
                          =E2=94=94=E2=94=80-.slice @2.473s

Nice!

- Sedat -
