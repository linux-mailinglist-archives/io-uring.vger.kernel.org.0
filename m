Return-Path: <io-uring+bounces-13308-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LdTJzZJBGrNGgIAu9opvQ
	(envelope-from <io-uring+bounces-13308-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 11:49:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BF6530EF3
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 11:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6C3C30CEC6C
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 09:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B473E8C62;
	Wed, 13 May 2026 09:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aod9k/kP"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B9C3E9C0E
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 09:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778665405; cv=none; b=UDwbJvmr/LuilDuSpUxpB2Sf/SEIZNNXuagCO960FXG/ZJ6/jiV6lmoqxm6zzhK3xsUow89OqKH+IuPQe3WfGSkh1e1dlUjuhLbBEY29d/g63T/L2gaOhblIMjnwNUdVqtH1L5HdYujF0xqHNztefxgad86BytQGOyb+7SxEiZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778665405; c=relaxed/simple;
	bh=ojCXhG2909dh6YJvNUbwV9rcvQMCcUtfstkd2u6AbF8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HTVZ15plLc7OJZCqYGyccSgKhHIsSnyLlGxLeFoM2Xm+aEnLK71+poDUaK1USvUeYllkDQH5RTJbYaY23xJDhoZv47jXbPILLtzAlUd8Z1BBuJIB0kJ8F0mLRdhTDuX1JTLEEgPptcBbaMD91OEOJXBi/6Z1fVAv3HSJc7t8+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aod9k/kP; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Fh
	ME0RRIPxGcC1PSZ7RFeDVB3Eed9DcSLOVIln+weRY=; b=aod9k/kPICQe8uhGg6
	Ygeygbumcdew0O2DZJ+CugBnceEC5ObVj+mcxpZZi5CHPtnXvRTp8rT3bcgcT+N+
	wxfauoOkrLscidE6lN+CNoqp6snafTCiWo35iSMunt4ZhFBZNx86xoo70AzV02Lo
	F3r/v+QOCFG3r7/1aOKcXPuXY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDnnZOpRwRqD2FkBA--.16076S2;
	Wed, 13 May 2026 17:43:07 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] io_uring/rw: drop unused attr_type_mask from io_prep_rw_pi()
Date: Wed, 13 May 2026 17:43:03 +0800
Message-Id: <20260513094303.866533-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnnZOpRwRqD2FkBA--.16076S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFy3uF1fZr18XF1fXrW5Jrb_yoWkCrgE9r
	srGryruFsIgF4Fyw47Ga9aqrZFvw47Wa15u3Z7K3srZa47AFn8Zr4kJF98ZrWkur4UWFnx
	GayDC34a9F1fAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRyxRPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QuXKGoER6tLywAA3f
X-Rspamd-Queue-Id: 19BF6530EF3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13308-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kylinos.cn:email,kylinos.cn:mid]
X-Rspamd-Action: no action

io_prep_rw_pi() never used the attr_type_mask argument. Callers already
validate sqe->attr_type_mask before invoking the helper (only
IORING_RW_ATTR_FLAG_PI is supported today). Remove the dead parameter to
avoid implying further interpretation happens here.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index e729e0e7657e..0c4834645279 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -230,7 +230,7 @@ static inline void io_meta_restore(struct io_async_rw *io, struct kiocb *kiocb)
 }
 
 static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
-			 u64 attr_ptr, u64 attr_type_mask)
+			 u64 attr_ptr)
 {
 	struct io_uring_attr_pi pi_attr;
 	struct io_async_rw *io;
@@ -305,7 +305,7 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return -EINVAL;
 
 		attr_ptr = READ_ONCE(sqe->attr_ptr);
-		return io_prep_rw_pi(req, rw, ddir, attr_ptr, attr_type_mask);
+		return io_prep_rw_pi(req, rw, ddir, attr_ptr);
 	}
 	return 0;
 }
-- 
2.25.1


