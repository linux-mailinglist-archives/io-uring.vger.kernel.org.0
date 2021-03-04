Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8632C9AB
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbhCDBJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355601AbhCDAcB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:32:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7B8C0613BD
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:16 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so15027648plg.13
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J21rFTDnZ61BoWogl/3/EAhlGup0mwLHVmamk1foxLs=;
        b=DooiPr15JJbNIKvUzzlE8xIVn6YmMlZKxXCLSPim4OCEfN5HzzMVsEZvRlkyniU4k0
         X2qPA+X0QHNkarnAWepbx7Bem9dl5w3kuLQvMUEIC9xMPhTb4ELM1EFUmesysVwXGNDv
         2Xm4oo4pJFv6ZxmoWoE5TNsumPGSNAZOdt1j0noY2T6wCXzvC7orr7gxGKrn1MqQJxYI
         UYPzdbns20lCg98GHbwcpZgDkYSsHdScqdz2IWfAqhT1LaTVoBB451g/IrprXibQYF4n
         nM+U9luPXo3UPGI3N9BvdODyAE5rfHdOdJ38zRZK+16Tc24kKd4uHH3Cab6dhFhheArT
         RRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J21rFTDnZ61BoWogl/3/EAhlGup0mwLHVmamk1foxLs=;
        b=VRWXe8t+BdP8L9v7sWSUqK6G8B/H8+Xdrkw7tkDF+qsdZnUGbxc/Zoezm4AXdlPvyW
         fj6bsk/He1q5N46XtzW+6330IOEn+ORsH51mwRtie39Pd0E8vl1e8YuS9APJhNdmaQ2j
         UtCSXsm7M6yXiYnsfLtH6rF+HuVqKUdtXNhObV4iMpMXVfHZZWiPKysDt+XfuVEmNriu
         pxjY9oMUZPOCCpTGXIfb8osqdrJl0CgguLHTr9MTPHiWnqkh6qDfmh/a8DzY0HGEqjdB
         Pv+ZjchfkBVoPl0F8IKl1Gz9nuSlLqqrDqxpov+yrd16UvRKmK2royT73LkNIhaI5vvZ
         +rBg==
X-Gm-Message-State: AOAM533EcZrUF029LGRI85Po2Iog8Bg6qRK7cr+xY1i5Ftd/MQ4dkMg5
        +iLRv0ZfxehBXw5FurDwOQ54k2QeTWPGmYXj
X-Google-Smtp-Source: ABdhPJwc5vIBQbsRENNGmMGIgG1lWzccUxC5MPFEc2gZdrEmYUl539K0KjZTjCRPOC/umWkYnVXQFg==
X-Received: by 2002:a17:90a:9f43:: with SMTP id q3mr1678126pjv.50.1614817636070;
        Wed, 03 Mar 2021 16:27:16 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/33] io_uring: don't use complete_all() on SQPOLL thread exit
Date:   Wed,  3 Mar 2021 17:26:36 -0700
Message-Id: <20210304002700.374417-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to reuse this completion, and a single complete should do just
fine. Ensure that we park ourselves first if requested, as that is what
lead to the initial deadlock in this area. If we've got someone attempting
to park us, then we can't proceed without having them finish first.

Fixes: 37d1e2e3642e ("io_uring: move SQPOLL thread io-wq forked worker")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d6696ff5748..904bf0fecc36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6783,10 +6783,13 @@ static int io_sq_thread(void *data)
 
 	io_run_task_work();
 
+	if (io_sq_thread_should_park(sqd))
+		io_sq_thread_parkme(sqd);
+
 	/*
 	 * Clear thread under lock so that concurrent parks work correctly
 	 */
-	complete_all(&sqd->completion);
+	complete(&sqd->completion);
 	mutex_lock(&sqd->lock);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-- 
2.30.1

