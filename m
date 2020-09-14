Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A78269180
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgINQ2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgINQ13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:27:29 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0599C061351
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:09 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m17so765753ioo.1
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jO2YbdgbjXS+B6PFyfcz8Uqn290FsLkw2M+TQo5pEz4=;
        b=CODJvX37ZaidLE2udsxVLK4/4WGGG3eGRzr7e7wtdYo1dKD+3k/G2ZlcrbLlb8LVlg
         2z66Qu0UWFWeslJqIAeK8WIyaaY5S72qfcl6GRnoIJTCFOPFMFVkA/OHVOPPXFxgfsHq
         XrEcXPnrtGNU2KUg8pqxfSgDhr+a08SGe/7nkhsU0AiN7O4EDUlBDBzb0XPGQk00rrkE
         XkmpcclEWrRVCVPuBXdyd9DG8nD5XIsVTHFaKBufWCjJf5riqVBZIgzUmvzq3uQWKP6H
         RA3b3aDv2V/S4NpBKOL9UCj91wud4bCVQZ7rxdgzH0/RrZLudiLq9Nlien58ApTkunDS
         TZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jO2YbdgbjXS+B6PFyfcz8Uqn290FsLkw2M+TQo5pEz4=;
        b=Tb8kZAcmsCvzt6gcOqDIAzla9doO8UeO7y1Y1QA5vHnEyIdKmuKTmkKmNhYpIoViOQ
         FFpkzs+iAS99fGNa+fWOgJivnilcPSYAdQg7QWhLPpp519L9pldsbYhzjq6/ISat08O6
         uf2TfZaAmGZ9/ML1VzVYPoTwXxVpmUJQyITBqtkKaZnoo+5nLRVbZz6q7qgOwPAQ3qjA
         uLn64JIvz3z63Aqv0kXpfhnyMdmcn8iCOJQZ64N2h5CS+DyeT+ulIWynNdceVSE8WQXS
         rQE8mRLPNXkq8zOgwN95a83ldeYQSS77I63bGL0mlVmUeuepiUttegb5nevLOvFKt76O
         UtrQ==
X-Gm-Message-State: AOAM531ZkB7x8Q/kXhyefX1uAGD8TBt+IvA0vI+HoQom03WNytLKsb5E
        YjItH74f+I5HaCUmorL5xi9epO4BCtoaYUjw
X-Google-Smtp-Source: ABdhPJzJcyuweePJuoSNH03Kx+6qO0v5pJD3coyxi9q6ZqN9rnwOWPvcFACokdER8e3ny/0CM7kF8w==
X-Received: by 2002:a05:6638:268:: with SMTP id x8mr13996747jaq.44.1600100769106;
        Mon, 14 Sep 2020 09:26:09 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: don't re-setup vecs/iter in io_resumit_prep() is already there
Date:   Mon, 14 Sep 2020 10:25:54 -0600
Message-Id: <20200914162555.1502094-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914162555.1502094-1-axboe@kernel.dk>
References: <20200914162555.1502094-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we already have mapped the necessary data for retry, then don't set
it up again. It's a pointless operation, and we leak the iovec if it's
a large (non-stack) vec.

Fixes: b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a9ff6e47eb16..05670a615663 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2293,13 +2293,17 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 		goto end_req;
 	}
 
-	ret = io_import_iovec(rw, req, &iovec, &iter, false);
-	if (ret < 0)
-		goto end_req;
-	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
-	if (!ret)
+	if (!req->io) {
+		ret = io_import_iovec(rw, req, &iovec, &iter, false);
+		if (ret < 0)
+			goto end_req;
+		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
+		if (!ret)
+			return true;
+		kfree(iovec);
+	} else {
 		return true;
-	kfree(iovec);
+	}
 end_req:
 	req_set_fail_links(req);
 	io_req_complete(req, ret);
-- 
2.28.0

