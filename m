Return-Path: <io-uring+bounces-3243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6512497D30B
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 10:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F991C212C0
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 08:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C608822EEF;
	Fri, 20 Sep 2024 08:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pMm8TDGM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1712AE77
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726822459; cv=none; b=VPZgINTO8CsJqneyEOUHAyoV8OcXO4PC0Z7fKaBblLOnRRxM8UFj97lRKbAGnxOy83jfRWUtgyQRYdHUxEwhr5a5HRM82fpMQIRFEuRGdadpIesLlXVjHzY3zhw8bwiwDqgw0rVX8dwuJo9Y/2J/9MgkXuwUsbWULGqkpZNMT0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726822459; c=relaxed/simple;
	bh=9NhO17Mmj/bWSQTLhwoJFHgFNGhUTO2tmVtKN+jaXAE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Tb4xNjgnLPH2pHQ4xbprfgVFsNA21uOxyOY/xA7coH02NIaXCi7Y3ZDOBSlUizjDMfMf5UCBkF57zryE2ePyKQfhxedCsAufx2lrcMU0adFhhPvdhcsEkah0oh/Vp8AqKGq8xIfBuOh+Xrm/LU+DKPeY0pl4+i4mUrhTZNih3rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pMm8TDGM; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5356ab89665so2382363e87.1
        for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 01:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726822453; x=1727427253; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWcFHCfbggv4qX2DWQCpYP4rg8Ta1tqJ/0puGBzntN0=;
        b=pMm8TDGMz3EXSGStgL5gREJ7R3YGfIRDWl4kOpzgILVNXvGsSwIE/FZVlu1bqVPhX4
         PjH7Q97wkgb7Bk5QwUv8ZgAZJvtpmeP0Z/+EkYFdTNb9+sZrIqlE0mDOosCvxmpE06EN
         7Jsf018eJl1JysV9EwTp9F6g8Mm30ZAHJA+yfolMC/0/kNW/y/fsvxLltZGWWeI0sw5f
         FPzMWX2eoqt4F3VnmitKYkVWdUyWOd/+GYVIdMWNalI65w8tyygYJppkaG/sGhxce/58
         bgeDwMzs9B8/q5JwSQET94S5LPH+MMs+YC/QiNddG+0R7UGgfcPTcjUNjcGoEohTLA1i
         9Ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726822453; x=1727427253;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WWcFHCfbggv4qX2DWQCpYP4rg8Ta1tqJ/0puGBzntN0=;
        b=GjpjGCOMcs3MqSWAQpvvUcEAft55HdEr9KTtgpZ9SLIksQCQepWGX1pUISFjiiPfbP
         yubyLLuQ01+NGSJ2lJrAAUayXcnXyS3x/ZJQ87B88xCXbZ/IVyknhYEj+oFAWbXGBHyI
         PHqbsBsjJhjNiXutW3Q9dQlsQj/pNYdbqAZk1BxsCsM13TfsrXKORphdzXk+g7zVBAJw
         UAu7m11UhtsN+55JwelA0UjVBzTuzedXFn3LOE0+FgOrWKvqOuHxR5sPhipbb0bgepT5
         VQlAQp6jsr2Ka5r+HDQafy3eXsIIVzn4gwgdeW3R6NuGMmx/OOp0WxuUj9sHZcvaBSVP
         ST2w==
X-Gm-Message-State: AOJu0YxyjYUtofVBtlnRP+Xl5Gik78G0vEd4/4ji1UMU2KU1ksUEHGym
	okD9XAJZk53YzcpRygYO1LfiYAPP9+8DwblRw/EJr5U6aWYLlSyCeLTFAVgcWaW/hq+VieiV2WO
	pBRR0Rg==
X-Google-Smtp-Source: AGHT+IFqUFlB85cHCUHRL5ruaX20nA5oUgLg0RS9hxN3bcyuIpVJBBIQNxSf0u2I/OR5RMNtZMKY0g==
X-Received: by 2002:a05:6512:a90:b0:536:5551:79ed with SMTP id 2adb3069b0e04-536ad3d48cdmr1134869e87.50.1726822452865;
        Fri, 20 Sep 2024 01:54:12 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb492a1sm6925219a12.8.2024.09.20.01.54.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2024 01:54:12 -0700 (PDT)
Message-ID: <0bf88b09-277c-4a87-bd55-2e4d7da511b5@kernel.dk>
Date: Fri, 20 Sep 2024 02:54:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: check if we need to reschedule during overflow
 flush
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In terms of normal application usage, this list will always be empty.
And if an application does overflow a bit, it'll have a few entries.
However, nothing obviously prevents syzbot from running a test case
that generates a ton of overflow entries, and then flushing them can
take quite a while.

Check for needing to reschedule while flushing, and drop our locks and
do so if necessary. There's no state to maintain here as overflows
always prune from head-of-list, hence it's fine to drop and reacquire
the locks at the end of the loop.

Link: https://lore.kernel.org/io-uring/66ed061d.050a0220.29194.0053.GAE@google.com/
Reported-by: syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d306f566a944..4199fbe6ce13 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -624,6 +624,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
+
+		/*
+		 * For silly syzbot cases that deliberately overflow by huge
+		 * amounts, check if we need to resched and drop and
+		 * reacquire the locks if so. Nothing real would ever hit this.
+		 * Ideally we'd have a non-posting unlock for this, but hard
+		 * to care for a non-real case.
+		 */
+		if (need_resched()) {
+			io_cq_unlock_post(ctx);
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+			io_cq_lock(ctx);
+		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {

-- 
Jens Axboe


