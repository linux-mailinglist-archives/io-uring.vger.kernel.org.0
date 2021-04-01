Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C185935183C
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhDARoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhDARjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:20 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8A6C0045FD
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:30 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 12so1180057wmf.5
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=va+DMaUPpcC5b2FUdXa9GOf2WrafA7WZA1VBL0yavDQ=;
        b=f2Llp5dLDsve/VDOghEoor7NJBk26x74ANMTrYdnmSJzdYwdCEBq4w+rgNtw6fbcWW
         ShkoV/Tt62ROP2zJYstY9QKF6xh2WkFcV+UKlhSXz9ehoHWs31aLHuRbbCXzXv3Rp+25
         UtVEWtzGbWioSnlBjaebMgzaEf+IT4VdaNOPxNZOqlw3zuDq3aOZ4Ojv96IyWIjhQkeV
         AaIH2OOvM5UpZS7kIcxUYRx8iI6Gmym3SRKSrZUTbNinaDfWuFfKbVdhEprF13F2Nbf9
         AQnGrmlrTwlVhw67rx0UBXH9PMO4wpOYmBZcxJPjFcu+ZHoN07kyLU2Ht7O3t9lIvzpa
         Gbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=va+DMaUPpcC5b2FUdXa9GOf2WrafA7WZA1VBL0yavDQ=;
        b=glntX2NNwLcBCjAsK0bIhNzUnkq0gyyDbO/LZfPcXcQfeH5s4wIS/b+NeWEmCYpcZv
         tbxrlp9EYy/54D0Z5bt8oRvWcEcpRj9RH7zsvtu8mEaRD2bW5qY4MEDmBINktQlbV212
         g6rR9TUOtVnBgVTviwJINswg1oOf73I3QhSz8Mek+9ulBWrwvRVxtr0r6WMDA99z6IDd
         FxyLIgqvgMLzSfz/FOWFrSqKk57RSiauP0L7n3mzmVBy5jTn2gjB198UHdBZxQGQEbBU
         IS+tT7RoNhNfEUiRklTz93tRvNEXZ03cN0J/4hk2gRDELBtg0aAvVFAevFUdIJIXtyDe
         N9tA==
X-Gm-Message-State: AOAM530bsgs7W2TIxUqTaLgP8Yc/3D3br9SU331jQYDZnhiIKWn8GvBP
        Z5YqvUFA6oFAmYxAPEGsoSWMmjHBphgGiQ==
X-Google-Smtp-Source: ABdhPJy4ZEs3gtgMxBxPwBhLLGNJf1Q6x5zpk/sROAEIoNmse2UZDZmCDO5iEcY1L/MfDFbWfPfQOA==
X-Received: by 2002:a05:600c:214d:: with SMTP id v13mr8538480wml.162.1617288509445;
        Thu, 01 Apr 2021 07:48:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 12/26] io_uring: better ref handling in poll_remove_one
Date:   Thu,  1 Apr 2021 15:43:51 +0100
Message-Id: <85b5774ce13ae55cc2e705abdc8cbafe1212f1bd.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index 9ebdd288653f..bf3eeabda71d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5224,7 +5224,7 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req)
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll, true);
 		if (do_complete) {
-			io_put_req(req);
+			req_ref_put(req);
 			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
-- 
2.24.0

