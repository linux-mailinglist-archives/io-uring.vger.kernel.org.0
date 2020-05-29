Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388561E7BA5
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 13:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgE2LWu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 07:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2LWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 07:22:50 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E75C03E969;
        Fri, 29 May 2020 04:22:49 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so1538761ilm.7;
        Fri, 29 May 2020 04:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=x4/s9euSWU0x60yfYD16U1tfLPQo/KjiUdAhxYIsof0=;
        b=nhRLoJN5nyhV0ObcYIPhWrPyPZUIYSyd0+loBSDg/+Sa5Tm7DCS4P97K7sbT+TKX6w
         ayn5P406wPGBx3ZaUBsTV3k92rbHqcXNnlviRImIR64EvEfO2i7O5uGCGo5ke4YO1lfU
         mpGawYmNnp1NQUUg4oVY+zDnZcsrs/lDNAwbVI0HKxf3zDV1BbDRay+kAVFgDQwKC3es
         rxCGSVes1wKfX85+AwlxGu4tu1Y3NDp/bNM4Bk1AAkDMibj9o/xbU2ejGKJLfL9cNkii
         aAkTFgwj/KQmbcy+x48jX+Z+Efbs/dYctFY1iRe5Ko7hZXLG9Z1io1uzvuEtYk1Eu3On
         UkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=x4/s9euSWU0x60yfYD16U1tfLPQo/KjiUdAhxYIsof0=;
        b=Bk6/HGmlBYTLCZUIVPceSMFq0ANupJEJA81PFWxP5g9CDaCwwmYPxB//d7yDgYNme8
         +ZoeCzKNnnU7ztghEskgNCH66ojiRqP7+fxywVZ98sJUCxSNQEplUhUWjqPTGtPWKcjG
         KGt4Bp/3ktreW+1irwp0D1EEbMpnlIH2mrcrkk9RvG2szev3HTS8fLq9s0GIv7w8lflY
         kWsCPlkui9HIRLas1mMmbvJGKadsIEdSdaQi7ktXwRrVCXSeqPbypHp00XF0WGxmgXop
         w8CSivnwrNC97A+gZ7+OOutcQ0HXDwThqeMVTsZALcrQjjAzfW78C/yTju15EemsfIKV
         lgRA==
X-Gm-Message-State: AOAM533n/r/1YmjuFNag77IK08sB1EIj72rGnAkr6q2VqGA1i4QsOWHw
        1zLQhsidvF7K3E8onjUXpKcHES2Ci8fCCLAsfx8L3xw08Bs=
X-Google-Smtp-Source: ABdhPJxwVVPOcsy+IFnf+7rGXou9+GF93cJIPwSgAq3BUKNEOWWH6WHbiBuXvoI48t8eBUq04eaiFPgz0mejVD1sGew=
X-Received: by 2002:a92:7311:: with SMTP id o17mr7293070ilc.176.1590751368217;
 Fri, 29 May 2020 04:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
In-Reply-To: <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 29 May 2020 13:22:36 +0200
Message-ID: <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
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

On Fri, May 29, 2020 at 12:02 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:

[ ... ]

> As I saw stallings with e2scrub_reap.service and swap partition
> (partly seen in the boot-process and noted the UUID 3f8e).
> I disabled e2scrub_reap.service and deactivated swap partition in /etc/fs=
tab.
>

I switched over from using a swap-partition to a swap-file.

The boot-slowdown is "gone" in sense of 1m30s stalls or better in
sense of boot-time is shorter.

# cat systemd-analyze-time.txt
Startup finished in 6.903s (kernel) + 1min 13.501s (userspace) =3D 1min 20.=
404s
graphical.target reached after 1min 13.481s in userspace

# cat systemd-analyze-time_swapfile.txt
Startup finished in 6.721s (kernel) + 1min 9.470s (userspace) =3D 1min 16.1=
92s
graphical.target reached after 1min 9.451s in userspace

# cat systemd-analyze-blame.txt | head -20
35.943s udisks2.service
32.559s accounts-daemon.service
27.925s smartmontools.service
26.561s NetworkManager.service
24.543s dev-sdc2.device
24.478s polkit.service
20.426s NetworkManager-wait-online.service
19.785s avahi-daemon.service
19.586s switcheroo-control.service
19.185s rtkit-daemon.service
18.661s wpa_supplicant.service
18.269s systemd-logind.service
17.627s rsyslog.service
16.312s gpm.service
14.842s e2scrub_reap.service
14.387s packagekit.service
12.017s ModemManager.service
10.584s alsa-restore.service
 8.407s atd.service
 6.025s exim4.service

# cat systemd-analyze-blame_swapfile.txt | head -20
29.571s udisks2.service
26.383s accounts-daemon.service
24.564s smartmontools.service
20.735s NetworkManager.service
19.254s NetworkManager-wait-online.service
18.675s polkit.service
15.523s dev-sdc2.device
14.152s avahi-daemon.service
14.006s switcheroo-control.service
13.800s rtkit-daemon.service
13.662s packagekit.service
13.353s wpa_supplicant.service
13.178s rsyslog.service
12.788s systemd-logind.service
12.313s e2scrub_reap.service
11.105s ModemManager.service
11.003s gpm.service
10.018s networking.service
 6.608s apparmor.service
 5.858s exim4.service

Thanks.

Time to experience with ZRAM :-).

- Sedat -

LINK: https://wiki.debian.org/Swap
LINK: https://help.ubuntu.com/community/SwapFaq

mount -t auto /dev/sdb1 /mnt/sandisk

fallocate -l 8g /mnt/sandisk/swapfile

8 x 1024 x 1024 =3D 8388608

dd if=3D/dev/zero bs=3D1024 count=3D8388608 of=3D/mnt/sandisk/swapfile
8388608+0 Datens=C3=A4tze ein
8388608+0 Datens=C3=A4tze aus
8589934592 bytes (8,6 GB, 8,0 GiB) copied, 176,511 s, 48,7 MB/s

# chmod 600 /mnt/sandisk/swapfile

# ll /mnt/sandisk/swapfile
-rw------- 1 root root 8,0G Mai 29 12:23 /mnt/sandisk/swapfile

# mkswap /mnt/sandisk/swapfile
Setting up swapspace version 1, size =3D 8 GiB (8589930496 bytes)
no label, UUID=3Dd3b72e81-c0fc-49fa-9704-cbbaba3822fc

# swapon /mnt/sandisk/swapfile

# free -h
              total        used        free      shared  buff/cache   avail=
able
Mem:          7,7Gi       1,6Gi       4,8Gi       167Mi       1,3Gi       5=
,7Gi
Swap:         8,0Gi          0B       8,0Gi

- EOT -
