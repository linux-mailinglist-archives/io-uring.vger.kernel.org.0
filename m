Return-Path: <io-uring+bounces-3814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C46649A433E
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 832442844AE
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68610202F68;
	Fri, 18 Oct 2024 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJGe6Jyh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFE520264C
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729267642; cv=none; b=TyJD9GQnSlJkCGxIQEvfLdpkTipBbwThP/HYCzQh/Uy6zs/2rQfMODsEfMSx0BDuASo5H6FFnLfvqIb2VnYcnF/I3o06tZKszFis9tKk1ta4BQRCIoMeIqF49lsdOmqnrvMwTRMz0BaMN6mL6ihxqoCMJe8p5Fl8OmVbg9Lvqco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729267642; c=relaxed/simple;
	bh=gRdrPgX0GAkrTlNyXcNZPDgzn626DGx5r/iPSkrMc+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jb+MdoOAfX23004llywDB84NEuYPgr/ClW6HQ7dP09KDup1K10z+DJzYIUlNxFg9QBm3SeOlKWOSCgRlkgOneG8WfSdwD2yqh9xhxKLj6p/UrRngaZ2ihunXTX4Q2a/uujTCE0ZZ3WDqXmLbZrRdu6gEyIKfWITnvL2qioqYnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJGe6Jyh; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c99be0a4bbso3053918a12.2
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729267638; x=1729872438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+yAva5ygIRL7tvhmwR6p1iZ5re5PSdZepgryzQRGO0o=;
        b=XJGe6JyhFe+SXfPk1ki240oNmY0qwXrn8CNuZjDgoa2eqrUOePdsTCV4WVEb0zjpjK
         tgilbmQS+rjgx+7R9/p6JnO3j84QAWFmuxYnfOv50FJD1zE5wXX5sfClZGlVIPVM2WX8
         Qx4quYeBRDuO9LDg4Ssr+BK8BAxMFB7Uj0J+kUvAm5Y3MOcP0N5SIWjKXuGzkBxR2rF0
         75TwHkpLlkfWuNQZWJks2xNcvdmB5uM4B95unw1J62ZZLRvlclsE7wmhYR6X4+CBjOSa
         A7SvXL3pXv/o32qxrbKuua+EefbZHLKEp2xeIwboWVpoha+5ecjW0V9HrZ9aHaH12zkl
         7s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729267638; x=1729872438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+yAva5ygIRL7tvhmwR6p1iZ5re5PSdZepgryzQRGO0o=;
        b=n35mqrUNz6Sm0H63TOpZ0hgjEzeJsVMqVCNBToAs/3+gMDjJcFsbNdIa/upudnao6t
         Bu8svwAXO3GOiPXWzdiYc4OTIfpELEJoYFYBnyWVd1WjjVBdeMt93vsAm/ggMv7mXUai
         qtaf2OsVeR3SfuDTTP2JJkIPQW4mgu7u8u/Alc5KPzAHIM2/lvAFzalMUq2zpDVfEio8
         jtf69LiFVD7CEbTohoTGPxWbXVEmI2H9iA+SISHx5TEzmBNSUDKbj4oYOKC16+f+yQFQ
         bnptw8SZxUbUr4Mt/0GvV8NWbb0xNd7ANqno1fgV8R6vE7GTfmrl9f8bE85QZ5dEbpeP
         0icA==
X-Gm-Message-State: AOJu0Yyrzu4d6fNvdsWYpyyu+oLQEx8kcyNu2oFT6DoERXXeiovY0IwO
	fvajW63X6AlZ0oL3wCY/OSsPpdo7XhXrp5OY0RSGb6qdTMfZVwnQWnSMyQ==
X-Google-Smtp-Source: AGHT+IFxKbaG9AKZfGNYnN4+vpH6M8CU0CmAD8yuJuSxBb58ZkzPCwcYTBrgPwBaX/Ov4aPvsio4NQ==
X-Received: by 2002:a05:6402:27cc:b0:5c5:cbfd:b3a8 with SMTP id 4fb4d7f45d1cf-5ca0ac458f6mr2199579a12.1.1729267637958;
        Fri, 18 Oct 2024 09:07:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ca0b07f601sm885594a12.22.2024.10.18.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 09:07:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: kill io_llist_xchg
Date: Fri, 18 Oct 2024 17:07:31 +0100
Message-ID: <d6765112680d2e86a58b76166b7513391ff4e5d7.1729264960.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_llist_xchg is only used to set the list to NULL, which can also be
done with llist_del_all(). Use the latter and kill io_llist_xchg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b2736e3491b8..ed34f356d703 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1076,20 +1076,6 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	return node;
 }
 
-/**
- * io_llist_xchg - swap all entries in a lock-less list
- * @head:	the head of lock-less list to delete all entries
- * @new:	new entry as the head of the list
- *
- * If list is empty, return NULL, otherwise, return the pointer to the first entry.
- * The order of entries returned is from the newest to the oldest added one.
- */
-static inline struct llist_node *io_llist_xchg(struct llist_head *head,
-					       struct llist_node *new)
-{
-	return xchg(&head->first, new);
-}
-
 static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 {
 	struct llist_node *node = llist_del_all(&tctx->task_list);
@@ -1311,7 +1297,7 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 	 * llists are in reverse order, flip it back the right way before
 	 * running the pending items.
 	 */
-	node = llist_reverse_order(io_llist_xchg(&ctx->work_llist, NULL));
+	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
 	while (node) {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-- 
2.46.0


