Return-Path: <io-uring+bounces-12303-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANUVAWwqlWm2MQIAu9opvQ
	(envelope-from <io-uring+bounces-12303-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF45152C0E
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EF11330054F4
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987972D46A9;
	Wed, 18 Feb 2026 02:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqA1+llO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE1DC2EA
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383402; cv=none; b=O9dXOa05J0xZGlYDe5vwsDTH7waG0a8DPonhIlRzpKiEUg2FFW1lWj8eXSd3/NqdE1VPD5pkr5kI8zM9FV7uh/kiH1iGr5mdupOhJPsJJV5wmlCjx4CBw+BjvfUHPek/C0ef4x0mz5oqpWYJNLqRBYZRCq+j8XbtxqJ4Jqv+FM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383402; c=relaxed/simple;
	bh=EYAPGTHsw3IhIUfQMyvZqHgWgkQbVynWRMq9L8NWRhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcArdJQQs1EfQLaRnaJKqud0fSjel/cy12Cax9VGOjz5obcYWQWaHO6oJ2g+XbKQ/+8BsIT1zQyfihMARqW3PMfzDHW1AxINFYc+ScSpe/aXCGUXTb+LXlGttE+WNbRx7zrOF1KhLeVB6Bzwn0I3f2B6HAn0nIXR6qOd2lDK8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqA1+llO; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c0c24d0f4ceso1917522a12.1
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771383401; x=1771988201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q63o83JHUThWKZ6SHfX9QHqS5S8vEJvsA/Xe1E/aJn0=;
        b=RqA1+llOAyZ+gnPOqkCX4+LyVMChJYJpLRjvjtGtfTO3huN2awjnfv2eaa8yyrcjAQ
         fqfotTdhBitCXL8NKo6fTJxQiJaC5NEqpmHrOPXMWyl4xjOOHzrAT4tx7xJW0/X2tzRu
         XXccs8GBAbySDvZv3hsUDor5fWkwS9M+pyRnfgRnTWp+pPxhepl5G6/u2iBXFAj9IVsr
         p3c4snHYX0KHlMZ2Dq+EZRMZAPvrf02XKL7W9mIjdX/YIYPUCm99q1B+htN4dad56Ycl
         I/xWL0zE0VDCUyh1gwh8mZhYxqoI0CdhvU71yLtWNCHMMz6RQWwDsC4Wf5YDA361UNcU
         2k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383401; x=1771988201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q63o83JHUThWKZ6SHfX9QHqS5S8vEJvsA/Xe1E/aJn0=;
        b=XL4onEkFRz0lY5gDrJeWTVIBmzfY+w7CY5o0FQrVyx9XocWsbH3+29hQAlOKRGAZSb
         EmOFMHeBu9RhspYS6k/qlfh40Z2BlXEDctdDmJCA1OJUOFWdUBEdZOFcAdQJqPsMSEGG
         SC06yyH2AhSReajyWPOrKpcO+8ecXjDwYnubdNRLgi++Nx9HW4KCZXEH4IMFI93id7Yi
         HPlGBrsUtLIw4lsWPZfnPlkAJY18bTJomZAZctrsRkP+uZhRcwudPhp9mB4lY7mKVryl
         sK1WDYR8C2hpAbroUQzDTTUdeeAwP5ZKu/0JwKt+Mt0uyOt1QC3STQwg4hQwHprjO0r3
         wCOg==
X-Forwarded-Encrypted: i=1; AJvYcCUDUUGNCVUviKr1yg1WJDwmP+K7S7rqhmxy43jNaKRSj7hMVVy05ZC/CAHgmvmw/JF0YtkI6Y1I9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhKyy7G8+GDEpEzuSajhw9hJUckUX509XkUbv0IuUSI1C1CzCi
	6njm9bk+EHNEcPfh4VgSF54/j2EdosVb+j3bYvCcCssBI40RFlpxm/MK
X-Gm-Gg: AZuq6aJlwB90Dk3Fg6pt6va0nN9t/oWvcE2RxWIv3nVr5oH2fBp+s51geygUv6JS0zo
	t89J/NxMTAhWqrL+hURwGA9WO7rebOm/aA89X0Wl0tH3DSVvQ4PHaIScTLaFkplKtcMNK2sgHTO
	xtYyLZuOVb++nJkTLNtKo7boe1rnkr5ei3KGyVgz3HLkKFRHI+TcaMzBMirL6FmzO6mLwgTnhIz
	68YvKQ9FzbLkki4kAV0E23TYGJBropvnBPjymZnoehjdpNVaojaCXiAxY7uWlfP1oQnoFYWAmN5
	mMSIjrid2LaihZEckaAay6hewXf7C6mFV+6OmLZS6jGzfvI3DQo4p5SzPYXwn7p2ckBb4Y2ccdN
	PvdUiQSOk1Nc9rGqnJSTM6he+VacX7cSgG2okNNclnD8YzNIEKOgbh8IEXOFIUzxDd4n9eNqu3T
	pzPd6unw/3ecuR4tuglQ==
X-Received: by 2002:a17:903:37c8:b0:2aa:e6c1:cea9 with SMTP id d9443c01a7336-2ad1752fc5emr113430725ad.50.1771383400706;
        Tue, 17 Feb 2026 18:56:40 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aadca63sm116042745ad.69.2026.02.17.18.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 18:56:40 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com
Subject: [PATCH v2 3/9] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Tue, 17 Feb 2026 18:52:01 -0800
Message-ID: <20260218025207.1425553-4-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[purestorage.com,bsbernd.com,infradead.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12303-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8CF45152C0E
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
index 816200e91b1f..efcc6540f948 100644
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


