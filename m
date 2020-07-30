Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADAE2335EC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgG3PqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbgG3PqG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:46:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60A8C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c16so8064465ejx.12
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Qwj+X1GiQP0yoqUkhUvy6EMMUSC2K/euXceeh6Fjk50=;
        b=KtwYYZLZgtRveDF+eEZwEBqvIf8kSbacsaBSGUDlwA0XidpcsnUWxtBpawbaPx4U6q
         8BBUtwWiH2Rn9vQMK5hQtXG6RFOBUSxpAbJjXYrC5l6pv43JmEhQDcCMEDxN36Ioj1M2
         Noozp4+ZWGu7KS8KMOVTbGGDLNQxbUJb1HeqoRGcbOwHtWWwsdsg8hALO8mQcyTlOR0Y
         PbVYSdp5XZENLu7LGBzaZ9USQ6eUkJjGUW0c9CCEUqCEt8mK56iQZvo1NWfXAsxxRete
         AoVs/SaW9G1yO/6PuLyG4vac8QW6bi5eXvoqUqW1odZ+hYZh8HqHHA1FYD/yasPY00fa
         BlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qwj+X1GiQP0yoqUkhUvy6EMMUSC2K/euXceeh6Fjk50=;
        b=aXhyb+Q9hIXVvYBr3s/Al91ackfawZ2mSldJFFuoIWW14dU1x1YWQkoMNW0mad+Pmp
         j1t3uErFy72I7Hg+WKS87+mZmtBGcdLKXTXeh00YXXncH9AMWz9bzEgI4nkqYKGl9u9m
         BFcVAfna0Wt+HSWoPBGBue4ACss3fMRElo1hCQlVRIVty13beRgtOi152xhyOMVXsMPA
         jza5UGwkghBQRJJdHezhSMt4p/Z8wZus5Izf2W/tgyhlU+XuwlTo4siCgl7EsgjzaoY6
         +sab/K60+d6t+TaNSnkzEdqcjtG8DKr2QFR4fgHGETamZvCt2hDYyhDuJvy/fW2Md2Cm
         dPxg==
X-Gm-Message-State: AOAM532YjlFyS5P6JvBO4eUiUsbFUDHliqAoNqk5RrD3rsIbWt4GV1kG
        IvNjJojM4xv8RgwsFsZulpc=
X-Google-Smtp-Source: ABdhPJzkYFDEEBg/0WOStjBSya0P+px2cnA+Nu8zYuRcRZi+l66ZLnoH2+OwnXGGNnBB1VJC6bpPFg==
X-Received: by 2002:a17:906:23e9:: with SMTP id j9mr3108878ejg.107.1596123964635;
        Thu, 30 Jul 2020 08:46:04 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:46:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: fix racy overflow count reporting
Date:   Thu, 30 Jul 2020 18:43:47 +0300
Message-Id: <ba9c998d27e8e75467b09d8a2716cf6618b7cd93.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All ->cq_overflow modifications should be under completion_lock,
otherwise it can report a wrong number to the userspace. Fix it in
io_uring_cancel_files().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11f4ab87e08f..6e2322525da6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7847,10 +7847,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				clear_bit(0, &ctx->cq_check_overflow);
 				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 			}
-			spin_unlock_irq(&ctx->completion_lock);
-
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			spin_unlock_irq(&ctx->completion_lock);
 
 			/*
 			 * Put inflight ref and overflow ref. If that's
-- 
2.24.0

