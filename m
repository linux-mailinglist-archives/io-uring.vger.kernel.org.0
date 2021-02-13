Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731F531AD05
	for <lists+io-uring@lfdr.de>; Sat, 13 Feb 2021 17:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBMQPk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Feb 2021 11:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhBMQO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Feb 2021 11:14:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEBAC061786
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:17 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m2so1657747pgq.5
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T/tptoFcBP62mdqUTlXtVpNctwPMerJzD1lEPWBhwUQ=;
        b=FxVXQdXTNZcKdP49Fr+Z54+Tgoe0il2TtMv2df2TCbwbuuf2OR551K//HDQhB1gEq8
         w1JK7Wr0l+692fAaYpDuVNVlFGNs5RrbBMcWXaslxbCR38lbMjgWMkH/n7R9c2dp+GDk
         XXEq72pCzfnwMtSrAAlnGMIkfiO/VPokxL/q0XLs70avW/HcW8dbKE0HPf6ByHdvwE+/
         OIepUMiq8q/yBYpc4wc1AMkN6w3oPWrgV2NQZPAOHJf9SC0dQPPzUEfwfxFCaJ0R296x
         N0VYCyjTCLsomMYskiBBE5TknfN9MDgccF2LPOAvGoa8uveQDk7OCtUKN0/0OfvAST8T
         /X/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T/tptoFcBP62mdqUTlXtVpNctwPMerJzD1lEPWBhwUQ=;
        b=n7DeLkopSKPASYXFaK4AaapP5CzTMQDDxZeOXGX+1XRZ7/37BNYyiwJ3wyjkgW4t2n
         M38ZVh+kSg9Sjq8e3I40ZNPDmOOcZBDe1HCkiAUiNNPV2NIU7NF6OuDA1titcTvb0lpH
         GCG1J47Cw0eLxlWwPgy4WwWak+nMLoXVI0i0KhuH+MxaRTed8cB6FhOoYpdx0SmX83bm
         DzUrGiNJxuLnPGEMVDtuETWD0gdt3NguAUsy2mqrk2J9iyzImHtyh84sSo5oRa57kpAa
         bYBP+fTM+bYQZ9MEMbcE0ofV/w5lK9EUBbpVy9N9JRW0F2qqMZzJqrfpDbh/uJSLFyxw
         F6dw==
X-Gm-Message-State: AOAM530R0TV2sneOWYSoYLtC7UW6vuIAuvCjjO1btPDMcIjBNRK1fuaL
        qPO57Jd5T3J5qmn3ZyaK+BKyXRaK8PERzA==
X-Google-Smtp-Source: ABdhPJzssJBIlpV2E+uRCOX2eqEsU6/siLj9Rn2tE9ccqT6dyOS9iJHe+aR1IRjIDYsdp3m5qbrXHA==
X-Received: by 2002:a62:5a07:0:b029:1cf:f54d:6e59 with SMTP id o7-20020a625a070000b02901cff54d6e59mr7979544pfb.49.1613232854825;
        Sat, 13 Feb 2021 08:14:14 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 124sm11984975pfd.59.2021.02.13.08.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 08:14:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: kill cached requests from exiting task closing the ring
Date:   Sat, 13 Feb 2021 09:14:06 -0700
Message-Id: <20210213161406.1610835-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210213161406.1610835-1-axboe@kernel.dk>
References: <20210213161406.1610835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Be nice and prune these upfront, in case the ring is being shared and
one of the tasks is going away. This is a bit more important now that
we account the allocations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1895fc132252..a9d094f7060f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9232,8 +9232,10 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = file->private_data;
 
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
 		io_uring_cancel_task_requests(ctx, NULL);
+		io_req_caches_free(ctx, current);
+	}
 
 	if (!tctx)
 		return 0;
-- 
2.30.0

