Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98DA5F3C89
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 07:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJDFwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 01:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJDFwY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 01:52:24 -0400
X-Greylist: delayed 510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 22:52:20 PDT
Received: from host1.nc.manuel-bentele.de (host1.nc.manuel-bentele.de [92.60.37.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03841658B;
        Mon,  3 Oct 2022 22:52:20 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A63855E497;
        Tue,  4 Oct 2022 07:43:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manuel-bentele.de;
        s=dkim; t=1664862223;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:content-language:in-reply-to:references;
        bh=0IQPBk0HRTduHZsmHP+k9foHwxcORE1gRHiBPhFIav4=;
        b=HYo7qjDZPXw/Zx384ZSCycLpWLZ8ARxxF4hctF/XC4EHHN5OWRAcgumnAT62QQtgEenAXs
        wuU9J1w2Twolufls/op925rK7Tuxugpl0BEpSrpsnxBnUKKeMTHRHJh/V1nyyr6yHpzQzT
        SsXQdoLDK5rLQFiBcrRpMm0Ssj39BIMZkthL8u0/yPbKxAmVDIxVXPlG3z0a4MOK5elBci
        /JcnG6fQiR0Y3zTyF3xgDGD3d8D0CiVRQBCVm8WgmxykF7FIdtIYBSjSGUxuEotx+hawFg
        QkTys34BKXZk7Q3S22/tRuf2wD+AiW55L6DM+tIqJA3Uo1omnf4YKeKNc6b0RA==
Message-ID: <b15c2ff8-ae30-8e8e-4178-c9976346afde@manuel-bentele.de>
Date:   Tue, 4 Oct 2022 07:43:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Content-Language: en-US
To:     Ming Lei <tom.leiming@gmail.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kirill Tkhai <kirill.tkhai@openvz.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>,
        Dirk von Suchodoletz <dirk.von.suchodoletz@rz.uni-freiburg.de>
References: <Yza1u1KfKa7ycQm0@T590>
From:   Manuel Bentele <development@manuel-bentele.de>
In-Reply-To: <Yza1u1KfKa7ycQm0@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URI_DOTEDU
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

thanks for the notification.I want to note that the official "in kernel
qcow2 (ro)" project was renamed to "xloop" and is now maintained on
Github [1]. So far we are successfully using xloop toimplement our use
case explained in [2].

Seems like we have a technical alternative to get file-format specific
functionality out of the kernel. When I presented the "in kernel qcow2
(ro)" project idea on the mailing list [3], there was a discussion about
whether file formats like qcow2 should be implemented in the kernel or
not? Now, this question should be obsolete.

[1] https://github.com/bwLehrpool/xloop
[2] https://www.spinics.net/lists/linux-block/msg44858.html
[3] https://www.spinics.net/lists/linux-block/msg39538.html

Regards,
Manuel

On 9/30/22 11:24, Ming Lei wrote:
> Hello,
>
> ublk-qcow2 is available now.
>
> So far it provides basic read/write function, and compression and snapshot
> aren't supported yet. The target/backend implementation is completely
> based on io_uring, and share the same io_uring with ublk IO command
> handler, just like what ublk-loop does.
>
> Follows the main motivations of ublk-qcow2:
>
> - building one complicated target from scratch helps libublksrv APIs/functions
>   become mature/stable more quickly, since qcow2 is complicated and needs more
>   requirement from libublksrv compared with other simple ones(loop, null)
>
> - there are several attempts of implementing qcow2 driver in kernel, such as
>   ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
>   might useful be for covering requirement in this field
>
> - performance comparison with qemu-nbd, and it was my 1st thought to evaluate
>   performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
>   is started
>
> - help to abstract common building block or design pattern for writing new ublk
>   target/backend
>
> So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
> device as TEST_DEV, and kernel building workload is verified too. Also
> soft update approach is applied in meta flushing, and meta data
> integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
> test, and only cluster leak is reported during this test.
>
> The performance data looks much better compared with qemu-nbd, see
> details in commit log[1], README[5] and STATUS[6]. And the test covers both
> empty image and pre-allocated image, for example of pre-allocated qcow2
> image(8GB):
>
> - qemu-nbd (make test T=qcow2/002)
> 	randwrite(4k): jobs 1, iops 24605
> 	randread(4k): jobs 1, iops 30938
> 	randrw(4k): jobs 1, iops read 13981 write 14001
> 	rw(512k): jobs 1, iops read 724 write 728
>
> - ublk-qcow2 (make test T=qcow2/022)
> 	randwrite(4k): jobs 1, iops 104481
> 	randread(4k): jobs 1, iops 114937
> 	randrw(4k): jobs 1, iops read 53630 write 53577
> 	rw(512k): jobs 1, iops read 1412 write 1423
>
> Also ublk-qcow2 aligns queue's chunk_sectors limit with qcow2's cluster size,
> which is 64KB at default, this way simplifies backend io handling, but
> it could be increased to 512K or more proper size for improving sequential
> IO perf, just need one coroutine to handle more than one IOs.
>
>
> [1] https://github.com/ming1/ubdsrv/commit/9faabbec3a92ca83ddae92335c66eabbeff654e7
> [2] https://upcommons.upc.edu/bitstream/handle/2099.1/9619/65757.pdf?sequence=1&isAllowed=y
> [3] https://lwn.net/Articles/889429/
> [4] https://lab.ks.uni-freiburg.de/projects/kernel-qcow2/repository
> [5] https://github.com/ming1/ubdsrv/blob/master/qcow2/README.rst
> [6] https://github.com/ming1/ubdsrv/blob/master/qcow2/STATUS.rst
>
> Thanks,
> Ming
