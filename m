Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC1C351A4F
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhDAR7B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbhDAR4k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:56:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8B5C0045AE
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:44 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v4so2078141wrp.13
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RhIVYRCEBp2P76QiFo+AOMrQ2AaXGewjKYXOu/DMYlY=;
        b=IbgISJmKXOnk19WZS3J2ySq3FVtnrxDi4hLax9YvS6t1XBCNhXjxpk679NzsW2fdgV
         w54k2SjAZ3TpaU7EWId4lgguNTVU601a6QexPvk5+ZD20SZ8RgIz6uvE3pDJu2g+TrTp
         VKGmM4M5iQqsIJASRziFNeZ8KOR8CGyOUjYr4JHyvOCpXLzeJvIvvKKBM3EctNu29n5v
         vyK7DWUhBDPx9q3/kF0V1aFsM2UGYmVduu6o12IRfYYno3+bSFQm8DsPlvEr5uz/Hu8O
         cuIyDhbq74GigNCXA7DO7LvefBscwd1YsE2z4Lry+SP4qm1jO8Oq3eedd+WMhpN/CQI0
         kNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RhIVYRCEBp2P76QiFo+AOMrQ2AaXGewjKYXOu/DMYlY=;
        b=Yu0Gd9hIxpYx+3rqn8ltQhghsm5JcE38XGJ/Oi1AB4PgXNgGCYYnnmTw67YJHkWuJt
         2sfcRUQ/DJY2UT5khpYj3WEP80/5L1TVhAOPBVPhGPqWPYKm80LzWGM/e2JgaES1RQoq
         rHyQUdhQDO2BxXaKX7knbWzfl7cUizQQcPJ0PdqnDnrWA+7YnHFFDSR5rDm9kg/J3zRZ
         MB7qgryBlNNgwr97oFUsy9Ao5vMvNlfOhXoivBj1nwH5N6qqJbLmERcHEoHdrnCEefXb
         jB78v0oGirE2z/MyzZdkLXBt7nhIqlNypVMkQJigkqxGDSFmWtS9x1efs1CJPs5PjOlc
         MNew==
X-Gm-Message-State: AOAM533obSetca9s6mHwnGR9UUomHTfbyBj3kYUB7rgqwsaua7DJQ8x9
        AXC4VSMIS1QeL0RCmYPy36jZGbV7NXglIw==
X-Google-Smtp-Source: ABdhPJz3FAPhCBkTBF6tKUr3aQxZoVpxlNtWRzdL1bslbqmRtc5kicABYfB4fZknrhzuqF/aeCEIZQ==
X-Received: by 2002:adf:e4c7:: with SMTP id v7mr10231107wrm.245.1617288523242;
        Thu, 01 Apr 2021 07:48:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 26/26] io_uring: kill outdated comment about splice punt
Date:   Thu,  1 Apr 2021 15:44:05 +0100
Message-Id: <892a549c89c3d422b679677b8e68ffd3fcb736b6.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The splice/tee comment in io_prep_async_work() isn't relevant since the
section was moved, delete it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1d9fface7f4..b20fec2e2be6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1224,10 +1224,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 	switch (req->opcode) {
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:
-		/*
-		 * Splice operation will be punted aync, and here need to
-		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
-		 */
 		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 		break;
-- 
2.24.0

