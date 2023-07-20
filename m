Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CED75B63C
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjGTSNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGTSNT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A2E92
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:18 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so13863139f.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876797; x=1690481597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imYhKP5v89lbPeTtC2wFGbz9kkgQjFqYE28HmmHERmw=;
        b=GrebEaRZHzYbDBDN/hmIpElSBatOqma0fWwnvNuied5zdXHf3S2dMzyUVfN3HdsjOT
         Qszjbxczbi7MewAEfrn+CLSFDleXg6brNEGAeqS9bXrHhWAloF4dFe0IZHeEFwHb0nNE
         auYYzqJkR4Gp+3yBQkCeRS+G/eSCS1cTH/1XyHGsVhFqzBFEXw4FzJgcYpAHStkNC5cl
         griSBiK5VjLUtfMP0/yk1Y47qdiAffkCq4Fp945EVpPQfnVFIP7ShDV3/5UAj72dlrD+
         olR1qIegksSBF77fDrVQj/oYhFIeRzHWUg4t4Aob2HfUX7zxABpgY9qgDAeLUk7U88An
         DS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876797; x=1690481597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imYhKP5v89lbPeTtC2wFGbz9kkgQjFqYE28HmmHERmw=;
        b=TSKtltulLMJKR2SS9brcmp/qzW79tI9BLDJJnYW+Otr6CjAnQRpuqzRaRVPIMICbTD
         Oht3Z5keQ8D++eqQwI7PaMtG3hRmHKFcbe7eB+lwrr4KEQzfKwn16AXvZrqQXfroa9VO
         anpK+oh7PJg0vb1zEl5fhnIQKcxPBcj/QoUax082QZ8Cy/GquX+sYXzzNpDWGnLeY9z1
         xP2Sdey+//bxrKxo6XodTySR2C44X4iTWjPFdB4SWtXWf4T8Ov5+mv/KYumo4qqiJnVw
         yiksSYDkWt8jvitCiLqDYej0fJBlhSDC28/1pws12n7+AF1th39y4qwG/rfKC9uMAjE7
         ddkQ==
X-Gm-Message-State: ABy/qLYxiihcIo1CBJ/+3lFQodf+3NRoHRRq57cT/CYKDLmQkw7htPOs
        mju7eXM0WMvmVCnCYyGoBybQMpDH58TofiKouZo=
X-Google-Smtp-Source: APBJJlEZ9N8QzhpudFyRYfXhPH7GjbxneV6i6nTiweh3A/yxGmb9RNjs4YJ7JIBjRusSqCTQ0Et8pQ==
X-Received: by 2002:a92:d902:0:b0:345:a3d0:f0d4 with SMTP id s2-20020a92d902000000b00345a3d0f0d4mr3508495iln.3.1689876797148;
        Thu, 20 Jul 2023 11:13:17 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] iomap: add IOMAP_DIO_INLINE_COMP
Date:   Thu, 20 Jul 2023 12:13:04 -0600
Message-Id: <20230720181310.71589-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than gate whether or not we need to punt a dio completion to a
workqueue on whether the IO is a write or not, add an explicit flag for
it. For now we treat them the same, reads always set the flags and async
writes do not.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 0ce60e80c901..c654612b24e5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
@@ -171,8 +172,10 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		goto release_bio;
 	}
 
-	/* Read completion can always complete inline. */
-	if (!(dio->flags & IOMAP_DIO_WRITE)) {
+	/*
+	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
+	 */
+	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 		goto release_bio;
@@ -527,6 +530,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_NOWAIT;
 
 	if (iov_iter_rw(iter) == READ) {
+		/* reads can always complete inline */
+		dio->flags |= IOMAP_DIO_INLINE_COMP;
+
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
-- 
2.40.1

