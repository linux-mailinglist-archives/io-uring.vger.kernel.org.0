Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C2A5F0781
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 11:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiI3JYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 05:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiI3JYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 05:24:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D880156C14;
        Fri, 30 Sep 2022 02:24:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lx7so3769351pjb.0;
        Fri, 30 Sep 2022 02:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=6iCG4gazXB3pWG0Bfe/MnWxlMViLhtA9EAJcveW3FPM=;
        b=W8OHm3zvUFFggryKe7RZxVt5JEGExVo3SyxpqYHCRTDO48QYpRWDUDvTaQ6MtxbOl/
         ryUTCUoPBtbcqWZw0R7IRMb0+C9HqtXCLNXViblCLZTjDRkzYmfNfE/4i4a58lLi7vsa
         4n6GdPfagn4cQj1WX5/emS676OYXTYRv57IT/K2NhQkELAFeEZvGWt0ofqlLZi5ciuWs
         9pcv1VjqQOrq+UaxiCYkVmPLlY9kLYn4xkHz2480/0r2O3invpGRPxHMr7EHB1yzVBZy
         Us5bWBxoEjPuFC4io5ABSU0ceUr7xoQzozmxLabsHlNnBWo9GfEEQHihVQsuLaiI0PaE
         lMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6iCG4gazXB3pWG0Bfe/MnWxlMViLhtA9EAJcveW3FPM=;
        b=lkyUhx7A5227DSeSCtYCWpU3NXuh8G6LcCB9iNY4DfIb/RK+ZECF3vOG2KWfWeZjT1
         Xb8i1elvNEJOd0FmvImds3OhryqbUPGSHVwXMHqBxR6WPdaUC7Ts7Sucq5/4x75cesJT
         izn8hZpvJ6JEKqAqRxQrN1FSn6sjQCqRK7nVK0V0QNPR+LGAL3+DQIlM73TyCig+Er38
         uXotz8Egsyk3Wz4wuzDGB3h36BczlsNwyVPvG4b0UARJdwg6XUL3b5SWx3fVY4sCZmYw
         tSiL4S5QWHgEjRcCPDQIVhyYSOn4anInFNJvB5dSd8fCNW1+34zWpzrbzh8cK60MNRnW
         J4UQ==
X-Gm-Message-State: ACrzQf1CK8cuHtyAS4zrIsmD5z+1deD/DxWEE9PRBgms9y8QxvWZFuIn
        2y8lQhtRQFuv6phm1Wbx6J1yPrU8Nu8tVw==
X-Google-Smtp-Source: AMsMyM7eeeVzQYgbUMSdujcKlMzcGJ72cz07MoTFpwokTQWD0n1LgIel+K8xU1qvisQNl/8S8qZd5w==
X-Received: by 2002:a17:902:e552:b0:179:e796:b432 with SMTP id n18-20020a170902e55200b00179e796b432mr7823816plf.21.1664529858681;
        Fri, 30 Sep 2022 02:24:18 -0700 (PDT)
Received: from T590 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k11-20020a17090a404b00b001f559e00473sm4879248pjg.43.2022.09.30.02.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:24:18 -0700 (PDT)
Date:   Fri, 30 Sep 2022 17:24:11 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Yza1u1KfKa7ycQm0@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URI_DOTEDU autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

ublk-qcow2 is available now.

So far it provides basic read/write function, and compression and snapshot
aren't supported yet. The target/backend implementation is completely
based on io_uring, and share the same io_uring with ublk IO command
handler, just like what ublk-loop does.

Follows the main motivations of ublk-qcow2:

- building one complicated target from scratch helps libublksrv APIs/functions
  become mature/stable more quickly, since qcow2 is complicated and needs more
  requirement from libublksrv compared with other simple ones(loop, null)

- there are several attempts of implementing qcow2 driver in kernel, such as
  ``qloop`` [2], ``dm-qcow2`` [3] and ``in kernel qcow2(ro)`` [4], so ublk-qcow2
  might useful be for covering requirement in this field

- performance comparison with qemu-nbd, and it was my 1st thought to evaluate
  performance of ublk/io_uring backend by writing one ublk-qcow2 since ublksrv
  is started

- help to abstract common building block or design pattern for writing new ublk
  target/backend

So far it basically passes xfstest(XFS) test by using ublk-qcow2 block
device as TEST_DEV, and kernel building workload is verified too. Also
soft update approach is applied in meta flushing, and meta data
integrity is guaranteed, 'make test T=qcow2/040' covers this kind of
test, and only cluster leak is reported during this test.

The performance data looks much better compared with qemu-nbd, see
details in commit log[1], README[5] and STATUS[6]. And the test covers both
empty image and pre-allocated image, for example of pre-allocated qcow2
image(8GB):

- qemu-nbd (make test T=qcow2/002)
	randwrite(4k): jobs 1, iops 24605
	randread(4k): jobs 1, iops 30938
	randrw(4k): jobs 1, iops read 13981 write 14001
	rw(512k): jobs 1, iops read 724 write 728

- ublk-qcow2 (make test T=qcow2/022)
	randwrite(4k): jobs 1, iops 104481
	randread(4k): jobs 1, iops 114937
	randrw(4k): jobs 1, iops read 53630 write 53577
	rw(512k): jobs 1, iops read 1412 write 1423

Also ublk-qcow2 aligns queue's chunk_sectors limit with qcow2's cluster size,
which is 64KB at default, this way simplifies backend io handling, but
it could be increased to 512K or more proper size for improving sequential
IO perf, just need one coroutine to handle more than one IOs.


[1] https://github.com/ming1/ubdsrv/commit/9faabbec3a92ca83ddae92335c66eabbeff654e7
[2] https://upcommons.upc.edu/bitstream/handle/2099.1/9619/65757.pdf?sequence=1&isAllowed=y
[3] https://lwn.net/Articles/889429/
[4] https://lab.ks.uni-freiburg.de/projects/kernel-qcow2/repository
[5] https://github.com/ming1/ubdsrv/blob/master/qcow2/README.rst
[6] https://github.com/ming1/ubdsrv/blob/master/qcow2/STATUS.rst

Thanks,
Ming
