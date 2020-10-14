Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EE128E787
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgJNTr0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNTrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 15:47:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88504C061755
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:47:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n6so405662wrm.13
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RLpXwzunmzrohVh/ea9JOV8h9tll7qA6xXdt5BJsp5w=;
        b=ZCVliedCPogs1mu6Hdk/bUFNHxmsy8+9LDVKNi34sxDCE4ZzsePVxUdDPTAhYWjPhr
         DX9LVI7Q8BD0dcMIzfUbAe/E6cjlWdTtYRMchrzqHZTYTl39Ljpvyv8RuYTGLMHsVK/p
         Jpju756glGC2C3aA9jY3HIb6AJOKNEeTvjAontKfWOLZgLZNuYoJ/cBLbT+HcU8mQlCp
         RW6MGyPtgnHJqEyRPw5Q/+hdcbeLHbP5NKqaq3EK0d3AhCevZjr0OWKZyIfA3by+hcSw
         M22UfZuGhD8OHj2nqW7ZooxIkeeHeRPhIhqqP0gjp0Pdx33swloZFELd6EtlPYJfAcWQ
         VqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLpXwzunmzrohVh/ea9JOV8h9tll7qA6xXdt5BJsp5w=;
        b=psnHbw2q0ceGH30eKiGcOAVoBgJyNK5UXBYH7kdXiBQuoIGofuu2+jSDLNrYlvzNcA
         cRT003H0YFrFjyif1cDKdM0A/C5eAqvTVbow5H1oHIfeDXjAbVRa28V/23mKJGmOhCO5
         TH1teI0+HPl1CnSjOkUzlQCqyWwmAQh4GdfBQ12zO1/wfEgyrO2IzdHiPrFVNJUy2FyZ
         SdGlzk2g3zKRYLT1w9e4aMKGrxdf2Pg7djugCRC4J4+EKefddmBUloFWhTgQtcUOZ8Zx
         oWxHN9+RBRXo+28IVetSgVrvxDQXkVflvqzxFVegS9Qu/NCZ+tN6f8cJ9P9dUQXDvC7D
         Mqew==
X-Gm-Message-State: AOAM532QiV0oIu3DDDZqfqU6KaV/I+VMmjCWfs/gxlJHyXMfA0KjAH/h
        KOVhzPIJqhh7AeQFZhTzVIY=
X-Google-Smtp-Source: ABdhPJxIzcFAq1rCjFuxb9tBI5hoIYlEE2CW+3sVxAixOeBRfIEInfg9ZFjKhbldoIcZg8Ame216QA==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr349193wrp.413.1602704844350;
        Wed, 14 Oct 2020 12:47:24 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id 1sm526985wre.61.2020.10.14.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 12:47:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: optimise io_fail_links()
Date:   Wed, 14 Oct 2020 20:44:22 +0100
Message-Id: <3341227735910a265b494d22645061a6bdcb225d.1602703669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602703669.git.asml.silence@gmail.com>
References: <cover.1602703669.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Optimise put handling in __io_fail_links() after removing
REQ_F_COMP_LOCKED.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f61af4d487fd..271a016e8507 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1816,7 +1816,16 @@ static void __io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		io_cqring_fill_event(link, -ECANCELED);
-		io_put_req_deferred(link, 2);
+
+		/*
+		 * It's ok to free under spinlock as they're not linked anymore,
+		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
+		 * work.fs->lock.
+		 */
+		if (link->flags | REQ_F_WORK_INITIALIZED)
+			io_put_req_deferred(link, 2);
+		else
+			io_double_put_req(link);
 	}
 
 	io_commit_cqring(ctx);
-- 
2.24.0

