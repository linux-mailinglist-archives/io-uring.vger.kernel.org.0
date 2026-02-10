Return-Path: <io-uring+bounces-12119-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OC9HKbR8imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12119-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FB2115A3E
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8245D3038A40
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023E0235071;
	Tue, 10 Feb 2026 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilqoJwRW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C775019CD19
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683508; cv=none; b=FXXg5QzuS3Gl+53ANcHVWCu/nWrJGTC+j2N0dKWc9JDfNqK0CWygUWzaL/HUhNKv+OTwj8rkV/dJDhz+uCmLQIt4kF6QFYeijyXiLPdTLgPK90qCcK0AfSo+AnrTMIzskK79/5GaCbqcKafaVVMel5ufvh1aB9nV1Oy7MmM9QtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683508; c=relaxed/simple;
	bh=ko5qf49NJZyN8n0RgrlQ5koyiabGsEE2+6GI5bai0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWNp6pXS3zfdZocrvB5nK4wWwetWcWgJCHEw/u2kqK70bo137EMmqrP0NTYK3wqkb04CPcjEbXNkr1vqL8npcj1VdZCpmU6opzBj7DTTBHIglbHpcwvzqT9HPiq1+JXya018jhvHJSwwJ01sj6kEN7V1Y2U+wIHJM69pzS3GKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilqoJwRW; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a95bfdb31eso13610955ad.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683507; x=1771288307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQDLZqXE3BcVNZzVpuMd9hJ4u9LazHZ6EFv0AmYNj5k=;
        b=ilqoJwRW/AJWSf56nl8y3LY1OBsJfh5ExQlyyrgNE03AOfl5AYytLboak8emsLJG9g
         35MW+foeyjlA8NoXl8zdoiEL4+/7qU5lnSuU9YE3C1LpQzmHnJ0Mst6hVPJf05EkRjk3
         +9DIUu775RpqYeI8ojJBHTdnFmX0TdEKO9LzR0aMYC7qKewkzLF/lVBJwHVd2od6dIgY
         F7q+lNWhS0zd45NqmXh4DcQTmvIshs/zl6PhojmaiF7v5AhderG66P4E9F7gttI/qiLM
         P4AwyfqaYjvb22+QEGGLcH9HUvRNQcmxhJq5G8M1O4k3PsNcuOqROvZuDgWymq+NVmC6
         Kppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683507; x=1771288307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oQDLZqXE3BcVNZzVpuMd9hJ4u9LazHZ6EFv0AmYNj5k=;
        b=FmOM0hCAJ1CLxyev0mWpzek1IYoDAjOhZKtoKYySMNEHj74t443/VqqUfrhsJ9+Wcu
         EIINa88DBrlDk4r34/BFm3miopTb+/5zwN4QZSYJgVCf4ksWQDKnxjJ2Hsb1t/7sM2Gf
         X6pdddRauALCLSLPojWjbLb1xCwIyk09he8Y/mUcmJMLRdGbb9ajM/NpOAZ0qORdsYE0
         5whXgxJbXC/zeWcD7FUPEQcdLF7q/IyB1Vq+2L65A75ViKAG3n/+0SGGiD7AGpqTPDSW
         PjxjltYv/wP4SK3BlW/oxDjEehusiRUTGKUN9m+LxPH1tgxf40KEyQxtkUdXhPKiOeEQ
         kfkA==
X-Forwarded-Encrypted: i=1; AJvYcCVaYfgi+kYUM3IdJmUdiss7ooirkZhLUtbA+3yaULn9ysh82bct1unrZNK9C8fsm/+ufjmvXlxP4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDeZXtKhCL/ugN0sZc/l/pMEtVwiMy2H4neS4JhjHP8fv+uer5
	oyPAzkzL8igmqdaX9eWRJ7bLHsC+2QLEXs5M1QHBeDWZJpXk20BhHecb
X-Gm-Gg: AZuq6aK0oK3qiW8BIOIoryJ6ELgAtDOM7Tztsk9HJfFNlGUS6zCqSp6MeMzU23koSJO
	fksgcNSlMy3hTwiryD0k7EwCTT70kzRYHylqONrkvSBPHFX5H/GeuwTf7WH6flRvp4kNaB9xOOB
	FMvI5hBXNlZRRymLJzmqA2hRi1ucjxHg/U6m8vpxU2gghZnLlqYFHTFAmNskqwUQU/bYSQaPWXg
	g9/HTKabA02TOKcS7N2aWS+Hw18qEJ3QZlfTnHtBf8S/YjgWFC4a8+XM89259fRhvzPU9jEnckO
	YSRBFWymp7Cl8Ik2F6jOgC0n3ABkhDlDIaT9XZL+9j7l/PY8tAk5qIH4Edn6/SvvlJcM3KxQQ+N
	bm5RjECKX2vVBexlAs+woSAPV3NViiBcvudH+G8j0VVWEYhPxu3ZWXmCPGnCdL/Da/zvvCzUw8O
	u8KC/f0cDO4hjoGktidg==
X-Received: by 2002:a17:903:2a8c:b0:2a9:327f:aa2f with SMTP id d9443c01a7336-2a952166b89mr147756635ad.26.1770683507006;
        Mon, 09 Feb 2026 16:31:47 -0800 (PST)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9cb100965sm84878985ad.78.2026.02.09.16.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:46 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 05/11] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Mon,  9 Feb 2026 16:28:46 -0800
Message-ID: <20260210002852.1394504-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12119-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47FB2115A3E
X-Rspamd-Action: no action

Allow kernel-managed buffers to be selected. This requires modifying the
io_br_sel struct to separate the fields for address and val, since a
kernel address cannot be distinguished from a negative val when error
checking.

Auto-commit any selected kernel-managed buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h |  8 ++++----
 io_uring/kbuf.c                | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e4a82a6f817..36cc2e0346d9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -93,13 +93,13 @@ struct io_mapped_region {
  */
 struct io_br_sel {
 	struct io_buffer_list *buf_list;
-	/*
-	 * Some selection parts return the user address, others return an error.
-	 */
 	union {
+		/* for classic/ring provided buffers */
 		void __user *addr;
-		ssize_t val;
+		/* for kernel-managed buffers */
+		void *kaddr;
 	};
+	ssize_t val;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ccf5b213087b..1e8395270227 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -155,7 +155,8 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
-static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
+			     unsigned int issue_flags)
 {
 	/*
 	* If we came in unlocked, we have no choice but to consume the
@@ -170,7 +171,11 @@ static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return true;
 
-	/* uring_cmd commits kbuf upfront, no need to auto-commit */
+	/* kernel-managed buffers are auto-committed */
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		return true;
+
+	/* multishot uring_cmd commits kbuf upfront, no need to auto-commit */
 	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
 		return true;
 	return false;
@@ -200,9 +205,12 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		sel.kaddr = (void *)(uintptr_t)READ_ONCE(buf->addr);
+	else
+		sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
-	if (io_should_commit(req, issue_flags)) {
+	if (io_should_commit(req, bl, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
-- 
2.47.3


