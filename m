Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAF2D07AE
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 23:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgLFW1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 17:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgLFW1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 17:27:34 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95491C061A4F
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 14:26:18 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id v14so9958649wml.1
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 14:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yXrVoOwEnit7NvL1cYM17xYiYY2EWut9drlUmISg2vM=;
        b=FEQL5BeY6yuU3L+/Kyams/4QKKnNydYJ4tULSg4FxPutiOIoRClEH8yZSoEYuGLqIr
         e9hFovaaaXWhc/HRB3gthLXFuAjlpTx+9ZcFJybExVMCZDnm2HkTgwM0SQtKa561s8B+
         zkuejf4O+Qla78gTQfI2F5oSrDnJk/ejYpXziKuA3JfVJkx9AOaUrhpDsO7vWluKvBYZ
         k01DvKoEJNWHzatHqK0GSaRYYTXOvIENU/m7N5bDK/kzQyGwnvH5U0eavOwZFCknWmlu
         A9A1sFygWNidO0UiyZ9dbNbxWRgW/Yy1ItRw1afoB6TdCi9VSuj2/hu2ldvhLon4kN0p
         LMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXrVoOwEnit7NvL1cYM17xYiYY2EWut9drlUmISg2vM=;
        b=WXhYj78vRHJLJ4uMxFNvWiyiaJhY3FYS7EVJUYjBgIc7bfOhBD2acayaKycqo8QTIg
         Zoj5OiGC2jeo4yEqJ1Q7aWrJTkJV3JI+022X6BjMPjdX+UOgcWltWphVCuK0wv6HZZAp
         oAhNIRhmtfCHF4GgpK4PSR4ELy4ttPz/0/hqnmzE1DM93q7gFTNwM+oVWb3fiZmUciX1
         NQ33QoQ9NSVr30cOQtufiM17MRRR7rTdv9nfvPizD/GVjmCc5EOFI5Z4Atf01YaI+WOx
         /xs13c+fl0AZkgWOK0K2P0At/1wPgz9C91qU/ofU9LgfInzh8JJQW5wtideYFMxz2WbA
         KUSg==
X-Gm-Message-State: AOAM533bw5avJkgt4FC5gKIPNnHDp2bPsvLKVz0k91dmBY0a1bomesJ8
        /YyMV/GwAqE2d69zfwrwfDv05y/XxXkcpA==
X-Google-Smtp-Source: ABdhPJwLGEVOt9hdGf8uu2IgT3j0BA5s0jvZvrcrW3fDUTPMJzwr26FC6AIzaonbtbC0VTo27ZgSBw==
X-Received: by 2002:a7b:c2e8:: with SMTP id e8mr15145620wmk.103.1607293577415;
        Sun, 06 Dec 2020 14:26:17 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.10 5/5] io_uring: fix mis-seting personality's creds
Date:   Sun,  6 Dec 2020 22:22:46 +0000
Message-Id: <19d9a41141d1a4bed4d16a34a6679797922aa211.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_identity_cow() copies an work.identity it wants to copy creds
to the new just allocated id, not the old one. Otherwise it's
akin to req->work.identity->creds = req->work.identity->creds.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f707caed9f79..201e5354b07b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1284,7 +1284,7 @@ static bool io_identity_cow(struct io_kiocb *req)
 	 */
 	io_init_identity(id);
 	if (creds)
-		req->work.identity->creds = creds;
+		id->creds = creds;
 
 	/* add one for this request */
 	refcount_inc(&id->count);
-- 
2.24.0

