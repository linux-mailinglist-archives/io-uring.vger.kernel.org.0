Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370D27AD40
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 13:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgI1Lwm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgI1Lwl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 07:52:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC7BC061755
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so942004wrl.12
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wfYKSnCSoQR3AxhIEa9eDUq9cUx2dCa3phCAu2YDp/o=;
        b=NX/uKuAQym3Ziih8wk+n1oB0cNhEtnoJtK0nbGG8kxbMaMD0R0b7z068XzX7SxIi6I
         QG8CLl+JYN83PNRpEoGo/ydpnP6QVYSwIF72KcGGTFC1clGbXKXDk3BfipJEexNuBB06
         QmUpvZzlRdluJuE9JfVk8EL0jEYd3LNminOk9sSRNyY5pNqbgr+esIsNDCQRZ/U+SK+b
         9D92K+G8vZc3hBwm+Qu3yzWE7vgmjdXIlBt2oEmeXMH1CDE7BVD8WBkItzqkp+Stc8wx
         ye35f32DlFgQdV/88v79qunRo7ZQh5n0OeL+gdO6nUBWxAFzh9bmD+8b1ELicStd0NTg
         Bisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wfYKSnCSoQR3AxhIEa9eDUq9cUx2dCa3phCAu2YDp/o=;
        b=UAERNAkgRtFHgOiU6OCOCMqUZk786+OXbSNUiipca2MvEO0nm22df3LohQgnjg9mt8
         9IoqWA3vzrBOGBc8prF2bLblg11UIbtwSH9bPzEjUv8quqf+IPxXMevSsIcE89hM+eVJ
         PUfMt7U2+gaPuy8lG9Bh/8wW0zprnWr3HdJuZ6eE83rxbBL2xKT2+xXLCKy2B8exzZKl
         SSb2LGih49lQsqM1xAG/1K5GNCa6Rn8a+HdhvKdEEFb1OqT9KD0tnmvuIrHdFeMOSZ3s
         5SSGIYBt23SuquTMPN/mO5+SSter+w3rXZgyGJfWHQuH3P8SS1Fh6FAzZLqKWKB6awDd
         +reQ==
X-Gm-Message-State: AOAM533GW875CYyrGNuJeZmnz0B4+k8UFgX+35F9sXr/NF0zGkaXiXE2
        xO0tJ3s805Wg9cHum7vgcZCBNp4GAHc=
X-Google-Smtp-Source: ABdhPJxrxKLmYxOTpkndPw9oMqq3B8aAXOjw9MIagWKZ7/PxR4WbGhyk3YdH24BuCHGqeGXwgkdl3Q==
X-Received: by 2002:adf:dd0b:: with SMTP id a11mr1273670wrm.422.1601293960216;
        Mon, 28 Sep 2020 04:52:40 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-140.range109-152.btcentralplus.com. [109.152.100.140])
        by smtp.gmail.com with ESMTPSA id l4sm1275282wrc.14.2020.09.28.04.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 04:52:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix use-after-free ->files
Date:   Mon, 28 Sep 2020 14:49:49 +0300
Message-Id: <71e7baae4ff3b745e13c685c39121af6e13ddea4.1601293611.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601293611.git.asml.silence@gmail.com>
References: <cover.1601293611.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_flush() should first clear ->sqo_files and only then trying to
cancel requests with io_uring_cancel_files(). Otherwise, SQ thread may
wake up right after io_uring_cancel_file() and submit new requests with
the going away files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ee5e18218c2..6523500e4ae2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8548,8 +8548,6 @@ static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
-	io_uring_cancel_files(ctx, data);
-
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
@@ -8570,6 +8568,8 @@ static int io_uring_flush(struct file *file, void *data)
 		io_sq_thread_unpark(sqd);
 	}
 
+	io_uring_cancel_files(ctx, data);
+
 	return 0;
 }
 
-- 
2.24.0

