Return-Path: <io-uring+bounces-13431-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKpaBYRODGqxeQUAu9opvQ
	(envelope-from <io-uring+bounces-13431-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:50:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8D857E05A
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96CA030D4906
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E804A2E0B;
	Tue, 19 May 2026 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0Kyt5Np"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0324A2E1E
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191097; cv=none; b=ul7f+ZUgxzEEQtLoljOInX4Pi7oeyb+4GUXaBZWBkYZK7oJs2TKPeXy80w5XcG7Xzk9P9Bm5lL8Zswp7agfKL9rbj5gCdZP2WogkW5jOOyks0j7hYlutufh/N30Up8stDGyIXFQABPRom3M6IDJd7q/+SOUBw0j9sTv6kpQw32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191097; c=relaxed/simple;
	bh=tltTlQ3YCwN7E+MKCK/eCm7hU0LC7TKmmGm6F8GyX/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMim/Rp6hPQ/cZWv0NHP2qUsK6dKvwMbLk0Vu52sDK3dC82PjwL5ebnKIbpBGNUVJ6iTlD7LaSloBn6/nH76kwML390ymqw7JmlnKEbfqMLuijEmx+F/IUnpdcYYOfiS7G2OonN423wYVOx3zjFPpTDoOuznk4KcDN9jsBg9/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0Kyt5Np; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so51435595e9.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191090; x=1779795890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLYW+cBqNKZlUyA1TVrGmuB7j5Td0XVJ7Y06ky9n+m8=;
        b=T0Kyt5NpzOptgR5dP4fAwGwf/sZJF3C8OA6rmY2Jq6enwYo2DHxRcBpzii8rM1Sffv
         Dsf5bgkBTgpuNTefsNAv3ZjBhMepWO8eGhmRq/1bbixeuLqypUChQxQN3X508O5lMTYh
         cJGPjs5GZMd4WZ903Jfp5Q9g8SjSl2jvWI4w7VvGkhlLxaT5B3XF4q5tcSSTogoGbXTk
         TWEVkST6jrwuD31huOeGhkEPzVT8baYQ52N9Nw5XuMU+07gk8Kz8mQv1aEMN3vwhEPvJ
         7rZsGomAVr5a9Jt6slWQ/Z8QmBmWeXr55rFc0YnL1urINXI39UqaZyBZPB+BRAsO7Bwg
         kOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191090; x=1779795890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLYW+cBqNKZlUyA1TVrGmuB7j5Td0XVJ7Y06ky9n+m8=;
        b=nVsmmMCaeiAO6llzO5ixjEevcCM0FFrx+HSBJ/lKqxR3+fJncm9m5SrF4tWfnOstqP
         2S9y0ML8gWhdoNbbSlOlnkZ9BMpB2kO9P7DVaMDrXyuq/3x7w/nNZE+nAKqod1oDZnK2
         QUs07vuYLeYVqfhLqZup0KrqAnooULGzvNCsv75znb9rE6RdBTeJxdTmFlnvhhjF967O
         ZkRuohjggoP2QLCiIpfpqoEG8rpvnLFtS3NnBumW0mcHfWDf2yJb/Yp/acDomVGBr+KI
         h5RQH7wZM7pHsJ4sEqZZwF/od225YBLPKQsEly4rNelgeFNE87LXhTtL71XzErv72Rcw
         OgfA==
X-Gm-Message-State: AOJu0YzuopyEZ3bXpxGwMcwX7XwswQRfzdt2S3/057KLFgz6/Md3TjER
	apcaxVPf1dAUBZQgHqM694G3hOggK7m03hB7kmdDhQSZvb63X5pHPePr+jnYWg==
X-Gm-Gg: Acq92OHhWOHmCKp9PzcT3A81WEBCNt3vFG7OYfPuEiu4w/iskTGfKw2a7YP67IHEr24
	llufBsW7rSQAaPSRiao0veM93tv887ngmOE+kBsSCoC9kyc7aQJPW9n/IAlEGUtpBaUGNj6k4wU
	5w/iI0FSjyE9tR4mFoPAya3Cw2RHs71AdzZmKR3y5ydZImrdjNIao1Uf/jFm1j0U/j8+0Q+dq3O
	2FbesNtF3CUnZqM+wKdI7EZP67pdH8xvhjaMg+McguK1es5nza9KWvP0c7CyoScQBqsX3UAmhOb
	MVSMtelnSGkngsI9n5RmVP22lVL2ZGPYcub1dArF/8omPblNv/zAoSMBDbkL7XRGREj8b93ETSz
	IQEixrwCoY/rYCfeLI5sv04arGoAC/YVh/j2QbA92uiPvVYqq6gocRe1ogoo92iEeFADtIeWhRP
	hiNTpwiFB1zkTPf59EcKo+/Pd7DyKbu4J6I3QZNkojTa8tjY4DtbYGQPZm8crwB1lGIAP84y/tU
	FMyUQjciBXxL/tUdJ+FVj9iutKyCQ==
X-Received: by 2002:a05:600c:4692:b0:485:4eaf:eb53 with SMTP id 5b1f17b1804b1-48fe632661bmr308857595e9.19.1779191089839;
        Tue, 19 May 2026 04:44:49 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 7/8] io_uring/zcrx: notify user on frag copy fallback
Date: Tue, 19 May 2026 12:44:33 +0100
Message-ID: <3d54bcd8bf10b3a1e88beb0cd39c40c3937bea4f.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13431-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 6F8D857E05A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Clément Léger <cleger@meta.com>

Add a ZCRX_NOTIF_COPY notification type to signal userspace when a
received fragment could not be delivered using zero-copy and was
instead copied into a buffer.

Signed-off-by: Clément Léger <cleger@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h | 1 +
 io_uring/zcrx.c                    | 7 ++++++-
 io_uring/zcrx.h                    | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 67185566ad3c..3f7b72b09878 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -70,6 +70,7 @@ enum zcrx_features {
 
 enum zcrx_notification_type {
 	ZCRX_NOTIF_NO_BUFFERS,
+	ZCRX_NOTIF_COPY,
 
 	__ZCRX_NOTIF_TYPE_LAST,
 };
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 455226790553..1e7c305da0d0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1533,8 +1533,13 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct page *page = skb_frag_page(frag);
+	int ret;
+
+	ret = io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
+	if (ret > 0)
+		zcrx_send_notif(ifq, ZCRX_NOTIF_COPY);
 
-	return io_zcrx_copy_chunk(req, ifq, page, off + skb_frag_off(frag), len);
+	return ret;
 }
 
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index e8b7717d6adf..54d91b580eaf 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -11,7 +11,7 @@
 #define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
 #define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE |\
 					 ZCRX_FEATURE_NOTIFICATION)
-#define ZCRX_NOTIF_TYPE_MASK		(1U << ZCRX_NOTIF_NO_BUFFERS)
+#define ZCRX_NOTIF_TYPE_MASK		((1U << ZCRX_NOTIF_NO_BUFFERS) | (1U << ZCRX_NOTIF_COPY))
 
 struct io_zcrx_mem {
 	unsigned long			size;
-- 
2.54.0


