Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70409514CAA
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 16:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377185AbiD2OZp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 10:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiD2OZo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 10:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E8D94EF5C
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 07:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651242145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/0gbFtgdy7CDyJjdS+yqHgi+WNEK/LMUhGKYDfnnlqU=;
        b=cj8K+tgr9tmYMTOI0v9iKEEp9v4+w4zjfOmlyidCTirOFoIOrO+gIsezdWSXQBJwDo+6jD
        /SJPiMehS064XqpuduoCpWlhPSgZc65WbUv5W//lCcc7izzBEozGq26utC3jsKeLBMgiI0
        sqZt7itKxKBEYG2N7byADkHi2zzMaT4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-k-rx8HEKNXqEiMX6FcziOQ-1; Fri, 29 Apr 2022 10:22:21 -0400
X-MC-Unique: k-rx8HEKNXqEiMX6FcziOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 712B2811E7A;
        Fri, 29 Apr 2022 14:22:21 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B3B14639DE;
        Fri, 29 Apr 2022 14:22:20 +0000 (UTC)
Date:   Fri, 29 Apr 2022 16:22:18 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: check that data field is 0 in ringfd unregister
Message-ID: <20220429142218.GA28696@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Only allow data field to be 0 in struct io_uring_rsrc_update user
arguments to allow for future possible usage.

Fixes: e7a6c00dc77a ("io_uring: add support for registering ring file descriptors")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7625b29..4e32338 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10588,7 +10588,7 @@ static int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 			ret = -EFAULT;
 			break;
 		}
-		if (reg.resv || reg.offset >= IO_RINGFD_REG_MAX) {
+		if (reg.resv || reg.data || reg.offset >= IO_RINGFD_REG_MAX) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.1.4

