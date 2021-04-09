Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD6035977E
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhDIIRu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 04:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbhDIIRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 04:17:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C532C061760
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 01:17:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so977183wrt.5
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 01:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hlgPGi7qNhoxEJK6a5X7oZaUXgEODQa5Zdufxv6uz/g=;
        b=P0yAQaKtkjTbPW7L4iqDaQHdWCr1HzrMydLm/idQfQrjeGjIhkf/IaaA5GiTdVBIFw
         QhwoqvFaRnhVmLWkF0NxC22JLBr47sQgVIn0eKQrpCVE7fVxAOWI0m8zlrzkVhQiT5Oz
         D87h0eLii+MtVBpEggSB7lP0jGpMnXOpBGvsNaRBCuACYqENEY8VCdFUrPILuPW82Uuy
         qrQS0CR4OzZQYPQG5zxCiVU78uRZ7Km4q5YkmIfm9dj9+hgl/Pk4MnE1TCbSS9kZ1dWm
         MXFZbCuu49o+2znGicxJcb2aGAP8RmiJwLSS265Ole54RjZuI8BHyH+hCDP/+cjsT4uo
         MQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlgPGi7qNhoxEJK6a5X7oZaUXgEODQa5Zdufxv6uz/g=;
        b=jHLTmfgJf33g9A/Df2DgWUjmaEa4IdpZzCgPWgGn3uORRmtmeoBcLhdifWnnrsSgLa
         ozgwhEJrwzxzzukjSrWgHKb56fxFZr+RcPk8z1EdIdg5vGC53avyJi1iCaIxDTvPgQBS
         Ml31CZy321scxYd15ovjHUfrbexwhiYbfxeUTmn67ijxPIBqW5AM7hCDNYtAawsY/fDk
         Q9KgLcIp4sKfxjfad4mtfv/5nS4sl4cM+6dHikFezWk5Vk8wVOX3Ovm7rXA/mV5ljqyf
         9NhbE6Q7DRJx8v8sNax9asSekRlt39JGg9iYS8/5MRcLpskLEI0Wzt6+W9q5aQLXRVlf
         iO4Q==
X-Gm-Message-State: AOAM5330KwL6VoC6178F5mSPj/Nan5DxE5wgGDffiZlvV+g+rOt3tKLz
        YnxEUZTTM7vDPWUKLSd9EPo=
X-Google-Smtp-Source: ABdhPJxj8qvHGer4heQmSSXcVJ5Iw/74/+MrdYvUsMjSlSOnEfjS6Odo2llXgSkxb/MXIoc8t4Ktjw==
X-Received: by 2002:adf:f48e:: with SMTP id l14mr16255090wro.257.1617956256245;
        Fri, 09 Apr 2021 01:17:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id d2sm3262133wrq.26.2021.04.09.01.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:17:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: simplify apoll hash removal
Date:   Fri,  9 Apr 2021 09:13:21 +0100
Message-Id: <965e7744028428e6b664c8b859cb558ab7de97d1.1617955705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617955705.git.asml.silence@gmail.com>
References: <cover.1617955705.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hash_del() works well with non-hashed nodes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5a0091e4042..a724e63dd8c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5040,10 +5040,7 @@ static void io_async_task_func(struct callback_head *cb)
 		return;
 	}
 
-	/* If req is still hashed, it cannot have been canceled. Don't check. */
-	if (hash_hashed(&req->hash_node))
-		hash_del(&req->hash_node);
-
+	hash_del(&req->hash_node);
 	io_poll_remove_double(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
-- 
2.24.0

