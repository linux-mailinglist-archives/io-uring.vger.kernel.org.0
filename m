Return-Path: <io-uring+bounces-12305-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sEc6I3MqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12305-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01314152C23
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B130D300AD86
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EB6C2EA;
	Wed, 18 Feb 2026 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fmvd7iIr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822042DC352
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383405; cv=none; b=p9tN+OWBacvKcYW9oKbqZBPVL2EoBG/cgyQYlpuHgJz35r72/nkEeDLdUlfZCZCjZn04H1u14r2IYlxYRCz7rzroj68nXgVku+Fe2nFh5W8N0R3etJiCxogR9S5NbW4YCYF6C67E0R9xlDyiKOXvcAIftFzXkRRKrY77ArH0iV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383405; c=relaxed/simple;
	bh=k3YS6slsDIgbAWJqQIA3gvIPULA/G3ylVSJv+yCUy7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1lxVgiOZStdrbcqya4FwsFMkB0os2TmWXZz3Pvlsb1VLNucc8zUYXKu1HSzUwWsEWkkS6qMv1FwLRb8sc62mRu2HkbfNXddluteRhvt2W2jcXl0dwbLCOZYhLazgpQMlxEztDHv+BBePJCZOuTZQ4+NAdEgfwol8GvwDb9/vr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fmvd7iIr; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c6e734ba92bso1134396a12.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383404; x=1771988204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LY4BukVtc0LvnvQPXcwLiGkkIk2pXEhWFAmE+in+Qmk=;
        b=Fmvd7iIrlEK9Kv4g1tHyU/ezxyxVvrLCW3ijlDAfhumi9DhrJBS5nLhMvbrPtpjIAV
         izA56YVeWnxRNnuI1yJIFEuGeYSCOOVpzrWElFZqN7ctyp1hUHnxMUAZQsmECibsdAoh
         /fDwRbkK5l01DkUHppwYLFpZ6YUuTowd5OXVwSoM3Zg9aXOte1DjzdaIa+iorfDpF6zo
         AUYlYUAQ2D3Rt60PwsHHBIw1SGKxDngyecrYw3HK7rMmuzvcbFuuLxi48pIMCjzQa9TO
         PvGmwVHRKeozRL7I7EzUFxYEgKkXEd5mtdtuj+BFgXizsRYJSt2n2uMd8/yHvV7fGlwQ
         CJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383404; x=1771988204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LY4BukVtc0LvnvQPXcwLiGkkIk2pXEhWFAmE+in+Qmk=;
        b=I5Waz9f0QwftntCjJiDh9shVZQKJes6cUsQzZf5gH9PYqEtyj5QM3IST8btnHhfpa4
         k6TWeKOtEzx2mBB5Oi4iLZDMb9VOqETuMs4lkbKvxJHvNCATccJ7Fm6t0Vo8h1k0a1ri
         dD7UU+ZnOGqR1D5kvAOAPpRYi2sEdAD+KvUZCwXECTZnP66F0ds2dcqq+tTb8+1DJstH
         cxvK8Sp+mKt0qWKkVgd4/BL+kc85p0KdGNM8C45p0FCyth4f4XKeEKDzpFwOKr5Jxu4J
         7AtAC4gf2JiKuwxGbG6uTPm1p7KpX+hX68OIUaV18tDgOjEZND7rfyBSUS0okrVPMBBi
         8yeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ55HiX6fs1xFpJAXN3WnuZmPDeLniXlAR3kEF/sJtmrv98CiTwkLjl9zyuLsncMA/4U33ZQF5Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzX4hrH3oMaApHdqzxunzAPvE4T6ltXrzdLWbeuzyokxITpz46+
	+PI+vtN+zB2rnNqAu0NbPmVzDGqJuIa9d7qv3qnep+rBMlLwmy/Ep1V7
X-Gm-Gg: AZuq6aJZkG8/FJ2usFzoYt0o8TUf/SvghT3XqP6ZHAkVa0G+Gte/e0cw/TFAVlXJToM
	kz+jdX08/vJZbLD0SwuTbXEyot7MOpAybhc+KHLJ+vYWcTmAHHvd2wdX5FG0ecE41QdD0ZJg5xK
	nTqny3o3OKeD25c8uVG8+0VIQ62mFuIF8U56n+iE4s7xfIRGd8l6GvII75FQ/9qzbNTae2ADXrO
	z4h93UlMwAkMbs6L7e4KfjNfuezYlc5asDEA6ikZkYbUnHO8FHvkmQgWUSASoaBJdwrRBbb+tA6
	zzj7KZD9ppD9cN/gFpA4c0uuUvD67wmJK0az2iyeCHRxFdTGVafb/XfIxB4juLlVHqjUn3L14hv
	rCUHaGXppyxcCUmVsUMKeb3yy+S5z5qIsY8ngQt1drOUQnDuNE5STRB2Q49w5ngqBFnqcOyOEEU
	PKysJ09nUY0D648HeTP1/1jYzr3Bk=
X-Received: by 2002:a17:90b:394e:b0:354:bd08:4802 with SMTP id 98e67ed59e1d1-358450ed085mr10961007a91.35.1771383403788;
        Tue, 17 Feb 2026 18:56:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35886a26128sm417218a91.0.2026.02.17.18.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 5/9] io_uring/kbuf: return buffer id in buffer selection
Date: Tue, 17 Feb 2026 18:52:03 -0800
Message-ID: <20260218025207.1425553-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218025207.1425553-1-joannelkoong@gmail.com>
References: <20260218025207.1425553-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12305-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 01314152C23
X-Rspamd-Action: no action

Return the id of the selected buffer in io_buffer_select(). This is
needed for kernel-managed buffer rings to later recycle the selected
buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h   | 2 +-
 include/linux/io_uring_types.h | 2 ++
 io_uring/kbuf.c                | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index bd681d8ab1d4..31f47cce99f5 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -71,7 +71,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
 
 /*
  * Select a buffer from the provided buffer group for multishot uring_cmd.
- * Returns the selected buffer address and size.
+ * Returns the selected buffer address, size, and id.
  */
 struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 					    unsigned buf_group, size_t *len,
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 36cc2e0346d9..5a56bb341337 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -100,6 +100,8 @@ struct io_br_sel {
 		void *kaddr;
 	};
 	ssize_t val;
+	/* id of the selected buffer */
+	unsigned buf_id;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1d86ad7803fd..d20221f1b9b2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -206,6 +206,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
+	sel.buf_id = req->buf_index;
 	if (bl->flags & IOBL_KERNEL_MANAGED)
 		sel.kaddr = (void *)(uintptr_t)READ_ONCE(buf->addr);
 	else
@@ -229,10 +230,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
-		if (bl->flags & IOBL_BUF_RING)
+		if (bl->flags & IOBL_BUF_RING) {
 			sel = io_ring_buffer_select(req, len, bl, issue_flags);
-		else
+		} else {
 			sel.addr = io_provided_buffer_select(req, len, bl);
+			sel.buf_id = req->buf_index;
+		}
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
 	return sel;
-- 
2.47.3


