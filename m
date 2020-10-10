Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD328A3E7
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbgJJWzk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731250AbgJJTFM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 15:05:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B0AC08EBB1
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e18so13699115wrw.9
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 10:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1ifgpFrjpQM4ci+JQJAx0+XCorFF0b5h0bX5cdG9IOk=;
        b=L3BjK7FEuTqUEi0GQgkT8paF5nuYlw8LXqrOeyTpUq78dnxKZnwYySTgpSULD03KOW
         QkdvLj5woxzfJBv50ECfpPpgsv+0r0OB9D9yvhp4fuNbgM5ubVDGNmLWlzZDHEV5F6BE
         xvqzPKBHc7g/hfmbY0f92OmRF1w/dtFo5v8yPjJf6d4BkyoIKTbADDMYPq/l/esE57pg
         3R/cZgiDyjK0dXJJyH2/wvwkXMdSLpyXgkcDQnZ4muE8hVdd3xJDVTBv1SKn6S0dQ/l/
         QO0Uk1bGvx4I3Xv1Ll6UJSTCiInstVadZL9i1oNUfhMxke8rZgnkT49SnvnBs98+bkNB
         oMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ifgpFrjpQM4ci+JQJAx0+XCorFF0b5h0bX5cdG9IOk=;
        b=OhTZAe65hNqX07rG+qw6z0yZ15YJe2ko72VFmhtmb2Ew/NbFYSNMnRfl0MRNS9/M18
         Bm/aW3dwbyrNoxADQXvqv4LwER7KBWTKs5jfdPR0ni63yQSy5VKiqW04nw/juBw2ODlj
         UvoSEmY6r9C4yiG6Q9u7yyUu+kdI1ESC3nwvn0qylCUwjJhG8/YZUjUZMI6QR7+afbqG
         4PUKKr5BIGuJMh9uRu4yazt7EsytYhskhIxulLIi0OHnNOfCnZGgqvJBVbpGmCv+bTTi
         Bw8NuPndMyMn6InVcG9gmagwHoyJAD0OYgY/yj7/6UrANj4PGn6vrSm3ZO5rDwdkI4UL
         DGpw==
X-Gm-Message-State: AOAM533YndIWLGnGWcoScvBK4NAsAeEfv0GtG6jpCRZcdtxWzfza/h8u
        A0buhbKyTa89Yt3ObInxTEY=
X-Google-Smtp-Source: ABdhPJzLFjV5WBy09e/3ZuASZnT/0wQVeWZoJ3IlcWfJeowetNaIKELmbXk+gd/iFJxMPXtoeB+59Q==
X-Received: by 2002:a5d:4709:: with SMTP id y9mr21063633wrq.59.1602351439379;
        Sat, 10 Oct 2020 10:37:19 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t16sm17269005wmi.18.2020.10.10.10.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 10:37:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/12] io_uring: clean leftovers after splitting issue
Date:   Sat, 10 Oct 2020 18:34:12 +0100
Message-Id: <58b23b922d087ea9b92d9103b10b493200f57f99.1602350806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kill extra if in io_issue_sqe() and place send/recv[msg] calls
appropriately under switch's cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ce72d48eb21..2e0105c373ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5831,18 +5831,16 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		ret = io_sync_file_range(req, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
+		ret = io_sendmsg(req, force_nonblock, cs);
+		break;
 	case IORING_OP_SEND:
-		if (req->opcode == IORING_OP_SENDMSG)
-			ret = io_sendmsg(req, force_nonblock, cs);
-		else
-			ret = io_send(req, force_nonblock, cs);
+		ret = io_send(req, force_nonblock, cs);
 		break;
 	case IORING_OP_RECVMSG:
+		ret = io_recvmsg(req, force_nonblock, cs);
+		break;
 	case IORING_OP_RECV:
-		if (req->opcode == IORING_OP_RECVMSG)
-			ret = io_recvmsg(req, force_nonblock, cs);
-		else
-			ret = io_recv(req, force_nonblock, cs);
+		ret = io_recv(req, force_nonblock, cs);
 		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout(req);
-- 
2.24.0

