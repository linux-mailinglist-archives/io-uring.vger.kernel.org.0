Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91E73BD1B
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjFWQtF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjFWQsT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:19 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47CA2972
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b5585e84b4so1310955ad.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538895; x=1690130895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSZQtoqAzhDTY0MUEMcJJxwF6F54WysrdBrpUmOaDJo=;
        b=hQSbsO4fStWXkomuzoa6x01KVK6sycjVgyfrluGqVKrP5MxD63ENDWEGjq9vvJ4O0C
         9YE9UGjY2/+KEveNTAHkTasxPIT0URnCX4u00IC+Ppbhgc8nlS55yXg6q3SUVC+6R9qP
         yyh6wTZUF4u2kmf3oZwdYwrFcv6/SblUXUGoak8nKXdWuoeiu0pgqiWSdVusMwaj+GkL
         97YZfYrVkrRIR5lk3ti6onv5He9tZAgOiLO5V1UwNFz5VGVTUF8BdU+jvyk1cLbhIQlb
         IZu+6I/k/MpE+qOTcHylGMu8Vss1zRFTdGITIEz7niKH57t09VfYD0gl+X+zKjIfKbi9
         Y94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538895; x=1690130895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rSZQtoqAzhDTY0MUEMcJJxwF6F54WysrdBrpUmOaDJo=;
        b=FgyJlpINwo8SPzHNePUHR9KMghkFcIFJYXnxIPbGTLZvarS71nGAZpeAzcnXCq6xrz
         xIniGie41Yt5dECzh0G972S4qCWUxoBk85d1Xb7GPDJNIgN/ijHg0XfZVYzXzU/tcWbA
         F+1KJJkhofP/WW2iqVPDZpo8PHjXJ+6lH9ft+DUhRHAS/099kBawaZed1CSYHfJ0n0d6
         j1lbzQYLJulkxCD8kEgfviXAf6mY1HoYzv39vgomZyS7qtUzTTb8Ak3PPnNmOgKXCG+l
         xmnOM/bwv1D4K48LVDdBuajnb5u64eXMvETQekFNF1pmDxjtVPh34d7Lq9ctN5d7BbIu
         +yCQ==
X-Gm-Message-State: AC+VfDyGpKOQVEX3phFV20SYsUDj8IeibPNEktQ5AqujuwSsC+1Oqay1
        gNlf49ea6HFSxYYSydNdpv6O9WIkyLIsIXmrV4M=
X-Google-Smtp-Source: ACHHUZ4zl8PHQ4wqc+LcjD9S1KHOK+u6gHQaUAAWxfATJycX3RLZiVgLpDNeo2kwaMFhw92d+vQJPA==
X-Received: by 2002:a17:902:d509:b0:1af:a349:3f31 with SMTP id b9-20020a170902d50900b001afa3493f31mr26823977plg.3.1687538894743;
        Fri, 23 Jun 2023 09:48:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring/cancel: fix sequence matching for IORING_ASYNC_CANCEL_ANY
Date:   Fri, 23 Jun 2023 10:48:00 -0600
Message-Id: <20230623164804.610910-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We always need to check/update the cancel sequence if
IORING_ASYNC_CANCEL_ALL is set. Also kill the redundant check for
IORING_ASYNC_CANCEL_ANY at the end, if we get here we know it's
not set as we would've matched it higher up.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 8527ec3cc11f..bf44563d687d 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -35,7 +35,7 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (req->ctx != cd->ctx)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
-		;
+		goto check_seq;
 	} else if (cd->flags & IORING_ASYNC_CANCEL_FD) {
 		if (req->file != cd->file)
 			return false;
@@ -43,7 +43,8 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		if (req->cqe.user_data != cd->data)
 			return false;
 	}
-	if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
+	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+check_seq:
 		if (cd->seq == req->work.cancel_seq)
 			return false;
 		req->work.cancel_seq = cd->seq;
-- 
2.40.1

