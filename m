Return-Path: <io-uring+bounces-6409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0E6A348C1
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 117EF3A2516
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 15:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6FA166F32;
	Thu, 13 Feb 2025 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="qKCjVYiI"
X-Original-To: io-uring@vger.kernel.org
Received: from forward203a.mail.yandex.net (forward203a.mail.yandex.net [178.154.239.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEFC159596
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461991; cv=none; b=bC8SBpNlx8pHhrBxibX4Eqzk6+KoOWe4vks5T8DWIJNOInyuOyPUe75eAWL8DY+G9ltD68VJmKs8F0Yjcl9GrGxwL0LujI/f393jxs73FL87Fgr14+X+S71NaPkm4V1s2kiMeTNKIGI1A8EtB761PBkWW4Rd6wncuobO3LdOB5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461991; c=relaxed/simple;
	bh=hGbPeEfw6X4y/hgxfriBbQDfPAeicq0XBNKh0/edbiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXNAaDBCMEVf0jKLEUTpF4TnwFpRJOEu48+OB8HMCwRuCad92ckxUW1lPaJb95eT7OMnyyhabRYojoW8hZlCXJDM/QoaT43SryrcyQ0SqHdwPG/XgrgeYt/UJxQAGPYWo/vZhSuwLY0EuCohOvDsv1k9+2Z56czGjEvc2mShK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=qKCjVYiI; arc=none smtp.client-ip=178.154.239.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward203a.mail.yandex.net (Yandex) with ESMTPS id BC30B67245
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 18:45:08 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:4883:0:640:cc3a:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id BA4AA60AFE;
	Thu, 13 Feb 2025 18:44:54 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id riS5bk3On8c0-7WQC1b2A;
	Thu, 13 Feb 2025 18:44:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1739461494; bh=pCBE/zTjMBJ5Qlky0LQTLJSwC8NJyLhQ1XzfRMkDp9w=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=qKCjVYiIkMeUCO29bmsKOkyQv3jPwRe20c8P/ET8Vj7dlHng+xS9pyW5VvcGNmxmT
	 U8Q6ut/go3KehwUMqC9Ejbx5cDiFCM2B8wcqPSx7F+gh2nSkVkBWhSKSEG9Q/S/7Xo
	 RHdRL9e4XBHVzinNcDvM38tEAFIcZGWwoymeSLb4=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] io_uring: do not assume that ktime_t is equal to nanoseconds
Date: Thu, 13 Feb 2025 18:44:52 +0300
Message-ID: <20250213154452.3474681-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'io_cqring_schedule_timeout()', do not assume that 'ktime_t' is
equal to nanoseconds and prefer 'ktime_add()' over 'ktime_add_ns()'
to sum two 'ktime_t' values. Compile tested only.

Fixes: 1100c4a2656d ("io_uring: add support for batch wait timeout")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ceacf6230e34..7f2500aca95c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2434,7 +2434,7 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 	ktime_t timeout;
 
 	if (iowq->min_timeout) {
-		timeout = ktime_add_ns(iowq->min_timeout, start_time);
+		timeout = ktime_add(iowq->min_timeout, start_time);
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
 				       HRTIMER_MODE_ABS);
 	} else {
-- 
2.48.1


