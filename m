Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415002BAF5B
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 16:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgKTPyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 10:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgKTPyJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 10:54:09 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF25C0617A7
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:09 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so13557199ejk.2
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5ybHvYwvjlgZ+BtUlOrAzNvtNfqdL19kdPqefi1v6TA=;
        b=aY9Evw/1Wc7tdtdLcBpSxc3OlcB0iYFqGsCk7wmQo3GNFpexrs1mjXbPVCELgXwUKY
         i2YKCt5WwFCdUK3NgMpQWDvYuXudv+TOPkcGxfb4vT+WPNR+1Cf1o67BXAZuM6eF8aoe
         gQHEpMRnflKv4tF417wNQotv5S5qlrRTp8xlWfgj171XYdZ/FpGt0j7E6IrKzjtBsX+u
         dFwiA3xIdzAt3m6tou4QsA5OR+KSZpHs1LEwUZhVQ8sg6rilpHpgR6C3hd4mMuGCi1Ug
         FZJaF1l2TbvNGUKK2tydiRTTF1u6bSDHMYn5PS7lFNng+ch0xzI3Xm5CrMBvdYtaiZud
         EEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ybHvYwvjlgZ+BtUlOrAzNvtNfqdL19kdPqefi1v6TA=;
        b=Ah4+KkbNyoO+vCwJvr1TPCUxIUlgpvTf8dZcvbGVp74+JROBjN3mFChY83k+TGpnFF
         hR46jg+lxyg8zAiepp7OvWaT/yCafa20jot0vtGj7xNdbqVFRUDNvIzCWG4+EuCFrmJg
         IoMciBpOBAVg/fSvCoyfPLnzWU2P6YXcGv/n1y9kXo7QsMpEjVOCDZ3FQo4x7nLBup7v
         YV+KQO5qD0BQwBmhCnja9Xh//Qt3cCRoKxHJJWmIT8/U44semnKANw4/PweyhSBB8Bm6
         zOwt7FOYNC82Y+mTpszClnotK+Bttb/e9geYB6bDlNwCqVMe85pWZz5knJX+ormPHikL
         HTqQ==
X-Gm-Message-State: AOAM530qGKqpktZ2riV4an2P4j7PfIdoZiOJuNmC5NTATZKhDjzGxIJh
        rAsM1xENcSHBNIpNgWgmd0E=
X-Google-Smtp-Source: ABdhPJy3d9bs85MtrMayXWuc2nVWhjWvi5JfY/lpa40AjrJRNuJoRdA+6Z/O72cEl8s9uHf5FunXYQ==
X-Received: by 2002:a17:906:ae95:: with SMTP id md21mr32171947ejb.425.1605887647692;
        Fri, 20 Nov 2020 07:54:07 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id y24sm1253956edt.15.2020.11.20.07.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:54:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: change submit file state invariant
Date:   Fri, 20 Nov 2020 15:50:50 +0000
Message-Id: <92d58424c8641a857f8cbe3c3dce528c9be4f7d1.1605886827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605886827.git.asml.silence@gmail.com>
References: <cover.1605886827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep submit state invariant of whether there are file refs left based on
state->nr_refs instead of (state->file==NULL), and always check against
the first one. It's easier to track and allows to remove 1 if. It also
automatically leaves struct submit_state in a consistent state after
io_submit_state_end(), that's not used yet but nice.

btw rename has_refs to file_refs for more clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8e769d3f96ca..62c87561560b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -764,7 +764,7 @@ struct io_submit_state {
 	 */
 	struct file		*file;
 	unsigned int		fd;
-	unsigned int		has_refs;
+	unsigned int		file_refs;
 	unsigned int		ios_left;
 };
 
@@ -2765,16 +2765,15 @@ static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 		wake_up(&ctx->sq_data->wait);
 }
 
-static void __io_state_file_put(struct io_submit_state *state)
+static inline void __io_state_file_put(struct io_submit_state *state)
 {
-	if (state->has_refs)
-		fput_many(state->file, state->has_refs);
-	state->file = NULL;
+	fput_many(state->file, state->file_refs);
+	state->file_refs = 0;
 }
 
 static inline void io_state_file_put(struct io_submit_state *state)
 {
-	if (state->file)
+	if (state->file_refs)
 		__io_state_file_put(state);
 }
 
@@ -2788,19 +2787,19 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 	if (!state)
 		return fget(fd);
 
-	if (state->file) {
+	if (state->file_refs) {
 		if (state->fd == fd) {
-			state->has_refs--;
+			state->file_refs--;
 			return state->file;
 		}
 		__io_state_file_put(state);
 	}
 	state->file = fget_many(fd, state->ios_left);
-	if (!state->file)
+	if (unlikely(!state->file))
 		return NULL;
 
 	state->fd = fd;
-	state->has_refs = state->ios_left - 1;
+	state->file_refs = state->ios_left - 1;
 	return state->file;
 }
 
@@ -6635,7 +6634,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 	INIT_LIST_HEAD(&state->comp.list);
 	state->comp.ctx = ctx;
 	state->free_reqs = 0;
-	state->file = NULL;
+	state->file_refs = 0;
 	state->ios_left = max_ios;
 }
 
-- 
2.24.0

