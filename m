Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAD28A3F0
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgJJWzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbgJJTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:04:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B641C08EBB2
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x7so5113472wrl.3
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=n4oUvCPLuuIu/xqFd+qmRFtDIDyqoEIvemsmP/FM6CA=;
        b=GOuT4W1MX0Moz9mugyqozHAC0vj54ElTsJC3nJtyfwuNS/jufQcdyCzApIoI5rVBR4
         2SjmkLaKZbWieGgylu+z0PZTZYiMQy1hbElTEsgTGp5g2cskD5RgRWkhk6gla4XmA+NB
         9urD64OlDPiitgIsC+8kKJbIu4YQZuHyHErfUbXSj5ACQKQ1m4gmr0zHIpZelU7E5mfq
         d1gILynNYxi5M2wWs+HYSgMm7BUdC+OJWYTSh7l7hNpzP2uRCZPeIIdcjXHWIM2gAVw6
         kWtRMqlbKGSltcgCsSyQ9dSLOoTNs8TntL9zgolpEyXMrlTNaibg0r/sM54zD5wda5Zk
         OEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n4oUvCPLuuIu/xqFd+qmRFtDIDyqoEIvemsmP/FM6CA=;
        b=VtKSWlJJMd9k5ExYVZbSs6laUCiUiXi3Y4r7ax62rUolPxjrDr5bD1l/yMsx2hnF4d
         JTbEPwbpFZictlQGwl04BiSdd+DoTTcSFYujwI7d1qb6RyDZGGZMq68OUg58r5WpNjmg
         KF4U+6h6vldZuxtYov8U0sw8OdpP/tgBDIb59yBwIm3YJ/iWnu4/H91gP8C4R8Ybjtnn
         apBhISoy1ENppz5zP29LOOT6gTL6BHJBdI6Cj2TdyXtVuwO/n7EmNW0qFJ0NaLv+ljZf
         JOgz8DFFeUZHI/IlQLCVoruzZiFDTHFq7TIkiHMZIemvBCpQcdUot5Y1U8VZ0yUviS4v
         +OEQ==
X-Gm-Message-State: AOAM532hA+yKb7TUn7Jiz678pInvX+cNPYS7ep6bargAB4vNPr82ZeCz
        /x0tGvXW4JqG5bSoSYDfQtA6UrV9J+Swjg==
X-Google-Smtp-Source: ABdhPJwuk/bCZbLW5421NLGy2Lh7VeWd7CZtJv1orBqoIOr6TiHLng0noG+AaumcMF+sZRgb/2v6oQ==
X-Received: by 2002:adf:a354:: with SMTP id d20mr4539028wrb.29.1602351440234;
        Sat, 10 Oct 2020 10:37:20 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/12] io_uring: don't delay io_init_req() error check
Date:   Sat, 10 Oct 2020 18:34:13 +0100
Message-Id: <98920d5293ac3ecb048442ae4cfe6f4dd732b3db.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't postpone io_init_req() error checks and do that right after
calling it. There is no control-flow statements or dependencies with
sqe/submitted accounting, so do those earlier, that makes the code flow
a bit more natural.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e0105c373ae..22d1fb9cc80f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6466,12 +6466,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 				submitted = -EAGAIN;
 			break;
 		}
-
-		err = io_init_req(ctx, req, sqe, &state);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
+		err = io_init_req(ctx, req, sqe, &state);
 		if (unlikely(err)) {
 fail_req:
 			io_put_req(req);
-- 
2.24.0

