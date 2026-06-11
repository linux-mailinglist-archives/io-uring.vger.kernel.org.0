Return-Path: <io-uring+bounces-13665-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WuiFJfkNKmrUhwMAu9opvQ
	(envelope-from <io-uring+bounces-13665-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CCF66DA0C
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=LZvw5oZl;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13665-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13665-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6043630EE39F
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CAE92AD16;
	Thu, 11 Jun 2026 01:23:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B215E40D593
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:22:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140980; cv=none; b=jYR26zRJwf8OvbVuoK+pgQohBAPRIYUcvrT40ZeOPYmAoby6VcRFMcjm08NPztghFwYckZHRWfErGFXXLvuucYjIngb4vdjEux30708xLL1zXPFlkyEZkQlg6txyqiQRae/G/MhBWaAp+FJ5FhgfeHPBMtYh4Et/ez2sdtza0ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140980; c=relaxed/simple;
	bh=TIpPB+xERPOQR9Tmg+l1Ugs/L/FzSGWCZfQMgnWru60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GYsWQX5ctfc+AgBqOfkrepT7XrDTTjzplxAEWHnHUy5aLjz3h5j3E4ixSxtarNgx0IqmGzqfH2sHSyYmGyaEi1UWaWmhdUGaoqpPeU7n4X9UFDg2SeUWX0L0/Ui4sAAEQGSROosEM1gqfBn3NkeTAFC3Fyb2kXZlHdaVMMFkjXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LZvw5oZl; arc=none smtp.client-ip=220.197.31.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Bw
	b0CK/7eTdXGZLWprA+aYfNbis9/HhAYC1TCdFOFaM=; b=LZvw5oZlbz/waNkJ5H
	+3KCE0XHjfrXWVQTPUeHstpELjf7tcGu42ZXH76sFQhk3N3W2fYqYvcSKVBozqmE
	51emfb/EKwS5okcYZk/FkONjeEy1zejJAnqKvZ9P5FDNMFGeEkyJrAARL/PLPTUf
	ryoklq+4AwQE3hiAT6ylCyk6U=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDH773gDSpqbsY_Bg--.28099S3;
	Thu, 11 Jun 2026 09:22:43 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/2] io_uring/rw: fix link failure on successful pipe short reads
Date: Thu, 11 Jun 2026 09:22:35 +0800
Message-Id: <20260611012236.3020181-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDH773gDSpqbsY_Bg--.28099S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw1UXr4xXF1rJw4kuFW3Jrb_yoW8Zr4xpF
	4Yk34YkF9rX34Igan3JFW5Xa4SvFySyFWUX3yFgrn8ArnrArnIqF4Fga4rZFy5Krs5Ar42
	qrWvyrZ8u34jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZXocUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgOgMWoqDeNmqAAA3w
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13665-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D2CCF66DA0C

__io_read() treats a short read on pipes and sockets as success and
returns without filling the iov. However, __io_complete_rw_common()
compared the transfer length against the original iov size and set
REQ_F_FAIL when they did not match. That incorrectly failed linked
requests behind a successful head request, for example a nop after a
naturally disarmed link timeout.

Treat short reads and writes on non-regular files as success in
__io_complete_rw_common(), matching the issue path.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/rw.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c4834645279..dd3f24b380b1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -547,10 +547,23 @@ static void io_req_io_end(struct io_kiocb *req)
 	}
 }
 
+static bool need_complete_io(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_ISREG ||
+		S_ISBLK(file_inode(req->file)->i_mode);
+}
+
 static void __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (res == req->cqe.res)
 		return;
+	/*
+	 * For non-regular files, __io_read()/__io_write() may return a short
+	 * transfer without looping to fill the iter. That is success, not a
+	 * failure to be propagated to linked requests.
+	 */
+	if (res > 0 && res < req->cqe.res && !need_complete_io(req))
+		return;
 	if ((res == -EOPNOTSUPP || res == -EAGAIN) && io_rw_should_reissue(req)) {
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 	} else {
@@ -839,12 +852,6 @@ static inline int io_iter_do_read(struct io_rw *rw, struct iov_iter *iter)
 		return -EINVAL;
 }
 
-static bool need_complete_io(struct io_kiocb *req)
-{
-	return req->flags & REQ_F_ISREG ||
-		S_ISBLK(file_inode(req->file)->i_mode);
-}
-
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-- 
2.25.1


