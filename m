Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2535D51B
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241562AbhDMCD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbhDMCD2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:28 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60653C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:09 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso7888256wmq.4
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TlJ05EDp2k6S/uVMZ79ZeP3EEish7emwDE+wHPXzSEg=;
        b=eGx+o7OW4YYM7P8bi4nLgg5c8Jub+IxDbIIWGW5DoOecXO8ATPwdrvumB0xOjatLci
         2sEfAyxqWFzzFQgUSNslA6XAq4gGSw2DJ3uujlFrd6RnYF7VGBlPiomRGb9556Uhk7Y5
         FkASk9vaOE4v1tTVtW3D6ZoYPCcV8q8WQ417doq1F8GdgZ+1+/L3qs4QdeqnREHfrvTd
         RlUZOmrRco+YyFsOQ6LrRmetHAFv52cKGTLn013PTXb2i/0aAqoGgBv+Oh6p6eMFeuNc
         TH5wpCpEybadhNKrlHc9P9EL2YeIuOm9tWVKEsqEVzaIyEc2H17TSmfmmSO/ea2Zqqks
         bTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TlJ05EDp2k6S/uVMZ79ZeP3EEish7emwDE+wHPXzSEg=;
        b=GUVWvwSNX7zkMiXOXrX3G9nRs8gB3PWmlzjZYLUlKaUVowQoJ4+ouNVydIsWVGixQu
         ZlytEP0D2qXxY4i2HRbbOd5SBt5kuvaQ93SU2bFDui+88HFaw4/hlenOZZ04JzyjXVjT
         lC+bv4WHpLo1ZgDfdr/af4jbKQVbcFs/yCW4ZbvQDqon4ksCzO2mJeixlwmrcNXxtJO2
         3MKVeFNXqnZRVcdXHNo5XGXf0CGrTO5ea/et75n5/cHmlndrqk+HXFh7yqQkrNS0aGQJ
         SSpcFGxXpsWGvwR1x5FkFg6KyQT/5fGTrnjtDn4G0Rdr5gj6L+yINB+kwr1Tht5NlYbG
         N7OA==
X-Gm-Message-State: AOAM530WI1jEKNG+k+juTDgDAZhFYR71LkMZGvYCqUQazDcvoEMQldVC
        4bxWNYGpRGodXjTrNCcikb0=
X-Google-Smtp-Source: ABdhPJz9SS/JqHAsFi9eysBZ7yHgXXK2WnDqFZNuir/CdP0gf/vGZIYbn3ll5SgxXx4Pbg+m169r3g==
X-Received: by 2002:a1c:1d53:: with SMTP id d80mr1681674wmd.62.1618279388207;
        Mon, 12 Apr 2021 19:03:08 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/9] io_uring: clean up io_poll_remove_waitqs()
Date:   Tue, 13 Apr 2021 02:58:43 +0100
Message-Id: <bbc717f82117cc335c89cbe67ec8d72608178732.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move some parts of io_poll_remove_waitqs() that are opcode independent.
Looks better and stresses that both do __io_poll_remove_one().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4f4b4f4bff2d..4407ebc8f8d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5224,21 +5224,16 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req)
 	bool do_complete;
 
 	io_poll_remove_double(req);
+	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
-	if (req->opcode == IORING_OP_POLL_ADD) {
-		do_complete = __io_poll_remove_one(req, &req->poll, true);
-	} else {
+	if (req->opcode != IORING_OP_POLL_ADD && do_complete) {
 		struct async_poll *apoll = req->apoll;
 
 		/* non-poll requests have submit ref still */
-		do_complete = __io_poll_remove_one(req, &apoll->poll, true);
-		if (do_complete) {
-			req_ref_put(req);
-			kfree(apoll->double_poll);
-			kfree(apoll);
-		}
+		req_ref_put(req);
+		kfree(apoll->double_poll);
+		kfree(apoll);
 	}
-
 	return do_complete;
 }
 
-- 
2.24.0

