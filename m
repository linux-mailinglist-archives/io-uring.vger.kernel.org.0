Return-Path: <io-uring+bounces-5118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 373D69DB6C9
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86BD4B2264A
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3FF199385;
	Thu, 28 Nov 2024 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JzLRZu9i"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7A919C574
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794372; cv=none; b=vDAROFDWjDOrozI36QKzjOiURvAPxdvNdggf8Le8B2iiKEnzIUrxNEJbYwy9s+zqxmg4YnU9KMe90pHC/93yplpApgSrU7VBAU9ep1OVAFRkUKp8BqPVxxqdHEPxNwk22cDVyVXAzyTik5n4Q4f9bWZXR3u0/50SikRu8letTr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794372; c=relaxed/simple;
	bh=mlLpOADJdimbzMrJqxVCIky165ZgGg3a+54zC1LiT88=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rczqMS962yuzz4syty0O/T50rRPHy+RIynt2h/RqNuq1hQK+LnQDFtDXvR5nts3/TMjsf76QBgL59Wouso2u/906KiiGzWY4jAHhWTqZ7/Y+D8WV9azhaG8QMrOISvhrzH/F9xiaUUd4GF9faGBk9SgIiVDORKVRjz4ioNEPtIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JzLRZu9i; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241128114609epoutp0318348ed2702fb33f97875e374881c5b6~MH0xEzmtV3197531975epoutp03L
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241128114609epoutp0318348ed2702fb33f97875e374881c5b6~MH0xEzmtV3197531975epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794369;
	bh=cRuOygxyfLjl7ybgQ+EVk9IvCIBAqSeYwRZ/zr1tr/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzLRZu9ihGM6g1beIxWgzgI5b0ZoECOIlcbkGAf4edK8wugmOSwVFL27tKcQ+oJci
	 CUj1LAkSGkpVharDM4exT0ZuOMNY1qbUypvBWCpaJN/S/9KzehiJuO8gbTiIrNyjU/
	 eq42oGTDSXLf7UR0C+JfP1slhwbmE/+i/50imHZE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241128114608epcas5p19b71a782a4aaf32b6af0939969df31a4~MH0woohAk2942729427epcas5p1x;
	Thu, 28 Nov 2024 11:46:08 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XzZJb1LSxz4x9Pr; Thu, 28 Nov
	2024 11:46:07 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.B3.19710.FF758476; Thu, 28 Nov 2024 20:46:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241128113106epcas5p1b5b06683bfa72225f3c1ab102b9f361c~MHnok8sA41555015550epcas5p1s;
	Thu, 28 Nov 2024 11:31:06 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241128113106epsmtrp2ce54218dc402e02bcb6731b7b6bf72f8~MHnokAPLv0091000910epsmtrp2a;
	Thu, 28 Nov 2024 11:31:06 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-9f-674857fee0ec
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.5E.18949.A7458476; Thu, 28 Nov 2024 20:31:06 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113104epsmtip27d46969dee4538ebbdc537c9a941345f~MHnmQAdcM2660826608epsmtip2Q;
	Thu, 28 Nov 2024 11:31:03 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 05/10] fs: introduce IOCB_HAS_METADATA for metadata
Date: Thu, 28 Nov 2024 16:52:35 +0530
Message-Id: <20241128112240.8867-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxTe7WtfH2VdHj+2XZoI9WVG+U2l1FsiY4l1PMeSQYYhWaLwhLcW
	KG1ti05jsrrKFphMQIVQioA61BK3gIggrY7CVkHFicqAhG0usIkEEn46wurW0ur877vnfOd8
	5zv3XgILHsFFRIHGyOo1jJrCBdzOvsjI2H+zaWXCchuG5pfXuOiLSjeGrLZOgFonTuBopm8B
	oLEfujnoUuuPHDRXOsRF9bVmDqp2jgDkGI9GdscAFzW2TPHR17904eiC6zkH3XO7eOiexcp/
	L4jutkzw6Qd3S+h2WxlOXzn/Od0zZsLp+alxLv1Nhw3Qd5r6+fRiezjdPjnLyRB8UrRdxTL5
	rF7MavK0+QUaZQqV/nHOjpwkWYIkViJH2yixhilmUyjFhxmx7xeoPXYo8QFGXeIJZTAGAxX/
	7na9tsTIilVagzGFYnX5ap1UF2dgig0lGmWchjUmSxIStiZ5iLlFqgXXBZ7uIe+zAdsqZgIj
	3HIQQEBSCi8u9GLlQEAEkz0A3qrt4XkTweQCgO3du32JFQBna2deVkxaevk+kgPAh6f1PrwI
	4OOGQi/Gyc2w/69S4C0OJe0AVjTf5noPGDkN4Le2s+udQsg0uHrxnKcTQXDJTXDlyQZvWEgi
	+Gefg+MTi4B1w8/WxQJIOawfWeH5OEFwoG5yvQ3m4Ziv1q9bgOTPBJw7avVPqoBXa4aBD4fA
	p64Ovg+L4OKcA/dhJfz7wZRfTAfNP93w81Nh6eAJzDsbRkbC76/H+8Ib4OnB7zg+3Tdgxdqk
	v1QIu868wBT86pLVjyF0DJn8mIbT9iv+7R4H0HwusxKILa/Ysbxix/K/chPAbCCM1RmKlWxe
	kk6iYQ++vOM8bXE7WH/gUYouMNr4PM4JOARwAkhgVKhQF5imDBbmM4cOs3ptjr5EzRqcIMmz
	7ipM9Gae1vNDNMYciVSeIJXJZFJ5okxCvS2cKW3IDyaVjJEtYlkdq39RxyECRCZOZNtOd9s8
	2ji6ebrmWcTh3iPNv06fPHLg9yZ8ZH+yKDW96rdDuc77hcqkisqPTO6u6Oxt/PGUxWx9o3ko
	Z6ay8x/X2LXcXVsrsoYUnS1Hr99WrYWtHrsco1nSgvDHiRRKHVUtZb3VUWa/WZbGCmPuxgrv
	17wTerLhy5vH1uSPnoItUc3u16JFptWZ2ERz752NMS2ZdsXUKf7r+M6D8luP+vV7w4eL/9jf
	7ApzJvP2ZAZWt1QFFio7UuOTQ1v3CXBscMveqk8vS/vS3XFik0BRnoWOx23qX5D0muzJzdWz
	Aep91xh2155VR1BIxO4noUsTN0brZB8IpuaJqB3WZesZGcU1qBhJFKY3MP8BExQUYmkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXrcqxCPd4HKntMXHr79ZLJom/GW2
	mLNqG6PF6rv9bBavD39itLh5YCeTxcrVR5ks3rWeY7GYPb2ZyWLSoWuMFntvaVvs2XuSxWL+
	sqfsFt3Xd7BZLD/+j8ni/N/jrBbnZ81hdxD02DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8en
	t1g8+rasYvQ4s+AIu8fnTXIem568ZQrgiuKySUnNySxLLdK3S+DK+HR8OWvBFdaKk6t+Mjcw
	XmPpYuTkkBAwkXgy6yB7FyMXh5DAbkaJ1t872CASEhKnXi5jhLCFJVb+ew5V9JFRYuvc16wg
	CTYBdYkjz1vBikQETjBKzJ/oBlLEDFI04ctssBXCAu4SP1csBurm4GARUJX49kIWJMwrYCHx
	7PBeJogF8hIzL31nB7E5BSwlZl/7BjZfCKjm8uPrrBD1ghInZz4BG8kMVN+8dTbzBEaBWUhS
	s5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4zLa0djHtWfdA7xMjEwXiI
	UYKDWUmEt4DbPV2INyWxsiq1KD++qDQntfgQozQHi5I477fXvSlCAumJJanZqakFqUUwWSYO
	TqkGpnj/NUfKv+w2+ZMjUKGzUiFWbOucDx5nnBh/eO09sD05XN87+c6vUMlp19zULJY9+7dw
	Dd+enyyn1gm5sF/9fDr67ea/sWyRjnL7eM00YxgkW50ET6653f4z19h2arids/SL4E13t2ww
	vzpbZ8kWn3U3tuxeKHbO7oz0lv4SpSlrftQvb90YGqx1ZI7zioM3zxbKa2ywOxA06WXvBu5N
	dc13Fi+NDj2QbOj/svFl1xfZWGl/5qO5F2LeHNlzrERZuEasa+MhmUWO56MLcqMXf0iNC63i
	DnqjqlsZdWBZ4g7PI01q1S7sqUUxPsKnM6002p4fOpWYWaS+6oBwS2/F3q1qxwIXdP35Jjt5
	9okvB5VYijMSDbWYi4oTAaMA8ZgiAwAA
X-CMS-MailID: 20241128113106epcas5p1b5b06683bfa72225f3c1ab102b9f361c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113106epcas5p1b5b06683bfa72225f3c1ab102b9f361c
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113106epcas5p1b5b06683bfa72225f3c1ab102b9f361c@epcas5p1.samsung.com>

Introduce an IOCB_HAS_METADATA flag for the kiocb struct, for handling
requests containing meta payload.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e29433c5ecc..2cc3d45da7b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -348,6 +348,7 @@ struct readahead_control;
 #define IOCB_DIO_CALLER_COMP	(1 << 22)
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 23)
+#define IOCB_HAS_METADATA	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
-- 
2.25.1


