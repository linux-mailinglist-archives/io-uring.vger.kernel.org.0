Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABD153581B
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 05:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiE0DtP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 23:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiE0DtO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 23:49:14 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FBA3EAA9
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 20:49:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VEVRoxB_1653623342;
Received: from 30.225.28.153(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEVRoxB_1653623342)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 May 2022 11:49:03 +0800
Message-ID: <03e4e3aa-7f5f-4051-a06b-62e9f5a082f3@linux.alibaba.com>
Date:   Fri, 27 May 2022 11:49:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>,
        joeylee.lz@alibaba-inc.com
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: RWF_NOWAIT does not work on socket
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

hi,

Now we're using io_uring's multi-shot feature,  multi-shot is similar
to epoll's edge-triggered mode, that means once one pure poll
request returns one event(cqe), we'll need to read or write continually
until EAGAIN is returned, which needs to set file to be non-blocking.

But since commit "io_uring: allow retry for O_NONBLOCK if async is
supported", seems that the non-blocking behavior has been changed.
In io_prep_rw:
+       /*
+        * If the file is marked O_NONBLOCK, still allow retry for it if it
+        * supports async. Otherwise it's impossible to use O_NONBLOCK files
+        * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+        */
+       if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+           ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
                req->flags |= REQ_F_NOWAIT;

Then I tried to use RWF_NOWAIT, seems that it also does not work. In
kiocb_set_rw_flags():
    if (flags & RWF_NOWAIT) {
                if (!(ki->ki_filp->f_mode & FMODE_NOWAIT))
                        return -EOPNOTSUPP;
                kiocb_flags |= IOCB_NOIO;
        }

Seems that socket file doesn't have FMODE_NOWAIT set, so user apps
will get EOPNOTSUPP when using RWF_NOWAIT on socket. Also in
above codes, seems IOCB_NOWAIT isn't flagged too.

Any special reasons about above codes? Thanks.

Regards,
Xiaoguang Wang
