Return-Path: <io-uring+bounces-12788-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DqHMX03wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12788-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:52:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4282F23D0
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 223A2308B63B
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BC23A9DA7;
	Mon, 23 Mar 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alIjBcnD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0123A960F
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269851; cv=none; b=mE2s0jxfJNHX4YnwAgQAQgan6CHsMuFa5Kr/TAocSot0mbuUbTyT+K8SzdoSkdeYs9ZT1DavTftbOGju9tW3LYkbzB/DvrnGlO0oTNa1y1sHtWgjYlfkmWxfAkJkOtmZF3SQpQbNceQ3lK/YMQ29oXzdgfeeJ1mwRFVFSa0qvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269851; c=relaxed/simple;
	bh=3PqFNl2CbbMT4PkYRniP6Wz2XT+jlVykX2V+edhm5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a97TbzTDf3LXzrHxVgFTk87rvi+EbN82o7ii3QhQ5JXr0EtAY978tdnjYA14ExQh6Ik3bAYAtrZoxymxvwIJkS1AXlHLIt0hWOQN4MJ5+D2l2ofKQjm0GBF6ljYTQbSerBUTYKQNBVpx9Rl21FodolBClIHF/hr3+w13Y4kqcrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alIjBcnD; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439b611274bso2287641f8f.3
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269847; x=1774874647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVSoEpX/itEc8uhG9upz7mIqKPMavJ+nVW9CGEtH7p0=;
        b=alIjBcnDh8sqYkYudWxhVHreU9esIiMCJFowrObJsrWzEkiFxSQm0an/fJTVuaqHCD
         vDiB1EPbwSdot9+qf+cKVC8QXAqAMDFPrsuQzP5UWoriczdALqTKldY5NbPhFcW3LudB
         uJj69ePX+GWVTUygFGPBW062VFBzovEjwjWd/sUY53gwge0n9knUoTUd4o2zh81x0kV9
         JV3WaR2J3bMNBFZp48PHHxkxs2FioUslOvaPlLJHI9jiKBCL8c2DWIpc5y1Gvc3840xg
         7OjO0lr1uLEjlKKTv8lJNhUBj2+1t3syowaBTv4eRRya5ZQbxANxup/YSqSM7Gdk8U01
         Gg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269847; x=1774874647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZVSoEpX/itEc8uhG9upz7mIqKPMavJ+nVW9CGEtH7p0=;
        b=IE7d/IGIWLAsNSdLqCV+meCLC3S/nM5faBz/1cFEPardZYtgjJmpXSqUmcoGd7rhed
         0kvJQuAlk7IWBgDq0vpdjoDnIJi0Gvb1xRUQHkhG0P+86u8BgnpTDtbz4wwBiIPJl3dU
         mJMNEpm3ySQqvKjjygf2lx3UqaLAXmA6R2IK+WeVOvcoJfPW+dDRLd+w9SO5+7pHp1Iw
         6KcN3j/owwq+5bVdnpiLHCSH3g5jOgvwqDe/bgZg0uqW698Ft0cXEwhfzFlFocNFnt1S
         uN4T/TKayiJDWqkSf9pmbze3F034iw8Gbt5nJoGgpUZTnXifdxnPSWYEduAXUGU9PJC4
         4Dmg==
X-Gm-Message-State: AOJu0YzlIskZ1lGUI5vaLFKPstFs1Cn0oBo2MPTSxnPgLMsGkVbW7zOj
	Z3oje0BtosnYGzrXc9fCmijk4A7pD3GubkpkRKGHd5fRHcVWjUZZihVwubxlkw==
X-Gm-Gg: ATEYQzzgNqqHYI11hbCMaghIJo6DgPA4EuIOPga6jVYA7ozfqyUZEmODA3BZY2JMP45
	rR77PRAze44QHxMZAN6Oap0FGBL1lG7FJ2itkMFHh5vqruddUnPLrRZJuCqGGCsn+gScsAWrwrS
	6YukxRw4Le0TYiuXVGWHIokUV101Z/oLKRnneQ1wF/6vk7KtLTC09FeUpz7V8DfJQxX/dbJM38+
	VK9l9YF7F+O9VUxxNvbfHHSJH/jcwalh7sKdRD0PqZwy9CEkCdxIcKOOdeOrdubblgrU/9MDq+1
	bKacfdCA0LdHtxOWsDAf3ZxSd2RIWrDktM6m2xTgDtovE5j0wBzFqC4LUc578RAbUS3NuaKYVoJ
	D/C2lkLC2fV9IqwhPyokp9MVHdoPYZet6tyhP3OBIAx7UlW68w0uhdSbnbmvS1Ze7EJlvkaU2o4
	lvutD6qhBTfLANmrp1nIL3e758/dLLhQIUK6mjA7byohx8K7AmvbztwFqEHTwesG9DHBsu8VKAG
	mOPWKSDmtZc2BotV7rH
X-Received: by 2002:a05:6000:24c7:b0:43b:514a:ec78 with SMTP id ffacd0b85a97d-43b6423d986mr17817590f8f.1.1774269847124;
        Mon, 23 Mar 2026 05:44:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 04/16] io_uring/zcrx: extract netdev+area init into a helper
Date: Mon, 23 Mar 2026 12:43:53 +0000
Message-ID: <88cb6f746ecb496a9030756125419df273d0b003.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12788-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2F4282F23D0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In preparation to following patches, add a function that is responsibly
for looking up a netdev, creating an area, DMA mapping it and opening a
queue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 72 +++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4e8064fc5561..d2798a82c678 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -751,10 +751,50 @@ static int import_zcrx(struct io_ring_ctx *ctx,
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
+	if (reg->rx_buf_len)
+		mp_param.rx_page_size = 1U << ifq->niov_shift;
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
@@ -821,33 +861,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
-	if (reg.rx_buf_len)
-		mp_param.rx_page_size = 1U << ifq->niov_shift;
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
 
@@ -867,8 +883,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 	return 0;
-netdev_put_unlock:
-	netdev_unlock(ifq->netdev);
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
-- 
2.53.0


