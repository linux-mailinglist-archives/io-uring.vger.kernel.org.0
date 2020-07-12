Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D5121C960
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 15:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgGLNS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 09:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgGLNS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 09:18:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D7CC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 06:18:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so11246750eje.1
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 06:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HXjah4L6pQjC1o6qIZ0wk9MClGhHKsTxarPhlF03AE=;
        b=p/yJsrNOrwy1Wgk1rzwRnowatdV/eGPhQ68twGPGT6+acQ1S11XjF3JGoPzavvjbrh
         tYL2Oe1DaCulkPSxexQC/clkD6S+FUoH95YDj47EHEdYRBjJW2PHCRcE9cexYlj6lmt5
         QPM94p8zBOPbKJx++KU+veeS233aDPDO7lXhAEsg50iNUmCWKVuPVJhwlNF6L+/K9rjQ
         pz0hzIHjSSxbHTaaftJlxgg5WK6WeEoy/jEEZAgf9k+8WkLuFPScj+wI2dVWoLQg5bBg
         H3VIXzFGDaAm2Q77u9BO4YyYTYefd/KBe9hOonvjpTRqB7kw1iqAQ3L61jgooEYAg3Mi
         7xUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HXjah4L6pQjC1o6qIZ0wk9MClGhHKsTxarPhlF03AE=;
        b=eStFP6421JmX79uc8KMZFcZDSG5sRmTOK7Uk5/PjjWtsE66ns0jNQAxlesKEANofM1
         rzfHovROdkLI9h3ymHOoH85blPflLRLp2d654CDB0bniv+gh+UMy9Y6jktqb37dV4BtZ
         JLhkeep2FSwy8D+4GZvMs3Phlozblvm7gmXjH8luaEJcGLWhBgClwWaGsA5M1RuaGg3u
         i7hma581Ih+ApqSFg2v091nWY7xjKozNjibV1lqrR8rbT94bNkkS3HeWPTXXcl3LacGX
         TlgBvmi4z8Fl7tCLuIz68PWCepf+9dlIpBJK3e4r+wYWJw+1hcVlsU8VBuFEhF7H32Wf
         LnJQ==
X-Gm-Message-State: AOAM530rX1jWAjyD/zcAq4iaHinWS0kqcjKz/wzENir0p0Is026emiym
        WpwO+4c/m9VBP9kFiBRiCRWbwklr
X-Google-Smtp-Source: ABdhPJz1M1to15Dxy1jCOi4HrofwZvWQ13iOc9/Hwp1mzj0w5jBAVEuWJYwI++rTYXtFPDah9DJBIA==
X-Received: by 2002:a17:906:a242:: with SMTP id bi2mr63846709ejb.243.1594559936227;
        Sun, 12 Jul 2020 06:18:56 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q7sm7575335eja.69.2020.07.12.06.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 06:18:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.8] io_uring: fix not initialised work->flags
Date:   Sun, 12 Jul 2020 16:16:47 +0300
Message-Id: <54dadfaba67a45d351ed9059547575214bc2458a.1594559782.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

59960b9deb535 ("io_uring: fix lazy work init") tried to fix missing
io_req_init_async(), but left out work.flags and hash. Do it earlier.

Fixes: 7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests completed inline")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

note: unfortenatuly, this creates a merge conflict.

 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9ce2e6f03dd..eba3e8645fd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1096,6 +1096,8 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
+	io_req_init_async(req);
+
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file)
 			io_wq_hash_work(&req->work, file_inode(req->file));
@@ -1104,7 +1106,6 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
-	io_req_init_async(req);
 	io_req_work_grab_env(req, def);
 
 	*link = io_prep_linked_timeout(req);
-- 
2.24.0

