Return-Path: <io-uring+bounces-12307-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KGuOXMqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12307-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9872152C2A
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 38AE3300AB26
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049E42DEA77;
	Wed, 18 Feb 2026 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="naz9guKL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB152E54B6
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383408; cv=none; b=ZuWRNa6fFUTKwiHESsMatQQn7ypU8719jIO1mvqtnLKuIcgv1PE19lem03j1hD8Bsc6CtM4kjAXETzqDMVNKgvT7j7jGNIUe0uYSiEohWF+HHOXqnPsfciv6tnESNiLsQMrbLm9WieUyK0FuB6oIOl0tzJHiGF/b+no7CNvUXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383408; c=relaxed/simple;
	bh=+aqJRomRnrmWMUSSfZYxzQf2MER3237KWmrHTWqbCok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR8w21bSYLuHMCNI/9WZno6x5akVa4zJeOE0ekfyn3jJuHffOA5aHpI9CeGVQoKdN5BU+k0S9QLicRNTEMjNRhlSKXQptQNi0bnILLF25uMkzII+0ZoP+hIGOoFh3qMmFb54Xh12mVMuvbJfhgUucjB1NP3HZgATdPXsAyJPP4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=naz9guKL; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-824a3ba5222so2738786b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383407; x=1771988207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2ZpeTqQMuFa8qkD/4o2zLQJD60ITtT9pnlvuSB63mg=;
        b=naz9guKL1BpA/xQO4UjbwF9R+G2RDrFkYeu6PfXOCvxU3FWa1J/u96i6+0+sCUd7/V
         BxD1G65Pim5xkj+ygG6KsL7f6IAT85zcWBSBBs+M+RTTtsSjQ/vy1iabsU2oHtyZkxXh
         MKQenfXMm/6CifcBH13Udm5JjuuUyx5jdhg/zecRvbErUu2i0funwxkA5cULPb6wwJiC
         rBnB/auo6srF+xdt5/ohqg24dvQVN8OC9XzjDu3G7PZFpEQBhAKe2j1A2xA9soUgZKum
         iW7dAs+KoyRic3lladZs85v73+gFw+JUl6XzfGYkc46qo8UU/v53HPk7eTzi7hozzoIh
         SpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383407; x=1771988207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s2ZpeTqQMuFa8qkD/4o2zLQJD60ITtT9pnlvuSB63mg=;
        b=O8lRCGffftEOTgLruQ+LB1waySx1g+EoxenXLxobXbfZULINGG7gp+ykGWfazl3tmN
         p/3kjOGBY7ZG5ieXsTHkqBkQ+e9r+ByHtipX1wDNsbgfJWW9H8w+3WCCMhdpnvUfCQGX
         nhM/D/o5ekWmT2kb2eXiIvyUaTw10LVx6i4JqEnZ5GoqlleRTbbjKxlw497RjlDFw/+5
         FndwsVhYjV0ohXZh5QrsdIEXFl3zEAduDbz71WhBjhDVGae+K7dozxohUETe2XppxQWV
         Rf5TIUKnhvPC+ODYZ1iTXYStnSWZ0IopjpqNTnB+hRuo1KNYwdLaIk5bu3rOQP2Kc/J1
         M3Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUUjaVgaGj8TspyuLfaTbwLupQ7EDa8LebxEYc0K0sqoyNnu6mpHEkOtjOoDSiO0x/c8TiTKWZgjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEDzSqPZyrALPSK8T5IHCcOyJwyz3Q8uTL9ICeke5Y62I/rKxV
	g8XMJq5Sf13GLgt3jsGV77ehag/nMTeKbLxnSCEx6QlX524jJt+XWQUh
X-Gm-Gg: AZuq6aK+7MwI442bR3dGXL55eki+eI2QBsnnSlT5b3mOtRbOySk+pwk9cOIFAyjEih7
	EbKtVA/DmnqAPPzzm8YIVm2YVCI15GfB+gx8mJvmzeWOHGt62gdTUmBrA3rtmbCo/tbcxU8fLrU
	7K7xEH3Mg4pAMMSsmLsWD8g3OWhvETJHzRA9tM7DVcLP0pJ1x6MwTkZPwedEMEqWCt94m7zoNl+
	NjgLNQenNKeQhsgg3Rdx+foeM/POHNfbUTqTdvUJfZtwrAO5Zh1QFOM9+scXWVvtgupcBQUg49i
	7fHje4Hsil1eDOzWdVC3IONWwO4QiBwe7SaOBQGG2SHA8mgyeN/IgA0lcIlrs3/rewxtZHTosut
	DtSyT53Qif5JJtp3uzd+asuimTyNfy/n5x8U5GbIcywxO1Qv5ayrMr4T+x2cnvK6INe1xxcWnB6
	S1tLnVlDQMfXY84BloDw==
X-Received: by 2002:a05:6a00:929b:b0:81e:f623:ba04 with SMTP id d2e1a72fcca58-824d94cf1b8mr13761658b3a.13.1771383406868;
        Tue, 17 Feb 2026 18:56:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:23::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6bb5acesm17151497b3a.63.2026.02.17.18.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:46 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 7/9] io_uring/kbuf: add io_uring_is_kmbuf_ring()
Date: Tue, 17 Feb 2026 18:52:05 -0800
Message-ID: <20260218025207.1425553-8-joannelkoong@gmail.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12307-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C9872152C2A
X-Rspamd-Action: no action

io_uring_is_kmbuf_ring() returns true if there is a kernel-managed
buffer ring at the specified buffer group.

This is a preparatory patch for upcoming fuse kernel-managed buffer
support, which needs to ensure the buffer ring registered by the server
is a kernel-managed buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/kbuf.c              | 20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 5cebcd6d50e6..dce6a0ce8538 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -92,6 +92,9 @@ int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
 int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
 			   u64 addr, unsigned int len, unsigned int bid,
 			   unsigned int issue_flags);
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -154,6 +157,12 @@ static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd,
+					  unsigned int buf_group,
+					  unsigned int issue_flags)
+{
+	return false;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 6e4dd1e003f4..bd10c830cd30 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -917,3 +917,23 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 		return NULL;
 	return &bl->region;
 }
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_buffer_list *bl;
+	bool is_kmbuf_ring = false;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && (bl->flags & IOBL_KERNEL_MANAGED)) {
+		WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING));
+		is_kmbuf_ring = true;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return is_kmbuf_ring;
+}
+EXPORT_SYMBOL_GPL(io_uring_is_kmbuf_ring);
-- 
2.47.3


