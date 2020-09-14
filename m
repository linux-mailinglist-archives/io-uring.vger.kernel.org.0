Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA2F26918D
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgINQbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgINQ0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:26:07 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C384DC06178A
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r25so784016ioj.0
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b6A8kuTVdHTJBvGzXju+QPO8VYtnLBOIBhdpvbm7Kxc=;
        b=S6uKY270NFIUIdOVJea4hXqVzR+CltTNSHmZSXTjEREB63TBmG5RPyr1KV0oUZKL8B
         cIWZkGih9fYoRUHjZzynYHbI1820OXzDnD5mOX9z9ctSZ4zAOD44Yz+Tejlr2fJrT+vs
         Q/wxEGWmpHj77cJ1LNEjOBseqbdNEcA6sbkQAmTdJSCJqU4obVVtvcYW1G82XdonJRmW
         UGMd+Rko28LESX+C+ALpfGY1H4paLEtKYcCfPDKc65ATEukWL3ON5lu05dhS81iJYwq0
         ye9KxojASWI7lc9GpU5evjmpT9N+j+3UWBlcAY8Q6zWJI/4+P58HbacVEAHnZzLBAaCb
         folw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b6A8kuTVdHTJBvGzXju+QPO8VYtnLBOIBhdpvbm7Kxc=;
        b=S0i2MDy6xpLwV5zEcH0bEe90nhtI98pM3Auf8zkBhISnN467bOlkozPtKnHhNTlGOz
         ozWwzaB4L7hIsHsZrimBF87h9Kp4fvd4htAYGanqyx3LrJXNCBoPaKMqOUwyP2Q6w29U
         wUXrK03vdHx0OGD7V4tmgmYfm0tP9fmxQrmK0F2USggPJ4mbX32oKuEG2YDfvbDTy7/1
         ccPJEsXznc1nuEyn6sWGsIG8NDucOZZ07+23He0vNEEHn4NLczpdnlu/Mm5czMvL51vZ
         ovhqiK1La/Vwbw+Q1rpMJeqDAcGmPYSOuQvAcNsANPQvzG/u5DVB1jpxRaq7XHhWNtMb
         bHmQ==
X-Gm-Message-State: AOAM531yLCpCYMC82LZB85r7rApgl3miRqM+8UJShsh4NrO7jfHCQ7C3
        /Rb3YjJrQyVenHx2/kCTvbziM/XOzRxf0hxP
X-Google-Smtp-Source: ABdhPJyc8DY2vwiAz4U9bFIYlSDdwETDUQpv7xsawfn42jktSO3GqJtvIIudKTPsPc/fJOMFtMkBVA==
X-Received: by 2002:a05:6638:224e:: with SMTP id m14mr13967640jas.101.1600100765717;
        Mon, 14 Sep 2020 09:26:05 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: grab any needed state during defer prep
Date:   Mon, 14 Sep 2020 10:25:51 -0600
Message-Id: <20200914162555.1502094-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914162555.1502094-1-axboe@kernel.dk>
References: <20200914162555.1502094-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always grab work environment for deferred links. The assumption that we
will be running it always from the task in question is false, as exiting
tasks may mean that we're deferring this one to a thread helper. And at
that point it's too late to grab the work environment.

Fixes: debb85f496c9 ("io_uring: factor out grab_env() from defer_prep()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 175fb647d099..be9d628e7854 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5449,6 +5449,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (unlikely(ret))
 		return ret;
 
+	io_prep_async_work(req);
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		break;
-- 
2.28.0

