Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CE0312867
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 00:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGXgu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 18:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGXgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 18:36:50 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC128C061756
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 15:36:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z6so15089010wrq.10
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 15:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S/mDO6WyuLYdb26GNXf5JDDyXhBvGZ7LOiBRQ8SZW2U=;
        b=bCYIKcS1lMawJhHTQxPTOVEXqZqxZLN+7CSzL5HfDdYKfkAcmP23MUnxOTlHnmEt9r
         TtxXbzmGJnZ5Hogf0gjiwIgFeZQ64FkhNg7ElzvDeMSypKTR5tX86qACc8GLxVUlVQ5/
         LB7clfYtogkiWkv+uZPyUNcmZWuYy9x0hwq+m9pOC3InRGbLmoTeaVzgXeMW5oEL1gEM
         3f/4RhrydSoI7UZj9quJ03efnfk0zse8I6R4T8Lnomo2VozFcWMJoAVOoU6z38d/u82N
         m3XOyN7609sE3mt+0rXu6K0IZPkAzcmt6BdrMLSwBQTvk9NuiSH5CXoDpWkNED0VhNkn
         yrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S/mDO6WyuLYdb26GNXf5JDDyXhBvGZ7LOiBRQ8SZW2U=;
        b=e6sHjJ88MMVRErPTu2s317e/Y6x4PvRQ6Sf+kSRkm5KC7Qamm2n3FM/Gfnb8Y+Tkn9
         ZoHpQsswjhwptQ2drxpEaCBFlOiOJnhy6hAC25VuIcWoL5Qogg9L+OXr+/Dzkg4C3XTb
         JmHeSutbE/5QQvrY1Xi27v8xGka/187Tt+P2Cnwle4jHTFCPzfAU8cqlGPtLowsF4cv0
         vA3y+Hab9yD1myjNhEWoVgA+vvnEIiwSWwRcB4GJeZleCQIxC7YBOr2IU3EjesLwbSK0
         Z8ghww0M4n7sViHnkUKxgso/Tve7K1+FnDfty9mxLrZca4Agh7tT4DgGq2dlvSc+uoDg
         Wblg==
X-Gm-Message-State: AOAM530/LS0IKGgZzNbcBCIPiY5FP6Ds2HTr0rM6W4c6yyLrFv9ncjgP
        GdtlFhInsTlFpkERoQP+FFEZcylJ3Wk=
X-Google-Smtp-Source: ABdhPJxu3A0lk3YglgpbAEfUUnDTv1YqzQ/XPhCRSa8lDWVlUTHMJ43qZeKCQI/ZXG/TtcyvIRGEKg==
X-Received: by 2002:a5d:51cf:: with SMTP id n15mr16556116wrv.303.1612740968416;
        Sun, 07 Feb 2021 15:36:08 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id l10sm25453380wro.4.2021.02.07.15.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:36:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/3] src/queue: don't wait for less than expected
Date:   Sun,  7 Feb 2021 23:32:15 +0000
Message-Id: <eb1de92f946deab354df626a8efff6b9c1a78844.1612740655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612740655.git.asml.silence@gmail.com>
References: <cover.1612740655.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_uring_peek_cqe() doesn't consume cqe it returns, no need to
decrease wait_nr because we check against the number in CQ as well as
the kernel do. One exception for that behaviour is IOPOLL, but that
kernel will return if there is anything in CQ, so will work just fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index 94f791e..dd1df2a 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -106,8 +106,6 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			}
 			cq_overflow_flush = true;
 		}
-		if (data->wait_nr && cqe)
-			data->wait_nr--;
 		if (data->wait_nr || cq_overflow_flush)
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
 		if (data->submit)
-- 
2.24.0

