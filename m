Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D257FCBE
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 11:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiGYJxm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 05:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiGYJxk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 05:53:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B666E17049
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l15so11126254wro.11
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sinLQ20yM4qKTkg/oyuzo+DXzfh3EUo3lAFbL25qdqs=;
        b=BrOMhMeF39zBFDfjqdDUWvU/k+JqPqhXxEpkd0ZSWw2H7EMhlWmwBruRyX9htxPFXH
         v+bVW2VBLLUMdFbu9/EQU0SGNQOGqdcsmd+ZaVvD9ypl/Jk3E2KhlDnsK0wtnOY5RdZp
         RcqidU0dm6m1HYEUy1UjMnGKV0nJyrSWg7T7oKqqHeSgvUTvDqSkV5/qluEog92+ETvl
         8k8DysvukTO0ZmCZ9Q++Wb2xXOKX6Jbq7FxE2hhVEgHc9YyMmz7mh7zAzBhkpoiF247s
         CDCSctV4ik4OxIRDpSLE9EgAHqnJwBznz7ofQTYs2INWM0/UYHbNbJqRn8xx0qYtwkXt
         KRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sinLQ20yM4qKTkg/oyuzo+DXzfh3EUo3lAFbL25qdqs=;
        b=iHN34X9HFfXlEsrvMSU+XIbaPZ7Gx4iR3UJAdsVT5XlzIEJIKFu+dPUZ0gzcA7M1HL
         35ULsA+BngGrelTpEp1BKY8WONKNlghjSfu7O6FJJMIQczxmD/HuxMlavW9NYJkHCQOP
         3PvzKnbcCoLhtW9adTjiAzRsfB08NxgyD5OGXg1GtnsUH+bXbsNlZPq8wveaz6RoalIu
         zo8Zj0VsRQgGj5/51uklt3RAnPi1potxQrpZFD0krGQJWUh6XgX2CXgUJoapSyKrNDSs
         viy1PXrnNxWg5m4lmh+A02/5PYE11H9P4VBiQ2VJiv5r+BeiW8YFD0Lk/yK8npWiS9BA
         hl9w==
X-Gm-Message-State: AJIora+yPr81wnR0U9bhBq5fQn/rHhr6DW5cxYpdRbtP3XVi05+J7C/d
        gYfD+G7fviM9sDMZ5rWT3iA6oXe11yA2Cg==
X-Google-Smtp-Source: AGRyM1vyJjwt7//2P2N+n+xSfgIaOahMT9aP5yaTidIV07ryPIWE10dotyI0mhoavnSeDd6HEmWuGg==
X-Received: by 2002:a05:6000:1888:b0:21d:beeb:7873 with SMTP id a8-20020a056000188800b0021dbeeb7873mr7135592wri.393.1658742816717;
        Mon, 25 Jul 2022 02:53:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:1720])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm18909636wms.17.2022.07.25.02.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 02:53:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/4] io_uring/net: checks errors of zc mem accounting
Date:   Mon, 25 Jul 2022 10:52:04 +0100
Message-Id: <dae0542ed8e6706071bb83ad3e7ad6a70d207fd9.1658742118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658742118.git.asml.silence@gmail.com>
References: <cover.1658742118.git.asml.silence@gmail.com>
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

mm_account_pinned_pages() may fail, don't ignore the return value.

Fixes: d3b8269075f67 ("io_uring: account locked pages for non-fixed zc")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 62be89837d82..8fb8469c3315 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -985,7 +985,9 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 					  &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
-		mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+		ret = mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	if (zc->addr) {
-- 
2.37.0

