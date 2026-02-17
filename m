Return-Path: <io-uring+bounces-12280-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCEEGR9KlGn0BwIAu9opvQ
	(envelope-from <io-uring+bounces-12280-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F6114B156
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7F26C30093BB
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 10:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD4F32D435;
	Tue, 17 Feb 2026 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPgcdCSM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32732C932
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325946; cv=none; b=Qk5Rpxlmvug8CfnuOCPXkdu0YEDzkeW2xaa6fTVWkga5xlEf70ZI7WTe1H67uKduncEq1mJL7t9q64IDHfpJ3nuYp8q899OKDRawsMj0+XcaLog3NFxz8cSXRPIMPJbTiggIHbPW1dtW5qysJcX77YUgYXS32HsCeZuU8zB50Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325946; c=relaxed/simple;
	bh=iuKLo1ze41U4tMnflrhN9XPXlGIUP/yAMOJmQ7Kw5mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOwHLcwdEv5HpeuHmPc+2wS6bD2J45x0m0l+5+cuuN6tcJA1EwWQns/ODzBS5KBySvGAgkv+ybstbYAsk4SglHYFl1WZD9UlL1+jesLLpabYOoyNzNd6gcX94KILbgf+kwSJqTLZ8rgmmCKC3QHlKszvhPyLWfxTbAxLPEqCXzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPgcdCSM; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4834826e555so41115975e9.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 02:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771325943; x=1771930743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZFEuqO6F24TJ5BkI+KBP+jkDWuQK6aufjjtltGbS2s=;
        b=UPgcdCSM77y9FEPvhLcIQm4EWpxUpsd+WwPxM/7X0ClCy665RI4Y8V/5hXRo/j6ZlT
         ibNpV0vqJjEAYTSQIXL1rK0wYk2WMCalaEC/fNH2zhBO56S1zCmb+YvRuWjrZlkzlF15
         +6PQ35VWm3b04gn7z5D6UJywx9jLs91txd+wsCKabOI37qUoT9IUUqcSxq85WF9Q26gZ
         6FFYMp0KXitxrnQA54uA0V0InyjhuS0ZTg0DdH8HeF5H9UsHOugn5oGiPXHb1A6fhTs5
         shl/8vDYDJ4lFKdyGF0nYM1F2kgXIfJedH1jxx+SiIA+6m6lVOupjPbol3+UYqGWGcnV
         F12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325943; x=1771930743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QZFEuqO6F24TJ5BkI+KBP+jkDWuQK6aufjjtltGbS2s=;
        b=ULGShkaH58CpO3MK3cQna1Kvno7sfUo+EWnNPlT3IXaXJDsdQ+Y/Kr9MxWVj63YvH6
         ZsyYq7+Q+flb5cwVO6OV1pLnoyso9hK6xuyr/mcT4Fa4z6b5FE2OR7ZyEo8BwsmgUj19
         5y4txONsrWeiT5pumrzOJKYQ3tsL0cqA+bekjQCxA4HfC9Fj1N9nHE76mQz4/9EGcHSD
         iKWlNR103c9HeJWVzrNpcRFnBZtIQ1u6NbpOeP246E21KA4zrCOoaR4cqfupCwlmsnwN
         u5wNqH1G881r4BxRDDYsWYRAbF6XKih7qficqk4xiwziS8lOX4wvCPzqu45GbU1TDJSe
         RhRw==
X-Gm-Message-State: AOJu0YxWy/Tr/bAiPIZcnwgP/ezFSRcYqnY5ni6/t5Pi2nJxVissXz07
	GoyLl2Vp13WxkKw3X9+NyHWeY28nCkWU7J3mfbisJZXhogf4ttqte5mz8rC+pw==
X-Gm-Gg: AZuq6aKESi5dp9b0WBE4EH6HK3X/C+i4cm8aHgK6S2Pz6l/tdLXH0l3R9EecqCF/da3
	17AWGaGVmV9eku2NWNgTPP3xy1fgUuaqjQ44mYvBN4jULgIa0dWr+5z48oQf7Z7gOToMGJx3pfl
	2T6V+y7IHW3z0oenh98U6aTvtbBPvVTckbh+6Q2cmyVoS+1fD2DkGlzF7BqNGT6yB6GprasD6Ty
	en4sg9smN2vr0vKPyIWSdVH1rrA8R3oQtR8BNTjkwqgHSOplR0hz0Ig/QowTyicFdK/RoqTmPK/
	U8tzEk983E6C4DCkvBhlcMFPf9VLIBtzaE3/1VeV9Xj8ArK5qPtVHGBLApA5kqnkGJnciDO7cqE
	tkuQOIzqKa2bQwvFJKS5Tua+u++1WzXfaX2b4FmU26ZD6U2LAgxQC/0chk2WQnuhr/SPJ5tf9Ld
	GV8ulzPiLZES9rEMZ8RPfPKXppx4ieUR0K94nIu3OT1C8cjPOUK/0XdPkJCwT+axMBLnbnVTf7i
	2p85ucAvMlENZeolVmqRomuIX+y+w==
X-Received: by 2002:a05:600c:83c6:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-48379b93357mr152538155e9.4.1771325942644;
        Tue, 17 Feb 2026 02:59:02 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a78c89sm327759395e9.5.2026.02.17.02.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 02:59:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH review-only 3/4] io_uring/zcrx: extract netdev+area init into a helper
Date: Tue, 17 Feb 2026 10:58:54 +0000
Message-ID: <62137cc7dd9d7e5ae6849af5d75ac9b23e9223a3.1771325198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771325198.git.asml.silence@gmail.com>
References: <cover.1771325198.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12280-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 94F6114B156
X-Rspamd-Action: no action

In preparation to following patches, add a function that is responsibly
for looking up a netdev, creating an area, DMA mapping it and opening a
queue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 70 +++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 290db098cfe7..4db3df6d7658 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -742,10 +742,49 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int zcrx_register_netdev(struct io_zcrx_ifq *ifq,
+				struct io_uring_zcrx_ifq_reg *reg,
+				struct io_uring_zcrx_area_reg *area)
+{
+	struct pp_memory_provider_params mp_param = {};
+	unsigned if_rxq = reg->if_rxq;
+	int ret;
+
+	ifq->netdev = netdev_get_by_index_lock(current->nsproxy->net_ns,
+						reg->if_idx);
+	if (!ifq->netdev)
+		return -ENODEV;
+
+	netdev_hold(ifq->netdev, &ifq->netdev_tracker, GFP_KERNEL);
+
+	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, if_rxq);
+	if (!ifq->dev) {
+		ret = -EOPNOTSUPP;
+		goto netdev_put_unlock;
+	}
+	get_device(ifq->dev);
+
+	ret = io_zcrx_create_area(ifq, area, reg);
+	if (ret)
+		goto netdev_put_unlock;
+
+	mp_param.rx_page_size = 1U << ifq->niov_shift;
+	mp_param.mp_ops = &io_uring_pp_zc_ops;
+	mp_param.mp_priv = ifq;
+	ret = __net_mp_open_rxq(ifq->netdev, if_rxq, &mp_param, NULL);
+	if (ret)
+		goto netdev_put_unlock;
+
+	ifq->if_rxq = if_rxq;
+	ret = 0;
+netdev_put_unlock:
+	netdev_unlock(ifq->netdev);
+	return ret;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
-	struct pp_memory_provider_params mp_param = {};
 	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
@@ -812,32 +851,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
-	ifq->netdev = netdev_get_by_index_lock(current->nsproxy->net_ns, reg.if_idx);
-	if (!ifq->netdev) {
-		ret = -ENODEV;
-		goto err;
-	}
-	netdev_hold(ifq->netdev, &ifq->netdev_tracker, GFP_KERNEL);
-
-	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
-	if (!ifq->dev) {
-		ret = -EOPNOTSUPP;
-		goto netdev_put_unlock;
-	}
-	get_device(ifq->dev);
-
-	ret = io_zcrx_create_area(ifq, &area, &reg);
-	if (ret)
-		goto netdev_put_unlock;
-
-	mp_param.rx_page_size = 1U << ifq->niov_shift;
-	mp_param.mp_ops = &io_uring_pp_zc_ops;
-	mp_param.mp_priv = ifq;
-	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
+	ret = zcrx_register_netdev(ifq, &reg, &area);
 	if (ret)
-		goto netdev_put_unlock;
-	netdev_unlock(ifq->netdev);
-	ifq->if_rxq = reg.if_rxq;
+		goto err;
 
 	reg.zcrx_id = id;
 
@@ -857,8 +873,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 	return 0;
-netdev_put_unlock:
-	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.52.0


