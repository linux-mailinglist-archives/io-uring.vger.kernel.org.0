Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9C25EB12
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgIEVs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbgIEVsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:25 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8193C061249
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:24 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t16so4415359edw.7
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pBnkV0jzBADEETy5dy3nnX2RJI1XhGgFaPxW2RCiV/k=;
        b=IJhi5mjQXpvQISPrKm5DZzXPm7aoUhHbOXI4sGDW66HQWKzoHrIF2/Scr5FBHktdhZ
         IULgvJeDDvr4mTqW0sYKn9dbPd8qTw0J2YjqBBPls+0eWKWYpPuA3+ePTTRlyPnS/nMI
         dlAfr+vjVxOtMHMUNsSRBVvfYWAQsS3zIPMdKAgfeThOgWVT2J5KqwEYKUwHzYC5cdoa
         Wq/nlPnYU1JEkud/UtlQdKsnxmEisdDL1n1RZy6sKEgzEu2f7eqbKUr9vjtUCYrlXu9G
         xNgfPXtCEXP7aIB2x61rjjsDhQ7FpidSstanmPuu9KasvKT6+ZeQkreN/woYAtFXd2hJ
         rkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBnkV0jzBADEETy5dy3nnX2RJI1XhGgFaPxW2RCiV/k=;
        b=iSoJF9ttfWldOdmtGJgujsTTFIC1nCDuL1cwaj+2qquc1Ul9Ux+M/9sGsiOscuR8Rz
         a8Zy3b/ieppKQnR5vClFPU5/nSIO6OPeZP/hpCd15wW0Nn5nRmouJOgjg2CanxMWWgCM
         dkW845i9rlDZNMbRnU5mjBG79QSP0iHyIJO3JLtRxBkSml7BymcFqLGMApRsPEL0Qqmk
         xeJAIWMIAde1MobnZ7GtQ9gJ0g+Gigj3qamCRl84BY/N5frbtq8sYkOAXDvgbx2IYYpa
         m/ydgb5mEN6Nt5bJWZZgjIyI4QJuXn+2jtJJwXrRD7COGmrR9KRTrN2C0AWwzFVz0i1D
         6xZg==
X-Gm-Message-State: AOAM533g+PADOsVTHy5PNrgHJNIRE5azXMVzn5eK0niXVGVVEYxa1I82
        PAZGDXntoTyb+j5AX2jYKh0=
X-Google-Smtp-Source: ABdhPJzk+Cb6RI2LPZ4G+E239AEiCz5ruqU2a7X1BNMA87vg+ByCCixRYlwfxYzIOhsZxm70SOmPKA==
X-Received: by 2002:a05:6402:1d93:: with SMTP id dk19mr15064631edb.198.1599342501436;
        Sat, 05 Sep 2020 14:48:21 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id g25sm7965603edu.53.2020.09.05.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: fix ovelapped memcpy in io_req_map_rw()
Date:   Sun,  6 Sep 2020 00:45:47 +0300
Message-Id: <2acfe0165377015983a0f285bf6242f8fa4232d6.1599341028.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599341028.git.asml.silence@gmail.com>
References: <cover.1599341028.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When io_req_map_rw() is called from io_rw_prep_async(), it memcpy()
iorw->iter into itself. Even though it doesn't lead to an error, such a
memcpy()'s aliasing rules violation is considered to be a bad practise.

Inline io_req_map_rw() into io_rw_prep_async(). We don't really need any
remapping there, so it's much simpler than the generic implementation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03808e865dde..fc2aaaaca908 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2986,7 +2986,10 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 	if (unlikely(ret < 0))
 		return ret;
 
-	io_req_map_rw(req, iov, iorw->fast_iov, &iorw->iter);
+	iorw->bytes_done = 0;
+	iorw->free_iovec = iov;
+	if (iov)
+		req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
 
-- 
2.24.0

