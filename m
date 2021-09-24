Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD14178F0
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245667AbhIXQiY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbhIXQiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:38:02 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44429C0612AC
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eg28so38476180edb.1
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dwuHYoWiy5kr6udRWs6XQrftdmCbpgDwihakLCb03n4=;
        b=keyXHk/JgMhhVYzxFvUtMKPAlZck9BQnrwvUR3HrHU03vUby7g3ihi9jTDDrfv1fvD
         1arSKYnzdjbj2IXKjbi98SboCACzo3xIGIgPAe2Ny7/XNz0i9g/XbKbKMbyJPBeKlT28
         5oU+2B72k+gOxU0+O0G8Rb2HgyKkKed8hTbYTZE0YSGlnw/PLkuQtXJw2Hln5Sql/TOA
         AeLT276rxA5ta45qmPgb7+ldcOKFLdfRHak7W0++hltnYMSlQ8nl/kbN0zUTQdp9J1ft
         ZsxsK9Pk3YbFX9xl2zgJ8s+o6s1bZKcnkh4xtet0jDd3LgtlRwaLxJa6nzK/wkKDU6DY
         zwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dwuHYoWiy5kr6udRWs6XQrftdmCbpgDwihakLCb03n4=;
        b=1wLmCeyRgBTC2OjiRe/ncSKdMBjo2bcvc6Yyiy3yxtnjuNxyFbpYWoHzqnv4KcggIk
         bB38hIEe0WSxITaYYOTrLhm55G0fnopO/xrpooksF8ilQJYcl9DHbn+n9NwDZMWJm0fd
         OHKScnmbiFPKmQjYLeB7P6ZwEXRUJHgjgM7Qm8dnX5+hzBVpMrKC8zfJ25jLW2wymo7C
         7KQQuN+WWg5LvccuDq2Xs0ZOoq4uh4h8NzdHO7yGDo4qXToSqmH9rRerxvFHq4RZhbTQ
         4OT9SPQPHwaU4Rir50LEiki0wz1Wn6UTIrx8m7Vk6LT6xgbZmRAjtD0fLULiDe0sFdKS
         24YQ==
X-Gm-Message-State: AOAM533Z3W34sj0O4TpcnB6QPGOOLjHF2MJSFEyTjT8TqwAmbyl+FNi1
        36EJfxn3F4y9/COvmtqCC+EceBNWQ3I=
X-Google-Smtp-Source: ABdhPJybjRyYeP3vhQ57rsoXO/NYFSgvNuJ/Rz/ap2LBn9vVdBI00NVJoiKmh+UtmwkeShaDoaqbyQ==
X-Received: by 2002:a05:6402:c8b:: with SMTP id cm11mr6031579edb.368.1632501184901;
        Fri, 24 Sep 2021 09:33:04 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 20/23] io_uring: reshuffle queue_sqe completion handling
Date:   Fri, 24 Sep 2021 17:31:58 +0100
Message-Id: <69ebb7881aee83866f87e75a806061d87e8ae299.1632500265.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a request completed inline the result should only be zero, it's a
grave error otherwise. So, when we see REQ_F_COMPLETE_INLINE it's not
even necessary to check the return code, and the flag check can be moved
earlier.

It's one "if" less for inline completions, and same two checks for it
normally completing (ret == 0). Those are two cases we care about the
most.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 76838d18493f..7c91e194a43b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6917,14 +6917,13 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
+	if (req->flags & REQ_F_COMPLETE_INLINE)
+		return;
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		if (req->flags & REQ_F_COMPLETE_INLINE)
-			return;
-
 		linked_timeout = io_prep_linked_timeout(req);
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
-- 
2.33.0

