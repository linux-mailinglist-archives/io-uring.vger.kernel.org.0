Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B3B35B10B
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhDKAvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDKAvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:16 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059DCC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so5503855wrt.5
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QfyIzYm8iEWiD65dVqhBGeRaLv0OOCUOHYYH1D5GYJQ=;
        b=hwXHUsdaasQSmj23G4UYBxH8aptg94W8AmhycW4Wju8fPTrUDG6iiCzt20zUck/MJG
         eF4sj+N/VkX2vCZDuGmQuND8e0WDnYaFAnpR26VWJsbbDM28uHA6Uzfje/jLYCYgA/t2
         IEqzccvQnhfuS5KxoXcMWcpjDgcgmw/2ICQdAhDuDPv/faBfjYqWVlXdKSqvpBR0uNVu
         mutUIbUWorHshEqfaWMPZx9E3yJz64ZDDmP0dDOIsc+j/7uFiPBPuqIJBPgREyxRoSIu
         47Lyehe/gHVe4KwRfoDaIvtBWxQcvGV9S75KnOszqwa/b2uI3lKB3C14HV1n4RsPZv+K
         mSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QfyIzYm8iEWiD65dVqhBGeRaLv0OOCUOHYYH1D5GYJQ=;
        b=TuS2yxeeIrfySUAXKfm4xX0imB9wtl1DLD21zpKLG9TkB4T3LdsIegOW+7u5U7Rp5t
         LsrmZDbwx3fwqAbS4JyGrDU6yGs/PuNg+tgCiN1Qq909rOTOCIupqBfmP06CYMzvggJ/
         uILij0X7wfe9/yHgfllKxG5SIdsWm7I3qHp6FonE40Xmp6k4Pk+/5TfizlOurP1aqgHU
         Lxoz8/V3fBbsJRgG76vPC5cvxxysvhl0syrPX43T2OjI/lj9sGPgwFuvZZ6wrCulIUSY
         27NtIMR6zvl3jC8BBOCTXgwxCvjTlbhRSrAdEN9mIfWsx5JEtqr3PduYz604ywyHJ9qQ
         uFWA==
X-Gm-Message-State: AOAM531NsYmAmZAm/3e8JnGQ6G+Cs9L9CZf5xd19LjMT5dWBy9iQU5by
        trr5dGVNL1E16iSk7tiR7is=
X-Google-Smtp-Source: ABdhPJydnwI9XYUsW+I9umczqiizhW9emCLGgqVh3Gz/yEp8/69Mdf6FmH8nRFSuQUMHe9l6bF99Kg==
X-Received: by 2002:a05:6000:1a89:: with SMTP id f9mr21838176wry.288.1618102259833;
        Sat, 10 Apr 2021 17:50:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/16] io_uring: optimise non-eventfd post-event
Date:   Sun, 11 Apr 2021 01:46:31 +0100
Message-Id: <42fdaa51c68d39479f02cef4fe5bcb24624d60fa.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eventfd is not the canonical way of using io_uring, annotate
io_should_trigger_evfd() with likely so it improves code generation for
non-eventfd branch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd9dffbd4da6..87c1c614411c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1357,13 +1357,11 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 
 static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 {
-	if (!ctx->cq_ev_fd)
+	if (likely(!ctx->cq_ev_fd))
 		return false;
 	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
 		return false;
-	if (!ctx->eventfd_async)
-		return true;
-	return io_wq_current_is_worker();
+	return !ctx->eventfd_async || io_wq_current_is_worker();
 }
 
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
-- 
2.24.0

