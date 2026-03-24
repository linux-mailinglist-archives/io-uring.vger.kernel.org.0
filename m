Return-Path: <io-uring+bounces-12837-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yARbAInXwmllmgQAu9opvQ
	(envelope-from <io-uring+bounces-12837-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:27:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D47D31ACF7
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 19:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA9A73065F43
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 18:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC2339657B;
	Tue, 24 Mar 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7UPnntr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42573A3808
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376544; cv=none; b=Mpm2KMTrhtqUk0TrCAOh/j/Sa8/V2S97bincQyQSFIEzOc/eRPgA4Y/2YoFXSr9XI+OW2mUOudvoibM7ELm3V31+45MImA9TEwMnMrK9BctTPjqc1mhF1beVfcaxJW1Ncpz/eIqXq8rV0QC+ZVMOUI7iddIPeHGZA7kr3NoWyq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376544; c=relaxed/simple;
	bh=TV+F0Vmu4aucF2TjbdbBnNT6guv3JixSxcykzZJgmzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3r2yYLpHI6Xk/FnD9rzFTGeS5sDO5yTQ60D1VYZ37YHL9drQgcHd/StT223/JPYEEySDOhx8YJQYr1+vB2p6UTJTm5lA5rf0ZoP9JhtEDwk2OtokhLEoE4Y2Z1fdTBpcAnNk59xwPmgXIBf/t1lt9AGu+5rOo9DpRI96UwSn7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7UPnntr; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c2af7d09533so3620738a12.1
        for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774376543; x=1774981343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AA5SRQ15WYXOghQfJ9ddPjPi0IIDAvudWjjHvBxa7xM=;
        b=d7UPnntr8TTstXamWvICjRomHHvr0INGhqj+uCAXqULPdPMCFC20M1WLTq1OdDPxzN
         cDRwrD3Rjb3/MD8uVLj0rniaAsghL/gXHBBuBn/6GlwSHl949Y1gePA561KF7dGxd6ZR
         I6GnFRrB4U56qRiNZcb1qM8yPWHxMHeoUTF9lpXQvMncL6DxRlyn/8qMrkDcNNoSY5Qh
         qg6zKqpYpkZHZF8+Q+V/21aSiU/2JEi99W5/rTRxcbh+211alHVO5laQgoQKv63zVJez
         5Mhl3xBGF+NdC7q6o4WEma8f+RCBsgJCviMBQpvEB1RrEzmerjE9dCoh4wf7g27uUSq6
         OvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774376543; x=1774981343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AA5SRQ15WYXOghQfJ9ddPjPi0IIDAvudWjjHvBxa7xM=;
        b=GjK4eAou5L0Ffr28P6c/A6AymUqS0lcmsBNmWsn/4E5OG8iDXBgRI1p3sqkjG39lP+
         LNddQRNovgSfZgZce8loDRVbS0XULx2r3VtATB/JDmTConna1nfZIWzW4tIgCiycfGpm
         EJ05wKyC/B025YKidLSF3HuM2HYgEPL+ezDIbPhZ9vy8ZMlTU5AHnCBcukM5j4D80wIu
         KdrUwXzK42dcjYkbuvWeemw1cKMeYupal+PETYhjiZQe/EhT54Wp69o5at1wqdMtIyxQ
         gQ8quX+wcJ1amYOOxgrfKN/jandC4UG9EIJNXdfj6P+QuDyc3178YB8LjjD+xHNr/0M/
         OBDA==
X-Forwarded-Encrypted: i=1; AJvYcCVUI1dqoHSUw6ZmN531RRBbdZaaf6xACiTdmTm63Tus5cGWTRE5GdhpfuTUDLHIsFPmrRA9Fb82DQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuNCXZgY4dnLaGq+bzx1WR4BNVUTV0HrOnGQYEnxwEUOASjXVR
	86AaSqTTHah7PErM1vESCOSfQ0EAlUzcX1zJbWc8i5oQvalHueCz1cee
X-Gm-Gg: ATEYQzwemsN6dgT/nqhWuF4CAz+P6dLhZkH5V1FuvSGV7vH+JgnoZGingzX3YKQNHd/
	AWxpReP3H0C8JcLbPG/QJ2RxE+GJmbjSXVQVwgfsAKUASYwaUSYF4kTaGcNSg5pdl7lqIL2lwUj
	gpwtczermWG2hX3S3LEDBIQ9ammqt6u9uSYy3PMgTFi3ivXQi1Mu4mCQida5VCzlHFvS4IgHTEt
	cS4n0jd/FSopE95A3mAd8x/qF9H15hpD1D128p/FHGHhBKRxcRdSTeAFiAR7stPVZYXaFU8pbJv
	8G2Sb/ohdDGJbTeGtgDTo5VRfcWOAyGLA03m/OvU1L113aSRdSndxhi2fxXrkf2cyu5LgoBZJ6W
	SUMBZO6RGfoiGH7juqdNIDA/rpJvFZnH9JEZMKLYmqz+d4uZv+3ciVnpYAK8LSlLPTLAtVEVJiW
	6is8XgpEydyIdJdpQd
X-Received: by 2002:a05:6a20:2589:b0:39b:9644:6ea5 with SMTP id adf61e73a8af0-39c4ac6ee13mr770972637.15.1774376543177;
        Tue, 24 Mar 2026 11:22:23 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc2a8sm10849205a12.27.2026.03.24.11.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 11:22:22 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v2 3/5] io_uring/rsrc: allow buffer release callback to be optional
Date: Tue, 24 Mar 2026 11:21:55 -0700
Message-ID: <20260324182157.990864-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324182157.990864-1-joannelkoong@gmail.com>
References: <20260324182157.990864-1-joannelkoong@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12837-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 6D47D31ACF7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which does not need a release callback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 01c3619e5f07..73ee03f85509 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -133,7 +133,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	imu->release(imu->priv);
+	if (imu->release)
+		imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
 
-- 
2.52.0


