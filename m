Return-Path: <io-uring+bounces-13922-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id +RKMNMwbT2rKagIAu9opvQ
	(envelope-from <io-uring+bounces-13922-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Jul 2026 05:55:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBA072C76C
	for <lists+io-uring@lfdr.de>; Thu, 09 Jul 2026 05:55:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JTyf3ov4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13922-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13922-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4BD23005D1E
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2026 03:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484B41A681B;
	Thu,  9 Jul 2026 03:51:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F113603D7
	for <io-uring@vger.kernel.org>; Thu,  9 Jul 2026 03:51:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783569111; cv=none; b=Y49qOvKV/Wm1KRP+9ixg+xAqXjT6VJEZCY6bWaBiFR2JoJWJxhbfner77IquLu0vzmBG1CNMJY/5OsoHlvw59mL742nhEHomMDDWE1Wbn4si5sHCnSLQpRyfPU7Kgf0jCtsvYDgQOdMe4a16apUn93kXvyEIFYZhB25P+AJDxl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783569111; c=relaxed/simple;
	bh=F4bTmw3Ia8pqiZ9/QREErdk8NjhbpYg78rNe7xKGM0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=af6vOb6oEGinZANDw2ZOog02upZbhFS1OgB+yeJGPtpKDWosTZxiZTHFEBY67ieI/deJj9ocrIAulWHNlCfZW4ZstNzpDUPSmEgXvrX5KL4RHxAO8dBvrwy89Cv5UPKsHxUoXJ5BuUm7gfIjm0oyfInLqRlsOTVrDNQL++sp4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTyf3ov4; arc=none smtp.client-ip=209.85.215.182
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c8b49639fbaso333528a12.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2026 20:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783569109; x=1784173909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ADWepV0a44l5gT9v6C8qAvveUNdTZ8pec6JfMV9nv1c=;
        b=JTyf3ov4vNbeeSD0dA7m2jTqHdzVqCGhIoFQ8GnOwYcRGt1dZnbmpjpKjYi7cAwjeB
         feHmY4YQW1+brZKFWRLedSqSlFnznf9f2yvux9LlgpPZdzYSDz6Q2dYt8Pjit5e+JfF7
         CqLN+NyWx0Lu/uCt1uOhg/GfcfkvhlFW1fmnpr7t3xNH/nKtrV52G2jlMZ8ITEpO5uzf
         NJwYH9Lh4jp37DTgRTcdpwGfo3a0EDylL8lEXB/scB3JEeuBYyPZhBo9zfgHJ17L76g0
         MjtkgKydXRvJeOChOYjOBT6/BuhUWQiQ25f2TfXHRcxK/Hq64LAiELk4GV1Uf0EH+pIM
         x2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783569109; x=1784173909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ADWepV0a44l5gT9v6C8qAvveUNdTZ8pec6JfMV9nv1c=;
        b=eBWjfjNIWkKkbLa5/B+yW/Rmrdr/v7eaexAuFc4/sv024fwgNLK8PMpb+4PPN1woYo
         dquGdf6a/5GQMTMhcP0nHp0nq0p0jmGGPFAz7BPa11skP2VW85b4Xr3O0sl0S9FSKH5h
         YXZp9eq0UCRg57KRdgEXki8XIi4MDUKUNp4mIkeGHNikarO7c87rxOAyR2I715X48j1/
         mflXT9yCYZUF2sRUTAZBacq5XOGxgqhItHNbxXTO4ICm0fJr2QHpfTOG6comiO3vyizQ
         mjNs+TeRkZPpNgMRz6NB18BIMeC9s/oq+QcqHCL9PpYPsTq2GNDE82Pz02IVY2p7CEb0
         hZZg==
X-Gm-Message-State: AOJu0YxZF/0tkln5vIQRwPT2FN0LgLrcXCjP9PH4hmEVEPftHygeB5b+
	XGVgyBPegX71S6ydoe6VWfiFtdbHcGVxlNI3VJmAuXVCJmu5GuqgbhBzT89xLqr2
X-Gm-Gg: AfdE7clWNrnDdaEynAiukzcmAFN6GoHtA6z6CggzX4ddnvdfAADFzdJXHoi6ydyRFBN
	EMaqCEQlkLif7nWWbUuruU2Nwo5FvTFqzGiSy+rK/eOoH0+0Z3nkHSueTIInUA9KGOEc6ekGltR
	vASpE1RB6qI+qwOsVYCDaWek/lSCWdQxfTOzwnex4Gq88qhW1DyeYxBPeZ8lBH8w0oBCmM+6ZLe
	L2Jxx6164A0t9hN4g7REdxVzhywqZdPpNljx36HTnvQ9KP8rQoTHEJsommevGMp1OjysDXDjEeu
	2UgxqIvhpQzh4l/QN7kg3+3XCzDULtkkEo5LuDhdiyKhMB/woF92r21JX+BkhlQxaMqowGbOqO3
	HMQrL85Ri3LimgQF5GDuXCeDGMnyEgzUi2iyJvYp013RTN/YLyOnblb6W2VRw0JP/1taoQLJn+y
	CErwRYcvFBGjf0CZDhpeWGzD4ExbqKYeZ8IgTwEH83Hn8cynjdjTD2YFZhCil8eitqM3b1hgveQ
	NmgRSH+tP7TLfI=
X-Received: by 2002:a05:6a20:d493:b0:3bf:7110:9949 with SMTP id adf61e73a8af0-3c0bcbe9106mr6684221637.6.1783569109026;
        Wed, 08 Jul 2026 20:51:49 -0700 (PDT)
Received: from DESKTOP-4AJO944.tail156a05.ts.net (ppp-223-24-194-101.revip6.asianet.co.th. [223.24.194.101])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174ac14f2sm27056633eec.27.2026.07.08.20.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 20:51:48 -0700 (PDT)
From: Woraphat Khiaodaeng <worapat.kd2@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dev>,
	Woraphat Khiaodaeng <worapat.kd2@gmail.com>
Subject: [PATCH] io_uring: restore RCU read section in io_req_local_work_add()
Date: Thu,  9 Jul 2026 10:51:00 +0700
Message-ID: <20260709035100.2269-1-worapat.kd2@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dev,gmail.com];
	FORGED_SENDER(0.00)[worapatkd2@gmail.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13922-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dev,m:worapat.kd2@gmail.com,m:worapatkd2@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[worapatkd2@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2DBA072C76C

The task-work refactor that moved io_req_local_work_add() out of
io_uring.c into the new io_uring/tw.c dropped the whole-body guard(rcu)()
that used to cover the function body.

For DEFER_TASKRUN rings the ring teardown still relies on that RCU read
section pairing with its grace period:

	/* pairs with RCU read section in io_req_local_work_add() */
	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
		synchronize_rcu();
	io_ring_ctx_free(ctx);

io_req_local_work_add() keeps dereferencing ctx after mpscq_push() has
published the request to the work list (ctx->cq_wait_nr, and
ctx->submitter_task in the final wake_up_state()), without holding a ctx
reference across that window. The RCU read section was the only thing
guaranteeing an in-flight adder had finished touching ctx before
io_ring_ctx_free() ran; synchronize_rcu() only waits for readers that
are actually inside an RCU read-side critical section. With the guard
gone the grace period no longer pairs with anything on the add side, so
ctx can be freed and reused while io_req_local_work_add() is still using
it.

Restore the guard(rcu)() over the function body, matching the teardown
pairing and the pre-refactor code (the guard was present when the
function still lived in io_uring.c in v6.12).

Fixes: d46ab2c98aba ("io_uring: switch local task_work to a mpscq")
Signed-off-by: Woraphat Khiaodaeng <worapat.kd2@gmail.com>
---
 io_uring/tw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/tw.c b/io_uring/tw.c
index a4c872870..4f7a0d107 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -153,6 +153,9 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	int nr_wait;
 
+	/* pairs with synchronize_rcu() in io_ring_exit_work() */
+	guard(rcu)();
+
 	/*
 	 * We don't know how many requests there are in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
-- 
2.43.0


