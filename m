Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E9145CE89
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 21:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbhKXVBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 16:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244393AbhKXVBb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 16:01:31 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD01C06173E
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e3so16124840edu.4
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 12:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8yV2iUvrEwjCOCNOZ1eZQ5sQAfGgdHqJMoYgtnGfqA=;
        b=qdDkPc3prQY0yq5v5/s4WOSRxKLCfQRM9IJ/iR4z1fF1Cj2Sn3nKJq8rI7t0jqHZ08
         xLQJQYdOBRx6uToUS+WBUa2Hz60gw0bZ7MsHEabgsYsoldP7+5YQR570nRoHGkcL/iv6
         0swr1xFg5QTz4qoRp/5Bz7L84xGJ8KePXrhu7wGqisqYQplZq4nMo6BpU1XAzjbwxM0p
         Tcg9DZh0B9FF1Gh90S+9g4YFAc5wDinixl5WkzcDvrkaap7I3N45FQQuCEHxLaRZspb1
         7Z3VkxGEQSTq6KsnKluluDSd8tVDOduVAJVv8Eo/AO/3EYubKKPUHcuHfcYEfg7+Zugo
         8UUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8yV2iUvrEwjCOCNOZ1eZQ5sQAfGgdHqJMoYgtnGfqA=;
        b=7IwIRLOomhaWYPdmnWRKTfBCefNzDKUOuvYuOOsApSeAJk86pb8VEVeGqJwlcJOPfY
         Aul8gWqmtByU6Cf+sLd0DE81U/Z+7Wu+gj9/CiL2ZKT5ULXgfnbePaufuVEhzbiqfH8O
         zcEXBa617/CakTT//+g5C6wfNSBhCBZtVMOhpodhYrp8GWyvrTlThId3ZfPKVftsA3Tg
         l1JhFSKqEpBIEm9tVUOZ7fQo5/47yyg1tmy3Pgi3SyusdUdKw80VKPSoFeKGTZxo0amD
         oAnyfxG4IZhwfdL6Ug3KLL5yUl1qJQ9okMcynPJ/tVOnn716gOaVfLq70b3JpX1yg/03
         7Ssg==
X-Gm-Message-State: AOAM5300iok8mECzcOqCO/x4R94bgLWo/fWFuJxumuQ6ObW8lrD3uU/r
        vP4cqLJhr0qaDRb4xMbBJ6jtPKV67/c=
X-Google-Smtp-Source: ABdhPJzU/8ZONXCu/RvK7I0ms41B/OvwYAIBMxFktcEUxPv32dH/lkgpF0qUZlWnNqi1Jx7Z3G46PQ==
X-Received: by 2002:a17:906:9b92:: with SMTP id dd18mr24676580ejc.290.1637787500133;
        Wed, 24 Nov 2021 12:58:20 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.168])
        by smtp.gmail.com with ESMTPSA id h7sm745843edb.89.2021.11.24.12.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:58:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/2] io_uring.h: update to reflect cqe-skip feature
Date:   Wed, 24 Nov 2021 20:58:11 +0000
Message-Id: <665ef6b2f9440105f5826a63be5ac014b179ccbf.1637786880.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1637786880.git.asml.silence@gmail.com>
References: <cover.1637786880.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IOSQE_CQE_SKIP_SUCCESS and friends

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 61683bd..a7d193d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -74,6 +74,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_CQE_SKIP_SUCCESS_BIT,
 };
 
 /*
@@ -91,6 +92,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* don't post CQE if request succeeded */
+#define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
 
 /*
  * io_uring_setup() flags
@@ -293,6 +296,7 @@ struct io_uring_params {
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
+#define IORING_FEAT_CQE_SKIP		(1U << 11)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.34.0

