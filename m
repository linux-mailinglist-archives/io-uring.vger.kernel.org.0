Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486AF2961E5
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368794AbgJVPu0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368790AbgJVPuZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:50:25 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D6EC0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d78so2645236wmd.3
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tqM4wRMx5rUI5AKPCfAlzM7vXY5idNjIlYEzQ9Kidqw=;
        b=gsZXCozIzrU+KZiv+5frQ95n/GDwpcQ4BmOSHuDVYFdUTMZ+8hhi3Ss5qC0FkH7xh4
         Se2I6mhfTUHFDDtzoxvlNl/aHEnN5MsMCU6FgLUnb7HDUFCmsoWgkpFsM7YzG0l0E3sz
         /slCsLZi5q9/OlRqeb8ETO7JnOo3PyxQsf3uycbtmYKYPGt68WbPzbbcYGjuABl9y8rx
         QELmL+PjWunCvN4W3Ux7K0+D5Y1CBzf+cloBxg5pwM5yz9okoYPh1jBW51WWkvZc33+4
         pwoYnthMX+F5vqTyCyfEm4xmJEC43XikInm5fSn8u5kmPYYr5/BvWuSRXSIRCE2hi9Fa
         7aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tqM4wRMx5rUI5AKPCfAlzM7vXY5idNjIlYEzQ9Kidqw=;
        b=Q+oxK3Eb6oBrKIBWxZokUS9y8PDkJYuEl1RglpYWr7ONeu8ddSahULzrUmUuR0ChZ8
         +ZaaP8DEPmDI1+e6C066uB8X4tL+EC1t8d8Kb8De1y4xUFJy+jjXnZWU4oQ5jTtX8Nnr
         s4wBv0k9Wj9fLR6ziSeC/BLAZuejlHHIgzQ+/96fO7aEJupxVFpnKvcmQqNrspQ3e/Wl
         iCtD97/7zMBmxXwsC4sUm3PuQ3SHCgNCxEkTW6t28jNPPty6Q8fEN0Laqbok8GoY6D35
         +jucPYHI1EkoAvdDFqdvFR8lL9uobnqylwqke9Cu1GjQB16XmVBXQOw2KAzQ4xqKn0v5
         dUKA==
X-Gm-Message-State: AOAM533d2Lm1kreJ8kQV4NDbQ6EL6bmN5VenoZD/9YqC1qM5n5EOX447
        d71dY/oiz0pkT4GZHVOx7M5RvXX9wDD3CA==
X-Google-Smtp-Source: ABdhPJz3vGC67VZ+Ebd6wagrcEyLJu6LtzVRz7wcO7SiswYiNBzZ8P7y1eYynsvDz07rDOJQaxpUhA==
X-Received: by 2002:a1c:dc43:: with SMTP id t64mr3288519wmg.6.1603381823945;
        Thu, 22 Oct 2020 08:50:23 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id m12sm4448653wrs.92.2020.10.22.08.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:50:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: simplify __io_queue_sqe()
Date:   Thu, 22 Oct 2020 16:47:18 +0100
Message-Id: <7b6991fbca6c258af1092d8a04d45b4e7801e078.1603381526.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381526.git.asml.silence@gmail.com>
References: <cover.1603381526.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Restructure __io_queue_sqe() so it follows simple if/else if/else
control flow. It's more readable and removes extra goto/labels.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05b30212d9e6..754363ff3ad6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6182,7 +6182,6 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 {
 	struct io_kiocb *linked_timeout;
-	struct io_kiocb *nxt;
 	const struct cred *old_creds = NULL;
 	int ret;
 
@@ -6217,30 +6216,25 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
-		goto exit;
-	}
+	} else if (likely(!ret)) {
+		/* drop submission reference */
+		req = io_put_req_find_next(req);
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
 
-	if (unlikely(ret)) {
+		if (req) {
+			if (!(req->flags & REQ_F_FORCE_ASYNC))
+				goto again;
+			io_queue_async_work(req);
+		}
+	} else {
 		/* un-prep timeout, so it'll be killed as any other linked */
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 		req_set_fail_links(req);
 		io_put_req(req);
 		io_req_complete(req, ret);
-		goto exit;
 	}
 
-	/* drop submission reference */
-	nxt = io_put_req_find_next(req);
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
-
-	if (nxt) {
-		req = nxt;
-		if (!(req->flags & REQ_F_FORCE_ASYNC))
-			goto again;
-		io_queue_async_work(req);
-	}
-exit:
 	if (old_creds)
 		revert_creds(old_creds);
 }
-- 
2.24.0

