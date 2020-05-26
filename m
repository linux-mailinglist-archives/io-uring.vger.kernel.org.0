Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FEF1E291B
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389324AbgEZRf4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389321AbgEZRfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:52 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB784C03E96D;
        Tue, 26 May 2020 10:35:51 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id be9so18354254edb.2;
        Tue, 26 May 2020 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L+yOKKVhdphHvfAHTFaUKuwnxuOPZ1y3kN0Tv2AL5fI=;
        b=S4y6aVlm2qpboGdMc7wzlBhZrjXiNyo1O6P7tQ8l2JfYqvKukQVrrJo1dc+H23cce7
         cUrVwc6zhTOAvE6bBE4EINA+VtlBjn4/uXZY4bggJHR988/oXWixGQB4kn7VJuYKrVwi
         l4KRaDA3vzi4F+jw9WVl+2B2fjrsXQPYIcqZyIJKaujmMK4Imn6/QKvUJjKHszyOvNs0
         ZrfwD/6OCM+tqSNSCHj9VhtgJz3fE90EIWOXyuyPanAMhzkJ8DQXQqcZirSpKy/me6XO
         eaKUN1sKJS3ioJXptQ4CILRJMZkljKAGCXozeqPXDYG3ltp19eNDGRS8H04JIiD/OwLE
         XDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+yOKKVhdphHvfAHTFaUKuwnxuOPZ1y3kN0Tv2AL5fI=;
        b=QGyPoYz/CzVTHtwz4C6yHhdrFp0lFf4+FWC2snqWxJcS1Dc23HG9XeUinzX64wcoqr
         qMrRwhzTmHUtg2U9K0kyrsioYGLvgVQCR8YeFvLEilcZ2OLYXGqqWFp44695wa7xMoQ3
         SKBO53mBxoTGwuRXixBiQIFAOxN61L0gYG0fljq5r8lnTudMuvfo/dqgws1iEm/BL2gm
         n5VfnaIGPaWBjvoGUNzBKOcO9XpFUiIGkhxio4RDag+Xw5Ya2s6/uFo5V8uUYJaR9lCu
         1LTE4UnrfeH7x25qCAsNIsGR2BxmfiC+ALeV+sFSaSvy1QgqbyaOiCW+zW2ByNpx2N+x
         /+xw==
X-Gm-Message-State: AOAM5327wPdUXrOV5fGGBt4XI6UUKI7LluqhhUTAQvx4VH2nR9fB6WIC
        ix3WUXn800/H75ZM9IdDyxA3HPE4
X-Google-Smtp-Source: ABdhPJyCoU/NW4gTj1feUYYjQWzLlGNK4c92vvMdxgtHOd9Bo+Z0OOlwtHQ5yZKick6YbgmiWCR2Rg==
X-Received: by 2002:a05:6402:3106:: with SMTP id dc6mr20861164edb.19.1590514550430;
        Tue, 26 May 2020 10:35:50 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] io_uring: let io_req_aux_free() handle fixed files
Date:   Tue, 26 May 2020 20:34:07 +0300
Message-Id: <3e06564a15ca706f5f71ed25e8e3f5ea1520117e.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
References: <cover.1590513806.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove duplicated code putting fixed files in io_free_req_many(),
__io_req_aux_free() does the same thing, let it handle them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac1aa25f4a55..a3dbd5f40391 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1413,10 +1413,6 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 		for (i = 0; i < rb->to_free; i++) {
 			struct io_kiocb *req = rb->reqs[i];
 
-			if (req->flags & REQ_F_FIXED_FILE) {
-				req->file = NULL;
-				percpu_ref_put(req->fixed_file_refs);
-			}
 			if (req->flags & REQ_F_INFLIGHT)
 				inflight++;
 			__io_req_aux_free(req);
-- 
2.24.0

