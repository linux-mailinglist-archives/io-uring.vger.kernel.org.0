Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53562290916
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409138AbgJPQCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410466AbgJPQCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6EBC0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so1616849pjb.5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q8Pab9WPQ1DRhWoD0EuOIcurtDTCRLUPCk31gU+x4qo=;
        b=CW7sfYLBjR7i8a5RpGePsBbJuTFLNCYsAwU/6tdki/RxnDqiqlkWclAxvWXAIZYLy9
         MVBu5cmXrk2NY+bvykFPhKl8tGt25u5xC1VYYLpxnt+VPE/I6JjGLyTO9ZPIeTByD15k
         3WBNje7f7BR0a5/Q70hg0HFTTNgjxZBYb+kgijeOzajr0oXrg7hkuPbjws3PC3VCUYp+
         D4i5rEN0os38fqhHN7DXUOYjHpYzUOf0hXV/+aHM2Gj56a2jpK5xZYWB8/l1LFKF/z1r
         Wjex7Yd6BWiHayauowBJDtnfpW0SfYxmFy9jnsskoi/XZaDZ1AAfcDaUpw5SzAGeOCYK
         RnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q8Pab9WPQ1DRhWoD0EuOIcurtDTCRLUPCk31gU+x4qo=;
        b=rbcimc1ZkIhemwmrtt50hxBYt0FaKHx6WdzbbS9vWh7hHTlcVvlcVNAJQZdamgZJyk
         U3Num6IqeMmnOk+odItIsHqg+88eI4safUXtPB5wMQRXKfD2rsAWrqX/vWgD52+Sk0mh
         zG3kd5jnAm4LvcQNc24AtyHBgEO1bCCNodPPX2w+Iwfl2yRVoEX5Zor9T0cd1smqDQzl
         w/FxgoFqkFpbo9yWGeek3tROyoCZVZ4PC6nwelMEX6y6oM4SQRgqULCp1pYLE5H/64xO
         ckE3ANtVYlIbkVHzTLCDAWdiZdJKQV1tJe+efeqgRxW2lBoO5oHOLTO+f5/vsgdFU9wl
         ZE0w==
X-Gm-Message-State: AOAM530l12xru3TrH3LNhro8xuGZFq5z2jK1wVfzyXAohnhWN/kgWdGu
        A6Z4HUAXfM98Dg4mcXZTh6O2pGNzbrU0Oi+z
X-Google-Smtp-Source: ABdhPJzczvqzGmmHT68gwRCSlNLoqvEiGB8MWFJif40BRMetX3XJEDtHTu4lVRcluGjzuLCsRh77BA==
X-Received: by 2002:a17:90b:350a:: with SMTP id ls10mr4960660pjb.117.1602864153249;
        Fri, 16 Oct 2020 09:02:33 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/18] io_uring: don't set COMP_LOCKED if won't put
Date:   Fri, 16 Oct 2020 10:02:10 -0600
Message-Id: <20201016160224.1575329-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

__io_kill_linked_timeout() sets REQ_F_COMP_LOCKED for a linked timeout
even if it can't cancel it, e.g. it's already running. It not only races
with io_link_timeout_fn() for ->flags field, but also leaves the flag
set and so io_link_timeout_fn() may find it and decide that it holds the
lock. Hopefully, the second problem is potential.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b780d37b686..c95e6d62b00b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1769,6 +1769,7 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
+		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
@@ -1791,7 +1792,6 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 		return false;
 
 	list_del_init(&link->link_list);
-	link->flags |= REQ_F_COMP_LOCKED;
 	wake_ev = io_link_cancel_timeout(link);
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
-- 
2.28.0

