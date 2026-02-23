Return-Path: <io-uring+bounces-12372-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOC4KfFfnGntFQQAu9opvQ
	(envelope-from <io-uring+bounces-12372-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:10:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E633177C9B
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6AEAC301A417
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D0B280317;
	Mon, 23 Feb 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBPKtoee"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4793027FB0E
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855850; cv=none; b=U4aQKmvZT7fuyd7s9RUwOyNzV8TOrusa9b33UPnEH4GDvIVsV9HpQoHMdCOYMVEc19JiwhtqeRB4q1IcSn0780va3Ti8qOtQTNoT6NQ//emTXzN/17RRDuOIUDloACwtkssMZoY+L4Lez/3oJdsalDm5srnao2qEBM7r+jNuMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855850; c=relaxed/simple;
	bh=L2fL7Kic+qNzkKWXtXTN7Xpq3HDKl14ycD3fr43StE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwhOtHQGNjErBrrne8CaMiSs+Q7oii69TXI5oCdkSKTXXYsdtBnI+X+E9FVzNd1JxYpUI8qGLyAlX3vC7WFyj7iTdTxZ+HSzn7iRVY4VWG2AsDHUDyhqTWRn0WZv6/iYUTUIcuFMOk+uvKiQxb1Fi6wa6UGEEaGWpPbPYkku+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GBPKtoee; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4362507f396so4220653f8f.0
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855847; x=1772460647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2L+RGBoI09w854zek6LVZ4E2MfPbfE0YM15RuJvb2s=;
        b=GBPKtoeeiM9C0Hnb/EJhzvpMj43UMKxLpy4kmcXcwTEAlTeef8IBZBHCFiWaLIa2MN
         nuG9kbYk/Wp4tUB5I+3pxEosVakd/Rac7vllUtJoso71obCCz7yUq9sZlSiZssIoZ00t
         EmWNyzgF4uES17mrZ7UFCr8yJya1iRO950FM2WPVo2aZBGdJ5J4HgURXk2ylsR8+LGqI
         bsjhF9zstAJw+U950BRmkGkNLFDWiRMj54u6U2UoWUpzyXCtM4IbROztqGBzSdoBCaRL
         Xx1gKHzqQHy9uv5akft4rbWiQREnbgrbrn34BDQ857cO+B4jfF64iKC05AUJUjNzoMfV
         YR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855847; x=1772460647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s2L+RGBoI09w854zek6LVZ4E2MfPbfE0YM15RuJvb2s=;
        b=pMTvdPNnTNxsu6MJr6R8aiLTBo7yKwYFccrPydjmoxn2RYUvLxWKTxxxTEYS7Djrgz
         RWIm7HEhgEl0SjHfOrQlIVplWmm9qcoSSMc03aDVCXsI2sceDb6EU50Am5pAphwdWrlX
         4iYE3LQ4o+WdeZ0/mCoJzyEgH54r+L3geLMUWp4CiJT/1ezaHYMGO1ZVdNTvf6+zT6OB
         OuvUwYQsGPglKlqclN88U35fHQrasAwVTNWuQ2vNYPaJQqr7MMqsBfbhhUYOqcE8Q+Il
         WcmQNlJkIWD/b6X0MFu2CJYiFM6CstRyBzGc9Oj1R26ar855rOgEePyFOceEeCRi7dEq
         UN3Q==
X-Gm-Message-State: AOJu0YzY2C3DgdER/7cuE6IHCIYIhvBo0/8ZVtEh9WCNfinIVe7T//13
	FQIoU/4kbljTNl3U/5ZKoEmyfJ9WIoQSodFBs2DfGfcZ70bFhp4LipWdUzxmRA==
X-Gm-Gg: ATEYQzx47iPgS4GYeuwUCSKET044IvhS4VgQFTUiuMisZTdZmTu2PRv0jNujz21Umh4
	67EKduZy/mtdK2ERH3xGHY4OHVmatMK2ldZw6oMEu1tIOnuW65ZeJlfF70zIEg9RXSia8b307Ed
	z2aSvKn2ldlQn8c4blaUzHq1hV6UZwR64y91HvJhBhJQepznGL4hGllL24/Pppj2ahiB1TtIRx/
	EiO5fvsb+ttpMaeYZX6Qw2sPBoJcwmpWtZdG9ssxd2AxOMeiy+6LqtLDbc9Gwg0pFVrPD2psU0G
	Nx2To1UVxVIolOkXBIusNuhiskLCzuE1o8+PIojwajCPx7kw4iO0yj3pEngkaYxvvtqg49hbbaO
	J0Z5yFdkMc2C04YQpH4NqHC3duKAkSKRc2B0LFLE//TK1tCKcR8dJuP+1LsmBetEpBqAHi/IcSn
	biVivJGGWuInCDx5Qof9eUKuEDIMEZfI1VdkL5k9n17URbKO49n+oxBj8HYcPNwQjU57D56TpLt
	13LszKRwUB7fULWu9fi
X-Received: by 2002:a05:6000:3107:b0:436:34d9:4627 with SMTP id ffacd0b85a97d-4396f17baf1mr15862427f8f.37.1771855847192;
        Mon, 23 Feb 2026 06:10:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bf9feasm19464640f8f.6.2026.02.23.06.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:10:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 05/10] io_uring: update tools uapi headers
Date: Mon, 23 Feb 2026 14:10:16 +0000
Message-ID: <8aef9b7a8da1ea5ba7af04b513aa70479f6dfb55.1771855761.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771855760.git.asml.silence@gmail.com>
References: <cover.1771855760.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12372-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5E633177C9B
X-Rspamd-Action: no action

Update the tools/ io_uring.h uapi header to include the region API and
new registration opcodes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/uapi/linux/io_uring.h | 96 ++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/io_uring.h b/tools/include/uapi/linux/io_uring.h
index f1c16f817742..d1b649caed48 100644
--- a/tools/include/uapi/linux/io_uring.h
+++ b/tools/include/uapi/linux/io_uring.h
@@ -198,6 +198,33 @@ enum {
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
 
+/* Use hybrid poll in iopoll process */
+#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
+
+/*
+ * Allow both 16b and 32b CQEs. If a 32b CQE is posted, it will have
+ * IORING_CQE_F_32 set in cqe->flags.
+ */
+#define IORING_SETUP_CQE_MIXED		(1U << 18)
+
+/*
+ * Allow both 64b and 128b SQEs. If a 128b SQE is posted, it will have
+ * a 128b opcode.
+ */
+#define IORING_SETUP_SQE_MIXED		(1U << 19)
+
+/*
+ * When set, io_uring ignores SQ head and tail and fetches SQEs to submit
+ * starting from index 0 instead from the index stored in the head pointer.
+ * IOW, the user should place all SQE at the beginning of the SQ memory
+ * before issuing a submission syscall.
+ *
+ * It requires IORING_SETUP_NO_SQARRAY and is incompatible with
+ * IORING_SETUP_SQPOLL. The user must also never change the SQ head and tail
+ * values and keep it set to 0. Any other value is undefined behaviour.
+ */
+#define IORING_SETUP_SQ_REWIND		(1U << 20)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -253,7 +280,17 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
-
+	IORING_OP_FIXED_FD_INSTALL,
+	IORING_OP_FTRUNCATE,
+	IORING_OP_BIND,
+	IORING_OP_LISTEN,
+	IORING_OP_RECV_ZC,
+	IORING_OP_EPOLL_WAIT,
+	IORING_OP_READV_FIXED,
+	IORING_OP_WRITEV_FIXED,
+	IORING_OP_PIPE,
+	IORING_OP_NOP128,
+	IORING_OP_URING_CMD128,
 	/* this goes last, obviously */
 	IORING_OP_LAST,
 };
@@ -558,6 +595,38 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* return status information for a buffer group */
+	IORING_REGISTER_PBUF_STATUS		= 26,
+
+	/* set/clear busy poll settings */
+	IORING_REGISTER_NAPI			= 27,
+	IORING_UNREGISTER_NAPI			= 28,
+
+	IORING_REGISTER_CLOCK			= 29,
+
+	/* clone registered buffers from source ring to current ring */
+	IORING_REGISTER_CLONE_BUFFERS		= 30,
+
+	/* send MSG_RING without having a ring */
+	IORING_REGISTER_SEND_MSG_RING		= 31,
+
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 32,
+
+	/* resize CQ ring */
+	IORING_REGISTER_RESIZE_RINGS		= 33,
+
+	IORING_REGISTER_MEM_REGION		= 34,
+
+	/* query various aspects of io_uring, see linux/io_uring/query.h */
+	IORING_REGISTER_QUERY			= 35,
+
+	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
+	IORING_REGISTER_ZCRX_CTRL		= 36,
+
+	/* register bpf filtering programs */
+	IORING_REGISTER_BPF_FILTER		= 37,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -578,6 +647,31 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+enum {
+	/* initialise with user provided memory pointed by user_addr */
+	IORING_MEM_REGION_TYPE_USER		= 1,
+};
+
+struct io_uring_region_desc {
+	__u64 user_addr;
+	__u64 size;
+	__u32 flags;
+	__u32 id;
+	__u64 mmap_offset;
+	__u64 __resv[4];
+};
+
+enum {
+	/* expose the region as registered wait arguments */
+	IORING_MEM_REGION_REG_WAIT_ARG		= 1,
+};
+
+struct io_uring_mem_region_reg {
+	__u64 region_uptr; /* struct io_uring_region_desc * */
+	__u64 flags;
+	__u64 __resv[2];
+};
+
 /*
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
-- 
2.53.0


