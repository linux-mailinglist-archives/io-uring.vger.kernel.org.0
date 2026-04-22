Return-Path: <io-uring+bounces-13127-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDuwOijv6GkdRwIAu9opvQ
	(envelope-from <io-uring+bounces-13127-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 17:54:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC95A448273
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 17:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E29263014889
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 15:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9E436F427;
	Wed, 22 Apr 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sDoee2vF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13148351C21
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776873249; cv=none; b=DttzSCI/rX3Mtr9QnMlj1NClEl5JNqNSiFObyrJNw0aN7TJDkhQzhgUq7ktBMBStHIy31htwpYin4SLlonYAMsDO8POAGF7nFnV3wMEXrr13KSyyZbXLSaOm6uM/1e96dbHuE9zSZiELq4ZRlERScdpso+y8JJG8gOGo6a11Lbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776873249; c=relaxed/simple;
	bh=chz0KLfckL0pVVlDTYqB5/Vp6ANh7y0usPSuATngaPA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=o12EpfJcmIFjqIl8UTl1RjBwde6yQbkUlAJs1V2pC29JFHUPPhJ4zs00HBGL2+autACI3sAqSYTjHvzWFkBCHI0zKFc0xW1V1dX0HWUQoaCG9Tyl8AEnre4/vFI7TeKIAj1zELlNOUhyz40pnxQLg90Kx52ZzCQHpC3lxWJVvyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sDoee2vF; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-66bf6fe1211so495043a12.0
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 08:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776873245; x=1777478045; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xYtCgCBSrJ171ZZx5YpgZR8oV4HLoKU+fvgbBYIH/A=;
        b=sDoee2vFt+loZjPVicWVQ8vvilrMCeE2eHW4Dj1H2ggz0T9oFTJbMvF2jKa6PdNJz/
         HlXlXJwUVY9cvExQXXDQ9fYnphnQLtJN4BFBl1PRJsv/nlbOWrqYRXp0ZbuZszpRWBZr
         VYzILXdtcXL6JTJQlvj3badhmroynC0D1NuCWYPtcGfAJjw5vKutacKP2kTJa6xFZpFQ
         ez1ccNgrTffPq8bAWU0Gxnav69fFd5qHg3FVGe1sOzXH8AMq8P5HyldobgZJrR5DkUOJ
         lEUWvPvneZXU0e3t1wO1kG3dPdnCHJstbEakg9T6hKm39bapzqzHKV1Eik9nl2nzl1oc
         7ILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776873245; x=1777478045;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xYtCgCBSrJ171ZZx5YpgZR8oV4HLoKU+fvgbBYIH/A=;
        b=bc5R/N5vFYcz7JpNAQE9DIvHXmEKNauzUwKlzieTFaqxvM5EzOr26vu9B7ANQC1zEK
         M6gBbEwLxVmeyWfJGPGfButGUS/R5OhGwERvC6JtXP1F5FM8J/8BtktPmV/FL8QlJkEM
         AlCCyAF7GALswAZAtas3xskEkk63Ht8Ml6CXVDNjpQOl7O+MVNTcT2touQrjm4SRazFa
         H0clIu/BA0vbW6H03tRzDpAle8JNoucc/Rr1/XoyL+UxRQU5duqZ+ClZfc1YT/LWwBVV
         ULxKBI8gleEBOF5TX3u0RjkJnj7Bj4SONT3MCa789XODjueC2+a6RlwwHF+ZFo5Id3hN
         luyA==
X-Gm-Message-State: AOJu0YxUI0Ugjo7oOVLwSCR+YU+2UybXSvQM7mJ+8/DS88R5Vg+DYBsQ
	nJ8cNnv25VpivEhzmaY1VYTHbhCs5EAR5NF8DmfGqwB6X6BXR/UtKwpTTQ+/1P6r
X-Gm-Gg: AeBDiesYFAtyhw6HLiTCq3LJ/zYQg8xNIrCfrFj3w9p42jkUAYuOJo/pgdFHgzSrNhv
	NDzpGIrzziGtlxmaRtdNlxFiJnkfrXEVUeoqtfS4zRjXS1M58092mHOa49g+du6J5Uxaanv6dI5
	B8mChFfZ32THOQz/Nl0sjf4rDQGw3fFeniY6wq1tO/1lUb5vxtChyJdzoodE+jb4q7DGtfOkVOI
	TlaYLsSqnNA3rfxnfqJIiD962a1/LLtydIX/mis0sUALbK+er3F+hvOrtLrD/JcxqUqTOMnaX+H
	uD9uBYm8J0/OPlwqET+UERRCKbCHrQDwcZHrePQ7EuOSK/k1Y+yBcDAPQt1sMT3Cd+d/Y4lJnBK
	AtzeetsJLiWthGFGsYIMKfUdPaM+XnDfdw86PTUD1W2ALBYk6Glhlcjt41KFZo8ur3mzq1W4R8G
	BOedWGjLXVPWX0wItzOTi3tY6l/hIOx4Ar0CODFNlxpQavFJnT5INrsH3SFQ==
X-Received: by 2002:a05:6402:1cc1:b0:670:8ccd:704a with SMTP id 4fb4d7f45d1cf-672bfeda823mr4709355a12.5.1776873244793;
        Wed, 22 Apr 2026 08:54:04 -0700 (PDT)
Received: from [192.168.168.223] ([182.176.170.188])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-672c4d50922sm3295274a12.21.2026.04.22.08.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 08:54:04 -0700 (PDT)
From: Ali Raza <elirazamumtaz@gmail.com>
Date: Wed, 22 Apr 2026 20:53:05 +0500
Subject: [PATCH] io_uring: fix missing submitter_task ownership check in
 bpf_io_reg()
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260422-master-v1-1-e82f47558345@gmail.com>
X-B4-Tracking: v=1; b=H4sIAODu6GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMj3dzE4pLUIt0US7O0VINUi6Qk42QloOKCotS0zAqwQdGxEH5xaVJ
 WanIJSLdSbS0AA73dz2oAAAA=
X-Change-ID: 20260422-master-d96fe0e8bb3c
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, Ali Raza <elirazamumtaz@gmail.com>, 
 Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13127-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[elirazamumtaz@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EC95A448273
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

bpf_io_reg() installs a BPF struct_ops loop_step on any io_uring ring
the caller holds a file descriptor for.  io_uring_ctx_get_file() only
validates that the fd resolves to an io_uring file; it does not verify
the caller has authority over the ring's submitter_task.

A parallel path in io_uring_register() already enforces this:

    if (ctx->submitter_task && ctx->submitter_task != current)
        return -EEXIST;  /* register.c:733 */

Without the equivalent check in bpf_io_reg(), a local user with
CAP_PERFMON can exploit IORING_SETUP_R_DISABLED -- which defers
submitter_task assignment until IORING_REGISTER_ENABLE_RINGS -- to
install a loop_step on a ring before a more-privileged process becomes
its submitter_task.  The loop_step then executes in the privileged
process's task context and can issue arbitrary io_uring operations
(IORING_OP_WRITE, IORING_OP_READ, IORING_OP_SPLICE) against that
process's open file table.  This provides a cross-privilege io_uring
execution primitive that can serve as a component in a privilege
escalation chain when combined with a vector that induces a privileged
process to adopt an attacker-controlled ring.

Affected: v7.1-rc1+ with CONFIG_IO_URING_BPF_OPS=y.
Requires: IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SINGLE_ISSUER.

Add the ownership check in io_install_bpf(), which is called under
uring_lock, matching the locking context of the register.c check.

Signed-off-by: Ali Raza <elirazamumtaz@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf-ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 937e48bef40b..cac11c929297 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -162,6 +162,8 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
 		return -EOPNOTSUPP;
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EOPNOTSUPP;
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EPERM;
 
 	if (ctx->bpf_ops)
 		return -EBUSY;

---
base-commit: bea8d77e45a8b77f2beca1affc9aa7ed28f39b17
change-id: 20260422-master-d96fe0e8bb3c

Best regards,
--  
Ali Raza <elirazamumtaz@gmail.com>


