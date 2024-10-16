Return-Path: <io-uring+bounces-3727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA709A09F0
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 261561C22AA6
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422091DFF5;
	Wed, 16 Oct 2024 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sPhbQHLy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8875B20823D
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082205; cv=none; b=OaPQlxRKtVvfDAdoNjvW0JIVA8zAg3+7U54tAfihWA1HbklLzGf86AeggaRgoG6GTXTfm1o0GAyuFev59rlvYrLd1S+FVmIwSqk6RasU655bLYwLmiKUqkseEMUcXY6yDLnUfYFmK/CER5lkz9VA3jKfMIj2MGDPa+FsffMdnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082205; c=relaxed/simple;
	bh=Xu1LbGRncxovRrdMmeiSgMvWFfaeTe1/VhI1JxApEKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DY/JGNv+mWQyD+AibYr1J1saUAosbZAU65qaybXip7VLUBOMWPq4DQs0tuPznivoQn9m99IzoqShORucPpiBcXVgAWX8MRRwmYAz8S6T9oHR+Qvs8YDNx94sd5/jdvxRJ5RUKpjHC58lTwfiDWAA3R7aHT1cyTR+hKdRtrsCce4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sPhbQHLy; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241016123641epoutp012be078577ecee3557f93a65b8afc1feb~_7xnxxWwv1560215602epoutp01s
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241016123641epoutp012be078577ecee3557f93a65b8afc1feb~_7xnxxWwv1560215602epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082201;
	bh=ixWRd6Ku3AHLpgpPOdfQwfzu6Ddv6cbLE0o4Y5h4UVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPhbQHLyV3BJ0gPwaVUU0uhLZccN3jWWum31eHCRN0sS+BWDx5dSgLhKeLbiIqayM
	 jBs5Q2rlrknKiAKP4jsFgsTXVqkKOGvRzlf9jN4nOeOl4gdy8vPUfA39KQg0KqSTdB
	 LG4fENZXtVTeKVldUhQwpvDnefYAGOX6wp1HvfS8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241016123641epcas5p28eda85d51e3c2d8369f8a94bf82dfc8d~_7xnN5CRN1006810068epcas5p2-;
	Wed, 16 Oct 2024 12:36:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XT9Sl2YnBz4x9Pp; Wed, 16 Oct
	2024 12:36:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.90.09800.753BF076; Wed, 16 Oct 2024 21:36:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241016113743epcas5p3b4092c938d8795cea666ab4e6baf4aa9~_6_Ijwnih1066710667epcas5p3_;
	Wed, 16 Oct 2024 11:37:43 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113743epsmtrp22f1660c34422b1efbeeb7bfd71bfb89a~_6_Ii7uEO1555115551epsmtrp2f;
	Wed, 16 Oct 2024 11:37:43 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-6e-670fb357c8db
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.68.08227.785AF076; Wed, 16 Oct 2024 20:37:43 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113741epsmtip197a1754cc8002dde58ee35e56722c539~_6_GfTUfB2875928759epsmtip1G;
	Wed, 16 Oct 2024 11:37:41 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 05/11] fs: introduce IOCB_HAS_METADATA for metadata
Date: Wed, 16 Oct 2024 16:59:06 +0530
Message-Id: <20241016112912.63542-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmpm74Zv50g63ThSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOmPn4PXPBctaK64dOMDcwrmPpYuTkkBAwkZjydQ9TFyMXh5DAbkaJRY0gCRDnE6PEvJs/
	2SGcb4wS1269ZoRp+X98L1TLXkaJV90LmSGcz4wSs/c+ZQapYhNQlzjyvBWsQ0RgEqPE88uh
	IDazwClGibW/FEBsYQE3iYlLDjGB2CwCqhKPd91gA7F5BSwlPk4+xAqxTV5i5qXv7CA2p4CV
	xKlzB9khagQlTs58wgIxU16ieetssCMkBHZwSPzd2MsO0ewi0fRwCdQgYYlXx7dAxaUkPr/b
	ywZhp0v8uPyUCcIukGg+tg/qTXuJ1lP9QEM5gBZoSqzfpQ8RlpWYemodE8RePone30+gWnkl
	dsyDsZUk2lfOgbIlJPaea4CyPST2XvoLDdJeRompa1ayTWBUmIXkn1lI/pmFsHoBI/MqRsnU
	guLc9NRi0wLjvNRyeDQn5+duYgQnZy3vHYyPHnzQO8TIxMF4iFGCg1lJhHdSF2+6EG9KYmVV
	alF+fFFpTmrxIUZTYIBPZJYSTc4H5oe8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNT
	UwtSi2D6mDg4pRqYctff5entftxQLvDjW1fZ6+OP+ueczTqe67I5+P3VWSVruHhCV36uXTZD
	aNe1/6tMZ3W6mU9tSct+6sOzMbRxD7vOtD37ftg9ZJRt/3ZHuiWH8U7tq9ntk/xT7X/3Lc+U
	cW580PikKW/2lC8J2xIsExJzns61CfRexaX0fuoZofWf3PnS9btn8Ap0fV7QHX+LzZen+dSH
	bX3aR/XX/pdoncrsvoj/Wp3ePpvi+68Kv8SLLY70P6b36t/Zkr3LvJzO7DO+V3HLadXRCLHn
	svsrTGdU9GzRu+AUvK94kXobU8WSCbldirVPeJq/WxtHuEre/n/4qlzhK7uTTrcOP60rSeDQ
	2KYUc9hnZsKbnuqZSizFGYmGWsxFxYkA5bzw6VcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnG77Uv50g8kv+Sw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGcdmkpOZklqUW6dslcGXMfPyeuWA5a8X1QyeYGxjXsXQxcnJICJhI/D++l6mLkYtDSGA3
	o8TDZb9YIRISEqdeLmOEsIUlVv57zg5R9JFRYsr7/0wgCTYBdYkjz1sZQRIiArMYJQ7Pmg82
	ilngAqPE1X3P2EGqhAXcJCYuOQTWwSKgKvF41w02EJtXwFLi4+RDUOvkJWZe+g5WzylgJXHq
	3EEwWwio5t/kD4wQ9YISJ2c+AbubGai+eets5gmMQGsRUrOQpBYwMq1ilEwtKM5Nzy02LDDK
	Sy3XK07MLS7NS9dLzs/dxAiOIC2tHYx7Vn3QO8TIxMF4iFGCg1lJhHdSF2+6EG9KYmVValF+
	fFFpTmrxIUZpDhYlcd5vr3tThATSE0tSs1NTC1KLYLJMHJxSDUxWtcc3Sf7+YX6GoXT7us4Z
	botu/nrXNi/iysbtf9wfnZb6cNOBby337Sd/b6rfDP4V9PFZZe/Td7u/us1vb33y0NCsNJ2j
	MMolb92OztdndgXuk1+/uS1l16IfV5az/rw3MX8vv3j0I96OuEjmG9O1xVkEm2zu+e6+VXnB
	dpvui9/9pQxGf68sTfslVKdxzqrl0Ln1lxPlayatWBDYvbJ50dbWSq0vRp/sv1zs4TJ7UPz7
	G0dnV5O+7L+DqQ0db8SnacY8dd1dcPC+6bWZP9dpvGeVf2vbEvH72u3w/SbRdypuCH5blHOA
	4esxwx3C/bOnr5xkP1voi2d6k3H/3p1P2+TvLDz7c4ubo+pV03WicUosxRmJhlrMRcWJAEi5
	2IoPAwAA
X-CMS-MailID: 20241016113743epcas5p3b4092c938d8795cea666ab4e6baf4aa9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113743epcas5p3b4092c938d8795cea666ab4e6baf4aa9
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113743epcas5p3b4092c938d8795cea666ab4e6baf4aa9@epcas5p3.samsung.com>

Introduce an IOCB_HAS_METADATA flag for the kiocb struct, for handling
requests containing meta payload.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3559446279c1..f451942db74b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -346,6 +346,7 @@ struct readahead_control;
 #define IOCB_DIO_CALLER_COMP	(1 << 22)
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 23)
+#define IOCB_HAS_METADATA	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
-- 
2.25.1


