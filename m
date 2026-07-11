Return-Path: <io-uring+bounces-13983-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XLu3EvYfUmocMQMAu9opvQ
	(envelope-from <io-uring+bounces-13983-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5A974150F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ksuGP1nJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13983-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13983-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 678073008FC4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468803C1414;
	Sat, 11 Jul 2026 10:49:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B188D39AD34
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:49:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766987; cv=none; b=cVTZDfhrq9Zb3ZzH8r0547+WRN50rOy82D5sLLKFZfqyaJdBOjTo5Jm/HVsB/8adjxltH6aTh76Iv9Is6M4x+RTm5p1AbvenBsywJygd2VkW9OPDtVKfg0Fc6mkO+IOfkds3PmwsdR8uGYsBWjvTyOin9Ndb2L5lm0UulMx7fPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766987; c=relaxed/simple;
	bh=bt1fjQx57j1sUPSIKU54YXB3emwAGpiLG3SIBERbcvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkYb0A8+GMayB0XO9nxYK5PBolM+IEchS9iM4v2eEJ4qng9UkKePCRUvA0FeM/9JUdV0hA+tOZP3X7pjOwGnaGz0WrpM/bhsxoxaA/pYQ9ZdVBT55oku8SKjQd/1kRzU+OnEzKNdhmEukIxElkYplTwRCbFYqDxjnNC2zLBi/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksuGP1nJ; arc=none smtp.client-ip=209.85.218.51
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15cd3fd760so208382166b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766977; x=1784371777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=ksuGP1nJKSvWps085DAtTwve0qPyQYZ3/cIrVnF0f04FcD03CJz2oA+LXFavSyEt9S
         el/zOZC9rtIfw2LsST+CrDDFYEmhh8xoPDmRJ8JhVBSwDNHsc+H5b1bF4gr9+N7IaTcH
         iEli7Cqcu+jhZvyyTqK7Bx4zUgJfBv6ce+wtUEMBGjn1qxwtZu43bU0laQctAW2Vo8XH
         7dr0LP83Q0jq2GI+uYL+/C4rupLsJ5XJuHmEmeO2EOHTMLw4bEJYJnpbx6W3ydOPDeR6
         U+0alT0reM6YX6SIYda1UHAnAus1ISkwbF6jxmvt4koIDHUErbTm66PQAMd+4gPOym25
         NOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766977; x=1784371777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=o2QRk8lygY08Cn+7Wuat70RgJB2LMW1bH7WAYF82wvJlt9PdfM1RQi/b8eW2SGMMSD
         tT9T/ZPWJWRCsfTDEzM774FB5f4j6bwGdQ2sR8yKRrcji5hPXd3wxHAI41TOI8vKP3ZY
         6oX4iLWrpOq84iJG/TxNYaroKJx9iY3Rj7gNNkyxdDuIK2mvTSgfPHxO9x2CyOpzeYpC
         G3BoAxBDtj/i1OwURjgEjzW8ud3FwQrJzS+6rwBbpZdoET5jbNY2oaBIWajaSVnqRs+f
         2RBPNuvPXnZTnxwgDZOYq8CJC2MCmt16brrvoNIMGhfl/UspKsJRGhZbTSD0bfseSjGj
         NpCg==
X-Forwarded-Encrypted: i=1; AHgh+RpbcFxG6xtK0OCueb5S2NdG7K9iuFfLLC3qu0tQmnqjenbgt6DpOiQlA5Dlnw8fU7bLN4/pcJSV6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk02kN785h/x4IG4n96TWtFKIjWaFTyErW4dDWbePjNzb3jpKk
	mOqTbdmeYWAN/n5pKCHXljCZ+QyHnmIDtr7tZASu22QMQxWEW+ip0bbi
X-Gm-Gg: AfdE7clq+4iUC2aNogDrYIcVnw0bWY5hUTSx7492IjDcT1RYP0zMf3C/ixMo5MD7EBH
	41lIGqhr3/JDsLNLa6Jv11pPU0Aw1tB/O3+hE1wsDqBiwqaqzVcfzNo7yvLbY8oEVxW2toiFwrK
	v9yWeEuhxy2Tyb7lZbXYDXcu5b1WatVWYuHDC3GUflXrE/0Ib5sRoRpPSFvbKXDFRrMRmwqNc4G
	ncuyHJNLgKAV3zhD/x5ZqcJe6JEdSwbdHT0s/zGNd4nUo084spyiFcNX+i9+S180gmtccqmemcZ
	g5ItRZkdJhZWHdtqz0bWHfGXZrThRSQyEuxZHIja/uDyugkQMf0L5y1E7k+CMJ8egOMd9XV1a7z
	FXYb8izSci7Gdyq3ZDG6B00r6ctWDD2DXuODDfsUWd98fedtnNkFyczkpRtwsAfEUMoz3khTipC
	xWI3dDiC/bHN4oY1cZgnRnro6RG0i+xvhG1J8WmvaLrfiRG6oziJXpMbWHySl0kPhRvKm/Yo6Fo
	CYWkPwIMDC+BKX60YyS0sHi4Uc10eDw61HGXWA+cby2gNQEfQ==
X-Received: by 2002:a17:907:e1d2:20b0:c16:1df9:6ed3 with SMTP id a640c23a62f3a-c161e96050bmr56339266b.16.1783766976606;
        Sat, 11 Jul 2026 03:49:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15beb53b86sm609123166b.25.2026.07.11.03.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:49:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 08/10] io_uring/rsrc: add regbuf import flags
Date: Sat, 11 Jul 2026 11:48:37 +0100
Message-ID: <f7ca7cb5c47f6171f1908bbc7faab71ced19f150.1783614400.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783614400.git.asml.silence@gmail.com>
References: <cover.1783614400.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,mojatatu.com,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13983-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:netdev@vger.kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:jhs@mojatatu.com,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3D5A974150F

We'll have special registered buffer types that can't be used with all
opcodes and need special handling. Add separate flags to control
registered buffer import, which will be used to specify what kind of
buffers the caller can handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c |  8 ++++----
 io_uring/rsrc.h | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d57e8a0380b5..05877b4c0ee5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1245,9 +1245,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1656,9 +1656,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+			unsigned nr_iovs, unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 83aa86e6f320..f12abaf63270 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,12 +65,28 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			unsigned issue_flags, unsigned import_flags);
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+			unsigned nr_iovs, unsigned issue_flags,
+			unsigned import_flags);
+
+static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+				    u64 buf_addr, size_t len, int ddir,
+				    unsigned issue_flags)
+{
+	return __io_import_reg_buf(req, iter, buf_addr, len, ddir, issue_flags, 0);
+}
+
+static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
+				    struct io_kiocb *req, struct iou_vec *vec,
+				    unsigned nr_iovs, unsigned issue_flags)
+{
+	return __io_import_reg_vec(ddir, iter, req, vec, nr_iovs, issue_flags, 0);
+}
+
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
-- 
2.54.0


