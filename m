Return-Path: <io-uring+bounces-12881-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMsyJla+xmnoNwUAu9opvQ
	(envelope-from <io-uring+bounces-12881-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:28:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 477BA348583
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC1B5305B027
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366AC25A2B5;
	Fri, 27 Mar 2026 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LF8l1wF0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDF53E4C7B
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632431; cv=none; b=K1yMxIWE7Tt3wpjzzjR4pKJhTflsXfOicFmMQNe4vPvvTqUn9xYPI7EARsyF1JYBdvbF8BFkaEBiIVN8Bl0hDG6EK1crK2sNolFa8sX49vfg0wDsHwppbdW6ql86vleX0VV9fYBAb18OwHxx42HdJQ6FDRz8oWM9sayriovQMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632431; c=relaxed/simple;
	bh=l+O9qzydf2aKxPuSL10jwpYHDtKQ1G0q+6CdciUI+lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADJ3Lz2v633JnzGZPzBRltEgKrTY9274hvsAivY+ON7s3qkRk1FNyRYtFcbCqr8faitZFl5q4XQGU5RFkXRVQcYSamGULcMe99l11/3FZQP3rMIwfcJewQBoGtMKV79GWz1knlr6Xh3OWCD16KeQ6w8VM16Y9WMcjxrctzwXMJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LF8l1wF0; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82c4b5dfe6cso1198734b3a.2
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632429; x=1775237229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsyNJBtNRyR+PbExOCYFszbi4zgFGTlg5LVxx73HThU=;
        b=LF8l1wF0T1agiXJvvOwyoihi8MR5xVoEk4KrtiS91Mf+KbMnSolepYl+y28k/REsfM
         PSUYKu1WQ0/hHE5BnToVe9eP7xaq3AMmolJbn8Dqbg5WkvTVMyxTP0jV4kHaHea3WO85
         ROyqDrG+ZYRJus0WN9PUwund4KQa28KFmISEDii4HILd4JXkqZ/pa6eVj3voUEdmOA64
         3FbnHOIb33oQkK5+FRjmcVDVZlCURNeOZ5Hdd2zXpbJevUABMtAshdWl2Kk0D+2XUICt
         3OVLWVYeIVilaNDour5zXUxtl2/Ff3qAEM8tdwz1hcG7A3hvQxkm/vK6JUjwQ2owMqff
         mryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632429; x=1775237229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vsyNJBtNRyR+PbExOCYFszbi4zgFGTlg5LVxx73HThU=;
        b=QRPoVTzEVidVw+rFHL3XxiOB1H3YErrfQLUM1q4LliC2dzNYVGZD89Fc6fyZQeXmP5
         GhjCnV/ZPju7Hp17klypMUFZO7TXUZLceGRRzPwwijp0/icehaJSZeIs52gymc0WEtZW
         k/b+pF68IGqQ9BfLj9F3lwnD9LhgS1oMpAlWnwHlEjL7lhT2peCXps/oJKt3kO4LNxDP
         0dqYJH8asOhcsOyp3C9aabDrytA7qvu0kijVR9hNT53aVGIsUfr4Tmnk85LM3xlsbgGl
         OU0fUs9h7fwMJpUnsgPwtmOU0kfAlwxW3hJmct9mQGob3H/eMGZTIg3ZlHO5PvYNNdUx
         sEzw==
X-Forwarded-Encrypted: i=1; AJvYcCWtTc2B9TTF/+jPRT4Gy8EG4kkqOhyrUXbKuUPItlp/w9R76pMl5bbHbMH05ahNbuyQPup3VTa4rg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjhUZRKgUtrIBS/V56o72IFJlr2yNv72z+vZRrnwaaOEtpkrr8
	oSA5/mfS3JlwW1aOOjLynMNirGvSde8pfXPB7tBHPTwNgdyLBZnMc7rZ
X-Gm-Gg: ATEYQzzhRyFwpV9xEUE76b7Kk6lXgDWWn/4Rr4R4oFj2CLzFE7z5irbpNoA7KUGS3uQ
	ofUhgjAVWMcUQPqeZUg5NlkEoN2z9GPPKo6YWgsw1AZGTuHMXSLeiAkBeeJZ4OUkH0kke7TWdjg
	UfGwg3SusiGjZCjStl4Fd3QQF1QmZn/C0cc74/iVR0zx6b1Mlh0h3st44eghM0agPq77urgn29x
	EKvzzcRskadBqgZg4sPYEc94R9ItNr2sBiJWIMGhf8jdXVLo2mgJ0JX52uF0xp9SNhILnux0lnL
	mAVadmMHwxLlAdaiTDv7I8xQotu6NWWvC6zac6OJ9XXpGxlqumxnGJtG1eZF5hXR0D4z99NG9JH
	b8XJFIxkofINPweG6+lTrqvH43JKqdZeP66Q5/2c/wqrrnCyj095IIJ84muyrXJlKe6bV11ES5X
	Q09lSCPiq+PGnVS60UIw==
X-Received: by 2002:a05:6a20:6a22:b0:39c:4cc1:afee with SMTP id adf61e73a8af0-39c87abc0ecmr3922890637.44.1774632429302;
        Fri, 27 Mar 2026 10:27:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76739345b2sm4377998a12.17.2026.03.27.10.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:27:08 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 3/5] io_uring/rsrc: add io_buffer_register_bvec()
Date: Fri, 27 Mar 2026 10:26:29 -0700
Message-ID: <20260327172631.3380702-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327172631.3380702-1-joannelkoong@gmail.com>
References: <20260327172631.3380702-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12881-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 477BA348583
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 13 +++++++++++++
 io_uring/rsrc.c              | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 165d436073a4..b4d1d5e8e851 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -110,6 +110,10 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
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
@@ -198,6 +202,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
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
index 01c3619e5f07..039e3b30ff60 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1006,6 +1006,41 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
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


