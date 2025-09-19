Return-Path: <io-uring+bounces-9841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC62B8933F
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C656A1888679
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E09E30B516;
	Fri, 19 Sep 2025 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiKO8qKm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7161B230BE9
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280237; cv=none; b=NsOAF864Ndge7uTT+Serp9AtqeYT49Lx51pQZsAlXqxtPRhVmRJ9Br0tiMC5WzX2LXTVOO1gQLRaupZDUataiAtVVR2RLJHMNS7QS61yYGyuLh5jlLbd2Vm6kHxn4FTXyLmUhqYX61cxfFmsp8OkNqEx6KPT+Uv7ajkFoNb2m0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280237; c=relaxed/simple;
	bh=LTLpF+7rfthYUGtOtVqenTqxTyEQwuNyjVB4267f8gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIYImjBIJGC1IAJxgUVRgQu+hqs3zUajZFZ0mtaB8mIA+qJSVI7/JdPppnKOHuuUU5DLuJXNsCJE32iBprmn7EhzMMt+Dj5KwNi82MCMVPWwquC1BhS3wbhUYOqYgWK6yAB8RyRH1KKpQ5x9mflHwbWamR1YfJ/2e6Sh//h80Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiKO8qKm; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dfb8e986aso17264155e9.0
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 04:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758280233; x=1758885033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPve2INZ83GO/Xa0xRLZOp7OneQXv3THvSnFuyFA5mg=;
        b=UiKO8qKmDP57wlTPj8Lq0M7tvZkCieBApEVIudeliOXVOXfMFzsC3vhHNmo0Oy8sIo
         njV5h7rHIYNRBgyVdpJZB4vIPFF8HPnip2GdjV0PLooEQeGHZCD3WaVe7FTAQBraddF5
         D7DLbV881UyOc6yJnQjri/1u+z2CqapGU2AobJHD+lsE5kSslqZDk6t04YWUqPmBla4m
         mNkVrKVhfHR41gwVtg1eBAhVkRabtQrhd0fQCp2Y9a/SmWepcdeLSOFJmjgzh4Rsi1XD
         xiKiaRN2pbd6nQzodHnADdexucTvOTs7ZTkLRUS3+c2feTiYOPwwazAeg2WVxwmGY3Lx
         HDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758280233; x=1758885033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPve2INZ83GO/Xa0xRLZOp7OneQXv3THvSnFuyFA5mg=;
        b=DMtmA0BaWdid8Ug8+a9DTpQXv1t9VOUwEadMjTu4a5YF4Cfcib1Tz4ejEOlKhfXNmu
         KzC8UWD5RePsFj8/RkaXxBcWnKhFiQgkIngzpxiWAyUhyKSuWP9xN8C4t7PS00YHe3dn
         TC6+27vfHKUYbp73GS0LQCYMjb+Ol5WRLxjb5748ibzOZhAZL3wFUyCcJUGstZO4LxeB
         Lhn94ZDxU/HWWyBCLbNx/HiCCIKWfjXOizrhvE3aOGTPOXoSbCbm1TB6BVTj8qpDKrb4
         zCWefiiIRh2/umhIWrl7u3Z2BaXlNLByoIMwNxEdgGsEidXD5i/Z1Yrgz6GL+EwEUHU+
         jB6Q==
X-Gm-Message-State: AOJu0YzmlwpqtaTN8AZSjnclXcSxm3NhkeNaTkPLWgzx7V8f+T/QEmuD
	PXpuVXiyXJWds/OEENU44CEqeaXXjqdxaJhmhyhqIXqcMK/dsphrQdxfGNpoWA==
X-Gm-Gg: ASbGncs/IG5k9m2js/pQbSqh/81Wvy7MknGCLRr/Lc07SgxTvglAXeA1OxigA+G1+fD
	+7iaEsr87fVDmscFMCdakdPakyk7fPQ3o84Pqa9vIxCadZF1fU0mYVytTAbpapz0fsSleVOtrdO
	0Jb3TF+BQy8boY0HRX7e+cz+tQ2HlxvkNgaWWMfmH2RZO6FnZlIZjqTDTHrK8tKR+B35lm391Gh
	xMn9Jb5kR+ek8EVzS6i1qP2Fc+nTg8c7kHsGIcSBoNO2osJkfRKMO1qW6Mr8AFeJ4IRUQN4D7Pn
	wDVRwp/XpOQc7oQ0VLeAS2BFqxxgInAMqwsDQ098rgittc5BO4S5HyOrgVwXnu3oHayl664Z94G
	naY6ZMJxqDDpGNN5I
X-Google-Smtp-Source: AGHT+IGn9iKjeCEY6hXZ/0IDvChV0H5r3m0if2R22QjxBZT6ghjAk+4BBY3MY+y9v1spFl1nTHoWAQ==
X-Received: by 2002:a05:600c:1e8f:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-467e6f37dc1mr24437135e9.15.1758280233221;
        Fri, 19 Sep 2025 04:10:33 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a294])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46706f755b1sm48776685e9.11.2025.09.19.04.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:10:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 2/2] io_uring/query: cap number of queries
Date: Fri, 19 Sep 2025 12:11:57 +0100
Message-ID: <f16717f6010f24289e0d449b9f801f5b2a5508df.1758278680.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758278680.git.asml.silence@gmail.com>
References: <cover.1758278680.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a query chain forms a cycle, it'll be looping in the kernel until the
process is killed. It might be fine as any such mistake can be easily
uncovered during testing, but it's still nicer to let it break out of
the syscall if it executed too many queries.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/query.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/query.c b/io_uring/query.c
index c2183daf5a46..645301bd2c82 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -6,6 +6,7 @@
 #include "io_uring.h"
 
 #define IO_MAX_QUERY_SIZE		(sizeof(struct io_uring_query_opcode))
+#define IO_MAX_QUERY_ENTRIES		1000
 
 static ssize_t io_query_ops(void *data)
 {
@@ -74,7 +75,7 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	char entry_buffer[IO_MAX_QUERY_SIZE];
 	void __user *uhdr = arg;
-	int ret;
+	int ret, nr = 0;
 
 	memset(entry_buffer, 0, sizeof(entry_buffer));
 
@@ -89,6 +90,9 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 			return ret;
 		uhdr = u64_to_user_ptr(next_hdr);
 
+		/* Have some limit to avoid a potential cycle */
+		if (++nr >= IO_MAX_QUERY_ENTRIES)
+			return -ERANGE;
 		if (fatal_signal_pending(current))
 			return -EINTR;
 		cond_resched();
-- 
2.49.0


