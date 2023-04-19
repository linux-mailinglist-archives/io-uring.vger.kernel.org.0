Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F3A6E7F93
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjDSQ0A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbjDSQ0A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:26:00 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC5C3C15
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b9f00640eso15047b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921559; x=1684513559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNBNMSl1jOPYogsKOmmzMd0l9YXo4Oz/6dQdAI0cTVA=;
        b=xwCOf3X4PlfnWhWSaAtpYQ2FhzyfRy7QNDiwtG7uFYejQ4r6TA/1X3kOmMWLkswwvE
         Vk/HaoaFgvZrSsxxIOH8OVOoqoV7UbS+cfGqCkIt1f5TPN8rzaovlVSwA+QLhlt/aLIe
         bfI0nesHoTb9UJSwb1Ln+KoeExoajaRBhCoapEZX6tJ8RmCnbriYBmFdM0BT7z8IDXNM
         FHxhtoCGEDXrs01p6pYxeDpsrKfg8KfDds5HSkCNV94zkm4IWyIKjaxtYs9ZaDreKop4
         WlGZkziX9fUjpnKdc6Vfw3VH57J0g2/WkCERiPSmTtb7Qoghybt9NsJ3FwEKvPRxcQIm
         632Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921559; x=1684513559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNBNMSl1jOPYogsKOmmzMd0l9YXo4Oz/6dQdAI0cTVA=;
        b=h5aAkAarEs5q2N9k0IRQx2M12ZnHsoIK0925vQbujCr4TZxRru45+zog+ulIY8dXdl
         nOchJD5meRmTyj2FuiS0yj2RXc0o2m/WiyoqmDyF7irvtFxcsPbP5EB4u3Oc/OfQscoG
         4Ck01Fd/urxvGDU4fOIyHeb7pb2rqMJ1oj9o8fEQZ8SCSQJLHD8cuQOJcvO2YXpKaMB3
         vT4PRQYExJ3tgrZec/X3GJte4v2n1vIXbNoMLCw8wffuQ1Z5y3iSFJJIaKY0vs0zS4q0
         OLjFiqPSvQpo0cf6C8BcWACQ+I+EIrzuI5xRpr73azN4+NClOOM/SIAnG7E/ValBxOcl
         8A0w==
X-Gm-Message-State: AAQBX9ejpi6Qf5TgwAyISVh+eL1jvpFe6DPwmHw5qrzHa+zaeWCcfTP7
        qvP4L7eoT16C0wk24HXSqgMpFxWML62/KDLOPnI=
X-Google-Smtp-Source: AKy350apdSgkk2XYXjP9RgnTE35elIKF4K+nqx/4fCOwWDqPKNzyTF6eVMcJtLTUYe0XM0WYmAM0hA==
X-Received: by 2002:a05:6a00:26d2:b0:63b:5257:6837 with SMTP id p18-20020a056a0026d200b0063b52576837mr20011980pfw.1.1681921558771;
        Wed, 19 Apr 2023 09:25:58 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] Revert "io_uring: always go async for unsupported fadvise flags"
Date:   Wed, 19 Apr 2023 10:25:50 -0600
Message-Id: <20230419162552.576489-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit c31cc60fddd11134031e7f9eb76812353cfaac84.

In preparation for handling this a bit differently, revert this
cleanup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/advise.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/io_uring/advise.c b/io_uring/advise.c
index 7085804c513c..cf600579bffe 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -62,18 +62,6 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 #endif
 }
 
-static bool io_fadvise_force_async(struct io_fadvise *fa)
-{
-	switch (fa->advice) {
-	case POSIX_FADV_NORMAL:
-	case POSIX_FADV_RANDOM:
-	case POSIX_FADV_SEQUENTIAL:
-		return false;
-	default:
-		return true;
-	}
-}
-
 int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
@@ -84,8 +72,6 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	fa->offset = READ_ONCE(sqe->off);
 	fa->len = READ_ONCE(sqe->len);
 	fa->advice = READ_ONCE(sqe->fadvise_advice);
-	if (io_fadvise_force_async(fa))
-		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
@@ -94,7 +80,16 @@ int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
 	int ret;
 
-	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK && io_fadvise_force_async(fa));
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		switch (fa->advice) {
+		case POSIX_FADV_NORMAL:
+		case POSIX_FADV_RANDOM:
+		case POSIX_FADV_SEQUENTIAL:
+			break;
+		default:
+			return -EAGAIN;
+		}
+	}
 
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
-- 
2.39.2

