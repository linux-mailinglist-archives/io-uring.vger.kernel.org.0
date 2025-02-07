Return-Path: <io-uring+bounces-6305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BCEA2CA4F
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 617933AA913
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E156118E050;
	Fri,  7 Feb 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IEsG3nTz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4831219D89E
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949806; cv=none; b=CsXUktko5sq37MA7B3eX4LbwK0ssPtdQEuSA2/Tjo09l5NxnVQHpVutDEPz4wK5LL9j5275KFlUJXProSX1U6EmzYbf6hatR1/cdtJO8EK43bFQe+9ZEX2bADxeLYcm3hKpITLecx0PlKfkISiLr8/olRkQSu70h9DMEbPl3XcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949806; c=relaxed/simple;
	bh=DuDffcRazxoqdMbIXpn7+EyJfMiPkF/egp+v1oEJbYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAJfHUgb9FrQs5hRadFS5AunF+mO/3B2BiQf9JjthPFDok6tIG5MuO2CthBg/63ollb46ykqe+4uUSovI1Igrd7pqfV5+lL14n4D1tCbv9jCSrz6rlYEq9CqWryY8VYHL0VBVssVJItr5asW1KjogLMMkoiipNPq1uzCwj0wsv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IEsG3nTz; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d03ac846a7so7375285ab.2
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949804; x=1739554604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buVgqb/rrfd7qjVWy9KC8hfJsXJN99hoK7Ry2+u0vJ0=;
        b=IEsG3nTz3F6aeEo9oDmNacLXyXHNlV8rDaMEhSOWiPsvQa5+/CUoQ5NyXyJiODPE4A
         5DHhfHJ3zPHNwbYisRm1PNZ9+szzsgO6nmUJdnRwCezhAV6AVenua3GwxmdEicVjB4sL
         Y/hOLo1Ru8ia2NEx0shLv2RrUDsDZMpfCAsZ+tRYtPSUsb1h/g89DbMHsQko5nyU1meM
         4Ed25Oy6DXxMepYO+tO4kNa5tB6qZ+APY9U2BZxj9TGmpA6qcr6SUZJCWxV+AreYddX8
         0R6J9va5icsPROShVbXbJGiTg5prHuG8DqEZsfM5QgtwQtveXS53nMOOSkZc26xV1u3T
         9ehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949804; x=1739554604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buVgqb/rrfd7qjVWy9KC8hfJsXJN99hoK7Ry2+u0vJ0=;
        b=KYL4cwyCcqeakmDxjs0MD/RVgRpt4HtorCkxvGDuIMZSTb5dyN1tdqjHgJ58kpvIAt
         C39ramdg/MEo0T5dphHE5BJdd5ot9+3bDaBxPVUYmRD0FA59f4R87tlVPGqYFgdOxENW
         Ucsnjux4bz/uAJJaXpQWj5l6ZdnuD4mw7jzixbB5lsGiwBqhA/rMSuDwGIkCh8v0JjwE
         5Nm3Lf/gt5swsud9yeCz5rqeIRgfEciWL7c/xOejmuOsutc7O9pP48jnlCcTGtkwXgs+
         mHNM6n1TfXaOtl/0wE60a+ToG+qDd4X40aNJJ5R6EsZRNEors8X8CUcHe3aq3Do3F/fQ
         0oPw==
X-Gm-Message-State: AOJu0YxM0v1A8Ik5JEp0dMIJxu8/EqXc8RUH4vI5VzuthBT54kDYmIkx
	nUwk73L5aabZTisp7cYrY571n7Etj3cHB/DRAVTn6prOlFd6FmhQAm6gKVKnS6lj6WuK8XKBnyg
	5
X-Gm-Gg: ASbGncvd7nOTCJGjfz/mrWIjkOJpZKOjWiiLgilrvNdA2K239RpuJNOk9ic+AyG/Pvm
	9AKI+cBERT3qdimMbhaEthzBNrm7nm5zAfqwgLwEZWKZunf7izfY2jI3ZNOw5eMkoSgKyGexNA1
	/FKwkCACnUJOqjsZiOGjOL4oMuYINoqtIsW8QGj78ziy53bRnaeRK8bEOshAZM6Acx2nRGXSp6w
	C/RC65bvWaKbp9wVm5uwGoqLyckrl+n+cjz+NJO0UPNkiXiEnmWesW+1SZ4db/d5Cp+umHPyM/6
	j6sXvb0kZIQjjN6fEgQ=
X-Google-Smtp-Source: AGHT+IH38njmpGOj3YxkEMJe5TX+OtPLNpsOMIhwPC104gcD+CbCCGR51nFfPMBz+iu5SQLer100dw==
X-Received: by 2002:a92:c241:0:b0:3cf:c85c:4f60 with SMTP id e9e14a558f8ab-3d13dd4ba6amr31410065ab.11.1738949803847;
        Fri, 07 Feb 2025 09:36:43 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] eventpoll: abstract out ep_try_send_events() helper
Date: Fri,  7 Feb 2025 10:32:24 -0700
Message-ID: <20250207173639.884745-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207173639.884745-1-axboe@kernel.dk>
References: <20250207173639.884745-1-axboe@kernel.dk>
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
index 7c0980db77b3..67d1808fda0e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1980,6 +1980,22 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 	return ret;
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
@@ -2031,17 +2047,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
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


