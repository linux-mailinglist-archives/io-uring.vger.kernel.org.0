Return-Path: <io-uring+bounces-13854-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wid3L/drQ2rNYAoAu9opvQ
	(envelope-from <io-uring+bounces-13854-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:10:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD116E0FEE
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:10:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13854-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13854-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94D303011074
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 07:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C223C553A;
	Tue, 30 Jun 2026 07:10:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BB022F01;
	Tue, 30 Jun 2026 07:10:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782803444; cv=none; b=HBcKgLjv92UPqBymrzJyG/JLWs0ezCcYZN+pFDPwfTZi3k82yIl9RumfEKmBydiJPa/o8TyHxNzy3LQuxU8Xtbtct7eKpxSxwbrHxLTcUAb04nwtozTen9009FpY+VXfIg+HWhFIIGwV6NTXRRckVQBygAisCNhwXNDDofg+mIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782803444; c=relaxed/simple;
	bh=3h+yZ7dSIJlwhS36iyfSrce3AD/uPGoPvLqjm4g/lL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tJLbMqhDrGTzUYmYU4NQPVxE+vzHlxzur9hmjmc5nnrILtkbVxq1GDQ76aT60GSfr2Kjl2vChdM/ji8mZkieoVanRkmJNM3hZxj8yuSiDZ4/ZmsSrGiF8J3oBklDOcCAIgzbINWTXCVTWA0ZstjgFkhlW/lA/25GImkaiasUaro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
X-UUID: cb299174745211f1aa26b74ffac11d73-20260630
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c2af0ca4-82eb-4383-94b4-047f87707c88,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:cdfa5a9ea981bed2f6e5882f9b17f439,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cb299174745211f1aa26b74ffac11d73-20260630
X-User: xieyi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xieyi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1765539014; Tue, 30 Jun 2026 15:10:36 +0800
From: Yi Xie <xieyi@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Xie <xieyi@kylinos.cn>
Subject: [PATCH] io_uring/rsrc: bound io_coalesce_buffer() page array allocation
Date: Tue, 30 Jun 2026 15:10:17 +0800
Message-Id: <20260630071017.100436-1-xieyi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	TAGGED_FROM(0.00)[bounces-13854-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:xieyi@kylinos.cn,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[xieyi@kylinos.cn,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xieyi@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_FORWARDING(0.00)[];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,kylinos.cn:email,kylinos.cn:mid,kylinos.cn:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2FD116E0FEE

kvmalloc_objs() in io_coalesce_buffer() does not check for size overflow
when nr_folios is large.  Mirror the check used in memmap.c before
allocating the page pointer array.

Signed-off-by: Yi Xie <xieyi@kylinos.cn>
---
 io_uring/rsrc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8d0f2ee24e0c..f1f8d6dd102c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -776,6 +776,8 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 	unsigned i, j;
 
 	/* Store head pages only*/
+	if (nr_folios > INT_MAX / sizeof(struct page *))
+		return false;
 	new_array = kvmalloc_objs(struct page *, nr_folios);
 	if (!new_array)
 		return false;
-- 
2.25.1


