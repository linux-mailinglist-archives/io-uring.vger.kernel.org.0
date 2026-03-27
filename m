Return-Path: <io-uring+bounces-12879-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAb/LVy/xmnoNwUAu9opvQ
	(envelope-from <io-uring+bounces-12879-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:33:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 288FF34867E
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 76CAE30526FE
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAA331618C;
	Fri, 27 Mar 2026 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n5kuleBk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F7F396B8B
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632426; cv=none; b=YmhSPxdSR1aFvEZVGvXjdREtu5uHgSvSh1n40yB/zB0el+NKoIld1qPscXRJpgWXMPnzu4pBgtSZC4RC+7ThsIhRvrC0qq18D+VPmnSuMYgZG8Rsw4V91d3AqSKbpihRv+uFOH585JF0ImxseYyf1wQV9ZwYOO+BI8oAgGeseXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632426; c=relaxed/simple;
	bh=tDwXiFqUAiwaMiB0VD+z7lDwUuZ5A5R4cZ91C+9RCuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4d6rye+I/3vHn1a8itzwu0ECB2Jqj0yhtZod5ZTmFLthri0SUluA4dsMGdr8rQwWGHdYAaHrPrgPOZ7Ho12XZHHyq4OCKf4tbQj2tZ+8bl+feOorXhb9uvUgD933Ehvwx7/GELCTm+MXQ7aQSI4Us33yMeXyFPjzEn7mkPQNRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n5kuleBk; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ad617d5b80so16863375ad.1
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632424; x=1775237224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwULbummLH3V3OOtstbxQjM0HDSDvzfPTHeo2WuhQJ4=;
        b=n5kuleBkX5fuTkF5EoU4jJvvMnSQgmdopvS4qyUfBjteLPBOXVwiqpv6vE6K+3EHL9
         httN3+BjHHn7jbbPlmp6I9mqNYeV+PT9DgMp3JrKACjhjP3eQaT9NceWT1UuWAO2D6UD
         yt8f7xEIHBwUhc4W9bERCJwN6EBNwLT8s+H7snWxMLqard8bBDmraI87AN11jaNablXA
         k0Xhx9PpAvhpSFunSxHzriCK4QzxG+/sdP9ZGUVYMZUxe01akd/u6sgC8h+Mj5qH37zF
         Vw/qaFpXn+R/MKdiSl/RTSfP3UwfwsyuCd50qrfIYH4IKufNkhslOvvQIcTHpDWqgrR+
         yV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632424; x=1775237224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kwULbummLH3V3OOtstbxQjM0HDSDvzfPTHeo2WuhQJ4=;
        b=qReI0e5oxIDsMMuYx9jLFqpF5cJCQAfrDMW1HMAk5Ea+Tut4s3g6W4feYMVd74pqju
         cY9ivn523ZkcKoYmaAXZsoTUBREFJIJ881+QCNDPeoht1uiNQMG4ivWg7aM3xftK46rx
         8nUdTqSygqtkQ1l1rPnUuikZX2SZh0GNHKW7zb6pM07ssEwRAFLYYYFKDnhqzhH9IKvD
         3Jt37Gp2oA3SsmkJadIZ1FPJ7viwPDTq6JOXZshmjRyXzQ+cdmngweAdbOvxBjP1yarL
         nOPZTZJGE+CmVuIqYEAJj3SAkM0Hw9KVcEirZrPYOTEZohDffoWnsnRqev8WQpcCKrhm
         ze4w==
X-Forwarded-Encrypted: i=1; AJvYcCXKyLyq9BcV01wbaKa0WOOJ2AvkUTs0XRs5CPuBJV7nZRPqJ8lQeIxxhAQlUxHB8UD6xlysELsuBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWOy52yKh5A+aTA6De5dx9ziQ3mTjQzF0rg1Y7Cbif47Bj+VCC
	siMBceOYzcZOUbmlqsVH/bpv8TrWcqJZRqhRAcTafDbpx5LkPNBU5izMzNlb+A==
X-Gm-Gg: ATEYQzxXnmcWaHqhYIqkAoKESot2nuiJGbfppO8Leg3xO2b7BS0E5b+Qy1B3KXtgvmA
	T/7wv1kox4wMxqLD72dDvsWpKU/LzRNVmqNeIpRf3UxYkOifUW9a/8Jjj1KVhaO7VUQSgjarvV9
	+B3N11fO+H5fLz2xsf7QWj9SLjkSim5mW3qg3z2uflxv4jkFK+EvWuOxawIqC0oKzu8CZo4lH1N
	yA3+9D+EdbIFbO26C2Nm2cumNZ72Zj55o49uHAimItOPYoArrHR57wAgkZ1AE7YyltWroVYVhqX
	HbXiCRDj7cu24mk99luU4N5Dc2WqmGjipMy62FeS4QY9w+zUI4OKEiLrzCmGBsVTW9NYw2U1doW
	mPGJcZK4ioJChidxSOtnc7V67nbCjGpYJ3igUBZhcw2eO98tuITzId+kItLls/FceVqQ5EJq9/b
	3CWguSq+z+XW7+B/l97A==
X-Received: by 2002:a17:902:fc85:b0:2b0:5990:cf1e with SMTP id d9443c01a7336-2b0cdcc8706mr31221515ad.33.1774632424245;
        Fri, 27 Mar 2026 10:27:04 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8a16dasm64640325ad.55.2026.03.27.10.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:26:59 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 1/5] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
Date: Fri, 27 Mar 2026 10:26:27 -0700
Message-ID: <20260327172631.3380702-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327172631.3380702-1-joannelkoong@gmail.com>
References: <20260327172631.3380702-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12879-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,purestorage.com:email]
X-Rspamd-Queue-Id: 288FF34867E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently, io_buffer_register_bvec() takes in a request. In preparation
for supporting kernel-populated buffers in fuse io-uring (which will
need to register bvecs directly, not through a struct request), rename
this to io_buffer_register_request().

A subsequent patch will commandeer the "io_buffer_register_bvec()"
function name to support registering bvecs directly.

Rename io_buffer_unregister_bvec() to a more generic name,
io_buffer_unregister(), as both io_buffer_register_request() and
io_buffer_register_bvec() callers will use it for unregistration.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 Documentation/block/ublk.rst | 14 +++++++-------
 drivers/block/ublk_drv.c     | 22 +++++++++++-----------
 include/linux/io_uring/cmd.h | 26 ++++++++++++++++++++------
 io_uring/rsrc.c              | 14 +++++++-------
 4 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
index 6ad28039663d..f014d1d69019 100644
--- a/Documentation/block/ublk.rst
+++ b/Documentation/block/ublk.rst
@@ -382,17 +382,17 @@ Zero copy
 ---------
 
 ublk zero copy relies on io_uring's fixed kernel buffer, which provides
-two APIs: `io_buffer_register_bvec()` and `io_buffer_unregister_bvec`.
+two APIs: `io_buffer_register_request()` and `io_buffer_unregister`.
 
 ublk adds IO command of `UBLK_IO_REGISTER_IO_BUF` to call
-`io_buffer_register_bvec()` for ublk server to register client request
+`io_buffer_register_request()` for ublk server to register client request
 buffer into io_uring buffer table, then ublk server can submit io_uring
 IOs with the registered buffer index. IO command of `UBLK_IO_UNREGISTER_IO_BUF`
-calls `io_buffer_unregister_bvec()` to unregister the buffer, which is
-guaranteed to be live between calling `io_buffer_register_bvec()` and
-`io_buffer_unregister_bvec()`. Any io_uring operation which supports this
-kind of kernel buffer will grab one reference of the buffer until the
-operation is completed.
+calls `io_buffer_unregister()` to unregister the buffer, which is guaranteed
+to be live between calling `io_buffer_register_request()` and
+`io_buffer_unregister()`. Any io_uring operation which supports this kind of
+kernel buffer will grab one reference of the buffer until the operation is
+completed.
 
 ublk server implementing zero copy or user copy has to be CAP_SYS_ADMIN and
 be trusted, because it is ublk server's responsibility to make sure IO buffer
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 004f367243b6..b9f293261240 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1627,8 +1627,8 @@ ublk_auto_buf_register(const struct ublk_queue *ubq, struct request *req,
 {
 	int ret;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release,
-				      io->buf.auto_reg.index, issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release,
+					 io->buf.auto_reg.index, issue_flags);
 	if (ret) {
 		if (io->buf.auto_reg.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
 			ublk_auto_buf_reg_fallback(ubq, req->tag);
@@ -1868,7 +1868,7 @@ static int __ublk_batch_dispatch(struct ublk_queue *ubq,
 			ublk_io_unlock(io);
 
 			if (index != -1)
-				io_buffer_unregister_bvec(data->cmd, index,
+				io_buffer_unregister(data->cmd, index,
 						data->issue_flags);
 		}
 
@@ -3091,8 +3091,8 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 	if (!req)
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret) {
 		ublk_put_req_ref(io, req);
 		return ret;
@@ -3123,8 +3123,8 @@ ublk_daemon_register_io_buf(struct io_uring_cmd *cmd,
 	if (!ublk_dev_support_zero_copy(ub) || !ublk_rq_has_data(req))
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret)
 		return ret;
 
@@ -3139,7 +3139,7 @@ static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 	if (!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY))
 		return -EINVAL;
 
-	return io_buffer_unregister_bvec(cmd, index, issue_flags);
+	return io_buffer_unregister(cmd, index, issue_flags);
 }
 
 static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_addr)
@@ -3280,7 +3280,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		goto out;
 
 	/*
-	 * io_buffer_unregister_bvec() doesn't access the ubq or io,
+	 * io_buffer_unregister() doesn't access the ubq or io,
 	 * so no need to validate the q_id, tag, or task
 	 */
 	if (_IOC_NR(cmd_op) == UBLK_IO_UNREGISTER_IO_BUF)
@@ -3347,7 +3347,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		req = ublk_fill_io_cmd(io, cmd);
 		ret = ublk_config_io_buf(ub, io, cmd, addr, &buf_idx);
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
-			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
+			io_buffer_unregister(cmd, buf_idx, issue_flags);
 		compl = ublk_need_complete_req(ub, io);
 
 		if (req_op(req) == REQ_OP_ZONE_APPEND)
@@ -3682,7 +3682,7 @@ static int ublk_batch_commit_io(struct ublk_queue *ubq,
 	}
 
 	if (buf_idx != UBLK_INVALID_BUF_IDX)
-		io_buffer_unregister_bvec(data->cmd, buf_idx, data->issue_flags);
+		io_buffer_unregister(data->cmd, buf_idx, data->issue_flags);
 	if (req_op(req) == REQ_OP_ZONE_APPEND)
 		req->__sector = ublk_batch_zone_lba(uc, elem);
 	if (compl)
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 89e1a80d9f5f..165d436073a4 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -106,6 +106,12 @@ bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
 struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 				       struct io_buffer_list *bl,
 				       unsigned int issue_flags);
+
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags);
+int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
+			 unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -184,6 +190,20 @@ static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
 	};
 	return sel;
 }
+static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
+					     struct request *rq,
+					     void (*release)(void *),
+					     unsigned int index,
+					     unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
+				       unsigned int index,
+				       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
@@ -233,10 +253,4 @@ static inline void io_uring_cmd_done32(struct io_uring_cmd *ioucmd, s32 ret,
 	return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, true);
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
-			    unsigned int issue_flags);
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			      unsigned int issue_flags);
-
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 52554ed89b11..7579f6992a25 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -924,9 +924,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-			    void (*release)(void *), unsigned int index,
-			    unsigned int issue_flags)
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
@@ -986,10 +986,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+EXPORT_SYMBOL_GPL(io_buffer_register_request);
 
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			      unsigned int issue_flags)
+int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
+			 unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
@@ -1019,7 +1019,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+EXPORT_SYMBOL_GPL(io_buffer_unregister);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
 				const struct io_mapped_ubuf *imu)
-- 
2.52.0


