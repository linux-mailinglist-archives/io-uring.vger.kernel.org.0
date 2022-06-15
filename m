Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E183354CEC2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356571AbiFOQec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbiFOQeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A841634677
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:28 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id e5so6632280wma.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Xnp5doseyV/R5Fgg6sqTDUrOugFuNWb6JYgnUVAxHY=;
        b=P5beFsz52CoABlwAXpZUOTj+mEMHr6jUQg0i438ocRpWNeKodb1bp1ILLXpvd+2Pc+
         HphMU+lXjsTcXQDJT7tMPkZVznt4WHaQIzTJ4D1X6UNSdEAtTwXWTWZjq1qAqmvGOK5z
         wmJsFWri7uZ3u8LJLtziqhRvrKTF/CAoKuVqcrUb4z4VLE5OP2b2oFiKmuwc664+0PO2
         mqQodDrJjQ0HP/BM/n3yXkxlPJNk8mNY5X/IG7O/UUDzLPLK4JIKYlvHSFHhTx0dwUWr
         DtA2q6dPmehZeDtKwI4BiWY0VqdoxQG+MZ78fCpno3tZpOV6t9ES031bENWRZqB0RHrW
         XQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Xnp5doseyV/R5Fgg6sqTDUrOugFuNWb6JYgnUVAxHY=;
        b=wEAXQX33IJcyci9g+OlURFmhJmmIcBLVfoFxu/Pb3ckWF1fjLLEmiNdW8meDJG3Iv0
         a/+fODkqQOs+h3Wm3iTivjJfx3ftiaS0Br6cyld1J7RevVKEnB1BKSmPh4jJGWa8v+M+
         mmcV74GADFJ7B9JsoPgAt18ks78QotowrUe7ur1LHyFbYkWhduz9iCjpjFFFDVycRz7Y
         2P/hAgjWitM28WiZVQ09Pt3yAq9cZH7LITsxtohcpWF+JqSemwHxIDDyFMue5qaDJyn1
         2kNbyFPghFcQhIf8E8hBZs0AgXXMfnt86Svn06C3nKQsMVBlTdOAraiVM7uUhIXkjdBg
         i/HA==
X-Gm-Message-State: AJIora/XMGS/OWCZuZclSCEnPCIYjJ4YKbYSB8jm6eM1ALTxmlMozJn1
        jSX7gehhKJ5eh8lbD/EaFo+k+P5SLgGq1Q==
X-Google-Smtp-Source: AGRyM1s9K/IiwuFqHODQq4gUI6XyQ+VHgDjJuTyYQ4bmV0NMvuQ9pZ/yy1blVO41l5HrjUbl+LejJA==
X-Received: by 2002:a05:600c:4e50:b0:39c:8ca8:faff with SMTP id e16-20020a05600c4e5000b0039c8ca8faffmr282411wmq.67.1655310866927;
        Wed, 15 Jun 2022 09:34:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 02/10] io_uring: move defer_list to slow data
Date:   Wed, 15 Jun 2022 17:33:48 +0100
Message-Id: <e16379391ca72b490afdd24e8944baab849b4a7b.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

draining is slow path, move defer_list to the end where slow data lives
inside the context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring_types.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 147e1e597530..bff73107f0f3 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -160,7 +160,6 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		struct list_head	defer_list;
 
 		/*
 		 * Fixed resources fast path, should be accessed only under
@@ -272,8 +271,12 @@ struct io_ring_ctx {
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
+
+		/* io-wq management, e.g. thread count */
 		u32				iowq_limits[2];
 		bool				iowq_limits_set;
+
+		struct list_head		defer_list;
 	};
 };
 
-- 
2.36.1

