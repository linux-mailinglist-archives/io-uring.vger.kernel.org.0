Return-Path: <io-uring+bounces-12213-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NHeBvc7kmn2sAEAu9opvQ
	(envelope-from <io-uring+bounces-12213-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:34:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 722BA13FC7B
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36A7A3035275
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE1029DB6C;
	Sun, 15 Feb 2026 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWwi8xJd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B21DC1AB
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771191279; cv=none; b=PlTKg6oSI+MpadexwwnfKaLd/+PIzlHfz9gUor6IfHKjEIHRtfqDiHFVZnl1Vpx47MZqdSQFsTgR3kkAwCVfvLGc6fPcFhFHOn/swrsnXmvyy1vO/5sgIKSwhuU815nxSno0KNz2oauAmck7MDPJgqIF+vIAVpytoY9ddgPLBU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771191279; c=relaxed/simple;
	bh=5+A9BM/9j4EZl47CcaalxWpYyqqhceOe5Lgrzliunqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YpSUw1+sQpU6Frgwm0U1+Fe8Lvfvgxd3NS8uM5c7lOtUZz9n5as6ACWmJd9L60+4SB2B0yl1RODrQ5VAftquKJcEsMPYUocSqL4bxhZSbWcFseFK/U/KbI5aqvP4C4TKYuN1GJWwMgw7SYtnTnN3eZgl6oRLBszxetzaXMjVRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWwi8xJd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48379a42f76so12156155e9.0
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771191276; x=1771796076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7pUXUjGf8GywcuWoq0eu0G//Qfj2+vuON25+u2VLtCU=;
        b=HWwi8xJdFwXP11R4GHQj9rYiIXqBHDdnN21ZJMHy+1hTV69Y2bxKi2Cbejd63JjAcQ
         6aXbWnx1gbBJTe6zE4ICHc+4nrO5laz3AFZBFwZMm+7onCMLTKqhuNx/CeModJezsOMG
         0yF0UceP8Gi3/walh7Eb5SmXaLH/idXfq8VUawdwSmD3mFmkAQAS26UPtl9A0EQAbeiz
         MM4ZjWfOVs8sGEhe85HEiHSJNaalr981tufrNOIs6WyoX83JtWMtrsqTPS5KN1T1eutK
         TBW6bfkpK4oHg/s43E6IbCb5fZp48FxtLmTdx2G9TDMspGfUE2lzRzjd2FYgDrT6RvK5
         0ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771191276; x=1771796076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pUXUjGf8GywcuWoq0eu0G//Qfj2+vuON25+u2VLtCU=;
        b=oKntm3C7vN+8gya1IwgeRuOIvAGqduqMUgwyF3GNCR4nviF0bXkVOs1wlsoML/H93/
         oLTFpvfoT4aUR8TKZ+tQPINpCqcnQ6ufM9YPsUh7r0MhpoUGbepBFAn/rtpYxCbJQl9R
         hBQAfgqxrLSHIfZMoLOF2TI2lv+fA+tFojXWTKoccRJFkcNEER0ag+s2OqWY/0DazkNv
         Nb7uBE2A9P9nltua9M63aN9oANmmn3nb/c/0bs7Le3rcfUs4juCcalqjeb9bxnHX7Qmh
         8A7sEmOSyPOF+7Q002J35fSr6DdjIt+q98AkilnvsUBiaQsicK7VQWaEJ5iDlK1InQvi
         kv3g==
X-Gm-Message-State: AOJu0YyNbTDA2TSbMOGALPw9KP8CGTBeqb9wIRbzN/+D26gKgW1o3SDH
	ZD69szwmVuIpYfWk3UI1hTjZKR4oRISR1Is/NajWXW1WQP6h1CTq5ByJmUf98w==
X-Gm-Gg: AZuq6aKeFBaBc2MyHt3XhxRDY45Nn3gYLABeuVQebgMbB+CsepyteUaEAZWQsdYfOif
	DPUP+A+HX0gT89lu/ip938ROLQjNb/oAVrTMb9PEP/nRjM9SrUMNmldLCfvUfgG8mzxIiVnPBwm
	awdM2EmWdHAoStWDoSM3g5TK9be75rB4Q4n+Goz8Hxn0z/QDDmh4rbJlPRgg5UbHn+xXRFVqgeV
	dCxvePSCiFPHapHCQzVXFG+ZeDAQyYxsU1b8t94Z/6zB4vss/n7Icv/XpPhc0BfGjpNz5B15/jh
	r7QT75VjMUDVhJlHqKW2jwwnqFNNTCDtXQn5Accn+mwGNAOIjrBXEuLPBn7ND5btH0qezFh5Hxh
	j2Za29oQv2SBqkBC1b85Bagd/85VjPq+3TQez/2tsprHNcsFgP5dkUCixPr96O3/TmH2Tch6qbG
	4lo+S6jgbtYt44pkahEAmGMVHkfHPJdf9inA7ivMq/CYSviAt2k44duhirppFXkxJ/zFhrancbL
	2pFk6RcRAoPJ7smbDc7bvUXDzWbLQ==
X-Received: by 2002:a05:600c:3106:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-48379bfd705mr114445795e9.21.1771191275620;
        Sun, 15 Feb 2026 13:34:35 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dd0e327sm378040235e9.14.2026.02.15.13.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 13:34:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.0] io_uring/query: return support for custom rx page size
Date: Sun, 15 Feb 2026 21:34:28 +0000
Message-ID: <2e8280467c93ead0c61ed3d68c036d6a0474bb78.1771188227.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12213-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 722BA13FC7B
X-Rspamd-Action: no action

Add an ability to query if the zcrx rx page size setting is available.

Note, even when the API is supported by io_uring, the registration can
still get rejected for various reasons, e.g. when the NIC or the driver
doesn't support it, when the particular specified size is unsupported,
when the memory area doesn't satisfy all requirements, etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

It's a simple change, would be great to have in 7.0 so it comes in the
same release with the feature.


 include/uapi/linux/io_uring.h       | 8 ++++++++
 include/uapi/linux/io_uring/query.h | 3 ++-
 io_uring/query.c                    | 2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fc473af6feb4..6750c383a2ab 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1090,6 +1090,14 @@ enum zcrx_reg_flags {
 	ZCRX_REG_IMPORT	= 1,
 };
 
+enum zcrx_features {
+	/*
+	 * The user can ask for the desired rx page size by passing the
+	 * value in struct io_uring_zcrx_ifq_reg::rx_buf_len.
+	 */
+	ZCRX_FEATURE_RX_PAGE_SIZE	= 1 << 0,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 2456e6c5ebb5..0b6248175e26 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -50,7 +50,8 @@ struct io_uring_query_zcrx {
 	__u64 area_flags;
 	/* The number of supported ZCRX_CTRL_* opcodes */
 	__u32 nr_ctrl_opcodes;
-	__u32 __resv1;
+	/* Bitmask of ZCRX_FEATURE_* indicating which features are available */
+	__u32 features;
 	/* The refill ring header size */
 	__u32 rq_hdr_size;
 	/* The alignment for the header */
diff --git a/io_uring/query.c b/io_uring/query.c
index abdd6f3e1223..63cc30c9803d 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -39,7 +39,7 @@ static ssize_t io_query_zcrx(union io_query_data *data)
 	e->nr_ctrl_opcodes = __ZCRX_CTRL_LAST;
 	e->rq_hdr_size = sizeof(struct io_uring);
 	e->rq_hdr_alignment = L1_CACHE_BYTES;
-	e->__resv1 = 0;
+	e->features = ZCRX_FEATURE_RX_PAGE_SIZE;
 	e->__resv2 = 0;
 	return sizeof(*e);
 }
-- 
2.52.0


