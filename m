Return-Path: <io-uring+bounces-6434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A89B4A3580A
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 08:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DD7C3AB98E
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 07:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5331215774;
	Fri, 14 Feb 2025 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Z6L5wElI"
X-Original-To: io-uring@vger.kernel.org
Received: from forward200b.mail.yandex.net (forward200b.mail.yandex.net [178.154.239.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB0B214A7B
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739518867; cv=none; b=txwASxS/J0T7t7VukEZcwAL5yWQ554/IfxLlO2NFjLy6GKm7RHMbZDOyAixZ+2Y9eoOsqTkNnu8XcCQLqx0mdtzv1jQDM9a+RUJ9Ef1kQhQycfYi+Js5wFNcnRZjuLZqefLsaEgEWkluPz0BWl3cPkVidukrxS02e68qXHME7SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739518867; c=relaxed/simple;
	bh=2aBigldgkqaTheYJKPaZql3pDyPYecr0ZfMbvlh9ZYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L6mpsC/dLJpxlgv7SXiD0lepAxqnds6E4oY6I1NvrQIJkcF70oZZPRv1SjkGueUX1chiXF3b66+52f3CE5saCupmwVcBp92l4yya/2sv/+3cv33ym8c+z6I2J0o8as6RMJbQjDedy3EUR6o2i0+Wm1dkm+fcEDr1e03L+Bhounc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Z6L5wElI; arc=none smtp.client-ip=178.154.239.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward200b.mail.yandex.net (Yandex) with ESMTPS id CA66C69086
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 10:40:55 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:2a23:0:640:a77e:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id BBEEA60B17;
	Fri, 14 Feb 2025 10:40:47 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id keL6wfCOkGk0-W34XtmEe;
	Fri, 14 Feb 2025 10:40:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1739518847; bh=BA11txVwjbqpEJB+7Stf5M1jmxwsf+JhSwZFseOffVM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Z6L5wElIixOAM9JfEOz3M05X7s2B45l0oU3tb6JnYcyy8fnkFGeyZ00xYaqB0f0B8
	 xw6lQtVuWMoIUoMyeHH1ucqQhtwhD529su8I7Y0FOp7mgQ5/+02lB2WK5qnqqAh58c
	 WQMKriu0ERNUm63dElAeeAuObF2DmyEPyeI9zZsc=
Authentication-Results: mail-nwsmtp-smtp-production-main-60.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
	io-uring@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] io_uring: avoid implicit conversion to ktime_t
Date: Fri, 14 Feb 2025 10:39:54 +0300
Message-ID: <20250214073954.3641025-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'io_get_ext_arg()', do not assume that 'min_wait_usec' of 'struct
io_uring_getevents_arg' (which is '__u32') multiplied by NSEC_PER_USEC
may be implicitly converted to 'ktime_t' but use the convenient
'us_to_ktime()' helper instead. Compile tested only.

Suggested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
I didn't add Fixes: as per Jeff's remark at
https://lore.kernel.org/io-uring/x49ed01lkso.fsf@segfault.usersys.redhat.com/T/#t;
if you think that it should be, most likely they are:

aa00f67adc2c ("io_uring: add support for fixed wait regions")
7ed9e09e2d13 ("io_uring: wire up min batch wake timeout")
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7f2500aca95c..f73555e981fa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3257,7 +3257,7 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 
 		if (w->flags & ~IORING_REG_WAIT_TS)
 			return -EINVAL;
-		ext_arg->min_time = READ_ONCE(w->min_wait_usec) * NSEC_PER_USEC;
+		ext_arg->min_time = us_to_ktime(READ_ONCE(w->min_wait_usec));
 		ext_arg->sig = u64_to_user_ptr(READ_ONCE(w->sigmask));
 		ext_arg->argsz = READ_ONCE(w->sigmask_sz);
 		if (w->flags & IORING_REG_WAIT_TS) {
@@ -3286,7 +3286,7 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 #endif
-	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
+	ext_arg->min_time = us_to_ktime(arg.min_wait_usec);
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
 	if (arg.ts) {
-- 
2.48.1


