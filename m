Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCED678D5D
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjAXBYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjAXBYS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:18 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BE412F26
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso9849645wmq.5
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOPjpicl2vBI6DRcLC573pKl2JN9yi/WB4p89oS7TOo=;
        b=m5n5fHStvP/ActV2KaB9srZOXrgMwkQeOp52wlWW5xtsJ0tXztmsm5sxhcT8aA4GG9
         /SWw3Ck2Vp5upqbFJKTDH7dVQXo/Eh9BSElHC5uhMTC54ySWVKI1xx0CQfiwjldnI1GZ
         NT5ap2H0RE2zk8/pS0rhysqOrTrfVEm/Cfpqzuc2kBHlI50t1IDsSEUMlvJJRGtSCRkG
         2XtnCQKdULmg0B1iQYa6sLzKfRbxkLc2Bs0GNwgLVSbt0vKrhlb940jlHUFYWkLwM3IX
         xLeti6OE207INXZ0z2IyX1HeKy7ZNKkzvKB3s9dck8kSQlwbGXHoPOw+0PVUSd19uWZd
         m3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOPjpicl2vBI6DRcLC573pKl2JN9yi/WB4p89oS7TOo=;
        b=XpG8ga+tr6ncvmawP6QMnI4tOZNRzs3gnk4ROd5WY/Q0ePfVps+Nys/aHCEu/C1mDc
         OwaoLjgwL5FTvnsHwDgzhWoSCDe28J4wzVCTXCa4keZdrQnmZ2OG33Paz4uPRhaHdlmT
         qgLvEVdJrBSoZIjHJlaGZHdwHYjyFoStO3tBATXlICu9cEHqIP04hXlcTxhfvxvtJg0Q
         XEp0uJ/ePVZW/xoRghtf519A+FWklnM+tZxHyhAeRAy+C61eOHWb4d3F6qDsLuBPev+7
         sf98ZL+njpLK4N9byLC+I1M3SBQ50CtiIoXqArp1v2js5cHhIGKs5vnYPhjjoK5oK7qp
         tU/g==
X-Gm-Message-State: AFqh2kpRbxg9UUWVGBZWuOKSvEJlLOSI4PG46b3xKRlJQ0Me6Ubi6QxG
        uvSMgfsp/3U25RlYGEID/feyfiRxLfc=
X-Google-Smtp-Source: AMrXdXuCRDdFC6vH2+okfZxok6bTAX0uGIf+JWTUT2fZlYKFzZEKHVH50DuhyQBgMGOhQdfK3ng6yw==
X-Received: by 2002:a05:600c:684:b0:3cf:5d41:b748 with SMTP id a4-20020a05600c068400b003cf5d41b748mr33860945wmn.36.1674523426677;
        Mon, 23 Jan 2023 17:23:46 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/5] tests/msg_ring: test msg_ring with deferred tw
Date:   Tue, 24 Jan 2023 01:21:46 +0000
Message-Id: <d9ff19ed95bf0ed7f90de359b2b7b844030948e6.1674523156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674523156.git.asml.silence@gmail.com>
References: <cover.1674523156.git.asml.silence@gmail.com>
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

Extend msg_ring.c to test IORING_SETUP_DEFER_TASKRUN rings

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/msg-ring.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/test/msg-ring.c b/test/msg-ring.c
index afe3192..6db7680 100644
--- a/test/msg-ring.c
+++ b/test/msg-ring.c
@@ -254,5 +254,33 @@ int main(int argc, char *argv[])
 
 	pthread_join(thread, &tret);
 
+	io_uring_queue_exit(&ring);
+	io_uring_queue_exit(&ring2);
+	io_uring_queue_exit(&pring);
+
+	if (t_probe_defer_taskrun()) {
+		ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
+						    IORING_SETUP_DEFER_TASKRUN);
+		if (ret) {
+			fprintf(stderr, "deferred ring setup failed: %d\n", ret);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_own(&ring);
+		if (ret) {
+			fprintf(stderr, "test_own deferred failed\n");
+			return T_EXIT_FAIL;
+		}
+
+		for (i = 0; i < 2; i++) {
+			ret = test_invalid(&ring, i);
+			if (ret) {
+				fprintf(stderr, "test_invalid(0) deferred failed\n");
+				return T_EXIT_FAIL;
+			}
+		}
+		io_uring_queue_exit(&ring);
+	}
+
 	return T_EXIT_PASS;
 }
-- 
2.38.1

