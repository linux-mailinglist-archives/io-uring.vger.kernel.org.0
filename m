Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCC3E98EE
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhHKTlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhHKTlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:41:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897C3C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:59 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a5so4068493plh.5
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9pKnGPoSXDDRnwpR8vj3UAaoFsHt6x+OlwEp7/D9CE=;
        b=rVBixIBLmsRk6pPEH8FWXkifgYNsHqK2L/eeqKnSatbmdFN6Iwl7JU8V2ZlRS3m371
         RNTM5lg+Nr9dq8Y4WhZIIMi9WVd43Tvcd1GE5ofBqMrKI4ljjKJ5yYT095P29KaYQFaL
         qUDtXml9QRfNHt+b/C0TDrfI3cwUrmf4Sr0jVQdMPO2X2cYAhk3wrhH7TfAYmgtty1zc
         zBBcfjQ5GcQuT2I0hAc4iVDzWUZ1PeF3p3EUFMCHxAo6hVSGB2VOER5/ApH1PB/FkYlC
         pIYjLp6Fv65Mw117bj8qWmZXsB76lR873LYps4bCnrbRig8QXq4RLcgorpEyv/UOd3Ls
         EdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9pKnGPoSXDDRnwpR8vj3UAaoFsHt6x+OlwEp7/D9CE=;
        b=RKnulYO9zSzx7vdszD5qrdveANZlxKQDs7imBR7CbxD9+UZZeqLf6jJ9mVFldv45Im
         hRtR+Hj8JmZaWOocd9w49UusTPUmH7eewCLL4OlIGvLamg9ZXRHYxHlKBrTX/vGhjCyT
         0qHYL/Wqix3ps9jQlX6RIiPys1W+QPJt9xswFuNu60c7rBOuaM+EZ0wuOJvfN2lbV44A
         sjTJuzcml0aKUh0HcIpL1lSx7m/JkbI1LT7vV7e6eKCrSlm9NbPlM/zKCyXPoK3a/Kyx
         KrA5JQrGkxbog1I4InjDGbUd1Zk/MIIknI5wV3DuLHXLMkRlQs3F8J9iX7OBrcgMkYWy
         U56g==
X-Gm-Message-State: AOAM532+qNLJjFLbgNXgIC89uoSGGZdTankn5xBFbRnlWaaaZJ3IkKUN
        8LOrF1lqWGWHAxqXHza2kljAyggRNSbczDEt
X-Google-Smtp-Source: ABdhPJxelhll5XHA9l6eA48O1Mv2FaJ3RYVxOmYqgHZ2KuHMNqbMSqG4Jtfcpoy+k9C+xWJUTglRqQ==
X-Received: by 2002:a63:4e51:: with SMTP id o17mr350430pgl.126.1628710858899;
        Wed, 11 Aug 2021 12:40:58 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm336118pfe.146.2021.08.11.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:40:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: run regular file completions from task_work
Date:   Wed, 11 Aug 2021 13:40:52 -0600
Message-Id: <20210811194053.767588-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811194053.767588-1-axboe@kernel.dk>
References: <20210811194053.767588-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation to making the completion lock work outside of
hard/soft IRQ context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a5551cfdad2..d1dac7adbec6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2474,31 +2474,48 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 }
 #endif
 
-static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     unsigned int issue_flags)
+static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	int cflags = 0;
-
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 	if (res != req->result) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
-			return;
+			return true;
 		}
 		req_set_fail(req);
+		req->result = res;
 	}
+	return false;
+}
+
+static void io_req_task_complete(struct io_kiocb *req)
+{
+	int cflags = 0;
+
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_rw_kbuf(req);
-	__io_req_complete(req, issue_flags, res, cflags);
+	__io_req_complete(req, 0, req->result, cflags);
+}
+
+static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+			     unsigned int issue_flags)
+{
+	if (__io_complete_rw_common(req, res))
+		return;
+	io_req_task_complete(req);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	__io_complete_rw(req, res, res2, 0);
+	if (__io_complete_rw_common(req, res))
+		return;
+	req->result = res;
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
-- 
2.32.0

