Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710C53492CD
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhCYNMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhCYNM2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:28 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EFDC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b9so2218986wrt.8
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6kLe4Lntbqqt4ODLzc8gTkVbc0pqtuEl5jJiqVJXaSs=;
        b=PM78brWHXr8KyMXhjQYHyI2sb1666+GAnPz7OJJCO/CS44RIfGPoQRhlnzM/mGbqQ/
         N6EX/rFfW9ioAOFAjLS2z4Fj17D6OKZGHe3PLOJkdLi4GUgzu5zsx+pdsllNQx7rayE3
         IwBwWmEg2V0geeuW+2daK8n3S/g/sGmLvRCVKBjWoJhB1yMBMFLv6YJ2b4aJaHj9ezeP
         ZfafYls7mTXRZ0PH0tRFuY4+o0AJXIulAB2PrZhk1/XF2z1pPJyV4qmJ3yERhG8QqEeU
         rN2KkZfcQrWqOzY4MrdONW89hEg5PD+9pUz0vBf2gkRS+E8tgm1U7efVZsS5iaIM9vxs
         p/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kLe4Lntbqqt4ODLzc8gTkVbc0pqtuEl5jJiqVJXaSs=;
        b=U/UyUU4CkilOem225h9CZIHE/Za6q0XYCd/dBtmUEgR6ytUXYityx6LSNbqAaC4jeJ
         l6YUkpuVDyueotXLq+1evRuyt0dpeSmoG56ZvN+pDOFvsLK0W5L2sUUm/JJMxf3klcA3
         K1G+EBqzWGkBvP5Tk0uJQjECzg4Zc+5xuYUWTr50rCj13HVbIyR93wlMYqyapzRheLMh
         BVsrvwapXbN1eqFvFJrRwHlt5xv13+MgLGx6f9mNng3Qb3GYwGynzy7HP928VhLzW5Wf
         wM8pvYTJta2EYC7D3qYsm0pqHEGH3+0lalCp3d9hMhHBOK4p24/RU7f5MPyz8sbBoCtt
         zsRA==
X-Gm-Message-State: AOAM531GYQLrX5JKLlOCaERuS8lsDo2gPJGyDXPMp2dXOY+Rzjma9jBf
        yVeh7TA796gf/8KXVDBz3EnfkB1JQKMWuw==
X-Google-Smtp-Source: ABdhPJz59A739PakvVxK1OwPsaGQU/EntQHq0iXhL0FMtd9hSFrYWJIhkae8vVOTmnd7PrdsapHRNQ==
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr9044162wrg.237.1616677946690;
        Thu, 25 Mar 2021 06:12:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 12/17] io_uring: better ref handling in poll_remove_one
Date:   Thu, 25 Mar 2021 13:08:01 +0000
Message-Id: <e174665e17b35c3ca8975b97b7a67110770a8901.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of io_put_req() to drop not a final ref, use req_ref_put(),
which is slimmer and will also check the invariant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 454381c19d25..a4c94dc7edc8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5212,7 +5212,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
-			io_put_req(req);
+			req_ref_put(req);
 			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
-- 
2.24.0

