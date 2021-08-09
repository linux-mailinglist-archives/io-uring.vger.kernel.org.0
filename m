Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE823E453F
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhHIMFj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhHIMFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E03C061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so14443008wms.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ESmiw6an763N3DIXnpThepLwM9LzWPDRHF7nkJutiGk=;
        b=mhF6P8Mz8CWDCV6yq95lx2db82MqUlCopz4wAPwNrO0qpPjjo2zAZ+geLYhljpbWA/
         YlqfVaqjjjJR7m7QAvZV/BmLyE9GbYZjlkgtzQ984AN20t6nkX1OxykzuatfiwG07cTk
         XRpaUghTWq14Mn5DwEEQeM0mpnjvStgIosYmaVvpdJfM0rMFgSOQxOZL1rmccZbGJvPG
         hyUbY/i3Xyzg+9EtYceZsXJukg1HUMWkB6ed0ImW8KxOlrmGMnVcOm0PDElPgiFhWKEB
         kZalh0WGwJw3926KMLpyHdcm7zKwGkdNvmbmlEx54d4jGytQ5nxeH1FFOLvHWtp0a6ZH
         PvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESmiw6an763N3DIXnpThepLwM9LzWPDRHF7nkJutiGk=;
        b=ZcFQrEQUUPjX5urhW3B0gxhn67pmiIgXR9l79N/2UBzEM661kPiSa/iT5cpCZ1+jFT
         OqGus1rXhJ5r88i/hyz9eaJOT1X3IyfWNuK6/tcHuss72BJ2l6PfO9eorZ/AASttm/iC
         jZ4qO0OYamcibZvc4Ajz/Yl3VFGvbSGffiITdLiYxGeKEhBI9kEbDRVX2pPa2klVeL0H
         PeRHZ6kd3utdjCwbBP0jgUVFjiEoB6m3RhU4Qg8ejSLfSgTrejhrnDKbJottYW9q1khQ
         BeIA6hT7exB7OlxF4sh09HfRDXhWgSPrTe0xM3DsI0v7KCLrqphbiXYI5sIHISbBzvw7
         7/5A==
X-Gm-Message-State: AOAM533x67xJL4DPHTMlHBJwBtViLom0sktUprsGYSMusYOvbllV8SHt
        T6xrZbYgpYCTd2D6/QFmD+4=
X-Google-Smtp-Source: ABdhPJxVALpPcXxbI+1bkIYEhyUOOvuyLcfdKova1cIQA/aLKZbazOAkf0k2w+14sJeQ5br+Kw3lWA==
X-Received: by 2002:a7b:c749:: with SMTP id w9mr16413097wmk.98.1628510717070;
        Mon, 09 Aug 2021 05:05:17 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 15/28] io_uring: inline io_free_req_deferred
Date:   Mon,  9 Aug 2021 13:04:15 +0100
Message-Id: <ce04b7180d4eac0d69dd00677b227eefe80c2cc5.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_free_req_deferred(), there is no reason to keep it separated.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1237e6e87ff2..17ead2a7e899 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2179,16 +2179,12 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_free_req_deferred(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_free_req;
-	io_req_task_work_add(req);
-}
-
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 {
-	if (req_ref_sub_and_test(req, refs))
-		io_free_req_deferred(req);
+	if (req_ref_sub_and_test(req, refs)) {
+		req->io_task_work.func = io_free_req;
+		io_req_task_work_add(req);
+	}
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.32.0

