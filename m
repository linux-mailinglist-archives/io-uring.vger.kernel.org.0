Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E271A6D08CD
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjC3Oy4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjC3Oyu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3054DBDDC;
        Thu, 30 Mar 2023 07:54:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r11so19373800wrr.12;
        Thu, 30 Mar 2023 07:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFbJzcJB80Re1Q+sgkx/0FejbOmENveKGMdPIGHHusQ=;
        b=fAaanC13ZIcJPOqlgTHTTR8OQ622D5DOKgBDq8AivQ6OZol52ff75ivXCbEWtrKlC5
         58sKNg8ei9TLxFzneeQcX+weXD5pVTkx5Una8QbUQ0N0zBSz4/9zQLBi2nTYeg17d/07
         BDhvnc5atjth6fl/hQ5ySvlGOQ4T/zeoOqc1+3smISDFKVYbnru8vA3kiUons8RW7x/9
         9BBOsInbG1nNwAtXQR4YCUNxAWpzV6a4ttCV3W5sudKKKy/FayqZQN9Pt/AsjOb5bby8
         VnWKU1P6pGUsEfhtkSI0HXYIv9yMTfVnkL7D6zLr5YFZHIhgMR7qyMLLX2+qBWF9JQkJ
         jaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFbJzcJB80Re1Q+sgkx/0FejbOmENveKGMdPIGHHusQ=;
        b=7pdXaNG7xaXlQoYQxmzQdHSSeilQEnirizGCc5mSCujOHfKjUwniSq1Pf/gjuNOS5L
         GDW63J88pzh0TvN2etLkbFWD5qU52vkrANFpkX2kJLrkjH7PmMKNQaGxIl02ccwgpeaS
         KDsXSsAUc2P+L0vDfG1RKUFNK5VB/pXiDDvXFNNB9+PYCv1Kdi2iKo360wWzU8uscMhl
         NVT3gV/h3hsxSTzpywLrx5+6U/CyjURJ1nTLsq0Imrdteaqed5I2vdJt+6rv3Rs/53Av
         FtODsPjjD1qNaFahqIzWIYiI7L8al3AJrH5SKisVQbUGF4baF3qrfJhSEkfL+UlirgmN
         MTkQ==
X-Gm-Message-State: AAQBX9e/w8p5SKdUhVIRKpspyG4DExUS/oCHWPpPxUm3gQs13yMuz3Lo
        uGlkt6hsqkpGzexBLc1pO3wzXX5gXiY=
X-Google-Smtp-Source: AKy350ZeatGaowOqM6eQoPi2XZ7zNijxYQWjvrwuXid7H5G1nzF7H9I6wArvCfjDSVxDFk7TAqclEQ==
X-Received: by 2002:a5d:53c8:0:b0:2dd:2a04:b73f with SMTP id a8-20020a5d53c8000000b002dd2a04b73fmr15772746wrw.49.1680188082258;
        Thu, 30 Mar 2023 07:54:42 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] io_uring/rsrc: rename rsrc_list
Date:   Thu, 30 Mar 2023 15:53:25 +0100
Message-Id: <00684614f29297882e2c03456351532cf027e167.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have too many "rsrc" around which makes the name of struct
io_rsrc_node::rsrc_list confusing. The field is responsible for keeping
a list of files or buffers, so call it item_list and add comments
around.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 6 +++---
 io_uring/rsrc.h | 8 +++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e122b6e5f9c5..10006fb169d2 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -146,7 +146,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
-	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
+	list_for_each_entry_safe(prsrc, tmp, &ref_node->item_list, list) {
 		list_del(&prsrc->list);
 
 		if (prsrc->tag) {
@@ -249,7 +249,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(void)
 
 	ref_node->refs = 1;
 	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	INIT_LIST_HEAD(&ref_node->item_list);
 	ref_node->done = false;
 	return ref_node;
 }
@@ -737,7 +737,7 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 	prsrc->tag = *tag_slot;
 	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &node->rsrc_list);
+	list_add(&prsrc->list, &node->item_list);
 	return 0;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index fd3bdd30a993..c68846de031f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -39,10 +39,16 @@ struct io_rsrc_data {
 struct io_rsrc_node {
 	int refs;
 	struct list_head		node;
-	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	bool				done;
+
+	/*
+	 * Keeps a list of struct io_rsrc_put to be completed. Each entry
+	 * represents one rsrc (e.g. file or buffer), but all of them should've
+	 * came from the same table and so are of the same type.
+	 */
+	struct list_head		item_list;
 };
 
 struct io_mapped_ubuf {
-- 
2.39.1

