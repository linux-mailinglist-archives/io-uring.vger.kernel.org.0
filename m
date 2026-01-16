Return-Path: <io-uring+bounces-11753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E61AD2B5FB
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 05:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03DB730505B5
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 04:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604F03396E0;
	Fri, 16 Jan 2026 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="btoR1IJg"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D755E308F28;
	Fri, 16 Jan 2026 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537574; cv=none; b=cWki2w4tgsvE6NM0TJoA1tHYE3OlRT72gXXIy7P1LrSBAYRijgOaIJrL2RqZV0S3AvJaRl/KyHn3FwyqGEn3jSeVNg8kCOdBkIXT4GroB2W+/VhIwkPpOCfLvp8skPjq2XV1OGV8e6Z8EzzeHqvbIYjY8IgQ4S+nn2HhKVSCDCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537574; c=relaxed/simple;
	bh=f1WI88Lt2rOcdgVk6iIUl3HvGGHesJXUCOuJSbuwMb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zjg4P+5+lINVY8Y9+iJXEJxy+Z8OkVLlZvd1fJ4dtXiXBxxN60LL0+XblJ1Espe4rDbB3AY7SW2KgKAoeY2O+7aw4XJ8Jck5N2ZK0SqmO8bIAVTouvk3A4s/9Sagy9tkv1Z7ZuzpywzJuM8NMsJ8HxXGLBceBMUYvymWkIRxevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=btoR1IJg; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fc
	ftgZ05mHrED0GxvAMOj8ZFpfvRzWtRd4Qt1z3VjY0=; b=btoR1IJgbGiSwi2WFZ
	CZt1gYZf87GXuh5by+aMyf1+3EYIGngF6waUhMfxDrP0olPA/LssJ5rm8Ny3iJO6
	RLSe4VhsMDC7KV/7xDlbcfstConHkD0K0y0dknZ57iQZbT+lF5jU5kIx77UvQCod
	ecC2WYMF0cf3u1x1uWaR4qbdg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXCLKuvWlpM1mcFw--.2330S3;
	Fri, 16 Jan 2026 12:25:21 +0800 (CST)
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
Subject: [RFC PATCH v3 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Fri, 16 Jan 2026 12:25:14 +0800
Message-Id: <d169069cabe953ea7515b08cfe27aaf25678105b.1768536312.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768536312.git.yangxiuwei@kylinos.cn>
References: <cover.1768536312.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXCLKuvWlpM1mcFw--.2330S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJF4fWF4kury3tr1kZrb_yoW8WFy7pF
	s8Kw4SqFWUXw129w43Wa4jka4YqF4vy3W7G3y7ZrnxW3Z0qry8Ar4UCF18Ka1jq39rAryS
	9r17trZ8Cw4jq3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUwIDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRFQ4GlpvbE-jQAA3e

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..d9514b99b7a9 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,29 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+struct bsg_uring_cmd {
+	/* Command request related */
+	__u64 request;		/* [i], [*i] command descriptor address */
+	__u32 request_len;	/* [i] command descriptor length in bytes */
+	__u32 protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
+	__u32 subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
+	__u32 max_response_len;	/* [i] response buffer size in bytes */
+	/* Response data related */
+	__u64 response;		/* [i], [*o] response data address */
+	/* Data transfer related - dout */
+	__u64 dout_xferp;	/* [i], [*i] */
+	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
+	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
+				 * dout_xferp points to array of iovec
+				 */
+	/* Data transfer related - din */
+	__u64 din_xferp;	/* [i], [*o] */
+	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
+	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
+	/* Control related */
+	__u32 timeout_ms;	/* [i] timeout in milliseconds */
+	__u32 flags;		/* [i] bit mask */
+	__u8  reserved[8];	/* reserved for future extension */
+};
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


