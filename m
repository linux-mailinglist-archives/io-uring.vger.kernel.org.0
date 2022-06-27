Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2055C6AB
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiF0IVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 04:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiF0IVG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 04:21:06 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1636F49;
        Mon, 27 Jun 2022 01:21:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VHWTgZ-_1656318059;
Received: from 30.97.57.54(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VHWTgZ-_1656318059)
          by smtp.aliyun-inc.com;
          Mon, 27 Jun 2022 16:21:00 +0800
Message-ID: <fd926012-6845-05e4-077b-6c8cfbf3d3cc@linux.alibaba.com>
Date:   Mon, 27 Jun 2022 16:20:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [RFC] libubd: library for ubd(userspace block driver based on
 io_uring passthrough)
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph.qi@linux.alibaba.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ming,

We are learning your ubd code and developing a library: libubd for ubd.
This article explains why we need libubd and how we design it.

Related threads:
(1) https://lore.kernel.org/all/Yk%2Fn7UtGK1vVGFX0@T590/
(2) https://lore.kernel.org/all/YnDhorlKgOKiWkiz@T590/
(3) https://lore.kernel.org/all/20220509092312.254354-1-ming.lei@redhat.com/
(4) https://lore.kernel.org/all/20220517055358.3164431-1-ming.lei@redhat.com/


Userspace block driver(ubd)[1], based on io_uring passthrough,
allows users to define their own backend storage in userspace
and provides block devices such as /dev/ubdbX.
Ming Lei has provided kernel driver code: ubd_drv.c[2]
and userspace code: ubdsrv[3].

ubd_drv.c simply passes all blk-mq IO requests
to ubdsrv through io_uring sqes/cqes. We think the kernel code
is pretty well-designed.

ubdsrv is implemented by a single daemon
and target(backend) IO handling(null_tgt and loop_tgt) 
is embedded in the daemon. 
While trying ubdsrv, we find ubdsrv is hard to be used 
by our backend.
First is description of our backend:

(1) a distributing system sends/receives IO requests 
    through network.

(2) The system use RPC calls among hundreds of
     storage servers and RPC calls are associated with data buffers
     allocated from a memory pool.

(3) On each server for each device(/dev/vdX), our backend runs
     many threads to handle IO requests and manage the device. 

Second are reasons why ubdsrv is hard to use for us:

(1) ubdsrv requires the target(backend) issues IO requests
    to the io_uring provided by ubdsrv but our backend 
    uses something like RPC and does not support io_uring.

(2) ubdsrv forks a daemon and it takes over everything.
    Users should type "list/stop/del" ctrl-commands to interact with
    the daemon. It is inconvenient for our backend
    because it has threads(from a C++ thread library) running inside.

(3) ubdsrv PRE-allocates internal data buffers for each ubd device.
    The data flow is:
    bio vectors <-1-> ubdsrv data buffer <-2-> backend buffer(our RPC buffer).
    Since ubdsrv does not export its internal data buffer to backend,
    the second copy is unavoidable. 
    PRE-allocating data buffer may not be a good idea for wasting memory
    if there are hundreds of ubd devices(/dev/ubdbX).

To better use ubd in more complicated scenarios, we have developed libubd.
It does not assume implementation of backend and can be embedded into it.
We refer to the code structure of tcmu-runner[4], 
which includes a library(libtcmu) for users 
to embed tcmu-runner inside backend's code. 
It:

(1) Does not fork/pthread_create but embedded in backend's threads

(2) Provides libubd APIs for backend to add/delete ubd devices 
    and fetch/commit IO requests

(3) simply passes backend-provided data buffers to ubd_drv.c in kernel,
    since the backend actually has no knowledge 
    on incoming data size until it gets an IO descriptor.

Note: 

(1) libubd is just a POC demo and is not stick to the principles of
    designing a library and we are still developing it now...

(2) The repo[5] including some useful examples using libubd. 

(3) We modify the kernel part: ubd_drv.c and 
    it[6] is against Ming Lei's newest branch[2]
    because we forked our branch from his early branch
    (v5.17-ubd-dev).

Thanks,
Zhang

[1]https://lore.kernel.org/all/Yk%2Fn7UtGK1vVGFX0@T590/
[2]https://github.com/ming1/linux/tree/my_for-5.19-ubd-devel_v3
[3]https://github.com/ming1/ubdsrv
[4]https://github.com/open-iscsi/tcmu-runner
[5]https://github.com/old-memories/libubd
[6]https://github.com/old-memories/linux/tree/v5.17-ubd-dev-mq-ubuf
