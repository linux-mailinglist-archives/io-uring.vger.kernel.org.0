Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E8554B4A2
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356689AbiFNP2J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356878AbiFNP2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:28:08 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61613D50
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p6-20020a05600c1d8600b0039c630b8d96so930307wms.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=SHTdE/B1anm+KTXgFUlR9XtmyEn8Z7y1lh0952BAvsNurbLIU/sod4Cf9Wdyusvs5K
         Lf1fhv3XfFwEzHGXYB9pQBCE3AKV2A6AC7jLGMzFqnefhVSd+QpyADNCUqroIw/onYRh
         XSuJoYmjowrTlElIuBlLek9Oz9G8BJGBL+4y4NqGjBJnBn1YvTHv2QCytYfyKbY8kUa+
         jYEZtzF0SpLPLuxizwdMFReim/d/iA/VUgdsP2G7wZ153ObPtVuJ1w/dSxk13B3aLOLo
         iqdpnoJtL5wb+i5pQQiTWbcI3hN+KfM/Ap4L+Tog6vskKlT3AKx65SFNw1Ma5utFDZ4Z
         HiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=gjjcgSZWP85qyt85uWqupzlaQ1bPGyrFfWF3sa79yKfT3z9AKhfK7l5UN5gD2LAuYc
         MrRS1diRSfp/ROJgn0rJ4yGImXggDr0nIyWQMwmkINSyYiDB4LKoITePzz/hpxhl59Wu
         Ldn7DpOCAq7pC4418avs+Txattp5Fy0G3ZUlNA5RcTZ7VaYeXw+8VN96saxR5vo+9DVa
         i1t3rXOyJh27fTEUN+mUe+8SEG71g8f4kg+AJltEfUGhNJqP/BDoiHDha0tFbqTg1MXG
         DRRk54K7O8q8PYUnm26ttVpiqLS+Y1IgoYm9lRI6z74lXlpxInpKDEaeNXZWooYc9eL1
         T8fA==
X-Gm-Message-State: AOAM533ieqhZesx+gGmBtHdzGYyhfpdACzLOe8zV9GMNp+O/MWdk3erX
        2kv/0U/KSloSd3Y0VeN98qEh0x7JfH4rYw==
X-Google-Smtp-Source: ABdhPJzdXh3HIqbgLATKviHT276OYBtneNVKe8P9rRbvzoIglVazn8Fz8b0Ud5O53SnGllOpeigf0g==
X-Received: by 2002:a7b:c758:0:b0:39c:44ce:f00f with SMTP id w24-20020a7bc758000000b0039c44cef00fmr4756849wmk.167.1655220483638;
        Tue, 14 Jun 2022 08:28:03 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm13313529wmj.24.2022.06.14.08.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:28:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/3] io_uring: update headers with IORING_SETUP_SINGLE_ISSUER
Date:   Tue, 14 Jun 2022 16:27:34 +0100
Message-Id: <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655219150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655219150.git.asml.silence@gmail.com>
References: <cover.1655219150.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 15d9fbd..ee6ccc9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -137,9 +137,12 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
 
 enum io_uring_op {
 	IORING_OP_NOP,
-- 
2.36.1

