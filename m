Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6BF5EEA65
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiI2AEg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiI2AEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:04:35 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD0118E
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:31 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n40-20020a05600c3ba800b003b49aefc35fso1822396wms.5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=+uc4iCBzCybZ61tUyEo3Ey2rp0QaiQnKf3jpYBhbUhE=;
        b=Ud0OePkIjZKMiHIvydR/7vwRJ9YXbC90cKPqU6tZpfSPaE88/gCS2pwplKN1PHr8aw
         T+7feL+NWpXGT3TvUjjmD6XA5Ft/WX/7a220pFBL9VtTELaOYKFiezREhJWc76bQ1ovl
         MIo53PkrGo3W4Btujg2awibN9wWn99wsoyq5g4uGOlwAutbK0YZ++ND3cFU2t3cWUA1G
         fwMSkr5motH8tAA5yRxoRQGzHK2EVHHOlSJfAZMMO+feorml9WoalAIykMrhLK4HUnms
         3AZ8fKe/4LeSHDvUKpUzjwI6MxxhcWUTJhVKJvYWL4MbrMNke8jgSNjJGtIuw/l6i5TA
         sOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+uc4iCBzCybZ61tUyEo3Ey2rp0QaiQnKf3jpYBhbUhE=;
        b=108X5zcUFyNb1Wj05gi0/D25at5JKU/M5AQXeHscJUEf66a70jbWsTsJwWiNs38UPn
         ZWTwe2j2QQHOixxyaRqI80BMDa1EMj2pqBXLscq6yqteTAACl7ixvnS+SCeAGgSgv8le
         3dsQi2hecvb9XUlt5QY0th7+QuXDDXGsX9CsCuA+o4G/Ke21NpFCXaiAFyZEWDr2RVTh
         i1GrEFSCT0nr/e0UGpVCrz4cyOBWilRXT+CkMY7CbP4pemCOkzEigzutELV2Ycu456yE
         59KhUNDmdmMpwS9mvV/79bZPcYyOW14wSzvFvru0uqKcNmj046RL2uqA4A03B1FKcMcM
         ee9Q==
X-Gm-Message-State: ACrzQf14U8d920BYAC58DdPWDzIllecNi0M2SeN1LAkrFl9MOpMgjYMC
        yH84dGmmkEpIkv8KlTNY7rxw5io51FI=
X-Google-Smtp-Source: AMsMyM7agMtNsQ4HwA5/NcXDi4JgK5OmqcQsIsMk6b8PZGdLDkVcCLxnwP/zYgS7a/TYLHdbiN8h/w==
X-Received: by 2002:a05:600c:21c3:b0:3b4:7e47:e3a with SMTP id x3-20020a05600c21c300b003b47e470e3amr287473wmj.167.1664409869685;
        Wed, 28 Sep 2022 17:04:29 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id i11-20020a05600c354b00b003b4935f04a4sm3871685wmq.5.2022.09.28.17.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring/net: fix non-zc send with address
Date:   Thu, 29 Sep 2022 01:03:29 +0100
Message-Id: <176ced5e8568aa5d300ca899b7f05b303ebc49fd.1664409532.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're currently ignoring the dest address with non-zerocopy send because
even though we copy it from the userspace shortly after ->msg_name gets
zeroed. Move msghdr init earlier.

Fixes: 516e82f0e043a ("io_uring/net: support non-zerocopy sendto")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b69eff6887e..4f671e6c8f3e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -333,6 +333,12 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	int min_ret = 0;
 	int ret;
 
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
+
 	if (sr->addr) {
 		if (req_has_async_data(req)) {
 			struct io_async_msghdr *io = req->async_data;
@@ -359,12 +365,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-	msg.msg_ubuf = NULL;
-
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-- 
2.37.2

