Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E7D2FBA7A
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391755AbhASOzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394462AbhASNiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:05 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97060C061794
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id y187so16750479wmd.3
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EzI/Ns1DMZeB1cUHGDe3Q/lUs/HKQEHvUii7bOdY7oc=;
        b=G4uWkXnGUHb1ygAIyAqrHLF1ArYZYB7VL5xS3xrqvcpvMePY+Gbc7ydkjfbynXorhN
         G77mbb9pUxO/rpy7tTC+G3eDoF3VsgHNhysxm4Tx5nXnLuyJWOVW41RQn2jQm7V1pszV
         Xg27rIiAZdnr6qdyk1VhkTH3k71uwDvej3GqurlVTL+XImeeyaOjJZBnI8SucJe7aqRx
         gsQxbZWzSH4HLikZuTWkZW8qHl9GGPM3cRqu6EIiqZE20N6oNNXpn3GAJ1EM8XFILejV
         I8Rwz+LJmXTC09yA3Z9KE1067bFZWOJ9jH6UCssjfhboWuMTMb8SRaaDNZUMIKTkCTkL
         FmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzI/Ns1DMZeB1cUHGDe3Q/lUs/HKQEHvUii7bOdY7oc=;
        b=qUy04y0U9H93PxOZ1lqzGcXDOH7/ZdpBg2hQ7RzFHZeV2KsI0HvMdKdBDyEFgpSJGY
         lH/4WORppKJWz7g0OQXpbr7XynAHJWW9pFvDLK090BsI5m27Iil63xc8dkXTAVYIEo7a
         hNA44bcK//amLr5jz8mRWSx9vUn01zw1/CZDddw65LI7bXfCRCDFVNgyBQEjDKMxeB3D
         34QUMWwf9oOD8DPjz13ow5HpGLD0Mb9qJvvw82xzy9nXdP1AVh3H6y8x3slyGxu5mDqf
         s4WRGi63UvF+2rUcwW6T5Rknzve/O8cSTM1pmdkh10xv6T75J/O16leAcQz1/mLoCN+i
         kppw==
X-Gm-Message-State: AOAM531zECKnONzZIM9X9ejuYMT3sbGwQ5LZaWdIuGcVleLVE11iYdzQ
        qic1tSkqZezjLIv4NHL+Rm8=
X-Google-Smtp-Source: ABdhPJyeyy18IG+yLP3DXSNUTC/v5OcUJHScHfg3diyqIc4v5Z6opfBoNOHNvFPiaQX+yV1sVyCyMw==
X-Received: by 2002:a1c:e2c3:: with SMTP id z186mr4132348wmg.144.1611063401455;
        Tue, 19 Jan 2021 05:36:41 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/14] io_uring: don't block resource recycle by oveflows
Date:   Tue, 19 Jan 2021 13:32:43 +0000
Message-Id: <f4332081e1c60460686075e16534ecf6a337cfc8.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't want resource recycling (e.g. pre-registered files fput) to be
delayed by overflowed requests. Drop fixed_file_refs before putting into
overflow lists.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c895e42201c8..9720e38b5b97 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1851,6 +1851,13 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		io_clean_op(req);
 		req->result = res;
 		req->compl.cflags = cflags;
+
+		/* Don't block resource recycling by overflowed requests */
+		if (req->fixed_file_refs) {
+			percpu_ref_put(req->fixed_file_refs);
+			req->fixed_file_refs = NULL;
+		}
+
 		refcount_inc(&req->refs);
 		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
 	}
-- 
2.24.0

