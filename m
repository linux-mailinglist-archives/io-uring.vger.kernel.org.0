Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0655834614B
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhCWOSL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbhCWORe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1EAC061764
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j7so20964321wrd.1
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pU24/bUO1FGRgkC6dwkVugc5j9FrEv9JmQsYYaHPouc=;
        b=tXszr5B8B6U0FX3sGYdVaTakeVRgMg2L73tdnPGe97iLCqZu3OglXcxTXxunDQpMBQ
         J8wke1CZvG6Sv/YS/K0RG7RHYd9yZJw/dHSjp1dOT+K/3KHJgBdIOh5LN1pnBLlZB5nD
         ps9i4gMOsK1eGvQllBgtLK/jXe1qEEH6yiQP5CfxY0woi9u70IFEIlVd54E/3nhPVAhe
         27AV0Fp/aa238BUSpUkMincUw3RVtK+ZwjKBpX90B9Fbp4uGTxeTo0FiSEriz3GdUkuF
         o2qiD/6wD8zRi5N3/u+H0giWq2Bpvc0d/mTEaTL4cFVcI7aepGT7s0hFfxJrlcEY1boX
         +MCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pU24/bUO1FGRgkC6dwkVugc5j9FrEv9JmQsYYaHPouc=;
        b=jX4O4OaLefYrssHtNAMknQpEjZsnpGykgQ31Gw7vVRtT/l3z50rGzoAGvhNJwdDEz3
         BsjzV7SQiYaIxZUAjPWNsY3j9o/O1KOv6TJvNx/diMMOPYhuybQ6iZ+jEgSfbPOw3oFQ
         kc78atXwLLV81QlTYTqcC6NVe3+tOJzsmEfALOR81ng9w7rfvMD2SPGszioqQ0W538OL
         6bltZxit/tTT+PTX2Iovayrl6rpXO1o/bAk2L1ou6F32HAxrOM3bqmKKTg0qHa3Eh35p
         ZC7xbm5VFUNDOy31/WFvUlytZag6049sbn2AyfNg2ICnch66fujcag/lVBipcvsp8hxs
         Vs0g==
X-Gm-Message-State: AOAM532+xrUKWGvB0Z+bTMacoPsNRrL3cmU+hqpvqvHq9G6MMYn+q8kO
        t+E9uVV0OkWSjSIoBeqfl70=
X-Google-Smtp-Source: ABdhPJxWZDyghOI9xmUJ6nfVBNqvUloXUxCBW4V92OpN+JqjWsnbOxSFyIRdYjtrZEMgfZh0xRFTJg==
X-Received: by 2002:a5d:4fca:: with SMTP id h10mr4489104wrw.70.1616509051730;
        Tue, 23 Mar 2021 07:17:31 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/7] io_uring: refactor io_queue_rsrc_removal()
Date:   Tue, 23 Mar 2021 14:13:16 +0000
Message-Id: <944b9e10c462bb18756bbb43e7e28758807a554b.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass rsrc_node into io_queue_rsrc_removal() explicitly. Just a
simple preparation patch, makes following changes nicer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f9ed4151e71..175dd2c00991 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7619,27 +7619,20 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data, void *rsrc)
+static int io_queue_rsrc_removal(struct io_rsrc_data *data,
+				 struct io_rsrc_node *node, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
-	struct io_rsrc_node *ref_node = data->node;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
 	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &ref_node->rsrc_list);
-
+	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
 }
 
-static inline int io_queue_file_removal(struct io_rsrc_data *data,
-					struct file *file)
-{
-	return io_queue_rsrc_removal(data, (void *)file);
-}
-
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
@@ -7674,7 +7667,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_file_removal(data, file);
+			err = io_queue_rsrc_removal(data, data->node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
-- 
2.24.0

