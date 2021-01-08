Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AAA2EF9D5
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 22:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbhAHVBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 16:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHVBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 16:01:46 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E6CC061757
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 13:01:06 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d26so10196860wrb.12
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 13:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hVP2Q6N4gw9SRGBWCj3bw1ALP1bznheOyZYxj7n83oA=;
        b=V9/MF9wXEgSvHW/eXQLauTGAG3AI8XYl4ue0HuNsnqqg/uxkj9rzbODT2XlxYwTKzy
         QO3CIN1EGuXBAypxbgzNWWxiObTpk5BMVgzfK1CiJKbZhGFykRjclvVfKVGm7hVQpPmV
         6MttIxhzTC1sbrm9SWyVNE3eDz23gGXasuatN69cj8lOgkRaMuAY9Nxp9LtHX3T0Adyl
         QZfAH8c4mSQNMMW9xwRE5E87nk6vMBOAqcGYyKJIwOWzJzF0xeBgB2IL2dmjTKDNueSC
         OnWU8m9kC1LRrLmR9JSp5XCNT8OFJoNxDViGAKnoq+a2l8OdgWkFOWq7xgpLQXonev2b
         k8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hVP2Q6N4gw9SRGBWCj3bw1ALP1bznheOyZYxj7n83oA=;
        b=ZrZIBq4Dy/8TE/KxpfS+aaQNs5aukd+Ni3oRUXe4Un50QjGsP7XaOljOda4tsjL6Os
         msDv8MtbSThIHhtN1Js/ikllo/WEC3gRS9ubmRMZ23pZKUiLGVeObhgoZa05Fn8gbbd6
         lHoLQVXaw8qdaSVvrohrNdTIrfIfVzjmamEkSvfLUe5oIYageKpGStwNLgYFZQsUp7b4
         RXESOd+MNnfeo2iUa0Qfzf3yKRV3Y7epImKBSDCKGULY84QONKmZba8Q0NcQvzqTFTsh
         MlwwJTbUaKJ63we5GBLVXtIwds9VreTdwg1XX5AgkS99yi9NHwdh5F68l1R36TIsLfjs
         2gpg==
X-Gm-Message-State: AOAM531Aj9yloaJfjzP+5c72aIswYZhDLUvXiwUt/OhYwYWMiKiUGj7B
        YxvWeOstr0CU+nVpYWd/ex0W/fWyj5Un5Q==
X-Google-Smtp-Source: ABdhPJzuBDLY2UZIN4NKuHQA6hzuhyNVxshjTmFd959vFyyBvTUG1eMBcuBXejNjO2q3xn9jS40R0g==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr5279940wrw.399.1610139664998;
        Fri, 08 Jan 2021 13:01:04 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id r2sm14919211wrn.83.2021.01.08.13.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:01:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: io_rw_reissue lockdep annotations
Date:   Fri,  8 Jan 2021 20:57:22 +0000
Message-Id: <0122ce2e04ee78a5cc3f17469d5292a7a987413a.1610139268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610139268.git.asml.silence@gmail.com>
References: <cover.1610139268.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We expect io_rw_reissue() to take place only during submission with
uring_lock held. Add a lockdep annotation to check that invariant.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb57e0360fcb..55ba1922a349 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2692,6 +2692,8 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	ret = io_sq_thread_acquire_mm_files(req->ctx, req);
 
 	if (io_resubmit_prep(req, ret)) {
-- 
2.24.0

