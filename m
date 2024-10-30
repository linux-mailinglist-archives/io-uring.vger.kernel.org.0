Return-Path: <io-uring+bounces-4231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 101B09B6BC1
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 947291F22407
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BA71CF5E3;
	Wed, 30 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KXRiKmVu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEC91CDA24
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311817; cv=none; b=Hz4P5aUeComIcuFuQQ2atTjKPZtqVHBKm3Z6e/lYJoUgWidj2z0Das6Vc6YvJiP2itKa01Mct93yL6ozpP2I+Mt+5OaglEKnQxCWc0E01P/R5x/VFss/z1KOLjk4Zdz/gx/rmmxEMak20zWpKy3UW9wlHnhfQ+IiIxFW5J9EBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311817; c=relaxed/simple;
	bh=+Hl8/FkKAij0Fs7hEyhj8RCHLWnzeYSlHRk6+aYEOkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sUV2Yxrtf2qXtW4VXosAumpCiCH9nqg2veeCZ9Q5EjqhC5KSFX7lDKEaG/KglgZL5yZ4zwTIJONiCI3VHl3U9ThObjQStEqhFHMau7F5kAMz4jufI5Q1q6cpw/Lq9n3zKYGNcQAUcxVpr0y0GNY7s4xZyC5/+JWQlX489v0KB/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KXRiKmVu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030181013epoutp04ec87ac5de049d9fd43cf9a9c450d3260~DTW0y7KYG0312803128epoutp04U
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030181013epoutp04ec87ac5de049d9fd43cf9a9c450d3260~DTW0y7KYG0312803128epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311813;
	bh=+pFos/OWvKOhSOsUibfKD4fjufgTGmZIusPrIWBykfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXRiKmVuVtFbRGRbgRfhuXwvPhl1lQOb+DcOSZnUHlERlXLhaKM6931rb0lDM07c5
	 1FPAcEq/MhPphvP1/i6qjQPwRHwbnOx8eWe0uTYvN0BbODhGuUNP4VfrQikxGOtGVF
	 iWgQ631duDoGmktFmh2pjEOPxvWWi4hLKUiIyI6k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241030181012epcas5p2c9f727ddd4cd0152825e35069b4bc259~DTW0GPB2m1352913529epcas5p28;
	Wed, 30 Oct 2024 18:10:12 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XdwC73HMxz4x9Pq; Wed, 30 Oct
	2024 18:10:11 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	56.2C.18935.38672276; Thu, 31 Oct 2024 03:10:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181010epcas5p2c399ecea97ed6d0e5fb228b5d15c2089~DTWyrqkP32064920649epcas5p29;
	Wed, 30 Oct 2024 18:10:10 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030181010epsmtrp144594a938e5a3b5dc907e3cd9e711d0b~DTWyq15Oh0197101971epsmtrp1Y;
	Wed, 30 Oct 2024 18:10:10 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-ad-6722768310b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	81.C6.08227.28672276; Thu, 31 Oct 2024 03:10:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181008epsmtip2041cf624a73380ec5b48a3723e1f1247~DTWwXwSCT0430604306epsmtip26;
	Wed, 30 Oct 2024 18:10:08 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v6 05/10] fs: introduce IOCB_HAS_METADATA for metadata
Date: Wed, 30 Oct 2024 23:31:07 +0530
Message-Id: <20241030180112.4635-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmpm5zmVK6wZsTQhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsal123sBf9ZKz7M7GFpYPzF0sXIySEhYCIxuXEF
	UxcjF4eQwB5Gic67l1khnE+MEr2z70BlvjFKPO96yN7FyAHWcvBwOER8L6PEsxlvGSGcz4wS
	b4/0M4MUsQloSlyYXAqyQkRgKaPEyuvRIDXMAg1MEr13e5lBEsICbhLfurvZQGwWAVWJjn+/
	GUF6eQXMJZYulYI4T15i5qXv7CA2p4CFxIcdN8HO5hUQlDg58wmYzQxU07x1NjPIfAmBGxwS
	57samCCaXSR2behnhrCFJV4d38IOYUtJvOxvg7KzJR48egANixqJHZv7WCFse4mGPzdYQe5h
	Bvpl/S59iF18Er2/nzBBwoFXoqNNCKJaUeLepKdQneISD2csgbI9JO7d2sEOCZ5uYFidns80
	gVF+FpIXZiF5YRbCtgWMzKsYpVILinPTU5NNCwx181LL4RGbnJ+7iRGcqrUCdjCu3vBX7xAj
	EwfjIUYJDmYlEV7LIMV0Id6UxMqq1KL8+KLSnNTiQ4ymwDCeyCwlmpwPzBZ5JfGGJpYGJmZm
	ZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwlTq530vSTvSfG5ZodVwu+/6qrBun
	hHPTDG4d4LRcvzzkx/UfHH2KNgEPkjozFqYpPzloeunjSSfDP6cU023S7vyPyfGWuv7n2ZN0
	p4Xxfw5y9jM/e2fydzqnopurJluboUtXdSaTSvY1oTK2P4rNmdN/b+l0txCcvm9L3fvYb+6s
	PtsYarm6PJOtn0w78Fqac2qPfH/u43mivyoL5vfVGzmfXeXrGxjx9ZujBc+fk39OPXf677vl
	WfQTOU5Z/+rF2zidpk8RD/q8auNxzWOzIlY7HnTU+Lt3yoQbHjs8Zi234bD6/DW6+lXePuZ9
	JiqWXuwb8t6kxh7xkrad7HzL7EfcCT/fsEVT/53hCF6hxFKckWioxVxUnAgAkduB/F4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXrepTCndYPJRY4uPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CVcel1G3vBf9aKDzN7WBoY
	f7F0MXJwSAiYSBw8HN7FyMUhJLCbUWLKon6mLkZOoLi4RPO1H+wQtrDEyn/P2SGKPjJKnPvz
	iBWkmU1AU+LC5FKQuIjAekaJs3snsIA0MAt0MUlc3sANYgsLuEl86+5mA7FZBFQlOv79ZgTp
	5RUwl1i6VApivrzEzEvfwXZxClhIfNhxE2yMEFDJ9YVnwOK8AoISJ2c+gRovL9G8dTbzBEaB
	WUhSs5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4xLa0djHtWfdA7xMjE
	wXiIUYKDWUmE1zJIMV2INyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJJanZqakFqUUw
	WSYOTqkGpkBr576Kxlg316JFMtO+aBziWLFVPUJYatnZs3Ni7732W7VO1kn3d8ZeibKyJPsJ
	s3dOfGL396XfoxZvpqDJb4P7L97d8TU94N626b4mHUyXjkacOXogZ+4T1/Ye03q5aMcXOhEX
	H+3znHrqbHPQa+kfz+pXBPheubv6+YlHaSofPr+axHmxcH3p6Xj366c+pUWdqWwpq0hY8EfV
	iffCSwbLrVqfnop0/vTTzJwubMLtP3un4T+J5Z9nbfJJnXph+rIdYcZTeN4GaaqrdJV9Dw+t
	ejzF6sNRNRlPU3OWP+E/M8uUbXV63n4qtMne9ojxZKN6y297j/NqLvJ7t1Ut8/mwfe/Bk8lL
	uVfbfH47r0CJpTgj0VCLuag4EQBLblizIAMAAA==
X-CMS-MailID: 20241030181010epcas5p2c399ecea97ed6d0e5fb228b5d15c2089
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181010epcas5p2c399ecea97ed6d0e5fb228b5d15c2089
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181010epcas5p2c399ecea97ed6d0e5fb228b5d15c2089@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

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


