Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0011A1A8DDD
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 23:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634000AbgDNVlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 17:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2633994AbgDNVlE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 17:41:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D09C061A10;
        Tue, 14 Apr 2020 14:41:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t14so3137481wrw.12;
        Tue, 14 Apr 2020 14:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5oGa0W5Fsbmz/lO6hF1+2jTv7urB98e3nfs+3wn0Vig=;
        b=UYvSSw53Fe7TxkT0l/l25seIAe1fEVK8A4lNJp7QByB4h9zfjJgXKCXLfEdMz3urVO
         K/C1fKrtWd+dVTxDp/rcN+rMTLnhBMGVt1QqQzxy55Gaf8E0ad0WR3KWNlvr1rrIiJ0n
         yXdiVTt+vWoxcEoTkLzbAiVISDlspLik5RFp2B4uHF9Hsv4PTAI9wmjzLERFVCj3mK1R
         ECymRv4ejPeHXK6sFgsjCoDTpEBihBxM45GAjaMe0zijNBs/7BkKJ01svc5wKK/XYznr
         7D72XHKv3/cW7yQx+mW2BGv5KK8eRMbigCDKKJLZ+rKK/V63VHV5kNLnuLc/rm/hlggT
         jHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oGa0W5Fsbmz/lO6hF1+2jTv7urB98e3nfs+3wn0Vig=;
        b=tb2vzZ+eewt+Or3Ir6tlr+yiZNY4laaOjmj2eGZZ82sBNreT4mvbvRMAUGu5ccQzv3
         x4dJAex8Ue+x2N5jT2LdJ/N3E2pJ9J6LbI8nN2vp0l1UtZKIDnV73bSFjJ7QKD7bSQTv
         pc0H5na90f0sM2x0Jgy/nWGiGDb+VHWu23EeQBA/ZJXIjjuTS31zpnuxoN4Jjl5SE6US
         sljnJq4+zQDSuYIAPSv4E0DSAEYO+J22IcDZ5tB1m1yl35RwXe1GND8jo2n7JaT9N/xl
         e9s3YzX464aPaTs22PabOsE03oxqujqtL+v0NaOh9FjdcN1thoGH6L7EbjGwsqnzcsww
         GTkg==
X-Gm-Message-State: AGi0PuYDPVroeY9Tejoa85XorPzY53fRPtOq9a5X7GRMuBFhP4U5VQQL
        JIZAVGXy69+8A03GvV1PXiN4auyG
X-Google-Smtp-Source: APiQypItW45WYuXZncl4kfqerD6okM58sIxIEne+4I2UT+ItdNwk77XEC07LR1Pz+sIcWu61K9PWow==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr8777977wrs.282.1586900462404;
        Tue, 14 Apr 2020 14:41:02 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l185sm20320540wml.44.2020.04.14.14.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:41:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: kill already cached timeout.seq_offset
Date:   Wed, 15 Apr 2020 00:39:49 +0300
Message-Id: <1a62f615d10d81ff2b99eb1bcb087a620c96ab69.1586899625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586899625.git.asml.silence@gmail.com>
References: <cover.1586899625.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->timeout.count and req->io->timeout.seq_offset store the same value,
which is sqe->off. Kill the second one

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fcc320d67606..e69cb70c11d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -357,7 +357,6 @@ struct io_timeout_data {
 	struct hrtimer			timer;
 	struct timespec64		ts;
 	enum hrtimer_mode		mode;
-	u32				seq_offset;
 };
 
 struct io_accept {
@@ -385,7 +384,7 @@ struct io_timeout {
 	struct file			*file;
 	u64				addr;
 	int				flags;
-	unsigned			count;
+	u32				count;
 };
 
 struct io_rw {
@@ -4668,11 +4667,11 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static int io_timeout(struct io_kiocb *req)
 {
-	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
 	struct list_head *entry;
 	unsigned span = 0;
+	u32 count = req->timeout.count;
 	u32 seq = req->sequence;
 
 	data = &req->io->timeout;
@@ -4682,7 +4681,6 @@ static int io_timeout(struct io_kiocb *req)
 	 * timeout event to be satisfied. If it isn't set, then this is
 	 * a pure timeout request, sequence isn't used.
 	 */
-	count = req->timeout.count;
 	if (!count) {
 		req->flags |= REQ_F_TIMEOUT_NOSEQ;
 		spin_lock_irq(&ctx->completion_lock);
@@ -4691,7 +4689,6 @@ static int io_timeout(struct io_kiocb *req)
 	}
 
 	req->sequence = seq + count;
-	data->seq_offset = count;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -4702,7 +4699,7 @@ static int io_timeout(struct io_kiocb *req)
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
 		unsigned nxt_seq;
 		long long tmp, tmp_nxt;
-		u32 nxt_offset = nxt->io->timeout.seq_offset;
+		u32 nxt_offset = nxt->timeout.count;
 
 		if (nxt->flags & REQ_F_TIMEOUT_NOSEQ)
 			continue;
-- 
2.24.0

