Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C251F30F46A
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhBDN7d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbhBDN51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:27 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988E2C061786
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id g10so3636879wrx.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=F88b5mnDsyXtt4b8Q2NFp50PmGHfcr+0s001yB65DM8=;
        b=LxI6/OshR8oFTr9z33fBjtCtG/28SM8/+u/dVNQpNT1lZMg+idbxt59AYTqZLlWnfr
         vOd6tr8NrGPQZ7CbtFDm5FU/5KyLQfFX6amESy+eProAF5Ctz0JxVhQUpUhzeZhyhpaP
         NjbF2YpXklBL+W/plaOyTsgXP8lRyjWiq9Np2D8S0l0SJTwLjkn5LhOUiua+Kjrq90oV
         DchVkv4uglZqRKniwmTQudPD/YjTYfXnqC55aRbBtY7cE3rE7iLmvrMw4ausieoTeuwI
         7xf/Ivgf8AnjCWch8iZBU0R2Mcc7USFNdZI2yNYv4n33g0PePHnBpVOaYLroX5bXa5ld
         CtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F88b5mnDsyXtt4b8Q2NFp50PmGHfcr+0s001yB65DM8=;
        b=bv/OJC8Lkhg6sk847wqQ0BGv3WAt2qogKydXspgKh0RC0W0egE+TJ07y4dnayCqaDl
         JHcb6RSOxstYlyvFPOWveUxrHyoMKfS3mrrl6bL7q05QF2UsCgNvUkU03ucqTc/FxvM0
         fz1AHjrOn55d1sfm2RDR33k25y8UDSiKAJ38kYlsdXnd7YAZ4lGPLghyDO3liwGE0lej
         qXsStQg28S9PF6ZIpw8Irscqhy17sW+TcRT3dxpacfQEzUgrulOGT9D/eZwdqeV/ZIHV
         WxfYJJ2WQs3WhOyf7ZIr6m+rxPcLonAYvlTd2KcleaiZ+j+1x6hMsm8xcKj4+IAEEdhA
         xpzA==
X-Gm-Message-State: AOAM532n2yIe6CGQnvoH+8CEl2kl88BZh8kqTA4QIIx/wdmXEeV3TMbv
        DJTEI/2zEFBSNfe8Li0uB6o=
X-Google-Smtp-Source: ABdhPJz8JPHKNrsX/GGdrdNe4jNLJF8mLng3h1gScj8QBevvWrNz/TXgxwCN41IzQpJyPTp1kLiNyA==
X-Received: by 2002:a05:6000:1a8c:: with SMTP id f12mr9365234wry.173.1612446969426;
        Thu, 04 Feb 2021 05:56:09 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 09/13] io_uring: highlight read-retry loop
Date:   Thu,  4 Feb 2021 13:52:04 +0000
Message-Id: <18608b73f7f9810a974bf518c07afa4701fdfa17.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already have implicit do-while for read-retries but with goto in the
end. Convert it to an actual do-while, it highlights it so making a
bit more understandable and is cleaner in general.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 35ad889afaec..bbf8ea8370d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3566,27 +3566,27 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	rw = req->async_data;
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
-retry:
-	io_size -= ret;
-	rw->bytes_done += ret;
-	/* if we can retry, do so with the callbacks armed */
-	if (!io_rw_should_retry(req)) {
-		kiocb->ki_flags &= ~IOCB_WAITQ;
-		return -EAGAIN;
-	}
 
-	/*
-	 * Now retry read with the IOCB_WAITQ parts set in the iocb. If we
-	 * get -EIOCBQUEUED, then we'll get a notification when the desired
-	 * page gets unlocked. We can also get a partial read here, and if we
-	 * do, then just retry at the new offset.
-	 */
-	ret = io_iter_do_read(req, iter);
-	if (ret == -EIOCBQUEUED)
-		return 0;
-	/* we got some bytes, but not all. retry. */
-	if (ret > 0 && ret < io_size)
-		goto retry;
+	do {
+		io_size -= ret;
+		rw->bytes_done += ret;
+		/* if we can retry, do so with the callbacks armed */
+		if (!io_rw_should_retry(req)) {
+			kiocb->ki_flags &= ~IOCB_WAITQ;
+			return -EAGAIN;
+		}
+
+		/*
+		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
+		 * we get -EIOCBQUEUED, then we'll get a notification when the
+		 * desired page gets unlocked. We can also get a partial read
+		 * here, and if we do, then just retry at the new offset.
+		 */
+		ret = io_iter_do_read(req, iter);
+		if (ret == -EIOCBQUEUED)
+			return 0;
+		/* we got some bytes, but not all. retry. */
+	} while (ret > 0 && ret < io_size);
 done:
 	kiocb_done(kiocb, ret, cs);
 	return 0;
-- 
2.24.0

