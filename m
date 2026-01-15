Return-Path: <io-uring+bounces-11723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E5900D22038
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 02:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6BF273016BE8
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 01:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848612417C2;
	Thu, 15 Jan 2026 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CofWKcDv"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608F318D658;
	Thu, 15 Jan 2026 01:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440319; cv=none; b=sJ2xGRLQe/p9aJZlWutZLKmP9E6JdZz1S8QA/tCGVCHuI46Itbag5MQhAjCS/iv5xQC7Mzht2n6yhLtc6MZyPQx8iGPsfj0hZD3ugYMcdmgrVKJDZBW4PRZVxnDeayV5mWgu9+kBhPlslQyemzsYIH5Ts4pXMu/oBFiCiPD3Sxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440319; c=relaxed/simple;
	bh=+7mJbEL7bhYRYQbaygXbJ6jipiVxMYD41FuqRpmk56U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gz2ypb3QgslUhxnXTLvNtV+dYPbG/KmJwTG0xHQXOTh5WpuxZz81BB+muM3lz+2DuHY64mYdcd0gAZXNuxQdooUL6xOzfqf0xXqMPYSeIQwmBDqRP7/5Auzz/5JNtIJBbs/52TeBm9/nRPTtvkYWu6eI9lPUkDAdGbXuLWaaYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CofWKcDv; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=CD
	a4sABizffoHeb3FGSToXXJwYx+A4tzzMAohS5HNFA=; b=CofWKcDvjZMULjYJuH
	Lauvb18fslYNBg5DPJ5I8yLpvJ9P09tNi7FJ0YLMhthmXeCiGLu4vxI3PUbD3zmg
	nwhQmOx6I2fX4ANWcC4HmFsU5EEHIzCLMBdsUHK/9k3bljq49QQ4WBbk8Qb6NUYK
	WK/i5Tz98TlaeNFrT9JyZTsUI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAnDqzXQWhp5NZdGA--.64S3;
	Thu, 15 Jan 2026 09:24:43 +0800 (CST)
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
Subject: [RFC PATCH v2 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Thu, 15 Jan 2026 09:24:35 +0800
Message-Id: <8dfccdef02fef1de0389b341b264528ddc398a84.1768439194.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768439194.git.yangxiuwei@kylinos.cn>
References: <cover.1768439194.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnDqzXQWhp5NZdGA--.64S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJF4fWFy7Aw43CF4UArb_yoW8Xr4rpF
	ZYka1fGFWUXa1xZwsxWa4UCa4YqF4vk3W7G3y7ZFn0gFn0qF4ruw4UCr10gw4jqrZFyryS
	9r17trZ8Cw40vw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUwIDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hv6i2loQdufdQAA3x

Add the bsg_uring_cmd structure to the BSG UAPI header to support
io_uring-based SCSI passthrough operations via IORING_OP_URING_CMD.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 include/uapi/linux/bsg.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index cd6302def5ed..0a589e2ceb3b 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -63,5 +63,24 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+struct bsg_uring_cmd {
+	/* Command request related */
+	__u64 request;		/* [i], [*i] command descriptor address */
+	__u32 request_len;	/* [i] command descriptor length in bytes */
+	/* Protocol related */
+	__u32 protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
+	__u32 subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
+	/* Response data related */
+	__u32 max_response_len;	/* [i] response buffer size in bytes */
+	__u64 response;		/* [i], [*o] response data address */
+	/* Data transfer related */
+	__u64 xfer_addr;	/* [i] data transfer buffer address */
+	__u32 xfer_len;		/* [i] data transfer length in bytes */
+	__u32 xfer_dir;		/* [i] 0=din (read), 1=dout (write) */
+	__u32 iovec_count;	/* [i] iovec array count, 0 for flat buffer */
+	/* Control related */
+	__u32 timeout_ms;	/* [i] timeout in milliseconds */
+	__u8  reserved[24];	/* reserved for future extension */
+};
 
 #endif /* _UAPIBSG_H */
-- 
2.25.1


