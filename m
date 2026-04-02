Return-Path: <io-uring+bounces-12936-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DBeBeKWzmkBowYAu9opvQ
	(envelope-from <io-uring+bounces-12936-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 18:18:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC6B38BC0C
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 18:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84E943067755
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 16:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C663E95A3;
	Thu,  2 Apr 2026 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C57/awPt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73873EC2EB
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775146183; cv=none; b=KuPLlXWzIWrhUfvvgEP+4lfzxHzA+i8CzMeFPLwn2+HBEjUmtpfZ1Evea+gA8XUlPaC0jRMu/6CqRfI0c9i3k/wXxPA5t3xfrknSfFk+b8AL8WY5CJ9f9UCGyhlmYiHtcmc1NEuGfFf2fNU3lAQGS1196eN8g81LiR6Yt9HVThI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775146183; c=relaxed/simple;
	bh=w74HoS+Zqktz+bo/NlWhkMD7kClofrlsAPPDFfvqvSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLPHibR2vqmD6VETP8xV3E+ndMzIhhjcovVAH4A27wxk+NJ2cVRH2roRvcTKTMpKcoY7EubCQnUHBGFHhkhnSjWG+vbozC6qUJdnI8yOZQfqT3LVM3Zs1hpwUXB861JLOzYeXOYcqdddKhNqlt8R2GPOlmmWIEG2W/+Ew90OkLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C57/awPt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad21f437eeso6246365ad.0
        for <io-uring@vger.kernel.org>; Thu, 02 Apr 2026 09:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775146181; x=1775750981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr0kKtOQXFs5Pj/sXTjoSleM70Z5aXusEhX2SB6KFZg=;
        b=C57/awPtXSZO+aUVi5Q98qr6mtCFccdC/jTlFhTYN+vHlzL/Z8BLzge3qkzQMvY/BB
         0qszn2oUeiW0npjQQzQay41Oj8ZXS67qSVGB1sRHD1OlXS/cQ4m3YfjcvLEp5BoS5FQ/
         QRIa9XO6yzBwfhbzjyNdQdDSBgDe54SIxh2Lce3HYLKdUpf/NAKTg4IrGv1fhsfdZovE
         9gDVPkZGoMUIdNe11HqCg4INVQZM3L8AgI7nwj69gsyYDL3bIwlXH/3zNz9oCKe84DP1
         oQEUXzKp56Lag/FqdXZ5lo7BefBz/XC7Qodtf7Mg5L3wiqoRLMJHCCo+pPNdRygTC3GE
         n9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775146181; x=1775750981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rr0kKtOQXFs5Pj/sXTjoSleM70Z5aXusEhX2SB6KFZg=;
        b=tFyjp1FGnwdmfdrqy+zVL7+Pvl6ldnAXaM1Imwppnmt84CUiqUbxZcSe/8h7TlZICA
         3QuTDq3N5oxGry3PoVn/ahXN/g4B+uAOhS+iIrdxLuIKGpSQ3HUnRX6mmMtzGnwvE11/
         yfDdL+I629dGgWmlWkBMhEVVIk+DrUqW4Tb3k9wDM7abs9xYOExUXRaWe19gZMB2McqY
         MoL69auwm/9JWzSjixvDVbVVnAfXRotFoJHDqJuj9oDydjSLn/0PDjKKQN43uQNrXtXW
         zgedRjHpQMUhV9kD/HEdD0Pgopb6FR+9tUTpaM7CiulZQ0j9gnOvMt8Jhz7uNFpw9902
         X63A==
X-Forwarded-Encrypted: i=1; AJvYcCUMi65qx7JIGS1GyM6EONHtEHFYd94cLJaKDcjUdID9riPWxNLbgouLtRd0CRYoeHVIOpHio/SRVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YymRF4PUNO0kZDBkd+TKyV2bCFeV8ZXvMvsyY0az1hhJJOTI8E+
	q/y9ISQa2TyKIh9QZi+65imBY4vYsUveTbNmWDZZqmtd+MiEDhwJg8pIj6rs3A==
X-Gm-Gg: AeBDievO7qy0JKADcXyzpytrd4+tGeP9a/lfIUDdwhHlRAk/7BOfiGig04jXkXiycSm
	Sd7XtDr7nmfLmjymDk+e0LjCSnU9QInTKxbfe9LovuWMVAS+RJZSRSKd3Oqx0+gRlVz6m3ANSo1
	nwjQRRmyDE9CWsN3KMqmH6RUIpomMeFa+39F63VBgPwwFdzGBbCgsNSpPxODyrNFKbjout5Wbgv
	vpIpVsJBNMzq0STo+EC22m4IqdU2WAkYEhdJwz8MkbE5B6KJ+2T7ggNMT7aWwzaPZrfhppzwlDq
	mquul+/Mh836vqgYYi6zOywKcoLN+cHzPwmeDbSLGI2JnUNdccgz/W6h7WxLAcc9CMlJ7zCdW8Z
	xyG8c6Xe1M0Ha6RrB2T5grdUHMENCdKkJyKge+MPoBcrEVZ+wxWtz2IZWxRIdxdjz4QAVu0nGYG
	dnslUyrzlqIluPFCqW/Q==
X-Received: by 2002:a17:902:d508:b0:2b0:51f6:d469 with SMTP id d9443c01a7336-2b277e5d247mr28300405ad.23.1775146180902;
        Thu, 02 Apr 2026 09:09:40 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274757fa7sm31817615ad.21.2026.04.02.09.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 09:09:40 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	io-uring@vger.kernel.org
Subject: [PATCH v5 1/4] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
Date: Thu,  2 Apr 2026 09:09:26 -0700
Message-ID: <20260402160929.2749744-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260402160929.2749744-1-joannelkoong@gmail.com>
References: <20260402160929.2749744-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12936-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9CC6B38BC0C
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
 include/linux/io_uring/cmd.h | 25 +++++++++++++++++++------
 io_uring/rsrc.c              | 14 +++++++-------
 4 files changed, 44 insertions(+), 31 deletions(-)

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
index 2d8be5edbbf6..ed5018c69d8d 100644
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


