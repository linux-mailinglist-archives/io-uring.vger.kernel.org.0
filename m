Return-Path: <io-uring+bounces-13321-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOCpIFSJBWrGYAIAu9opvQ
	(envelope-from <io-uring+bounces-13321-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 10:35:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B13C153F606
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 10:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72692300228F
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 08:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094293DCDAB;
	Thu, 14 May 2026 08:35:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6D43DC857
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 08:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778747713; cv=none; b=Lr37KhUVbewIw0inHgsmoc5aiQZ0Urgs9FXVLWnSoff/Z4aS09H/kIvEv+V1EpVLrC/CO0VnpfGFzuYgDjnK6jSE6c3SZH/yUKLYdv275yUlyf0ByHoT4Z3HQ54lnqX++wNxbtoWPAKsShadGYgrFOy5wldTowyUqpnRHYnsZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778747713; c=relaxed/simple;
	bh=UHVDmNe+B3lwBRDy70HgS1/F5uCXTaWMp87Ni+8UDms=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DEWQsYCisv40u6POkiyHU6oF1walWBTO8N0kAdMl8IL2nHFKgDqVtwBzVcwbrx0Ntp8jaiTRldi/2OlnLNey3JAQLGSiEhnk9K1Z6/f1i9fCZDPILp0wCfGuOg281T/skkwZVn3A8/atObO23YYm3cxsXkeUYyvjH00MX34LHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: cb8633144f6f11f1aa26b74ffac11d73-20260514
X-CID-CACHE: Type:Local,Time:202605141632+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:26f4c621-dfcd-429a-a694-a565f0fb089b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:2aa2e8086385de7bf4782e18a8d18f04,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cb8633144f6f11f1aa26b74ffac11d73-20260514
X-User: xieyi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xieyi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 479044440; Thu, 14 May 2026 16:34:59 +0800
From: Yi Xie <xieyi@kylinos.cn>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Yi Xie <xieyi@kylinos.cn>
Subject: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
Date: Thu, 14 May 2026 16:34:43 +0800
Message-Id: <20260514083443.203387-1-xieyi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B13C153F606
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-0.983];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	R_DKIM_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kylinos.cn];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kylinos.cn:email,kylinos.cn:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xieyi@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13321-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3]
X-Rspamd-Action: no action

Wrap the io_ring_head_to_buf() macro value in an extra pair of parentheses
so it is safe when composed into larger expressions, and to satisfy
scripts/checkpatch.pl.

Signed-off-by: Yi Xie <xieyi@kylinos.cn>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 63061aa1cab9..dd54e43e9ddf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -21,7 +21,7 @@
 #define MAX_BIDS_PER_BGID (1 << 16)
 
 /* Mapped buffer ring, return io_uring_buf from head */
-#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+#define io_ring_head_to_buf(br, head, mask)	(&(br)->bufs[(head) & (mask)])
 
 struct io_provide_buf {
 	struct file			*file;

