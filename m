Return-Path: <io-uring+bounces-13702-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 53sCMpZVLGpHPgQAu9opvQ
	(envelope-from <io-uring+bounces-13702-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4E467BDD8
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:53:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mQ5HuGX9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13702-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13702-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E06F13016D38
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E7335F191;
	Fri, 12 Jun 2026 18:53:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131473093CB
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:53:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290388; cv=none; b=NkrZZZMVUigr57j5a/xwDFaMFjrAHVL9GnaGs1rru02BIcjtHh1ntlG3UNE4oqlYZdTvgTU69CaRPyRnFs8aHUn0YSrJU7VbKLoZ1YP7hrvDkgL7eq5mtIzoIVtW7YYRH3IubGZQgwIjSYGV5yu8eWSVQ0BxrDQCajArNgkQ8UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290388; c=relaxed/simple;
	bh=6AX+7SJvw8Mz8lTu8VN4llPUj4q331TSpGswNpgsaM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS5SEpEB8OpHNGnYq8BnzyHoM5THP9QXlM9I0JtpNRO+FKSYNJ6ugoRw0YSb20o5svBLszaykGJ7bANJxM5hmvc+flIQ8/8M8Cl3qZzZ45zb8X8PQN9eoaMlNN8q8P0ypLA9Z+xlJ9HAt+oJXbi16JSIZTLgX1GKJAXR9g6rEZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQ5HuGX9; arc=none smtp.client-ip=209.85.210.178
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842848fd613so1368730b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 11:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290386; x=1781895186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XHOgdNDd0H22/o7i/iYi5Osc/YEgHzALFo/YgfpKc4=;
        b=mQ5HuGX9yeeJp0hXMGh0EdRlIj4tK+iHddzTyryBh69GztjMGtsyqL7Pk2/E9EGGIH
         0ekr0L/QYHMwS1lvDKuR6NEABG3oDJH87cPo9DUpIweIR1LthNkBw5F0x7KSSFshlRIl
         3epTMYyybUQCTjxsm5Kc7lCPNyT0aMGk5Me4bakeHUPlziyp7XNnKKX5RluVuE+DH7+M
         UKyqppD3wmrHhDdsspszo8NGt/sXzg4RCHrX+7eFV3bPBA9VVRfKcSaH7SM2GPeHf3dF
         Ya+jbOt0nIlqL1MKInW6YzqAKiN6xspEQO3JOsmIbbb6eRCNVfajFYCbNQxaxdQTr1ol
         ZMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290386; x=1781895186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9XHOgdNDd0H22/o7i/iYi5Osc/YEgHzALFo/YgfpKc4=;
        b=NZ7n/Nf/6tsJPkBC8w0ZVt/1cpemqD3WB5Uzk5AxtjxrG+wzSLwKqb/PFCeNp1sgJd
         2Hn+VQtzIcGDCuLvLMSpOI0kWayUU8bjJ5Yq0kdPM60V+bfisOaVgotAAHUtL6Q16UhK
         hLWtPVNN7B4WspEdFzJBlhuAHk0L2I8crCzy8Dfz/MnLIR7EgikIKo0u8N1MH2mx3xsG
         mRGww1eR+IIpe/86xA3WwbuUSyMew1CQnq2UlW9gVrYBpHILleHWUnS3F6GwfaUg2j/H
         ZZUnjtbI1vtpphq1Uoh74PbbAIkg0xCtjQAIQAsmzeIDHcVNP39q3eoNFhve3AZSarT/
         6dMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hVq5iX14MxbW9OeHR+Lx2vN2xe59NY8+C/q94p4mUOv995JfpUaCOwodqpYmr/cVovI0VhIHsLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNVl3F9/jrbsN4t4jQPRa5W1iZuEjttzBUlRVMdA23UAIGQRw9
	wAp/B4H1zN66PdD7wH97Ekmj4cmu66eMHib3Ntcnc4WiNnNq+68TRZXt
X-Gm-Gg: Acq92OE2oOl2KAJyv2r3oDgTFR1L1JNjCXvPMVngHlD+IzKY5KRgMfZbCMjm+aptAhY
	yAOaaAYE278ButexHE75WCXPddB45RHvjuHB8i2z+MSqEoXYFkI8olDcGOsoyHDcvunMvQ4kM85
	eEc1VBPYy6mttguP6b3W6ukhllu/FtxOROhIrLbaTnQpovrEEr25GBk+sPuFNMWIDFBEWRnq5uI
	VmvlVviV+TOogbSVjUBDcEAGIsWy+Q6Fn2bQYcdK9vRlgRGk+qhEU4hIl60WL4v4ZKKcjlNO6Pn
	L6u38kCwb0ZVD0LvIAwruMY3/cxVyRB7xN/lHxgo9qJyL69pmbscWeWbHpgjFSulOXEbuP3wBuW
	FOoEiD8H8LBM5BvIcdzQXa9zYTW9BloGqO+5b8omDHfi5tH3mRPv6pQcOUjSMAKsmjm1dAjNLP7
	IH3d7G0zu1+9hUXId5SecXDMolsDS+xxYctSmtO26wjbR6Rc4V/PUsdmkSh3KPys3kBkvA5wCk8
	Fo=
X-Received: by 2002:a05:6a00:398d:b0:842:6e1f:c8fc with SMTP id d2e1a72fcca58-8434d0afeeemr4524614b3a.32.1781290386387;
        Fri, 12 Jun 2026 11:53:06 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9cfebsm2677096b3a.9.2026.06.12.11.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:53:05 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: miklos@szeredi.hu,
	csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v7 1/4] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
Date: Fri, 12 Jun 2026 11:48:37 -0700
Message-ID: <20260612184840.4058966-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260612184840.4058966-1-joannelkoong@gmail.com>
References: <20260612184840.4058966-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13702-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:miklos@szeredi.hu,m:csander@purestorage.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,purestorage.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6D4E467BDD8

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
 include/linux/io_uring/cmd.h | 25 +++++++++++++++++++------
 io_uring/rsrc.c              | 14 +++++++-------
 4 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
index 0413dcd9ef69..28300fee22bf 100644
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
index 4f6d9e652187..4036eb6be056 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1699,8 +1699,8 @@ ublk_auto_buf_register(const struct ublk_queue *ubq, struct request *req,
 {
 	int ret;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release,
-				      io->buf.auto_reg.index, issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release,
+					 io->buf.auto_reg.index, issue_flags);
 	if (ret) {
 		if (io->buf.auto_reg.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
 			ublk_auto_buf_reg_fallback(ubq, req->tag);
@@ -1906,7 +1906,7 @@ static noinline void ublk_batch_dispatch_fail(struct ublk_queue *ubq,
 		ublk_io_unlock(io);
 
 		if (index != -1)
-			io_buffer_unregister_bvec(data->cmd, index,
+			io_buffer_unregister(data->cmd, index,
 					data->issue_flags);
 	}
 
@@ -3194,8 +3194,8 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 	if (!req)
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret) {
 		ublk_put_req_ref(io, req);
 		return ret;
@@ -3226,8 +3226,8 @@ ublk_daemon_register_io_buf(struct io_uring_cmd *cmd,
 	if (!ublk_dev_support_zero_copy(ub) || !blk_rq_has_data(req))
 		return -EINVAL;
 
-	ret = io_buffer_register_bvec(cmd, req, ublk_io_release, index,
-				      issue_flags);
+	ret = io_buffer_register_request(cmd, req, ublk_io_release, index,
+					 issue_flags);
 	if (ret)
 		return ret;
 
@@ -3242,7 +3242,7 @@ static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 	if (!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY))
 		return -EINVAL;
 
-	return io_buffer_unregister_bvec(cmd, index, issue_flags);
+	return io_buffer_unregister(cmd, index, issue_flags);
 }
 
 static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_addr)
@@ -3383,7 +3383,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		goto out;
 
 	/*
-	 * io_buffer_unregister_bvec() doesn't access the ubq or io,
+	 * io_buffer_unregister() doesn't access the ubq or io,
 	 * so no need to validate the q_id, tag, or task
 	 */
 	if (_IOC_NR(cmd_op) == UBLK_IO_UNREGISTER_IO_BUF)
@@ -3450,7 +3450,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		req = ublk_fill_io_cmd(io, cmd);
 		ret = ublk_config_io_buf(ub, io, cmd, addr, &buf_idx);
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
-			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
+			io_buffer_unregister(cmd, buf_idx, issue_flags);
 		compl = ublk_need_complete_req(ub, io);
 
 		if (req_op(req) == REQ_OP_ZONE_APPEND)
@@ -3787,7 +3787,7 @@ static int ublk_batch_commit_io(struct ublk_queue *ubq,
 	}
 
 	if (buf_idx != UBLK_INVALID_BUF_IDX)
-		io_buffer_unregister_bvec(data->cmd, buf_idx, data->issue_flags);
+		io_buffer_unregister(data->cmd, buf_idx, data->issue_flags);
 	if (req_op(req) == REQ_OP_ZONE_APPEND)
 		req->__sector = ublk_batch_zone_lba(uc, elem);
 	if (compl)
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 331dcbefe72f..bbf57da1e4c8 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -91,6 +91,11 @@ struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
 bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 				 struct io_br_sel *sel, unsigned int issue_flags);
 
+int io_buffer_register_request(struct io_uring_cmd *cmd, struct request *rq,
+			       void (*release)(void *), unsigned int index,
+			       unsigned int issue_flags);
+int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
+			 unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -133,6 +138,20 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 {
 	return true;
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
@@ -182,10 +201,4 @@ static inline void io_uring_cmd_done32(struct io_uring_cmd *ioucmd, s32 ret,
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
index 8d0f2ee24e0c..40807994a8f4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1015,9 +1015,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -1076,10 +1076,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
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
@@ -1109,7 +1109,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+EXPORT_SYMBOL_GPL(io_buffer_unregister);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
 				const struct io_mapped_ubuf *imu)
-- 
2.52.0


