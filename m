Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2428A55EDB3
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiF1TP0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 15:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbiF1TO3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 15:14:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A7537A23
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 12:12:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso47595pjz.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 12:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=o4MCWpaqWRxscyqKeJFt2mu0KswfALaLpwZYYndkEck=;
        b=HBprBT8WBVZX3oCWz9LwnyQ5G49nl4y8/tYz5Oqn6mY8uVQS85a73T5X8K1w7LhsBs
         j1qCVoCHQWgdi8oxnOSOwTJJpgwZECYSKbljFfkMRPUBPBMz9v22wTP16gCdlAGSYhNv
         CuqyObhaVdkk3O8SaC8oC8f8+FiOQ9jxsvIw1OG0+noVjcsu4eUC8nFEW8WtyGU2BMZq
         DVV9ZFjax8NcyvbxaciR7nkV3zZLxrqIsmZ6UkmL6YJzcEAIqn/N+pYAG9/jYKSTqECr
         8i5RYAmRVefoJTSp1Bl5knqBcmju10QC0A4WATrCg7Brq/fmGM67ocpy7dFSbozHghu8
         aykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o4MCWpaqWRxscyqKeJFt2mu0KswfALaLpwZYYndkEck=;
        b=UpCNi0AMsmlTxIUvzi19zXwED3+gMAHchTGCY8PUmHfBN3sIG8BTOo/1A2TZCkpQsO
         85gXj7jxEBLTYAeN1ir1irgKrw9Gode7B8yVJKtSKcknaj//SCsSVBsoABOLUVBcn/ci
         2l51PHAmxOMp4oDBvlgDqks5wHZAVjC82xUHJ51wbrjfb5Wphm1W1mQPTvAXE/gcsx2l
         5A4DUZnzIx120flHz7tpgfYuD3dvWtmq8ZkhaUTqFNbt0QXOL+GoGIlZHVpkpOrwVVoe
         3lCqtO2/saMPMFydjJX9nwWR1oU9AqoJhKQVZT67o/LiLOeUcln1rxIl48l8D26Nrlr9
         X3Rw==
X-Gm-Message-State: AJIora8bDl8G7cz6evnu98FpPDpmrBVrOcpwou7/FRiVmvzcLFy9uyhs
        1cSYdJnZjTb6xVwtCKPUVSnAYb065Eig3A==
X-Google-Smtp-Source: AGRyM1tuJXJ1siPVSyALSaTosFwx57Ljtv2JISkSI1IzvlC/1cQHmxztGSH11CmWUc4GFhaV3ALPWw==
X-Received: by 2002:a17:902:b118:b0:16b:7b17:41df with SMTP id q24-20020a170902b11800b0016b7b1741dfmr6236278plr.171.1656443576532;
        Tue, 28 Jun 2022 12:12:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::165b? ([2620:10d:c090:400::5:f46f])
        by smtp.gmail.com with ESMTPSA id 9-20020a17090a0a8900b001eee5416138sm182657pjw.52.2022.06.28.12.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 12:12:56 -0700 (PDT)
Message-ID: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
Date:   Tue, 28 Jun 2022 13:12:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: read corruption with qemu master io_uring engine / linux master /
 btrfs(?)
Content-Language: en-US
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <YrrFGO4A1jS0GI0G@atmark-techno.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YrrFGO4A1jS0GI0G@atmark-techno.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 3:08 AM, Dominique MARTINET wrote:
> I don't have any good reproducer so it's a bit difficult to specify,
> let's start with what I have...
> 
> I've got this one VM which has various segfaults all over the place when
> starting it with aio=io_uring for its disk as follow:
> 
>   qemu-system-x86_64 -drive file=qemu/atde-test,if=none,id=hd0,format=raw,cache=none,aio=io_uring \
>       -device virtio-blk-pci,drive=hd0 -m 8G -smp 4 -serial mon:stdio -enable-kvm
> 
> It also happens with virtio-scsi-blk:
>   -device virtio-scsi-pci,id=scsihw0 \
>   -drive file=qemu/atde-test,if=none,id=drive-scsi0,format=raw,cache=none,aio=io_uring \
>   -device scsi-hd,bus=scsihw0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0,id=scsi0,bootindex=100
> 
> It also happened when the disk I was using was a qcow file backing up a
> vmdk image (this VM's original disk is for vmware), so while I assume
> qemu reading code and qemu-img convert code are similar I'll pretend
> image format doesn't matter at this point...
> It's happened with two such images, but I haven't been able to reproduce
> with any other VMs yet.
> 
> I can also reproduce this on a second host machine with a completely
> different ssd (WD sata in one vs. samsung nvme), so probably not a
> firmware bug.
> 
> scrub sees no problem with my filesystems on the host.
> 
> I've confirmed it happens with at least debian testing's 5.16.0-4-amd64
> and 5.17.0-1-amd64 kernels, as well as 5.19.0-rc4.
> It also happens with both debian's 7.0.0 and the master branch
> (v7.0.0-2031-g40d522490714)
> 
> 
> These factors aside, anything else I tried changing made this bug no
> longer reproduce:
>  - I'm not sure what the rule is but it sometimes doesn't happen when
> running the VM twice in a row, sometimes it happens again. Making a
> fresh copy with `cp --reflink=always` of my source image seems to be
> reliable.
>  - it stops happening without io_uring
>  - it stops happening if I copy the disk image with --reflink=never
>  - it stops happening if I copy the disk image to another btrfs
> partition, created in the same lv, so something about my partition
> history matters?...
> (I have ssd > GPT partitions > luks > lvm > btrfs with a single disk as
> metadata DUP data single)
>  - I was unable to reproduce on xfs (with a reflink copy) either but I
> also was only able to try on a new fs...
>  - I've never been able to reproduce on other VMs
> 
> 
> If you'd like to give it a try, my reproducer source image is
> ---
> curl -O https://download.atmark-techno.com/atde/atde9-amd64-20220624.tar.xz
> tar xf atde9-amd64-20220624.tar.xz
> qemu-img convert -O raw atde9-amd64-20220624/atde9-amd64.vmdk atde-test
> cp --reflink=always atde-test atde-test2
> ---
> and using 'atde-test'.
> For further attempts I've removed atde-test and copied back from
> atde-test2 with cp --reflink=always.
> This VM graphical output is borked, but ssh listens so something like
> `-netdev user,id=net0,hostfwd=tcp::2227-:22 -device virtio-net-pci,netdev=net0`
> and 'ssh -p 2227 -l atmark localhost' should allow login with password
> 'atmark' or you can change vt on the console (root password 'root')
> 
> I also had similar problems with atde9-amd64-20211201.tar.xz .
> 
> 
> When reproducing I've had either segfaults in the initrd and complete
> boot failures, or boot working and login failures but ssh working
> without login shell (ssh ... -tt localhost sh)
> that allowed me to dump content of a couple of corrupted files.
> When I looked:
> - /usr/lib/x86_64-linux-gnu/libc-2.31.so had zeroes instead of data from
> offset 0xb6000 to 0xb7fff; rest of file was identical.
> - /usr/bin/dmesg had garbadge from 0x05000 until 0x149d8 (end of file).
> I was lucky and could match the garbage quickly: it is identical to the
> content from 0x1000-0x109d8 within the disk itself.
> 
> I've rebooted a few times and it looks like the corruption is identical
> everytime for this machine as long as I keep using the same source file;
> running from qemu-img convert again seems to change things a bit?
> but whatever it is that is specific to these files is stable, even
> through host reboots.
> 
> 
> 
> I'm sorry I haven't been able to make a better reproducer, I'll keep
> trying a bit more tomorrow but maybe someone has an idea with what I've
> had so far :/
> 
> Perhaps at this point it might be simpler to just try to take qemu out
> of the equation and issue many parallel reads to different offsets
> (overlapping?) of a large file in a similar way qemu io_uring engine
> does and check their contents?
> 
> 
> Thanks, and I'll probably follow up a bit tomorrow even if no-one has
> any idea, but even ideas of where to look would be appreciated.

Not sure what's going on here, but I use qemu with io_uring many times
each day and haven't seen anything odd. This is on ext4 and xfs however,
I haven't used btrfs as the backing file system. I wonder if we can boil
this down into a test case and try and figure out what is doing on here.

-- 
Jens Axboe

