Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892A1E91C0
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgE3Ngr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgE3Ngq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 09:36:46 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F2CC03E969;
        Sat, 30 May 2020 06:36:46 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j8so2264641iog.13;
        Sat, 30 May 2020 06:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=/NBbRRa5pl9eVO87iKoBTxygo81Ok3+Xzeg/mVPc/EQ=;
        b=jfzFHsKnSjzi3p7xhDfMHYc1AeSJ/trFRssnkJ8A/gcb+l2DqxP8MxyQWQOfaRHrmP
         MdZFppK+Zuwvd/EXRkkCJzWLafKqI96JLac48kk5+bokkrhQm+C9ifO50G7dEc0mUbkp
         y4znc59j6hPCX9V5G1E0++2LIv/Ut1D8yUflQNlmjBDZ9dpXFWXv96spcQL+XJz2hAZf
         rJDPeAXhUK5tnjffqGh07aYZ5mbD7W7RwjV0nwYjm2hmg1x24kZUwY4c/oNRDXhuKoWe
         jssMZzeYRPNY21kOEqy70/0Klm+TtizQdUwykNUhHDh81SaZsNh3lvx8zZR1VE7wX95t
         brvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=/NBbRRa5pl9eVO87iKoBTxygo81Ok3+Xzeg/mVPc/EQ=;
        b=ugqYqfnRiT9kERwZc0r0/jB6icoh1Hgn5Y1XQaUSIDa48MDdLbl/oWpWIrpQ2j9ISt
         MEHhtqN1unI0b08tYGq2Y555ut+cJZtdU+EbGNG0YesrkC5PGExMF9MeWd0KG6QbGv8X
         4vwzulUAF2Bt3H/WtVoHcJcju7LLL10xRkDS3krvcr4TUKHbK+ywlVuMLItRluFTR1Hc
         cnZKvWfkmRw/wzUSpjSIIhBrtTcFsKnk/q51hNXinNL5uMPtjOpEtyffplJd3N1pH+Za
         k2lPZ3IYKS3HHGyqmsxkEFUWzAJ9KJZlsYaCrbC5oK7daUK9XNlzXj3izboRU87rAq8y
         1RNQ==
X-Gm-Message-State: AOAM532HC+gDRA6CyFnYpgicmUtPpde+USLPjgzJDNszEpPw2uMQJH7Z
        p1Ad6pnmFm2voIivUK5lMaVFVYZftwchyQhDHcO8Pe6Dt3E=
X-Google-Smtp-Source: ABdhPJzG40rHq7dlo3ZJjB6ZQt7oeWmTJW4IpXkErnlgoULYIQxKsHlha1AA5a2OR0O9tdBAPKVFwudCxdRYUqdLzII=
X-Received: by 2002:a6b:750c:: with SMTP id l12mr11356161ioh.66.1590845806016;
 Sat, 30 May 2020 06:36:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
In-Reply-To: <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 30 May 2020 15:36:37 +0200
Message-ID: <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
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

> Time to experience with ZRAM :-).

I switched over from swap-file to zramswap.

And I can definitely say, my last kernel w/o your patchset does not
show the symptoms.

# cat systemd-analyze-time_5.7.0-rc7-2-amd64-clang_2nd-try.txt
Startup finished in 6.129s (kernel) + 44.192s (userspace) = 50.322s
graphical.target reached after 44.168s in userspace

# cat systemd-analyze-blame_5.7.0-rc7-2-amd64-clang_2nd-try.txt
24.050s udisks2.service
23.711s accounts-daemon.service
18.615s dev-sdc2.device
17.119s polkit.service
16.980s avahi-daemon.service
16.879s NetworkManager.service
16.112s rtkit-daemon.service
15.126s switcheroo-control.service
15.117s wpa_supplicant.service
15.105s systemd-logind.service
14.475s NetworkManager-wait-online.service
14.258s smartmontools.service
13.161s zramswap.service
 9.522s rsyslog.service
 8.337s gpm.service
 6.026s packagekit.service
 5.871s ModemManager.service
 5.746s networking.service
 5.383s e2scrub_reap.service
 3.960s systemd-udevd.service
 3.396s apparmor.service
 3.231s exim4.service
 2.795s systemd-journal-flush.service
 2.359s alsa-restore.service
 2.186s systemd-rfkill.service
 1.878s atd.service
 1.164s keyboard-setup.service
 1.098s bluetooth.service
 1.089s systemd-tmpfiles-setup.service
 1.021s pppd-dns.service
  968ms systemd-backlight@backlight:intel_backlight.service
  964ms upower.service
  937ms binfmt-support.service
  873ms systemd-modules-load.service
  849ms systemd-sysusers.service
  845ms systemd-journald.service
  683ms systemd-timesyncd.service
  676ms modprobe@drm.service
  641ms systemd-udev-trigger.service
  620ms dev-hugepages.mount
  618ms dev-mqueue.mount
  618ms sys-kernel-debug.mount
  617ms sys-kernel-tracing.mount
  501ms ifupdown-wait-online.service
  434ms systemd-sysctl.service
  419ms systemd-random-seed.service
  413ms systemd-tmpfiles-setup-dev.service
  405ms user@1000.service
  389ms systemd-remount-fs.service
  383ms console-setup.service
  301ms kmod-static-nodes.service
  181ms proc-sys-fs-binfmt_misc.mount
  174ms systemd-update-utmp.service
   85ms systemd-user-sessions.service
   22ms user-runtime-dir@1000.service
   19ms systemd-update-utmp-runlevel.service
    5ms ifupdown-pre.service
    4ms sys-fs-fuse-connections.mount

[ /etc/zramswap.conf ]

ZRAM_SIZE_PERCENT=20
# ZSTD support for ZRAM and ZSWAP requires Linux >= 5.7-rc+. -dileks
ZRAM_COMPRESSION_ALGO=zstd

[ /etc/fstab ]

# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> || <mount point> || <type> || <options> || <dump> || <pass>
#
# Root-FS (here: /dev/sdc2)
UUID=<myUUID>       /       ext4    errors=remount-ro       0       1
# SWAP (here: /dev/zram0)
# Zram-based swap (compressed RAM block devices), for details see
zramswap.service and zramswap.conf

# dmesg | egrep 'zram|zswap'
[    1.041958] zswap: loaded using pool zstd/zbud
[   29.569355] zram: Added device: zram0
[   29.581631] zram0: detected capacity change from 0 to 1647824896
[   30.562279] Adding 1609200k swap on /dev/zram0.  Priority:100
extents:1 across:1609200k SSFS

# cat /sys/devices/virtual/block/zram0/comp_algorithm
lzo lzo-rle lz4 lz4hc [zstd]

# swapon --show
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition 1,5G   0B  100

# cat /proc/swaps
Filename                                Type            Size    Used    Priority
/dev/zram0                              partition       1609200 0       100

If you have any ideas let me know.

Ah, I see there is async-buffered.6.

- Sedat -

[1] https://aur.archlinux.org/packages/zramswap/
[2] https://aur.archlinux.org/cgit/aur.git/tree/zramswap.conf?h=zramswap
[3] https://aur.archlinux.org/cgit/aur.git/tree/zramswap.service?h=zramswap
