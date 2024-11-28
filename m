Return-Path: <io-uring+bounces-5121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 822699DB6DC
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1219D165433
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C04619D072;
	Thu, 28 Nov 2024 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KuFCgKXz"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E919E99A
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794385; cv=none; b=rU/zTJYY9M2Cz2wX1R6Ky/A2DUtHxcayqXNY6tE2fneiYZ8NxVODtqKSlHBf5SJa1eu11UQT5FhKfm0CldEfMzWWf5C32huziBQ27U+xk/s3IGImIA92m4vPXClAxUAg84FA23HQJbuchNE/7bf/KQ/BcKvcgOsGr9NvqwX5n3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794385; c=relaxed/simple;
	bh=R0ISA8yY2JMwXPEw3NvAC6mLoQ+w67YWfMlsx0QA4Ss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=e8NbQ20cWvUea2ddjpCRZpPasceAesOxv6fZ9nUh+S4SiYKEmRG0X2IhyicRBduRyCpGa/5taKGBAt0MWQkw25hYxQOGAGi5iyMNPij8OVoyUkIS4yhQ0T4+rPwEpMwcgm5hkfTKScBLLaAbJQnA1ouww4ehUNU268UN/wD7BGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KuFCgKXz; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241128114622epoutp026a0f96cbfb68f44993c2ba487fc84f0e~MH09tHHI31313913139epoutp02D
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:46:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241128114622epoutp026a0f96cbfb68f44993c2ba487fc84f0e~MH09tHHI31313913139epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794382;
	bh=fOhAPjepG8IxDxWR0+S1vjp4KvMbiHG0tXmeE420F+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuFCgKXzp1SsDif2l+hjopVG6RLMKOUAVxFGf7S7lm8uOZtoK3GEV9cEqak5aJ2tR
	 /GAb2hnLhD7czwYPtiU2T6bqP1dUVTXQtnC9pQObzCqxud+G637+SN1iO7IZcC0D/j
	 Vh6yHqXbqwjLQZCreqfTmFUA2jRqIWCeLNKDPcVg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241128114622epcas5p27eed31a1a09e6201c42b3f54b0b14231~MH09VMcTr1842118421epcas5p28;
	Thu, 28 Nov 2024 11:46:22 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XzZJr50Mjz4x9Pv; Thu, 28 Nov
	2024 11:46:20 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B1.C3.19710.C0858476; Thu, 28 Nov 2024 20:46:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113114epcas5p29c7e2a71a136cb50c636a9fe5d87bb0b~MHnwUalBa1770017700epcas5p2Y;
	Thu, 28 Nov 2024 11:31:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241128113114epsmtrp22a238ddd34832bc52d6039fb95e1e7e7~MHnwTesv90090800908epsmtrp2q;
	Thu, 28 Nov 2024 11:31:14 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-c0-6748580c7014
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C8.5E.18949.28458476; Thu, 28 Nov 2024 20:31:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113112epsmtip2d2c774c38c40fa32e0b86c84bfc4bcd7~MHntznqrO2086720867epsmtip2h;
	Thu, 28 Nov 2024 11:31:12 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 08/10] nvme: add support for passing on the application
 tag
Date: Thu, 28 Nov 2024 16:52:38 +0530
Message-Id: <20241128112240.8867-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxbVRzdfa+0D7DsrTC5orLmJZsBB7RCy0UHnY6wpxhlbMlQiayhz0Io
	bdPXbtOoa4Z1H44NFgmugICZGyuOGWB8uJUiX834WgKMAZE5DOgmsq3gBlKHtn2g++/87j3n
	d+753XsJXDTJDyNytUbGoFVqKH4Ar6kzIiLqqQxaLWme24JcD908dLjoMY7KbU0A1U6e4qPZ
	znmAxttbMXShthtD9yyDPFRWWoCh7n/m+Oh0xyhA9okX0VX7NR6qPDcjQF/cbOGj884VDF1/
	7PRD163lgu0iutU6KaCHB0x0ve0Yn244e4i+Mm7m066ZCR59stEG6P6qLgG9UB9O10/PYWkB
	7+Zty2GUKsYgZrTZOlWuVp1Ipe7O2pElk0ukUdIEFE+Jtcp8JpFKfjMtKiVX48lEifcrNSbP
	UpqSZamYpG0GncnIiHN0rDGRYvQqjT5OH80q81mTVh2tZYwvSyWSl2Qe4r68nOLaKYG+MfDg
	wEwDZgbd/seBPwHJODhYfRI7DgIIEXkFwLOl1TyumAfwztQI4IpHAH7f4xSsSe4MPfBhEWkH
	sG02liMtADgxeovn3eCTL8Cu3yw+dQh5FcDC6j5fX5wswmBVaSPuZQWTu2Dfw3Gfgkduhq7P
	yzxtCUJIIlhReJBz2wTPDC363PzJBFg2+sjPi4XkBnjtzLRPins4BZfLcG9/SN4mYH/rRT4n
	TobmuV/9OBwMf3c2rkYIgwv37KscNVwansE4rIcFPW2Awwpo6T2Fe8+DkxHw0g8x3PLzsKS3
	DuN8g2Che3pVKoQtX69hCh65UL6KIbQPmjFvG0jS8PJXe7hhnQBw2VHvVwTE1ifiWJ+IY/3f
	uQrgNvAMo2fz1Uy2TC/VMgf+u+VsXX498L3zyOQWMFa5Et0BMAJ0AEjgVIhQH7hTLRKqlB9+
	xBh0WQaThmE7gMwz7mI8bGO2zvNRtMYsaVyCJE4ul8clxMqlVKhw1lKhEpFqpZHJYxg9Y1jT
	YYR/mBk7mhoe3v8njKA+bXC6028nbVVbFkfQsGtT/FTPN/s/s2XaBbKfjUfdmNZNxEahnPRl
	Z7wlWPNszYGgxPeklpAx9XLtscNYpK0dzvCtosypGlbduyxT3DqxPmuf+JAiNyNFfvO7H81v
	/SV2YH1jmydd5vm768ozHXtLuwq3tzWz80HrqicGHC0lZeNPR/40NLE40P76c3878NnXLul/
	eSDN2DUmrnu1WpEypahR7yyoe7+ffucD4dvFzTc+6by7vLf7xrea+yN7Pj7/xvpG132wZeOS
	5I8j/Uunm5LYdN4ru0PbKioxh8o23ZucunJu1hSlSOuI+bJhwJ19sWRDaERgxlaKx+YopZG4
	gVX+C4uLufVwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG5TiEe6wd2dehYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUVw2Kak5mWWpRfp2CVwZE1c/ZC/Ywl1x
	9ulmpgbGo5xdjJwcEgImEi8ufWDvYuTiEBLYzSgxccEHNoiEhMSpl8sYIWxhiZX/nrOD2EIC
	Hxklvtw2BrHZBNQljjxvBasRETjBKDF/ohvIIGaBGUwSv/8sYAFJCAv4S9w71QY2lEVAVeJj
	22ygQRwcvAIWEnN7KyDmy0vMvPQdbD6ngKXE7GvfWCF2WUhcfnwdzOYVEJQ4OfMJ2EhmoPrm
	rbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnC8aWntYNyz
	6oPeIUYmDsZDjBIczEoivAXc7ulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0REkhPLEnN
	Tk0tSC2CyTJxcEo1MLGG1FSbX9HSmR2Vme597JSjrphO9KUre5PdJf6l3t+TtqItfa/q6zlp
	7EsnMCtP3XJq9fK3hmeyrz98da1pr9bW581yNy+/Uqu1T+24veLYtS2K7K7m888yzaxXTmmc
	LqZq8ao+dffq/JNz3E/d27tJVFLl9f1n01+6ycUeiditfm3RKZFnfBHp8xP/mq1Ues8kJTRJ
	nPXMxsNyt7pTJQ3OHg9LKZlz4UVa7M2DXrcVT+9t6jERZU05NK3816/cRNlPAqtaHs1rOikx
	2zytTMFLvJTT+aPY3t2VTKd/vJh8nCX8g17qpckbZ3nuXdlTHXXYoL7QqCEttDqJ/1zWA091
	jnOfNrw28J/X/K2w4ZkSS3FGoqEWc1FxIgBZyNukJgMAAA==
X-CMS-MailID: 20241128113114epcas5p29c7e2a71a136cb50c636a9fe5d87bb0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113114epcas5p29c7e2a71a136cb50c636a9fe5d87bb0b
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113114epcas5p29c7e2a71a136cb50c636a9fe5d87bb0b@epcas5p2.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

With user integrity buffer, there is a way to specify the app_tag.
Set the corresponding protocol specific flags and send the app_tag down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e4e3653c27fb..571d4106d256 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -885,6 +885,12 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	return BLK_STS_OK;
 }
 
+static void nvme_set_app_tag(struct request *req, struct nvme_command *cmnd)
+{
+	cmnd->rw.lbat = cpu_to_le16(bio_integrity(req->bio)->app_tag);
+	cmnd->rw.lbatm = cpu_to_le16(0xffff);
+}
+
 static void nvme_set_ref_tag(struct nvme_ns *ns, struct nvme_command *cmnd,
 			      struct request *req)
 {
@@ -1025,6 +1031,10 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
 		}
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_APPTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_APP;
+			nvme_set_app_tag(req, cmnd);
+		}
 	}
 
 	cmnd->rw.control = cpu_to_le16(control);
-- 
2.25.1


