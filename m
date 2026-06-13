Return-Path: <io-uring+bounces-13722-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Dt3zJJrlLWphmQQAu9opvQ
	(envelope-from <io-uring+bounces-13722-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2026 01:19:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 90186680066
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2026 01:19:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=fail ("headers rsa verify failed") header.d=wigham.net header.s=default header.b=gAlkdTSB;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13722-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13722-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C6DB830028E0
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 23:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CB5375F82;
	Sat, 13 Jun 2026 23:19:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cp14.uk.netnerd.com (cp14.uk.netnerd.com [185.229.21.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89E3C06;
	Sat, 13 Jun 2026 23:19:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781392787; cv=none; b=Lz/9+h4PE9Ch2NfZ+kZzLGqgqEnys16RW9s/qwwswTKUbrZfvuuInyqSrl9n8GRSlG4RcV1Gr2Kgft9i+q1Z/6pl/I8sTOaQxE4Lo4hyaMNZc18Fqi5aL+GdoU3eVqaAsueJ6Wwn5c5JXIWajccJEIL2hSPSVMNknO/sHJ99Aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781392787; c=relaxed/simple;
	bh=nybDCkCRGqY1B/+QzPNe34BsrRh/wYncRO+q28jgA8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gj1jpNaa32CJMkC6B31PdyfjCslVUa4DTf5qxu1WV/KMN2OOYj2Jr9YnvAYcHYX9RP949idTkfKM4Gg64qCfFxWgmI1MrsF21tVoJmxiysu4F9knHcqnTLg12hTvX8Rcmny4WIV/zj6+6Q+qOgBb043pZsaiYo9pkMNSUBU1S2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wigham.net; spf=pass smtp.mailfrom=wigham.net; dkim=pass (2048-bit key) header.d=wigham.net header.i=@wigham.net header.b=gAlkdTSB; arc=none smtp.client-ip=185.229.21.114
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wigham.net;
	s=default; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=29HMGrm89TsI6WDdYLYtAeNCdSFS+KB3EBoiicU8hNM=; b=gAlkdTSBm4HURUdasJwp3/t1n8
	Y04ce2/ZsqO82M4Ij48j4j/eCHeF4hUsg58I1m5ST/Uo1mI6cOOveu7aJmcoSKiWlEVgHhvqk6BLh
	gT2JykSlkqh635uZBZmVUEonoqq6AU2hQxBxb/M+VhcOlSOItD3rdXZFZbb7bdfUNiHKvFAbIOf3+
	FlJjts0Ucd0VJ3cFmJpBxPt9WFR4CVHxXCzsNKc4FiWAAVp3OnrH3SOB/wKStcxGXd2GmeHzyZW8u
	EGMiSR+S3aTtNrDQW7DkF+PlsNVa30VeDR1JJS5KG2UlqYymkT7ohfHp42gd+0903XVRhGQIDoaiQ
	IcC2hHBQ==;
Received: from grth-13-b2-v4wan-177038-cust580.vm6.cable.virginm.net ([94.174.226.69]:53378 helo=archwig.local)
	by cp14.uk.netnerd.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.4)
	(envelope-from <michael@wigham.net>)
	id 1wYXEH-00000003m1m-2DR7;
	Sat, 13 Jun 2026 23:53:26 +0100
From: Michael Wigham <michael@wigham.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Wigham <michael@wigham.net>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/rw: preserve partial result for iopoll
Date: Sat, 13 Jun 2026 23:52:16 +0100
Message-ID: <20260613225240.34032-1-michael@wigham.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cp14.uk.netnerd.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - wigham.net
X-Get-Message-Sender-Via: cp14.uk.netnerd.com: authenticated_id: michael@wigham.net
X-Authenticated-Sender: cp14.uk.netnerd.com: michael@wigham.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_REJECT(1.00)[wigham.net:s=default];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	HAS_X_AS(0.00)[michael@wigham.net];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:asml.silence@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:michael@wigham.net,m:stable@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[wigham.net];
	HAS_X_GMSV(0.00)[michael@wigham.net];
	FORGED_SENDER(0.00)[michael@wigham.net,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,wigham.net];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TAGGED_FROM(0.00)[bounces-13722-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DKIM_TRACE(0.00)[wigham.net:-];
	HAS_X_SOURCE(0.00)[];
	HAS_X_ANTIABUSE(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[michael@wigham.net,io-uring@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wigham.net:email,wigham.net:mid,wigham.net:from_mime,vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 90186680066

A partial read will store the completed byte count in io->bytes_done.
The regular completion path applies io_fixup_rw_res() so that, when the
following operation reaches EOF, the number of bytes already read is
returned.

The iopoll completion path does not apply this fixup to the return value
and can return zero instead.

Use the fixup result when updating the CQE, and the raw result for the
reissue check.

Cc: stable@vger.kernel.org
Fixes: 4d9cb92ca41d ("io_uring/rw: fix short rw error handling")
Signed-off-by: Michael Wigham <michael@wigham.net>
---
pread(), normal io_uring, and io_uring iopoll should return the same
result for a read that extends past EOF. Before this fix, the io_uring
iopoll path returned zero.

To test the fix, a standalone test prepared an 8704 byte file opened
with O_DIRECT and issued a read of 1024 bytes from offset 8192. Before
this change, the IOPOLL path transferred 512 bytes into the buffer but
reported a result of zero. With this change, pread(), normal io_uring,
and io_uring IOPOLL all report 512 bytes read.

All liburing tests passed.

 io_uring/rw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c4834645279..63b6519e498c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -601,15 +601,15 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
+	int final_res = io_fixup_rw_res(req, res);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
-	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req))
-			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-		else
-			req->cqe.res = res;
-	}
+
+	if (res == -EAGAIN && io_rw_should_reissue(req))
+		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
+	else if (unlikely(final_res != req->cqe.res))
+		req->cqe.res = final_res;
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
-- 
2.54.0


