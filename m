Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13DB417CBF
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348512AbhIXVCs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348517AbhIXVCq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:46 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6361FC061764
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v10so36291173edj.10
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JDqEb9kaBQg5Y5XReUa0YuPupJZv1fslT+WK/niGJMQ=;
        b=Vg+FgKaS9U5WEK5jZiRvDUKnifYmnC6xpVdjf69E4bvrWFiluYZe0bbTXOUxpdSa5U
         dP+u75f6KgW1h1OLKx8NxA1+iqLI0QwmPfxx8g75x5ZX7VRVwVf7I063WoNwisoyabAN
         7jcGC5fH4YTq7wnmWkUTIHL8RjirQjpPJVLORgbEW+Euu/XwyCsjfA+joq3h/LRndXdT
         o0sWqcUmeoxUhRcI46ZiWuTpJ9lven7eYragA3GkRfyiCT1tTXbV4aTpapvz21sKG3YJ
         bXYuxlq4UtDwxnqAR5JyfyXtRzUbLgYMJ9xkEFd5xYu7UxxwkGTzYYjG1Fwuvxg2CYkM
         ai8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JDqEb9kaBQg5Y5XReUa0YuPupJZv1fslT+WK/niGJMQ=;
        b=0g8RPhXrLOen8TrVo9UaIzqZOkOGvoY2Oblcg+dnc5Hl3ZYLZ5kDKK4+cInCuZYZC0
         E3C9nshW/JmUAZ1dX0pESOT2+kKwA2dtt4iUebuyl7iojNM/cF8adtNTbccuJzZLJoBt
         +YE2TsoT/I1sd3pk5v2gR0VwKV3KLlVpKHsW2xlyqE9z9DGSrs9RCqmlQrcastwB53Zg
         bTGuj/w216YQqTj4cJYCWdCUxMyfsltyxmQkMUwVFwvviU9WzYMdx6s0UqvGjMvbw6Qa
         qrJke/f519HQmQUub+gNgGHjT4b25jMKt2ZpO/At/WvXsfyNM3W830VBxgXrv3j5nVl0
         xl2w==
X-Gm-Message-State: AOAM530h9bgiuthmlUKUNKPAYAFKoxPtuyIz/fSKuyWtRKBmyBVCH6Hh
        Ty627n0pmwFCZf6JRdlrtTI=
X-Google-Smtp-Source: ABdhPJyWz6Ggu6J+E1F9Tufa33/Jh4eeuAQK2fARgn33+4L8kNiJPzKMelxGnl4/gy0VTlqJWKpJog==
X-Received: by 2002:a17:907:2637:: with SMTP id aq23mr12905573ejc.367.1632517269927;
        Fri, 24 Sep 2021 14:01:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 24/24] io_uring: disable draining earlier
Date:   Fri, 24 Sep 2021 22:00:04 +0100
Message-Id: <d20b265f77bb4e8860b15b9987252c7c711dfcba.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clear ->drain_active in two more cases where we check for a need of
draining. It's not a bug, but still may lead to some extra requests
being punted to io-wq, and that may be not desirable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6bdf8e72123..c6a82c67a93d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6469,8 +6469,10 @@ static bool io_drain_req(struct io_kiocb *req)
 
 	seq = io_get_sequence(req);
 	/* Still a chance to pass the sequence check */
-	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
+	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
+		ctx->drain_active = false;
 		return false;
+	}
 
 	ret = io_req_prep_async(req);
 	if (ret)
@@ -6489,6 +6491,7 @@ static bool io_drain_req(struct io_kiocb *req)
 		spin_unlock(&ctx->completion_lock);
 		kfree(de);
 		io_queue_async_work(req, NULL);
+		ctx->drain_active = false;
 		return true;
 	}
 
-- 
2.33.0

