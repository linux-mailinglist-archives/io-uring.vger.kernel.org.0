Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF64305EB
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 03:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244775AbhJQBer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 21:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241259AbhJQBeq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 21:34:46 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA38C061765;
        Sat, 16 Oct 2021 18:32:38 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id m20so12154074iol.4;
        Sat, 16 Oct 2021 18:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rq7eJiJY5GizzeYQg7HyUDUwFZHc89rYqOhPQrMeQeE=;
        b=kimjJzbHxu0G4NEaBLJg8zkXM0H0T3NPqqamfR8nbRO7DSxbfPAE0HJsGJoha1T7yh
         0kB1JThMzIYv5mtsM5xOqVDJdBIdK0tCxx4rhgLC9ZaEy3CL9+D7BvTG262s8/j+HRci
         2bu1B+chNC0tiVw8GQy4X8WjDYNHu2SIIBUiVzr3oZ37NLUNGm6VC1Z0ZuagbRjrRQPh
         najpJaSSAk+Ry0+Huc+a1soJoNVdEYrh37vs0LiFzWU08fj6ugLUh8GDWtmWykeTUq8B
         OGplu/wzP9HH2GcCK0i6cX5HBmdpjp2810n7DiTT7xH7BLxrsS/6/OwRYRDnDEWFZWgv
         N55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rq7eJiJY5GizzeYQg7HyUDUwFZHc89rYqOhPQrMeQeE=;
        b=Ww1UTy6zXDo7YwuHTkiOmszpjdk3di820jc4nQTla9NHwnDQi8hlwbntDfYlRXy7WH
         eQcP/y4JODyFj62aYJmDFH10A7TQNsPnygqeyTGfjANSwS4WnJ3lKRbPAIKZ37QMhxOV
         yp1igJd6C92I2CrcCUv/yECdxt47CehEfHwxFvPnGX4d4qkTrQriJt7iRZUX4m5Xuiio
         1cWcpjHvkk8glZFl+/jt35STJKRhBTPd/vtHgiGkOOAdZ2PuXxkvZIrksFtx12rd/C1n
         3/6YRrc0fTRt3lIPrRQdJAp+GzxkYaPCYGKi8tJ/a1R7Akg6VLjup5Bw63k7doDKRNlZ
         TV0g==
X-Gm-Message-State: AOAM531t9HyCGreeFcCVfaFMpr2/FMZfy/x/0cdDwGh+pk6kt/7ugNVB
        feb5LhfuxDTrrwdG+q7yji0hpCtFPkQ=
X-Google-Smtp-Source: ABdhPJzFXupUUFg6YPvdcu+wlZeidOXVNm/8ugfr0+x4lmO6H2hd3vuxfC4gyTjRRAGVjvz0avOdGA==
X-Received: by 2002:a05:6638:a2d:: with SMTP id 13mr13028099jao.12.1634434357408;
        Sat, 16 Oct 2021 18:32:37 -0700 (PDT)
Received: from localhost.localdomain (mobile-130-126-255-38.near.illinois.edu. [130.126.255.38])
        by smtp.googlemail.com with ESMTPSA id m5sm5010533ild.45.2021.10.16.18.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 18:32:37 -0700 (PDT)
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] fs/io_uring: Prioritise checking faster conditions first in io_write
Date:   Sat, 16 Oct 2021 20:32:29 -0500
Message-Id: <20211017013229.4124279-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit reorders the conditions in a branch in io_write. The
reorder to check 'ret2 == -EAGAIN' first as checking
'(req->ctx->flags & IORING_SETUP_IOPOLL)' will likely be more
expensive due to 2x memory derefences.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b9e70208782..321de7ddf2cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3660,7 +3660,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
-		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
+		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto copy_iov;
 done:
 		kiocb_done(kiocb, ret2, issue_flags);
-- 
2.25.1

