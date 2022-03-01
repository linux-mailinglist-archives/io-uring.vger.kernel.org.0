Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C804C8CE9
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 14:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiCANsC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 08:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiCANsC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 08:48:02 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE29F39B;
        Tue,  1 Mar 2022 05:47:20 -0800 (PST)
Received: from [45.44.224.220] (port=56376 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nP2qV-0002GI-4T; Tue, 01 Mar 2022 08:47:19 -0500
Date:   Tue, 01 Mar 2022 08:47:18 -0500
Message-Id: <cover.1646142288.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/2] io_uring: Add support for napi_busy_poll
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The sqpoll thread can be used for performing the napi busy poll in a
similar way that it does io polling for file systems supporting direct
access bypassing the page cache.

The other way that io_uring can be used for napi busy poll is by
calling io_uring_enter() to get events.

If the user specify a timeout value, it is distributed between polling
and sleeping by using the systemwide setting
/proc/sys/net/core/busy_poll.

The changes have been tested with this program:
https://github.com/lano1106/io_uring_udp_ping

and the result is:
Without sqpoll:
NAPI busy loop disabled:
rtt min/avg/max/mdev = 40.631/42.050/58.667/1.547 us
NAPI busy loop enabled:
rtt min/avg/max/mdev = 30.619/31.753/61.433/1.456 us

With sqpoll:
NAPI busy loop disabled:
rtt min/avg/max/mdev = 42.087/44.438/59.508/1.533 us
NAPI busy loop enabled:
rtt min/avg/max/mdev = 35.779/37.347/52.201/0.924 us

v2:
 * Evaluate list_empty(&ctx->napi_list) outside io_napi_busy_loop() to keep
   __io_sq_thread() execution as fast as possible
 * In io_cqring_wait(), move up the sig block to avoid needless computation
   if the block exits the function
 * In io_cqring_wait(), protect ctx->napi_list from race condition by
   splicing it into a local list
 * In io_cqring_wait(), allow busy polling when uts is missing
 * Fix kernel test robot issues
v3:
 * Fix do_div() type mismatch warning
 * Reduce uring_lock contention by creating a spinlock for protecting
   napi_list
 * Support correctly MULTISHOT poll requests
v4:
 * Put back benchmark result in commit text

Olivier Langlois (2):
  io_uring: minor io_cqring_wait() optimization
  io_uring: Add support for napi_busy_poll

 fs/io_uring.c | 246 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 237 insertions(+), 9 deletions(-)


base-commit: 719fce7539cd3e186598e2aed36325fe892150cf
-- 
2.35.1

