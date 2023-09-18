Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C747A3FE3
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjIREMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjIREMN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:12:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D446BB6
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5HY5paQq7XQmn0pw4HIY34PddQ5m+YEJQsmQoendPwY=;
        b=CzXuMexTJHwUL0k5FchWC7HMuGHSCfxQzeGfCioCfA0U/8s4j2D8l7Ip2HiFbvMxR5v9cJ
        rhmSa1/PvnX6sMD/eec2pI5S375xWQn4DyCH8i3bWeL2xUiyBB4b3DaXtQP9/9b4UP51C9
        BJ8WWuXorytrOJh+WOj2TYd+IKV6S5c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-u8ppvWWvOXSPPiDZu9WqFA-1; Mon, 18 Sep 2023 00:11:19 -0400
X-MC-Unique: u8ppvWWvOXSPPiDZu9WqFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3274C185A79B;
        Mon, 18 Sep 2023 04:11:19 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48A1910F1BE7;
        Mon, 18 Sep 2023 04:11:17 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 00/10] io_uring/ublk: exit notifier support 
Date:   Mon, 18 Sep 2023 12:10:56 +0800
Message-Id: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

In do_exit(), io_uring needs to wait pending requests.

ublk is one uring_cmd driver, and its usage is a bit special by submitting
command for waiting incoming block IO request in advance, so if there
isn't any IO request coming, the command can't be completed. So far ublk
driver has to bind its queue with one ublk daemon server, meantime
starts one monitor work to check if this daemon is live periodically.
This way requires ublk queue to be bound one single daemon pthread, and
not flexible, meantime the monitor work is run in 3rd context, and the
implementation is a bit tricky.

The 1st 3 patches adds io_uring task exit notifier, and the other
patches converts ublk into this exit notifier, and the implementation
becomes more robust & readable, meantime it becomes easier to relax
the ublk queue/daemon limit in future, such as not require to bind
ublk queue with single daemon.

Ming Lei (10):
  io_uring: allocate ctx id and build map between id and ctx
  io_uring: pass io_uring_ctx->id to uring_cmd
  io_uring: support io_uring notifier for uring_cmd
  ublk: don't get ublk device reference in ublk_abort_queue()
  ublk: make sure ublk uring cmd handling is done in submitter task
    context
  ublk: make sure that uring cmd aiming at same queue won't cross
    io_uring contexts
  ublk: rename mm_lock as lock
  ublk: quiesce request queue when aborting queue
  ublk: replace monitor work with uring_cmd exit notifier
  ublk: simplify aborting request

 drivers/block/ublk_drv.c       | 216 +++++++++++++++++++--------------
 include/linux/io_uring.h       |  27 ++++-
 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            |  57 +++++++++
 io_uring/io_uring.h            |   4 +
 io_uring/uring_cmd.c           |  13 ++
 6 files changed, 230 insertions(+), 90 deletions(-)

-- 
2.40.1

