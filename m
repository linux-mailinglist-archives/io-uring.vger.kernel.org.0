Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219E87ACA9A
	for <lists+io-uring@lfdr.de>; Sun, 24 Sep 2023 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjIXPp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Sep 2023 11:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXPp6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Sep 2023 11:45:58 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED6EC6;
        Sun, 24 Sep 2023 08:45:51 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-4963a2e3aa6so4297903e0c.0;
        Sun, 24 Sep 2023 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695570350; x=1696175150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxAiqV0SbR0M9A07Lt2yaycJ8W97vQp/Mh06hMDHTLs=;
        b=OddJYccUQVjQDnMGnlvt7ukZyO9vK07HESjbEWWZmFK4ySvNmb9ACM71eIT7evAoKB
         Dg23ul5qd1GTZasEod9bq+88MvhA9ZGsDA+oRXkFc22iqVDFnWAA8Ubn3UoB11Btu0VX
         a6tlzEbJX8bbQe73DH/upJwjGmsGQ0USC7fdsmldwFB1okb7mBafuPGtQhgOi6dZUs4X
         G2pWhG9XRxFMpTS9hshwYU5MqQNMq1x0WNBjPYo6rNKZCM6PZipbJMA/RdmFt2MTsz7q
         FZd0QZZvMpDl85wUttTIF2d2oBzaIve5i1EXcInrqfnBUx1h8w5+mDndyGP2+SblKsZO
         mzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695570350; x=1696175150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxAiqV0SbR0M9A07Lt2yaycJ8W97vQp/Mh06hMDHTLs=;
        b=GVt1WBffT0E4LxPvKobtwyM1LvjXwvKcVjTQhKmqG2o+/W6Ku9w/ndrX3RToQQdH+r
         xdOx1bcV6gZoeqBbbCIsIQ+ozo5Yuko0ET3bWAV1kxtNLqdW9FoRV/rS1il+dsL97Xb+
         lt1zZR9X+mjasmsz6yrv7jy9cj/yVg4rMxM/d69j/VnTLF7mr3/vF2ls8MQ789VhuV9O
         AF1Ysb3YpcZ9XjyfPvK4j0N9De7EKpvPvzV0XWWbK7sPNI5LnoqeKaZ29Af7t7fP8zS6
         10R6l5xg/qNcxUyfsNYdTqOFv7QxbOGfHMwgHY4yy+tpR16V5F1w/iOz0JuFyJqacVng
         OOUw==
X-Gm-Message-State: AOJu0YyAVcBUiCkXiduUbBuWOXKzshUxYEFMittp5HUjgR7pHNYzVHEk
        vQ09rOMM/Cd7twJERffjeJU4Ww/qydfrIUVhrciiMRmboYY=
X-Google-Smtp-Source: AGHT+IEiH3fl59g8Ui3OUaphdb0rqJmQnbWe+Q0ZM31wZvzcRsCSdzMErzFME0BWADpvc2MlBNdMbxZDaF5ZqZjVYwQ=
X-Received: by 2002:ac5:c913:0:b0:495:c8bb:f0f8 with SMTP id
 t19-20020ac5c913000000b00495c8bbf0f8mr3581640vkl.3.1695570349689; Sun, 24 Sep
 2023 08:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Sep 2023 18:45:38 +0300
Message-ID: <CAOQ4uxgpC-qgE0BvtBYW0JfqyJ-Yf8jj84wLwm+6XzRrjNsXHg@mail.gmail.com>
Subject: Re: [xfstests generic/617] fsx io_uring dio starts to fail on
 overlayfs since v6.6-rc1
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, io-uring@vger.kernel.org,
        fstests@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 24, 2023 at 6:15=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> Hi,
>
> The generic/617 of fstests is a test case does IO_URING soak direct-IO
> fsx test, but recently (about from v6.6-rc1 to now) it always fails on
> overlayfs as [1], no matter the underlying fs is ext4 or xfs. But it
> never failed on overlay before, likes [2].
>
> So I thought it might be a regression of overlay or io-uring on current v=
6.6.
> Please help to review, it's easy to reproduce. My system is Fedora-rawhid=
e/RHEL-9,
> with upstream mainline linux HEAD=3Ddc912ba91b7e2fa74650a0fc22cccf0e0d50f=
371.
> The generic/617.full output as [3].
>

Hi Zorro,

Thank you for the report.
I am on public holiday, so it may take me a few days to get to look at this=
.
In the meanwhile could you try to bisect if the regression is introduced
by this vfs PR merge (of my patches):

 *   de16588a7737 - Merge tag 'v6.6-vfs.misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
|\
| * e6fa4c728fb6 - cachefiles: use kiocb_{start,end}_write() helpers
| * 8f7371268a4b - ovl: use kiocb_{start,end}_write() helpers
| * 8c3cfa80fd1e - aio: use kiocb_{start,end}_write() helpers
| * e484fd73f4bd - io_uring: use kiocb_{start,end}_write() helpers

The io_uring PR merge:

*   c1b7fcf3f6d9 - Merge tag 'for-6.6/io_uring-2023-08-28' of
git://git.kernel.dk/linux

Or the overlayfs PR merge:

*   63580f669d7f - Merge tag 'ovl-update-6.6' of
git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs

Thanks,
Amir.

>
> [1]
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 dell-xxxx-xxx 6.6.0-rc2+ #1 SMP PREEMPT_DYN=
AMIC Fri Sep 22 15:41:10 EDT 2023
> MKFS_OPTIONS  -- -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,inobtcount=
=3D1,bigtime=3D1 /mnt/xfstests/scratch
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /mnt/xfstests/s=
cratch /mnt/xfstests/scratch/ovl-mnt
>
> generic/617       - output mismatch (see /var/lib/xfstests/results//gener=
ic/617.out.bad)
>     --- tests/generic/617.out   2023-09-22 16:08:35.444572181 -0400
>     +++ /var/lib/xfstests/results//generic/617.out.bad  2023-09-22 19:33:=
29.240901008 -0400
>     @@ -1,2 +1,54 @@
>      QA output created by 617
>     +uring write bad io length: 0 instead of 8192
>     +short write: 0x0 bytes instead of 0x2000
>     +LOG DUMP (46 total operations):
>     +1(  1 mod 256): FALLOC   0x28c0d thru 0x2953a      (0x92d bytes) EXT=
ENDING
>     +2(  2 mod 256): TRUNCATE UP        from 0x2953a to 0x81000
>     +3(  3 mod 256): ZERO     0x6f07 thru 0x14790       (0xd88a bytes)
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/generic/617.out /var/lib/xfstes=
ts/results//generic/617.out.bad'  to see the entire diff)
> Ran: generic/617
> Failures: generic/617
> Failed 1 of 1 tests
>
> [2]
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx 6.5.0-rc6+ #1 SMP PREEMPT_DYNA=
MIC Mon Aug 14 12:45:06 UTC 2023
> MKFS_OPTIONS  -- /mnt/scratch
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /mnt/scratch /m=
nt/scratch/ovl-mnt
>
> generic/617        5s
> Ran: generic/617
> Passed all 1 tests
>
> [3]
> /var/lib/xfstests/ltp/fsx -S 0 -U -q -N 20000 -p 200 -o 128000 -l 600000 =
-r 4096 -t 4096 -w 4096 -Z /mnt/xfstests/test/ovl-mnt/junk
> uring write bad io length: 0 instead of 8192
> short write: 0x0 bytes instead of 0x2000
> LOG DUMP (46 total operations):
> 1(  1 mod 256): FALLOC   0x28c0d thru 0x2953a   (0x92d bytes) EXTENDING
> 2(  2 mod 256): TRUNCATE UP     from 0x2953a to 0x81000
> 3(  3 mod 256): ZERO     0x6f07 thru 0x14790    (0xd88a bytes)
> 4(  4 mod 256): ZERO     0x4a097 thru 0x5dfc8   (0x13f32 bytes)
> 5(  5 mod 256): TRUNCATE DOWN   from 0x81000 to 0x10000
> 6(  6 mod 256): MAPWRITE 0x74000 thru 0x78de7   (0x4de8 bytes)
> 7(  7 mod 256): SKIPPED (no operation)
> 8(  8 mod 256): MAPWRITE 0x52000 thru 0x57bf5   (0x5bf6 bytes)
> 9(  9 mod 256): DEDUPE 0x19000 thru 0x20fff     (0x8000 bytes) to 0x57000=
 thru 0x5efff
> 10( 10 mod 256): COPY 0x64000 thru 0x6bfff      (0x8000 bytes) to 0x1c000=
 thru 0x23fff
> 11( 11 mod 256): INSERT 0x38000 thru 0x46fff    (0xf000 bytes)
> 12( 12 mod 256): WRITE    0x16000 thru 0x1cfff  (0x7000 bytes)
> 13( 13 mod 256): MAPWRITE 0x3f000 thru 0x444d5  (0x54d6 bytes)
> 14( 14 mod 256): INSERT 0x83000 thru 0x8cfff    (0xa000 bytes)
> 15( 15 mod 256): COPY 0x54000 thru 0x5dfff      (0xa000 bytes) to 0x6d000=
 thru 0x76fff
> 16( 16 mod 256): PUNCH    0x34f3d thru 0x48c45  (0x13d09 bytes)
> 17( 17 mod 256): FALLOC   0x47bd5 thru 0x5a950  (0x12d7b bytes) INTERIOR
> 18( 18 mod 256): READ     0x20000 thru 0x3cfff  (0x1d000 bytes)
> 19( 19 mod 256): READ     0xe000 thru 0x1cfff   (0xf000 bytes)
> 20( 20 mod 256): MAPREAD  0x70000 thru 0x8d512  (0x1d513 bytes)
> 21( 21 mod 256): PUNCH    0x12773 thru 0x1f5b1  (0xce3f bytes)
> 22( 22 mod 256): DEDUPE 0x81000 thru 0x8ffff    (0xf000 bytes) to 0x3b000=
 thru 0x49fff
> 23( 23 mod 256): CLONE 0x78000 thru 0x7efff     (0x7000 bytes) to 0x1e000=
 thru 0x24fff
> 24( 24 mod 256): MAPREAD  0x1000 thru 0x1b6c1   (0x1a6c2 bytes)
> 25( 25 mod 256): SKIPPED (no operation)
> 26( 26 mod 256): FALLOC   0x43b4c thru 0x5ecb7  (0x1b16b bytes) INTERIOR
> 27( 27 mod 256): SKIPPED (no operation)
> 28( 28 mod 256): WRITE    0x3000 thru 0x8fff    (0x6000 bytes)
> 29( 29 mod 256): COPY 0x19000 thru 0x20fff      (0x8000 bytes) to 0x79000=
 thru 0x80fff
> 30( 30 mod 256): WRITE    0x19000 thru 0x28fff  (0x10000 bytes)
> 31( 31 mod 256): DEDUPE 0x3a000 thru 0x3dfff    (0x4000 bytes) to 0x49000=
 thru 0x4cfff
> 32( 32 mod 256): ZERO     0x8f290 thru 0x927bf  (0x3530 bytes)
> 33( 33 mod 256): PUNCH    0x45aec thru 0x58137  (0x1264c bytes)
> 34( 34 mod 256): SKIPPED (no operation)
> 35( 35 mod 256): FALLOC   0x5b567 thru 0x613ab  (0x5e44 bytes) INTERIOR
> 36( 36 mod 256): ZERO     0x1abc7 thru 0x1bbd6  (0x1010 bytes)
> 37( 37 mod 256): MAPWRITE 0x44000 thru 0x45411  (0x1412 bytes)
> 38( 38 mod 256): FALLOC   0x3b222 thru 0x4de57  (0x12c35 bytes) INTERIOR
> 39( 39 mod 256): COLLAPSE 0x1e000 thru 0x20fff  (0x3000 bytes)
> 40( 40 mod 256): INSERT 0x62000 thru 0x64fff    (0x3000 bytes)
> 41( 41 mod 256): DEDUPE 0xf000 thru 0x16fff     (0x8000 bytes) to 0x78000=
 thru 0x7ffff
> 42( 42 mod 256): WRITE    0x4000 thru 0x12fff   (0xf000 bytes)
> 43( 43 mod 256): COPY 0x62000 thru 0x79fff      (0x18000 bytes) to 0x2000=
 thru 0x19fff
> 44( 44 mod 256): SKIPPED (no operation)
> 45( 45 mod 256): MAPWRITE 0x22000 thru 0x297c9  (0x77ca bytes)
> 46( 46 mod 256): WRITE    0x41000 thru 0x42fff  (0x2000 bytes)
> Log of operations saved to "/mnt/xfstests/test/ovl-mnt/junk.fsxops"; repl=
ay with --replay-ops
> Correct content saved for comparison
> (maybe hexdump "/mnt/xfstests/test/ovl-mnt/junk" vs "/mnt/xfstests/test/o=
vl-mnt/junk.fsxgood")
>
