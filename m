Return-Path: <io-uring+bounces-12547-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCICHMPop2mDlgAAu9opvQ
	(envelope-from <io-uring+bounces-12547-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:09:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F6371FC3E9
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F65E3011070
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 08:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323A73822BA;
	Wed,  4 Mar 2026 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="P376xUdN"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67B82D949B;
	Wed,  4 Mar 2026 08:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611445; cv=none; b=HHn9sIbMfMxtev3IJhC/X9Z+aWAfRBLIUgKIyna2GzYOF3bgovV9hV2b2H+pihoHubAO041SlZvAEkJYR1XvlyDW8aw13qeSLiNtO133eV4tmhNXyk0CIQ7oab482W8E+bzG6BwUPQ/VCMsWaq7DM3lzXBeOorm6vZSDCt1nMwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611445; c=relaxed/simple;
	bh=4nhnK/caT+5lVyHZhvTwEdE//w0eYhU8dWxnE45mTEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JsbIDX8nVik+kuEbuIFOTy8jR3GbOqhzLQs61AYX/DMAFMsz0yExVZlmlB8ySwwWRnAApwLDMJYao3qkTqkeYQrp+VIZmceBjzPlZz76TlAKO8IkXLsrgtdlQniEn+5kFLlghYpVCpeRCOCJIk7eHJdF62ftJKrufefbO+zUhyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=P376xUdN; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1Y
	BNzXxLpA3HY1a54/AnAdwwruJdKBfVzW9rKDno53k=; b=P376xUdNwCEPq/i73S
	bqmGIV16h2pzHTB47WoKvz/GZgszi95Xwl9tvLmTg8PqbG3DWgBU3rwcOayjlijL
	gAg9AFm+/CFYKWsBYDBDUMjohYPHDng+6pdpl3Emmk3NSCH8HDVlndih3D3mtJsN
	aCXKvLJcOIOCG18je43QGhys4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3CvhD56dpCDV7PA--.26869S3;
	Wed, 04 Mar 2026 16:03:23 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v5 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Wed,  4 Mar 2026 16:03:11 +0800
Message-Id: <20260304080313.675768-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3CvhD56dpCDV7PA--.26869S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJF4fWFWfXF4xJFWUurg_yoW8XrWfpF
	s8Kw4fXFWUWw4I9r43Wa4jka4YqF40y3W7G3y7Zrn093Z0qFy8Ar4UCF4UK3Wjq39rAry0
	9r17trZ8Cw4jvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUzV8UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgtQ4Gmn50vMtwAA3g
X-Rspamd-Queue-Id: 8F6371FC3E9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12547-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..983c6e2b6871 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,26 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+struct bsg_uring_cmd {
+	__u64 request;		/* [i], [*i] command descriptor address */
+	__u32 request_len;	/* [i] command descriptor length in bytes */
+	__u32 protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
+	__u32 subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
+	__u32 max_response_len;	/* [i] response buffer size in bytes */
+
+	__u64 response;		/* [i], [*o] response data address */
+	__u64 dout_xferp;	/* [i], [*i] */
+	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
+				 * dout_xferp points to array of iovec
+				 */
+	__u64 din_xferp;	/* [i], [*o] */
+	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
+	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
+
+	__u32 timeout_ms;	/* [i] timeout in milliseconds */
+	__u32 flags;		/* [i] bit mask */
+	__u8  reserved[8];	/* reserved for future extension */
+};
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


