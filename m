Return-Path: <io-uring+bounces-12758-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OJFIE9qvGlQyQIAu9opvQ
	(envelope-from <io-uring+bounces-12758-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 22:27:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7812D2AA0
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 22:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5039E3212B3B
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 21:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB343F0777;
	Thu, 19 Mar 2026 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nVtJwNCM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8F3B774B
	for <io-uring@vger.kernel.org>; Thu, 19 Mar 2026 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773955404; cv=none; b=RLLRdmZDdTNJj13YDqk4sIefQJekaWM4UZVDJ//TnZf4I4Mm43PJC0hb8Y34zn4zHlv5CE8vQC46aSgVWHSYgWESCp98iu/Wqqz9qTePx4+kBd4TY6Mj2uN1HR0yyZWEpcgBZqDqTDXBLGo17+Ul7c+udFWlul+gTEO8ndyn26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773955404; c=relaxed/simple;
	bh=StJfLB9hF/4Lxg7xG9mSwfOFdap+/YtChcudW6Umfj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZGkgh1XzaDvcWslRc1HOa19XbmgecdymJ12fUzXQ7lYcZSL6/A+jctsYJcrGYv1elzlxkYo1w/Zr1ufiDS9PO5X1yj1KTmPojSfLse466AxOC8U5rczoCBV1y9AXW/3kwJdrxcYQdVORqUVWqWMJVj+TZyTRUE8fmf2FPWsgnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nVtJwNCM; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-40429b1d8baso459655fac.0
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2026 14:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773955400; x=1774560200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IKxWJXPBsb1pqKefO6RKKySVkGscxQ9SCqJ8fzyBdCM=;
        b=nVtJwNCMpUGTmkohFubcH5NYt3Oz6DVQ3e/kIKNsC8ce/2SgmUafp+VeTTwmwacHZ1
         4NQnzDEoKH/OUzK4KwWdljshaMyvirJQWgBVvuRYKSczA7r0Muzg80kfwdWvkVkZguxd
         T/gRMv0YcHPUk1v7Lt05BZ1AOUMKJAKp9M2AQZAwzYeS9u4nNRoA9d9KvSiGgVVlH1oy
         E7P8OLQ+bkDhqKQbz4OuDuL3eklX0TZjtmsSa9BbPQOwr+MbPKsH5LoSgXzRtxTN+sEt
         0XDHgYeWOGTtgH4V/t5kCtDW3OF0zmX6WB2UdqQaIPbLVLgpnj6Mmq2+68bxLuGFwOcZ
         mB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773955400; x=1774560200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IKxWJXPBsb1pqKefO6RKKySVkGscxQ9SCqJ8fzyBdCM=;
        b=ZjHlWoHdsHCh09UIeKQ7V2KsS/TSJpPrBNIemZGdTVHLGeONulqaJdP4NSJF7dhH1d
         lBq+dF8MdqND/SX8f3qbVrTvoSDM+fQGPamtb8RLnHGJs1olXcZ8d8FJpm3SRLJkzh21
         WComDmOdFICG7qatmSWc1noh9vjCRHhLA9k8hR4d3eR12x+Q19xwUW6IsG9vesezrQkf
         crSJXCO3ZrGv3pt8FLPzZgC8EmVugY5H1OJZzlYSiP74ubK7GJ6CcPiwNsmFvRg0iSjA
         ta9QQr2QV8+VYh5AiFtQoJC7Zg5+gAY2rmmWx4IawNESid9VSnXY2d8zUqcLG5HAXmO8
         TBeg==
X-Gm-Message-State: AOJu0Yxhdujrhb5LJEyZ697E/gaSnYWQ105R17ZZ6JJ0teWK5U3TIZAD
	jRxbxR0KaMHjjqNfpNjGD11/hK8LITZUVJGRE2z0iflZc8p8RKfwQwYRS61eCiVu2HBAN+LsDkU
	5IHfBmG8=
X-Gm-Gg: ATEYQzziwpY5N9ib02A3HMvr1MKNeH1hdrx7bozaDb18CIMwtpiNwRttuywySLIH+Q1
	pfbtP+7I9tzYQhlnJhTvvx/hURLi6fo/tOE4Ak6bkTJekwyhtO4NT2y9wzv/3iXL3m3UDzAmFyK
	AZZ9bZtO2oaM5WolrR4fo2dPGa3x5rUro6XQwfwyexsMXCMsJCg43PaFNF9AQe1jK7PqF5U2W5f
	ujEfHS4+3WmutX689s6aANfHPGJudA93lWfvpkwyXfOmmmi8G2kVwgzbp0q79fQVvFXtJxFhI8S
	eRd8uy38CDyLmLaRHWgtZVAjGMeARTeNZ6Z9yXZiKwXAx1L/rEpv8um13zabBWNPzRW+iFyhktc
	pysrhlldTTN9bhAjsAN9X/uIIRp9mT77VtKeH1OHsk/JsdyhTL2jLtdFo3jcRSITLH8I0wayLnZ
	jmmDjgCEnS9+wzV12dR0y8Jty3BhmTkNLjPYG2ktZB+s6PYCtylzx0/b94Xfjn+Xrg4Ek=
X-Received: by 2002:a05:6870:911e:b0:41b:e9c4:9778 with SMTP id 586e51a60fabf-41c11179184mr505000fac.32.1773955400265;
        Thu, 19 Mar 2026 14:23:20 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c148a5ca4sm186363fac.3.2026.03.19.14.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 14:23:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: code@mgjm.de,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring/kbuf: propagate BUF_MORE through early buffer commit path
Date: Thu, 19 Mar 2026 15:21:36 -0600
Message-ID: <20260319212309.284152-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319212309.284152-1-axboe@kernel.dk>
References: <20260319212309.284152-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12758-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.990];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mgjm.de:email]
X-Rspamd-Queue-Id: EC7812D2AA0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When io_should_commit() returns true (eg for non-pollable files), buffer
commit happens at buffer selection time and sel->buf_list is set to
NULL. When __io_put_kbufs() generates CQE flags at completion time, it
calls __io_put_kbuf_ring() which finds a NULL buffer_list and hence
cannot determine whether the buffer was consumed or not. This means that
IORING_CQE_F_BUF_MORE is never set for non-pollable input with
incrementally consumed buffers.

Likewise for io_buffers_select(), which always commits upfront and
discards the return value of io_kbuf_commit().

Add REQ_F_BUF_MORE to store the result of io_kbuf_commit() during early
commit. Then __io_put_kbuf_ring() can check this flag and set
IORING_F_BUF_MORE accordingy.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/kbuf.c                | 10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dd1420bfcb73..214fdbd49052 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -541,6 +541,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
+	REQ_F_BUF_MORE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
@@ -626,6 +627,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
+	/* incremental buffer consumption, more space available */
+	REQ_F_BUF_MORE		= IO_REQ_FLAG(REQ_F_BUF_MORE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
 	/*
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a4cb6752b7aa..f72f38d22d2b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -216,7 +216,8 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (io_should_commit(req, issue_flags)) {
-		io_kbuf_commit(req, sel.buf_list, *len, 1);
+		if (!io_kbuf_commit(req, sel.buf_list, *len, 1))
+			req->flags |= REQ_F_BUF_MORE;
 		sel.buf_list = NULL;
 	}
 	return sel;
@@ -349,7 +350,8 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
+			if (!io_kbuf_commit(req, sel->buf_list, arg->out_len, ret))
+				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
@@ -395,8 +397,10 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req,
 
 	if (bl)
 		ret = io_kbuf_commit(req, bl, len, nr);
+	if (ret && (req->flags & REQ_F_BUF_MORE))
+		ret = false;
 
-	req->flags &= ~REQ_F_BUFFER_RING;
+	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
 	return ret;
 }
 
-- 
2.53.0


