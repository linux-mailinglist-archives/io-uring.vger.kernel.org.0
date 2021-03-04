Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C35A32D4D0
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbhCDOEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237583AbhCDOER (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E63C061761
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:36 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h98so27744728wrh.11
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nwFt3bEY7CR79i67G8c499ytIqZvxFdqr8Fzfscpxt0=;
        b=OXxYvpH6qKsccY4+c3mIhHKPck8gtjekr0iacvem0jry3BZSPMdBXY020ZRzGkHgUx
         tYOvKkl71B0J8xGX/3yH2CEyBonEytvn5AQ1lIfm1kM1m7oex5o8C+A7OYC3erxaU7c9
         fywM1D3KmzlJumdMNjTvXDQqIC5pJMYaasJpNV/Jk6FNkzrk/tdxf6bRwzBsd3skzzK7
         y667hkX0hVWvk9rkvNI8X2WoEP0vXRf6vWLrG0DU03OGI/sXd5tAp8pYQI0QWg5FgbHD
         fvCqmDQBuaaRbRQYxR+VQSFMj9dDuRDDO3reade6OkCKRg0AMw+0I19oymek4cNVfx8Z
         Hgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwFt3bEY7CR79i67G8c499ytIqZvxFdqr8Fzfscpxt0=;
        b=Xg6xFb3EA7revZmy8+WX6qcOrHCnHn0DDmdf/P9lnqB/bAGDTYQ/Q1NdvcUu/uGab5
         oT0pIBAc5UCjtfxWOv5+YH6XB0a0V9OfJ42VP/auWJpazwsE5PZVZwqYLRYCGUDy7BUf
         G3N9PfB2PrABQGoT37+yQ4VBCn7EJMfj/kSQySbRvnutIB7P6bL62rvJaNKZ+rv3JKYq
         OR4tFlh5aVra8cRxlaRgwI4kHnCPSfKDugMnGotOorPtsS/w+8oYF5wYAkHUyc8fYLse
         f6/l315e1RLgeo28qE12sZfk1ZwIHEXJzBiuFziKKWy8+jzvMdQASuQrYF+iF92OeX7w
         Yckg==
X-Gm-Message-State: AOAM5300gkc1N45TZ00oMkV7n+OZq8Eu67yl70tjTsZGAI3AThF41j/G
        SFqOVz/sHFLN4ctwYThHNAA=
X-Google-Smtp-Source: ABdhPJz7K5aIksl5WwO3hlmwruo1HY4EzX+GfVsuOexzZVmiiYyC8Lm90XNrJlef2VIc4gH+qI8AZw==
X-Received: by 2002:adf:f148:: with SMTP id y8mr4079998wro.107.1614866615386;
        Thu, 04 Mar 2021 06:03:35 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: cancel-match based on flags
Date:   Thu,  4 Mar 2021 13:59:24 +0000
Message-Id: <4157ce297803d38e560cbb257cc6dbf81e2d530c.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of going into request internals, like checking req->file->f_op,
do match them based on REQ_F_INFLIGHT, it's set only when we want it to
be reliably cancelled.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7cf8d4a99d91..c340d7ba40a2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -703,7 +703,7 @@ enum {
 
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
-	/* on inflight list */
+	/* on inflight list, should be cancelled and waited on exit reliably */
 	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
@@ -1069,7 +1069,7 @@ static bool io_match_task(struct io_kiocb *head,
 		return true;
 
 	io_for_each_link(req, head) {
-		if (req->file && req->file->f_op == &io_uring_fops)
+		if (req->flags & REQ_F_INFLIGHT)
 			return true;
 		if (req->task->files == files)
 			return true;
-- 
2.24.0

