Return-Path: <io-uring+bounces-3732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8879A0A04
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:37:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EEDA1F255A4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1327D208D80;
	Wed, 16 Oct 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e2+/jeDu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6D20896A
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082242; cv=none; b=PizHMBWFuBuU/HEtyASWdyptXX6GiJ3xJMsSmxNzG7xv/C0Vnp1OtM6Sx53yBSi6MsbcefmhVOpmB9LvHgYmXRbs3ZnA9KxfD6+PBD+7bqBDkHnDiQsLt0rdIFg8/VR5JCcHvdULYhfGTKiAxihdtX3gwzgJZc8L4RVRACUbn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082242; c=relaxed/simple;
	bh=55i5BYT08PR+ogRCKeefqI6P0kYHacdRz9t+UtJq0mI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ZeWyTAHwa9uVUvYUCOBFL5m4sj0KQ7OxxVx+AkChUC6rAm65/Z5vHNDgMRLMQ0Ys3ExtO4cE4EbYI3W4zZVpIJZXOoql9KBUixl75FR8HuErCMjV+Bt+aq2xcT6d/TUetaxbm9DT/IyxE4mkINstsDfqAHnJAVrtcEAxvOPBNc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e2+/jeDu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241016123718epoutp03e220ea115cfa3d1bc180b0c1f4cc35bd~_7yKOK6Ty1120811208epoutp03G
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241016123718epoutp03e220ea115cfa3d1bc180b0c1f4cc35bd~_7yKOK6Ty1120811208epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082238;
	bh=rp2FS8zl3jE/nKjhp03u/2IrOy2rAmcpwepbQ5vVxF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2+/jeDuW3uMxGPnYeS14wahU1Ema4xiRm4PR1fUQZGxVJJcWS2dVmVEXkq5AOU4a
	 Kq3FEjM7TLbAVkHaeqhnTzszcc0ril6qPPEjA8Bhq+ZxwQ6GjlpGoYI24DEu6j010b
	 Fd0q7v8LPqa7wjog1gZMA3/feEqn9iNRvqoS3l/o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241016123718epcas5p1f952275928210c06b8799453c1168094~_7yJrnWtE2746927469epcas5p1N;
	Wed, 16 Oct 2024 12:37:18 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XT9TS2jw0z4x9Pq; Wed, 16 Oct
	2024 12:37:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	26.63.18935.C73BF076; Wed, 16 Oct 2024 21:37:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241016113755epcas5p2d563b183a9f4e19f5c02d73255282342~_6_TVmfn53038230382epcas5p2R;
	Wed, 16 Oct 2024 11:37:55 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241016113755epsmtrp15b225a1884e9c64c9f4e76452b15d6d7~_6_TUzQX60254402544epsmtrp1x;
	Wed, 16 Oct 2024 11:37:55 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-82-670fb37c9fa0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.78.08227.295AF076; Wed, 16 Oct 2024 20:37:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113752epsmtip19c5aa77a3fa0dd1f65f9f54ac12acc52~_6_RRY3Th2875928759epsmtip1K;
	Wed, 16 Oct 2024 11:37:52 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v4 10/11] nvme: add support for passing on the application
 tag
Date: Wed, 16 Oct 2024 16:59:11 +0530
Message-Id: <20241016112912.63542-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJsWRmVeSWpSXmKPExsWy7bCmhm7NZv50gyedwhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYHP3/ls1i0qFrjBbbzyxltth7S9ti/rKn7Bbd
	13ewWSw//o/J4vysOewO/B47Z91l97h8ttRj06pONo/NS+o9dt9sYPP4+PQWi0ffllWMHptP
	V3t83iQXwBmVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdL6SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQ
	wMDIFKgwITvj1YrTTAU3uSr2XdvA3MD4haOLkZNDQsBEYt3l90wgtpDAHkaJ4/+SIOxPjBKz
	p1p1MXIB2d8YJTYencQK09CweAcjRNFeRonGJ/YQRZ8ZJc4eOweWYBNQlzjyvBXMFhGYxCjx
	/HIoSBGzwHtGiWXPZoElhAUCJHY9/AA2lUVAVeLW/1vsIDavgJXEr33/mCG2yUvMvPQdLM4J
	FD917iBUjaDEyZlPWEBsZqCa5q2zmUEWSAjs4JDYfmUBG0Szi8TB3degbGGJV8e3sEPYUhIv
	+9ug7HSJH5efMkHYBRLNx/YxQtj2Eq2n+oGGcgAt0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXy
	SuyYB2MrSbSvnANlS0jsPdcAZXtIdK7eyQwJrV5Gid3zJjJNYFSYheSfWUj+mYWwegEj8ypG
	qdSC4tz01GTTAkPdvNRyeCwn5+duYgQnaa2AHYyrN/zVO8TIxMF4iFGCg1lJhHdSF2+6EG9K
	YmVValF+fFFpTmrxIUZTYIhPZJYSTc4H5om8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNL
	UrNTUwtSi2D6mDg4pRqYZgY4vmCWjKtctE75zhlvu0ffb994HvT05xI///o30v0sK73q7i9Q
	by3r7TULeaX8bvKpA+7xLHuNFdkYqv7J+q7znX/697PVwfYqBkZPb1jzFQpElz/0jj4h6bGg
	nKVTeMoivn/brx/hXfZK43HX73O7gvfEHnE/83W+kH+x+AvhSTwqYrPqVt1+8axgzQPetd9i
	S1xdQkt5krUZJrb6xIht4o6d8dI/oGNvDuNRBlbxF2d9MwoaXwr6fBNZtaXI/8k7ro/b79pH
	JD8o3S6RZt+rcLxX0umJyTIzhcDZE538iyJm9s530N3Zc8NLaqaZXeXPmdL/xV7VH9ygsjEs
	xGPnRk6v5BXd3416l3YpsRRnJBpqMRcVJwIARXlNilsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42LZdlhJTnfSUv50g6NfzSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDOKyyYlNSezLLVI3y6BK+PVitNMBTe5KvZd28DcwPiFo4uRk0NCwESiYfEOxi5G
	Lg4hgd2MErMub2KESEhInHq5DMoWllj57zk7RNFHRol5M96CJdgE1CWOPG8F6xYRmMUocXjW
	fCaQBLPAd0aJf93OILawgJ/E8TNbweIsAqoSt/7fYgexeQWsJH7t+8cMsUFeYual72BxTqD4
	qXMHwWwhAUuJf5M/MELUC0qcnPmEBWK+vETz1tnMExiBtiKkZiFJLWBkWsUomVpQnJueW2xY
	YJSXWq5XnJhbXJqXrpecn7uJERxJWlo7GPes+qB3iJGJg/EQowQHs5II76Qu3nQh3pTEyqrU
	ovz4otKc1OJDjNIcLErivN9e96YICaQnlqRmp6YWpBbBZJk4OKUamJRKA82Kn6vOe91bcv1u
	TuuK93enRpVvYc9/vWyvdoyfRZ1l0Nn/p67Y6DzvCnPOXZKroXjp8FvBBVdvf5iUWGzR1pPH
	/GHvi+rX6Vr3ThT8YNdUyuljfu++T0+i6J7EsmWpzf+1l3IYKfHwz97HJZd/19ti/ZdV90yy
	y687RK4qTVS4LpLnwfHQbOlarxVTTrtcTpdpqbHpL5v4yP47kyhDeaFtuI/8zUtxbsaPp52K
	naD8t8qhTJqDJ+sD39TTi2ZM9oq+p33jvglDa6clr4O16JcPFfH8SW7Pc51/ZtmaPOFKenl0
	5RPWv0fX7uF8bOkoeja1J3mml8h318LwqBm6p7+H7fr+MHz2zCVLlViKMxINtZiLihMBKwjv
	MhMDAAA=
X-CMS-MailID: 20241016113755epcas5p2d563b183a9f4e19f5c02d73255282342
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113755epcas5p2d563b183a9f4e19f5c02d73255282342
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113755epcas5p2d563b183a9f4e19f5c02d73255282342@epcas5p2.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

With user integrity buffer, there is a way to specify the app_tag.
Set the corresponding protocol specific flags and send the app_tag down.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 211f44cc02a3..c7ba264504b5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -872,6 +872,12 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
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
@@ -1012,6 +1018,10 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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


