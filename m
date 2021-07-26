Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645073D64DB
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhGZQJa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 12:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239945AbhGZQIJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 12:08:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44BC061368
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:47:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso20638956pjb.1
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Sf4Xafp+lX6vFFxFsIXBCIyw6FJyTnjlP/mUd36o/K0=;
        b=0PlG3RdOOy/yUhtxqsbeo3vl/cfy2RCdr8lggCznLjXpP/XrzMCpTZ7cAQHck212PH
         VfAZq4lOK7nS9G0FWxTqWnBmODcsGGxGHzDX8mf+U3P8AP4z2PWfm4f94CHUtqU919Eu
         yA8qKyuXNOwa9jPtuJLNA9QXhfjIMrMSR8WlbYiN5oKn8l1Q/3HsQpo6zxbOnyjw/erC
         XCVb4++lZl4EouCkf4bcXCxKrS2WkD91mvLTuSPZSojUuFUAPnGR0P4mjjasP4sG+K9t
         /Y3qlZ6gxsCMwfPRMwnx98stB0tTk3tF8s5NFdgszjFstDC/MYm3goUFQabUaXTdIPO9
         gCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Sf4Xafp+lX6vFFxFsIXBCIyw6FJyTnjlP/mUd36o/K0=;
        b=ZIp9ZhDnYOKYzc4e8wfjqU9H/HZvKzxJB2/vYbbbhdYg+9OKYyc4IW9fxAaG/pnZ3S
         5j05iuLcn5OAG67nsfaz/D2V+8o1RKDjV2ad/XVMoZLkjr5oTfHZ/WcLCCERJq+bJN+j
         fwNnIkZw2Z6T8mOzKZWiMSiV/aq3Or1dS72vYWwZ2qTnSm/UuOJtYk4f1UgT+RyTQYcD
         bpGUBBB2Xf30JMPomnteslqFXCpAPmyE4MSq6m8HVyrR1KzZsA9eF9A/asPlxJgmtj7u
         Kk8QKnNYh7hB/zKPPQ3v0H/7HDFxmiayZsE1hk9kF2WA7W7jCCdqyb0/qrU2rRjo1o29
         giKw==
X-Gm-Message-State: AOAM532d/u59wrdlq0AXKwIwaY2gGBEyRZ3WMrVVqxC4btSNt8FEzIO3
        j+rL/vbVzceKPxk3XNt7sRtCTTjzvWzapwo6
X-Google-Smtp-Source: ABdhPJwbVEfRcnmSLX3INDvcGbcCrPZhJnC7x8HMjhw/NUBBJDe/kLW6qhGcUu+6azidtGrhcOqE4w==
X-Received: by 2002:a17:902:8f95:b029:12b:7e4b:f191 with SMTP id z21-20020a1709028f95b029012b7e4bf191mr15314996plo.63.1627318067559;
        Mon, 26 Jul 2021 09:47:47 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id e2sm229942pgh.5.2021.07.26.09.47.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:47:47 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix race in unified task_work running
Message-ID: <aedc3a6f-4f92-b8b8-31ea-e6d7202a0b74@kernel.dk>
Date:   Mon, 26 Jul 2021 10:47:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use a bit to manage if we need to add the shared task_work, but
a list + lock for the pending work. Before aborting a current run
of the task_work we check if the list is empty, but we do so without
grabbing the lock that protects it. This can lead to races where
we think we have nothing left to run, where in practice we could be
racing with a task adding new work to the list. If we do hit that
race condition, we could be left with work items that need processing,
but the shared task_work is not active.

Ensure that we grab the lock before checking if the list is empty,
so we know if it's safe to exit the run or not.

Link: https://lore.kernel.org/io-uring/c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net/
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4d2b320cdd4..a4331deb0427 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1959,9 +1959,13 @@ static void tctx_task_work(struct callback_head *cb)
 			node = next;
 		}
 		if (wq_list_empty(&tctx->task_list)) {
+			spin_lock_irq(&tctx->task_lock);
 			clear_bit(0, &tctx->task_state);
-			if (wq_list_empty(&tctx->task_list))
+			if (wq_list_empty(&tctx->task_list)) {
+				spin_unlock_irq(&tctx->task_lock);
 				break;
+			}
+			spin_unlock_irq(&tctx->task_lock);
 			/* another tctx_task_work() is enqueued, yield */
 			if (test_and_set_bit(0, &tctx->task_state))
 				break;

-- 
Jens Axboe

