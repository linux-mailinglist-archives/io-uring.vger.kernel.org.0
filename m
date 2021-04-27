Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C899036C877
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 17:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhD0POw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 11:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbhD0POv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 11:14:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B17C061756
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:06 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k14so9935888wrv.5
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IyjGJ6ajq70QcBsatsOARYaJD4M8/wklyqTGu1x8SUM=;
        b=r+baP4rdnkC/i9BZ73XfgjNjrkZVYIGFPEyRP2u1bqUPsAJZnKysseD1GQR/56Tfh6
         2HOjetIUmp33VINBCRtymEnfSPX/I1bqG0veLXAMmXtfv28qBnQvxLMtUomsh4ALjPfS
         TNopsNeNggNsupqzbbaDL+VvSSabxt5KCd8MKgoJ1o1un6gCrkwyFhWP8k7XFVODhBwW
         5THOE9JDn9LB3vd9cy2jAhmwnfncO7FdU7HU/VqMniXokhaSynh6Lg7qZTGeTyu/fFdA
         aX+RS8vPltNf8af7wMXQC8+I/Lv9I/qBcXoS5roSLMggD44zwMPYi/zEgIYuDso3YJnD
         JfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IyjGJ6ajq70QcBsatsOARYaJD4M8/wklyqTGu1x8SUM=;
        b=BrNnD0RYN3t0qCG/hlBQPlbVSrNB/hNUJw62ofaXOv4Je4yYuKa3GmFqT9aGvYJQSx
         95lekNW1Us1/PG5f5FVGrJ4xzBlQk0tqJFMzESSfQZGK8PjfWUpUVXPeiiwyHkFqUVwO
         58griIO0COxbwb7VO9qO4ZKGhBeeky7p6h04s7a5nv0oGGHhx0mH9qGt9QoazYDkPFsd
         hujM/pLjb9x75MKXaVvoPu1XYiJUvr7scTgqUs7rxDu1yU8qxJYPXdB1XRzJ6Ds43puw
         /Btev3hF0XrN7pgrmkQloLJ012AhcTqvh6EonS/kS0i4Q0Iwx5IWqnvxPjSMCXQ0J783
         GQhA==
X-Gm-Message-State: AOAM530t66hYGaMnNQIw2F0NdpsHXI5N4Xnnn8Feci/sY+3/SoD/D9lq
        7jXIpFs6VhUFey0HP1UTauo=
X-Google-Smtp-Source: ABdhPJzJfoYi7j8MfnFb3dCjoXajwB9gEzfXlBxbHHEdcQjFhJIAkZKVzhG0IU2VzlGbyprXbPjm7Q==
X-Received: by 2002:adf:f947:: with SMTP id q7mr29889344wrr.414.1619536445620;
        Tue, 27 Apr 2021 08:14:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i2sm1629630wro.0.2021.04.27.08.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:14:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: dont overlap internal and user req flags
Date:   Tue, 27 Apr 2021 16:13:52 +0100
Message-Id: <b8b5b02d1ab9d786fcc7db4a3fe86db6b70b8987.1619536280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619536280.git.asml.silence@gmail.com>
References: <cover.1619536280.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CQE flags take one byte that we store in req->flags together with other
REQ_F_* internal flags. CQE flags are copied directly into req and then
verified that requires some handling on failures, e.g. to make sure that
that copy doesn't set some of the internal flags.

More all internal flags to take bits after the first byte, so we don't
need extra handling and make it safer overall.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3b7fe6ccb0e..3419548ccaf5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -702,7 +702,8 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
-	REQ_F_FAIL_LINK_BIT,
+	/* first byte is taken by user flags, shift it to not overlap */
+	REQ_F_FAIL_LINK_BIT	= 8,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
@@ -6503,14 +6504,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->work.creds = NULL;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
-		req->flags = 0;
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
 		return -EINVAL;
-	}
-
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
-
 	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
 		return -EACCES;
 
-- 
2.31.1

