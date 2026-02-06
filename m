Return-Path: <io-uring+bounces-12086-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOwCJ/RjhmmYMgQAu9opvQ
	(envelope-from <io-uring+bounces-12086-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 22:58:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B401039CD
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 22:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E43473013ED6
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 21:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D793128C6;
	Fri,  6 Feb 2026 21:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YmCMXJoM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f228.google.com (mail-dy1-f228.google.com [74.125.82.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB57A30E858
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 21:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770415089; cv=none; b=QI0amOa/ycsoEdbMLHkLzJC6OlPiL4LG04nT9QjC41YW3nbup0InlaBea3Hbqn+s0fewJC5Qox5Ig61bKCUEYyTCNaethyqLuIGUS545sDB2QqGLIJR2nvJ7msJZmauJ7NVrMEhtNdX7UW55mZy03CxXElvRJJNiENMI+Qn92sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770415089; c=relaxed/simple;
	bh=YQhVmDwez2F4WBxYw0HKce+xrh2MBzNfIgBrxHJgTXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lkuq2hCN89wuOKdYl/OTohdRVBdy9R0fw16HhoP9wOqQzF6y/JSFfm/J8M+HiBdlfaaH/YVpKCo2kivpX4GbU6EuieIOd7wUhA99x2AEcfKt8qDCHfrw0lISuGXEyQz+p/jMNyhNvK3PT/hQPnTdmOhb12ubSxj78k7DFHJ21WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YmCMXJoM; arc=none smtp.client-ip=74.125.82.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dy1-f228.google.com with SMTP id 5a478bee46e88-2b867142b07so44412eec.0
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 13:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770415089; x=1771019889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iRTAskpVWcpE1JTBduaT0XNtGXYotQNdR4rRO6QLXL0=;
        b=YmCMXJoMJm9CpkLD3Z2O8iJQnJwFmBdRT8emw0wtXYb3DQTagzvcPgfQWGOoR0xckd
         YIAVF3Sw2PJ9A2TrcvHjD4a/C2NzoDeLDahDLPHNsQugbDDBslrdyLr7djLO9NLm8EUc
         A2vUD3CL4NYfAEE353nAmG0R5BF5Kli8PDzhzQt1up4VelIn0D57qgHRg3kDPhlfSHzs
         kW9TdbMWxLJSI/G0nhqDh8ZayY0J4XMiGByQGXzStUzV/Wkip543p3IEzuhekDODu497
         Gv6trwuUwD71gj0KktIzby1gUf1QsNCPKcNlSstrxcCIYDHdXhgz7SEVxTkhcUiqXVF9
         5hkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770415089; x=1771019889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRTAskpVWcpE1JTBduaT0XNtGXYotQNdR4rRO6QLXL0=;
        b=dP5DddF8XKp0mtYagoOnFZIcD5PukDeh23bafhB1h7hX5PnpUrdevFws/jCzuhEWMV
         tXV4knCu/XMKtSBrtetWgz8WjCSyuOQdMV9jA+BBe5hryF5Mh+DG29i+YknwMiH3doDE
         Hsur4Zk/3Z4QfofgzcBuT66knetHaSf0CfYmgucE402CP3gcSm4b2Y6epGVpv7JrIYEy
         YuBFhSKq4Ch/yMzYu/f6M2GRnk56SglgWwAPtCmN5xCmwElIwGWLt4Fvht9BGQTSSK4U
         nGsIMzHS8w2zVmN4LVZekgU12+jFbt4cj8Q3TpQ4zHBSO6lH3ys8z1bXfAZf7NMohw5M
         ChXA==
X-Forwarded-Encrypted: i=1; AJvYcCUgFZHL0ozTQLbcEZo70Es4o+iiiv7IAOFaMmopUXIud5PhtReARrbow5Tf5UOAdmJ2in3cjdXgUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8jO3h6NxNTAo9czRR5bUQs2SfmVFNBp/7gKrN1pG31469GCwF
	btZGZkhG8ni8/CNoaaV2VvyupuzdYOwVzjP23yln8YFfz6OYqnvXlZ/PvSWLjJYLHBZxOYz+Y19
	3hzmcJSwSM88IAY6ddFU8UJ6fFt7yuqdkrL9w
X-Gm-Gg: AZuq6aJd8Wep8uOOyTinmrrVnE1dYDzSot2ipxYqg8pVfubkkR3iBudnb2jKYF8deqD
	XQct+JZ3eECaxiQ0yALiZuAk8Ld5B+Ar7vyUc6ED0/ZLNiFIyqLrSzKjZfawJTpe2y+KfYfHhRn
	B1lblB0o0hRvQGOCZl6k6S4APzxmkP2d1yXGhNsAWeOpbSwIZPeRA0Fr7HTErAxEP0T3NTbjiWa
	Cxyq7YAVdVYts4yk9EO2bcJLq6Q2PUb3mKdfQalinAYh+FLhBsx6/0D68rana/vZXcs4MnMFCaA
	fwQgyrQ9nWnCv9rw68Zk3Q+3j32ILw1JBbbnjNw6MwUMV0Van7fQNHkUzKJJVBI8QLzs/EDBP84
	nXrFZEKMdzvj+TEKkqfjcJilPHKFkK0iWzZcBVZxX/A==
X-Received: by 2002:a05:7300:4353:b0:2ae:5b8c:324a with SMTP id 5a478bee46e88-2b8564e211fmr1030688eec.4.1770415088653;
        Fri, 06 Feb 2026 13:58:08 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-12704341962sm848306c88.7.2026.02.06.13.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 13:58:08 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8B7A53400F3;
	Fri,  6 Feb 2026 14:58:07 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7640BE41AEB; Fri,  6 Feb 2026 14:58:07 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: simplify IORING_SETUP_DEFER_TASKRUN && !SQPOLL check
Date: Fri,  6 Feb 2026 14:58:04 -0700
Message-ID: <20260206215806.1637548-1-csander@purestorage.com>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	TAGGED_FROM(0.00)[bounces-12086-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.998];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 15B401039CD
X-Rspamd-Action: no action

io_uring_sanitise_params() already rejects flags that include both
IORING_SETUP_SQPOLL and IORING_SETUP_DEFER_TASKRUN. So it's unnecessary
to check IORING_SETUP_SQPOLL in io_uring_create() when
IORING_SETUP_DEFER_TASKRUN has already been checked. Drop the
!(ctx->flags & IORING_SETUP_SQPOLL) check for the task_complete case.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5c503a3f6ecc..8949e6d7400a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2901,12 +2901,11 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		static_branch_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
-	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
-	    !(ctx->flags & IORING_SETUP_SQPOLL))
+	    !(ctx->flags & IORING_SETUP_IOPOLL))
 		ctx->task_complete = true;
 
 	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL))
 		ctx->lockless_cq = true;
 
-- 
2.45.2


