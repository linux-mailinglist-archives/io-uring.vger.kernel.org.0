Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF36A6DE9
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCAOJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjCAOJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:09:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA65B1A4B2
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgL0MAAgWmqfO+9t+5jpWAVNrZVmdtUVYegvFw8KI4g=;
        b=NxQocpqX85tbABeJ6nkQNI2xvgrRxyXH8zeQZtR3f/dkChEFFc0EtyA8r6st6TvEgp4WbH
        trftZLalsqjmRTI38Lz80gUzMwNNfR/4RQ2aXjomIRytVa7jkfzLjbmNzFfp1Shi+E6mMK
        X8bjWqBhxQVjxfaZ6bd+fQmyJasB6TM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-EElNq6KeN4CQA32vZtj2Dw-1; Wed, 01 Mar 2023 09:07:59 -0500
X-MC-Unique: EElNq6KeN4CQA32vZtj2Dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B372B84AC99;
        Wed,  1 Mar 2023 14:06:27 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F113E1121318;
        Wed,  1 Mar 2023 14:06:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 01/12] io_uring: increase io_kiocb->flags into 64bit
Date:   Wed,  1 Mar 2023 22:06:00 +0800
Message-Id: <20230301140611.163055-2-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 32bit io_kiocb->flags has been used up, so extend it to 64bit.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 2 +-
 io_uring/io_uring.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0efe4d784358..87342649d2c3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -530,7 +530,7 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
+	u64				flags;
 
 	struct io_cqe			cqe;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1df68da89f99..09cc5eaec4ab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4418,7 +4418,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
-- 
2.31.1

