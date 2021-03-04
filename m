Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEFE32C99E
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241060AbhCDBKP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384445AbhCDAf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:27 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2408C0604C1
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w18so17536706pfu.9
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A9mctk7vfy6Rwt/N4ln0h15kGyERr1NTPZjL1l6LEEg=;
        b=K7D6BggF11FmzbQlwo22G8gyxo+ApWoLORYTlXjntwFdvHiFxtE8MAPvJabgyU5inI
         2u3pospVnUY3sPWUwzzoeNuILtn6Iw5Zo+u63cFPIHH6KaKd7UwSnrlTb0HVC988A3NE
         91FweCYNrM4lY01WXdIM/g7i+Nodykm7oflpLNWwH97GJfBo8tJQWUz9e0g7jhXvZZE2
         uJIsq9Z1so/LLPdgFD+bcF1ER3hSnTy9k3KXDNWChdeQlYNAoJdltfmYbaJRghn0WLiu
         71Wd5gM80MKNQDHF7540VCVZ1Zjst5fJUem++fXaRujV9MfPqsiu3h+vIun6tvazAe9e
         rw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A9mctk7vfy6Rwt/N4ln0h15kGyERr1NTPZjL1l6LEEg=;
        b=tmJKaE6VvK5OgYoZAJ3hNbeE+CdYRX8dX4zeEhnalW1fDhrxnJ91ZBWXGyBaovVFA5
         tRJhSXuHC/NfDTqYD6X6hkNc8Jxd6OsGx/e46rX52U8qGkUnPW53WI9VI0Yd7LSA92z2
         vMCj3hakjp/Q7xO32MoHaL5xMSoFunDSX5GIpQELw64ti0LFYk3aC8h3K8BNWCyfIkob
         dR6GVjaNDPTj9vKdhbUY+PETOd3jeK1Rh63ljKYfKInYMsosZWvGTeaiMbO2a05qirrH
         IpYsgBMhOtw+mTshxdkWSy0R9MXCw/a7W3amRytpfJGnzTfPO+y38DPnNvUsWOL9Pdfe
         m49A==
X-Gm-Message-State: AOAM530satq3pgOadyF4jA8AK8T4kyEHTkEOak0IcKIVBnMfWD1LKw7O
        RfojeeNtQk7guvSHiz+S+2buM5fd/7qBDAPc
X-Google-Smtp-Source: ABdhPJzpjZBPrFD5d6KsIBRWl+H0DhYlU9dkIxtGzu9DIAyDYTgLVgpnIBZL0pZqCMmJxDHHAlfuEQ==
X-Received: by 2002:a65:6493:: with SMTP id e19mr1281050pgv.239.1614817658998;
        Wed, 03 Mar 2021 16:27:38 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 28/33] io_uring: choose right tctx->io_wq for try cancel
Date:   Wed,  3 Mar 2021 17:26:55 -0700
Message-Id: <20210304002700.374417-29-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

When we cancel SQPOLL, @task in io_uring_try_cancel_requests() will
differ from current. Use the right tctx from passed in @task, and don't
forget that it can be NULL when the io_uring ctx exits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c765b7fba8a1..d5e546acae7d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8636,7 +8636,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct files_struct *files)
 {
 	struct io_task_cancel cancel = { .task = task, .files = files, };
-	struct io_uring_task *tctx = current->io_uring;
+	struct task_struct *tctx_task = task ?: current;
+	struct io_uring_task *tctx = tctx_task->io_uring;
 
 	while (1) {
 		enum io_wq_cancel cret;
-- 
2.30.1

