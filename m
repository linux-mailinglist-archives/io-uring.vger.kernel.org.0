Return-Path: <io-uring+bounces-12816-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMbYC83XwWkaXQQAu9opvQ
	(envelope-from <io-uring+bounces-12816-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:16:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DD12FF780
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0CFE308C5F0
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 00:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C18F17C69;
	Tue, 24 Mar 2026 00:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEkpHroS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0B64A32
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774311025; cv=none; b=DIElxqrNM8913J4jXg3WvvezEbv7lMbtv+F7kBWBrkvmJJQ7mJ6koCtyMiY3tm798nyGgArm3g29a71tfTp9D3MT5Ap+rnC6VzduCnmClbWWnFfwytlyRrbjVwj0xuLV3vszAkZ17sMyA6lq3eefRQgj2mhdX8JLa97ALXJFkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774311025; c=relaxed/simple;
	bh=vWFGITqQ3wGzPNmBsUXR2nggE2aYU4h5tlGjDNGMDE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb9KiMuhtEcdSyAM4bwmCHxFpKcTGVWs4EUjq08yOng01Sgoz8PZf7ZgyhIQuDmjt0F6S9HXuvZGYy4iw9HLk26Aetn29EJPq0pNKVYg8yB9R1UpQ+LRZ5OlQyNuU5E6uod9+D1LMBWU4l3Bw05RHmfviq5+pp1gKG3snS3sf9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iEkpHroS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b06c43e6a7so17595395ad.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 17:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774311022; x=1774915822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gFzxrIVh4gLtrSrYN1n3GrzTnFIrUKc2tCG5pigU/8=;
        b=iEkpHroShI/ts4TPxIIpJbBe/gB67fjX1VBgEFPMOcQrmg7sI9MIaaG5BFirVt5zgr
         QyTQGcA6CF80Snc/vthFGYjoUt8nMVxqIiof5FQB+Jb1cdlHm/rkAkkqpN53U8jaLtzq
         S2I5mgDJLqGMXrBAAZiYwGOSW39pOj08MFg9DmP64ExAP6Env5qT/Xbovw4u/KOiIzr8
         VAkTqHg4+M38X8j/IWbdrnCHwx3HASZFZ66w4FGc0EHreZBkIkbRExF8f/Phhge98WPm
         HygJoehTWt8yywVVC2ertD/iKngVLpGzpA4bDxovshuzw/wLPHQuAci3FILKE0cdbSxp
         vlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774311022; x=1774915822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/gFzxrIVh4gLtrSrYN1n3GrzTnFIrUKc2tCG5pigU/8=;
        b=G3CHjpZHlfvq6cB/BgmGt8tZLKJs++yUYcD+FDJCrkfxcQkTGEn4ZyYNasKv+6XFrt
         9UPH/BDqpNHolIz8v3nd5+mdrOcaPpHvwc+rD8Wr6IMM+HnDDOGwsW/IeqqL0LG6UFsu
         AQEHAmbzH5qRMzFrKpbL8ZIU/HlxK5DKUAU08Pe0bYdPvInslc1AFYLH0Boyt9hrWC87
         fen5ZOwWQH5nJmSftvUj/UcCOPxsQY+Rfmgd+nrsaKJnFRb/2EgZzXHh4fHoglpbDV3p
         vBWxN+yHXojfnyfz7lWjWECo+Fr8m0ajCSUFoxovXZTJpbaV8p2pyZmUnjkkk63mYH7l
         L8/w==
X-Forwarded-Encrypted: i=1; AJvYcCVYjay2CyZV7/IEeFinfC4lhS+TeN9fPN4mJ8ssPIkfwB4MjohwVZ9iJJOXLMzYkFhzfkNRW6ZYww==@vger.kernel.org
X-Gm-Message-State: AOJu0YxE/0SClnuPKEi0wbJ14zeKsNqWTvFeZbyDBGJa8l28NVh4dizy
	HJW/TmGU7sx18leP3V32jKV3WMyPNqc9naLI3rtMMC84e8X5IOMt9ADP
X-Gm-Gg: ATEYQzzN9jOINgwCTi3bZSbyWH36ZksMPgrD/m77rnk5k/929/LG2XK7+yEQb+iz5JS
	n7opjIREJQBal/lqgZ51T0PXLkT8k0brnOK7OCHdZynP8C0E46VJ44VwPeOXy2ypZAIQgFa4vlI
	r0tdkb2KoO+5LE4M8l9ZI2wTS5tUt8aq3lLo1+7hZjQN4BWDrYp+EDeua81u9eXA7QHQ+VVI08U
	W50og3S+3f5SeZKlaLn1hL3r3LAa3csdC8v8PW7N0zMA/fUO9PTWrcaQIisgLEvx6hKPN7gul4s
	RRbRwv1GmVKKu8HSLIzjClHVV+zyKrlpvRQiwGbaSDAkatE6jsYxGKy7b6el67ZZ5o0JZPiGzEs
	FuBHys+fpSy0UEFW9Lqdr8XlxIdvYxhQzED9YXq3r/pmLLiQU6h/aa0yifEtRt7Xs9bk7QPIWPm
	IWJXXwKG+76X0x2w==
X-Received: by 2002:a17:902:cccc:b0:2b0:5e63:fc45 with SMTP id d9443c01a7336-2b0825d69efmr119517985ad.0.1774311021868;
        Mon, 23 Mar 2026 17:10:21 -0700 (PDT)
Received: from localhost ([2a03:2880:ff::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516cb9sm126042035ad.2.2026.03.23.17.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:10:21 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1 4/5] io_uring/rsrc: add io_buffer_register_bvec()
Date: Mon, 23 Mar 2026 17:10:06 -0700
Message-ID: <20260324001007.1144471-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324001007.1144471-1-joannelkoong@gmail.com>
References: <20260324001007.1144471-1-joannelkoong@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12816-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4DD12FF780
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_buffer_register_bvec() for registering a bvec array.

This is a preparatory patch for fuse-over-io-uring zero-copy.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 12 ++++++++++++
 io_uring/rsrc.c              | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 165d436073a4..f054ec1c8912 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -110,6 +110,9 @@ struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 			       void (*release)(void *), unsigned int index,
 			       unsigned int issue_flags);
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index, unsigned int issue_flags);
 int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
 			 unsigned int issue_flags);
 #else
@@ -198,6 +201,15 @@ static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+					  const struct bio_vec *bvs,
+					  unsigned int nr_bvecs,
+					  unsigned int total_bytes, u8 dir,
+					  unsigned int index,
+					  unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
 				       unsigned int index,
 				       unsigned int issue_flags)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3a89eec9265f..3fd15bb8f6a7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1007,6 +1007,38 @@ int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
+/*
+ * bvs is copied internally. caller may free it on return.
+ */
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, const struct bio_vec *bvs,
+			    unsigned int nr_bvecs, unsigned int total_bytes,
+			    u8 dir, unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	unsigned int i;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	imu = io_kernel_buffer_init(ctx, nr_bvecs, total_bytes, dir, NULL,
+				    NULL, index);
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


