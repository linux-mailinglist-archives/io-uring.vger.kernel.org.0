Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFBE1E933C
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 20:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgE3S5Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 14:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgE3S5Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 14:57:25 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8397C03E969;
        Sat, 30 May 2020 11:57:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 9so5637327ilg.12;
        Sat, 30 May 2020 11:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=vODm+pXurH+rBfuwvyKxRprP7RJ4Xx9eWH1gUxDg1F8=;
        b=hp47LxpmBqAsrQzmTLhFdp8driONb7WsBHUZ3QGAuKXSlQ2GeCjy3XtyfQ37AJsuv0
         v8ptYf668iGB7LkxdiNcyetR2Bqu7AD9kCwQfxfgffffbbC2Y1HQVft6ddUBiN0XSRhR
         cSilpBR1zC1ZhX1JZW9nb/DDni9bmRubFheGK+IBzjUoj4dkUoxbDH7/wezM18AIu3QS
         bJbbXmbRzIDLl7pFzSABR+DGPVxS5sx2gZH3tu+kiD2cwwmwMq9GJoIngmToVwyuwrU1
         Mw4VQxA3LgcIXT8XXK1wEwsnsQxk7NIevv9lBGWef2uJR/snphsFvXpIKJBg7vxfQsFt
         ceJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=vODm+pXurH+rBfuwvyKxRprP7RJ4Xx9eWH1gUxDg1F8=;
        b=WeR3WRL19Jr2HGGobDLV/csSt+RBTDvS03L2LS3kJyMPi0vRS0GCfOmQlK24vl2zlg
         SwbY0I8eThyem02afhd10Im7rRWn3rIR9rqkjTXGsBzjrpXB1dUITTQRnARsXuoJgM1J
         Nc91oKQUcEeBt1PD1Hz2ANxOSlDHiAclU3qFLFGrs703ZjnfD7ZDtMPiYCmVgFqXvi6k
         9bgSyB6Dx0DTiywNafquHf5UX7RgMFhq0gXEfs/0yW7Wr6FwPVsl5Cv4oMSDPJVsFcuH
         sjQ9VWXA7IrNyD3p8E5D8Z6ZHSZgxW9vnag+3mFnLzLNB0awYcgShXoufPLr2gUONY57
         1HHg==
X-Gm-Message-State: AOAM531WNVry4vrJAIwaWwkl5PowXskoriMxtchCDvwKQE8XwusJ/Wzw
        vNfKcE6K5n1MmNeJZ8O1lBc8IRh2fGpB5/oynJs=
X-Google-Smtp-Source: ABdhPJw+2SR3yHbttga54tUzhsEtNDzRlHsiEJDPdmyoz0n6/2wsqN3X0RB1Z9JxDmFVyVv8TbBcg/J8uuz0k0pCfPs=
X-Received: by 2002:a92:898e:: with SMTP id w14mr13245573ilk.212.1590865044128;
 Sat, 30 May 2020 11:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com> <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
In-Reply-To: <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 30 May 2020 20:57:16 +0200
Message-ID: <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
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

Here are the numbers with your patchset:

# cat systemd-analyze-time_5.7.0-rc7-4-amd64-clang_2nd-try.txt
Startup finished in 7.229s (kernel) + 1min 18.304s (userspace) = 1min 25.534s
graphical.target reached after 1min 18.286s in userspace

# cat systemd-analyze-blame_5.7.0-rc7-4-amd64-clang_2nd-try.txt
53.727s udisks2.service
47.043s accounts-daemon.service
40.252s NetworkManager.service
38.916s polkit.service
38.730s smartmontools.service
36.970s zramswap.service
35.556s dev-sdc2.device
30.307s switcheroo-control.service
29.179s wpa_supplicant.service
29.051s avahi-daemon.service
28.817s rtkit-daemon.service
27.697s systemd-logind.service
23.913s rsyslog.service
22.616s NetworkManager-wait-online.service
22.357s e2scrub_reap.service
19.579s gpm.service
14.879s ModemManager.service
14.126s packagekit.service
14.047s networking.service
 6.137s alsa-restore.service
 5.330s exim4.service
 4.331s systemd-udevd.service
 3.954s apparmor.service
 2.606s atd.service
 2.342s modprobe@drm.service
 2.046s systemd-journal-flush.service
 1.519s bluetooth.service
 1.459s systemd-journald.service
 1.386s systemd-udev-trigger.service
 1.271s systemd-modules-load.service
 1.210s keyboard-setup.service
 1.136s systemd-sysusers.service
  930ms upower.service
  896ms pppd-dns.service
  826ms systemd-tmpfiles-setup.service
  807ms dev-hugepages.mount
  807ms dev-mqueue.mount
  806ms sys-kernel-debug.mount
  806ms sys-kernel-tracing.mount
  712ms ifupdown-wait-online.service
  617ms systemd-remount-fs.service
  588ms systemd-timesyncd.service
  509ms binfmt-support.service
  506ms systemd-backlight@backlight:intel_backlight.service
  497ms systemd-random-seed.service
  490ms systemd-rfkill.service
  376ms user@1000.service
  343ms systemd-tmpfiles-setup-dev.service
  305ms console-setup.service
  303ms systemd-update-utmp.service
  300ms systemd-user-sessions.service
  295ms kmod-static-nodes.service
  267ms systemd-sysctl.service
   71ms proc-sys-fs-binfmt_misc.mount
   19ms user-runtime-dir@1000.service
   13ms systemd-update-utmp-runlevel.service
    5ms sys-fs-fuse-connections.mount
    4ms ifupdown-pre.service

[ diffconfig ]

$ scripts/diffconfig /boot/config-5.7.0-rc7-2-amd64-clang
/boot/config-5.7.0-rc7-4-amd64-clang
 BUILD_SALT "5.7.0-rc7-2-amd64-clang" -> "5.7.0-rc7-4-amd64-clang"
+BLK_INLINE_ENCRYPTION n

- Sedat -


- Sedat -
