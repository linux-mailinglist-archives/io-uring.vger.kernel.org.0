Return-Path: <io-uring+bounces-13270-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EF7+JAsgAmrAoAEAu9opvQ
	(envelope-from <io-uring+bounces-13270-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:29:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DEDB514785
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 20:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D78F0305BFAA
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 18:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CD247A0CB;
	Mon, 11 May 2026 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="CrHcmIX3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE6E47AF75
	for <io-uring@vger.kernel.org>; Mon, 11 May 2026 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523748; cv=none; b=lppRn+UeFVRaQE5Ylx+CnjB6C1d5QAHGONY9B3YCG0lwsuwcPxA0Icjou/sKDtkdecmmDQCf8lekMA54wknACXoPh1ASIbUO9CXaQZzARCKav23Km7G7SK6M34Zk9g01fItLxSj/1XKALFDNy9Oc5poYwU1BOdeZjl5Oxjr7JVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523748; c=relaxed/simple;
	bh=jvySFlbAFqKkpm6JGnPoXSDVjVnDYJKmwyy1reCFN2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF4gsNnJ5UVbn/lqpjpm2r5OdIhlrfO6psIwMlPaDJc9nekS45kEZlQVGnLJ8EnxAw9DxCWWZs6Osa0N6VuYb1FLiKyUguZqiaVKrqvRtIGXD4kpY5jLwpz7p2LV4E8mL0gAaUKS8o7aclP7b2PcG2Ehw1p2CJ/A2p6ldQK/b4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=CrHcmIX3; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-464bba3a9easo2449600b6e.0
        for <io-uring@vger.kernel.org>; Mon, 11 May 2026 11:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778523746; x=1779128546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVn4DCFizARj1qN9OzthSmEsUdbqwYJVtmJ8VKsvkHQ=;
        b=CrHcmIX3g96x76/I8w35RpZf43jKXQ10EYQT+4ZdfPxFu8+wwyX4PwgHhqibPbMPac
         8z4QGXKE0CANcePKNpeapcEUqEpm0UN5+b6vuoj8zIEvRV7pc9PLw5/A4fm9eguUgBly
         46dE0SESmDYBGqi9erqEOty3sGurMpMIQgJ646SaI7kXYjNUgjBnfR4ZBoD9ugPanSkx
         3IEcrA2WDJ3kh2/T9ZcBcX51U4JfBdxbawjTbbFLc+pmH2mRH3Gd3SaUXjvevaRCI59R
         Lk5TBxxjF1Fc48rt0RFoIiQ8iS/byZRo88VC73yk3iLTVBKcSyUqrTEMYq1hlHzeHn05
         xXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778523746; x=1779128546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KVn4DCFizARj1qN9OzthSmEsUdbqwYJVtmJ8VKsvkHQ=;
        b=SSrsE5mlF4NeC5AtkiDgdAfYRNq66myAZfbRbPWCrk0cds/7wIcUiBfnafTsPwaA0Y
         5QcRe68dcEH456UK4ooxIhPm6u36xUb4zGh11hmzjrjKVqYa1CceBmQVll6KP0QxBUzF
         TD7N8coeuJMeIHLVPSa87Id8G2iRsfbFUXjC/8TqpinIu/Krsn0dnDg7DluRKNab7gwb
         ZAStMM/pkuzMtqhCdj+buO7OCLfe79cQNdpjy99Gga5q/C8i+x2LqPDQMMvMiOG0sqbz
         Hq848IeklZ9Eu5Qz/5jDppyxhz4N8f/chPF66LLq5Nsfhu6T1AC5mSbiItf2orcpo59w
         2GWQ==
X-Gm-Message-State: AOJu0YyCUmj+sSLJVFt0VfqSZp9bSd/qQpHSPjIs/PiOZkmTKpB1VFf7
	UM2FpbiDHUAtTbOLjtbOqjPqMWu95IuvlUBeYo2gBJ0pwmq3kvk91G//egpR98lazb9x6ZUnF2s
	JvpxZ
X-Gm-Gg: Acq92OGtKdHteT6xj6xjcbXc9S58Y2+EwIc4osuvZnINhBTaoW7WdHY9YoqEnegl5yr
	czeftks9lT8DKiOXAc1BUAy1ZMGEVPR3aj7Svehcfam1GT5gOawGe5rLS3aH0iCLvxzfZlwLvg4
	CPoxNhAAHYqKuPyGS2ymcurlcBamZNn6TmgexEpN3WUVS84yC70zUg8XrMIX/pTXrBLrGpjPFCp
	iqobcV/u/l4lQeo/pGjspiApBejDM45m+obZIwK0xU+XfSTIR0pVzIYI40RhLZs5z62L6fjFFXm
	niZnkRPOWE1PrhAqe1D08qKVlp84BqjzSV8tuPvDTdJmImrtrbkVoFXjqrFtup7yIj6TgrXGRCe
	2EjLLifebvSBzCUA1GY8HG80T6S/fGrtpfd+XmpsK3p6QNK9cvomc4RpqgtFmoGuCnhw3SH7wK4
	CDr8EtADWGT8xPSvq2F8BVgc+Z+HKvUJLvlklqusKV0vWz/uq59TDoQU1vgHASYRUW+Q8=
X-Received: by 2002:a05:6808:3011:b0:479:e7c7:dc61 with SMTP id 5614622812f47-4824a97ca11mr6429818b6e.26.1778523745790;
        Mon, 11 May 2026 11:22:25 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c769c9b12sm20749141b6e.17.2026.05.11.11.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 11:22:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: hold uring_lock across io_kill_timeouts() in cancel path
Date: Mon, 11 May 2026 12:21:04 -0600
Message-ID: <20260511182217.226763-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511182217.226763-1-axboe@kernel.dk>
References: <20260511182217.226763-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DEDB514785
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13270-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Action: no action

io_uring_try_cancel_requests() dropped ctx->uring_lock before calling
io_kill_timeouts(), which walks each timeout's link chain via
io_match_task() to test REQ_F_INFLIGHT. With chain mutation now
serialized by ctx->uring_lock, that walk needs the lock too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 5e5eb9cfc7cd..4aa3103ba9c3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -561,8 +561,8 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
 	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
 	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
-	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
+	mutex_unlock(&ctx->uring_lock);
 	if (tctx)
 		ret |= io_run_task_work() > 0;
 	else
-- 
2.53.0


