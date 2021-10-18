Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832E9430D15
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 02:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344856AbhJRAbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhJRAbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 20:31:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E17C06161C
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d9so63643749edh.5
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eb7tuSZFnh6wPgGmyxW9nuFuxujgJjZdBfp0UoPeVWg=;
        b=hd8ZQzO4S6v9AG/Pve0Wosx/ltUxjypfVKB7V+t7JivOZOmgPCVH6V6Waz1xbRurrN
         q1G4qQwrFNiPa1u0W+qh0Pi4V37LnEY7pB7rH2Wp0Y7mbnmYR2xzZ1tKK9ktN2wfRay9
         U8/YdOS2da5QyDTLYEULDRw+ZcjDY8bnUS6GM9AcfSMMJ8o2geRzK8iVRYriOSW0RYPH
         VEqArENPlqHjBe1OKPWQcsXvPBNkHTLXHoWQBfDq0Wy5FIbCm1IupPQBvB+/j/xmyIHt
         XNQQ3DJLUfetxeA6KoPznmkkLiQOfRc/hdpzTep+uEJaENMSGMmWTLrm5te2m2aC1vNb
         ECNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eb7tuSZFnh6wPgGmyxW9nuFuxujgJjZdBfp0UoPeVWg=;
        b=EsEtKDF9eoz5A/52rLMxlXMWKYAWrxRIaDWsQQXxtxsE3YFNd2ZzVR39JEKsxrpyPd
         9uLcrlT2f4RFwEPK5iJK0FjDZ6Oa7JszSMktWXMSnr50+13KxtGAyZHhY0+w75eprsso
         KwYzoqhxUTRJfpCau8FAFWiH20fBqPpSqCnaACY/OFx8c9GT26aOuopmN33u0+obvKqc
         QZmI9xJaRf21nzDwWBPvCCCC4+U+KYW6CsBUMTnO3ZdWSwYlysRM0ZFPcGgedkU9coq5
         5zXSTcpgHAGxW3RYOtt14KKK3lsb8BeYkgT/KszygSeSuFbFY0oSW1or/A+sZGYwQcL7
         O4yw==
X-Gm-Message-State: AOAM533SKwh9bj7feT7U1M7oIUes92IKdqrotn6L2St566/+dkww0AT5
        LQLvC1vBlFVqUI4CHuBE073MNMvgaPCNeA==
X-Google-Smtp-Source: ABdhPJyaoXVdVMajD9iv2urVQXp3hIueKKSKWvoBQy9y8APdQBMNnzW8A7nxMH+8/WU/YSi9baKWoQ==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr40470048edu.356.1634516961461;
        Sun, 17 Oct 2021 17:29:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id q11sm8881489edv.80.2021.10.17.17.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:29:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: clean up timeout async_data allocation
Date:   Mon, 18 Oct 2021 00:29:33 +0000
Message-Id: <16f63174013deac5076b2f63bd1301664af71f34.1634516914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634516914.git.asml.silence@gmail.com>
References: <cover.1634516914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

opcode prep functions are one of the first things that are called, we
can't have ->async_data allocated at this point and it's certainly a
bug. Reflect this assumption in io_timeout_prep() and add a WARN_ONCE
just in case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ead1507be9b..acda36166a9a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6120,7 +6120,9 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
 
-	if (!req_has_async_data(req) && io_alloc_async_data(req))
+	if (WARN_ON_ONCE(req_has_async_data(req)))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
-- 
2.33.1

