Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D61C36FB37
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhD3NLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 09:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhD3NLL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 09:11:11 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B829C06174A
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so61484250wrt.12
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dOLUA4U0+orWelrZj4UP9WQEHXIZUx8F0WoWf9nlf5g=;
        b=NHcSlDS8aPk8KfNv7r9wlYspHZOYJK99iC6lo+Ii6djLoqgTNP1LdmAMMSnfEmOlVC
         nbgVEcVSNrAE/3Y9aw02DE8bQcBdCf+l1rq9WAEBVMy4kBvxbls2E90pgaZsCIlxDGu8
         0WAQ/jvoX+250cC7UcWv9ORybNGUvpEMaFYoaFJZK88H/FoMbB9ZC1DNY11u2xgzOqKr
         qunnJTtP9AwX8GRXmu9nmGmA1vvLSJbGMEPWSUjnB2Fl5DpUDO3Cd1IXtrbupwA8c8/m
         ufih87ic04tsbF62qFl6jDZAZHqX/CTOAYcvgo0rmjqiCxkZjRYOfdnC6qGIBJ4VlGOd
         WTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOLUA4U0+orWelrZj4UP9WQEHXIZUx8F0WoWf9nlf5g=;
        b=WgtapxxpFQF/j27KQdf1tQxDUbLYS8K4XrApT6YWIcMa4HqxEG2rM5lq0teuSOxrqp
         AUh0HvMBuknMGJCPfnMinrAfZQp0/aGafhn1roS0EmqVnBdKSmNzbqRq1oFD4PbKwvns
         N2d7Tav7I3SKU0LQ9pxc6c1tZEdRU2U9U+WVUUy6x+f4EPOnLa7m/zbN+/uRPWk4RYdN
         d+PBBz+zaswhrePHwHKyABdWkLp9aiPoEwm4DcbTGCEeiWIbrNG5sR6mPMeyNC+kivDj
         DHOOVUonU7XQYuZgeDKxbdzKH+If6SSDAINCt2gSpXhjf+dyjtNc5POnLyueP4H/wlVv
         v4Jg==
X-Gm-Message-State: AOAM530jsiP0PX1abqxczW/Q4WTQgQqjUAIBAWnT+QqJlzGzJgKD62Ui
        UyFR9MDMsayw0yK2MxQxjX+xO0mbcWc=
X-Google-Smtp-Source: ABdhPJyjH2Ry16Q5KlYXuJha13NiVaPWVW2H5wF8SSJONiTME1+uia2PRVlSZWRd1iGo20G6bknX9Q==
X-Received: by 2002:adf:f5c6:: with SMTP id k6mr7136088wrp.338.1619788222200;
        Fri, 30 Apr 2021 06:10:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id v13sm2292925wrt.65.2021.04.30.06.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 06:10:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: localise fixed resources fields
Date:   Fri, 30 Apr 2021 14:10:08 +0100
Message-Id: <b1d3ac6dde55e08718bfd181385a8d1a13df21ee.1619788055.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619788055.git.asml.silence@gmail.com>
References: <cover.1619788055.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ring has two types of resource-related fields, used for request
submission, and field needed for update/registration. Reshuffle them
into these two groups for better locality and readability. The second
group is not in the hot path, so it's natural to place them somewhere in
the end. Also update an outdated comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ff5d0757b5c5..e8b05e4a049f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -390,21 +390,17 @@ struct io_ring_ctx {
 	struct list_head	sqd_list;
 
 	/*
-	 * If used, fixed file set. Writers must ensure that ->refs is dead,
-	 * readers must ensure that ->refs is alive as long as the file* is
-	 * used. Only updated through io_uring_register(2).
+	 * Fixed resources fast path, should be accessed only under uring_lock,
+	 * and updated through io_uring_register(2)
 	 */
-	struct io_rsrc_data	*file_data;
+	struct io_rsrc_node	*rsrc_node;
+
 	struct io_file_table	file_table;
 	unsigned		nr_user_files;
-
-	/* if used, fixed mapped user buffers */
-	struct io_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
 	struct xarray		io_buffers;
-
 	struct xarray		personalities;
 	u32			pers_next;
 
@@ -436,16 +432,21 @@ struct io_ring_ctx {
 		bool			poll_multi_file;
 	} ____cacheline_aligned_in_smp;
 
-	struct delayed_work		rsrc_put_work;
-	struct llist_head		rsrc_put_llist;
-	struct list_head		rsrc_ref_list;
-	spinlock_t			rsrc_ref_lock;
-	struct io_rsrc_node		*rsrc_node;
-	struct io_rsrc_node		*rsrc_backup_node;
-	struct io_mapped_ubuf		*dummy_ubuf;
-
 	struct io_restriction		restrictions;
 
+	/* slow path rsrc auxilary data, used by update/register */
+	struct {
+		struct io_rsrc_node		*rsrc_backup_node;
+		struct io_mapped_ubuf		*dummy_ubuf;
+		struct io_rsrc_data		*file_data;
+		struct io_rsrc_data		*buf_data;
+
+		struct delayed_work		rsrc_put_work;
+		struct llist_head		rsrc_put_llist;
+		struct list_head		rsrc_ref_list;
+		spinlock_t			rsrc_ref_lock;
+	};
+
 	/* Keep this last, we don't need it for the fast path */
 	struct {
 		#if defined(CONFIG_UNIX)
-- 
2.31.1

