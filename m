Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15A14178F2
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbhIXQib (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344137AbhIXQiR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:38:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A73C06124A
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y12so2085401edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=un+JsE+3YjqCTlaWNCZblNOx7kN2LhaUcco1SMqPAE8=;
        b=G74AnOR0ReTWVE6NQTxSybx9/tOLqxXjG+V2SacvjQaOQ8K7+hH9RhRNNn2HC0TV6l
         8GjsDIW7Q+kYTy86Bu1YqVqVRgWF+3Hqh8OQ3lIsm1b7mcCittxlLYG4RVoPWml3NhrJ
         pMSFqg/S61KWjl9OTkmjI05sHFHqs7WHQJ1w9mAbjfySsfEnkhRuFFtVn+U9DUPC5cTa
         4mRqfoB3raYsEcXw62kdrcezbArGKfT4rbRsrTDDxBJvK0ce14C4qiZadiKGlK+6MpAD
         zGCfGRCxp7aw+FxFuMzrEW6dwkMGYrFlK+60V3p4VxFg4L3K3vi5/Dtd/Ti397yAs03Q
         WkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=un+JsE+3YjqCTlaWNCZblNOx7kN2LhaUcco1SMqPAE8=;
        b=BbmsKv6+V9Et2dh2eGQxZbIHPSb2LR9UQeSTM7K+wYw74gkp4PHYAHCS/SJxNAeoZX
         3XEIAmY9Zv7rnKyBk3dom0T0ZSx5Qf146/MQnqIHjFvRVzi64P9ESOcQMkp+d+2Fij0Q
         Qm6LPmzISDDXsNsDZMFBFi4kTVhFBLHEKvGpt5Ufpq8c+9yt1Tn1i1jFYvh6JHcojtGx
         d96lRSW9Ysy/jXtJcbsddGqZqjU8/vg2yJ7MQQ2hOkcKLMSqS0YyklhDxrUa5xMQORQn
         zK3iJPggTbdUGtdNhShbYR7ZKpfzzMC5idehba9keDEyLM+0StF6mMCtG+j2SL6nZR7V
         gVJw==
X-Gm-Message-State: AOAM5332yjGQ2/neB1/ZwRJ9Oa5kWLgC2QISHLttLk7uXFgwxVX5zyvc
        eeYrl34A/wW8U8ZG+sOpM8QXsDdiFl0=
X-Google-Smtp-Source: ABdhPJzO1VeNWEKLodACjAZyGErQCoEQz0pkSBcJ40KS/8tziRNXIZFbNbtpJ4R2orMss3cZjAxowg==
X-Received: by 2002:a17:906:2f10:: with SMTP id v16mr12424302eji.434.1632501187505;
        Fri, 24 Sep 2021 09:33:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 23/23] io_uring: comment why inline complete calls io_clean_op()
Date:   Fri, 24 Sep 2021 17:32:01 +0100
Message-Id: <354b92ad6a3ff7774bccded71f3e60c1595bd1e5.1632500265.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_complete_state() calls io_clean_op() and it may be not entirely
obvious, leave a comment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c53e0f48dc69..5d19016f663d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1824,6 +1824,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 {
 	struct io_submit_state *state;
 
+	/* clean per-opcode space, because req->compl is aliased with it */
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
 	req->result = res;
-- 
2.33.0

