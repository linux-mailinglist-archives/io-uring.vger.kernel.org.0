Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7933F788325
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 11:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbjHYJLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbjHYJLa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 05:11:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3A1BD9
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 02:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692954638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a+pGH+z7QUdI0m+ykxwJUuvoAK3X6BtRIZS4sAYva04=;
        b=Tyx6rYkpTyKhmh8c6/0twqJo/Vx8XGVxjLA82v12sKFKgCrZNT9J/QpjHYc7LJwSkhwyVF
        vIbX6OR/B4034K56BngtsmuqOlNSlynFySuz3ivWQrwqtezizcJ4vGOAzfsrh+ra1fbmzJ
        2+BUw+uB4iGl8QzEHB/OFzwPDhPpsgY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-eVymPfdkMtKD4-Kl57CkSQ-1; Fri, 25 Aug 2023 05:10:33 -0400
X-MC-Unique: eVymPfdkMtKD4-Kl57CkSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB54228040D4;
        Fri, 25 Aug 2023 09:10:30 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B202026D76;
        Fri, 25 Aug 2023 09:10:29 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] io_uring: fix IO hang in io wq exit
Date:   Fri, 25 Aug 2023 17:09:57 +0800
Message-Id: <20230825090959.1866771-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

The 1st patch add one helper, and the 2nd one fixes IO hang issue[1]
reported by David Howells.

[1] https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/

Ming Lei (2):
  io_uring: add one helper for reaping iopoll events
  io_uring: reap iopoll events before exiting io wq

 io_uring/io_uring.c | 27 +++++++++++++-------
 io_uring/io_uring.h |  1 +
 io_uring/tctx.c     | 60 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 71 insertions(+), 17 deletions(-)

-- 
2.40.1

