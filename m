Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8271D2029FF
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgFUKLh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbgFUKLe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:11:34 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32F8C061794;
        Sun, 21 Jun 2020 03:11:33 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a1so878655ejg.12;
        Sun, 21 Jun 2020 03:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hXCaj+05K3j3ohDduMYvUhwQVadDBgc0NER8cldE3iM=;
        b=JacV56jN0UAqIKn/L+yrXZ1YfYh4Q/eYmfobEmxx0heGkHbYeySg4Cj47tcTXnD7mt
         cCkH53ca4G4ptICTZqM8IM285xnI9ZoY95ylV2hvfwyWAbO+whlUmGqtt+nBn2Kwn3az
         dFGk7ZLN9aPqsHEXsBlvcgFOZo9k4TIx/dJoKDUyFBvp08Y9Tt/4dK6SVXpnEE6yeuQQ
         Hpe7P6JmjNampNMDfJ3fgwizQ4xil4HuQIM9wJ8wVq+Phtbq3w524OzD6UTuoSacxepl
         FhbT3lHYTzE6Iy7EQQAgdwOI9ApgVCt3w0kbtfhY/WGLWB6xSs+rqXPnePfzmfZr4kal
         d68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hXCaj+05K3j3ohDduMYvUhwQVadDBgc0NER8cldE3iM=;
        b=jn+CIIKWhtA2BLfw5S9M5yKazc1q8H3ZQjBp2TO7wTuDN3BteExSbpbswKM5LAy078
         JFTLH1NxJJ+7afnZPDMXQNwA/ldljb4FdY4BmecN9Bcv92O89WSxzWQ+/m/7RnaGRM0j
         c+iFvyY9+l4kmBZsmKARPJWPMb26NP43iG03q9sa4jB4xCzRQeZRQ2JGQn5RiZWZMoF/
         BSpeoEwN9IKAhi703kJ2t0wSoH6ZYhpoXKQbLRBzAhRz5/lMoijcD7vopSaLavS9CfMi
         w7l1eDMheP6bvqN1doJpdTvEpeeclYOx71pECeXw5HrjR9twHQI+sYVVpmIlgA5jEwNR
         XN5g==
X-Gm-Message-State: AOAM532s07cqFhhxxWhSV24jOkYNnwBVelhKju3dHjnyvyQj0PK8trlK
        WxVC2FVK3s2b+vkzpXTGuBSYZk2+
X-Google-Smtp-Source: ABdhPJwD/Fk0NKPL/Oar5fQLEajIuGdP8tR9+xcDjlZPPAzxEKDeX9ycN/ovE37IkAAnKDCD+wLYTw==
X-Received: by 2002:a17:906:191a:: with SMTP id a26mr1183980eje.315.1592734292554;
        Sun, 21 Jun 2020 03:11:32 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id y26sm9717201edv.91.2020.06.21.03.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:11:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring: kill NULL checks for submit state
Date:   Sun, 21 Jun 2020 13:09:53 +0300
Message-Id: <4b127f2fd5c4f5587a8c1d497c055cf39ab31cd3.1592733956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592733956.git.asml.silence@gmail.com>
References: <cover.1592733956.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After recent changes, io_submit_sqes() always passes valid submit state,
so kill leftovers checking it for NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 676911260f60..0bcf819e9661 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1371,11 +1371,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!state) {
-		req = kmem_cache_alloc(req_cachep, gfp);
-		if (unlikely(!req))
-			goto fallback;
-	} else if (!state->free_reqs) {
+	if (!state->free_reqs) {
 		size_t sz;
 		int ret;
 
-- 
2.24.0

