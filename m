Return-Path: <io-uring+bounces-12214-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HxhHM88kmn2sAEAu9opvQ
	(envelope-from <io-uring+bounces-12214-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:38:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D060F13FCD4
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:38:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 945BE3013697
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062F942050;
	Sun, 15 Feb 2026 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3QlXlpI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C291B1FD4
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771191500; cv=none; b=Exip4yn1ctMoNVYo76AiZUeN4DVSgYKcrYHLaz5m0VeJxCinIZESoC17eqKm2oK6nvj559iGrzYKHMV5Drz7k3+2A9gyK57RmyBPZA+U1f1h7edDcYi5iNlEts4VDOSSyklnx7u6BtwzC4NwzLOFd4aUpPUorAtt+KU3GMMtij0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771191500; c=relaxed/simple;
	bh=58saoN9/ug7n48J5ik/h0Qh3a5Lo68qptT+Sh0gM98c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z9E9YhD1t/VEQYHkVddCi1chpROm5riPXjuDnI+ur1owjYjFGamtPupGAQTGRZAHWc6Ex8veBMz3Q+NdiruUgFl8CYhzjCqo83LBOesoJycxpSNPsGOkpvuaqQCSTx5sKA8ysM/hcozQ+xv56E1k5LEFM1GgC36KC1lkORcN8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3QlXlpI; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so19601475e9.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771191498; x=1771796298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CiFWfnkB8yhkx81dOSFNc4oPrM9/puDcIhy5TgrylIw=;
        b=e3QlXlpIcT0BIzlQzEayEPxnEOpDyW58YB2FXfoYvZsRnO2RCa8Oae5vyM74W4Kj9U
         C2B4JNuSJCu6FSOg81LP/t58WATPWYFj1Zj3yPIIBNQvT/37qxXWgzkvxzlTT1coeVry
         nkBa41UqtbN+PUs60qK52NN/eMaG/j3fnRAp76sE61fn9cZrZkpgg+h3QETb6Zme66uI
         9W8KXrmW68GWFUye6DlBz4Y5Q00ltGIpYPMEvOEW0/cJ9OBpvu1QqT+pcHIlA/ne+Y0j
         ajvnZSLc/UY+RMx2AGbK3TVmzvv65fvso8vgmx0qQ9+wqBP0/gQo6oA6LkONCUgBvmbf
         vqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771191498; x=1771796298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CiFWfnkB8yhkx81dOSFNc4oPrM9/puDcIhy5TgrylIw=;
        b=sUZyYq+rveChTFAxkAJGnTSrx7UWY+Mb38RKUJkahu+15AnaCs9+iiryYgyduqHl40
         Zr3xP0bmNPDQY3ucOftkb3hhhcVyhSqbRpL12DW3hMgIaEpuDuZz/UapoM+Ohm6DR18H
         thr8Tfve/7Wa3ooGkS2PljohSs6wFKDo4VSI9yVQnRS6i8dkiD3PlYTg6V9eHquU6Qqk
         Hiq4UMN9V2V9nGM3ip4ZYBi51KYCIx7wScHjrbkRFPOryCRd26ii1TJ9bHqwLZDseV0T
         xXWaL/B5py4wWklVgEXS5U+inMHQfhMgnVfOHXCXWCcpAqM4GjOc7WXEZ6BB5+0l3yCR
         +QNg==
X-Gm-Message-State: AOJu0YzkWI79W+KHJg7B25s4wsI/hv8wLeaJWamXTsA6m46/kuBiq4/n
	1HdCPSuVV4nNogh814hvwk7JKxbNsZ9yKubNGG9K/F4lKbpNYZQdEO/51owajA==
X-Gm-Gg: AZuq6aI2qRHmrLLQtP+28UXw5rq4qgWBMw5Q7A7eMsQuF/vx2/xZ4rsv7H5FdKcOqgP
	xgzYLJn3Lzcpg/2DroZQWJmCNFBUXcOgovlwWX+YP6XbZ3LuZWveYYVr6KBtey9RNZkMUQIGTke
	nfL/ue49rxkDZoA+oyzxWZy4E/saDW6UjdZTXoDsgQPzL9y8JZX7jzeZAoHMaFuaFDcinjB3+rX
	zQ/xNXMFHNg/mpCuFQZ1RGZn+SY9kSOKqMuTSXkGJHJrlVwocCABwKTSRSkKOUa1iQFMQoq+ffy
	n/w4faRT8yiWoYqSms1ajxgB4BMkfnbNbkMKzJeMV+YELL+xZ6vaDgdQm5nfcoX7eMzqARK4f3i
	TU+fSrsK/RLiyvIhEAcXgy5qj/GgE1bwFN6mnbYm5dfnARHQeIoMuNI3FqVeHgdO+EAzoqLgJIO
	vKTg5WlKHgYzJPqV3bSdWJrGG5UC6aJj7h376GQ1gSUkroePiCRua7sHU7SF+BeEyZJWINL+OEx
	vUe/9Mj0KsI42CMGCJTV21XBRVHJA==
X-Received: by 2002:a05:600c:348e:b0:47e:e2ec:9947 with SMTP id 5b1f17b1804b1-483710960eamr172471325e9.33.1771191497797;
        Sun, 15 Feb 2026 13:38:17 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483740be167sm193376145e9.15.2026.02.15.13.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 13:38:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/query: add query.h copyright notice
Date: Sun, 15 Feb 2026 21:38:09 +0000
Message-ID: <2c2341d55728a89c0dd99e296f57c55ae8e683b7.1771191481.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12214-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D060F13FCD4
X-Rspamd-Action: no action

Add a copyright notice to io_uring's query uapi header.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/query.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
index 0b6248175e26..95500759cc13 100644
--- a/include/uapi/linux/io_uring/query.h
+++ b/include/uapi/linux/io_uring/query.h
@@ -1,6 +1,9 @@
 /* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
 /*
  * Header file for the io_uring query interface.
+ *
+ * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+ * Copyright (C) Meta Platforms, Inc.
  */
 #ifndef LINUX_IO_URING_QUERY_H
 #define LINUX_IO_URING_QUERY_H
-- 
2.52.0


