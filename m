Return-Path: <io-uring+bounces-13873-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id yPtuLQknRmoQKwsAu9opvQ
	(envelope-from <io-uring+bounces-13873-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:53:29 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5A86F4FC9
	for <lists+io-uring@lfdr.de>; Thu, 02 Jul 2026 10:53:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=WTh9Qtwo;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13873-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13873-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B0FD430EDC2C
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2026 08:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974F23D967F;
	Thu,  2 Jul 2026 08:30:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC6D42E8C6
	for <io-uring@vger.kernel.org>; Thu,  2 Jul 2026 08:30:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981024; cv=none; b=rqEB0l8IieOY1dnZBC/kfLuVu5B98J/ozkGOCbAGjBPpSpBy9Ny08uHbb9RwWunhC/DEmAd33Kq1AiwtLanZX8hAX/zJGTMhrv23SJH1e6AwFTJ3woS8mQs+hO475pvAA9bfFQGRbCiMGdp5GjNTTi2/N0/T8a94eaFmCbrk5qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981024; c=relaxed/simple;
	bh=qU7JJNowmE4a/6g2mr5x1OlJRPHXeQFxjm3O/sOquxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GT9PM4l3oi0Nrlmu0UoIsACqE7igJnR4NERevPKqgDSZsuZCM/teFqkZeu7myZzBNsh5ltDLNqsjorbSlemNKiql7Seb2A7SwGOIevDL74CxIbogRBcXfnwgbVI0KQGOxSF3BCBHriVynxo3tPiNwKe+/Euz5QErr8XVDMZUNgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WTh9Qtwo; arc=none smtp.client-ip=117.135.210.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9n
	Ut1mkCSIQxa8hbS4yDLq4pxlNweeINSOSmAbxh0ts=; b=WTh9Qtwod/XqayS+Ep
	+2JyCZVbxIPLDLjZkt3Gjf7q0cP47/Esdp43uLuR2PPco74GZM6XaTI6GrtIwBN0
	UWtj2FFWyBP4AahdsO0HpArlwy0mu892H9MN2+U/qjDCUE0RcVsQjuE0G0yhE937
	miX8aoXjOSTWKUe8Sangja31I=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnH0R0IUZqmPUCHA--.22854S3;
	Thu, 02 Jul 2026 16:29:44 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/2] io_uring/uring_cmd: copy SQE before issue_blocking punt
Date: Thu,  2 Jul 2026 16:29:36 +0800
Message-Id: <20260702082937.3707134-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
References: <20260702082937.3707134-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnH0R0IUZqmPUCHA--.22854S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw13Kry8XrWfZrykXFW8JFb_yoW3Crb_Cr
	Z8J348uFWfJrWUZr9rG340qr4Fkw47AFWjvrn3GryUGFy7Ca4kG3yDZr45tFnIg3ZrtFy5
	JFZ8Ww13GrnxtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjOzV5UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRiSI2pGIXgS8gAA39
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13873-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kylinos.cn:email,kylinos.cn:mid,kylinos.cn:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DE5A86F4FC9

io_uring_cmd_issue_blocking() punts to io-wq without copying the SQE
off the submission queue, unlike the -EAGAIN and fallback paths. Copy
the SQE into async data before queuing the work.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/uring_cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7b25dcd9d05f..fe32311b2e51 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -326,6 +326,10 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (!(req->flags & REQ_F_SQE_COPIED)) {
+		io_uring_cmd_sqe_copy(req);
+		req->flags |= REQ_F_SQE_COPIED;
+	}
 	io_req_queue_iowq(req);
 }
 
-- 
2.25.1


