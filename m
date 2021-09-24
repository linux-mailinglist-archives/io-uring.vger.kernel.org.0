Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAFF4178DA
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbhIXQhh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347667AbhIXQgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:36:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C05C06139D
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:48 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g8so38218653edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WEe9YLOck72XptbRIJFrThknsHIlAEWOCPXUcSnYZI0=;
        b=Wxi/NP1bgwiPC4MVow+uHJt1cV2HNsjUwhl3SrUFypY5W3Bqnyk1ROwn+/7VZcpcWK
         f+OosGtzRtpz93v/5Uxj9VAEmd01wKDw4k85tyQXP6h0tudtycAspJ5oAfyzXqZ9jKkn
         Y10s95r++HgT69XWxRFYMWAgAj4KddZDwXzIButY7rS5t7pWk2IVkGkYL1tLvjZD2uEX
         X1ZD456N142XzmsnGEA9h8QSvqmDC8A57xit7Ej8a23jGznfEw8ddqMDfefsLdrW8myb
         BiesYnWfqVkPUJwZKH31WzyFWAznpQdHEuoleZGdL9nIQhn+o+VJKtLP6tnANYUlMhoI
         Gi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WEe9YLOck72XptbRIJFrThknsHIlAEWOCPXUcSnYZI0=;
        b=U6LsrbtyOTAaK7MIH6wiDSfytwL8lpTeTZNOSZs3PYsYDftGHB86r/JcXYK7SmFuZl
         NKQKUxp3B03PkZd2a2IHg/0rStDwp9ls+/l1Xml01dxmXuhE3Dl9Ph6SaDGantUs+O4L
         kzQUvfPAh77Edm8bJ9m6S3sPBaJXbtTA0Gai9czkjyiPDKVWuYyvGh6uVuW2g/phsIfd
         YyZ9ldvcjG1murXKEo6yl2bHu/ATuml69+mQ9CQJRC4lKpgXn92X54oTLJ3xAJIaCzHO
         9Pk3oekb0wY2mDjWEwtVJDkFPcroWb+Lei6aceB80kYv8ww4DqdWGA/8roIhRaLBcgLJ
         sIgA==
X-Gm-Message-State: AOAM531QSHu5QEg7bSYtaayLB1GUVGJ3qTrbsP1dYZlprRIGV6We4CpI
        aqAtoCmbqeER1H8Ajai9eoQbdcWCbcU=
X-Google-Smtp-Source: ABdhPJz5k3STiFUkTmNmiuaNNHM0n90RC3d05Hyq619nzVeMNvdsEvDqqheIjSrTWayj24JsPpnKow==
X-Received: by 2002:aa7:d5c3:: with SMTP id d3mr5968957eds.151.1632501167463;
        Fri, 24 Sep 2021 09:32:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/23] io_uring: mark having different creds unlikely
Date:   Fri, 24 Sep 2021 17:31:39 +0100
Message-Id: <8787a4c6a3d96351806ed2af06e28a4a4fb0510c.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hint the compiler that it's not as likely to have creds different from
current attached to a request. The current code generation is far from
ideal, hopefully it can help to some compilers to remove duplicated jump
tables and so.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7888bb78cbf..8d0751fba1c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6629,7 +6629,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
+	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
 	switch (req->opcode) {
-- 
2.33.0

