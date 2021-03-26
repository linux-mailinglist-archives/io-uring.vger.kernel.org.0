Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1F349E26
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCZAlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhCZAku (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7080C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:49 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h8so74827plt.7
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2AQtMuOB9bXRoDfBmDGIY9ygRNoX9J/CWoDuEf866/M=;
        b=avsmrllR7+0gfohzFsk6ASZHgl9TuqABTHAJ2V+eiz+DSys2Q/pzcvX/fVH2y6dK3A
         lN3baIPCSMVclURKqiGfnpVH1Htvcv+xWplzmoIIWYkRZft23OTfwQXl1wkDMy/rn8LR
         jBwAgavTqIx28ENWIWjSiZCcP9vYtEATf7Av3Qu+CkBTI+4KP9KMHs05Sqon7g3EPvQk
         iFUXt7P6QbCUPZTO2yUT/AaFdlI6P5IlNMCN72fXN8paDBIj2fBxYUwjTIgq6gcmhfZ8
         S6aIddhzcij1lZICm8yi4oOqoX+BnNIf2tAFez/DvFe2XhsXaa2QEw7IK/t0RJ4UHWKy
         y28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2AQtMuOB9bXRoDfBmDGIY9ygRNoX9J/CWoDuEf866/M=;
        b=jFNbsolF1QnVTowmSFUEoVDALvS6g3YyyUu3xj6ucxdmN1mmRirtGhSp5s0OrKafbZ
         e3pjsHGMx1rEjJcjN4jlsCFJoOrg7fAP+Occg1GTNjx1xQlE+dBtwWyf5HUwZpIaU5jd
         E5btoSz2wTIEfnp/KJTAEfphuiIzbE8lddtaw4rYCTtXk52Vuq6pVDzIsXvZsUHnpYie
         35i7uMPQgr5VfRyGNG/Rf9LkeaLmBmbh239V2zjYbJUbX+ASo8OIuCz6GFC84WuQUYgy
         t5FEnQw+YOt/j4dJMFX8mLGhzL3wHrntDS4PPCY+A9YiPg3fTYhqZepVqcL3D/onwZOU
         lOqQ==
X-Gm-Message-State: AOAM531/Yd9aXGOlPok8wDTzCul1x6pTc0i0TL7z8xxBs2IaKl3sStkB
        rSHCI5n8FRnAiXLvdkvHAb6jjfwXJpeKog==
X-Google-Smtp-Source: ABdhPJw/XAJZDo8dNbanulZB7f9qyCu/MAdrE3py6Z0A0yTMX4yf2f9Z7ImHOh3NqR6k9NYY2wqc0w==
X-Received: by 2002:a17:90a:1b08:: with SMTP id q8mr10734086pjq.203.1616719249055;
        Thu, 25 Mar 2021 17:40:49 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] Revert "signal: don't allow sending any signals to PF_IO_WORKER threads"
Date:   Thu, 25 Mar 2021 18:39:26 -0600
Message-Id: <20210326003928.978750-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 5be28c8f85ce99ed2d329d2ad8bdd18ea19473a5.

IO threads now take signals just fine, so there's no reason to limit them
specifically. Revert the change that prevented that from happening.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/signal.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f2a1b898da29..cb9acdfb32fa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -834,9 +834,6 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
-	/* PF_IO_WORKER threads don't take any signals */
-	if (t->flags & PF_IO_WORKER)
-		return -ESRCH;
 
 	if (!si_fromuser(info))
 		return 0;
-- 
2.31.0

