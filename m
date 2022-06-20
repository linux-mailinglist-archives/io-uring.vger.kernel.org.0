Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76737551800
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiFTMBe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 08:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbiFTMBa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 08:01:30 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAE612744
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 05:01:26 -0700 (PDT)
Message-ID: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655726484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bEiBj2UtRiPajG0hPXJWW9BlzB4DIKSE+rDhX37+S14=;
        b=wpAqX0rWge7R5dr6IEaZnldBqWemBFPMiaQpOo4Xzmu7i9zXox28etKuidroGJTYXkAjUw
        7ffxnYNnhL2uT12WxJJTABGFHnOn99R/phQJAi5T/FaATkMCn87Vn8M407AfF1ZFBGi0En
        wtwZyys2tDyLz/TscxATJ/MPXAbAAm4=
Date:   Mon, 20 Jun 2022 20:01:11 +0800
MIME-Version: 1.0
X-Mozilla-News-Host: news://nntp.lore.kernel.org:119
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
Subject: [RFC] a new way to achieve asynchronous IO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,
I've some thought on the way of doing async IO. The current model is:
(given we are using SQPOLL mode)

the sqthread does:
(a) Issue a request with nowait/nonblock flag.
(b) If it would block, reutrn -EAGAIN
(c) The io_uring layer captures this -EAGAIN and wake up/create
a io-worker to execute the request synchronously.
(d) Try to issue other requests in the above steps again.

This implementation has two downsides:
(1) we have to find all the block point in the IO stack manually and
change them into "nowait/nonblock friendly".
(2) when we raise another io-worker to do the request, we submit the
request from the very beginning. This isn't a little bit inefficient.


While I think we can actually do it in a reverse way:
(given we are using SQPOLL mode)

the sqthread1 does:
(a) Issue a request in the synchronous way
(b) If it is blocked/scheduled soon, raise another sqthread2
(c) sqthread2 tries to issue other requests in the same way.

This solves problem (1), and may solve (2).
For (1), we just do the sqthread waken-up at the beginning of schedule()
just like what the io-worker and system-worker do. No need to find all
the block point.
For (2), we continue the blocked request from where it is blocked when
resource is satisfied.

What we need to take care is making sure there is only one task
submitting the requests.

To achieve this, we can maintain a pool of sqthread just like the iowq.

I've done a very simple/ugly POC to demonstrate this:

https://github.com/HowHsu/linux/commit/183be142493b5a816b58bd95ae4f0926227b587b

I also wrote a simple test to test it, which submits two sqes, one
read(pipe), one nop request. The first one will be block since no data
in the pipe. Then a new sqthread was created/waken up to submit the
second one and then some data is written to the pipe(by a unrelated
user thread), soon the first sqthread is waken up and continues the
request.

If the idea sounds no fatal issue I'll change the POC to real patches.
Any comments are welcome!

