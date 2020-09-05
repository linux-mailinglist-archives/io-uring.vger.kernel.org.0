Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9D425EB0B
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIEVrt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:47:49 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68BCC061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:47:47 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id j11so13126266ejk.0
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nA5Ow83Pgu2t0I0lG+CpUkeAdrtACi5ZL+p8nwATzHA=;
        b=qP7hIlnis04Wtyq3Y6ErfUzyasDOLkHrPocub+zwE5zSMHgNImxpPiTUQVhzoKKsAf
         sZCU+iEX7vO5DMn48kPHzdRtzQfo+otjaNeBD/wVTErO9SgOa4q/xz/nbwpH7L/MChV6
         WdXi3oemgDuUi9S9Werk4Mp5TI9exgkp5uDGwWqHMQ508xqUUh4KJfpv66A2gW4YERcV
         GYbUffiOXpnWxSHHIWl3bXfp/o+GzTOsxks7XV3TMyNildNt/vNySdg+FS9nhq/yIfsf
         VSuM7KaUNG+snidjSCFAaellj2ATziwKMuyV60HI38gGVVz03CMo+rLupDWB4eNtZiuB
         e69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nA5Ow83Pgu2t0I0lG+CpUkeAdrtACi5ZL+p8nwATzHA=;
        b=IaX6XuftyZ6dp7g38NWqBSi6p2GyRWFRJu0Emm8YdfUXyoxgqBam/0MOvy106Ltj7g
         Yz9JtN6k90XxX/Gn5d3iL+vo/1Aidc+jsuaYRqDzkLG5H/sGFe5yPGKz3CHI32ocH0Ol
         MDFmG+HkQE+ixSynv52EKogJGGQSsNLBxTOkQ3ig78QC/NXPDgFYpFflyV97C3biCKdY
         eomuul0BqUE92eBrdIA2LcXgNF6xTHstkK510N4JB888ZrUe57HKGAO5wD1jlp1vnEg7
         rrdIILIrqKBoDqhxKDhGXVO3aOtajlnLY8hjROo8U0cqQHDO/TpgEdgNT64j1v4ipjWN
         YPhQ==
X-Gm-Message-State: AOAM530Ymw8qqgddeaJXHPoDkvae1y1AZZobM8pI4b3hSxmbgc0/zrZT
        GoyGqYhwZ7iTDNP87hI1Qz41FPwxGnA=
X-Google-Smtp-Source: ABdhPJzqN98OlTZIufKThmkIW8cNDpnHQSuEDKop4DaTEeklhSool6sJExJpEvyDX7hncMNS2mXmFg==
X-Received: by 2002:a17:907:37b:: with SMTP id rs27mr14868421ejb.0.1599342466450;
        Sat, 05 Sep 2020 14:47:46 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id c5sm2399121ejk.37.2020.09.05.14.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:47:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix cancel of deferred reqs with ->files
Date:   Sun,  6 Sep 2020 00:45:14 +0300
Message-Id: <76a24f63b598c6e698ceb7cbdbe0aad012d412e0.1599340635.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599340635.git.asml.silence@gmail.com>
References: <cover.1599340635.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While trying to cancel requests with ->files, it also should look for in
->defer_list, otherwise it might end up hanging a thread.

Cancel all requests in ->defer_list up to the last request there with
matching ->files, that's needed to follow drain ordering semantics.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e3adf9d17dd..20b647afe206 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8092,12 +8092,38 @@ static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	io_timeout_remove_link(ctx, req);
 }
 
+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct files_struct *files)
+{
+	struct io_defer_entry *de = NULL;
+	LIST_HEAD(list);
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_reverse(de, &ctx->defer_list, list)
+		if ((de->req->flags & REQ_F_WORK_INITIALIZED)
+			&& de->req->work.files == files) {
+			list_cut_position(&list, &ctx->defer_list, &de->list);
+			break;
+		}
+	spin_unlock_irq(&ctx->completion_lock);
+
+	while (!list_empty(&list)) {
+		de = list_first_entry(&list, struct io_defer_entry, list);
+		list_del_init(&de->list);
+		req_set_fail_links(de->req);
+		io_put_req(de->req);
+		io_req_complete(de->req, -ECANCELED);
+		kfree(de);
+	}
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
 		return;
 
+	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
 	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
 
-- 
2.24.0

