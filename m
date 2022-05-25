Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C15533C40
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 14:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiEYMIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 08:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiEYMIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 08:08:17 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DA213F01
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 05:08:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VENKOlQ_1653480493;
Received: from 30.225.28.160(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VENKOlQ_1653480493)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 May 2022 20:08:13 +0800
Message-ID: <d8829873-4e68-1da0-f326-0af2dc40c3e1@linux.alibaba.com>
Date:   Wed, 25 May 2022 20:08:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: improve register file feature's usability
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hello,

I raised this issue last year and have had some discussions with Pavel, but
didn't come to an agreement and didn't come up with better solution. You
can see my initial patch and discussions in below mail:
    https://lore.kernel.org/all/20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com/T/

The most biggest issue with file registration feature is that it needs user
space apps to maintain free slot info about io_uring's fixed file table, which
really is a burden. Now I see io_uring starts to return file slot from kernel by
using IORING_FILE_INDEX_ALLOC flag in accept or open operations, but
they need app to uses direct accept or direct open, which is not convenient.
As far as I know, some apps are not prepared to use direct accept or open:
  1) App uses one io_uring instance to accept one connection, but later it will
route this new connection to another io_uring instance to complete read/write,
which achieves load balance. In this case, direct accept won't work. We still
need a valid fd, then another io_uring instance can register it again.
  2) After getting a new connection, if later apps wants to call fcntl(2) or
setsockopt or similar on it, we will need a true fd, not a flle slot in io_uring's
file table, unless we can make io_uring support all existing syscalls which use fd.

So we may still need to make io_uring file registration feature easier to use.
I'd like io_uring in kernel returns prepared file slot. For example, for
IORING_OP_FILES_UPDATE, we support user passes one fd and returns
found free slot in cqe->res, just like what IORING_FILE_INDEX_ALLOC does.

This is my current rough idea, any more thoughts? Thanks.


Regards,
Xiaoguang Wang
