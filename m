Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D223E4537
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhHIMFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbhHIMFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4307EC061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k29so8290248wrd.7
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gQqHxgFrrYW46Qkmj1aQWq5ER5mnoLq4uIS2O+OthMM=;
        b=vhJnW1bESexwzVqrHz5zNWbB+HOpm/iOcreTlcDEa83cMca7vG+jf5pQo1U7d7oZzZ
         ZpNszle9jJKw0havZwR4lcEPv3YdcaxvSM9XeE2MRRJWVeu6vFFJ87fppH3FIt99H7aF
         pcgCB55weYM0JsA2jW7bVQdjFP68Hb52mkJCEvrCDqOhvoZhkeLQlf4zV7NaNtTpTs8Y
         v8VxQ9UNwgt+IvINGR0ydajBHj9yRhEhH9P+IhpejHJaLpGx+bbJSKGoP1CNGdfBDIB9
         XI6ldCK+9bjbYM0X9agBXG/NId2IfIL2oDJl8kVyoBNKHIeB3ptkddCWeeV8fAR2bgsS
         UvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQqHxgFrrYW46Qkmj1aQWq5ER5mnoLq4uIS2O+OthMM=;
        b=DZ+pQyqdvt7Pk/fl7EJ4FwscpG/OCu6q+/Qvv8FXIXxqECY47mjPmHPdm/7ZgrIK49
         aOV9KTXiw4kDz30uswBwiSIXbXsRBxcZM2QBCw+VNSuSUvvz1bGUc/M9Dy/zBLH/9gqS
         GT9PbcZWk+eyw8dUv6a6gq0su+e4ya9EFbQ4p17lMzWB1MPSMlMh/pJ80kWrfaMbKq3n
         TzqLNb+0J1VImshHRpLYPDcpCyuq8PbkMljFwyodPYy6CDX2POnk9g0XiKorBe+4xzZe
         r5I+I0nYUIsUMdN2DL+5YobkndSQTuRgsW5QDU4QOAz4wMpNErzZzUhxyDcwDcLudZEY
         B0Eg==
X-Gm-Message-State: AOAM533RcLJ1VJ0Gp4DCpgvKVOWLz5gJzXqmS9RBOgWMcybwi7Kcz761
        rRcuehWIf2Tr8OIz0wOZ8v0=
X-Google-Smtp-Source: ABdhPJw0+7JdoZR2ZbH7trZVYTfrbdW2sY5j7zFbWUzxzewoH/DFlTji/1JmSCFXZMgB188f0ujjUg==
X-Received: by 2002:adf:f704:: with SMTP id r4mr25230821wrp.389.1628510709976;
        Mon, 09 Aug 2021 05:05:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/28] io-wq: improve wq_list_add_tail()
Date:   Mon,  9 Aug 2021 13:04:07 +0100
Message-Id: <f7e53f0c84c02ed6748c488ed0789b98f8cc6185.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare nodes that we're going to add before actually linking them, it's
always safer and costs us nothing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 3999ee58ff26..308af3928424 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -44,6 +44,7 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
+	node->next = NULL;
 	if (!list->first) {
 		list->last = node;
 		WRITE_ONCE(list->first, node);
@@ -51,7 +52,6 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 		list->last->next = node;
 		list->last = node;
 	}
-	node->next = NULL;
 }
 
 static inline void wq_list_cut(struct io_wq_work_list *list,
-- 
2.32.0

