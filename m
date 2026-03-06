Return-Path: <io-uring+bounces-12567-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLQqD8kgqmn2LgEAu9opvQ
	(envelope-from <io-uring+bounces-12567-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 077EB219D4E
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 637B4300C319
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 00:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECDB2D6E58;
	Fri,  6 Mar 2026 00:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctO0+n+V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D918F2D3ED2
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757189; cv=none; b=qLkcB02unCS1gxbtEDbadu8EF0ip7ZucC8SFSUlTlHan8ewcm4G1afDxwiIkMiSdbcpXMBSu6lq3rps4HwFjNI7Ukd2fHlZ5PmUy8W833LUdm0aztk4Tj9SXQoWAmS2ou5pj2iMYpV7/3D3+BkQ3YAytx49a5rcBcU+CtEuUCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757189; c=relaxed/simple;
	bh=7U86HvIAhhGhXSoWawp6Ysfbw1L8cF7LBpPXr+cUzy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SALFMxA0vntkUyyPUw5xFTU8ZD9vKEW51RaMTZ4c6F52qVlrZnZ5Kd4Rkz52QQ+G9dM0zTtn12mTLIbUqme2U9HyoK5yTWIIHwSv/PyCnR6R9u44tf6+rsE+9UFzsCdgoxkfOI6HLG4wvCjEzNy+kUWYhmxe2i5bx1LmNmAAebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ctO0+n+V; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3585ec417f6so3459442a91.1
        for <io-uring@vger.kernel.org>; Thu, 05 Mar 2026 16:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772757187; x=1773361987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YLhbQQZzpo60MAweyB3p56v5e9F4gE26cC0pj+WnE4=;
        b=ctO0+n+VpiTm+YKs5p1pjDnI/LAa0bZbugpX4eBotSANH+O7w9BajxsmjWK/GcCdQL
         89RNmnZqdAxaAz/MLaR8p1HNl2RkFu5YOIF/zlVB7ZStPz3u24FegYz+pOVprjRqipuh
         D5ebWnYO1K13PyGNh54ocWw+WLROgRlHtxJ5yuGaIG5znI43+ubQtL5WxXQUci2XxZJU
         DM6H9e48y0QiH7tyc+H8waPSNkgcHk7+Eue4GAPbzE2Z3WU9G9qh7IiSa+YdWzFMY1yq
         oR/X0XH7o7nGq/FEmAsdaQ6+zTZ/5gPQVDNErceqaE4X7fPTEaOKs30FOZOfB0xDFTF0
         92lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772757187; x=1773361987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1YLhbQQZzpo60MAweyB3p56v5e9F4gE26cC0pj+WnE4=;
        b=D7qwa3GDgM4jTHNseW7Y/RrNJXkLwFvbvfoouK1TV2m8ayR4kyAFoFf6gpArCxdSeQ
         Oet9OW8yJc9iPVHpXHN78I8T2vDwweEyz2/2ZJh4oorJUuStY6PdJNv9VHKQ154hshgd
         2MQJthuDDi0f3LIyDsD0oBAMRxblAjW6xjRHo7rzK+FebzmuDpnFGjYt2v1xfKST+iIr
         u5sc0vJusxlTWLNqrXGczFkpvxTnpgjsajBh3Xcr8mvZ3fRCcl6n40QAY/U7LLObS/QZ
         tyM5XkYDoPwmdfkmMZQEHIcofTQ4YLtTmjG3jvxOhbcvZCaM5T/gMH5ks5EGsw0N5vXs
         8ynw==
X-Forwarded-Encrypted: i=1; AJvYcCVSQnhE5XePTlPLP+7W9foFCdiftg7Syb2VfV/vbPIzaUF1prARvkbQDMbNjGeT0zmGC7vG5D72CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKkRj5P1vpLKhJH9dG5FzBr/+Rwj8yr+L5dkc3DHez4A0tAzKs
	caH+UpxCloowTIXg++ZCgW7kLd+4faF1sTs4rE0acmKSDRzrSpissvcX
X-Gm-Gg: ATEYQzxMOg9ch+SE5jgnRMhe5nwjwoeG1mPv0IkcTUp9/USRj4/FkFdwpvZJ3kYrLqr
	75aqrv6Cyqeq6TaWBXY2nql3N/y9WpTCYauNQTWzCQc6PWGGgiey93Ct0hiO0vX0R97doIv0fh7
	AyUOIWpIH5Mtm9Xqa12B8BK8mTAhJHPvtchbmqTtfEPK36rDjM4qWt6fIO4/oCO986DogAuI4lV
	kkhGM5zcPuuU2/0MzH6SQzUqmE5MwJsGxj2KE4d10N3kqvGnUbuTItaZRQR99y4eroZcQuOYCtj
	Z/fiaU+Dpj8KTM+VP8cQv9ig6yPso7Mqsi2nfIUs4i5C0lPf039O1eZTpVgP8/xXwnAPDzxY4bM
	HAkv/sBQhcL/wjWCDcGR4tJzNbQuMsrGeB5FmRxzYT+YouDML1zx9LDg0r5Z1XnXSKBX21MgIoJ
	obNf5ek+3sT6EX6H3D/Q==
X-Received: by 2002:a17:90b:48cd:b0:356:21e9:73ff with SMTP id 98e67ed59e1d1-359be354bc7mr199485a91.11.1772757187014;
        Thu, 05 Mar 2026 16:33:07 -0800 (PST)
Received: from localhost ([2a03:2880:ff:56::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2d3922dsm3132115a91.2.2026.03.05.16.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 16:33:06 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	asml.silence@gmail.com,
	bernd@bsbernd.com,
	csander@purestorage.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3 2/8] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Thu,  5 Mar 2026 16:32:18 -0800
Message-ID: <20260306003224.3620942-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 077EB219D4E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12567-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
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
index 0e42c8f602e1..13b80c667881 100644
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
 	if (!io_file_can_poll(req) && !io_is_uring_cmd(req))
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


