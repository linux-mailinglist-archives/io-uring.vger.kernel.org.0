Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ECC2FBA7F
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391816AbhASOzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389008AbhASNiI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:08 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280DC061798
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c124so16483882wma.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/D22Gb17/jtqVFklWiVMb5tdwN1lDZi/QJQuHv8Nxoc=;
        b=YygbSwv2NydkWqUwazYwo2F02gioqB7fejxCNVI0cHPmmsQ525WbKeMVGIFpeL2oao
         QpuiERMcypXRmDX/MYiJaEw8xb7oMU3lHvoNYol8tiiE7zIkJgGs8JC6QRQQ6fdDOFW1
         /zZS/IH/9wc76Teim0qIcKSGMwYQkT8ZbmTmBAObB3Im0/qdfZULzRa7FxeNBvQMrmrb
         RsoG+WScmmfGzTtiynkTi4Vp5jrZPwwiTJTekclN1B8V2WmDs+InrODSlYY44dWnuF0f
         NRQwQYbAY+Z0EON/A+IljJvU8yVgh4Kz+Qk/Ehd94Ha9Nw+wnGiTy2KzcT112zie/1tp
         9OfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/D22Gb17/jtqVFklWiVMb5tdwN1lDZi/QJQuHv8Nxoc=;
        b=YET5Ycm8uqICZM5Jh6CWiRZ1baM4e9/1WfNSh21t0KUA14BdXmLrvddLmiuT4itWKe
         GqOybefLN5JfIfpOoBmtABpRFhDqywYHDNsveBe/4i8K+2rYyetCDh/ilf9Uq3WbBWR4
         KlyDIw4a9tkVExbAehSTPvb2MKxx9B6umFITeZHFMYGixCuJR4YMwSxUebxhp39MBXeq
         ImWayI/x89dN5Am8eyCxob6M2ODSXSz1CEQSPkMDHH3jwSda7fytkHF3TmLPGdysNicC
         O+XdJS+BVDr1YE7feCFua9pJE3xNNm1GCLvzYdaDsVUHgYqlZV6Xcm5euDLuuQENtjxE
         yEZA==
X-Gm-Message-State: AOAM533x4/rhC1NzWDukBhYr5+FnPl6O9owSuUvnQBmLShnO8766RouM
        y66BEi6mBbnk/POrxT9Pflus2qLA8ZyyFg==
X-Google-Smtp-Source: ABdhPJxCkRp/9Ax09iEbNmXDoWGeFgzRB+xob6j6AFt+foeCBKDMokGJYqvKu/wRv+oFLYyVCaAIrQ==
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr4278512wmm.4.1611063403975;
        Tue, 19 Jan 2021 05:36:43 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/14] io_uring: don't flush CQEs deep down the stack
Date:   Tue, 19 Jan 2021 13:32:46 +0000
Message-Id: <e597805f2f3087e81101f25f9ea19ee6afd149da.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() is called down the stack in the _state
version of io_req_complete(), that's ok because is only called by
io_uring opcode handler functions directly. Move it up to
__io_queue_sqe() as preparation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b0f54f4495c7..1e46d471aa76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1923,8 +1923,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 	req->result = res;
 	req->compl.cflags = cflags;
 	list_add_tail(&req->compl.list, &cs->list);
-	if (++cs->nr >= 32)
-		io_submit_flush_completions(cs);
+	cs->nr++;
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, long res,
@@ -6538,7 +6537,15 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			io_queue_linked_timeout(linked_timeout);
 	} else if (likely(!ret)) {
 		/* drop submission reference */
-		req = io_put_req_find_next(req);
+		if (cs) {
+			io_put_req(req);
+			if (cs->nr >= 32)
+				io_submit_flush_completions(cs);
+			req = NULL;
+		} else {
+			req = io_put_req_find_next(req);
+		}
+
 		if (linked_timeout)
 			io_queue_linked_timeout(linked_timeout);
 
-- 
2.24.0

