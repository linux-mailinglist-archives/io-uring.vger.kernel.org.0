Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B713B9609
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 20:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhGASSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 14:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhGASSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 14:18:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D86C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 11:16:13 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w13so9776029edc.0
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 11:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8lu+cEfvMzXlQ1wgcZvxaMZWS1W+IfZvHbCoMgrm2n8=;
        b=jAwUgGTGR5FGOviuOIlA6AUkWChquEg4EOgiUYb9eubBVc/5vITRWo7LTFMxo23IUX
         TXwHBmvvneCRFGTEY4gpJrVlpJYT8dJcizYabFA6pnCrw/q36mk4e3q8m125F7rmZHwO
         iC5PjEJHxqCdB4SuAfaO3lPRRV4mV5UKtN/HzjExDXLrAC3a5DDG1lfDB0VG9bUHUoAf
         xm2049o8VR/YIOXLYSVE21dKg7Ht47TOFwKouALXeyrJL2lctAI8/cZ2k2BAtVTqQyfB
         6hTe0WrbB1K3n2AqViGSt2GvQUiytjN5axEUgjoAJITQTVNFldlJki0wyiCXAfhEUffn
         jBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8lu+cEfvMzXlQ1wgcZvxaMZWS1W+IfZvHbCoMgrm2n8=;
        b=UO2g1CteYkRJ8rbvuH2YauRrRPoGIdi8sW/glgTzV+7ZySnhOWD+YM8yrYadcXNaZw
         MFzwbPxkmVa3HYsie0QtgpDtmIMEhN0A8yNdWLyuxwD/1X21cUERV9CQ08ZinWOpjuyF
         STXCKELgqOclNHwAXJOVMyCrXxtdCrCVxOGP6bDc7nPyR4IZ+EjgD2OobhedukQjSAMV
         qJjJrMUv3IpL94ZzKemps+eirmBmENM7lgOCl1rXhk0is7Ov1RwZT/rO0GU7TGvzbf+c
         e9gYsL4R0vH5OVwYBRBDVesPOmrC0WnZ3kvvLVF+XJl3kVXzy9S4rezjUrgaUkxOXODu
         nemw==
X-Gm-Message-State: AOAM532DJLT3fi2UaTvIV8O0R0isF6vDuWlG8G006bah/SZ3BHlSEauZ
        NHYL1tVe1O+mj02TNr4Hfz4CbU5vtRkSMoJbDnk=
X-Google-Smtp-Source: ABdhPJyjceZ1SeqxCRGlQmML4g7wgYKb/ZLkgOIEjjiwtzt2kIv6ah9K/lJJodk5OVYATN6kMSshEVDch6Km//5iM3Y=
X-Received: by 2002:a05:6402:5248:: with SMTP id t8mr1608945edd.110.1625163372308;
 Thu, 01 Jul 2021 11:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f2Nmu_XNjE8SM+jzfaNZfzyFowN3Cf8Lgw36FT+gqqPAg@mail.gmail.com>
 <CAEO-eVO_hEvGzoUdoExs67ybfQC0WgpwOLbg3n9fc+R4JfikZQ@mail.gmail.com>
In-Reply-To: <CAEO-eVO_hEvGzoUdoExs67ybfQC0WgpwOLbg3n9fc+R4JfikZQ@mail.gmail.com>
From:   Juhyung Park <qkrwngud825@gmail.com>
Date:   Fri, 2 Jul 2021 03:16:01 +0900
Message-ID: <CAD14+f077PmD7ymmnoi6kCqeEviUO2xPecCxVxT+-4PukFARpg@mail.gmail.com>
Subject: Re: Possible io_uring regression with QEMU on Ubuntu's kernel
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Stefan Bader <stefan.bader@canonical.com>,
        io-uring <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        qemu-devel@nongnu.org,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kamal.

Thanks for the timely response.
We currently worked around the issue by installing linux-generic-hwe-20.04-=
edge.

I've just installed the new build that you provided but I'm afraid the
same issue persists.

I've double-checked that the kernel is installed properly:
root@datai-ampere:~# uname -a
Linux datai-ampere 5.8.0-59-generic #66~20.04.1+uringrevert0 SMP Thu
Jul 1 16:50:12 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@datai-ampere:~# cat /proc/version
Linux version 5.8.0-59-generic (ubuntu@ip-10-0-33-11) (gcc (Ubuntu
9.3.0-17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34)
#66~20.04.1+uringrevert0 SMP Thu Jul 1 16:50:12 UTC 2021

The guest VM is still unable to read /dev/vda's partition table with
READ errors.

Is the commit reverted properly?
If it is, I'm afraid that it might be something else, hmm..

I'm still certain that it's a regression from 5.8.0-55 to 5.8.0-59.

Thanks.

On Fri, Jul 2, 2021 at 2:50 AM Kamal Mostafa <kamal@canonical.com> wrote:
>
> Hi-
>
> Thanks very much for reporting this.  We picked up that patch ("io_uring:=
 don't mark S_ISBLK async work as unbounded") for our Ubuntu v5.8 kernel fr=
om linux-stable/v5.10.31.  Since it's not clear that it's appropriate for v=
5.8 (or even v5.10-stable?) we'll revert it from Ubuntu v5.8 if you can con=
firm that actually fixes the problem.
>
> Here's a test build of that (5.8.0-59 with that commit reverted).  The fu=
ll set of packages is provided, but you probably only actually need to inst=
all the linux-image and linux-modules[-extra] deb's. We'll stand by for you=
r results:
> https://kernel.ubuntu.com/~kamal/uringrevert0/
>
> Thanks again,
>
>  -Kamal Mostafa (Canonical Kernel Team)
>
> On Wed, Jun 30, 2021 at 1:47 AM Juhyung Park <qkrwngud825@gmail.com> wrot=
e:
>>
>> Hi everyone.
>>
>> With the latest Ubuntu 20.04's HWE kernel 5.8.0-59, I'm noticing some
>> weirdness when using QEMU/libvirt with the following storage
>> configuration:
>>
>> <disk type=3D"block" device=3D"disk">
>>   <driver name=3D"qemu" type=3D"raw" cache=3D"none" io=3D"io_uring"
>> discard=3D"unmap" detect_zeroes=3D"unmap"/>
>>   <source dev=3D"/dev/disk/by-id/md-uuid-df271a1e:9dfb7edb:8dc4fbb8:c43e=
652f-part1"
>> index=3D"1"/>
>>   <backingStore/>
>>   <target dev=3D"vda" bus=3D"virtio"/>
>>   <alias name=3D"virtio-disk0"/>
>>   <address type=3D"pci" domain=3D"0x0000" bus=3D"0x07" slot=3D"0x00" fun=
ction=3D"0x0"/>
>> </disk>
>>
>> QEMU version is 5.2+dfsg-9ubuntu3 and libvirt version is 7.0.0-2ubuntu2.
>>
>> The guest VM is unable to handle I/O properly with io_uring, and
>> nuking io=3D"io_uring" fixes the issue.
>> On one machine (EPYC 7742), the partition table cannot be read and on
>> another (Ryzen 9 3950X), ext4 detects weirdness with journaling and
>> ultimately remounts the guest disk to R/O:
>>
>> [    2.712321] virtio_blk virtio5: [vda] 3906519775 512-byte logical
>> blocks (2.00 TB/1.82 TiB)
>> [    2.714054] vda: detected capacity change from 0 to 2000138124800
>> [    2.963671] blk_update_request: I/O error, dev vda, sector 0 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.964909] Buffer I/O error on dev vda, logical block 0, async page =
read
>> [    2.966021] blk_update_request: I/O error, dev vda, sector 1 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.967177] Buffer I/O error on dev vda, logical block 1, async page =
read
>> [    2.968330] blk_update_request: I/O error, dev vda, sector 2 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.969504] Buffer I/O error on dev vda, logical block 2, async page =
read
>> [    2.970767] blk_update_request: I/O error, dev vda, sector 3 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.971624] Buffer I/O error on dev vda, logical block 3, async page =
read
>> [    2.972170] blk_update_request: I/O error, dev vda, sector 4 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.972728] Buffer I/O error on dev vda, logical block 4, async page =
read
>> [    2.973308] blk_update_request: I/O error, dev vda, sector 5 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.973920] Buffer I/O error on dev vda, logical block 5, async page =
read
>> [    2.974496] blk_update_request: I/O error, dev vda, sector 6 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.975093] Buffer I/O error on dev vda, logical block 6, async page =
read
>> [    2.975685] blk_update_request: I/O error, dev vda, sector 7 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.976295] Buffer I/O error on dev vda, logical block 7, async page =
read
>> [    2.980074] blk_update_request: I/O error, dev vda, sector 0 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.981104] Buffer I/O error on dev vda, logical block 0, async page =
read
>> [    2.981786] blk_update_request: I/O error, dev vda, sector 1 op
>> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [    2.982083] ixgbe 0000:06:00.0: Multiqueue Enabled: Rx Queue count
>> =3D 63, Tx Queue count =3D 63 XDP Queue count =3D 0
>> [    2.982442] Buffer I/O error on dev vda, logical block 1, async page =
read
>> [    2.983642] ldm_validate_partition_table(): Disk read failed.
>>
>> Kernel 5.8.0-55 is fine, and the only io_uring-related change between
>> 5.8.0-55 and 5.8.0-59 is the commit 4b982bd0f383 ("io_uring: don't
>> mark S_ISBLK async work as unbounded").
>>
>> The weird thing is that this commit was first introduced with v5.12,
>> but neither the mainline v5.12.0 or v5.13.0 is affected by this issue.
>>
>> I guess one of these commits following the backported commit from
>> v5.12 fixes the issue, but that's just a guess. It might be another
>> earlier commit:
>> c7d95613c7d6 io_uring: fix early sqd_list removal sqpoll hangs
>> 9728463737db io_uring: fix rw req completion
>> 6ad7f2332e84 io_uring: clear F_REISSUE right after getting it
>> e82ad4853948 io_uring: fix !CONFIG_BLOCK compilation failure
>> 230d50d448ac io_uring: move reissue into regular IO path
>> 07204f21577a io_uring: fix EIOCBQUEUED iter revert
>> 696ee88a7c50 io_uring/io-wq: protect against sprintf overflow
>>
>> It would be much appreciated if Jens could give pointers to Canonical
>> developers on how to fix the issue, and hopefully a suggestion to
>> prevent this from happening again.
>>
>> Thanks,
>> Regards
