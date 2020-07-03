Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EB2213FCE
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgGCTRH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTRH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:17:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5790C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:17:06 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so35354989ejc.3
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EpP0j+IKaFN+/2k/d95m4TP8TDYLgokhMFlDnjQRKRQ=;
        b=by8N9ugLS487CrzT/a6O9n+Zjo4vx+alrHW8Fl7yeZORga7lDWkWSds5MfwREKujET
         m8ccWbrcXP0/0KTyTOMys7KGJ4wjJ+/JMxEoiFQo5mjF9CE0g7XsZ4yLUHbAwJDGh6iX
         MG4EOUmyAzAZ/gD8/Z1s5vDYk0+4t0T/SaUL/a/Wc9nbZ5HREbPEaB1sqNJV3xC/f6dm
         8QZePnaHOm4uIPwpg86HZOAuPqIsd0mX/e0yNjNeDBrDCkWKr9ZZBytjmEXP1Kf8RfAa
         1h4FMFfkdebundImQbM+XxF7LRppIDBQTH499PMhUrGyYeSQzgr+1/pY+5+93WMA1uI2
         ujXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EpP0j+IKaFN+/2k/d95m4TP8TDYLgokhMFlDnjQRKRQ=;
        b=GaIdVsq8ST2aGJxGa5L6AORcJHgLltr/KbYkwsR67EW6CsOQzEnuxFEza1LEBDA3qv
         vJG7NEu/9pudd8igQRlgYa6No5Wh8J+wqyR80ALViowZUNw2tb+mQ9CC3pjgJNLQN+vc
         6Yze5n278OYb+MXAtawGXFLHKqxPMixcdPsXSBFEal7+CFeR0jazvwhYn0xaoCS2w0sv
         kU+TYyrVu0vA3WQuVXCk83MY61WO3VPB8rIZJr5Z+NzkimmeYU34e7ehNv3hAzW4cUsB
         /FTpFmJhAyJV+592ypX+hPhcidTAr8YeICVG771Vd8kU7ZkS6jewLEMucpuXWZX7RrjI
         qnbA==
X-Gm-Message-State: AOAM532q7LEGrzRm5fX9PpkhbMgLkfECoDq3HtHRfKT2kSeuiJnQDUJD
        BrN2LCQv8tgjCCibTg8cbNU=
X-Google-Smtp-Source: ABdhPJyTuOSkkC+fDLwADiwuRpCglJG2ciXwGFbobSUBHqu/7A4XkW9cxYLPQzr/p2x1+EAGqKCp8g==
X-Received: by 2002:a17:906:5657:: with SMTP id v23mr34685276ejr.196.1593803825512;
        Fri, 03 Jul 2020 12:17:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id p9sm9907883ejd.50.2020.07.03.12.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 12:17:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: keep queue_sqe()'s fail path separately
Date:   Fri,  3 Jul 2020 22:15:07 +0300
Message-Id: <fb6d49f10b0e31d85be670dcde06dfd50face93c.1593803244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593803244.git.asml.silence@gmail.com>
References: <cover.1593803244.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A preparataion path, extracts error path into a separate block.
It looks saner then calling req_set_fail_links() after
io_put_req_find_next(), even though it have been working well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f0fed59122e8..d61d8bc0cfc0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5930,22 +5930,21 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		goto exit;
 	}
 
+	if (unlikely(ret)) {
 err:
-	/* drop submission reference */
-	nxt = io_put_req_find_next(req);
-
-	if (linked_timeout) {
-		if (!ret)
-			io_queue_linked_timeout(linked_timeout);
-		else
-			io_put_req(linked_timeout);
-	}
-
-	/* and drop final reference, if we failed */
-	if (ret) {
+		/* un-prep timeout, so it'll be killed as any other linked */
+		req->flags &= ~REQ_F_LINK_TIMEOUT;
 		req_set_fail_links(req);
+		io_put_req(req);
 		io_req_complete(req, ret);
+		goto exit;
 	}
+
+	/* drop submission reference */
+	nxt = io_put_req_find_next(req);
+	if (linked_timeout)
+		io_queue_linked_timeout(linked_timeout);
+
 	if (nxt) {
 		req = nxt;
 
-- 
2.24.0

