Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB14561DDB
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiF3O1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiF3O1b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:31 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC547B37C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:57 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n185so11416336wmn.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XxjPxsaxC4InhhQuR77UkgiYJHDnnofimUEVznPbP7s=;
        b=l/NfeYe0tdguL+g1X/X75itf1/gPxFViiIij3BEjcOMfZ08zinsB3mixauKbw4MK4D
         /wCkkmmhOtuYBWtvwGNxRa4iQADhKRRigxVeuj9fH14uP3E1eT1F7P+XuOH/CpFwyR5o
         6+Vj2CEKKnB7gwEGsyG+nffEQ6I93hV5vbvNYrgUui6HEpgLue3vSB72C/qn2pZB3NHJ
         sz7UcTNbO8pETK7OOEVdtnyrzNSvw9UEq2mdHSKYVYUfN2EGoAHLBtOrsdUf5DHrPmDc
         odvsTSFDDqrhZmQ0SYwLNqn4Nbts7GgVIR/pdvfG6fLyEUV16pY0hQXXhjnIGvdSox2p
         JXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XxjPxsaxC4InhhQuR77UkgiYJHDnnofimUEVznPbP7s=;
        b=0HT6cTGbt/mL5UJ/hmf24b53WJZvt2AA4N/UeMqxL1OstU8b0s40+XvOWbsNrMcIti
         royw7Ms34LRtSepHcyllba3mnYB6i50+9Vxops/Gqbv6PrZAXDxh5DIC2ntsbEz/bVNu
         M6HOkMQkOm/FKm6SX8ZHMN882USwqZcnYoDBZIzAgFJn7G9emwYb+Wj5jG5ehGf93gls
         ieIhxGLon9prI0Q1zwxEeHMsRi+LfoD9qfkzjWXnqOOSugdCy30X+Y2yaD0BB4Y+plsb
         Yx75o43AkKJ0YkuZwy1Tb0dxpBjM5SiDa5cyYixZanpZfZRPQNzwx7yU+h5byDW/JztB
         z5+Q==
X-Gm-Message-State: AJIora/4dwCqyhmxQYNYm1Qip0EIph+faBN94CS5+eh97yHx25lo3pHI
        66nge/lDXLNc9R/sLo4LrAkrzFJeoU43rg==
X-Google-Smtp-Source: AGRyM1v+H9P1nr2UZOl187bGlHhfRFFT4sYYHBfjoUZG2u4vHAz3/TuA4DpNEE+7zH6Tk+jSsb9NIA==
X-Received: by 2002:a1c:6a06:0:b0:3a0:5099:f849 with SMTP id f6-20020a1c6a06000000b003a05099f849mr11634173wmc.14.1656598237426;
        Thu, 30 Jun 2022 07:10:37 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/5] update io_uring.h with file slot alloc ranges
Date:   Thu, 30 Jun 2022 15:10:13 +0100
Message-Id: <8f98bd6d014b9e8b1d86d04aa165b6d36cfb0ed5.1656597976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
References: <cover.1656597976.git.asml.silence@gmail.com>
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
 src/include/liburing/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 0fd1f98..c01c5a3 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -414,6 +414,9 @@ enum {
 	/* sync cancelation API */
 	IORING_REGISTER_SYNC_CANCEL		= 24,
 
+	/* register a range of fixed file slots for automatic slot allocation */
+	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -558,6 +561,13 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_file_index_range {
+	/* [off, off + len) */
+	__u32	off;
+	__u32	len;
+	__u64	resv;
+};
+
 /*
  * accept flags stored in sqe->ioprio
  */
-- 
2.36.1

