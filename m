Return-Path: <io-uring+bounces-12951-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KvBFfP7z2nt2AYAu9opvQ
	(envelope-from <io-uring+bounces-12951-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:42:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE79E397171
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A3213027D87
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 17:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BBF35F603;
	Fri,  3 Apr 2026 17:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pknW096U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D981334DCD7
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238127; cv=none; b=cGmhU9PeKBwEIE4wgk0NpUIAms/NSW9mtABG7jIu2QLKXR6fKVJww0aGgFY+0ax70eJoqc48p/QSL4asjtTm78NF1b2HFV6GXKo551yOcQm66sqIk0gErD2M0EKbA9P1s4y5Bv7mwZGCmj+ux5Rn3oQbM/tBCMAhBsIPhN6hhY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238127; c=relaxed/simple;
	bh=XbeENpznGotWVx6HwzBreFrQBLH8GiQuBTLV00eYKaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxAjU4nJtRJcwmMWijzaQW2laTt9ThZXcdvK/689sAqkei9BpNn4Sf1TV5B4PQXiGcjB3+wossFpkD7aZG8GqeTuSJzsandkY1yxsllPO3V/0j6DgunMaaSZYRNPCeSrXc+Ve0zt+cU/Z1T1wnX++tjVr8FOKcaLg7X+TrdaFuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pknW096U; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-823c56765fdso1053816b3a.1
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 10:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775238125; x=1775842925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6YRHPYNkrHHQDgcZam4PtZiUQ/H2iB+W8q5HynTigw=;
        b=pknW096Ub182L9Gw/WHLZ4BA1sr5vTOMuxE3Q2UtiQjA9KQW2/g4zRiDzrwb7SET5b
         Ul95H8N7UdcJh6sPpRg/491qd7UCxIt0sU1YSQWzUg79NSSzBKURvEd//iS4J1QEpUw3
         2H+aiCp/5eP2LcjF9NkwNjzQKQHy9CLJ8gxzpeG4Pgjuvng7tTI3YaoQ2+NjQDRDfila
         2vl5DnFyl8P2lPiqr+tzy2jfV21/nUz42UFQXDK2pHygfruTTGC/zYfYwR22KsbO9432
         UvWEBBb45rE9pM0mZvCbBBRjriQsqYIcl4ExYeYRgIg+AUAdoA4fUa0rt3dZqiB0GYRi
         B2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775238125; x=1775842925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k6YRHPYNkrHHQDgcZam4PtZiUQ/H2iB+W8q5HynTigw=;
        b=g5sA6lPdAOwwiL/fuj7Rs39sxH2XY99fWb6spCOq3SSSj285f2oR9Um/xPHow2Cyo8
         aYvUb457IFCzPNSPPFivsqyTJtgZUNWDNaKiHHLXuAJ+Ew0+cE/NKGbfCoxs1uEeLT92
         onip+6DlpS1kDB/PYk9Oheerv11bjtyONeYICqeTomz11ilu+2iLuRRx8nREjBtJBe9e
         CqSZZJ/AC6OAL9YC8RZiMaHBGYPUlN3LCKz/9CpVfjQvGTXZ+J3Cpwy07Ko2ibVvtmnH
         SlKhfizoORUnLOOicPH4HJCd91Cd+iYjIIHhKg4f4S8Gj0xWeBwKi5IbTmAX1KjFZCv4
         n1LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiiIQPQ4bBNTj0W26TA0zQ+QZSYGr59efoRFIN46g206RQspQr9aG1BiF1mO0YnpiII25ipymuKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNGCY7fuqZ09yHfAKXM1mR54JOSDgFcNAU/b7iUDe6U9PWAiL5
	pEIAOXnE4O6jA2SaIuTGfruwgZeFQ8zIaSmsWZIPW1Er9YM8ZX2P0Xgrl/r3jg==
X-Gm-Gg: AeBDietLPhHsThfwrtqCZCgkfenWJQ4JbfmyDSNganZnsH26ozedcUqgqLiajJxOvD5
	FxLms74kVQUkQDfADiPUz+MWaNsFqsOV5R0GjdsJqkUySeNQJWuT8AdUpqWClVKbdTkmNVIuUQT
	q7Xid9P6uwewc6dfVV62zRJ0hcp0BE+278gF2mL0o8sM/OEs/AfxMkaEVK+1P1aw2/fAAX6gegY
	bmOdq8jX6JU0TmwEwA3fac1m1+nhgQ3yDrXlSSWvO8uSyjL6q7fL4WS5Kp6R4MaZ9RRxdfek5xj
	ylgvP+1ltGU+TfIKuV9GbZ5hhIzBDjJgId+2fwhR7u5w/ufrEUNfUhuh8xVf7TJi/6M5YgE+7ti
	ms5+UGG6u4v/yi0MebEpz0N3YE5NciDKgd48F24pX5ybrCPyj+vvn3uve5RsiGC3/veATSVIGQc
	pbUwIplAo/wEDdJD0TLg==
X-Received: by 2002:a05:6a00:2393:b0:827:32d7:6690 with SMTP id d2e1a72fcca58-82d0da98e9amr3643699b3a.13.1775238125085;
        Fri, 03 Apr 2026 10:42:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82d1d6b221csm415247b3a.56.2026.04.03.10.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:42:04 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v6 3/4] io_uring/rsrc: add io_buffer_register_bvec()
Date: Fri,  3 Apr 2026 10:41:38 -0700
Message-ID: <20260403174139.3634824-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260403174139.3634824-1-joannelkoong@gmail.com>
References: <20260403174139.3634824-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12951-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE79E397171
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
index 6ee699bbbb91..9283cbe99872 100644
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


