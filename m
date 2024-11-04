Return-Path: <io-uring+bounces-4417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F4E9BB980
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22F4CB2101E
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEBE1C07F3;
	Mon,  4 Nov 2024 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ur0EzeqZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756121C0DF3
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735777; cv=none; b=e4uoMRrBHfnlXqwrXaT72/nPrfkJY+kZoKZyO4YXMCaPif4Z6g8OykzmcaEhTt0yyzKQNWrCp994ztjO9FUQiaOaVifeFds6cijgwJvpJGFXneVpwFGSQizd3Abf4us7XK4TNLn9CqTDvSNDR4aFQYFzIZvWnFDq/v92lfEzfDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735777; c=relaxed/simple;
	bh=PPDNMGOuEvkJDIU7LllEytV2427zo9AzbP3ebXn9pJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=mmPpE/S7R6DZoDrXh3xD1AN50dYB1BTZlgcJkBfagk92Iv4u5AzxT64uceA+WlGgGnHKHT/IMvYPNlUo+5RBcstjC0AWKYB9qm9r8OgIZyx/m3Mzqm7YG7AixBw6xJKolOrRCsbIoV+ntZsNN+MVnNax5NSNluDueErxseSwNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ur0EzeqZ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241104155612epoutp0487a84ec53ba536b1c29996a67935cf5e~EzwPxH_DG1247412474epoutp04Q
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241104155612epoutp0487a84ec53ba536b1c29996a67935cf5e~EzwPxH_DG1247412474epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735772;
	bh=0Qev84oB/WNNKAORKgHjGWYS6Jca41BG3ZIzsvdmNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ur0EzeqZ8s10zEmgkjwF3CDxrhCnmJ0jz/kQkGPt9Lp8TfTsPl4wUXgPrpV/BOzaE
	 vcyySZbnBodIOV90iFE7F/QprkNvZ9Ui8rmxQwLd15NxOu1xqx+Nl5jXa2iHw9jm8u
	 otXyxbYgmC8GolzyIrfAxcbJDEohimFP9q1+k6NY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241104155611epcas5p4f6ca1d9f35d73c18873bfb1b7cccfaec~EzwPDTMVt1901719017epcas5p4O;
	Mon,  4 Nov 2024 15:56:11 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xhx0B1y3hz4x9Pq; Mon,  4 Nov
	2024 15:56:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	22.DA.09800.A9EE8276; Tue,  5 Nov 2024 00:56:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241104141456epcas5p38fef2ccde087de84ffc6f479f50e8071~EyX0xLPPN2420824208epcas5p3A;
	Mon,  4 Nov 2024 14:14:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104141456epsmtrp1f8075e736025a0e20cc83f1ed67e0f9d~EyX0wYXRY1340613406epsmtrp1K;
	Mon,  4 Nov 2024 14:14:56 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-39-6728ee9a70d8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0B.68.35203.0E6D8276; Mon,  4 Nov 2024 23:14:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141453epsmtip2bc39da8da09bf780b329cc179e0ae39e~EyXydls4O3023030230epsmtip2v;
	Mon,  4 Nov 2024 14:14:53 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v7 05/10] fs: introduce IOCB_HAS_METADATA for metadata
Date: Mon,  4 Nov 2024 19:35:56 +0530
Message-Id: <20241104140601.12239-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJsWRmVeSWpSXmKPExsWy7bCmuu6sdxrpBvN+clh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygd5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
	BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlrT69hLLjCWrH+VgtjA+M1li5GTg4JAROJLUsX
	sHcxcnEICexmlGj8+pYJwvnEKDHlwhsmkCohgW+MEp8+SMF0vOr6BdWxl1Fi5dS5UM5nRomN
	F1+zg1SxCahLHHneygiSEBHYwyjRu/A0C4jDLPCSUWLpqkVg24UF3CRmzjgNZrMIqEpcm76F
	GcTmFbCUuLK1kQlin7zEzEvfwaZyClhJzPl7lwWiRlDi5MwnYDYzUE3z1tnMIAskBC5wSFxb
	v5EdotlFYlp7P9QgYYlXx7dAxaUkXva3QdnpEj8uP4WqKZBoPraPEcK2l2g91Q80lANogabE
	+l36EGFZiamn1jFB7OWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kGKNtD4unab9Dg6mWUmHCy
	g3kCo8IsJP/MQvLPLITVCxiZVzFKphYU56anFpsWGOellsPjOTk/dxMjOJFree9gfPTgg94h
	RiYOxkOMEhzMSiK881LV04V4UxIrq1KL8uOLSnNSiw8xmgIDfCKzlGhyPjCX5JXEG5pYGpiY
	mZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwHQin9OUzUH3+q2pa++cintw2O3o
	N72w9gCXiXdfKIWcNgqW3ffA6M0a99kmrznvf7l4dfvZ5Y27sr6ayQayPXgxxyHYxa5C3u6c
	7t51/lkzxZxXt3/M5s7dzLLgT89q71OT9ThX6bS27tkQPpv7uIjPuWnTbk9TCbC9nBP/STgy
	M83+cuQ927des7SFwzl/l3Joc+Vsst96/oVF4Z37E4rqVP5d1t/xwHmDS4H7c9azjpLSxRH5
	f5/sXGK+antY5p0lsjdUD+uvWC/Urbuh84x455QrevODuW7+UVFUO3O1K4c3JT7xV84CL28N
	7gu2LXvPXGB6LBP442/zXt7XqY/bZ9SEt5xccWS7w76X6Q1KLMUZiYZazEXFiQDhTTLIbQQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXvfBNY10gxPr+Sw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxtrTaxgLrrBWrL/VwtjA
	eI2li5GTQ0LAROJV1y92EFtIYDejxJ75UhBxCYlTL5cxQtjCEiv/PQeq4QKq+cgosevUNCaQ
	BJuAusSR561gRSICJxgl5k90AyliBima8GU22AZhATeJmTNOg9ksAqoS16ZvYQaxeQUsJa5s
	bWSC2CAvMfPSd7ArOAWsJOb8vcsCcZGlxKamSywQ9YISJ2c+AbOZgeqbt85mnsAoMAtJahaS
	1AJGplWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMFxpqW5g3H7qg96hxiZOBgPMUpw
	MCuJ8M5LVU8X4k1JrKxKLcqPLyrNSS0+xCjNwaIkziv+ojdFSCA9sSQ1OzW1ILUIJsvEwSnV
	wMRU69RmeOdYzsbnt7yq+SP/TNiybNLqWzOcTPf9KNBKFXhwab/mqS/PP/2LOC+76ReLxuZw
	rrSZ9vvWsVif/PM04eBvplvOJ7g+FMS2v1xvwXNurl1p7nLl60stNq9/qC35L1nI9d/VSZ1q
	89YeV1n80+r0p2vu/Jdjl/ZNXtB43J2Z073rreLd3eJfpnaevOjYssmJc17H+0y/aXHRASyt
	U+ILruZd4JZ91Cag1Plv2/zbja+FPacs+p7Ul7bo1c4+NmW5/3O2uzw9dKfMm7N8aXTLt+LV
	7GXaqwWtfxQpLW+f8XzhDO3D0yQ+erj0VAt5HBBMmbCgrOPv1XMy11e0bXd2qTxjJj8rJW3m
	ulolJZbijERDLeai4kQA1JajCSIDAAA=
X-CMS-MailID: 20241104141456epcas5p38fef2ccde087de84ffc6f479f50e8071
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141456epcas5p38fef2ccde087de84ffc6f479f50e8071
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141456epcas5p38fef2ccde087de84ffc6f479f50e8071@epcas5p3.samsung.com>

Introduce an IOCB_HAS_METADATA flag for the kiocb struct, for handling
requests containing meta payload.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b5cad44a126..7f14675b02df 100644
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


