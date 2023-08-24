Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497D6787BB6
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbjHXWzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244041AbjHXWzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:36 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA0C19A0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9a2a4a5472dso110126566b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917727; x=1693522527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfCDFTGPqPDquTSsf5QwXyrmIi5jQ5+Y+5MLL1cbVZg=;
        b=cRpzkHh4gekBnwGHCVv733wH7otA3KbEzC2tyRMzjnLOo8bzbrAElSFPZw9+YDZiB3
         lJsTTYM1TGT2IY3DmiCDtoV0alwZEayhXBHL4McFnEnZwlSHyFv1L7FlCPcIfxyLuqhh
         0p7c8AJ8fChKcNcKeaVhYJcQaQlNsrwf67cawm5S6/N7/ukJRLu1sQkU9/Fr/4542DDm
         7gKhQnGG6/bPqS1gs3WsvVmXPMMUyhJVPqFoyElUmP3YIEwt2785HSU+LJkpJz/7LTJQ
         XS+KP3zefm5W/oMESPa7vE/Zr+SrwcL4Q1iPXpM4yjTOcYtw+OCttrcSIrQxcz9Mu2pV
         b/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917727; x=1693522527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfCDFTGPqPDquTSsf5QwXyrmIi5jQ5+Y+5MLL1cbVZg=;
        b=eJ+UpfcNoOSIuFrxfZFVKQ0yRLHLHHOX7BZQ/W/nDPIiVJeunjrQ9Y5TPOKsmtzkWJ
         hBDS4PHBJiuuosJ4biaILYpvM9tDxcd8wOIz86rM5OI7irCzL8ASDU4zEEx9s0hK3MFL
         IweODwwWVTVPkDlIydin/wg3taFB0SaH7Wj11X8Whtcl80YZ/rhzntuhcU1Hm3VaIW68
         w5rCWdYnYEh8moxWrxsmZeJiJl+toUW0TpLe3hL6gEoMumpEB6UfFfWeIaxG0tKXlJDA
         9gLKwuNcsss4LCRwImGPt4ptcujW6MRqjCERudGYMhLM1Danl/6+2FMM93mFxBKLyLNI
         Vihg==
X-Gm-Message-State: AOJu0YwWSqOVyernRUA068v/pKwunCHi+6RGtQiTPPBohvXbVh7V3hdD
        yEnCRZJm57baMLvnVaAHoHR+LKTEvik=
X-Google-Smtp-Source: AGHT+IHnF6ehN/QYO4okmI57KzHIK4QRxOX4Gv4bdBLLzdOV/dynBpU7YmMD7WlI4CRx+rg2rJsL2g==
X-Received: by 2002:a17:907:948e:b0:9a2:28e2:c347 with SMTP id dm14-20020a170907948e00b009a228e2c347mr1678646ejc.34.1692917726906;
        Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 11/15] io_uring: move non aligned field to the end
Date:   Thu, 24 Aug 2023 23:53:33 +0100
Message-ID: <518e95d7888e9d481b2c5968dcf3f23db9ea47a5.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move not cache aligned fields down in io_ring_ctx, should change
anything, but makes further refactoring easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 608a8e80e881..ad87d6074fb2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -270,24 +270,6 @@ struct io_ring_ctx {
 		struct io_alloc_cache	netmsg_cache;
 	} ____cacheline_aligned_in_smp;
 
-	/* IRQ completion list, under ->completion_lock */
-	struct io_wq_work_list	locked_free_list;
-	unsigned int		locked_free_nr;
-
-	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
-	struct io_sq_data	*sq_data;	/* if using sq thread polling */
-
-	struct wait_queue_head	sqo_sq_wait;
-	struct list_head	sqd_list;
-
-	unsigned long		check_cq;
-
-	unsigned int		file_alloc_start;
-	unsigned int		file_alloc_end;
-
-	struct xarray		personalities;
-	u32			pers_next;
-
 	struct {
 		/*
 		 * We cache a range of free CQEs we can use, once exhausted it
@@ -332,6 +314,24 @@ struct io_ring_ctx {
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
+	/* IRQ completion list, under ->completion_lock */
+	struct io_wq_work_list	locked_free_list;
+	unsigned int		locked_free_nr;
+
+	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
+	struct io_sq_data	*sq_data;	/* if using sq thread polling */
+
+	struct wait_queue_head	sqo_sq_wait;
+	struct list_head	sqd_list;
+
+	unsigned long		check_cq;
+
+	unsigned int		file_alloc_start;
+	unsigned int		file_alloc_end;
+
+	struct xarray		personalities;
+	u32			pers_next;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
-- 
2.41.0

