Return-Path: <io-uring+bounces-4687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4989C9C88BB
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EF5A282B22
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8891F8EEA;
	Thu, 14 Nov 2024 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YHSThZ5o"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B921F8920
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583211; cv=none; b=XXUexhnQm/m55O41V5QjCgW0dJl2xdI8YllaUDk4E32Zl1A7ENOH+Y7itt6JGs9W3arOdcr+/VkIpaXErlq3pnIyCV1mBwDWHDaI+sxOzFCEB2mDNPGQXWyCgzhXpDSceXsdAiUb5Fk4H1VjhOTSXjRmuim+spNNRKtixLgqIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583211; c=relaxed/simple;
	bh=PPDNMGOuEvkJDIU7LllEytV2427zo9AzbP3ebXn9pJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KB2Z97miuPxncT+3R7qQODAO1tkgiw7LMMZeo93auqrFcFYv8V2hwihurBOFEsQS2f6PaNGC+qhH/P07u49cSJSfhADF3YllU7A3j6Y1CdY7aZqqzE/dLSs6fYUa2BxE/aRvQBE1FiSBZY3gYvSFAWvHs6FfjnXDE2lLQbjUTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YHSThZ5o; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241114112007epoutp02f1bc7b89d9d9a9b3c071a4987a5e24dc~H0cDXeQ8r0573305733epoutp023
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:20:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241114112007epoutp02f1bc7b89d9d9a9b3c071a4987a5e24dc~H0cDXeQ8r0573305733epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583207;
	bh=0Qev84oB/WNNKAORKgHjGWYS6Jca41BG3ZIzsvdmNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHSThZ5o1xsaqVz750hiIlC852GqUiM1IQXXw1DR/beIhr5836ZE3Wt+YIIXkUj9N
	 qfRNaeZarEv1+hoFwMNJExVHZa0hqsNqhliNPS25Xm22LMZlJJJoYFSMoAjS18dDAW
	 rkJsGqf8ZgnQONuG8cr2FwWIsT5l8FerIGXJfbvw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241114112007epcas5p2c0c280818e38dd3044fa0b8aeec9bbd2~H0cC4FZ8L1060210602epcas5p2B;
	Thu, 14 Nov 2024 11:20:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XpyP05d2Tz4x9Q3; Thu, 14 Nov
	2024 11:20:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1C.DA.09420.F4CD5376; Thu, 14 Nov 2024 20:17:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241114105402epcas5p41b1f6054a557f1bda2cfddfdfb9a9477~H0FRiATPP2479024790epcas5p47;
	Thu, 14 Nov 2024 10:54:02 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241114105402epsmtrp219b5de0bea165464a14f74580ee83897~H0FRg6MAH2100721007epsmtrp2G;
	Thu, 14 Nov 2024 10:54:02 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-f6-6735dc4f96cf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.B3.08227.AC6D5376; Thu, 14 Nov 2024 19:54:02 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105400epsmtip2f563123d90e413f262c86ef493005d03~H0FPOEslx1406514065epsmtip2V;
	Thu, 14 Nov 2024 10:53:59 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 05/11] fs: introduce IOCB_HAS_METADATA for metadata
Date: Thu, 14 Nov 2024 16:15:11 +0530
Message-Id: <20241114104517.51726-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmuu7jO6bpBmeeG1t8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygd5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
	BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlrT69hLLjCWrH+VgtjA+M1li5GTg4JAROJE7de
	MYPYQgK7GSUe9Zp0MXIB2Z8YJXYtWMcG4XxjlJg67TcbTMe22avZIRJ7GSXuNNxlhXA+M0o0
	vbzDBFLFJqAuceR5KyNIQkRgD6NE78LTLCAOs8BLRomlqxaBbRcWcJP43jcLbDuLgKrEs6Nz
	WEFsXgFLiUXdp1kh9slLzLz0nR3E5hSwkljRsJUZokZQ4uTMJ2BzmIFqmrfOZoaov8Ih0fg1
	AcJ2kfg4fxM7hC0s8er4FihbSuLzu71Q/6RL/Lj8lAnCLpBoPraPEcK2l2g91Q80kwNovqbE
	+l36EGFZiamn1jFBrOWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kGKNtD4tzZSSyQ0OpllNjY
	2MQ8gVFhFpJ3ZiF5ZxbC6gWMzKsYJVMLinPTU4tNCwzzUsvh0Zycn7uJEZzGtTx3MN598EHv
	ECMTB+MhRgkOZiUR3lPOxulCvCmJlVWpRfnxRaU5qcWHGE2B4T2RWUo0OR+YSfJK4g1NLA1M
	zMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamASnDHH//p7gdKyN/o3DzhWB9vv
	t05mefLVzfli34s/69o50yT+hbtqi/asr9UyvjdHl/PrAcXtK5vqNzFOM7Jp8dmpFqJ3L+RS
	jz8jh5fQ97tVfUoLTa2VvizM1Nw2+/+mea69cc/tVh+wntx/dQPDhXPXVaSmaUwWTFNrlE0P
	K3rq0XI7a+mC98nG/PvLH81qcBW8y9HEtqL22oIv7ptyMvKqTdyNXR4+WzVdnpnl7Ql2Jqtj
	DjbOi5aecznOtXv7H7mzc58Yzpd+9+xIkCLv3wsu2X35OvJPP6fwf+dz0svqif0rPu+U/bV7
	iwuXzI8r/RDHvN/McG1yR/Ol9i1Mc3U09zC6ND8peugQ+0qJpTgj0VCLuag4EQC2nHoPbAQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXvfUNdN0g3P3ZSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxtrTaxgLrrBWrL/VwtjA
	eI2li5GTQ0LARGLb7NXsXYxcHEICuxklHsx+ygSRkJA49XIZI4QtLLHy33N2EFtI4COjRMdL
	XRCbTUBd4sjzVrAaEYETjBLzJ7qBDGIGqZnwZTbYBmEBN4nvfbOYQWwWAVWJZ0fnsILYvAKW
	Eou6T7NCLJCXmHnpO9gCTgEriRUNW4HqOYCWWUp8Xy8CUS4ocXLmE7CRzEDlzVtnM09gFJiF
	JDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgKNPS2sG4Z9UHvUOMTByM
	hxglOJiVRHhPORunC/GmJFZWpRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbL
	xMEp1cDE1Z2RucxjOvt8eemNnyYvvXzpko19wtrGLxcSXF84Cv87UxwxW1bqyIbft58Jxe1f
	sONtk7vFzZDqequYm34pwoa8cs2zVV/lXZnUHLd546+rn/RMZRjjZkbd01oaeOdUS1Nv4cHZ
	pa9sWY9Hbv2SuGuK7aSYbMOUFrZdCneS30/bPGNS7LHiaQuO7zKLXlRpsyavIMqmjE3yoSrj
	NIdZeaav+g7OMrYKFzus8vDmWrYrft77n+kXXj0n4xPxMf5BEEOfdRq3XfLxkMsRFRmpSyz+
	lJQ5b+yb+7pybv30Zt9jvPxflx/mVzdepm+4QPzppYt3tYULquQfSl9nKVeZEBOzSrNmimKV
	e9zGtS+VWIozEg21mIuKEwGqv5BkIQMAAA==
X-CMS-MailID: 20241114105402epcas5p41b1f6054a557f1bda2cfddfdfb9a9477
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105402epcas5p41b1f6054a557f1bda2cfddfdfb9a9477
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105402epcas5p41b1f6054a557f1bda2cfddfdfb9a9477@epcas5p4.samsung.com>

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


