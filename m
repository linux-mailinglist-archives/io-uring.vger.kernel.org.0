Return-Path: <io-uring+bounces-5115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7599F9DB6BD
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 12:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0081B20F9C
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 11:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6354F19C558;
	Thu, 28 Nov 2024 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r2RGuylJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960719ADA4
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732794359; cv=none; b=o+2RnYMjiMZYSX3nXPtf91k9JZEISTsYJxlannp8AfvvqZFoxn2t+m1VDJDDjbEVk2f9twoPUraiDqrDLGbGO8q4yfCOg0qHm1AFhsQlfPTh+yC6d7y8QECvJOFJgHbgQpNXAxcO5VH6XOXWVPhjYsnePh/egr6/bgV14TYnEow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732794359; c=relaxed/simple;
	bh=g2fp64Elfp9R80cl3zu6i89Ehrxw1OCNHe/eXuK93qM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XUa20qcIeyTgZN2fcd2chzNtpyObkimgOdIIjs25sst7VNS2GYKVBJvn4SGbX+KgpQqq9Am94wC1/zFGbSCjzjF5PJyiTYe9YE0U9rQrBZBXtrj7iBuGg0BLMCaxAJieAnZQBZd7SPZX7kxXMA9jApC3DDcexs9R0ZlksRpKnm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r2RGuylJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241128114555epoutp04342f55a492a2c7317374c1c221c1402c~MH0kHNcW51096710967epoutp046
	for <io-uring@vger.kernel.org>; Thu, 28 Nov 2024 11:45:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241128114555epoutp04342f55a492a2c7317374c1c221c1402c~MH0kHNcW51096710967epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732794355;
	bh=FQM1oME+yjLcszh/NNdlGeevLgEVh+e4WfItNIpaOVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2RGuylJhHYpxtovtgeiOV8PXusomywuf6dxPTVuD7qsu6x25+7l7nupUO0uQQ9pS
	 OHWViXD4dn1uwF+hGKT964g+3kF8H2ksy5TYSS56ykSi0C8e+yC4l4xHaoBiZVsoYf
	 8I0Is1T8TEBRReviGiuH7+NbR6lBo6nN4uTI3C+c=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241128114554epcas5p2c9df787ad8145e598d3817c5db00bcca~MH0jhfO8m1857618576epcas5p28;
	Thu, 28 Nov 2024 11:45:54 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XzZJH2fn4z4x9Pr; Thu, 28 Nov
	2024 11:45:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E6.B3.19710.FE758476; Thu, 28 Nov 2024 20:45:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241128113058epcas5p1f544aa328a27b59f96b48b94dc0bdf94~MHnhJguS-1316913169epcas5p1r;
	Thu, 28 Nov 2024 11:30:58 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241128113058epsmtrp2b79823e07685711bd53938c807451bc2~MHnhIiCRN3231632316epsmtrp2k;
	Thu, 28 Nov 2024 11:30:58 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-81-674857efef9e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	32.58.33707.27458476; Thu, 28 Nov 2024 20:30:58 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241128113056epsmtip211016eab1dc2a7836a08fd9d6c853c49~MHne1hoN12660826608epsmtip2H;
	Thu, 28 Nov 2024 11:30:56 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v11 02/10] block: copy back bounce buffer to user-space
 correctly in case of split
Date: Thu, 28 Nov 2024 16:52:32 +0530
Message-Id: <20241128112240.8867-3-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241128112240.8867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmuu77cI90g4mX+S0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QO0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
	ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzPs5uYClbzVaxqmMbWwDiJp4uRk0NCwETi0LJ9
	TF2MXBxCArsZJe70nGeFcD4xShy5fpgFzunpOcII03LqxUtmiMRORomXB3awQzifGSXuT/vN
	BlLFJqAuceR5KyNIQkRgD6NE78LTYLOYBV4ySixdtYgFpEpYIEXi/J+P7CA2i4CqxI0Ph8G6
	eQUsJFa8PcEKsU9eYual72A1nAKWErOvfWOFqBGUODnzCdgcZqCa5q2zwW6SEDjDIfF8dSvU
	sS4Sb479YIKwhSVeHd/CDmFLSXx+t5cNwk6X+HH5KVRNgUTzsX1QvfYSraf6gYZyAC3QlFi/
	Sx8iLCsx9dQ6Joi9fBK9v59AtfJK7JgHYytJtK+cA2VLSOw91wBle0g8vLeKDRJcPcAQ7rjM
	NIFRYRaSf2Yh+WcWwuoFjMyrGCVTC4pz01OTTQsM81LL4RGdnJ+7iRGcyrVcdjDemP9P7xAj
	EwfjIUYJDmYlEd4Cbvd0Id6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPzCZ5JfGGJpYGJmZm
	ZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwbX0QfKD8el6QlKe/oEgPD/ukzbuP
	KniXbuVX1jnXaxaisKReU/dVYdWvCaZzla9s5YgV0HllyWC2dV/u7X7F0NeN9zqT/rD8mPw4
	c1/Hm6fZO5Rnt8/0O1WusPQCC89i87dVM6zMxKUEZ3685Xvx4unMpT8md35/xDIjPfRP/oQL
	c9Ntz3yQ3OiofMXIOP3W6wO/tp8sPzjBtG7q5MjFiq9293T6rOnMLRDsWXrog9bmsl2tU+KY
	DZqt9+dsia84sbfa5/mEG3aPq/YHR6m8kco4V86/uvbRp5sS/8utuoMjOmce3WFtd81/5pOD
	Vvk7N+2/ox5gw1lqeKX34vTVU//t0FeZKm3yfJ7CNPl/R5RYijMSDbWYi4oTAeQLVXFuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJXrcoxCPdYMpKOYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV8Xl2E1PBar6KVQ3T2BoY
	J/F0MXJySAiYSJx68ZK5i5GLQ0hgO6PE3ye/2SESEhKnXi5jhLCFJVb+e84OUfSRUeLfzg6w
	IjYBdYkjz1vBikQETjBKzJ/oBlLEDFI04ctsFpCEsECSxMM7LWANLAKqEjc+HGYDsXkFLCRW
	vD3BCrFBXmLmpe9gNZwClhKzr30DiwsB1Vx+fJ0Vol5Q4uTMJ2AzmYHqm7fOZp7AKDALSWoW
	ktQCRqZVjKKpBcW56bnJBYZ6xYm5xaV56XrJ+bmbGMERphW0g3HZ+r96hxiZOBgPMUpwMCuJ
	8BZwu6cL8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwREkhPLEnNTk0tSC2CyTJxcEo1MNno
	pP9VfOB4/6PV8fkHMidMq/31/YhhS8TkefkXdXw77f5L+Lq4zBSZ+tfrDUOziqPV6ivvueXX
	VuxnDbE8t7pr2d0/fNaXPfQjUy4vKO8VZ5R8+28+w/LQqbEa29bPcg97f7x+wZ5JLypdn701
	1dXY8XiughXPK6fu9Nd3Cti/Xr8cnH176ez1h65rvH+imfFRo5TVVPbs5ML0zeJ+CxSNln/s
	OznzaLesdOPm+JrreessCuc5HNkmdJDxIH/Liqf5SWd+vShvCVp+LsDkSu8B/jTPeRt1TatF
	5zQJHAi133D8Zoe05LslTUaHRMTOr3okrexjNv2yReZhH7NDAms7Q0onyXLu/1IpOv2ac4oS
	S3FGoqEWc1FxIgB2wfXMHwMAAA==
X-CMS-MailID: 20241128113058epcas5p1f544aa328a27b59f96b48b94dc0bdf94
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113058epcas5p1f544aa328a27b59f96b48b94dc0bdf94
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113058epcas5p1f544aa328a27b59f96b48b94dc0bdf94@epcas5p1.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Copy back the bounce buffer to user-space in entirety when the parent
bio completes. The existing code uses bip_iter.bi_size for sizing the
copy, which can be modified. So move away from that and fetch it from
the vector passed to the block layer. While at it, switch to using
better variable names.

Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a448a25d13de..4341b0d4efa1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -118,17 +118,18 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
 
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 {
-	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
-	struct bio_vec *copy = &bip->bip_vec[1];
-	size_t bytes = bip->bip_iter.bi_size;
-	struct iov_iter iter;
+	unsigned short orig_nr_vecs = bip->bip_max_vcnt - 1;
+	struct bio_vec *orig_bvecs = &bip->bip_vec[1];
+	struct bio_vec *bounce_bvec = &bip->bip_vec[0];
+	size_t bytes = bounce_bvec->bv_len;
+	struct iov_iter orig_iter;
 	int ret;
 
-	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	iov_iter_bvec(&orig_iter, ITER_DEST, orig_bvecs, orig_nr_vecs, bytes);
+	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
 }
 
 /**
-- 
2.25.1


