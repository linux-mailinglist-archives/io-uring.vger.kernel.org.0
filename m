Return-Path: <io-uring+bounces-13857-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3oTsFsmKQ2prawoAu9opvQ
	(envelope-from <io-uring+bounces-13857-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:22:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4316E2161
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 11:22:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13857-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13857-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21E28313E04C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 09:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04103EBF2F;
	Tue, 30 Jun 2026 09:12:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E763EB80E;
	Tue, 30 Jun 2026 09:12:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810765; cv=none; b=EdR72D3G6kZdmcV6ECvuPsr5jrHSqGHZI2vekA04OljYGmd8ou1wwdntfLEYu9+SSSLRXV+Awb+svoJNhUC2XQx+cKX02rFBe+0ynXa7ihM+p/eXoYLaSy/zEKSNO8NA+WdrfKFFZpJTQXHlqByquFRvezkh3K31ZsdYXFrYyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810765; c=relaxed/simple;
	bh=GCP9S3kllwFjZEWe8OSji1YnUETYF+m09HkD5fkuvpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H3MnK9ZdJufT4VakvbXTJFZFWrwb5Zh/Si4LneOM5B7axzLycL/u5Eoez8s6ugDgPIs8gNsRfgs1dk/1t6jc15QVStx1XlcrBcZj8JIHIX1ZXwXOr0/DySHD6Ej64crHuLxkgdCmqE9TNw+WV1dsxydrCyt9Pioem2YBJnetz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
X-UUID: d4fa9426746311f1aa26b74ffac11d73-20260630
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4b3fc901-bbd2-439c-bf64-b245499e94c8,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:a341f5aea137f7cc62bc9b0f11ec87d5,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d4fa9426746311f1aa26b74ffac11d73-20260630
X-User: xieyi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xieyi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1893926105; Tue, 30 Jun 2026 17:12:34 +0800
From: Yi Xie <xieyi@kylinos.cn>
To: axboe@kernel.dk,
	krisman@suse.de
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Xie <xieyi@kylinos.cn>
Subject: [PATCH v2] io_uring/memmap: return -EINVAL from get_unmapped_area() on bad mmap
Date: Tue, 30 Jun 2026 17:12:06 +0800
Message-Id: <20260630091206.126206-1-xieyi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630065700.97360-1-xieyi@kylinos.cn>
References: <20260630065700.97360-1-xieyi@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:krisman@suse.de,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:xieyi@kylinos.cn,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13857-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[xieyi@kylinos.cn,io-uring@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xieyi@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kylinos.cn:email,kylinos.cn:mid,kylinos.cn:from_mime,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6F4316E2161

get_unmapped_area() returns -ENOMEM when io_uring_validate_mmap_request()
fails, but validation errors are -EINVAL. Propagate that errno to
userspace, like io_uring_mmap() already does.

Signed-off-by: Yi Xie <xieyi@kylinos.cn>
---
 io_uring/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index da1f6c5d07f8..23e8a85111bc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -337,7 +337,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 
 	ptr = io_uring_validate_mmap_request(filp, pgoff);
 	if (IS_ERR(ptr))
-		return -ENOMEM;
+		return PTR_ERR(ptr);
 
 	/*
 	 * Some architectures have strong cache aliasing requirements.
-- 
2.25.1


