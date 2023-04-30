Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B356F285A
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjD3Jhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjD3Jhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F97210EC
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f20215fa70so8030395e9.0
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847459; x=1685439459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F209vZkGL7kWoLxpVYvPls6K5IzM+99Cmjxg/T/04lo=;
        b=haeamIQPBbE13H+Y3mgH7GI0iOxj5Dqko3U9g5OAuflPsFJvnSWRH2oEDeMqqb2WP5
         NdhJ9LElYph+v8NkdxN1csMZeVpQgjNridFe16SKGkKhFYqpYzUGxyp/MNRBbdlYqxYZ
         omJ5WKn4xmuO2fHyH3UGYFC+13V5V6RlI6PJlUcWVavIhaX/hIFtZCvRGaRe/V6tNKwv
         WWKERt4mVooFZ4ZsU6yguLKmaHEeaqxt75T7PyeQRmFrGwomuKIGez5m0Cj5DwTi73sw
         q2Yp96tKlVeJ24Y6WpwGSmf8V046ZRpTe3oQYiOy6PP/kE7pk2EeuM8lebG+CM7HDu/p
         5O0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847459; x=1685439459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F209vZkGL7kWoLxpVYvPls6K5IzM+99Cmjxg/T/04lo=;
        b=k3fu1jYW8f6anxQGkBC6w6ncdN0Fxh1vg76q+rredMFmjrVjPFgofMZ+8S3hmLKsP5
         67ed8ln/58+mWlQ9YHdFRTFOc8mIUHEiao7qo2+nkhFrWPg0Om4g4goPY/t3M4pbkRy1
         AVzDezsPHXP8JzEi5ryOiWaulxMVzChwtC0CQBGMmyllhTBdxEzmYWA7rIDgZF8STDRs
         8nCphEpNodD25HT2XS+Ak6fkUM+F/q8yvl7Ob3Kuj0H2VrgyfJW+/obDj/45Dx4PejWe
         DLXkBLqYrzyd2Rs5EFIT+td8eTk+brSNQUCTlMfKb1uYaRTB3Y1THAEGBeguvcY00xDG
         zncw==
X-Gm-Message-State: AC+VfDyRSG1AwGCotGkE8nsMr/t8b6hvLO5x8D4kHPBpZvoi58sS5mDM
        /c7AE+ZghoGgcOR/HCD+8JAnlasOCuQ=
X-Google-Smtp-Source: ACHHUZ7+jd5LTO/UOWXTrnCbWwvtZbvGUdlaJvQ5kKGDnjnPvb3/8MpXnD1YbmYwsiA7sUWoajvEBw==
X-Received: by 2002:a05:600c:3789:b0:3f2:4f24:5f61 with SMTP id o9-20020a05600c378900b003f24f245f61mr7893618wmr.38.1682847458860;
        Sun, 30 Apr 2023 02:37:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 5/7] io_uring/rsrc: add buffer release callbacks
Date:   Sun, 30 Apr 2023 10:35:27 +0100
Message-Id: <dc23e86615074c488e8bf47ef01dad899a78ed20.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
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

With other buffer types we may want to have a different way of releasing
them. For example, we may want to put pages in some kind of cache or
bulk put them. Add a release callback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h |  2 ++
 io_uring/rsrc.c          | 14 ++++++++++----
 io_uring/rsrc.h          |  5 +++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index fddb5d52b776..e0e7df5beefc 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -26,6 +26,8 @@ struct iou_buf_desc {
 	unsigned		nr_bvecs;
 	unsigned		max_bvecs;
 	struct bio_vec		*bvec;
+	void			(*release)(struct iou_buf_desc *);
+	void			*private;
 };
 
 struct io_uring_cmd {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0edcebb6b5cb..3799470fd45e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -111,6 +111,8 @@ static struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx,
 	}
 	imu->desc.bvec = imu->bvec;
 	imu->desc.max_bvecs = nr_bvecs;
+	imu->desc.private = NULL;
+	imu->desc.release = NULL;
 	return imu;
 }
 
@@ -169,10 +171,14 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	unsigned int i;
 
 	if (imu != ctx->dummy_ubuf) {
-		for (i = 0; i < imu->desc.nr_bvecs; i++)
-			unpin_user_page(imu->bvec[i].bv_page);
-		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages);
+		if (imu->desc.release) {
+			io_reg_buf_release(imu);
+		} else {
+			for (i = 0; i < imu->desc.nr_bvecs; i++)
+				unpin_user_page(imu->bvec[i].bv_page);
+			if (imu->acct_pages)
+				io_unaccount_mem(ctx, imu->acct_pages);
+		}
 		io_put_reg_buf(ctx, imu);
 	}
 	*slot = NULL;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9ac10b3d25ac..29ce9a8a2277 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -169,4 +169,9 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 	atomic_long_sub(nr_pages, &user->locked_vm);
 }
 
+static inline void io_reg_buf_release(struct io_mapped_ubuf *imu)
+{
+	imu->desc.release(&imu->desc);
+}
+
 #endif
-- 
2.40.0

