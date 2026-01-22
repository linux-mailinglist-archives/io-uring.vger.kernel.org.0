Return-Path: <io-uring+bounces-11880-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDs9BRmFcWk1IAAAu9opvQ
	(envelope-from <io-uring+bounces-11880-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 03:02:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B340460A87
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 03:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 20645442AD1
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 01:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E8929A9F9;
	Thu, 22 Jan 2026 01:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="A7n8RbZG"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96534F257;
	Thu, 22 Jan 2026 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047075; cv=none; b=iy7hkQYjlPmiQD6VbzqtNdfI7zahZ8YnekblTtc99HE/5frEO1wcJe6xvhKmYjw2VLCUyziCf05H+3O4/BGQCs/4rBHBDYo9ObF+7oUvAKCt6sUoxtmm9XEySuWVm1RzJmV5dUvYer8huzegwBFPeDW0GYma2OQmmdNEM5zOB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047075; c=relaxed/simple;
	bh=4nhnK/caT+5lVyHZhvTwEdE//w0eYhU8dWxnE45mTEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1xfA2p0jSOo7Knia6NDpXfSdk/jfAlWDkhGf2xBt0aRugO6jxwVb5Ob/jH2a5BuHjZ1PIoXAzqTs1Bgis5SjUKnSkTfSvf/H/rZAdVza8jlPNeQEEkOoKZDR7AZTygKxH0/n16IPvgp70Ru+Bae76+96c+Jiscx+Xy12cMidTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=A7n8RbZG; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1Y
	BNzXxLpA3HY1a54/AnAdwwruJdKBfVzW9rKDno53k=; b=A7n8RbZGrmoR0bu/zf
	syP2jtginD4eWcwA+N1fmF9c9Zii+sJ5j3R0NHQS7CCpGNItnSvdQp79d7BnswXN
	/vgYg5lW6ZAVmR4wMScdHkLjjFrs9uHNNB0MWdJaQIiBBxFfxVVmFVunsCjeWtog
	0Dnk2oJSCvdVSmWMNtine1Fl4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBHTZvng3Fp059XOA--.28408S3;
	Thu, 22 Jan 2026 09:56:57 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH v4 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Thu, 22 Jan 2026 09:56:51 +0800
Message-Id: <20260122015653.703188-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260122015653.703188-1-yangxiuwei@kylinos.cn>
References: <20260122015653.703188-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBHTZvng3Fp059XOA--.28408S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJF4fWFWfXF4xJFWUurg_yoW8XrWfpF
	s8Kw4fXFWUWw4I9r43Wa4jka4YqF40y3W7G3y7Zrn093Z0qFy8Ar4UCF4UK3Wjq39rAry0
	9r17trZ8Cw4jvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUvtZUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQnRYmlxg+kesgAA3l
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11880-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:mid,kylinos.cn:email,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: B340460A87
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


