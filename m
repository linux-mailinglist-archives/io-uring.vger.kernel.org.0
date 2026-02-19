Return-Path: <io-uring+bounces-12327-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JkZAcUDl2mjtgIAu9opvQ
	(envelope-from <io-uring+bounces-12327-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:36:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AFC15E9D5
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 330BF3005152
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 12:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646F92F39B9;
	Thu, 19 Feb 2026 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O0bWMmx9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C274927FB1E
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504574; cv=none; b=ajUmFi+3kLRqpm6YQCeukQN+vWonQCqwR0RmAzYuLvYLdfKEhYlBIy9kOcsA/SItdwuUe/dMXgHnK1NzbwmL1H3pOXaC2dAZKOD/xsl5zOYY7Tfn4eDdiWKwpYW+vR2MKa8wjOSnduItL0nxnfhaVRdO6XFmOqWparaPG+uXduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504574; c=relaxed/simple;
	bh=BY/RK1tXzEvXXCGYdwhKNtu97iVzifuQJ7T6bTG1gmk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=QhUNk39PDGEBpusEC/eIIvakFGA93PKa+OtDIa7XJVbZ9y+W5JS1olqUYeN6ZtWvw1G3kF1177eZZVRdjLne3fRIVOGZxlbZtCdJ/ofRF8yDe+YnHj6ENKcmmaHQdQHGsLPcT+FAiDUSCVlPZpIgsMV4JFyZOsn9n5cv1MgFPcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O0bWMmx9; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260219123603epoutp03509c4bfb5ac1b4d37a61312355153fac~VpgPR2LwD1992919929epoutp03z
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 12:36:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260219123603epoutp03509c4bfb5ac1b4d37a61312355153fac~VpgPR2LwD1992919929epoutp03z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771504563;
	bh=q0LmMvcEPAKNKFTmhqhPJ18Lkr2w8F5SogDpXQyf4Mk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=O0bWMmx9gaS4bzkIwjbJCHs3p4ZjIpO6vtRhzXfV8clD6ypeSRSnYuQzKgmKdQ/A/
	 oB4b0BN8ZvnFWOYhs4G5dz7uQ0+3lCsRoAOGn3WxSnjM8o6ATxjaIjRMWlcVZVYPZc
	 ++lBaQJ30LuqcqLRLfsSr+Im3Rdvp68mEziK2wO4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260219123602epcas5p48f3d917270e7fc3f40e9658dfebfbeda~VpgOinHqX1907219072epcas5p45;
	Thu, 19 Feb 2026 12:36:02 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fGtCQ23MPz6B9m4; Thu, 19 Feb
	2026 12:36:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f~VpgNU04sI0254402544epcas5p3E;
	Thu, 19 Feb 2026 12:36:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260219123600epsmtip1fa7e2c37495716700e4e6752e969d99d~VpgMgp4LB0038900389epsmtip1E;
	Thu, 19 Feb 2026 12:36:00 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org
Cc: io-uring@vger.kernel.org, joshi.k@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH] io_uring/rw: handle IORING_OP_URING_CMD128 in iopoll
 dispatch
Date: Thu, 19 Feb 2026 18:01:36 +0530
Message-Id: <20260219123136.155590-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f
References: <CGME20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f@epcas5p3.samsung.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12327-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,samsung.com:mid,samsung.com:dkim,samsung.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[samsung.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[anuj20.g@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: E3AFC15E9D5
X-Rspamd-Action: no action

io_uring_classic_poll() special-cases only IORING_OP_URING_CMD for
uring-cmd iopoll dispatch. IORING_OP_URING_CMD128 falls into the generic
rw branch, which calls file->f_op->iopoll() after casting to struct io_rw.

That is the wrong callback path for uring_cmd requests, which should go
through ->uring_cmd_iopoll(). Treat IORING_OP_URING_CMD128 the same as
IORING_OP_URING_CMD in io_uring_classic_poll().

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b3971171c342..0eede0c09eaf 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1254,7 +1254,7 @@ static int io_uring_classic_poll(struct io_kiocb *req, struct io_comp_batch *iob
 {
 	struct file *file = req->file;
 
-	if (req->opcode == IORING_OP_URING_CMD) {
+	if (req->opcode == IORING_OP_URING_CMD || req->opcode == IORING_OP_URING_CMD128) {
 		struct io_uring_cmd *ioucmd;
 
 		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.25.1


