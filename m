Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311F4617925
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 09:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiKCIwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 04:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiKCIvp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 04:51:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC6AD2D1
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 01:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667465444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bv8EKan1TkTFIJ/b08ygqoNPGp8v59Xr0rg9p15U8hc=;
        b=Fm7JLJ3QW68VNOzYk4Y2u8tXjR8FNFVCMlBn3emnG6GxT1KkuZcxw75Uo61XttUdTulpL0
        kW8bLfvWNlcGcTKe5wQWGFvAzxDX5ZvRJNNLCsYv0CR0NpduxSQQJ9mEs4HucUSvZeq6Nz
        gUa2gKRGOEtmK9QzEbx05pDFo+WrwgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-vvSZal0vOFOVjiSTmwbjmw-1; Thu, 03 Nov 2022 04:50:33 -0400
X-MC-Unique: vvSZal0vOFOVjiSTmwbjmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1527C811E84;
        Thu,  3 Nov 2022 08:50:33 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28D892166B26;
        Thu,  3 Nov 2022 08:50:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 2/4] fs/splice: add helper of splice_dismiss_pipe()
Date:   Thu,  3 Nov 2022 16:50:02 +0800
Message-Id: <20221103085004.1029763-3-ming.lei@redhat.com>
In-Reply-To: <20221103085004.1029763-1-ming.lei@redhat.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add helper of splice_dismiss_pipe(), so cleanup iter_file_splice_write
a bit.

And this helper will be reused in the following patch for supporting
to consume pipe by ->splice_read().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/splice.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 0878b852b355..f8999ffe6215 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -282,6 +282,34 @@ void splice_shrink_spd(struct splice_pipe_desc *spd)
 	kfree(spd->partial);
 }
 
+/* return if wakeup is needed */
+static bool splice_dismiss_pipe(struct pipe_inode_info *pipe, ssize_t bytes)
+{
+	unsigned int mask = pipe->ring_size - 1;
+	unsigned int tail = pipe->tail;
+	bool need_wakeup = false;
+
+	while (bytes) {
+		struct pipe_buffer *buf = &pipe->bufs[tail & mask];
+
+		if (bytes >= buf->len) {
+			bytes -= buf->len;
+			buf->len = 0;
+			pipe_buf_release(pipe, buf);
+			tail++;
+			pipe->tail = tail;
+			if (pipe->files)
+				need_wakeup = true;
+		} else {
+			buf->offset += bytes;
+			buf->len -= bytes;
+			bytes = 0;
+		}
+	}
+
+	return need_wakeup;
+}
+
 /**
  * generic_file_splice_read - splice data from file to a pipe
  * @in:		file to splice from
@@ -692,23 +720,8 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		*ppos = sd.pos;
 
 		/* dismiss the fully eaten buffers, adjust the partial one */
-		tail = pipe->tail;
-		while (ret) {
-			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
-			if (ret >= buf->len) {
-				ret -= buf->len;
-				buf->len = 0;
-				pipe_buf_release(pipe, buf);
-				tail++;
-				pipe->tail = tail;
-				if (pipe->files)
-					sd.need_wakeup = true;
-			} else {
-				buf->offset += ret;
-				buf->len -= ret;
-				ret = 0;
-			}
-		}
+		if (splice_dismiss_pipe(pipe, ret))
+			sd.need_wakeup = true;
 	}
 done:
 	kfree(array);
-- 
2.31.1

