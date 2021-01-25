Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4034304A3D
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbhAZFKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF20C0611C0
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:18 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id p15so5394470wrq.8
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MxeJplOd6aFIYBt+YHr+ru8j9ko6pPCAGNUPmqPm2hE=;
        b=mzRgN1XTzV0TXqpuf284PD5t2K4UWSm/veTDn382gg6iFGm0764jmv8ZiT3nK040Sp
         ukyV7+TGYw3VuIjF8YcPAlRz7LtPldUhzciee0sPKZ5ssWMhrCItWtwN59oi0cCmfag6
         ydBLmfdx72XYNggiuCCRGSHpO7hcZZVHTm4fC8oD4hXuPVjIU3P4YMkMLt8ZxHygXz9A
         dhXfSs5BMvlsWP+GaAuKx6UOlJy+y3xr7mYDoxGR0ayjT5Mhq7vNl9tA0HBW6z8sxB5y
         MwGqN7rJQkHMJBTmvw781EMW7E/Nfc+TiGbxNSoidGr96xRz9++nZmbl/zPS4XfIkWPJ
         3BxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MxeJplOd6aFIYBt+YHr+ru8j9ko6pPCAGNUPmqPm2hE=;
        b=p80shrhqKQbVk1CiAwpERswORHJGvJaGxIsBGoyj4IhMCe48ZTr+INQSjGn964MMzQ
         ckQQhe6dvBXLHiOlcfIvRi/YTOlXZYEB3+3E32ek8KViv8oUOLPhQc11sctJf+vvie7S
         8p/dezuvhRMzYRZYdyAIvXac1FwzLCOtTqiz37TG79LJ0hKCpvhAueGc4/EdGSU3pStl
         uHTGV1MiBtVuRSqi5FXuq9s/LqZSxYDqe+IvWb2NZDuoMNVQa60ZeCyMivSLmbMgLezX
         b+uWFDPxiRyOQ7QlFRAfh9Psm7sw9b2eFICY/XLR4+Kodyg5vn43HFenmye4eD3QL13X
         OAJg==
X-Gm-Message-State: AOAM531g8dxWiyuAv/FRuPka1cMRa33cWGn2l9CDtMoy0YPpnCHaETnU
        3Dy3szCy9HRnjC6Oy/HQH6hZ9W88mj8=
X-Google-Smtp-Source: ABdhPJxyhU+sgl02m/+GW7I0XmVMjAAsq8rEyUn7LhbBuQ+3CkQfsYZs4aCniX3hq+o4Dep555dMNg==
X-Received: by 2002:adf:ba49:: with SMTP id t9mr476176wrg.183.1611575174708;
        Mon, 25 Jan 2021 03:46:14 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: ensure only sqo_task has file notes
Date:   Mon, 25 Jan 2021 11:42:20 +0000
Message-Id: <14e7c16f3dd6153fe7868b9065aeb60cd637272e.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For SQPOLL io_urnig we want to have only one file note held by
sqo_task. Add a warning to make sure it holds. It's deep in
io_uring_add_task_file() out of hot path, so shouldn't hurt.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a17c947e64b..8be7b4c6d304 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9074,6 +9074,10 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 				fput(file);
 				return ret;
 			}
+
+			/* one and only SQPOLL file note, held by sqo_task */
+			WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) &&
+				     current != ctx->sqo_task);
 		}
 		tctx->last = file;
 	}
-- 
2.24.0

