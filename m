Return-Path: <io-uring+bounces-12552-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCJKFaonqGnoowAAu9opvQ
	(envelope-from <io-uring+bounces-12552-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 13:38:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6A81FFBD8
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 13:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AA84830185C9
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 12:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0797913D891;
	Wed,  4 Mar 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzHi1LdL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B7C8F49
	for <io-uring@vger.kernel.org>; Wed,  4 Mar 2026 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772627874; cv=none; b=bvTCLcrdalbsa2fRkm37ImgFJ6GaoiGEaVv2T1DPKDqPjcF5TX91wnoHCa6AlsWhk44xK7w/2Az75p2msu03qKcQ1o1pGXYALDMo9laYxxk4ZxCVb0bYw8uAapi3FYOW6mAb4oC5Clx6J/qNDWMnJUPuPOYLRQjp1hXdS2JvbfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772627874; c=relaxed/simple;
	bh=zJuo7qMutHORFwQoVNSSuIoEfHsEUlmjBsGv1qbTk3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxdyCYl3M7Q/oTtyTGq4xQuaJH6tdnIG6ttDRkHcvKxKtRpSXTKz5PCAVbIUcHUMuD0M9w1TAv5FpRhMy5iTHYLNd0UL9sRtS8QujvEKbzNWlzQV/DHdXnJ49ssQamTKVIHpA8YeP0hgRVVyFr7LBv2jHaY3oIpMUqkzg796/jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzHi1LdL; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483a233819aso66918435e9.3
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2026 04:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772627872; x=1773232672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UxB/uFtMk7BfQyoh1WMZKIcALFnrrxe/IZwZ8/zch24=;
        b=RzHi1LdLnHZhTUDlkDjWx705yW7nMp5SCcE6YFZo+lgpo2RoVx4FnG2xpfN97NIp0A
         svpyAyC3+EssTHbgM04HQYwgtEwtssaRDmTBgUUunNPVmCRcP3XaucIMEgUe9e0XAnVP
         0J9oDvky1YRAlXKA+P9i4v998vZjUZyq12a+/hHFu2xG7Uw14CQQzNhyJc1EMWZUZbPI
         Q+LTMdc9lRJ/dHTASXqDcf3oQERjxCZmfR9RUS3gk13NVVuf2bz7PwgXIrIfu2Qie9D7
         vyV1+2762D+SLCno+tpjiRJaflZWyVKaHi/HxgjXZw+Zc/chwm30YvEN2yfNiegi3J8O
         aI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772627872; x=1773232672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxB/uFtMk7BfQyoh1WMZKIcALFnrrxe/IZwZ8/zch24=;
        b=LpV+bOgZcDAHpDPkLiEYmnNkRvpSOcbIv6/HtomnxF+LHMTUiENR47TT3Ir5rWZ0rY
         EZ+W/twYeeR1zyTOPkuW2IgYo54LmYDPcQA0cyFC/amr8c0d5+VXnsPjm2A+dp56ogWh
         x6Fung3+Y2fq5SGNAgzCdExckRwOA18fq9xKLkp7Jc2hbElxVaVE6hmqigi706oBx5zr
         EVThjKO5Swb86wGLprvtBWQfPKK/Pe3kHJxSyvfz6VKztlk2LwOiONhxa6RTE2RosmzG
         U+cq7k88MeZ8oVVc9eFaeg7vGxX+/v2hNt8QneWRREza+fMEfClcMx9RhXI+fT/VVyDW
         QmJw==
X-Gm-Message-State: AOJu0YwT4sehqF8/Fxw83D3c2FGA+ikUxHYQjzIWmaWiF2gd2yh9twc8
	sy4I602g9genbDVD1pdr++7HLpLEfcPFXSAvePgEJQww/gPHBreTDAHD8MzUPQ==
X-Gm-Gg: ATEYQzzfDT7tTU2JNXPgxLTNCjG4+AJsBgKJcvI0xy4Yf4tP0DNlrNGrVTHh16mBSk9
	TdheIzTyluFmJOsxPoo/0B81yg8u2d9jdrRukc5umAac89thxXakmBcMV1rPm09vNwhhPuH+MQz
	9w2oru0TGCMm+H3I0knJT0gA+9r7KgX7d17eVUi/ilZsgl7bOjJZHHd20xlGVrEMFRH1DXSFFTt
	FOBisAhXjfAbw6c3CWcXDyhbD222rclA5Cidy06cnZ9sG08bczv8UCfrDeYSJ5TXSgVbPCBmLXS
	JLREOJBLpM7AU89pqlaldx1QtgI8jkEHj1t7RcFXemKJ7EEqroGdTi9WmpaMwR9CEN1y+jqeI/a
	XIQHQHVxWTKR7Clzea0btMFleI7Pi/1JXkSLRFLG5ew7P21d0ud4yrLErRW60GTQP1hq3kVa+7C
	zi0OhRz6jVcepQffMxMnzQ9UU8v5yHQCmP6HxOpp/u4V1BTj1KAM0ygG8i3JdGlMcHrlsBw6Tp9
	sh4/96eklfXfy4apjxOKkexOIpF2A==
X-Received: by 2002:a05:600c:8105:b0:477:7bca:8b34 with SMTP id 5b1f17b1804b1-4851983bf08mr28109745e9.6.1772627871679;
        Wed, 04 Mar 2026 04:37:51 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851a7fef84sm26505775e9.1.2026.03.04.04.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 04:37:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: use READ_ONCE with user shared RQEs
Date: Wed,  4 Mar 2026 12:37:43 +0000
Message-ID: <e93675f7a196a178d2f389c69ad96079cf98e1bb.1772627580.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C6A81FFBD8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12552-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Refill queue entries are shared with the user space, use READ_ONCE when
reading them.

Fixes: 34a3e60821ab9 ("io_uring/zcrx: implement zerocopy receive pp memory provider");
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 19b287d21f4b..0461edebb042 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -927,11 +927,12 @@ static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
 				struct io_zcrx_ifq *ifq,
 				struct net_iov **ret_niov)
 {
+	__u64 off = READ_ONCE(rqe->off);
 	unsigned niov_idx, area_idx;
 	struct io_zcrx_area *area;
 
-	area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
-	niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
+	area_idx = off >> IORING_ZCRX_AREA_SHIFT;
+	niov_idx = (off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
 
 	if (unlikely(rqe->__pad || area_idx))
 		return false;
-- 
2.53.0


