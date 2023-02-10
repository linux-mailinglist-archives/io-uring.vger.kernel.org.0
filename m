Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0B692248
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 16:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjBJPdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 10:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjBJPds (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 10:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CBE5CBCE
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676043176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uj7Rv4KeEREhQreSkWBQhCSYBs5N5QoJeDQDwyenPI4=;
        b=Ie8FYXHnv1tdIBrJyGUOwIWkwyXkJr+izlQsFPcoDXbEv4EVrDTksEXeUVxHh6lhWnWW4L
        8tgHhYWfSPxO5KaBUAgBvH0dAu+dVjDHopwBYOog/AHJ4R+hwjhuXzR+TQCcQTK8ClPKSf
        hXk5NLJTPP2FKIRJjJRSU0vaFDWVyZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-2NAH9aGyPMmisW9aHU-23Q-1; Fri, 10 Feb 2023 10:32:53 -0500
X-MC-Unique: 2NAH9aGyPMmisW9aHU-23Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE39B85A5A3;
        Fri, 10 Feb 2023 15:32:52 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACBAF1121315;
        Fri, 10 Feb 2023 15:32:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/4] fs/splice: allow to ignore signal in __splice_from_pipe
Date:   Fri, 10 Feb 2023 23:32:10 +0800
Message-Id: <20230210153212.733006-3-ming.lei@redhat.com>
In-Reply-To: <20230210153212.733006-1-ming.lei@redhat.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__splice_from_pipe() is used for splice data from pipe, and the actor
could be simply grabbing pages, so if the caller can confirm this
actor won't block, it isn't necessary to return -ERESTARTSYS.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/splice.c            | 4 ++--
 include/linux/splice.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index c4770e1644cc..a8dc46db1045 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -471,7 +471,7 @@ static int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_des
 	 * Check for signal early to make process killable when there are
 	 * always buffers available
 	 */
-	if (signal_pending(current))
+	if (signal_pending(current) && !sd->ignore_sig)
 		return -ERESTARTSYS;
 
 repeat:
@@ -485,7 +485,7 @@ static int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_des
 		if (sd->flags & SPLICE_F_NONBLOCK)
 			return -EAGAIN;
 
-		if (signal_pending(current))
+		if (signal_pending(current) && !sd->ignore_sig)
 			return -ERESTARTSYS;
 
 		if (sd->need_wakeup) {
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 98c471fd918d..89e0a0f8b471 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -64,6 +64,7 @@ struct splice_desc {
 	loff_t *opos;			/* sendfile: output position */
 	size_t num_spliced;		/* number of bytes already spliced */
 	bool need_wakeup;		/* need to wake up writer */
+	bool ignore_sig;
 };
 
 struct partial_page {
-- 
2.31.1

