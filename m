Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA14240D6
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbhJFPJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbhJFPJc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:32 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBC3C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v17so9789402wrv.9
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xADS+b4vi/HR/+m10KWQ7Q+fIERahTDvX0Wwqhr9Vz8=;
        b=XieBg+XUufGOItEdt99oDpNdhZFQqd/9WcL2uMt6b7zV60wOCJfE+jaNxYwHQm3rAH
         WjxSh4BofT7OwybygPahXeGskERc/r2gisHFPjb96h7j5WrtOuWJlh4s5Nx3xXggqFAu
         1HOZTHSAjaiZ6PQlwoS9Ayn9tq8itIw3VLWwkcfrv2jSd0RXI2KKRi6tv33Ib5yTKXT/
         QBDVgNy6gugQuBfLZocmiOnXIDew+moAMa8ajtxUEqXUdbnJM/Ul/XUZSwoJK3akjn5Y
         h8FXlTP3Qg3JoLbB9svdilXAsJ3lgdP8y3B79uEoMeLvlqXXwNVWwSGIv2GdFl8mtCTZ
         6O+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xADS+b4vi/HR/+m10KWQ7Q+fIERahTDvX0Wwqhr9Vz8=;
        b=IhuTal6girVEWnk2gulGmcZMyqzl2kPmLDHFpOVulfqRZAt5njg6W9K+Fqf5njR8tk
         Lvpcl1XDZEYa5GHRdaHnryFrGIDduM5Ml8cfNslvdJy9HxWciBb7VdJpoZRPYsBM+wgV
         66V6g2AMEV9LHvnJ334wgbLfbzK/FmHZ/LUXtDIkaoWnOlHvWWbW7sv26XG8QyXfAdq6
         7bGpo3pvke6lSpPZWIOuVqQoTMEBDq+tow9C5GfYIKrxhXTbNja9KBl4C+F5VglyYaC9
         GYprRY291n3TiSdxDxTu8q38rz3ssp8PBCBQRBzJ9pIcQPr/e8/VE4TLtYjbd8WqPLR0
         n1pg==
X-Gm-Message-State: AOAM533NEXRjeNCJWTvx1YoKonYsAvcwZxir89uoTa7a5mmNRee3UUt2
        pJzWsauZXk6R8S6381qOn5a2WxDW7M0=
X-Google-Smtp-Source: ABdhPJyr3m71EyxV5tgwfyjj2st7dhKVXpSIUXOKcaJ3K3r6bT3llvy2lkWewdT227LtPTAbdg4Heg==
X-Received: by 2002:adf:8b59:: with SMTP id v25mr30224012wra.386.1633532858805;
        Wed, 06 Oct 2021 08:07:38 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: reshuffle io_submit_state bits
Date:   Wed,  6 Oct 2021 16:06:48 +0100
Message-Id: <6ad3c15849f50b27ad012c042c73e6e069d22df7.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633532552.git.asml.silence@gmail.com>
References: <cover.1633532552.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_submit_state's ->free_list and ->link are hotter and smaller
than ->plug, place them first.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b61ffb1e7990..3f8bfa309b16 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -308,19 +308,15 @@ struct io_submit_link {
 };
 
 struct io_submit_state {
-	struct blk_plug		plug;
+	/* inline/task_work completion list, under ->uring_lock */
+	struct io_wq_work_node	free_list;
+	/* batch completion logic */
+	struct io_wq_work_list	compl_reqs;
 	struct io_submit_link	link;
 
 	bool			plug_started;
 	bool			need_plug;
-
-	/*
-	 * Batch completion logic
-	 */
-	struct io_wq_work_list	compl_reqs;
-
-	/* inline/task_work completion list, under ->uring_lock */
-	struct io_wq_work_node	free_list;
+	struct blk_plug		plug;
 };
 
 struct io_ring_ctx {
-- 
2.33.0

