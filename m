Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377E93D5A1E
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 15:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhGZMeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 08:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhGZMeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 08:34:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC16C061757
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 06:15:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h14so3084524wrx.10
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 06:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+tnUSYMtPKpTaq23xhPRRUDqyBFSbrGdJHO9ZO/6Ic=;
        b=DXn+lBhs9xkvobct+GmKheNPXyhGzgMsXB6yWCMGbWAgpFpr2AaNNT8FA5TZN2kicA
         CFHTS0XdEk4RIp+5ou/3nC8fhgXn3kKt1edBCiYfzvOMgUVH69XM8GTx6raZBV90S9AW
         DLyxbScnbgOBLWRTrpBvzjE80ojzYX8hfQWqGBHzwkiXWXrJsc3qkAYNOYNSO58+JGJx
         K54EY0KFz1JJsBYWEsCD2IhSsQKMDP1RJbtafW3bk7pjjSvRuSrhXJKG0vgHlXBIPOT/
         iVkNw8iErVyTksm5zgUYOjkCESh7Ey5BtshFXTlFqWzjGP41y52Sw8N672qtt0sbQmUu
         v1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+tnUSYMtPKpTaq23xhPRRUDqyBFSbrGdJHO9ZO/6Ic=;
        b=fwpYE+IIoxEGT3YBX/ufBNAnj0fwR7H134nvZAV6p1/wQQyzMUb//ylBzU0E7HqyS1
         Ry93Uh6L8oBCNPwz7GDM3FOPXyVs79CQX+7gvnBoO8lQDh+qLxuV4E6lhpnEZD5qmyJs
         rq8DLFpRVVZ0glAilJaIApsgDngq+vXKtbOzaeCQBWCsJeVOaxkfFmVoyBzvCRI9VoZD
         Snej8y5OiTuEHgQwoh2azEg6vzBxhvQDPO2qMGbc0/rIBMIMqujRhjCchuvb7uPamLg2
         VZIZ0ELlq0K/d2kNgrOxTHfREr+CG/tUg45tZsZtQ6o2v7J7QirQgqXQBndEdflMPSX8
         g4Qg==
X-Gm-Message-State: AOAM530zOsRF6RWXmbpblqVWI35jLi/KeRZsc1HNQkAToJD852DghPL6
        6PFxsbQI0M12aROuW+m1PUI=
X-Google-Smtp-Source: ABdhPJzLtJN5omyD2MQhtKH1YjXhcrG4ICdWz+IRd7b93Q8Sx8SOGhCWLkUNjlbjoAnmbetpC0O7FA==
X-Received: by 2002:a5d:4284:: with SMTP id k4mr388274wrq.407.1627305303055;
        Mon, 26 Jul 2021 06:15:03 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id n18sm40956775wrt.89.2021.07.26.06.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 06:15:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH] io_uring: fix io_prep_async_link locking
Date:   Mon, 26 Jul 2021 14:14:31 +0100
Message-Id: <93f7c617e2b4f012a2a175b3dab6bc2f27cebc48.1627304436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_prep_async_link() may be called after arming a linked timeout,
automatically making it unsafe to traverse the linked list. Guard
with completion_lock if there was a linked timeout.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d995d97beeb..6c2cc374a2a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1279,8 +1279,17 @@ static void io_prep_async_link(struct io_kiocb *req)
 {
 	struct io_kiocb *cur;
 
-	io_for_each_link(cur, req)
-		io_prep_async_work(cur);
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->completion_lock);
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+		spin_unlock_irq(&ctx->completion_lock);
+	} else {
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+	}
 }
 
 static void io_queue_async_work(struct io_kiocb *req)
-- 
2.32.0

