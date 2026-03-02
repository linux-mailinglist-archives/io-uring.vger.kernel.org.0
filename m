Return-Path: <io-uring+bounces-12515-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABjpF8C9pWn8FQAAu9opvQ
	(envelope-from <io-uring+bounces-12515-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:41:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 060EF1DD123
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DDB9630330E1
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C3C421EFE;
	Mon,  2 Mar 2026 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JoyN9Yd5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6245F421A15
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772469554; cv=none; b=XxgvrQkqlc07lZyOEGIzoUUkVhQDfnBaNahxnUZvM4rUGbdYVqH5xVg/VQbnBQzOnQhyDNtfM29At/lwbKsNRFuIvrMNMcMhlUKu4JA6r5V8L2WzV2/1VCCVB92vS7u+0e9g1jGE0Yif5ebcLOo/hCmFaC0Aclo4dr8wF6LVn7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772469554; c=relaxed/simple;
	bh=bfIMw4s5E6WEpd7VcgBYJkug+2LIkZB4O3crmBDTPb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GcppJg4L5DmEgS17A/QqaarGL1jQTR5bDh1pNVIOy4cd5p7/zlJ+rRpNC0Ip0Pj5zyOzzGvm4c0QdeiM14Gb4PwW/HVWqZmsGmG95yInWbI6o+71QqFidxOTJIxTfWdYiWPsvb4ObAZSLOi+pEdH1B7s9CaLQNy+fQ4bz5vJaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JoyN9Yd5; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48373a4bca3so28318285e9.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772469551; x=1773074351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RLH2Zsf/+9XcBU3PUX60P5GwjddHlM2s685LeP+DF/U=;
        b=JoyN9Yd5vmzsdu/egtES2pZlR+W7DOGBNe08Y1LemG+CGPJlv5E8o0lGRhPiWPMu2V
         SpN/hIHvjryuw3/MSMhCQfPAIVmRSQcp78ndrulT1mGTZvvfQ472YSCVVtB8R8qEPfsL
         GKQyMtc8lgQrN69QFP3M4Bb/YXL2DVXEwrWfgpJz40Cd3QHmqHSkilK6fywlFo0L4+fG
         mEGFKyHP8GBMhyV6t9UOrtZpcXms2K3gA5kXtFXqAJbQmqRB9B4ihOCVfsPMR6AD8QUC
         /nRi1gE5OWeeXntrqgBh3OUlXuLmbrt3kYZ4I0JcycvQVvtM3Ld1sJa9u28ctKmT1IUP
         maDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772469551; x=1773074351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLH2Zsf/+9XcBU3PUX60P5GwjddHlM2s685LeP+DF/U=;
        b=XBsO/T/IBj13Tdb5ru4TXE1XM/rl71CQ8nH6a64hNg1MiCXdOfRKIeElWttBwom6Ry
         9W6UeL2c0AHXTR2Siijbf96L8S/iOfAYsl34ChJt6mEPm3pBNr9YK/ICfAx2vuKhCQg8
         r/gLYX1hV0zLoVQxvPwurFc+fW5xn/xudsAlQZ3xZt/shmhK6vp17fnCRHyn8UdqS7/3
         4+Tk4O6y0esvwBpjgnpa4NpCyHGL+y4Kuc38KNPmmspybNMCx/nEx6hQ4xZaZ/z0ZEVk
         I+paqTQDW6N+d2+bkgnUNZ6qNVpQDF4KtEozvKjRPbq7OcDH9TPizQ7c7OKJ4Bnu4/Gk
         wh4A==
X-Gm-Message-State: AOJu0YwoLpyWi7XA/vmYdxsnSB7os6KBoSiRxxaj8VOCODBhFUXmJrub
	DDvQbZZivMjj+ZBUnz5hPjALCWz88aZ+0ij7JkyL16Deju9XVLVyuQKjJSNi6g==
X-Gm-Gg: ATEYQzyyycBObTlAyTouraRa+QLkT0ohP1hrm0pEIggkJi0arQJ5tbjdIW3NfUrjOF7
	CrzDvH3E2WzIBUBrWXfwJyKb/dvagIyPp+wNMYHC+F2cqo6D0xnDa0T0WU/hfkTvQmqn7qehEaj
	w6QD5NSXoDJlDpZK4Ww2UHeIU8DRf0kEEhv1a/g4X5Zhe7QaYuBVXarpcjUqaDauQbcmP+uuCDg
	jQw7vtmlnEauu0MrlK50Y8XUidqS9baRI6tZYgsS+GKPJBed4IaehSDUVLrjqGfig145fj8j/ug
	dlwLewaSoaNyh1wMoZ4Ok9j6cFDT+DwUF8myPcIugK+kHmjT96bR8TZoTrG1/M0frrKp+cL4aym
	UrjPo2zTdQUkltMWz/Zn0+5SSQwtN+70bw71gjU4Dw7i9dWdvxljqJhxql8L3SvJGKYoOXY5Zrf
	a/TTKLh2dUHP9ylPxuBHVqdISFNkhiuLfJo/aXNFhMDnOJJiW6hEPEB3Z4Rp5LMFuIj1sRtZlot
	wfwT65znwWFRCwbncewc6DTSRDf8w==
X-Received: by 2002:a05:600c:6488:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-483c9bbc297mr242254815e9.17.1772469550955;
        Mon, 02 Mar 2026 08:39:10 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd765604sm364368595e9.15.2026.03.02.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:39:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] man: document that immediate abs timeouts are allowed
Date: Mon,  2 Mar 2026 16:39:02 +0000
Message-ID: <89b2497fff2bb02b9f08d693ee1ebd86dc538a8b.1772469512.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 060EF1DD123
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12515-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

Add a couple mentions that absolute mode timeout requests don't work
with IORING_TIMEOUT_IMMEDIATE_ARG, now they do.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2        | 8 +-------
 man/io_uring_prep_timeout.3 | 9 ++-------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index b5b60b2b..bd4f0613 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -677,9 +677,7 @@ field to be interpreted as a timeout value in nanoseconds rather than a
 pointer to a
 .B struct __kernel_timespec.
 This avoids the need to keep a timespec structure valid in user memory until
-the request is submitted. Only relative timeouts are supported with this flag;
-it must not be used with
-.BR IORING_TIMEOUT_ABS .
+the request is submitted.
 .in
 .PP
 
@@ -2214,8 +2212,4 @@ was specified, but
 specified more than one clock source or
 .B IORING_TIMEOUT_MULTISHOT
 was set alongside
-.BR IORING_TIMEOUT_ABS ,
-or
-.B IORING_TIMEOUT_IMMEDIATE_ARG
-was set alongside
 .BR IORING_TIMEOUT_ABS .
diff --git a/man/io_uring_prep_timeout.3 b/man/io_uring_prep_timeout.3
index 04316f8d..0c4a44e7 100644
--- a/man/io_uring_prep_timeout.3
+++ b/man/io_uring_prep_timeout.3
@@ -71,9 +71,7 @@ argument to
 is reinterpreted as a nanosecond value (cast to a
 .BR __u64 )
 rather than a pointer. This avoids the need to keep a timespec structure valid
-in user memory until the request is submitted. Only relative timeouts are
-supported; this flag must not be used with
-.BR IORING_TIMEOUT_ABS .
+in user memory until the request is submitted.
 Available since the 7.1 kernel.
 .PP
 If no alternate clock source is given in the above flags, then
@@ -98,10 +96,7 @@ The specified timeout occurred and triggered the completion event.
 .TP
 .B -EINVAL
 One of the fields set in the SQE was invalid. For example, two clocksources
-were given, the specified timeout seconds or nanoseconds were < 0, or
-.B IORING_TIMEOUT_IMMEDIATE_ARG
-was used with
-.BR IORING_TIMEOUT_ABS .
+were given, the specified timeout seconds or nanoseconds were < 0.
 .TP
 .B -EFAULT
 io_uring was unable to access the data specified by
-- 
2.53.0


