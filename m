Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2055D4310FE
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 09:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhJRHHR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 03:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhJRHHR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 03:07:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FAFC06161C;
        Mon, 18 Oct 2021 00:05:06 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m20so14999601iol.4;
        Mon, 18 Oct 2021 00:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jXX2fvCmjdLfrYBH5s0iu5Hk0ygNOTdaxa2SFqxVg2o=;
        b=KwRUqOxq0BaLUI4zLOEo1NnfrM/jGSTl3YvpCpYuUJR7qlW5HB1/vSGExx8EXOKNyg
         t4Vqi+2FowA/fBESkiIm2RyKCnJSE4tFeCFmYDqAjCgCH2T7n2/voLU9lapGbijgMlk9
         rR/w+9B5pYujdbteQUJhCcc26X/SKO9RyLWJMt11djVlmx59QDQoZKhNrR59oF+8arcW
         1BBJzvWpvUlEMd0GOnHYpVyE7g9svRvluXVad+dZLSoUD1JtGf1kJJS1ArzlZJPw6INj
         +8nqw9hxLCGj1rye2xtA3JHklDGTvh7eSGv4G5KqRAd2/MgMaVz2IkxYBvcEnagBN9oB
         ezxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jXX2fvCmjdLfrYBH5s0iu5Hk0ygNOTdaxa2SFqxVg2o=;
        b=xkHXybl9MaC0U8NjE+RFdLDqeGXAmPo5nipJrU9maPo0hU3t3zaglWkyJyHbT7oVeG
         42a38ddCrcQWP9e8JkkLBsORI6J4w8WqPUwA3QgG4Tu/arF9a2rbeOVK34ZXJUPlKWgX
         tPQMj77AqXpr6QHvWIGa3+Jtl3mTZnZNLifpYEqD423GBLzVxHOum0D82huObWr7nvpO
         Lj56PnpFOUgxjkQvtIcMeJrRHrhcRkGw9BO3a9U4zSPxy10KlSmskMoMmITMvIGFGw0C
         Lawbau/S+au8RHWw11EunvoZsfZ4kS5HUWxCMwC7J9D1ndn+DJQz3ezZ81ksXfh1wi/N
         6IlA==
X-Gm-Message-State: AOAM533W9hxLM6/GNmke9VeMLG04eX30uQs1TzMXbcL0u5KnZE4vjcFP
        NftN0UtYdqDih3Mh3NtWSSo=
X-Google-Smtp-Source: ABdhPJxTFSBXKNvkHFBIftPsm1AnvyVbhWIRNBoda1E/eesEY/lLMI/Z8r0sUYtkQhFxLMVr4bpUWw==
X-Received: by 2002:a05:6602:2d85:: with SMTP id k5mr13266775iow.92.1634540705528;
        Mon, 18 Oct 2021 00:05:05 -0700 (PDT)
Received: from localhost.localdomain (node-17-161.flex.volo.net. [76.191.17.161])
        by smtp.googlemail.com with ESMTPSA id g3sm6782727ile.61.2021.10.18.00.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 00:05:05 -0700 (PDT)
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] fs/io_uring: Hoist ret2 == -EAGAIN check in tail of io_write
Date:   Mon, 18 Oct 2021 03:02:43 -0400
Message-Id: <20211018070242.20325-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit reorganizes the branches in the tail of io_write so that
the 'ret2 == -EAGAIN' check is not repeated and done first.

The previous version was duplicating the 'ret2 == -EAGAIN'. As well
'ret2 != -EAGAIN' gurantees the 'done:' path so it makes sense to
move that check to the front before the likely more expensive branches
which require memory derefences.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
---
Generally I would want to rewrite this as:
```
if (ret2 != -EAGAIN
    || (req->flags & REQ_F_NOWAIT)
    || (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL)))
        kiocb_done(kiocb, ret2, issue_flags);
else {
    ...
```

But the style of the file seems to be to use gotos. If the above is
prefereable, let me know and I'll post a new version.    
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1e672e7a2d1..932fc84d70d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3648,12 +3648,15 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 		ret2 = -EAGAIN;
+
+	if (ret2 != -EAGAIN)
+		goto done;
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
-	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
+	if (req->flags & REQ_F_NOWAIT)
 		goto done;
-	if (!force_nonblock || ret2 != -EAGAIN) {
+	if (!force_nonblock) {
 		/* IOPOLL retry should happen for io-wq threads */
-		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
+		if (req->ctx->flags & IORING_SETUP_IOPOLL)
 			goto copy_iov;
 done:
 		kiocb_done(kiocb, ret2, issue_flags);
-- 
2.29.2

