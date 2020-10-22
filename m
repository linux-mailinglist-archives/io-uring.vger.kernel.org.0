Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91812961E4
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368793AbgJVPuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368790AbgJVPuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:50:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8E1C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e17so3031714wru.12
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1pbz/Rmh32Yi4ImYC3nVa6jgWzpPzvn0SrSCW/LUwIw=;
        b=E/xA88dNQq3Tdxk9Yd4SsmPby+t6ZOsXTHpwc0+0VsCH8LkLU9IEiGKFyhiLfowmDs
         injcN2epfyB4+7Xxxvx2CuwgOeX/M8B/n3GUwW8ID5N2F2fjRHTJYbEjm8HEbORPZNPn
         /KKai6GkP1JTDhpLgyw8Lp1thQg661euWcWAvoQj1VQzPB4P7ufa+ktlC+7owYJqoDQH
         bogACa434lNzLNyLIYNx7ZDh6zmSrUf6PmPuhJmCoYJ65PXaQ4RwjvlSOoTRpW95+b3+
         LmZZGyJ3YgySR66eS6/oZmnAjN+EuF7TUs3Oq1MaAnJNODZsb0AqhZ/eECO9tprJJsm4
         Wh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1pbz/Rmh32Yi4ImYC3nVa6jgWzpPzvn0SrSCW/LUwIw=;
        b=dpdL3XikFbVtOhP+IaSd68WRJyuUT6C726duUkz4/2dwHnQK1yKv6M66bGCBHejWZs
         dY08RwLb5ArseGaHu//7Tl/30L4REkevYKxHhLuwLTZy336YVDXWCkftz56krmHxOT95
         NJ1gO1vMCFXEfFtLtaZINJj6t3VmyiBJD4npYfOOHq+rHLGh25YHtVMAfzE0lSKdfrST
         AD49X3TY39ZOLczgRy686+dITJ3JWtvSqt3IDRHz3Zp3DpjFrOUg7+OLrpX6w+bwakTr
         JwRPIYXe2Ox+0nos+cEDrWOpxB6/MfkaGurVRxaPP/0lM30KxCTa0VvZnQoKdmiUK7EV
         q+XQ==
X-Gm-Message-State: AOAM532qpeV7TDABXYaYl0C9Oeb29CQQpHRqsAyN7TkF6zZHdbMmNagu
        Jvvq/XzmZKbXHNthggZYOrXHQC/zeL3RmA==
X-Google-Smtp-Source: ABdhPJyTh9wvrA0+GgTwQwkY8SFuFvuda+s3kIn0MjnGKJEps78T2nR3KR4AnKDEyOSQBMNid+W2HA==
X-Received: by 2002:a5d:4b49:: with SMTP id w9mr3635786wrs.41.1603381823148;
        Thu, 22 Oct 2020 08:50:23 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id m12sm4448653wrs.92.2020.10.22.08.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:50:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: simplify nxt propagation in io_queue_sqe
Date:   Thu, 22 Oct 2020 16:47:17 +0100
Message-Id: <1dffbb4d59e8234254cd26c7f55f8bc3c859772b.1603381526.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381526.git.asml.silence@gmail.com>
References: <cover.1603381526.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't overuse goto's, complex control flow doesn't make compilers happy
and makes code harder to read.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9aeaa6f4a593..05b30212d9e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6208,7 +6208,6 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	 */
 	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		if (!io_arm_poll_handler(req)) {
-punt:
 			/*
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
@@ -6237,12 +6236,9 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 
 	if (nxt) {
 		req = nxt;
-
-		if (req->flags & REQ_F_FORCE_ASYNC) {
-			linked_timeout = NULL;
-			goto punt;
-		}
-		goto again;
+		if (!(req->flags & REQ_F_FORCE_ASYNC))
+			goto again;
+		io_queue_async_work(req);
 	}
 exit:
 	if (old_creds)
-- 
2.24.0

