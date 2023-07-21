Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E2A75CE23
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjGUQSh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjGUQSE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15CA4219
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so25862939f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956218; x=1690561018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7cLLw1JpMnOMXLNHlH7JagCdHX69bYdsN+9qujHNmA=;
        b=vAUGNAgV1Vbq0eLmgbSiSvCxRWW2+Cw9dLYbFJT3lDY7TdJ5AZFO7HBSWJdLUoNNIA
         XdMVnORN2Hq+gCapIl1iD8L515U+oRRCx5H8wKu4bfBM13MOfjjNqDlTcimtvilsRWFt
         h6RVxA+lgtJl9gnjCNmQqTi/HI3+iOmdW5lnItmg+NDFaLFRT4EUUW/FJ4OuKFHIPZxq
         BrWLIAmRfd+v7rLsQnNBbiVPJWO+xH3VoDmfomiD9AdisfnGxvlMrFhDUHSIPIT5arF/
         m61tR+TRcbo23cOs5c9J4YdLTUd5kw+IKQxzRmndPACj0Rvd0hc1zHVtKOKQ3e4PXYIW
         VOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956218; x=1690561018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7cLLw1JpMnOMXLNHlH7JagCdHX69bYdsN+9qujHNmA=;
        b=i/eYPF83+NLIgLA4IOlcVnnICUK4nzh9z6dQ33PEBVvyTRSJd90BYE8DTx2GAl9W5F
         luEzzI2+7nLyrlExuwZgDFJriq0MsE3raSVZJ15+Vb412iPZtMF3aiUcQEFsL+QfA6pR
         ruB6P41TsKgW4FTn2eae0t8FGk+b9VLuXpWCkJzA+ppWP1SS/seibHRxjnsYRB/wRpzS
         uzh2M+Vtjd21SAw/ApduTCfeHlVPJYwfp91ZI9FmyShPQaow7uwYL+kLqNFSUXU8B66G
         D+/evzMvco/UKKxBMjbqaQQqGQ9/AeYtJXeGwHDdEJ0Kf6dn/KDGtxfOrfrzFTA56ihm
         JPlQ==
X-Gm-Message-State: ABy/qLZPrVjV1JY8NVMNMQiEUJVxzm/HfekjPB0oJL0UcXImCkrvzo63
        wsgth8Ye7oZ3rQlOTDbj3Yn+on1aEciLvydYpT0=
X-Google-Smtp-Source: APBJJlFG0eKMp+V3bd8Ngr/HkKy7BtsI6srIw0YeAKla/vxNKEZgZUFepNJgNUqes7/7Q1N6HppK3A==
X-Received: by 2002:a05:6602:14d2:b0:783:6ec1:65f6 with SMTP id b18-20020a05660214d200b007836ec165f6mr3086501iow.1.1689956218099;
        Fri, 21 Jul 2023 09:16:58 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] iomap: add IOMAP_DIO_INLINE_COMP
Date:   Fri, 21 Jul 2023 10:16:43 -0600
Message-Id: <20230721161650.319414-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

