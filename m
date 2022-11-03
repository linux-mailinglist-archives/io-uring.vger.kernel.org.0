Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01634617922
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 09:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiKCIvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 04:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiKCIvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 04:51:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58CFD13B
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 01:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667465432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDA3qRRkp7ROYhYReLuXeczugOI8k0pmRRjImuHFcO0=;
        b=G6PE3ngKauEs74BMInzNhsujna8d5e94C2hpkaViVLILCT9cJpBDSVVsDbouXsfPWodXYf
        OinouaDtOa/PynuWXlakQa87BK4K0rcYf8YOWuTaRqjrlFfOzBxpafw2LJSp9VqhPfIl6o
        7AV7NEBEbncKAhsvBGXrSIkstg9ARq4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-7Pg4MZE_O6GN3gizwamFpg-1; Thu, 03 Nov 2022 04:50:29 -0400
X-MC-Unique: 7Pg4MZE_O6GN3gizwamFpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECD5A811E75;
        Thu,  3 Nov 2022 08:50:28 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 086592084836;
        Thu,  3 Nov 2022 08:50:27 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 1/4] io_uring/splice: support do_splice_direct
Date:   Thu,  3 Nov 2022 16:50:01 +0800
Message-Id: <20221103085004.1029763-2-ming.lei@redhat.com>
In-Reply-To: <20221103085004.1029763-1-ming.lei@redhat.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_splice_direct() has at least two advantages:

1) the extra pipe isn't required from user viewpoint, so userspace
code can be simplified, meantime easy to relax current pipe
limit since curret->splice_pipe is used for direct splice

2) in some situation, it isn't good to expose file data via
->splice_read() to userspace, such as the coming ublk driver's
zero copy support, request pages will be spliced to pipe for
supporting zero copy, and if it is READ, userspace may read
data of kernel pages, and direct splice can avoid this kind
of info leaks

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/read_write.c        |  5 +++--
 include/linux/splice.h |  3 +++
 io_uring/splice.c      | 13 ++++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 328ce8cf9a85..98869d15e884 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1253,7 +1253,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 			goto fput_out;
 		file_start_write(out.file);
 		retval = do_splice_direct(in.file, &pos, out.file, &out_pos,
-					  count, fl);
+					  count, fl | SPLICE_F_DIRECT);
 		file_end_write(out.file);
 	} else {
 		if (out.file->f_flags & O_NONBLOCK)
@@ -1389,7 +1389,8 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 				size_t len, unsigned int flags)
 {
 	return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+				len > MAX_RW_COUNT ? MAX_RW_COUNT : len,
+				SPLICE_F_DIRECT);
 }
 EXPORT_SYMBOL(generic_copy_file_range);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..9121624ad198 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -23,6 +23,9 @@
 
 #define SPLICE_F_ALL (SPLICE_F_MOVE|SPLICE_F_NONBLOCK|SPLICE_F_MORE|SPLICE_F_GIFT)
 
+/* used for io_uring interface only */
+#define SPLICE_F_DIRECT	(0x10)	/* direct splice and user needn't provide pipe */
+
 /*
  * Passed to the actors
  */
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 53e4232d0866..c11ea4cd1c7e 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -27,7 +27,8 @@ static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
-	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
+	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL |
+		SPLICE_F_DIRECT;
 
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
@@ -109,8 +110,14 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
-	if (sp->len)
-		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+	if (sp->len) {
+		if (flags & SPLICE_F_DIRECT)
+			ret = do_splice_direct(in, poff_in, out, poff_out,
+					sp->len, flags);
+		else
+			ret = do_splice(in, poff_in, out, poff_out, sp->len,
+					flags);
+	}
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-- 
2.31.1

