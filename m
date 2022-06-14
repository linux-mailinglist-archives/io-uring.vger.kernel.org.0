Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D02C54B0B6
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiFNMeO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiFNMdo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770F84B429
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u8so11042186wrm.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5BK3pf+Ob1QUOBk18Dp6t/3CfaS7xXLjPvB8wT77wB0=;
        b=gHW2Yc1Q3mf2pomD74eLIngyMMfcjA7psHXSdtKMOg1DEC8Y2FspfFdpSirnWL3LjC
         1oes8wkm3NwM9BUzVdw443qRkCcCOZz0XMZEOVGoL5gT0ALJiptGZX2RM58S2chqTHsO
         Y320LqI/1QmdnDxqNHBf1HmhqWwWdXUmJLz6FLSoRN0ZNPp5EULwPa9hO2Jc+78pNkCp
         bwcalvBnWa9xc6otdN4ClkaVyMOadAAHVkqB3Jyo4UBDbGL/DaZq4qMkIMiH1Dgd21lt
         9V7THk7u0gt6ctkMoIp2B5IgoDVfTpb2Zl4VJHO7lNHkCfrt5u7oJ1qCnFpNBF6scClf
         RiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5BK3pf+Ob1QUOBk18Dp6t/3CfaS7xXLjPvB8wT77wB0=;
        b=Z8U7IVXj6ji9DjRNvgn0ggmEcCe41Uo+fEiNq4rsNEbXQUIoZc1ue2MPuESyoT/nea
         GAcTkLLhDjkQpCTqIt+LTH7dVvazC6XrjYFm/gyxf7W2x5qHz4QXINw+o+cXmAXxqDCX
         dNyKfeK1R2YT/1KHGxrFjmveEb3UMV5j9nwr3txrCGEKK1/W0KVeu5cIIQtXAR5TNWlf
         tm0uiTQg/iLLGoXoUsKZ36ZZdpQzwgMEwskloInjFRqq2FfkJcs6h6WRfbBxTkan3pbW
         JIdjpnp1ubmqZVBSbupnvNhfRRjLq74US3IRZxiHhEQFbLwAa5WqqWCCm1N6Vb9VZqFJ
         JhNQ==
X-Gm-Message-State: AJIora9PfzbgD4SctjiW2K3JZrmQrfj0wx3LDnTBKTOLo7CrO62DmQC+
        7XIWgZ+LsIYVvIp4Aw2VkLCXHTKHgkfwFA==
X-Google-Smtp-Source: AGRyM1tcbRFwVYIPXaW+CRBc4OIUiWKo1cGTRzN7VKOZVMcHqoIkok+gIh2/fcrKZHTrAdJvadiyTg==
X-Received: by 2002:a5d:6d8c:0:b0:217:a419:c3f8 with SMTP id l12-20020a5d6d8c000000b00217a419c3f8mr4649548wrs.260.1655209846292;
        Tue, 14 Jun 2022 05:30:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 09/25] io_uring: never defer-complete multi-apoll
Date:   Tue, 14 Jun 2022 13:29:47 +0100
Message-Id: <1bb69d5cfe760bec1b2b2a6405ccbbede37cb9d7.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Luckily, nnobody completes multi-apoll requests outside the polling
functions, but don't set IO_URING_F_COMPLETE_DEFER in any case as
there is nobody who is catching REQ_F_COMPLETE_INLINE, and so will leak
requests if used.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8ce8d2516704..5156844ca2bb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2149,7 +2149,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
-- 
2.36.1

