Return-Path: <io-uring+bounces-6256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F25A27BDF
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B8FE163D3C
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEAE219A74;
	Tue,  4 Feb 2025 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="deb31OxN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8649A218E8B
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698504; cv=none; b=CHqp0fh5U+T9q2aTkY+4ZSEZh7TH6kM0sdYqDsYJi/ycnAlPBScRH+5wBus/lxCh2kC+jeEXUcQ79lQO+WM4yABwM0dXmNKFSaRcY4hN3E2yPAQLqnMhC4jVrOXNXroKz7dg7F8ifKF8t21hYLbpHBGf1QsbJ0k2Ix/Q939mXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698504; c=relaxed/simple;
	bh=FfOsgqQUbrqMBseqWoxvdeHMXbEwUwBb1lrRINWoyNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1FDkX6Up3v8ZO19Y9V9lj0EKnw8JIh2k2h5hBeepRWFoThHKFPridslLKXo7jOp7stcYpoVbZmB/BGe+81M3ddE29QQTxdG10gSuNO8piAslqyKWmX9fZLq2MkxfCh1aBsgb8HXILoMth3gTTaX/PfB0RZSQBOk5uAHxCffmz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=deb31OxN; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844eac51429so448530039f.2
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698501; x=1739303301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4mLZ0JfeLifQ8U+aoK/TU8xkbtkVLx+Q+iBJc1yFPs=;
        b=deb31OxNU1FrYW9c2lj1rJc6b8gWtKbFVb5TKGPbva+mmxr0DaB/gl3FW32XO6Vd9P
         fv/Ofbej1UEoi9ntN2mhcq78ornCTfVBmTeswca4nbnzg+s1jgomg+22ZRSDQ1njaFeC
         0uqdXmH8wpLQ5wTcT5YY51on44ogrMFmVsuBIxSnO9xol6AiFlYRVLYVewRhZ5bM0qSb
         iTWxkO4IxMF4FpWngUQB2goF5hWWkLHJv7N5drCgG6LOfsmBA+VVBzOBw/gOFCfhnCnW
         qpaW6jhFf1B31wHrCK097hSORcOU+it22VuRG0wQCZ2zbtPTbRaZq2OA/ybGkIEdhqJv
         y74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698501; x=1739303301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4mLZ0JfeLifQ8U+aoK/TU8xkbtkVLx+Q+iBJc1yFPs=;
        b=tugVs/tqzq2VEHl7sxnc/KGFcrGx/W6li2spfqvwdFUEIETo20HKDWCMeqmDUvkVE+
         X7GqeT59hUFlVYmvziBVZTwIhaB1mTS2ljwINBqgTyt6JzdQ65RJRAKWSWuN6E3052Kc
         +SEVmyp9o17qdMbkMEF0fjqQeVc2iX571na36/+6rBUF/Xq/9va4RMdL9mlHIonv0DcX
         p+zKBkTl9XE7kX+PfPx0m2x8wL5tzJCUkITXTcN+i2aEy8tZ84j1Ho44uJDB7M6GsHw0
         8lVpt///W1zqT7Lnz1fOYijfN18PvFkEO4UvTRtp3EeXUaKnGobFo/jswCmo8cc94+sn
         FGwA==
X-Gm-Message-State: AOJu0YwKuIOMPKazpOK2UbLeVjYKh8C5b+1J/fzhCXukPVaiHddqofev
	LeOHUyackZZDyqvgOdw/OVtKkjKsqxCUBTgqQfHc8DwU2ycQ7947urcVi7OvirrMXZVxdaJKzhZ
	o
X-Gm-Gg: ASbGncsxP8/vZkBDRGxuIIQ1ufjY0ApsL9mHqNGpgxx680eUbf/kX4iELF6KujPdIlW
	SfqewujI5UELMKzkJW/9DBNr1dWkeHWiL4ro9xhS/jMUKEff8kszRi41TAi8R+TS9cGpEx7ldGS
	000d59RhoQt9I6Ls6L/lRsGZqt4hUZd0uoUc73CUdSPKqcQjaGFXJhRSQcz5i4Huz/8dpQ8FsHR
	BPG4Uv3yrpD+n60PVMX2/31vJURN/cbxNalgFHkHb0GKW5AsmT7JjgeJLf8e8/1ZYuzppUdOXvd
	XKzas+8xbAblatt43LY=
X-Google-Smtp-Source: AGHT+IETLElqsMwzUMAfae/TCAVOpEGuh8jeYsJtvh7I5ZQpGcY/b5dQsufHQP1bMD6MomTu5+GjAw==
X-Received: by 2002:a05:6e02:1d1a:b0:3cf:fb97:c313 with SMTP id e9e14a558f8ab-3d04f8f6ee9mr1728975ab.18.1738698501376;
        Tue, 04 Feb 2025 11:48:21 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:20 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/11] eventpoll: abstract out ep_try_send_events() helper
Date: Tue,  4 Feb 2025 12:46:37 -0700
Message-ID: <20250204194814.393112-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for reusing this helper in another epoll setup helper,
abstract it out.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 01edbee5c766..3cbd290503c7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2016,6 +2016,22 @@ int epoll_wait_remove(struct file *file, struct wait_queue_entry *wait)
 	return -EINVAL;
 }
 
+static int ep_try_send_events(struct eventpoll *ep,
+			      struct epoll_event __user *events, int maxevents)
+{
+	int res;
+
+	/*
+	 * Try to transfer events to user space. In case we get 0 events and
+	 * there's still timeout left over, we go trying again in search of
+	 * more luck.
+	 */
+	res = ep_send_events(ep, events, maxevents);
+	if (res > 0)
+		ep_suspend_napi_irqs(ep);
+	return res;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2067,17 +2083,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	while (1) {
 		if (eavail) {
-			/*
-			 * Try to transfer events to user space. In case we get
-			 * 0 events and there's still timeout left over, we go
-			 * trying again in search of more luck.
-			 */
-			res = ep_send_events(ep, events, maxevents);
-			if (res) {
-				if (res > 0)
-					ep_suspend_napi_irqs(ep);
+			res = ep_try_send_events(ep, events, maxevents);
+			if (res)
 				return res;
-			}
 		}
 
 		if (timed_out)
-- 
2.47.2


