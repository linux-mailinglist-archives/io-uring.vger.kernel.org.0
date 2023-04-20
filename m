Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5956E9BB3
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjDTScc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 14:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjDTScT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 14:32:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60D6A4C
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:40 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-760f040ecccso7656739f.1
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682015499; x=1684607499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNBNMSl1jOPYogsKOmmzMd0l9YXo4Oz/6dQdAI0cTVA=;
        b=2e7ydIF1lE5pIcqLrgPngNieVBPG80J3zFrU8eWekVQFmwYBArfTJ0yJMVbpiMN3vW
         9jGG0W/qWgWuNV7Uf6k85NQgqYIP0Ccs1psgSLB+8pBCvziyQ57jjZ8T9oDlsFNDOIcw
         blHNhhS6+RwQINq7fTL0aeN2Hi0leV+15XwN6DkuVL0stn+LA99yy3wWANXeCFI5hL8O
         w87UR8KcJVWRCG5BXJNjRhvQSalNkfyLHgbaIUVtNQQoMcsFJ8RrMc8HtJypkcLwcvLW
         idoqkQB2NuisMzPNe03ZznM+3MZF6baapOPNYhvw5KN3FzKneiwWxkHUMkbjey8jza9/
         U8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015499; x=1684607499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNBNMSl1jOPYogsKOmmzMd0l9YXo4Oz/6dQdAI0cTVA=;
        b=fkK3MMF4nQlVDDuK5OM0OIu2mqBWFr3Vzo9jhpI1NHiP7q03ZgiHz+JCSt7wVf5j0/
         G/fICGwU7iT1C5DLm8Sx8e7aYAy90qlhQiGklstFdrWPoNhEED6mRjdV+luBnvy5eCsz
         ObS7SebhqXDYAXEdFXP/VS3+os8PrDhxUftLfz2gBCKyl0YElfyU8nACLl19kzaHq+/I
         3ES2Tf8I+maYJbrKfkn1R26to4KdgHlnydhaGiB6qy/dAbvtEutzOsKvZud/Y5sXfS7k
         yoqcSpJ0w84MP7sZXHJMBEKC2CiTuOI1Yfk1psminSzpRx7wdhg1T4s/LalRuN8iy9hx
         AUMA==
X-Gm-Message-State: AAQBX9edHvybSqNELM00rJjDhPhwnwBff+YpFhBxsDGJshvKPyRV5Yky
        ILXG4EUrdLYTcJluEvFgHrX/9Ca/pvvjDiMvR7w=
X-Google-Smtp-Source: AKy350ZRK6mVYJ3NIVz/OraNh0aOBK1TkyhoaHTEw7h6sa12J0GHqelcxrSa/e1iiwydSSIzAd4jnA==
X-Received: by 2002:a05:6602:2d91:b0:763:86b1:6111 with SMTP id k17-20020a0566022d9100b0076386b16111mr2264707iow.2.1682015499455;
        Thu, 20 Apr 2023 11:31:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dl36-20020a05663827a400b003c4e02148e5sm659132jab.53.2023.04.20.11.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 11:31:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] Revert "io_uring: always go async for unsupported fadvise flags"
Date:   Thu, 20 Apr 2023 12:31:33 -0600
Message-Id: <20230420183135.119618-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420183135.119618-1-axboe@kernel.dk>
References: <20230420183135.119618-1-axboe@kernel.dk>
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

