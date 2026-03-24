Return-Path: <io-uring+bounces-12844-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBsXCLUNw2lKnwQAu9opvQ
	(envelope-from <io-uring+bounces-12844-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:18:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D5931D423
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 23:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 29C813030E4E
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 22:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984353C5DB2;
	Tue, 24 Mar 2026 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXjylicG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B2156677
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 22:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390520; cv=none; b=KzNnztc9bD3hjDAGZSXzDzLR57v9GCeM2PxtsrpxhGp4ZZkX9yczmZafR+7s7WBcbCCQmx+60QasRDwGj5qrMNuOG3EelfkqVReyvFJgBlZbulKPluJCeS5wS79+70csdNn56DgzkXBa57XRmXfKwcwXZAYZb+j8h8smr7AhLx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390520; c=relaxed/simple;
	bh=l+O9qzydf2aKxPuSL10jwpYHDtKQ1G0q+6CdciUI+lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td39wZh13/tWlACuvApHMma/ISoPijMj9Zix2EWBj4AjDbSahEiqMilNHGIS6JeQEbwUIUjvjaUM0Rq5kS4qs2+hWsyAj8EwJeCBE5qSJhXWSGQibablGTOfEFqEAPCQrZq+J1zdReAj4eh7EijT4W7oyRuxOpDs1Q8F2oCy5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXjylicG; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b05761bec1so1413035ad.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774390519; x=1774995319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsyNJBtNRyR+PbExOCYFszbi4zgFGTlg5LVxx73HThU=;
        b=EXjylicGTUIRNg644LT6d4DYtcZWW9Gkld/B5E2pChqteikAryxRZf1pqvxwc0I/hr
         yJ0fzXlvP/gDIVs2P+h+wNHrqXbwqwVY9g0kcJkqEJD5E8RoELhrM98uuVQLK8F9CzHZ
         e2mMvDr7S51fq8GlViUj3Qzjp0agjTSVmzbl2A+rKm4YZeIxnxV7phk0uO8JYKcb5L46
         F/pz05IhAtSW6db7cgKpddeK7eZcOGrUZroUhDiPf5zSu+o9mzhK+GWGloBF9+0lX+ue
         1qqzKMWxXbpMcMbHNqTyfPqz4yRnpm9nypjnrHUtavLDDYIqQDWd1TrwrB8oepYHd/vy
         P5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390519; x=1774995319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vsyNJBtNRyR+PbExOCYFszbi4zgFGTlg5LVxx73HThU=;
        b=O3HUkWfL6SP+d+qdS/E/7cS9nsk4h82WB5KBXJb/XXFv2i+6qZ5Rx4a4+Qt7J1fi7R
         hnw7ao82R8tToeBl8bic2SVMTRe+UAN0QKv4jOmFITExBLgcKNcMZtxPwHv6L5RMxaDh
         dRyaPiEmoGEJXJt1mBa4zvP/3+zRHrrwzCVnTJMJsk9kc2EDB9Y0GfSY+AiF0RbBomLv
         iWqXj648WNhtdEaJTD774UpCeuRx2oXjjG5Z1Psa4Rf0JntD+Hzn85vYVV1f0C+A/QPo
         vc1sjCYgKy/d8DoxmuTgTuEhgFszzMhF57AvRMo2JHK4AEPHOg4Ad9ulR5YeBuXR1+1H
         2MuA==
X-Forwarded-Encrypted: i=1; AJvYcCUWh4egwJRgjmkTeoO+7b8d9Fy+NsfSGdOMJsSFgVwB0UxcW4Fgq0AUZ8sb5hlPUY0lnLB3muNqBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw82SJa/epsocsrsBjQEclgJTqVNBa8uawKaygKLDqPw8SVCUD9
	AdCue211F6iOMkspxrwm5lai6cDr6Tf14R/paxW5jJk2WtT8vQDGdKfx
X-Gm-Gg: ATEYQzzrYEizEd15p1rovr4N4T/z2FIk3/7N9A6eZX9MZR73yajqzcbiPS2MecN1xtJ
	UNQ2HNHtfnjTHvdsdWVHiYzHHZ8zZ6NXk6gsEZkGXplyvPHakQ+gu80rkLrwjW330Q2JP+2fjoQ
	RZ7RGXyM+vIP412QO9Gbk3xRNRTERuPbhiTVFAVjCL2Eb++S+ZgRd9QOsWYxfPZMvOaS8EdkE8v
	T405BKfOFWyIS0ufX9ZPr3EoJtI23UrCcxfU6g9SY7/adoFCSRL2pFkww7HQ/EZuTXLIU/pEIN3
	mZXN9OTH2zB2CIJmFZW0EQjVgB2cW4DTSl63rAyYVUTZng4tpAKwuwClSgNUQO8xj5PxKJhbs/c
	HSf7uyMLgb9p8DAIcHWYFiKECUbjjvlZTDVfE9O2oJoUbTUCD24DmEb2RVx+u+ensOVGfTajRdB
	HfkZGtn4YCxYbDroiS
X-Received: by 2002:a17:903:3bad:b0:2b0:b3bd:1de3 with SMTP id d9443c01a7336-2b0b3bd200bmr627525ad.7.1774390518280;
        Tue, 24 Mar 2026 15:15:18 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836556desm208621575ad.47.2026.03.24.15.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 15:15:17 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v3 3/5] io_uring/rsrc: add io_buffer_register_bvec()
Date: Tue, 24 Mar 2026 15:14:24 -0700
Message-ID: <20260324221426.3436334-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324221426.3436334-1-joannelkoong@gmail.com>
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12844-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 66D5931D423
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


