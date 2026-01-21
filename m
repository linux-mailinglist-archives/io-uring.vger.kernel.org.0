Return-Path: <io-uring+bounces-11876-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iG+dBkZhcWkHGgAAu9opvQ
	(envelope-from <io-uring+bounces-11876-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:29:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D6C5F857
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4626B64247C
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BF9286D5E;
	Wed, 21 Jan 2026 23:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S6JjfQ4W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA830F53E
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769037955; cv=none; b=e1BNi77fByE8D8xtJY46wsE1nGCXSPaGJquHXuG0Yjryr6T3fhZdbLKYFhTXvQNpS4Cqnxmo/Cuh14b0uk7G5fn1Ec1G0Zint0qk0wd+fKj8ZwGGIPml8c6AL5pPw+bVWXbz6t1mwPcK2YsEerVMyqDHyg4w65cEcQnvrIbsB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769037955; c=relaxed/simple;
	bh=zc2eyqCeHcYibo4Jt5xPptPLJey1vUJImeemg2sEUww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otDq0N3hgG1uOPmq4KePsMMIK/10aAl4YKmQZuNzJLYMzecKmfQnwIH28J3phjy55me+HPoiRLlLIffzBZEBh5Ko6254PHuanCZOelO5aiaWljOb2T+eh7sB5eKYw0uP2lI4qBLCDnLctC6DgRUkEQGqKlTPoZ3m9ps1EsETBWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S6JjfQ4W; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4042cd2a336so168980fac.0
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 15:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769037952; x=1769642752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXb4TR83FHA4r5e6wZubYo7mB8XBVeHpJPXxijwCfpo=;
        b=S6JjfQ4Wb4hwP2hf+8ov01hWOZ2e/bZe5dyQ1wmI55KVGpRmFZCdD3oMBsXR+JU+Z7
         +I6Wl3N/ltRpS4sMi/Einl9y2LXyKlrqMuNPf4plixhxFLG+0yr9MWsyKE3Is8exChZG
         /lvH0nwAdHledEo3bMBvTU373JmG+F8jPowA8IX1dy23bUJqwXkhBwere5iy2SmspYlc
         qKOyIM8UE2qfi6iLAbLVs/LrTIo/8NadVghAAbsPZnusDH7uxazWnSfNENY7zyz9Ibq4
         IuQ1xMbjVuboIqkWmyKnb5qu7I7pWavqsSmYHNer1AeUf4tj7clGc0Y4nKTHpxCZQEq1
         IU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769037952; x=1769642752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IXb4TR83FHA4r5e6wZubYo7mB8XBVeHpJPXxijwCfpo=;
        b=G6FoUZ8KBilS2yok/Yoovk2XBdX2PEkWkH/C5D3V0hZ+5sO+z1LlkJeyXppP415OCn
         59PprUYc4o/TPY1x52GqAg8usOhwxVMsEDDoA4FJ6BwcjdzFZZJHhUIAQiNJYEpZwBmn
         p+SqVSVaMpvRtO4BQuqJ5dEyGsrO1ylbMlux9k5hyJOaX8P5hUDvyrkPKLkSbaAjGGD8
         95XdITlAEWzlgsq0aMaZAeD5b2MnnA6WNdnUbt/ejJEj4dVpf/wEsf/efJfNtm5Tyoj3
         ZMknb8y6TlMpjRPamdyacka80cfI5Gg05/BwrjcejxvCpyTfbTzSBmlgF2zgG11aSgr5
         kHpA==
X-Gm-Message-State: AOJu0Yw3/3uQJszYm+rDHj/osvI2OA3QpdABQnneyjZ9fapD5vptzyxW
	Wk5e95fSQSj6JxYSzCeKX5SbcUrfW0fgJQWPfjT/pKkf/ABLWM+iImJFpiUHiU3puphmvtdt57p
	9yX+5
X-Gm-Gg: AZuq6aIWm4RYz21+l6axu+6kSLT8UDWVNLB0S3CwSjFG4fS0mvkbZDMI+f2VbdkM0L0
	8Y3xkqnsY+gR0juE5ZL2sJJRdtbaa+9+SgOlvBC1J9xSc9bAz65BA7hGcE8SnBFpRKBVFZqu8Lm
	faH8BAuMUr0exk7LPSdOalnKWQ/MO4sK41SD+j11UCKqcOcoQbFsvtKp6sV2nz2XfDOMB8hDCsh
	k6TdBivxbkgfT2jXo9KlL5+p9UVjLQ8X9/NENYCEIHbOunlTMhrC9AfXA6pbwVU284GvunDOcqP
	0eAyqLPufWIWXA/rFOVmDHJKLpglwJHlaGZJC1zXdHI35OpqNuLs1rdhNvZEy6LD01SeCzYAFFW
	SzgUAgDH6BMctbGIggD4+AA+6w3DW2XKSFAuYXBIBmWTIlmp2AcIysXWaMDivmd5dCm7A0OmKNm
	VYl6h3Nzd5zY5VTzeC6Pl0bLmBB1770Fmcmn3LnLKhrLT9WihEDfp+NJbt
X-Received: by 2002:a05:6870:6109:b0:403:fcf4:eaab with SMTP id 586e51a60fabf-40846c8b429mr3779867fac.12.1769037951982;
        Wed, 21 Jan 2026 15:25:51 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bb55928sm12074632fac.7.2026.01.21.15.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 15:25:50 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/io-wq: don't trigger hung task for syzbot craziness
Date: Wed, 21 Jan 2026 16:22:17 -0700
Message-ID: <20260121232546.260055-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260121232546.260055-1-axboe@kernel.dk>
References: <20260121232546.260055-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11876-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: C3D6C5F857
X-Rspamd-Action: no action

Use the same trick that blk_io_schedule() does to avoid triggering the
hung task warning (and potential reboot/panic, depending on system
settings), and only wait for half the hung task timeout at the time.
If we exceed the default IO_URING_EXIT_WAIT_MAX period where we expect
things to certainly have finished unless there's a bug, then throw a
WARN_ON_ONCE() for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2fa7d3601edb..aa670909fece 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -17,6 +17,7 @@
 #include <linux/task_work.h>
 #include <linux/audit.h>
 #include <linux/mmu_context.h>
+#include <linux/sched/sysctl.h>
 #include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
@@ -1313,6 +1314,8 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 
 static void io_wq_exit_workers(struct io_wq *wq)
 {
+	unsigned long timeout, warn_timeout;
+
 	if (!wq->task)
 		return;
 
@@ -1322,7 +1325,24 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
-	wait_for_completion(&wq->worker_done);
+
+	/*
+	 * Shut up hung task complaint, see for example
+	 *
+	 * https://lore.kernel.org/all/696fc9e7.a70a0220.111c58.0006.GAE@google.com/
+	 *
+	 * where completely overloading the system with tons of long running
+	 * io-wq items can easily trigger the hung task timeout. Only sleep
+	 * uninterruptibly for half that time, and warn if we exceeded end
+	 * up waiting more than IO_URING_EXIT_WAIT_MAX.
+	 */
+	timeout = sysctl_hung_task_timeout_secs * HZ / 2;
+	warn_timeout = jiffies + IO_URING_EXIT_WAIT_MAX;
+	do {
+		if (wait_for_completion_timeout(&wq->worker_done, timeout))
+			break;
+		WARN_ON_ONCE(time_after(jiffies, warn_timeout));
+	} while (1);
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	list_del_init(&wq->wait.entry);
-- 
2.51.0


