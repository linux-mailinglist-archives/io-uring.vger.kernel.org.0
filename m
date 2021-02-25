Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19AEF325025
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 14:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBYNGm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 08:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhBYNGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 08:06:41 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBDAC061574
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 05:06:01 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o16so4779377wmh.0
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 05:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fq11R57tYgCfLf2/wPG44oHwSmp/rJmFpKQvDroXR8c=;
        b=nWhy6xcvn9XVTveVPQT8rjHB24mxIsLkvnBvQvlc6qrbaUlpqOEPAlBaUi0IZGekzL
         oryeqUjSvKLaeclqgEeDkr+7aBUv2IDbUnnMoHmrqHHUopYXQQTJneQGGSWdWNg9J0K4
         J8hZAjtRNqCL4/gyDgbREqnHq7kHBL3jCj2Vwk6jS6GZqpHwjUWfs8unlp0L3zD5EO96
         wDT3JmlDB3sJQR1qc9KTFUFcxM5Uh0eLBh3LMhWHAnB8vuRdsMwPL/xPQP2MN90mVSm2
         06iq3TDXpXO/nZ6iNQaXRb9DX4YfQePYdXkdduXjmbtevkhg7JA7XH685iPD1OOxVS0U
         22aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fq11R57tYgCfLf2/wPG44oHwSmp/rJmFpKQvDroXR8c=;
        b=PKZbfUI1VolK++9gsAWO/Wu+1hOD1JrHhBa3Sq8tY21D0i59sSLaRKCIEs6+hIMiPi
         t+krCjFiCFlYVqht/QX1t5iEkLbcVZBJKN90m2pdQ3wb0OD/GLK9fPBYOioAf+D1HVZY
         2TeEUkyeH6QSDxfbM4ZH/iTfFHYEMFI7K2OHQ5E67nFCALplNbQT4iq6F21UQCg52tpT
         mbJm7dYqExjhPxErKx+96OP3fLgoh9QRtB7Qp+CV0ZpbmwjxEqdfxKwBVtPKJM5TqXXI
         /KE+7qrS2R0MHBlbyuNpwKYKLA85QdJoP21G+ic0tqJG4Pv6By68r1S0Qky4DZ3TT1cv
         +9Dg==
X-Gm-Message-State: AOAM533+QFaUTyxoBoLdrfxSKRoMek5/MzXD+rTQ/fm6J9yYB6I1QB3K
        n8fGGVH5iwmPZJCDIfr/JfE=
X-Google-Smtp-Source: ABdhPJyjgD5mV1coglWcg36X/eVeFrKDWam/VesVoN2AyYUKIkuSWPk4wRWZfOEl+3QXz+WTUvIKWQ==
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr3193054wmy.120.1614258359908;
        Thu, 25 Feb 2021 05:05:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.28])
        by smtp.gmail.com with ESMTPSA id s2sm8729312wrt.33.2021.02.25.05.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:05:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     xiaoguang.wang@linux.alibaba.com, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: don't re-read iovecs in iopoll_complete
Date:   Thu, 25 Feb 2021 13:02:00 +0000
Message-Id: <3b8aa8f6cfcad71b8a633477932e34232ade68d8.1614257829.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Issuing a request for IO poll and doing actual IO polling might be done
from different syscalls, so userspace's iovec used during submission may
already be gone by the moment of reaping the request and doing reissue
with prep inside is not always safe.

Fail IO poll reissue with -EAGAIN for requests that would need to read
iovec from the userspace. The userspace have to check for it, so it's
fine.

Cc: <stable@vger.kernel.org> # 5.9+
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reported-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..561c29b20463 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2610,8 +2610,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		list_del(&req->inflight_entry);
 
 		if (READ_ONCE(req->result) == -EAGAIN) {
+			bool reissue = req->async_data ||
+				!io_op_defs[req->opcode].needs_async_data;
+
 			req->iopoll_completed = 0;
-			if (io_rw_reissue(req))
+			if (reissue && io_rw_reissue(req))
 				continue;
 		}
 
-- 
2.24.0

