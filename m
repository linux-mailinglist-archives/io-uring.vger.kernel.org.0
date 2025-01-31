Return-Path: <io-uring+bounces-6202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DFEA240B0
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25AF3164688
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5DB1E3784;
	Fri, 31 Jan 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ep/xofZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF861EE7D6
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738341241; cv=none; b=VCbOM8YwmAl1lm5CeveR+vCInP83rsw5nHutzFoVfZ/lBgk9vqnSRXRFw1FunBOOTDYkFkwtObySiit1ghFtMD/pMMLcpB2jfUhrD4VmLdgna48yUEsypd+OBf1zjW6XiteolP9gILCFY5jbZ8mddsT2rgDF4c3eOV3jUkI9W/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738341241; c=relaxed/simple;
	bh=73cbX+zzwGNOhDBh8CP2oha3/ByMXxLkp6CoYbJHWEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sCEDYuevtj1lHmBZkpErk3RfFy8ZqXGqIzzcYH1vcgTrGZwQxiqo+MFO/tOYfETCMtmto17/C7AkeeDwGRUnetv2xJm2T1InlmKabHhksLT8+dHYvg9AKg1mbJWVn627Fyr3mDOAGOaQiwkHCQJ5NeNKZmN99fdYHUnvb8W59ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ep/xofZR; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d4e2aa7ea9so4601566a12.2
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738341237; x=1738946037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CmYfZnfTLndINniIHztfbOqNV8XAFyAM7U22d7+N9Gg=;
        b=ep/xofZR15s/siNGlJxNT/3Ge6lexC9jAtub4tTkg8RpFa83zXXS51eX3FEcAJ04Fq
         7tP5Z8eYTDmWDEPgtQIwDCFez4bX9+c3sAaGRfu4Mf22iT6RUu4qzRfQlwHEftStXA2F
         zTBlxV2IMPFcVQKCcfPUyGMnxARiGDjwsrsB/CSbBcTCh0UIV7icOBgYAwN81UGFyLCJ
         wIlGoTC6ppCvMWaGjXJ/nm+cX4u1rx6KrQjvuTWL7mX/2FLZ39N/z7FmHpHfBDswiPA7
         BAB22IbmE9MyyZcjiAqipvB5UenkGKI5U5ThMZHx4MuktVOcxayj+KOYWesJFYnsuddV
         MFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738341237; x=1738946037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmYfZnfTLndINniIHztfbOqNV8XAFyAM7U22d7+N9Gg=;
        b=nveiXApI94Zpmol7BkbQ9VNGl24EaVE5NBf2aPY1+4xhwhxG779KnZ4o0kLA1OAaCU
         SPnAHhr/utBhGEM2g+TqMXGyCg1J1JUh+m7GpSFjDY0XgZ3hsXoP2jYEwuokya/7E+ot
         +CEeEN4vnZryVs6FS6Aqb/EB89eUdMDnYo9qXN+mgH5DPYtz/ZGnGi2f1J/mxxIskAcX
         1yu6+HMf05Bv3rsky8Iswh9Zp5OWS3ImUWLfgL35Be0nF+MYzpDkFugEosBdvzi9tPZ5
         1YPs4AmHj11ZQRiS0GtguwBbw5JPhBOxRxJAXgdw0y8PlVeDM7nwk7mkTYh4WTcV39gW
         7T5Q==
X-Gm-Message-State: AOJu0YwJgkzABFqxH45NvSTw+HfrbAtz5I4inBf5qB2mz85CbSQs0ImJ
	5rp/wmZrJ8GeUMT9oefkZkOOyC8IfIfUSLgV+lrvVbKnRr5jIipnHL187A==
X-Gm-Gg: ASbGncswl78bLHsG3hrBsxpEmdcH5V+DJa1NZwn/lE8iPb75jvm86yCI1csnRz6k31q
	6wfYM4RU+d5UrgE3xGm42SWD97jSsUQ9+3MQdwAS2SPuZHilF3tm4GRQuT33iOdc/g9cTkaJ8Iz
	CXUYjd+YRoKMO0TLvK/39aY00ZNC1i0VFzb5lG16HR8+aaZQ+IIfB6ytBE1F9gNywCf4jbG2hja
	LjPkRwQ8HXc+Vlc0kvYeCvkE0joLZ4QJoNc7ehqNDl4o+7Qsf3+CQukPQq4eojxokuzYKfD79k=
X-Google-Smtp-Source: AGHT+IFX+0qk5jT4ByEGpblct99b86vrgyTL7GAsUaWuAtofsq6qFJHZE82BLeiReefN1+SIwSKaFw==
X-Received: by 2002:a05:6402:520e:b0:5d3:e45d:ba91 with SMTP id 4fb4d7f45d1cf-5dc5f008488mr11700405a12.32.1738341236875;
        Fri, 31 Jan 2025 08:33:56 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc724055e5sm3181239a12.45.2025.01.31.08.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:33:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2] io_uring: check for iowq alloc_workqueue errors
Date: Fri, 31 Jan 2025 16:34:00 +0000
Message-ID: <cdf0d7b4207aa991602e5889804d55d5bec31bd6.1738341118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_workqueue() can fail, check the result and return an error back
from io_uring_init() if anything goes wrong.

Fixes: 73eaa2b583493 ("io_uring: use private workqueue for exit work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: drop other patches

 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263e504be4a8b..4d6d2c494046c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3920,6 +3920,8 @@ static int __init io_uring_init(void)
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+	if (!iou_wq)
+		return -ENOMEM;
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
-- 
2.47.1


