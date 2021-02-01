Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03730AFFF
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhBATEx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhBATEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:35 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E02BC061756
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:49 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o5so260982wmq.2
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=C/PxhfTZ6vuIggcQvtl16VOk2Brhql0jQl3GO1QbO7Q=;
        b=eui15w0xH7YHwOWdc9PhMrBJIYQk5RNwykeAcVpPwT9HXaIx4fnYNq/zql4o7/mwDo
         +OFEz9pbPtriFkA+aUBXgZG/Sgla55qXOldHwATkaBs7VQ7i15B3X4cliOacxAMMbL8R
         y6Rpe9ptr5Jzg4tqJLflD8ypdDZDDGbccPmOhMdGeFVNsv+SmM+PT5HQO8H3577n2QLL
         0rHs4SbleFgiyRpFJyHW7FyVZOW8TZXXRtf4VIKFIo98g+36mic0mSJeTXmbqFUxmnYN
         /DZ3GqKBY5iF3Kv2gmB/VJgUNrjWPUfElfErSaTs49lvPKmCN5YcgqqwxocWON+SCgfj
         rFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/PxhfTZ6vuIggcQvtl16VOk2Brhql0jQl3GO1QbO7Q=;
        b=mG+O1YrxkphOUnJhDM1f1kZ+WP7rVDD3C3s+Rm9KtYEGiNQ22vYr9gQq6VZii2HwWl
         KwKQpVsHBClngRRkR7dOBQ6gPpMimI3ldyBntYfpQDe2Vu6iHBU52VJDQpk+67GCgS/I
         OL31J72IS9SEsXeaCM2aGRUTdfe625yW0ZOE1Pq76obYSO9f/9cUC0GEayvbtpE9APlD
         oMqNLC59gLrR5jQyg5cxoKizJJRH7JyY8RrcGp0MLvll7oKztBl7bO9w25fg3IRrbWBb
         mvX77Gmf4H4TNRtyCI0ualDoVq6rVfidpNfGzjh+WqwH7d9SUFW0W3J08PAor5aJdsML
         qXAQ==
X-Gm-Message-State: AOAM532oSE0Xinb0TVjrqkNzTuDhFBcd+rSXpFDqXorsQ7jVsS34dsCq
        yAEuXVDa2dVrAdnrtN7YJF8=
X-Google-Smtp-Source: ABdhPJwI/nZPtcVB+SqtdxLl3UOJYkWU/2fab9bfOyu8bZ+yU/toWnXpoO+w9uYdrXGT/2tEAQhBTw==
X-Received: by 2002:a05:600c:3549:: with SMTP id i9mr282161wmq.47.1612206228097;
        Mon, 01 Feb 2021 11:03:48 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: kill not used needs_file_no_error
Date:   Mon,  1 Feb 2021 18:59:52 +0000
Message-Id: <41da065c3de7989a9194c4cc3fba815e49d3a576.1612205712.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have no request types left using needs_file_no_error, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3252ff6542b..bcd623512d17 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -788,8 +788,6 @@ struct io_submit_state {
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
-	/* don't fail if file grab fails */
-	unsigned		needs_file_no_error : 1;
 	/* hash wq insertion if file is a regular file */
 	unsigned		hash_reg_file : 1;
 	/* unbound wq insertion if file is a non-regular file */
@@ -6896,8 +6894,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		bool fixed = req->flags & REQ_F_FIXED_FILE;
 
 		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
-		if (unlikely(!req->file &&
-		    !io_op_defs[req->opcode].needs_file_no_error))
+		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
 
-- 
2.24.0

