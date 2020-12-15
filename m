Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C822DA4A3
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgLOAY4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgLOAYq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:24:46 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74062C0617A6;
        Mon, 14 Dec 2020 16:24:06 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id g25so9987084wmh.1;
        Mon, 14 Dec 2020 16:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7uupKi2lTHg1nTREBYfC4U7HbsUj926sgl3xgaqTd0=;
        b=P81A9Xdxqm6t1KFSSYwxpIM9EzQWTzR8Kz1eIjcTpt9oDQteS1+WmwytiySg9Ve3ck
         NH3x0eCT2MFsM6i7mpTaRmDkUKmx5yR84cDkT/K6YRM1+dJDKNadBpjefTeOpL7Jq0sU
         hLnzYpj6MkeIUvLlzsAR9PAA75XqsccnOt5Wb44pkE1iqEyfYLJT7jvppOb0ArghCB3U
         aiiSZEELjay6jLHL3mD8WZJ+DeJ9kVoBdCzXJAJemKWaykjXM3T+6gNyZ4vQ7eIbTDsU
         Sd4LMtYWOt+LJEqXarqBcbVqn+H4L7PALmdqkkXdPbMC2NyrSHYlmYwwX0FoD6I8p81c
         3blQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7uupKi2lTHg1nTREBYfC4U7HbsUj926sgl3xgaqTd0=;
        b=Z/ayUguHDbfm8n3WQuLImH2uFxf5GburTC7IEyzsKXPgocNsvSznCrgs05gP3Yta1Z
         1a5p8nlFzl8DEI7kMT7yX1+f1+pyCrhtRUId4GAVzqJsRUL4Iy44KJXhcZ8thfD9uxXt
         bKp8G6bSqsPNmD7AgbL7eNHshUygksaKs6kxmoQ/FRQDfWG7hmhGj4wj0cHg3IdkW94i
         XunxaqfAgb+qxqTjTg0zSeeGHXSfN0WaYn/0Ixf/sgiSQ6OR2V1m2APyZPFthkV4JYB+
         gvvpol74yrBRNbJwvd/tk39MoGd3y6aJFaY41AhCi7ZDMkIwrIHoSAd6bqZdu2Ccz+JN
         kBKA==
X-Gm-Message-State: AOAM531JhHgqEkxk5Ez+q+dIJB6eXoEtG2p+ugqOVu9NZlJS7tvnO27E
        w3h9XFr+4x6MxDJ6wgqBb3y+5XPtKQ40/rV5
X-Google-Smtp-Source: ABdhPJykC0JY5d7rIaOq+MAqm+QaT5pR/4R471Z55M1imOLkxialCK8BI686kFFIPWNpqaYfjLcRPQ==
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr30684129wmf.149.1607991845077;
        Mon, 14 Dec 2020 16:24:05 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Date:   Tue, 15 Dec 2020 00:20:21 +0000
Message-Id: <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iov_iter_advance() is heavily used, but implemented through generic
iteration. As bvecs have a specifically crafted advance() function, i.e.
bvec_iter_advance(), which is faster and slimmer, use it instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 lib/iov_iter.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..5b186dc2c9ea 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1067,6 +1067,21 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 	pipe_truncate(i);
 }
 
+static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
+{
+	struct bvec_iter bi;
+
+	bi.bi_size = i->count;
+	bi.bi_bvec_done = i->iov_offset;
+	bi.bi_idx = 0;
+	bvec_iter_advance(i->bvec, &bi, size);
+
+	i->bvec += bi.bi_idx;
+	i->nr_segs -= bi.bi_idx;
+	i->count = bi.bi_size;
+	i->iov_offset = bi.bi_bvec_done;
+}
+
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(iov_iter_is_pipe(i))) {
@@ -1077,6 +1092,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		i->count -= size;
 		return;
 	}
+	if (iov_iter_is_bvec(i)) {
+		iov_iter_bvec_advance(i, size);
+		return;
+	}
 	iterate_and_advance(i, size, v, 0, 0, 0)
 }
 EXPORT_SYMBOL(iov_iter_advance);
-- 
2.24.0

