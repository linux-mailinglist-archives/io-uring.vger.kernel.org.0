Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6E2E87E1
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbhABPWr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbhABPWp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:45 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22906C06179F;
        Sat,  2 Jan 2021 07:21:31 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c133so13165892wme.4;
        Sat, 02 Jan 2021 07:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfcAWicfY3ps8Cp/gsA4qs7Avo53ajYGpXmNYv+JbSY=;
        b=h3b+ygyZOCMZuu/SSxyE2DWy3gO46XVTWVl20xf69BlLvp9dyAKaIzAwn7UmW26Kb/
         Ljv0oHCBxsXqorvd1qYO/nb8M0kRw/9DQQx6p+tfKVVwfj+/6ysumrx+Cn1GhfAuSm9S
         v+7NBHal1hmJCfS5zl+1GhhdLI3hHTIpQnNfgkqSKgB/I81jGpD95EU2eneLMNlNY4IH
         FgNLFwinxLsO4rsFs6D3gm3ZQzQI71uYRosnGEz/aeZdan7BrrrEt08QP5adFhjqMouz
         JWKb4wWJuJfsKMdwtZJd30UVuxO9MV9x4ger8/HPOf50eWCLPwOaRdQ2MS3H02te9WbG
         ByKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfcAWicfY3ps8Cp/gsA4qs7Avo53ajYGpXmNYv+JbSY=;
        b=iUIhtk48KJ91qOW1SIRED0JtIPiFZF8NEJuOfqnWGqMCK+zAZNdd1fhU92fgwuT2DG
         9PBXqvjDiWe782iEWD4tWc8ohfieNJtqOeh+sNg1Ot0EJJH0MkkYh5V5kqj3Ab56rmyy
         762777UFpVnPtlIoGd4/bfA1ThKlI62Bfu7oZoVk/YQcP45xti/QRNpPFmqgsbDqFQdO
         hedkU1tmvJRdAvR4HCBMT3CZxBKjTpYzK8aYXmio0HNyJtkEDtrJHF8Pl9IYNajScQiM
         R1HMnG1pbg2KTSzvlPgTCutKztof2Env3dugFah86w+7CvU5CZyJxFxQgv6kqfEmKWCI
         AO2g==
X-Gm-Message-State: AOAM531RBiiVYPWqFz5buDAf/mf2b5mTHjlxEkuHIdgBuxQwDymOeglX
        zTosUaalT949LHXbi0ugBf/8MEVPtoOJTw==
X-Google-Smtp-Source: ABdhPJz+w9pXtmdIRErhfXjecmNBpBoEj5ZToxSuo4zC0pqEv8F+jXoDdzGVYwWU0q45PiWTWmj+DA==
X-Received: by 2002:a1c:6383:: with SMTP id x125mr19797365wmb.46.1609600889718;
        Sat, 02 Jan 2021 07:21:29 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:29 -0800 (PST)
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
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 5/7] iov_iter: optimise bvec iov_iter_advance()
Date:   Sat,  2 Jan 2021 15:17:37 +0000
Message-Id: <a93a17ce2669c8f8ec4341bfbc503e2f649c317c.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iov_iter_advance() is heavily used, but implemented through generic
means. For bvecs there is a specifically crafted function for that, so
use bvec_iter_advance() instead, it's faster and slimmer.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 lib/iov_iter.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7de304269641..9b1c109dc8a9 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1065,6 +1065,21 @@ static void pipe_advance(struct iov_iter *i, size_t size)
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
@@ -1075,6 +1090,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
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

