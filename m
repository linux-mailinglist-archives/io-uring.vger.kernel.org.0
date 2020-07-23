Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA322B57E
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgGWSOc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgGWSOb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 14:14:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882BAC0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:14:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o8so5789361wmh.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81phQ+/ZbvSnxXgc1bohAvgipWCDUO/ghvX8O6RisWQ=;
        b=j5t85reoznJo3LEC362oVcZWULipFBQTM+YNX3I2wsiZJUAUpO9mW69ghXOkbcPEBC
         YDc5MV0gBuF3k1ot4goke+lwSP1xOgDQLr04gbqZJYYtj7FEC20dD3Y1tXOVAkYmEspy
         +fMinhD94woaY4ycHpUUQJtSQylsNWRPuQgWTfoCXrWE5acSSFZbv3GZcHxsmyXC7RQH
         OsP79E58tSmsAKH56o1LgeqWFM/K63/owfWNxCzGjJzX3LH4+AvDdNvXPgjs2Zbvg5bO
         qpeXaKVfYOiYFRCX2R69sW15rZQ9UAc8Xlgh3zBGPbOrlpHL+hVd0IuQNkq1UJsT4gMs
         2K5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81phQ+/ZbvSnxXgc1bohAvgipWCDUO/ghvX8O6RisWQ=;
        b=lnNSQveab1Crp7lqIxiFb5elt/Wl/VSopPoHD6xxUNwL9QdAjFk0C63SPbPC32GleS
         jYBAca0ijrD6Ldutte29V8pshlUzl2QiusINCvylyOgfi113U3oUvkDC/fGv7QlnMm41
         ryvqiJvnVpeK/XX21/QJHG9wCTgUBUQ8yISfJMezPfHeYv9+of32pwAZd9ifR6oidQ6N
         TJw4x6z0yf3Szb46svqJV0s+aJHu3+fpDEfXQFkaEsm+8zdK6s2mCbr/tVdfG07IDuqk
         IuaRJiQdskeNcG+5pS4A/jqXBt7wi8y+crfP8ohzTMfAgLa+PIfyxK0BBMeNv23h25L7
         Vuuw==
X-Gm-Message-State: AOAM533bwmhAT4dy3RT1dvzcjGw7GABurvzSFod8dbctEysW66hiraQB
        mdBfw4rXPpfVwgprhruTwjzgQrCr
X-Google-Smtp-Source: ABdhPJylyyck0Hg3GM6OQJEw3PDytliHY1AWpc8wdcatcprJrkN79JsTH26yiunj5JROibUMdO+1tQ==
X-Received: by 2002:a1c:a757:: with SMTP id q84mr2902437wme.1.1595528070212;
        Thu, 23 Jul 2020 11:14:30 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 33sm5077714wri.16.2020.07.23.11.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 11:14:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC][BUG] io_uring: fix work corruption for poll_add
Date:   Thu, 23 Jul 2020 21:12:30 +0300
Message-Id: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll_add can have req->work initialised, which will be overwritten in
__io_arm_poll_handler() because of the union. Luckily, hash_node is
zeroed in the end, so the damage is limited to lost put for work.creds,
and probably corrupted work.list.

That's the easiest and really dirty fix, which rearranges members in the
union, arm_poll*() modifies and zeroes only work.files and work.mm,
which are never taken for poll add.
note: io_kiocb is exactly 4 cachelines now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32b0064f806e..58e6f7d938b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -669,12 +669,12 @@ struct io_kiocb {
 		 * restore the work, if needed.
 		 */
 		struct {
-			struct callback_head	task_work;
-			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
+			struct hlist_node	hash_node;
 		};
 		struct io_wq_work	work;
 	};
+	struct callback_head	task_work;
 };
 
 #define IO_PLUG_THRESHOLD		2
-- 
2.24.0

