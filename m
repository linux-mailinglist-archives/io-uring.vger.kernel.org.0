Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A5D25B8B1
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgICCVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgICCVA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276A6C061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:20:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k15so723767pji.3
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gAfEUaV+z1B7Js3bMwhOrcjcXawoOd5zP4Ye94up+TE=;
        b=nUegFIbvTwjpJsXdnjm+NN6VG/4/pjVAG2Hv4fFJ97mIpVsq72cRh6xZqDrqznj9bD
         D6cP6B9EQrcoddhvCiyY3I5US1eUPPvPz07N8TqG3bndHaiO4ov+D4zWX8sTpjpqFVoH
         o6Qjpru2UV/MkwpdbLHaVbjlk1Bg3AKd5Njd7ybZqiaaWGpbZ94yuEYmBbKeeLCjwOl4
         G4iH46uQc7DHE5DQ9gPbnijxIxF/pKZsNhf9+2dfxkQ7smBjGcvCPZ+/IRamZ+k1NX7v
         0ylV4l5IKa8P5TwnOXv6S7nX3exvUC5P70vrpdwOSV+O3R2lU6zw8En5yy+GYrJYzzk+
         chng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gAfEUaV+z1B7Js3bMwhOrcjcXawoOd5zP4Ye94up+TE=;
        b=HPyvCC2ZyRvpZenTbayyQtMjXKmfgsFQ2BrltEZLvqdtU6UFEZPdpVMTDwSWxG6I5O
         2EBDrZbF1fqI2xV78O7GZGCNARN/DHybEXwAmtWmReghbVkhwIAR27uHT9GK4mnrROzG
         f1iRoBWvq9Iob5MMY0v8t0/DThF6CSwrS8O8YyaZNeOypSMEF8yI3QnLCRCiEkWcSliL
         iU2D7qa34vk9A5tQ7Ma4UoOaG/ZWtjmor3rVhMVBCIbsr51BawbtgGRKG8MJlAjD7pmu
         FNPePfXdTVhhkC9B5ggKDcPUv/SZ52oORhgGws9tMw0S8j41R4QPvr6UsHgxQaQ/NF1a
         aOgQ==
X-Gm-Message-State: AOAM5308Qqv4BSQBvdMRYFU9r/z6EMNlGowGEVGuo5UmKMTsM2cfGUoP
        Y81pv2QNn18fQ0423bMOIkN7+Nu3oGZDkZDi
X-Google-Smtp-Source: ABdhPJzBSDSoekEibOweTK8lhNojW+8Wi+o9s39v8DnwvqlgPaWcc027UrBdjo9XfHninJ4EB7Z8Hg==
X-Received: by 2002:a17:90b:f01:: with SMTP id br1mr851966pjb.2.1599099659184;
        Wed, 02 Sep 2020 19:20:59 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:20:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: io_sq_thread() doesn't need to flush signals
Date:   Wed,  2 Sep 2020 20:20:46 -0600
Message-Id: <20200903022053.912968-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're not handling signals by default in kernel threads, and we never
use TWA_SIGNAL for the SQPOLL thread internally. Hence we can never
have a signal pending, and we don't need to check for it (nor flush it).

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d97601cacd7f..4766cc54144d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6700,8 +6700,6 @@ static int io_sq_thread(void *data)
 					io_ring_clear_wakeup_flag(ctx);
 					continue;
 				}
-				if (signal_pending(current))
-					flush_signals(current);
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
-- 
2.28.0

