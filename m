Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62DA6D60F8
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbjDDMlD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbjDDMk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:59 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6135A6;
        Tue,  4 Apr 2023 05:40:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w9so130034910edc.3;
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48iFWUfpdleMqEh/dEcvKEXwQRaih9b/03a5Bfe+CrM=;
        b=gl2kV2u30DiuF6LupyGJhc9fmdXteYGvxc6WMMxQ83owbOpufrLobHdjp7vJ76EHJe
         DFLCkr9ikzj6jB8Lx9bpBWtWijJTmPgRcduPEEBluNfaPgqUCYx3eXvNRIXw4Im4rrxp
         ZZldOEBkDIZjteD7LSlQiyopcCqnmHABeZ7kDpsqWuIw6MF5GaLBYTz5NGyCRXGUoxp7
         ipMyvoluJLjtxjqftPEjuEVwPK351nasYVHb7iHl5CwuIT3SaQ65gC1IJEF5dF88mWgY
         FMCIGHgl4laJj+IdD/toCmbvnOTIPaACCFhKUeIpTcSdN8dso/qs6EGr97scyqWTi2bO
         GKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48iFWUfpdleMqEh/dEcvKEXwQRaih9b/03a5Bfe+CrM=;
        b=ukeex1gOJL/QN1OzwNURJZhog2vjwkjp4B35fRbiz4rThDu5QhNPBIim7FK4VXX4Z7
         pZ8sqHqmUo5QVGe9jMeAA+/59KJHKm6V+hFuGB1AP4OvrDTqrwRkK7yvOFR7zwMAEo8V
         j/yGO9AxYQUgG4C8dLlfqYHdm0xjbopdsdna/ctF2DHQUrLy1nDRUnC9IX8RVaLf/aLX
         T8mcAwqWzRhSqti24draJDvKOM3pMvy2zXzZtNYwcnKRR/tIKtHTMvcTUlnrgbhthcqh
         g+lB9fECprHe40rbPSr52PMAy2SIoxIZcUFcnpoZS5lkvTCG+4FAdMjWr+2ZknDOjt+B
         NJow==
X-Gm-Message-State: AAQBX9eEjmfrh/MUNWmxJlHoEkFMO5nDcfM0C+jeuiFm4EIb/HxVWiGc
        kF1EeMTFleCxEjlRw3lbH+FGniKL1aE=
X-Google-Smtp-Source: AKy350afySlnvs5wXx4oqHWSRmZ1ZwAJDwueyk1ag0N1T8uvCt4GM8mr4y2/PofDTTWzZUhKlzqVWA==
X-Received: by 2002:a17:907:bb87:b0:8aa:a9fe:a3fc with SMTP id xo7-20020a170907bb8700b008aaa9fea3fcmr2098510ejc.8.1680612054507;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/13] io_uring/rsrc: rename rsrc_list
Date:   Tue,  4 Apr 2023 13:39:51 +0100
Message-Id: <3e34d4dfc1fdbb6b520f904ee6187c2ccf680efe.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
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
index f3493b9d2bbb..2378beecdc0a 100644
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
index a96103095f0f..509a5ea7eabf 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -38,11 +38,17 @@ struct io_rsrc_data {
 
 struct io_rsrc_node {
 	struct list_head		node;
-	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	int				refs;
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

