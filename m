Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49235343680
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVCDV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhCVCCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:50 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A14C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so8353220wmj.2
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SCiGhvWj7hQiOZTzQ+KAzJhunaarDo6bM2/Aa5ioI40=;
        b=vawCTcDcQQVKLZiBuaII+Bd+kjkOwiWlYiFJN8f3ECVS7z3wZ6DU5NIguviffxMqXM
         h7Je+uHK2+Yw47sh6YNAduIdPnagOd6aJYH4nUiLk8mM3h9w2isejSjmJwR2NZ4N/0Jw
         z/gprPvLz1RLiiEaW59xjipPvIK1h77sAFf26sClNP+w5/eZJnOJuLb3lya6PmAzGF+l
         cTQDXdYEV+cGdA3GHYbGwcwRKsglUcb3aRTV968vmLBQSUbqE/amCLS9kW1ULES4d5L7
         cdvWzZPRLOwFNqi5bL7gmu246OqrjVY7kweimLMfjDw98PyA1dj/n0t+DlLQ3TYOSjQO
         ewXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCiGhvWj7hQiOZTzQ+KAzJhunaarDo6bM2/Aa5ioI40=;
        b=DPCZcEmxzm7od+cDRK/q5Rzwa3VPpXkwdxCAVY8EfRAaa93HeVRYTs7uc1GZIhrDUR
         5BYapJRWebeGF3GR2wofjpCKe+lWthnRuh1Mc4r0gAc8n8aPp+pA4oVDMythLvubU0we
         cBR3eoAd1IW1vUivTZaoylwz6+Ou78xFD/P5yxaTFso9fLPFSRK6tIgxapjisHeogWSn
         Cizt/m//klIgXeaiL04jy8/AXj4MRPvItxGVSaZen6czNb2mLWcCqjfzGaBrN7x2DjP2
         EblHqGJ72jJq/67QTuARah7LOBIxf/2yKgZrBxbTvXfJgK3a2NE5UNvTn/eznq2KKvaj
         JROA==
X-Gm-Message-State: AOAM53127n2XsF9DQTFu7ThtjnjQXhdHuDPIbFM1KGrUkSuaqi0BATgB
        VT8V2xkS87UquQrtsOoY8ek=
X-Google-Smtp-Source: ABdhPJw0DdgEn4RXR/5GgAdbbBg4ztZdA57TqdXSulgQp6cxkZY/C3tyd2KMXPcw6TtFAtXfab0eoQ==
X-Received: by 2002:a1c:a958:: with SMTP id s85mr14091717wme.4.1616378568941;
        Sun, 21 Mar 2021 19:02:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/11] io_uring: optimise kiocb_end_write for !ISREG
Date:   Mon, 22 Mar 2021 01:58:31 +0000
Message-Id: <f810119cab851228fbf8644b5c325ad34a1ceafd.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

file_end_write() is only for regular files, so the function do a couple
of dereferences to get inode and check for it. However, we already have
REQ_F_ISREG at hand, just use it and inline file_end_write().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b666453bc479..c81f2db0fee5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2461,11 +2461,11 @@ static void kiocb_end_write(struct io_kiocb *req)
 	 * thread.
 	 */
 	if (req->flags & REQ_F_ISREG) {
-		struct inode *inode = file_inode(req->file);
+		struct super_block *sb = file_inode(req->file)->i_sb;
 
-		__sb_writers_acquired(inode->i_sb, SB_FREEZE_WRITE);
+		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
+		sb_end_write(sb);
 	}
-	file_end_write(req->file);
 }
 
 #ifdef CONFIG_BLOCK
-- 
2.24.0

