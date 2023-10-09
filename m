Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF207BD729
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345753AbjJIJgG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbjJIJgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94CDB6
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tq+Ci0wfhdVfXx27WuiNYwGov0M93T2ZRy4Z/qGJvWw=;
        b=IdsE8dJ6szepVvrmW3pqXBfvbovSA6mLOigAUCttuCwm0C7LvScz9RiSL16RIDK1bBTgLN
        QERQjAWgkyh//DBTsNbXio85itd29qdk1XYltU4NmNXkM2vPLH9NH93feoCVAmF8sMJJRh
        +bVUJPFzLhpyRrwi6ZzF4NkS5jGE60w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-Ph7N5N8PN_arA3l8LJwbJw-1; Mon, 09 Oct 2023 05:34:26 -0400
X-MC-Unique: Ph7N5N8PN_arA3l8LJwbJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56ECA85A5BD;
        Mon,  9 Oct 2023 09:34:26 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82161140E962;
        Mon,  9 Oct 2023 09:34:25 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with cancelable uring_cmd
Date:   Mon,  9 Oct 2023 17:33:15 +0800
Message-ID: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Simplify ublk request & io command aborting handling with the new added
cancelable uring_cmd. With this change, the aborting logic becomes
simpler and more reliable, and it becomes easy to add new feature, such
as relaxing queue/ublk daemon association.

Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
of blktests.


Ming Lei (7):
  ublk: don't get ublk device reference in ublk_abort_queue()
  ublk: make sure io cmd handled in submitter task context
  ublk: move ublk_cancel_dev() out of ub->mutex
  ublk: rename mm_lock as lock
  ublk: quiesce request queue when aborting queue
  ublk: replace monitor with cancelable uring_cmd
  ublk: simplify aborting request

 drivers/block/ublk_drv.c | 306 ++++++++++++++++++++++++---------------
 1 file changed, 190 insertions(+), 116 deletions(-)

-- 
2.41.0

