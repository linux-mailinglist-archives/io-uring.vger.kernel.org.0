Return-Path: <io-uring+bounces-5247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 905B29E4D9D
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 07:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FE8C281024
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 06:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7588A199FA4;
	Thu,  5 Dec 2024 06:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="p14iLzkw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609F199384
	for <io-uring@vger.kernel.org>; Thu,  5 Dec 2024 06:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733380177; cv=none; b=CdNqIMdxyQPwO6dO660ehw9HQVMID9oGaLPqODwATXQGcS+zBrJfR0plLVaY/Ysz1CjyxPQcxqlTxPyGHQ4hvZucEWrt57d+SVKfpgvdgjD1oMkBvlm5YsVowUC36KUviga7KsXlukmL0Ab3Vt+6+gUXdKe6hN/3Bf5p9QktKpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733380177; c=relaxed/simple;
	bh=0i+nmq4Qwmwn/OCtZKpB14Y0/hMEmIoLYvobZsIH/AA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=IO5Ue+4kvYziJl9WbSTI/c7PZFeda4As7EQuavC5/itFecLisLt9vWss8wHiCjBbSQQbnkJFl1ShQoYpo3zQxgueDk+8PhCW2HVlvBFWSB12dgzyr+TwIoKkqRyK7IhSrsLv9BppHCQzTjMK1esBIhvYnIAMlytMxkzKXudSBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=p14iLzkw; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241205062931epoutp0262bd323feec678112ea8013a6cc4c2a5~ONBUWShUR2780827808epoutp02j
	for <io-uring@vger.kernel.org>; Thu,  5 Dec 2024 06:29:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241205062931epoutp0262bd323feec678112ea8013a6cc4c2a5~ONBUWShUR2780827808epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733380171;
	bh=TgPKReFp197WLmTvpzF04Tc/Z86p12AdMdfbIcFMIY8=;
	h=From:To:Cc:Subject:Date:References:From;
	b=p14iLzkwZWaVzS5nJ3M8yYt+3tKzYuzuZe/reFe3m4hdYDLb0nrKqiSssaFpEevoC
	 7VLfkZ8lm0nV96W8SaBOsoU86eg+O3TbVvcRGmkls0kTswdKzucRqV/AXw7DqzPEk7
	 osr0JqraOtU6SAzRahkB1S/kxXN+9mmnsk4HlK3Q=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241205062930epcas5p4917adc059a830e8c1bc804d68562c56a~ONBTlWGUA0420704207epcas5p4G;
	Thu,  5 Dec 2024 06:29:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Y3ky1514Sz4x9Q9; Thu,  5 Dec
	2024 06:29:29 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.8F.20052.74841576; Thu,  5 Dec 2024 15:29:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316~ONBA5JQcX1911819118epcas5p2E;
	Thu,  5 Dec 2024 06:29:10 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241205062910epsmtrp2de8267400262e656ebbf0892c87f5a2a~ONBA4Yq0R2903929039epsmtrp2D;
	Thu,  5 Dec 2024 06:29:10 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-06-6751484703ae
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.00.33707.63841576; Thu,  5 Dec 2024 15:29:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241205062909epsmtip1f8f1a719669b930439518cb25435a0ac~ONA-3IYu70732107321epsmtip1y;
	Thu,  5 Dec 2024 06:29:09 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com, anuj1072538@gmail.com
Cc: io-uring@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH] io_uring: expose read/write attribute capability
Date: Thu,  5 Dec 2024 11:51:09 +0530
Message-Id: <20241205062109.1788-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmlq6HR2C6wY6jjBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8az3HYnF+1hx2BzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZk28/Yy9o4alY
	vZu3gXECVxcjJ4eEgInE0r4XbF2MXBxCArsZJWa9fMUK4XxilLizaBY7nDN9xycmmJZVv96y
	g9hCAjsZJV6dF4co+swosevsdlaQBJuAusSR562MILaIgJNEZ1sHWDOzQLjEzGNvmEFsYQFH
	iXnPH7KA2CwCqhIdWzexgdi8AhYSnbPbmSGWyUvMvPSdHSIuKHFy5hMWiDnyEs1bZzODLJYQ
	2MQu8WTbNqgGF4knW/4wQtjCEq+Ob2GHsKUkPr/bywZhp0v8uPwU6psCieZj+6Dq7SVaT/UD
	zeEAWqApsX6XPkRYVmLqqXVQ9/NJ9P5+AtXKK7FjHoytJNG+cg6ULSGx91wDlO0hsbv/Gxsk
	sGIl7jS8YpvAKD8LyTuzkLwzC2HzAkbmVYySqQXFuempxaYFhnmp5fB4Tc7P3cQIToFanjsY
	7z74oHeIkYmD8RCjBAezkghvkHZAuhBvSmJlVWpRfnxRaU5q8SFGU2AYT2SWEk3OBybhvJJ4
	QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamNISJCuz6g/+YLrJvvL8
	vkcOkp83ZvMfOHPuTIHnnC+Rc295Sn94/1NRz8+sedHqd+/LN7NHyB07tLI+LqNCfNObVw9F
	C8L9LrFf/BvloWhfq5P9WKH0ucXk17s5dJ8uKZRN3zB7lfGxY28zHoTpft6+L/vg/TkGHF5K
	b78csVSTLti+rEz48IVS6ycF8V77REPU9WZP/pLWbnBYsTPvxMJlfeXGb2yPWQX9myOVoKMW
	pL3sroN36Z2SbkfbmFdz9ng+3Pu4KVTn6XNpKQ3+K7Nmb/T6mH3zkZBG7bcI9VnP6rhqxKu8
	Z0TOrgnLvn1eUZB5i+Xcff+45XZdTHr+1O2u9orJWu//rzrw4X31peNKLMUZiYZazEXFiQBR
	SvbCCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsWy7bCSnK6ZR2C6wdY+PYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SzetZ5jsTg/aw67A5vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQi
	fbsErozJt5+xF7TwVKzezdvAOIGri5GTQ0LARGLVr7fsXYxcHEIC2xklpi46wgKRkJA49XIZ
	I4QtLLHy33Oooo+MErt7v7GCJNgE1CWOPG8FKxIRcJO4974FzGYWiJQ4emgSG4gtLOAoMe/5
	Q7ChLAKqEh1bN4HFeQUsJDpntzNDLJCXmHnpOztEXFDi5MwnLBBz5CWat85mnsDINwtJahaS
	1AJGplWMoqkFxbnpuckFhnrFibnFpXnpesn5uZsYwWGoFbSDcdn6v3qHGJk4GA8xSnAwK4nw
	BmkHpAvxpiRWVqUW5ccXleakFh9ilOZgURLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUwBcct
	uWf6smT3u09iR38z9VYxHy6ZPH3fzyd62YX6ixS+Xvt9J6u0oEfczD4w5Uzvm5uq7zYe1FPs
	eTHf3mJLvsPSC04uzxqNty24b6epLmctvfZY9KNDMk+f3vm+PeDvpXj7tthHhf9vibM6lW7z
	9nqYH/vvo/CTDQ9TUtJvh89nig+2rP1us7WjTG3y090P33SEnNNWfantIsVr/CCmPpZtZ23Q
	hBjhy+tbPX9tmLR/mtubneIqv1y9rB5pnvlk/IPRekrU9BU6Z3nWaEbdvHB2Mf93oUvNTtev
	z7buivlZ4CNuc9dQdoep9w1Onme8s1fKinUYX9b/uVeJ2V3/npmU5fOZdwvUP/5fffi0qhJL
	cUaioRZzUXEiAPzs4WayAgAA
X-CMS-MailID: 20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>

After commit 9a213d3b80c0, we can pass additional attributes along with
read/write. However, userspace doesn't know that. Add a new feature flag
IORING_FEAT_RW_ATTR, to notify the userspace that the kernel has this
ability.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/uapi/linux/io_uring.h | 1 +
 io_uring/io_uring.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 38f0d6b10eaf..e11c82638527 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -577,6 +577,7 @@ struct io_uring_params {
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
+#define IORING_FEAT_RW_ATTR		(1U << 16)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a8cbe674e5d6..a895de54eb3e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3710,7 +3710,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
+			IORING_FEAT_RW_ATTR;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.25.1


