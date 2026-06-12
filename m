Return-Path: <io-uring+bounces-13704-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id B4pBKp5VLGpOPgQAu9opvQ
	(envelope-from <io-uring+bounces-13704-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A0B67BDE5
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AOSBlTDq;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13704-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13704-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C10123003BC3
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7CC35F191;
	Fri, 12 Jun 2026 18:53:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C41189B84
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:53:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290392; cv=none; b=qrbgK2A9amayDXUucg5mLC29jNPt/p/8ptoCrvf6PQbz0hsuSlrq5a0wpvpxSE0F3le9DL2HLtthDCZPxmv+MYEcG0owK/AzoWXxWpefPnGddoUMkgga0onYOQ0Ym9sGKD6JPlGVMVm0adP8YLH/y+IGXo1Ymw6KD5gTFgQHVvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290392; c=relaxed/simple;
	bh=hf0e6TiuMkksbXbkZW13UL+5R37oU3f6PFCW/ZGULuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2gd2FVryaZZ5JNwVtkwW2y8++vkYNr1XytmIr5Db8m+XG4+P1VulCHKyxCWK0pAqwPjACKOGOj9rcJlp/ikGjL9Xkjkt8cGBOEzb0XL0X21c+l4y9Ypg0lHc9uJPDMRb8xUnF2AFW7ShnYLK0SLxcRiV7ZYykEPQGFlPitYpjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOSBlTDq; arc=none smtp.client-ip=209.85.210.182
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-842358aaf36so617863b3a.2
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290390; x=1781895190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B/sH+7Ux0s2B0GwAhc4Jr67atYffFmkQRCUY2HhO/4s=;
        b=AOSBlTDqwwS0BQG2nBiDcToXYkVo9WaHF1TZD/OG6yCsmMKrA5umJjwUbaUhEr1iKi
         6tgll6cKoFuN5OUlm6JARyTwDFUPAuEIksxqXWIp+sVvz6+1Uic2JlkyJK7D6M04A1UL
         4xeDjH1b+wTZf+jWCtFNNmQ8YEx7f6X/MZo4xQjKNJKQom1rxsFqJ+x6/NUrUJaDIA4A
         UDNtS/n45yElGTWE2kJ8x4OAYSfTDAB/FeWd1oGwX94QHyNUVAhdQk4fe21OwOPgPucy
         phil3RlMQ60eI66wlGp64AdhYLyEcM+9eLoB5HayrtYcefIX13E0v0BuEKbZhpSLmP0K
         4NuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290390; x=1781895190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B/sH+7Ux0s2B0GwAhc4Jr67atYffFmkQRCUY2HhO/4s=;
        b=nCdLh2uOG39smq+uM0dtLmk7eic7h8oYdCSNDdjzftr+z58hJWgz1MvE93JkODttbA
         Vt5bHgWufzyf54mkBWTu/zHJZ3W/iy1oGAoD03Xd67moaUZlsPBacfBfJgED6xBdGrdF
         h0dJ+5jmq4AHOEjvrcmgL4H1mgYpR0m00QFolU+KxSi7t4+aSwqdyFvtIa69w/a3kWJb
         ib0br64qBmqg2fjLDr8m1bYuoYRFKbPGF3JBKvPolr6NoPuqhWzav35Nk9PLUyILmi7R
         LakjRgIa4Kn23AVwhNrqUxoigGuGDSlFEhbZ8HfcyqmziaSzQAbRxAiLQ5onXrw4CwaH
         oLxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9CvAarNl0CDlE9S/Imqy+c1S2zG/Z8QWlAth3rcoHWD95mlI+kqsBAqdTdY/7DFB0VummG1p261g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSJyUs52VgzU2+pK/Ix5BOoKMY9jcCDILB3gV5MmAFX4yOc+tU
	Nxp5EJmZVVxCcxaD4tMp2vgOjOeon67SGXCzh7xEcPE05tu0ZFZoyY1a
X-Gm-Gg: Acq92OERDk+3nU9ZoBnuLMBEIGiGeeaaz4I0N/YXejsOtGk04LOGEpuCz+z2dGNyUmV
	5s3hkA0hSsnkk+u8z3ghwFESi7DmC211/zV1e0XCd6X58Zqk+1Ik4rNKDbuMUKQiGht7BGQKegf
	E2ShDi74CWmHUiNVBPfQocTL7dG9INrHWdEzDH5nClo4tbIIe6qdvvZIaRJCSucBSqe0H6T2FBI
	cqpTlsd4BTo+tpANWdQxNS5/+EOTPq+6somOXbHKVrscI992W9kqcCEfQOQns484XXwswkrRQLe
	ASOTEybqcESUHcD4pQnZAyOlPWTyaXTZkZUOgg9eEsOk5MD8ad6Q4rY0M+Lt6YSDj8hmHr8SjCT
	0NEFyoPcnFuVPHlo5pKv+ajJSqablRNst4dWAmFrtKYNBgtmBYI6G2sMGH7tBdUWbmB2Vb+V3tP
	v+kUD3oedIxqjtW1Qe2XMfKPFw9TzFNxoG2FRqj++vCPjDjLZ2k3faipnN6APyuMMRnicXUcyOv
	qM=
X-Received: by 2002:a05:6a00:1256:b0:842:68d3:e29f with SMTP id d2e1a72fcca58-844e193a464mr942769b3a.3.1781290390373;
        Fri, 12 Jun 2026 11:53:10 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434afd100esm3741845b3a.34.2026.06.12.11.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:53:09 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: miklos@szeredi.hu,
	csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v7 3/4] io_uring/rsrc: add io_buffer_register_bvec()
Date: Fri, 12 Jun 2026 11:48:39 -0700
Message-ID: <20260612184840.4058966-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260612184840.4058966-1-joannelkoong@gmail.com>
References: <20260612184840.4058966-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13704-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:miklos@szeredi.hu,m:csander@purestorage.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,vger.kernel.org:from_smtp,purestorage.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A8A0B67BDE5

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 13 +++++++++++++
 io_uring/rsrc.c              | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index bbf57da1e4c8..42801f0b6456 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -94,6 +94,10 @@ bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, void (*release)(void *),
+			    void *priv, u8 dir, unsigned int index,
+			    unsigned int issue_flags);
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags);
 #else
@@ -146,6 +150,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+					  const struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  void (*release)(void *), void *priv,
+					  u8 dir, unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
 				       unsigned int index,
 				       unsigned int issue_flags)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5d50b967645b..819c5087d8d3 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1096,6 +1096,41 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
+/*
+ * bvs is copied internally. caller may free it on return.
+ */
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, void (*release)(void *),
+			    void *priv, u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	unsigned int i, total_bytes = 0;
+	int ret = 0;
+
+	for (i = 0; i < nr_bvecs; i++)
+		total_bytes += bvs[i].bv_len;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, release,
+				    priv, index);
+	if (IS_ERR(imu)) {
+		ret = PTR_ERR(imu);
+		goto unlock;
+	}
+
+	bvec = imu->bvec;
+	for (i = 0; i < nr_bvecs; i++)
+		bvec[i] = bvs[i];
+
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags)
 {
-- 
2.52.0


