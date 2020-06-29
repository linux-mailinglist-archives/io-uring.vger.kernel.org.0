Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBF20E065
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 23:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgF2Up6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 16:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731535AbgF2TN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:13:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD1EC008656
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z13so15944181wrw.5
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MInVKzwVBbCTPDFODv/yDRRILguVF+gkg6qyCbAQMuw=;
        b=nFu3n23aRWoeNEfUhmtyavIpybKdegU10TssOqJpihk4q2g7B2YdAM4RRjzP8+X7Sg
         GMQ/TuKzUIS20OyNSQsx47ZMnQwFG/c1q6C/b7xaVTTbk31zhuwUmE38IC2DbfYyRkDB
         FktMPMhHlYpu53W82WZFFW4IoD991B5EYyqR31Hbe62mUvbjQZXMqjC4RTo/DKEMABiH
         39/GiRZqzKKjOnMDmQz3MbjIay9/DipvjBc0ri3h4vetulfl0m2olMV5QcAwHJwqE/Ym
         8OLmAtToxEIg7XAY8eVxkAPuAZ6MLC1Cxll+wGKK+I+1mLGzJkCdXpL68AEOlYKYw3Hr
         w9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MInVKzwVBbCTPDFODv/yDRRILguVF+gkg6qyCbAQMuw=;
        b=B4XoS4yzMD5XLhMBA6D2dv7dlueA5EhImxODes+fW/Usdp0/3jPvgKF/hTR+ikKnwP
         EgTmpXNPEgG+sCBFmPcN8fSCbq07QP+WZ4wgmwALlZpHHj2WVhcESL82dAtujxLapYxn
         HQrGtwW3msXB7QkP3fH8VSlEnta0kLSXlTnVzlojMOUrKa1VYk4kjJPvD9XSb7Q5yWfk
         OK+XVbWZPio90ccidU4MKeqtwMhnSkGthJwYCcr9uE452vl34mvEWi8G5MatWKS4QBKn
         IciT6zF90Gv07Eomk4LziiJhYYkXSjZQJ1y/OyNe782cb6nawAkoK1MYwEWGweqvMQMq
         IwdA==
X-Gm-Message-State: AOAM530/5rBOam5BmtbIWi5mKk/bEVXgIR1RNy9q4I4QRWW1qOZlt10g
        HMKX22D/GCTuOl5c8hrn3E49xj+c
X-Google-Smtp-Source: ABdhPJzejbNqjlXy1AkTE5PgZMrItxXwyQ5Vxy+d27RU4TQgwbvtJzDvNnX2609onDdYauUDA71BFA==
X-Received: by 2002:adf:fe0b:: with SMTP id n11mr16225512wrr.245.1593425689245;
        Mon, 29 Jun 2020 03:14:49 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: kill REQ_F_TIMEOUT
Date:   Mon, 29 Jun 2020 13:13:01 +0300
Message-Id: <de75e8dc7bb6bd826161926791e7576479f4a910.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593424923.git.asml.silence@gmail.com>
References: <cover.1593424923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now REQ_F_TIMEOUT is set but never used, kill it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 52e5c8730dd5..159882906a24 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -531,7 +531,6 @@ enum {
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
-	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
@@ -574,8 +573,6 @@ enum {
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
 	/* has linked timeout */
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
-	/* timeout request */
-	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* no timeout sequence */
@@ -5040,7 +5037,6 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data = &req->io->timeout;
 	data->req = req;
-	req->flags |= REQ_F_TIMEOUT;
 
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
-- 
2.24.0

