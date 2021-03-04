Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDFC32C991
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbhCDBKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377138AbhCDAfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26579C0610E0
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:37 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z7so15044535plk.7
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hKyJL1p5U6a8GBPc3zymuRaeKCn2V/ojqFcL8O0vZL0=;
        b=fQm1FnMZlBCgU4dlav4vkOswOteoqyvN1RHJCcetVX9gQnDshBwT/t07wQyzvX8qUS
         CuvlH7on0StuOAadBbClQwbsXh1wcr5XjISMqYfrdRWziLedmM9lxezBe5YUKcvu0iqX
         fuHOVdc26KzXfos17XXy/o7rEySu6by+k+cBX7LBWHlIWOToLu7WsoTUv3eqQAl5N9OK
         h7L3TTo+NA52tz2S0WcWrWcm8cWVDnMe0CPRevAwPjzyzCRauV4jod/Nxehu27Y5UzMm
         FY6gfwPe1Xmbn9njyHOOfJiU2uX61orOE4Dk3ggqLNSscx1W/pwm5UYl1pSMIS7dlAXI
         cJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hKyJL1p5U6a8GBPc3zymuRaeKCn2V/ojqFcL8O0vZL0=;
        b=SZ+WVnabd3V6UxKJRgCFJMgZzuwLHPERxrqh5fm+Gaq5Hlz3NSxYRafxFr+c1DR1SJ
         1VY9iOb8iLF06fPlSPRyVn+NUTwV8sJpkzKABz1DILvB0r5CEhxBvdc64joZzmTYO4r1
         d1QApTNwCfMOaGvDGQtHxHQ+6yvMAAd41QOiN9lylVinfSQzAhaSAyTT3tfFb7ZFJ4F0
         yvTYZwJNCX+K/udvrbjrRJSNsr3X1favHEv8UIQFpYs8zLoUgh2qDOvp0sj9raHVjW0T
         8OrO6YxVQMQqAB9IewhsLcLngbP+eUfVvDljYJGgUYDF3JO6f0d5dQ5qaAkJkDl0cp1w
         m/Xg==
X-Gm-Message-State: AOAM533amGE6q4JFmrFmWCwl41dyL5T3LKd7lD7tUFaZHmfLo9k3OAuq
        lzioIpGqtHumF7SnzmZqwHGle19e+B7hVm7W
X-Google-Smtp-Source: ABdhPJwpssmOInsP6xw0iDNJhTer7OzsRfAe6iljhtaM+vJQq+aQMEfXhEgPYgFeBNy8lLFBkkCzGA==
X-Received: by 2002:a17:90a:9ea:: with SMTP id 97mr1684570pjo.84.1614817656462;
        Wed, 03 Mar 2021 16:27:36 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 26/33] io-wq: fix error path leak of buffered write hash map
Date:   Wed,  3 Mar 2021 17:26:53 -0700
Message-Id: <20210304002700.374417-27-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 'err' path should include the hash put, we already grabbed a reference
once we get that far.

Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 327e390bc0c2..1fdb2b621b51 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1047,8 +1047,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (!ret)
 		return wq;
 
-	io_wq_put_hash(data->hash);
 err:
+	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	for_each_node(node)
 		kfree(wq->wqes[node]);
-- 
2.30.1

