Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC631EEF4
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhBRSwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBRSf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:35:57 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431BBC0617A9
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m1so4837350wml.2
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=c+wuPJApSiVBfvYrgq0FV+GSQpnWzdHpkUAhK1/oSho=;
        b=s5U/zqc7dXiaZG7IaNvx2NNY42XfskY/BXO3MAPsQAhg/GXFBnzo/PoMvD6mb7DnbD
         0/B0uAA6i9joRnCiv5rWXtNmcDAB5jUF2UaWfSCGxUcF42a8ap30+sVCbbL58GFybrw9
         FK2BuZNBZerfFOdXG7e2SFGbZlLrjvzgqxodWqn9S5jXur66St0gY/jYIzYaCkCzeKzS
         5USaL05wUY4KrspPutoCgUAMNNDMVvoKgllvgPvNF4LafCR4c33L3MbRYdJX0MnSBA1S
         3H8TATZwiMpWRprP69rezYuj02vPDr5uXgy21d73vm6UPM0zoLMOxjubTHK9qqBulRmn
         rerw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+wuPJApSiVBfvYrgq0FV+GSQpnWzdHpkUAhK1/oSho=;
        b=VEEdZtyEZxJhPDjucZynID9eBfExbMoEOnlWjQsZKlVaE3/NeciFNoE3L6TXlexv13
         D/e6BzoUGIJ6fyFU1Ny623PLPs9rw2jr/ixwWbzwmOV1LY3PiQxoZ+2SlWrK9EHShyf7
         96iW0iQ9r54WkXAKOPb1kddScDVB83VNajl1pm5Db3kLN2XhfwTvhDq5E1oUw0+khIdA
         qqgXyg5wmu1ZH6J9eFnbzI1MvtYE1JiVpzS7kh5+3HYQvx2AJQLJGTH8/mG0OAX+rwer
         SpOjvz28fyDaEI8VwaLodijxgZ7kG9EULtvjfzqxgFDKVrusBPnorCLZ1Zm4HAUlP74L
         5n+g==
X-Gm-Message-State: AOAM530XDma00y77w/+iV4MwKOZw5/ebNrCqGP6ihm73Ws4uW4p9ZPyT
        gZa0PI2/NK2yi6cRTL7wEC4=
X-Google-Smtp-Source: ABdhPJzBfC/C2nCxMXSyoKkQ3NTMgkeJsnJ40XJpzfLC/fiMjdnQTCTEXJY97ip1yaddMUMlcpPb7w==
X-Received: by 2002:a05:600c:230c:: with SMTP id 12mr4814679wmo.30.1613673227025;
        Thu, 18 Feb 2021 10:33:47 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/11] io_uring: don't duplicate ->file check in sfr
Date:   Thu, 18 Feb 2021 18:29:39 +0000
Message-Id: <7b00c461161bc8e1a2708f74c4700fcc52684c13.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_SYNC_FILE_RANGE is marked as .needs_file, so the common path
will take care of assigning and validating req->file, no need to
duplicate it in io_sfr_prep().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index adb5cd4b760d..db6680bb02d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4599,9 +4599,6 @@ static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
-- 
2.24.0

