Return-Path: <io-uring+bounces-3012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC11967F7F
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 08:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C7A21C20D9D
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 06:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DAD3C30;
	Mon,  2 Sep 2024 06:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q8V7e+mm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6156115C140
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725258652; cv=none; b=Tytnfxxe8rN7qxXph6M9nBvPwNh840p10J7uAAvkCIzeiX1gFX1pQbBqdufp+s6RVqlrkGaWIRxzT6/x9X783qCGr24hBsf+d75p9sy9qmHNbcnpXoJyomEp7OIZzWW+feYsWpH1/lrQSnWXmFTf9hKUzeB+SKq9le9bB1ecY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725258652; c=relaxed/simple;
	bh=WRY93CUbNk2e228cbO2zWgsuAyrGL2NQBZajjEwdNfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nH6YiLBnOol2prwI9ucamxgIBYNGwdN6iTnMa+kEUBzQhXCc1pHStrmZt8PGv6OMtCmX/sniG8FmC5jpM4OeZzch+pmiPXLGoFXlo9XJpClxH3QVvEpVMMEU3Qv1d66JWKtVKIg6vUmnf+u04j6EzAxBbX3shv7tR57Norjzsgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=q8V7e+mm; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240902063048epoutp013a12cc8bc259904095b8245b5ebf51a1~xWZl-cNni0718807188epoutp012
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 06:30:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240902063048epoutp013a12cc8bc259904095b8245b5ebf51a1~xWZl-cNni0718807188epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725258648;
	bh=wR+9/CmcgcSqRaHmSjUjZG+cFrJhHrF2EvYygWICBYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8V7e+mm67zrN+k4BV0qNLKrzbAeXLf0e2cg7h/VdWA3W8q44qnVUUSjO12xIgaJp
	 S35eQyhl+iBw8WG6KNJ+5fNVY2zV7H1K7lS4rDP1E5+TA5tDYmbaxa8TQMGfudOl8o
	 31qaypeHP4A9EvzvqJTJ5IDciJdCdXDO/jiy/tYs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240902063047epcas5p1c3106478e202c98c3f728ad809284d75~xWZlnqTGU0367503675epcas5p19;
	Mon,  2 Sep 2024 06:30:47 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WxzQs1Z83z4x9Q3; Mon,  2 Sep
	2024 06:30:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	53.85.09642.49B55D66; Mon,  2 Sep 2024 15:30:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240902062910epcas5p490bdf7aa1ee9f31491c7948de089f220~xWYLO9SII2160321603epcas5p4F;
	Mon,  2 Sep 2024 06:29:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240902062910epsmtrp2bfc0e62bb92fde31336c19c53f1153e7~xWYLOYKFB0595505955epsmtrp2P;
	Mon,  2 Sep 2024 06:29:10 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-33-66d55b94dce9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.88.08456.63B55D66; Mon,  2 Sep 2024 15:29:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902062909epsmtip2e1967004af7960b0a891bfb7bffb1ef3~xWYKaUTUY2333423334epsmtip2q;
	Mon,  2 Sep 2024 06:29:09 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v1 2/2] io_uring: remove unused rsrc_put_fn
Date: Mon,  2 Sep 2024 11:51:34 +0530
Message-Id: <20240902062134.136387-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240902062134.136387-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmpu6U6KtpBjPOSVo0TfjLbDFn1TZG
	i9V3+9ks3rWeY3Fg8dg56y67x+WzpR59W1YxenzeJBfAEpVtk5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
	X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXH14Cz2giaWir7ngg2M85m7GDk5
	JARMJPo2r2PrYuTiEBLYzSjRee06O4TziVFiz5xXLCBVQgLfGCUOLXbsYuQA65h9IhIivJdR
	YmGTI0T9Z0aJf6/eg9WzCahLHHneyghiiwhoS7x+PBUszixgL3Fu9QcmEFtYwFri2JP57CA2
	i4CqxJ6jV1lBbF4BK4mVHTPYIa6Tl5h56TuYzQlU3/tjASNEjaDEyZlPoGbKSzRvnc0McoSE
	wDF2iYtnXkI1u0jMOfUbyhaWeHV8C5QtJfH53V42CDtd4sflp0wQdoFE87F9jBC2vUTrqX5m
	kIeZBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1CtvBI75sHYShLtK+dA2RISe881QNkeEvNPX4aG
	dB+jxJSFx1gnMCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arFpgXFeajk8ipPzczcxgpOglvcO
	xkcPPugdYmTiYDzEKMHBrCTCu3TPxTQh3pTEyqrUovz4otKc1OJDjKbAAJ/ILCWanA9Mw3kl
	8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTBtYpQvSpkQ+157jobI
	4k6FvM4nF5c231NS0D8v6a9jd021wW/aqwsbTxqozUo9nBC8ctn5+496ExecS//1r/TFicvX
	vGYe2/b1hOKvlQqNU1+stm6tuPWWkcV5yo+Ys10BX3Vf8XbVP/rE9U3lQr97uqPzdVPFiDcf
	b/lee+UWbXLCN7FJw2LFqteHJb6lBzOavXLdp3Hm75w/Gd/asqQqZnwJrC2315ioNaWIY80l
	l9/XtSTLhO3YFZbd3mNw8WnwSqHHZvvvKv1ueVq/VcpOr84048+Mw65chezBYufX71+ll816
	X/LgNQtG7jK+PvVTnGp/o+/XMzDPW9cY8df23r1ldTcVCnUnP/pvH5ChxFKckWioxVxUnAgA
	tf4rwQsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvK5Z9NU0gw2T5S2aJvxltpizahuj
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKuHpwFntB
	E0tF33PBBsb5zF2MHBwSAiYSs09EdjFycQgJ7GaUuD9lKnsXIydQXELi1MtljBC2sMTKf8/Z
	IYo+Mkq82X0FLMEmoC5x5HkrI8ggEQFdica7CiBhZgFHiakbroHNERawljj2ZD6YzSKgKrHn
	6FVWEJtXwEpiZccMqF3yEjMvfQezOYHqe38sABsvBFTzYvNnZoh6QYmTM5+wQMyXl2jeOpt5
	AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBIepltYOxj2rPugd
	YmTiYDzEKMHBrCTCu3TPxTQh3pTEyqrUovz4otKc1OJDjNIcLErivN9e96YICaQnlqRmp6YW
	pBbBZJk4OKUamFpuMLdZXtykLSNjdu9/PH/L0rD2/bE/BUUmlR89t+nRYq2rKlrnr/guTW6y
	SfgvznTyx6e27e9+tkw7m/adTWdu15zkL5unOapmdFp1Fz31+Py/x2272lE/oz3sez7OWVg2
	d3lrUwS/j5ByoN7PYIXYyIbSCepm+U8+N6gzJGyWehKkaiZh7LZquqPtrdAQ9pVMtjZmx9l+
	Ku/qnvxZ6fE/p9daU2e7Fm9hPS7p0X/qTktRh5eu+KHd6przD6eXH15y+9n6e65i79cuPDo5
	QM/2lqyjRL6gprbOJsvlM38skZhyaOmkppnZky/e5VtQLlQ74/TWncEix3l3vn8uP/tj4vUd
	PFnPzfekpZy0llViKc5INNRiLipOBACp2NVXwgIAAA==
X-CMS-MailID: 20240902062910epcas5p490bdf7aa1ee9f31491c7948de089f220
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902062910epcas5p490bdf7aa1ee9f31491c7948de089f220
References: <20240902062134.136387-1-anuj20.g@samsung.com>
	<CGME20240902062910epcas5p490bdf7aa1ee9f31491c7948de089f220@epcas5p4.samsung.com>

rsrc_put_fn is declared but never used, remove it.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rsrc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 18242b2e9da4..3d0dda3556e6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -22,8 +22,6 @@ struct io_rsrc_put {
 	};
 };
 
-typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
-
 struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
-- 
2.25.1


