Return-Path: <io-uring+bounces-1606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 302AC8AD379
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 19:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 546371C20752
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 17:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48446153BE5;
	Mon, 22 Apr 2024 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uQv3R/qp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E969152197
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808163; cv=none; b=LOTKahGrkMbYEpIKBkGWgGKEkkGVW0LNhcwjySYVExN3QVZw1lTK+Js6frcL3e9VXl5zrOR3NDQHSiRn3m5r0+7tb6clJ75snKMx1eCJ9EBy483E28ZP8WOD87WTKTKH1MvVCgWV6noNUGAm+1CmeU6eBfy91HcvJMFdYnUfsCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808163; c=relaxed/simple;
	bh=lWmXzExRfW4oddy21KyknChD3yXhPFbq3MHDw/hc3HI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=odn77+39L1i6mg/L6mEC2CxIK+NrbB94FRhBBE3Jt7SQmQHuZPVF8elZAFP6NzM04yar49H3/h6LIQQp1ekJNt4hfzbNTDI9Z/yAGxJdmHqpAyqN02EV2rpT0EDeLLk+CvS62MnxnjLlbiaFUoTgOrU3At9oODhHrpucDBlZREY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uQv3R/qp; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240422174917epoutp04acaa8be7013a8d9dc0c33b8cbbbdfbfe~Iq3BLrOWO0511205112epoutp04i
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 17:49:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240422174917epoutp04acaa8be7013a8d9dc0c33b8cbbbdfbfe~Iq3BLrOWO0511205112epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1713808157;
	bh=DaXbv/agppL5Z3C40xhGdhy/ZLZ6YngbGKSwwtVkPSQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=uQv3R/qpZaJOxf81J/up8dRf4D5eqRtyYyseCe3mKp7P+ftp8JDyYHVryUHHk0foQ
	 8bIFrOP5U4Rc/CeAb4CjtlaLlpo57MtfCZvb5BHVgqWLjm3Qx7CJWowBfQl130rWuV
	 TDXlLhx7mVByrpywh9vW2miJHmEcXJxVjHqXafbY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240422174916epcas5p13882faeb840628ca9852be31a0d8438e~Iq3A52BpT1690716907epcas5p1B;
	Mon, 22 Apr 2024 17:49:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VNXn73p6lz4x9Pq; Mon, 22 Apr
	2024 17:49:15 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6F.44.09688.B13A6266; Tue, 23 Apr 2024 02:49:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947~InfV4tpMH0862008620epcas5p4j;
	Mon, 22 Apr 2024 13:42:15 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240422134215epsmtrp100c11aa5931c0db8a7ed6563e4dc620e~InfV3hXwG3106231062epsmtrp1V;
	Mon, 22 Apr 2024 13:42:15 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-79-6626a31b0cb8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	86.45.19234.73966266; Mon, 22 Apr 2024 22:42:15 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240422134215epsmtip21335ed65157c2fd5c0b3980e27b38820~InfVK0ZcY1327413274epsmtip2T;
	Mon, 22 Apr 2024 13:42:14 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org, anuj1072538@gmail.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH] io_uring/rw: ensure retry isn't lost for write
Date: Mon, 22 Apr 2024 19:05:17 +0530
Message-Id: <20240422133517.2588-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmuq70YrU0g8V/ZC0+fv3NYtE04S+z
	xeq7/WwW71rPsTiweOycdZfd4/LZUo++LasYPT5vkgtgicq2yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
	Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIznjYv4Op4B1bxbkzy1kaGE+ydjFy
	ckgImEhs2PyaHcQWEtjNKHHoQV4XIxeQ/YlRYuuhDcxwzrSH/1hgOl41T2eBSOxklDj78CMj
	hPOZUeL17ilsIFVsAuoSR563MoLYIgLCEvs7WsG6mQUiJHa/ng20j4NDWMBe4nyvOkiYRUBV
	4s6E9WAn8QpYSLQ9+c4MsUxeYual7+wQcUGJkzOfQI2Rl2jeOhvsOgmBVewSb/e0skM0uEg0
	tK9kgrCFJV4d3wIVl5J42d8GZadL/Lj8FKqmQKL52D5GCNteovVUPzPIbcwCmhLrd+lDhGUl
	pp5axwSxl0+i9/cTqFZeiR3zYGwlifaVc6BsCYm95xqgbA+J3T2vmCDBGytxbmMz6wRG+VlI
	3pmF5J1ZCJsXMDKvYpRMLSjOTU8tNi0wyksth8drcn7uJkZwutPy2sH48MEHvUOMTByMhxgl
	OJiVRHh//VFJE+JNSaysSi3Kjy8qzUktPsRoCgzjicxSosn5wISbVxJvaGJpYGJmZmZiaWxm
	qCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QD084lYalbBVcp/Zads+9x22NJA+HDGys8922b
	8rFB5dYOpbrd1eYni33+vL6XzrWrSnaG/zyDCWaTW6U1tu1prSpSFP7w3am07pfaJrWmkBrp
	WxOuX4x5fWCbgv/EIxezjCMOsmuapV9/u2qjsl4H98lr6571Cvut2K68a8tGF7GJepsyDhUl
	rGh5LjPP6ItNhpS11o49B4491TZ0Ph3J8GjXIt7iQv4kfbVzPY8sDR9eT04rnfwgY+YC21Af
	1j1XDzys1U4K/TxdJGvqqop7zLdLns/92HBsybS8aTd/2HM28WlFzWj/v8//1Ldb7K1qqUHF
	di+XXhPyWjNxf+2nexLlHcZ6XwxWJR9zC9vFZqvEUpyRaKjFXFScCACdB25vAAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsWy7bCSvK55plqawd6PehYfv/5msWia8JfZ
	YvXdfjaLd63nWBxYPHbOusvucflsqUffllWMHp83yQWwRHHZpKTmZJalFunbJXBlPOzfwVTw
	jq3i3JnlLA2MJ1m7GDk5JARMJF41T2fpYuTiEBLYzihxd9lLNoiEhMSpl8sYIWxhiZX/nrND
	FH1klNjQsZIFJMEmoC5x5HkrWJEIUNH+jlawOLNAlMSG2T+Yuxg5OIQF7CXO96qDhFkEVCXu
	TFgPtphXwEKi7cl3Zoj58hIzL31nh4gLSpyc+QRqjLxE89bZzBMY+WYhSc1CklrAyLSKUTS1
	oDg3PTe5wFCvODG3uDQvXS85P3cTIzjktIJ2MC5b/1fvECMTB+MhRgkOZiUR3l9/VNKEeFMS
	K6tSi/Lji0pzUosPMUpzsCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamKJ36UgX89y9d/LK
	MoeZpfU3tTZ4T3526azMtxV8PtdqfNT/Fdx9efCtfor85rszc0Qc5nllW1w0TN3h/nrde8nm
	56+yrMoeROhu2qC0ln3jZWbj04e2VPX6vm3IUXoSXpD11SKDcdGBkKiPVWvL4r/tXcNx4sD7
	cw9udSb9ZHjs+NWib04y41ytdVfFQlUurjjUfiU+cWXzScGJJ/XmtZ5yWug9a1tn662r/9iN
	yqbsSH2ztfebSzbHcdV9hrUvCu0X9BdL6M2oYvtu+vN2j5b2zZl3237MOefKuNOtgq904o7P
	eZ9O2L2+sfWm+K0bauoTONcdTNBWOWcipHJ5Z/PDpe3zOX5nXn3waCf/Zc/bSizFGYmGWsxF
	xYkAZbj7XqgCAAA=
X-CMS-MailID: 20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>

In case of write, the iov_iter gets updated before retry kicks in.
Restore the iov_iter before retrying. It can be reproduced by issuing
a write greater than device limit.

Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4fed829fe97c..9fadb29ec34f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		ret2 = -EINVAL;
 
-	if (req->flags & REQ_F_REISSUE)
+	if (req->flags & REQ_F_REISSUE) {
+		iov_iter_restore(&io->iter, &io->iter_state);
 		return IOU_ISSUE_SKIP_COMPLETE;
+	}
 
 	/*
 	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
-- 
2.25.1


