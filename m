Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341323BF7E6
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 12:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhGHKF2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 06:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhGHKF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 06:05:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E26C061574
        for <io-uring@vger.kernel.org>; Thu,  8 Jul 2021 03:02:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so8606509ejg.8
        for <io-uring@vger.kernel.org>; Thu, 08 Jul 2021 03:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WfLv+iEwjQwtjZrGnqUiPlIT948XwdXkatugmFcZhIY=;
        b=agcc6L6P9iX+JZ42KSTuaB7GhwLcgeN+t+yx9H6HI3F4y3qV3WqPn2/XqgXi/G4HWG
         /nP44n7kO6QM3vdOU3TUOzrjdJhMbPLT6SPpVwiMe7XaHiEAf/YhMLTrMNkSTv0TfqTt
         jo4X5llc2FA6kiKul+V4SjCPBV9sh+nBvS8lUGx73zImL4L/iqgvDXBg3zKw8JV7uz2O
         x8iqQqysgJScl8dydX8uE35TPvieQzta/vP5wUmHA+fhIljZo+x/t4ThBLF/k1ByOrPU
         A4iZxKobTQ6/srB1aEDM41vz/9QgCiDaoXmDWBjTftdwWcG7NWY/h8Amyr8St1i58gBL
         XCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WfLv+iEwjQwtjZrGnqUiPlIT948XwdXkatugmFcZhIY=;
        b=qf/S0CK+HXlbbekGGbQqalrY+LaPxDLbG0Pr2JGojnE1/tM7s2vkkikVg5feqzhk+i
         KKqi/2NDc++yMLzFgFn3EmhlhW2+17iJTmvDDI+BXK1OnBbkd7XJ1kqyDJoQhu/4yuyd
         7ycYsdZbQTnXdYdgDD/jCqQycy2IfvIFvOknWdjZZhpcEpmDAHuOtvjhKXQ2Vi13Q/3e
         ujshv1mkB9Md65uBe1cxTPIwJDwChD8RmpCfZtczczsjgWFLbLiWMwg7qG/DjWhSLz5u
         gzIO3UoEV2XsdmUwVt2iMYmwy29qQmOMWwi09uSskHEr0hNxpNn2Jrn8cPz9MLhvYD79
         TrEg==
X-Gm-Message-State: AOAM530XUrVRbvSIDNx9hl6pBEQRqb7YnlOVq2EEkMYIVbFiXSneOlqm
        mlvv2NoHTunNbdImfnOKjX/U1YKQC+gjuV1gKd0=
X-Google-Smtp-Source: ABdhPJxv/Y8oQzXq1JgwhYvj9ttBa0vMZY7kuiy9juOmErA9hfOW/e024ngiF9bvAoNptb3moWlp73NertVafmiLIM8=
X-Received: by 2002:a17:906:3006:: with SMTP id 6mr30324801ejz.73.1625738565206;
 Thu, 08 Jul 2021 03:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f2Nmu_XNjE8SM+jzfaNZfzyFowN3Cf8Lgw36FT+gqqPAg@mail.gmail.com>
 <CAEO-eVO_hEvGzoUdoExs67ybfQC0WgpwOLbg3n9fc+R4JfikZQ@mail.gmail.com>
 <CAD14+f077PmD7ymmnoi6kCqeEviUO2xPecCxVxT+-4PukFARpg@mail.gmail.com> <CAEO-eVM49rB_a21hiQdpK_FQYPy=mUKtLuh4Aa2J3fGhw91isg@mail.gmail.com>
In-Reply-To: <CAEO-eVM49rB_a21hiQdpK_FQYPy=mUKtLuh4Aa2J3fGhw91isg@mail.gmail.com>
From:   Juhyung Park <qkrwngud825@gmail.com>
Date:   Thu, 8 Jul 2021 19:02:33 +0900
Message-ID: <CAD14+f2c2JXOUJDyoN8u93pp1Myf=-HpZoTFtvpRVrBL-OQE6Q@mail.gmail.com>
Subject: Re: Possible io_uring regression with QEMU on Ubuntu's kernel
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kamal.

On Sat, Jul 3, 2021 at 2:33 AM Kamal Mostafa <kamal@canonical.com> wrote:
>
> Hi Juhyung-
> [trimmed the cc: list for now]

Let me add Jens and io-uring list back, juuust in case this affects
mainline too in a way that I didn't notice.

>
> We don't doubt it.  Before we ask you to start trying all the intervening=
 kernels, let's try one more targeted shot.  Here's another test kernel whi=
ch is 5.8.0-59 with a set of md/raid patches reverted.  Those patches -- ba=
ckports targeting the bug "raid10: Block discard is very slow" https://bugs=
.launchpad.net/ubuntu/+source/linux/+bug/1896578 -- landed in 5.8.0-56.63_2=
0.04.1.
>
> https://kernel.ubuntu.com/~kamal/uring-mdrevert1/
>
> TEST KERNEL 5.8.0-59.66~20.04.1+mdrevert1
>
> Revert "md: add md_submit_discard_bio() for submitting discard bio"
>
> Revert "md/raid10: extend r10bio devs to raid disks"
>
> Revert "md/raid10: pull the code that wait for blocked dev into one funct=
ion"
>
> Revert "md/raid10: improve raid10 discard request"
>
> Revert "md/raid10: improve discard request for far layout"
>
> Revert "dm raid: remove unnecessary discard limits for raid0 and raid10"
>

The 3950X machine that had this issue as well didn't use a md device
to QEMU and simply used a partition under an NVMe device, so it was
unlikely that an md patch would cause the issue.

I've set up a kernel build environment and manually bisected the issue
(hence the delayed reply, apologies).

It was the commit 87c9cfe0fa1fb ("block: don't ignore REQ_NOWAIT for
direct IO").
(Upstream commit f8b78caf21d5bc3fcfc40c18898f9d52ed1451a5)

I've double checked by resetting the Git to
Ubuntu-hwe-5.8-5.8.0-59.66_20.04.1 and reverting that patch alone.
It fixes the issue.

It seems like this patch was backported to multiple stable trees, so
I'm not exactly sure why only Canonical's 5.8 is affected.
FWIW, 5.8.0-61 is also affected.

>
> Also (regardless of the outcome of that test kernel), we would like to st=
art tracking this with a Launchpad.net bug.  If you'd be so kind as to file=
 one via https://bugs.launchpad.net/ubuntu/+source/linux/+filebug it would =
be much appreciated.
>

Yep, will do this as well.

Thanks.

>  -Kamal
>
>
>>
>> On Fri, Jul 2, 2021 at 2:50 AM Kamal Mostafa <kamal@canonical.com> wrote=
:
>> >
>> > Hi-
>> >
>> > Thanks very much for reporting this.  We picked up that patch ("io_uri=
ng: don't mark S_ISBLK async work as unbounded") for our Ubuntu v5.8 kernel=
 from linux-stable/v5.10.31.  Since it's not clear that it's appropriate fo=
r v5.8 (or even v5.10-stable?) we'll revert it from Ubuntu v5.8 if you can =
confirm that actually fixes the problem.
>> >
>> > Here's a test build of that (5.8.0-59 with that commit reverted).  The=
 full set of packages is provided, but you probably only actually need to i=
nstall the linux-image and linux-modules[-extra] deb's. We'll stand by for =
your results:
>> > https://kernel.ubuntu.com/~kamal/uringrevert0/
>> >
>> > Thanks again,
>> >
>> >  -Kamal Mostafa (Canonical Kernel Team)
>> >
>> > On Wed, Jun 30, 2021 at 1:47 AM Juhyung Park <qkrwngud825@gmail.com> w=
rote:
>> >>
>> >> Hi everyone.
>> >>
>> >> With the latest Ubuntu 20.04's HWE kernel 5.8.0-59, I'm noticing some
>> >> weirdness when using QEMU/libvirt with the following storage
>> >> configuration:
>> >>
>> >> <disk type=3D"block" device=3D"disk">
>> >>   <driver name=3D"qemu" type=3D"raw" cache=3D"none" io=3D"io_uring"
>> >> discard=3D"unmap" detect_zeroes=3D"unmap"/>
>> >>   <source dev=3D"/dev/disk/by-id/md-uuid-df271a1e:9dfb7edb:8dc4fbb8:c=
43e652f-part1"
>> >> index=3D"1"/>
>> >>   <backingStore/>
>> >>   <target dev=3D"vda" bus=3D"virtio"/>
>> >>   <alias name=3D"virtio-disk0"/>
>> >>   <address type=3D"pci" domain=3D"0x0000" bus=3D"0x07" slot=3D"0x00" =
function=3D"0x0"/>
>> >> </disk>
>> >>
>> >> QEMU version is 5.2+dfsg-9ubuntu3 and libvirt version is 7.0.0-2ubunt=
u2.
>> >>
>> >> The guest VM is unable to handle I/O properly with io_uring, and
>> >> nuking io=3D"io_uring" fixes the issue.
>> >> On one machine (EPYC 7742), the partition table cannot be read and on
>> >> another (Ryzen 9 3950X), ext4 detects weirdness with journaling and
>> >> ultimately remounts the guest disk to R/O:
>> >>
>> >> [    2.712321] virtio_blk virtio5: [vda] 3906519775 512-byte logical
>> >> blocks (2.00 TB/1.82 TiB)
>> >> [    2.714054] vda: detected capacity change from 0 to 2000138124800
>> >> [    2.963671] blk_update_request: I/O error, dev vda, sector 0 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.964909] Buffer I/O error on dev vda, logical block 0, async pa=
ge read
>> >> [    2.966021] blk_update_request: I/O error, dev vda, sector 1 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.967177] Buffer I/O error on dev vda, logical block 1, async pa=
ge read
>> >> [    2.968330] blk_update_request: I/O error, dev vda, sector 2 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.969504] Buffer I/O error on dev vda, logical block 2, async pa=
ge read
>> >> [    2.970767] blk_update_request: I/O error, dev vda, sector 3 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.971624] Buffer I/O error on dev vda, logical block 3, async pa=
ge read
>> >> [    2.972170] blk_update_request: I/O error, dev vda, sector 4 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.972728] Buffer I/O error on dev vda, logical block 4, async pa=
ge read
>> >> [    2.973308] blk_update_request: I/O error, dev vda, sector 5 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.973920] Buffer I/O error on dev vda, logical block 5, async pa=
ge read
>> >> [    2.974496] blk_update_request: I/O error, dev vda, sector 6 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.975093] Buffer I/O error on dev vda, logical block 6, async pa=
ge read
>> >> [    2.975685] blk_update_request: I/O error, dev vda, sector 7 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.976295] Buffer I/O error on dev vda, logical block 7, async pa=
ge read
>> >> [    2.980074] blk_update_request: I/O error, dev vda, sector 0 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.981104] Buffer I/O error on dev vda, logical block 0, async pa=
ge read
>> >> [    2.981786] blk_update_request: I/O error, dev vda, sector 1 op
>> >> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> >> [    2.982083] ixgbe 0000:06:00.0: Multiqueue Enabled: Rx Queue count
>> >> =3D 63, Tx Queue count =3D 63 XDP Queue count =3D 0
>> >> [    2.982442] Buffer I/O error on dev vda, logical block 1, async pa=
ge read
>> >> [    2.983642] ldm_validate_partition_table(): Disk read failed.
>> >>
>> >> Kernel 5.8.0-55 is fine, and the only io_uring-related change between
>> >> 5.8.0-55 and 5.8.0-59 is the commit 4b982bd0f383 ("io_uring: don't
>> >> mark S_ISBLK async work as unbounded").
>> >>
>> >> The weird thing is that this commit was first introduced with v5.12,
>> >> but neither the mainline v5.12.0 or v5.13.0 is affected by this issue=
.
>> >>
>> >> I guess one of these commits following the backported commit from
>> >> v5.12 fixes the issue, but that's just a guess. It might be another
>> >> earlier commit:
>> >> c7d95613c7d6 io_uring: fix early sqd_list removal sqpoll hangs
>> >> 9728463737db io_uring: fix rw req completion
>> >> 6ad7f2332e84 io_uring: clear F_REISSUE right after getting it
>> >> e82ad4853948 io_uring: fix !CONFIG_BLOCK compilation failure
>> >> 230d50d448ac io_uring: move reissue into regular IO path
>> >> 07204f21577a io_uring: fix EIOCBQUEUED iter revert
>> >> 696ee88a7c50 io_uring/io-wq: protect against sprintf overflow
>> >>
>> >> It would be much appreciated if Jens could give pointers to Canonical
>> >> developers on how to fix the issue, and hopefully a suggestion to
>> >> prevent this from happening again.
>> >>
>> >> Thanks,
>> >> Regards
