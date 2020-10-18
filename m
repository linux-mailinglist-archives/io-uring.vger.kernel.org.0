Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E54291695
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgJRJUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgJRJUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1A4C061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y12so8076946wrp.6
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hepcH/MgsK7ZU7bT5BAumLBMAiLpcITTWNu4guzUR3E=;
        b=YlTziiudQzOeH2tTgXckRUygK5vAgkUtNxZaKU+vemz1Qj33vSDMfBMbPd6kF1HTbd
         OE3vTSLd1O1wmZB+Rcfk90l5Sok9QftBDbvdekWaJ5RDLPn9bLHN9pwJa1DAZAjryK+c
         fKwC6CqG91RlhQc2qf1S3+TkaaHg3s9H/CjPDQ7PX/fj9/nI+lpz5W26gtweeekS1PZK
         cHPWdHJzREDAtgUCEb95HxFG2mV0u+B52l1hDXI9Ddp7p0r+XKhBPJdvB0YYorEIPGFo
         NYnQ2h6aGp8xQZc0tP5q24qjnyYDXRRD6lcgDwMK9uRGMm3nZ45CEl5Frou0PVN+QSCl
         bdEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hepcH/MgsK7ZU7bT5BAumLBMAiLpcITTWNu4guzUR3E=;
        b=FBQB5+k9NoH9Va5lqY+pVkLavH8rSEzGQ1bYOGP70BkUqdLBsd36LkoF/Vub/wW6ar
         grJ+9WmhKtRoy7/JgBPzBzCF6PdJpewnmEL0hr1n2bZHDS+tPTf7nHNGBzMsx5LrmIgk
         xiUY6jExTq/tfSU+oV9ZqSU9CQrq0AFArxOXu+voYJldhRG7XsuNk9Blt2oPfEyRfozL
         OW33zb0h/VahPk5xYdVn9HAxH44akJ/Xe2q5INsv73254jecLmZsIcD511l+2/DfhvsN
         gGbcHgCJupC+J4rqZIhp9BwAnVroFsjYyJWWLIVchhdH7hb+uNub32znhkgHZNWhZZOK
         IRYA==
X-Gm-Message-State: AOAM533v1b/W5eiILSzQoxSKeDaw/beDvoevTOq9gQLSXUjjWr+VGJn4
        v6XxQPO3uTHmj86kB4inU1RVP57X9LueSA==
X-Google-Smtp-Source: ABdhPJx1KGMEwVG2Dh8/cyJ+nQMtgTS+57BsHjA/E7nbEw/30Ny494NG89dDIOk6/Xrya17OHJbytw==
X-Received: by 2002:adf:e54b:: with SMTP id z11mr14737280wrm.128.1603012844357;
        Sun, 18 Oct 2020 02:20:44 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/7] io_uring: flags-based creds init in queue
Date:   Sun, 18 Oct 2020 10:17:37 +0100
Message-Id: <f242de86cf8715cc187d8cdc8079f951ef123113.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
References: <cover.1603011899.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use IO_WQ_WORK_CREDS to figure out if req has creds to be used.
Since recently it should rely only on flags, but not value of
work.creds.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5651b9d701e0..fd2fc72c312c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6184,7 +6184,8 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.identity->creds &&
+	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
+	    (req->work.flags & IO_WQ_WORK_CREDS) &&
 	    req->work.identity->creds != current_cred()) {
 		if (old_creds)
 			revert_creds(old_creds);
@@ -6192,7 +6193,6 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = NULL; /* restored original creds */
 		else
 			old_creds = override_creds(req->work.identity->creds);
-		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
 	ret = io_issue_sqe(req, true, cs);
-- 
2.24.0

