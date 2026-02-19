Return-Path: <io-uring+bounces-12320-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YVSiJAZplmnBewIAu9opvQ
	(envelope-from <io-uring+bounces-12320-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:36:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 057E515B611
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 46C4C301D4D1
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 01:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070FD1EEA49;
	Thu, 19 Feb 2026 01:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Iwj0GP0H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0761EEB3
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 01:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771464962; cv=none; b=oJwOXvvMWDn/ozvxu3MkEm1o0rR+NHqq6iFHorPkvlSzkXFjUSQblYFSHy2zex/Pdu/h7F8NaikRTHpq4HRu0OF5tjzOtXDJWoruhJYF3pkQ/ZHXOSxWEiY3giHDPRavRRlb/SX7XbzBZn7sDPuIN+wtTtNFXiowCtZCP1HgAEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771464962; c=relaxed/simple;
	bh=SK7lNVVt3R3qPwh5gNARbgazIAbuys8j5HASsZvezDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e/gUZw8UOg4UbqxatVHXF7TkExb1r8ADB0fsDgglOv2QFuaeT9w1C90EYUSQ5NseITVG6SyF4+mnBpEicupnDNW8EEXg790XUWIBEDQfBwklEjEwYTfh8B4MuctK8qkiXTkdEcanLb51AkX0RGEovd1X1GYiy+KHHuK12cpTE/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Iwj0GP0H; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-c6e18da0f82so41098a12.2
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771464960; x=1772069760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XrpUavd9Jn1m5PTul6V14FFmKgASSL32mDcwIWu9GWA=;
        b=Iwj0GP0HElzidBP+a3etf5yOBEIlyQzzOqMlYEozmRz34lPo/hALyb/Hk0RU32fp0s
         ozpb4KP8l812MA6aHSzmrST0/PR+2RTxpLmSFzx5P9ncsdwjlOofAwCfyy5tMzRiAnPD
         Y/tyn/30agVjyeINtR8+TJOuk0gO57KwMPJWkST8FacDKvBt+gwvJ0f5oSgHXfjx0FpC
         4P8MBBDZ/99cX1RCTP/8w7jpMJIyx++H8O1dRbZWROgpYDjA4m3baVxgnxTWO8ay+hXM
         7thWTWLO9k81+/R/MoPVIfWp5Ih/7NxgtJDemXB/WCwnI40t2C8oHbA/FLqI25B4FfAp
         W4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771464960; x=1772069760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrpUavd9Jn1m5PTul6V14FFmKgASSL32mDcwIWu9GWA=;
        b=hVIZJEtBz1+EDHNwxsjKqK7plnA/ZpSQrmdKHpN9d+seC+GMnZ21ZwNZfOJTCMiAC/
         qWzjLcI+LMkvWxS8iUnbohp742+BlPYLlSdpy9f8TgAMSxsfSae2S7S+i9ez8THWM3xt
         GaCtl5BlYgrV4VWTuUM2nULN59rpxChlCROmF8YomTo5nxKOFyw0jYkqAQjP1g3480IL
         orDIIxwNvCI+vjCj4skyuSqZgWdxMDxu08ZaICjpJXx3wgXdqfw662seuWPMewC9Ktq2
         wDpD+KtFDPlh+gmsSfJUxqG2/Xla3ejy6s0rC1CzTSueOiWQ6AdyBH+Hvn3VA0pwPNQi
         mTvg==
X-Gm-Message-State: AOJu0YxNQN9pf7vsceI1auALGvkQcOVGU/+Ub5DbJchKbIsstsbf8IJQ
	89ZGK8PJMijvSzWuA0/1GZXd7rPcgZf2LCdOjvmUHQq3U+S3+Ok0CZRT6+rbMQl3VuwTHmc3utr
	l0WhSrv9vQU+jIe+5X351e+nuQznr9YkKrZNMqtGkpf9oVOJ2LYkq
X-Gm-Gg: AZuq6aL48fzRz2aYxsnCGaWSmDMHzXEZMqzwMrRAk1NNAAYSOO8bi4qGx2wn9RLUUaX
	GWXBVqd6q31cusX8uR35m2Q3yQAk5ioTR4QKrFCldie1/4aT9yaL2axT11V9JOXs37PSWNmgAqG
	oNhCQXi8jFyirr9ZTk5Re91oXamUx0oIYoHhRt8ZDyhGCOB8aHEK9TTJGtxXiyIW5uIeOhDYASz
	abZsK6zzRpfaeq+4QysWSF7MxP7UJWt2rZP+2MRAyDtXG6zUgUwZbW/4DOERwx/8zLlEtJchAaz
	3/Nosvw9DAXTQJDJixpFmxHaMo4a+LN4YNwK7BK/VZsr+C5xzJGTPv2nNJtnawm3c9qt35VbGgJ
	VBIWBL+1GT/6uOOrDfajc9xkqDO2q8yD+9GcH0Dw=
X-Received: by 2002:a05:6a00:1142:b0:823:c646:28c8 with SMTP id d2e1a72fcca58-824c5ec6f49mr13730751b3a.1.1771464960045;
        Wed, 18 Feb 2026 17:36:00 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-824c68f0dafsm2093732b3a.0.2026.02.18.17.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:36:00 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2224F34014B;
	Wed, 18 Feb 2026 18:35:59 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 1399DE41D2F; Wed, 18 Feb 2026 18:35:59 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH] io_uring: add IORING_OP_URING_CMD128 to opcode checks
Date: Wed, 18 Feb 2026 18:35:34 -0700
Message-ID: <20260219013534.4140776-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12320-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 057E515B611
X-Rspamd-Action: no action

io_should_commit(), io_uring_classic_poll(), and io_do_iopoll() compare
struct io_kiocb's opcode against IORING_OP_URING_CMD to implement
special treatment for uring_cmds. The recently added opcode
IORING_OP_URING_CMD128 is meant to be equivalent to IORING_OP_URING_CMD,
so treat it the same way in these functions.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.h | 6 ++++++
 io_uring/kbuf.c     | 2 +-
 io_uring/rw.c       | 4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 503663d6fd6d..0fa844faf287 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -528,10 +528,16 @@ static inline bool io_file_can_poll(struct io_kiocb *req)
 		return true;
 	}
 	return false;
 }
 
+static inline bool io_is_uring_cmd(const struct io_kiocb *req)
+{
+	return req->opcode == IORING_OP_URING_CMD ||
+	       req->opcode == IORING_OP_URING_CMD128;
+}
+
 static inline ktime_t io_get_time(struct io_ring_ctx *ctx)
 {
 	if (ctx->clockid == CLOCK_MONOTONIC)
 		return ktime_get();
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 67d4fe576473..dae5b4ab3819 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -169,11 +169,11 @@ static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
 	*/
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return true;
 
 	/* uring_cmd commits kbuf upfront, no need to auto-commit */
-	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
+	if (!io_file_can_poll(req) && !io_is_uring_cmd(req))
 		return true;
 	return false;
 }
 
 static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index b3971171c342..1a5f262734e8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1252,11 +1252,11 @@ void io_rw_fail(struct io_kiocb *req)
 static int io_uring_classic_poll(struct io_kiocb *req, struct io_comp_batch *iob,
 				unsigned int poll_flags)
 {
 	struct file *file = req->file;
 
-	if (req->opcode == IORING_OP_URING_CMD) {
+	if (io_is_uring_cmd(req)) {
 		struct io_uring_cmd *ioucmd;
 
 		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 		return file->f_op->uring_cmd_iopoll(ioucmd, iob, poll_flags);
 	} else {
@@ -1378,11 +1378,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 		list_del(&req->iopoll_node);
 		wq_list_add_tail(&req->comp_list, &ctx->submit_state.compl_reqs);
 		nr_events++;
 		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
-		if (req->opcode != IORING_OP_URING_CMD)
+		if (!io_is_uring_cmd(req))
 			io_req_rw_cleanup(req, 0);
 	}
 	if (nr_events)
 		__io_submit_flush_completions(ctx);
 	return nr_events;
-- 
2.45.2


