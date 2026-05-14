Return-Path: <io-uring+bounces-13343-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGQKKUz4BWqcdwIAu9opvQ
	(envelope-from <io-uring+bounces-13343-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 18:29:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 054E7544AE1
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 18:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7291630234C1
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD113290C8;
	Thu, 14 May 2026 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7T2VcF9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147B314B96
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776001; cv=none; b=a+mLjFnKhXS3hhQZTWauHmjIofkKRSRCSEwbWCfH+Dk2RgufsL4OaaDwsemKHxTYtK+ReCoel6JRMfrTk1zMQ5ahfTqHxfyIMaELfaDJ7lw3HkbnHh+5sH4jaJvmHkv6jnodiZbQcXHrRMQlOfaMRO8nNk+j/hSKX26RPoYQ4lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776001; c=relaxed/simple;
	bh=u1nbiDWh116CJ1gSIwEeqU11XDDsZSM1Xuony/MWFHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z2FDPo7HqEk6YMEH/fz+Tq7mpQolztSpOBoHFIY7j+o9mLORSs8w76VZ6RJjhnfjWU+A5BKxOYIzExR3KJloBkZabRMB9zC0g/N4c2VuDw58wb2CN8yjSqzVnMJzzH5iHx8LJBQNQU51BqlT7HBTg7qcjWEhpiBUFr/At6VqK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7T2VcF9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-459bf19e87bso2894667f8f.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 09:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778775998; x=1779380798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oUyGvi+t7+IuZEGvRIrYdTUfOa+05x3+pKUrW3Z0Lb0=;
        b=i7T2VcF9+GmmxHE+JYD0vL0UpnwQR35qG7GdcRY2Sec/FDIKMmchQUSqAcggMORouG
         V7GyJRG62P5MXaQP2sg4+ustQU2CGjfpM1UnGE6jpMcxcKv/iJzdYeZMhPWpNHcS8Epb
         WZ5c3Me2wJK1+sWQUkQwr1xFioCvbtARsgiwX4LW95DqKOgT3SjFsKl9MgBVs0Bn55+T
         YNt4BA1hf6bkkaysUOPBsIzcFwFtxWw1tQ3buP0rCPHmRXD7kiLQ3p1nmNB5ewRpysKg
         bHPIAv3tYsy/I7pZ1Xy2nvJUXlvzfjhpvaHWQe2fw14KVQMnxT6vlLBKLkF+Y897OlDj
         1m8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778775998; x=1779380798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUyGvi+t7+IuZEGvRIrYdTUfOa+05x3+pKUrW3Z0Lb0=;
        b=VJmYZ9veFM+8SyTsnjxXwgV1S/mYNWQ5Wc5qLUXBEBDvUJielr3VTw6xI4NjOb3tj8
         bnol+3FPz5xMGYEoxKTWt0LlhBaZDgbRlGcnI1wsVLXE62n0XLPxNkrWQ9tPE5FbXvv6
         nuLPnrp+BGxium7AmCaqNcKyC+XA8KphTuhSuIcDeSOr2gkgTaxTbWO+dQzN2JkxAuDR
         gB2P+86zJwEGVu1hbOyy1Q35btp1ZJSwnP2XhXcVqsFvYusx6hMxn+tpZKmT1wBCTiP/
         TwkHmuE7eB3/dN0lM0MEBx3BQi9+IO7e15WuazHA1p8PgPEERmu1EcaI+ECrBgU+qTvR
         RAxA==
X-Gm-Message-State: AOJu0Yy99BKtEsIBsrRZUphYrSpPWg0NS9BRPJV0VOulhp3uj+Ul3nv2
	rtU1TFny4XrzdQurA1hkaXsRYIwjh+eliviitOqlTtX4ZYtLehUwLWjPvUYA6g==
X-Gm-Gg: Acq92OH5UglchQ44wmY/lR0GC9uaFxC1WaHgOUSN+bC7pV2IcVz41xZV2MQf0aATnCF
	3UPQkrCNClFx/Wwv1D8wz16BYN6F9hZj3bCFYgehKlUWaz2Se05z5pGsQZb8MgrivJnTwt3tE5i
	h/TgB29f2lvAw7kZH+RI1FQnRy3XcIcCj2wctWPMyERjitFGbbt3lzsdJK5cXZz7iWwf2rSPo1k
	c1Mj53buOD6+5yslB+n3VAGTTyTjT7aW+odxrMpx0Y7zGAfbrHxACot2NOEVDlPDYIlZFF4mDR4
	mgx5Sx4/YwZ9/HarvPdEX58F1qFnEBbIulxwKn3efiix85PIkDfAIHJC6L3/Y2Lh0TpWof43zwc
	++ez2M31EWBYNXHQ5qn/wf8cjQJiC/R9Gc/xXF5E6G1XPvN64ys9JWoB6S52clroL5Sz+3K7oxR
	juv97dJPSRYPCk6S9OxyX2k6wTscExB/DQ2UzBzTvICHqWtAY9IS+lHjRK0JLFupHEW89/ty0Tt
	oN1yL7Wc7a4Xnw04SNef8MY7AQwag==
X-Received: by 2002:a05:6000:228a:b0:44f:c886:89b4 with SMTP id ffacd0b85a97d-45c58696b01mr13004465f8f.15.1778775997735;
        Thu, 14 May 2026 09:26:37 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a562dsm7906777f8f.33.2026.05.14.09.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 09:26:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: improve zcrx export tests
Date: Thu, 14 May 2026 17:26:26 +0100
Message-ID: <df5e866a3c0582ae42538841dc54fffc45004aa9.1778775960.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 054E7544AE1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13343-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

Use the right zcrx id in test_zcrx_invalid_clone(). And fetch the fd
after exporting, it's currently just 0 and is not checked.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/zcrx.c b/test/zcrx.c
index a0e8a863..e4d2213e 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -751,11 +751,11 @@ static int test_zcrx_invalid_clone(void)
 		return ret;
 	}
 	ctrl = (struct zcrx_ctrl) {
-		.zcrx_id = 0,
+		.zcrx_id = reg.zcrx.zcrx_id,
 		.op = ZCRX_CTRL_EXPORT,
 	};
-	box_fd = ctrl.zc_export.zcrx_fd;
 	ret = t_zcrx_ctrl(&r1, &ctrl);
+	box_fd = ctrl.zc_export.zcrx_fd;
 	if (ret < 0 || (int)box_fd < 0) {
 		fprintf(stderr, "Can'r export zcrx %i\n", ret);
 		return -1;
-- 
2.53.0


