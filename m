Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA655DF17
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiF1JPy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 05:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbiF1JPy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 05:15:54 -0400
X-Greylist: delayed 418 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Jun 2022 02:15:52 PDT
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B961F17A9B
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 02:15:52 -0700 (PDT)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id DA6B520D4A
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 18:08:53 +0900 (JST)
Received: by mail-pf1-f199.google.com with SMTP id bm2-20020a056a00320200b0052531ca7c1cso5069869pfb.15
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 02:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=HRNqjL9MGKGhevjoe5tS0k0pndrVYtplL5el/0LWUSk=;
        b=Xhj15rsVEhqZeHJjWIIzIeHHxMXif5Fn5Gc2s6H24vGKvd5zV+JWINhYtBu4q82k9Q
         EgmhG0A2gGTkD5GXIb70hQutQVTU1TAhCAIv/sf+XjhscOdOfedf2LyrDvKsj3I81qFK
         n/+KYWBprj84AiEO0o3wPEJp0TD0YCbKk7/UCwbzyH/RIJhbG/+UPQRI5WaCdZv932jd
         r3MYybd9AXZdkrup5xSAlWuQ6hc71pgvKkDLT4LyXJCXrvsPIon47juTSTbiNjfOye+u
         FfjY/WsuoHLcbKOKjUDaapc3iXhKPrxZ0mtLsyTAbZgyhgyYmkiBuoFDy/BQC7JIg+K8
         LIeQ==
X-Gm-Message-State: AJIora8z0rrR8d/azH9BMpSWIwQ09yrG3dI6pfsCDT1ytPGpKNB0C2nv
        Y9JCYzGF3rwtSTFizKdtcgnz0EuGCZAnaBXFCaxFFQhWHArP8uW7m1JYZpHZG+OA9K3f27InP/t
        AQW5EQ3eD84vkFkQL9mBO
X-Received: by 2002:a17:902:ce83:b0:16a:4a3e:4f8b with SMTP id f3-20020a170902ce8300b0016a4a3e4f8bmr4102474plg.41.1656407332818;
        Tue, 28 Jun 2022 02:08:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vDmu5INZDJB59bJ1xBY3MTkTTfv8xrU3N0LTHWXAbRp9uWN+m6a0IIuWdydt41JfU4uiUaBg==
X-Received: by 2002:a17:902:ce83:b0:16a:4a3e:4f8b with SMTP id f3-20020a170902ce8300b0016a4a3e4f8bmr4102447plg.41.1656407332507;
        Tue, 28 Jun 2022 02:08:52 -0700 (PDT)
Received: from pc-zest.atmarktech (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902988100b0016a4a57a25asm8665491plp.152.2022.06.28.02.08.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2022 02:08:52 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o67DG-006CYg-Tu;
        Tue, 28 Jun 2022 18:08:50 +0900
Date:   Tue, 28 Jun 2022 18:08:40 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: read corruption with qemu master io_uring engine / linux master /
 btrfs(?)
Message-ID: <YrrFGO4A1jS0GI0G@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I don't have any good reproducer so it's a bit difficult to specify,
let's start with what I have...

I've got this one VM which has various segfaults all over the place when
starting it with aio=io_uring for its disk as follow:

  qemu-system-x86_64 -drive file=qemu/atde-test,if=none,id=hd0,format=raw,cache=none,aio=io_uring \
      -device virtio-blk-pci,drive=hd0 -m 8G -smp 4 -serial mon:stdio -enable-kvm

It also happens with virtio-scsi-blk:
  -device virtio-scsi-pci,id=scsihw0 \
  -drive file=qemu/atde-test,if=none,id=drive-scsi0,format=raw,cache=none,aio=io_uring \
  -device scsi-hd,bus=scsihw0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0,id=scsi0,bootindex=100

It also happened when the disk I was using was a qcow file backing up a
vmdk image (this VM's original disk is for vmware), so while I assume
qemu reading code and qemu-img convert code are similar I'll pretend
image format doesn't matter at this point...
It's happened with two such images, but I haven't been able to reproduce
with any other VMs yet.

I can also reproduce this on a second host machine with a completely
different ssd (WD sata in one vs. samsung nvme), so probably not a
firmware bug.

scrub sees no problem with my filesystems on the host.

I've confirmed it happens with at least debian testing's 5.16.0-4-amd64
and 5.17.0-1-amd64 kernels, as well as 5.19.0-rc4.
It also happens with both debian's 7.0.0 and the master branch
(v7.0.0-2031-g40d522490714)


These factors aside, anything else I tried changing made this bug no
longer reproduce:
 - I'm not sure what the rule is but it sometimes doesn't happen when
running the VM twice in a row, sometimes it happens again. Making a
fresh copy with `cp --reflink=always` of my source image seems to be
reliable.
 - it stops happening without io_uring
 - it stops happening if I copy the disk image with --reflink=never
 - it stops happening if I copy the disk image to another btrfs
partition, created in the same lv, so something about my partition
history matters?...
(I have ssd > GPT partitions > luks > lvm > btrfs with a single disk as
metadata DUP data single)
 - I was unable to reproduce on xfs (with a reflink copy) either but I
also was only able to try on a new fs...
 - I've never been able to reproduce on other VMs


If you'd like to give it a try, my reproducer source image is
---
curl -O https://download.atmark-techno.com/atde/atde9-amd64-20220624.tar.xz
tar xf atde9-amd64-20220624.tar.xz
qemu-img convert -O raw atde9-amd64-20220624/atde9-amd64.vmdk atde-test
cp --reflink=always atde-test atde-test2
---
and using 'atde-test'.
For further attempts I've removed atde-test and copied back from
atde-test2 with cp --reflink=always.
This VM graphical output is borked, but ssh listens so something like
`-netdev user,id=net0,hostfwd=tcp::2227-:22 -device virtio-net-pci,netdev=net0`
and 'ssh -p 2227 -l atmark localhost' should allow login with password
'atmark' or you can change vt on the console (root password 'root')

I also had similar problems with atde9-amd64-20211201.tar.xz .


When reproducing I've had either segfaults in the initrd and complete
boot failures, or boot working and login failures but ssh working
without login shell (ssh ... -tt localhost sh)
that allowed me to dump content of a couple of corrupted files.
When I looked:
- /usr/lib/x86_64-linux-gnu/libc-2.31.so had zeroes instead of data from
offset 0xb6000 to 0xb7fff; rest of file was identical.
- /usr/bin/dmesg had garbadge from 0x05000 until 0x149d8 (end of file).
I was lucky and could match the garbage quickly: it is identical to the
content from 0x1000-0x109d8 within the disk itself.

I've rebooted a few times and it looks like the corruption is identical
everytime for this machine as long as I keep using the same source file;
running from qemu-img convert again seems to change things a bit?
but whatever it is that is specific to these files is stable, even
through host reboots.



I'm sorry I haven't been able to make a better reproducer, I'll keep
trying a bit more tomorrow but maybe someone has an idea with what I've
had so far :/

Perhaps at this point it might be simpler to just try to take qemu out
of the equation and issue many parallel reads to different offsets
(overlapping?) of a large file in a similar way qemu io_uring engine
does and check their contents?


Thanks, and I'll probably follow up a bit tomorrow even if no-one has
any idea, but even ideas of where to look would be appreciated.
-- 
Dominique
