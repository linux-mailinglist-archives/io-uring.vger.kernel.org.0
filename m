Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E151D6CC1
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 22:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgEQUL0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgEQULZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 16:11:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6F0C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:11:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so3895964pjd.1
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l4DTQa572pZSUSR9rJtB72ATvKaKLS/PM301FRnKl9M=;
        b=mu57R0FE1d1zrxn6bnShzZ4RkzcphbTUUWzjbqeNXL0ZFAzn221ksFNMs28+ZjyE9Q
         pW5ZjIWMg8mUPSzu0ShTweDcFGGWvG8amYZs0oT+Eie/bNJvodrN/06bnWBpmaUOCmXe
         CQ7/xmTfEsS9EbOHsvGATSSvIdLN5jOMSGHQXvsfp/zpkrOBmbxVu55jAUm9/pXet5iT
         uo77qe++RvutqOw1GFwO3K5ArKQwYfGspH9nyEamGI3tJmT7xB1aTNB8UZLwuyyPH5sz
         qb6l5PM4tvO98n6upLYrd7xAVw6/0FtSahgSiJ/qmq+vudnJ51YDYTTy63JT3cvEFC7Z
         sQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=l4DTQa572pZSUSR9rJtB72ATvKaKLS/PM301FRnKl9M=;
        b=QICFfVhYj8mDrTa184GtymR6eCEhZtu9MPHBWERbeUvc54ddj4RTMxCxig5+Q9uFz8
         rI+k7s+msHA9eRvfbMYREy7HBHlzPfu4xewDs862ouNcQCF8r7+03rKRivKZqLdNw3cX
         qxOB4P94b0nXZrv/EForScIYa0nOGMuJCsNyhiZ9Z5Q2XMYlL0AF/HgnB+Hq8NJbTEvP
         EQUkqOWQicQaXbuSbC5M2DrasV7pUAxZbpVDGBR0d7Kr6XkQV+CgUCztq2NrJOmGyAOD
         ZWM+e41zm64U+miBCg5osc7e2+jTwJ9wS/pVfXBnVnQDQlYgSwT/svS9VomrOjCKstT/
         sjxw==
X-Gm-Message-State: AOAM530LmM1Y4Cx7zuHs7IeuC13nbfVJ+P6VfbcYJVIiB5PN1rw6hJRQ
        JDGGN4POEyIW45CF/ySJaWb7oDuXetE=
X-Google-Smtp-Source: ABdhPJx03yT9AEU1gVHehPq2s9E7s77QYq4ulCvobmvg6TK58/GkaAssHWaCFX9+6qWV7/aRtqq50Q==
X-Received: by 2002:a17:90a:fe83:: with SMTP id co3mr207424pjb.62.1589746283832;
        Sun, 17 May 2020 13:11:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id j124sm1257819pfd.116.2020.05.17.13.11.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 13:11:23 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: cleanup io_poll_remove_one() logic
Message-ID: <a8a19ba8-c2c3-7a42-e356-7a4da1774a19@kernel.dk>
Date:   Sun, 17 May 2020 14:11:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We only need apoll in the one section, do the juggling with the work
restoration there. This removes a special case further down as well.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

V2:
- Forgot a closing brace...
- hash_del() must be before work restore

 fs/io_uring.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 93883a46ffb4..617697140c78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4471,33 +4471,32 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 		do_complete = true;
 	}
 	spin_unlock(&poll->head->lock);
+	hash_del(&req->hash_node);
 	return do_complete;
 }
 
 static bool io_poll_remove_one(struct io_kiocb *req)
 {
-	struct async_poll *apoll = NULL;
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		io_poll_remove_double(req);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
-		apoll = req->apoll;
+		struct async_poll *apoll = req->apoll;
+
 		/* non-poll requests have submit ref still */
-		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
-		if (do_complete)
+		do_complete = __io_poll_remove_one(req, &apoll->poll);
+		if (do_complete) {
 			io_put_req(req);
-	}
-
-	hash_del(&req->hash_node);
-
-	if (do_complete && apoll) {
-		/*
-		 * restore ->work because we need to call io_req_work_drop_env.
-		 */
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
-		kfree(apoll);
+			/*
+			 * restore ->work because we will call
+			 * io_req_work_drop_env below when dropping the
+			 * final reference.
+			 */
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			kfree(apoll);
+		}
 	}
 
 	if (do_complete) {
-- 
2.26.2

-- 
Jens Axboe

