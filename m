Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720F35271DF
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiENOUf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiENOUd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:20:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC42BCF
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:32 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 137so10047681pgb.5
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pU7A50hXcHq7ng73ERmKvfAIUben4nCE2ouNyg1ycrA=;
        b=qVjkqMmROebnDmGUGaYAG6U3S2RGwfPcwKmrcc74YhTlURUH4HYVdJnjfGz9s2BgvX
         SmOLdQCcqldfnkfMcmMApaMJtPlpB7lE+fyk/tSbcM4ULyygD/GsPsXSaJ+AtmOtOSzx
         tnT8moN/pnyd7IxqgjqlvJseQwa+o8x89F0jtoMzUIbqHoUIY7dozQToY75BIpNHY67T
         gJ/ccflado8B+ao/g9i0IUJy0yCm6pKy8YZ0uww49tkfASwBF345iNOvibm91tBUKpgC
         lP64vcGweDFvpz2Vf7pID49OSjj3xCrveJERBBILLkefyugAwcxFc2SXD8eoUPo8VYhw
         gkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU7A50hXcHq7ng73ERmKvfAIUben4nCE2ouNyg1ycrA=;
        b=T7LSx5V46Keo8eS/An65Rt6Cony+u02069ebu62cmQrlRYvk657i4hkbG0gAIOK3V1
         IRk0lbrIo6vdTULbsqtjpIh9z56pCEnQ7aqISc+o8x70aTSKPkxiiaCn3dIzojC7Pq1T
         I9VR23fEaOoWhPLF4IpWcS9oXgYO0nvL51I/F4tMbYmMD/Z10jcCJhn5+bKM7HFhkWKb
         b/DHg+Z2nc8cyc3Io56CKs8o3xUXOkVv3CIzdBYpjfMQKJl3oRweXuIedRrUsvpAf/Zn
         haVQlk2u5QtxQ97Rw9SilrRS1m7yoCBulNtBO3KC3BVHqPMFrFSHD06DLPVy3AHLR0NX
         uPvw==
X-Gm-Message-State: AOAM531zawOmAQIzEwtqYn/uCvTxTPt47PAAibyITCRQ6QHgtE5XTUhY
        apFXkrLVZiA/izVMamoDxmIi+U5joPYNt+Si
X-Google-Smtp-Source: ABdhPJxRAq6CKGQ9wcG36rdN4gtkEy2XZIFAXHY03/GApy/02ClGHPgoJaB2OCFwKGhVtcuX4sGdDg==
X-Received: by 2002:a65:6250:0:b0:3c6:8a09:249 with SMTP id q16-20020a656250000000b003c68a090249mr8154153pgv.389.1652538032198;
        Sat, 14 May 2022 07:20:32 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm3815968plg.198.2022.05.14.07.20.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:20:31 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Sat, 14 May 2022 22:20:43 +0800
Message-Id: <20220514142046.58072-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514142046.58072-1-haoxu.linux@gmail.com>
References: <20220514142046.58072-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
support multishot.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 36ec43dc7bf9..15f821af9242 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -232,6 +232,11 @@ enum {
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 
+/*
+ * accept flags stored in sqe->ioprio
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.0

