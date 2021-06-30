Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422293B7F48
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 10:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhF3Itt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 04:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhF3Itt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 04:49:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76189C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 01:47:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id hz1so2971061ejc.1
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GqpO+K3m6JQW3IWFjAEC6Rw1Dw45MStJqLAuboNmGY8=;
        b=q9Ntn7EXoxPUmRd6faFIK9hQ1F0BbEKS1h/a+nlOu+pzQB5Ed1Q9N/R2R5HP6pSfdZ
         L+KYPObu5iyycWNW+HUh44yHxnXQVa36jOkpMN5mJCwUqd3jX/okBhZnS2MtQPTWPE+/
         rzllKFgHpp9jNcmqr4+KOM6l8bPs72iSZq0aS5ZHppG81U7F1QuSWH+LaCF78Pcfp68I
         PyHsRNngw+lLq8IgC/lAAq/AXqGI6O1+7LLkgp2LXL5s58xwcf6Yd5bK4RHzP/Xese5O
         lNEgBrqdWTb0S+GU88uuB9lL2DqVmqbCrJWOMj+RNhOScwk03DmZXAOomEsGhT56je3p
         5YCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GqpO+K3m6JQW3IWFjAEC6Rw1Dw45MStJqLAuboNmGY8=;
        b=JJW++lrStWDp1WAXxwdk1lRfEsT6PabrflofDCQVQO0b+oHeud8QHeEbOhUMQsBIP1
         PxTYj7/OnMuHEfm84axS8h44dOzk3OcMNYsjYum9cgXuwvYaJhLGrV3DPhAexSZIx7vE
         Nlr/NVHBIVb+dA0uudnPiQp7h7az73fgVA8HJxvm0NfSvH1Q93soM9EuC3gK2oCOBgK5
         EjOfqF71623adE+0C2xKl9Pd1EeWg6yzIprnJIWFl6+6eE/bfZJ3XhyLQozscPMExFWg
         Ssc7UFrbQxUlZB7DfcJsK5jah8kYalxmpJR8ZAcQRG+tIJ0DGSg0Y/b/mk0YOT3Ggg1D
         JYcA==
X-Gm-Message-State: AOAM530I6w4W4XwO1rDbPsl9SAO72JR6OSjqZcKeY1SbJMV8UI/hlll0
        NhsAb2hMiQcxbO9mZoVOVP549TUYTIECFW40MX8=
X-Google-Smtp-Source: ABdhPJySG0/J7u1X8vOwGGnPWfJLdjG/E3OjLUnKyAP12upVjnJAd4sUN/o1cgzsqOwhG7ao0ZPsZvxQ+I0EC5WSgL4=
X-Received: by 2002:a17:906:3407:: with SMTP id c7mr9973560ejb.212.1625042837149;
 Wed, 30 Jun 2021 01:47:17 -0700 (PDT)
MIME-Version: 1.0
From:   Juhyung Park <qkrwngud825@gmail.com>
Date:   Wed, 30 Jun 2021 17:47:06 +0900
Message-ID: <CAD14+f2Nmu_XNjE8SM+jzfaNZfzyFowN3Cf8Lgw36FT+gqqPAg@mail.gmail.com>
Subject: Possible io_uring regression with QEMU on Ubuntu's kernel
To:     Kamal Mostafa <kamal@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone.

With the latest Ubuntu 20.04's HWE kernel 5.8.0-59, I'm noticing some
weirdness when using QEMU/libvirt with the following storage
configuration:

<disk type="block" device="disk">
  <driver name="qemu" type="raw" cache="none" io="io_uring"
discard="unmap" detect_zeroes="unmap"/>
  <source dev="/dev/disk/by-id/md-uuid-df271a1e:9dfb7edb:8dc4fbb8:c43e652f-part1"
index="1"/>
  <backingStore/>
  <target dev="vda" bus="virtio"/>
  <alias name="virtio-disk0"/>
  <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
</disk>

QEMU version is 5.2+dfsg-9ubuntu3 and libvirt version is 7.0.0-2ubuntu2.

The guest VM is unable to handle I/O properly with io_uring, and
nuking io="io_uring" fixes the issue.
On one machine (EPYC 7742), the partition table cannot be read and on
another (Ryzen 9 3950X), ext4 detects weirdness with journaling and
ultimately remounts the guest disk to R/O:

[    2.712321] virtio_blk virtio5: [vda] 3906519775 512-byte logical
blocks (2.00 TB/1.82 TiB)
[    2.714054] vda: detected capacity change from 0 to 2000138124800
[    2.963671] blk_update_request: I/O error, dev vda, sector 0 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.964909] Buffer I/O error on dev vda, logical block 0, async page read
[    2.966021] blk_update_request: I/O error, dev vda, sector 1 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.967177] Buffer I/O error on dev vda, logical block 1, async page read
[    2.968330] blk_update_request: I/O error, dev vda, sector 2 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.969504] Buffer I/O error on dev vda, logical block 2, async page read
[    2.970767] blk_update_request: I/O error, dev vda, sector 3 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.971624] Buffer I/O error on dev vda, logical block 3, async page read
[    2.972170] blk_update_request: I/O error, dev vda, sector 4 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.972728] Buffer I/O error on dev vda, logical block 4, async page read
[    2.973308] blk_update_request: I/O error, dev vda, sector 5 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.973920] Buffer I/O error on dev vda, logical block 5, async page read
[    2.974496] blk_update_request: I/O error, dev vda, sector 6 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.975093] Buffer I/O error on dev vda, logical block 6, async page read
[    2.975685] blk_update_request: I/O error, dev vda, sector 7 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.976295] Buffer I/O error on dev vda, logical block 7, async page read
[    2.980074] blk_update_request: I/O error, dev vda, sector 0 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.981104] Buffer I/O error on dev vda, logical block 0, async page read
[    2.981786] blk_update_request: I/O error, dev vda, sector 1 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[    2.982083] ixgbe 0000:06:00.0: Multiqueue Enabled: Rx Queue count
= 63, Tx Queue count = 63 XDP Queue count = 0
[    2.982442] Buffer I/O error on dev vda, logical block 1, async page read
[    2.983642] ldm_validate_partition_table(): Disk read failed.

Kernel 5.8.0-55 is fine, and the only io_uring-related change between
5.8.0-55 and 5.8.0-59 is the commit 4b982bd0f383 ("io_uring: don't
mark S_ISBLK async work as unbounded").

The weird thing is that this commit was first introduced with v5.12,
but neither the mainline v5.12.0 or v5.13.0 is affected by this issue.

I guess one of these commits following the backported commit from
v5.12 fixes the issue, but that's just a guess. It might be another
earlier commit:
c7d95613c7d6 io_uring: fix early sqd_list removal sqpoll hangs
9728463737db io_uring: fix rw req completion
6ad7f2332e84 io_uring: clear F_REISSUE right after getting it
e82ad4853948 io_uring: fix !CONFIG_BLOCK compilation failure
230d50d448ac io_uring: move reissue into regular IO path
07204f21577a io_uring: fix EIOCBQUEUED iter revert
696ee88a7c50 io_uring/io-wq: protect against sprintf overflow

It would be much appreciated if Jens could give pointers to Canonical
developers on how to fix the issue, and hopefully a suggestion to
prevent this from happening again.

Thanks,
Regards
