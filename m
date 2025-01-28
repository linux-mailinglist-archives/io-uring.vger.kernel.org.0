Return-Path: <io-uring+bounces-6156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 089E3A20B69
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68E86164C55
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF9E1B394E;
	Tue, 28 Jan 2025 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="fufaeNUN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193AC1A8401
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071585; cv=none; b=KcTW4kt4YX8o7U9FMzRh+i84D7zZnadDocUXoVpPYxhwG9FQkE669i42wix56awEpA06motB58jBhMqMtAHb4whfldPH2yzjWUJeBAQ1sGRAz050hkOxcYpoQTXa0WKlszRX/FONuO5wJHwpRV4s/cIQ/GCO9J4Xvo2YJ9RBjiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071585; c=relaxed/simple;
	bh=8YwoeVS/XmIWopqyLGAYx78wP3cqW3SI6yiDMS7cgqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1JjhvDwgYJg1yxviJPPoggEbKLCa8ycstquv2JM6RM9QZg2HhIDAXCk14ao2uS4AAwdSGPMb+QtA7MfXyXMapoeQN40wGEE3+K8NDkwdV1sblyjsGLbQnXM1H+3IVvc+wALHSjqsEMZnatCwDe2RpsftABW7WXGCKs0iIesU4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=fufaeNUN; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38a8b35e168so3644979f8f.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071581; x=1738676381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8ARVoEcuhaiyy7y8Dw3Fh+k6qruQ+ILlqwd0Qs/TsM=;
        b=fufaeNUN+R5yDmPzs0Ok6sn/vINkAu8P/DIB1csZmkax2fV5fZhiDUxY1hM2Oj+9Bg
         2uvMUqBt7d+oi0dBabSMVoDE8Jcsav7xJtp6MZIVO/I9umY7Fsp2p9ZZnRIQbYYz1dsN
         GHxfx9n66iLu2qezrJtJ6rCxBv1PabhsBXpal/YhVHbsqewzcbd1sQMqm1miPlcQHeMp
         TwQRLZhvp8TKX5g0i+dZX9d79j7i9XjaPKDH8yLpNPYE2FGOOX4RSBLc9IACdqPgiBho
         GqOiIr792JpMKiVwd+kOdmxZaU1enzS/uTePBegMcQiBXCxWyej1iHS7Mm7/PWn+K64H
         elyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071581; x=1738676381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z8ARVoEcuhaiyy7y8Dw3Fh+k6qruQ+ILlqwd0Qs/TsM=;
        b=M9cpDh7uZ3bMBOri6Am6Gy2BbGgKLci8SHK8cu3tCFn0VWFDj9lOtmrlkTgNLf6Uif
         Q+jWjymTnxnHrwuZRO6ap3MsGAVOXmYnU1WUIOrr2TkitHY3fA1NyQrTDAxzzjP2Fx4I
         9Y3EvoiT/6KoA9GFgXXCb/OD8aDyLFCrWUe1T16+tCQraQFtbS1XtFk5dF26ECH6tBn0
         829kSXsM2xrJqGX/bIBE3xcq6jGkVh1bttR3bRTdq+kGu7gqTnZrIwgW4LERBBYkPjhx
         +vlv1X6BXBbfXjRmlV/hD3A+ADVZxA896TobaO9q/wYEwH1zkBE7Qw/Uffx6n9VLxaAB
         I77A==
X-Forwarded-Encrypted: i=1; AJvYcCWfH1IwqkkMuOQvpWC/5nMDMAMxB/u5RCrZJzKJ6m7/sWVppxjoBP6YJmNopZNOfy/6kWOmbQ8A9w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6FW0dQSfCNoiLwN93uvXS0HScy5kuJWUCgtMfTRT2m1+IcTs4
	hBGJjjHFD+WH9W39tZ2ipscumGg7Ngn53dQGNnTLysGgHTwLYW6PHF0xxZB3jcc=
X-Gm-Gg: ASbGncslRyMtVtZezh60cBEOKDE3cimes1UynDH95BRWsoDpCuAbyosGhjBsmJHMT7y
	1lBmHiDN3FrldYr3/PKj0p1HakKkPuc6gzH5ZHaBx1qgmAAjvr4z9y+c9E7YGs9oWLgeCca6oEO
	rbzuFjR4xYDESMJ5wtDeG0boPxUk1HZhYFuPAuQ0M4M432PrufhKJCfI1Tl7T6dzNRUugyZhWNn
	RvSM5uVAMPzxjnVftBvC1ak6xKNn6b7u+lmUy2RKlyBTl6d4wsi85AY89tPRQ4s7DE9GmziwAvY
	bxi6PEb44COIs/aP9U95Dcg92G52BZ+u+90T+U13hIOyreVGfQluskcuH3SpoM8na9XjLwVxb6/
	eIDW8G29JmmooNbdfsgtSBcpUQA==
X-Google-Smtp-Source: AGHT+IGul3WSFjDA3kUrmEFfTfFX20BTEU/HgvE7YsOUr9tBZ+dCaFW4q6pwq1qDAzOy8oJKT4N7WA==
X-Received: by 2002:a5d:6daf:0:b0:38b:ee01:ae2 with SMTP id ffacd0b85a97d-38c49a27186mr2274103f8f.10.1738071581332;
        Tue, 28 Jan 2025 05:39:41 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:41 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 6/8] io_uring/io-wq: pass io_wq to io_get_next_work()
Date: Tue, 28 Jan 2025 14:39:25 +0100
Message-ID: <20250128133927.3989681-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only caller has already determined this pointer, so let's skip
the redundant dereference.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6e31f312b61a..f7d328feb722 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -485,13 +485,12 @@ static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
-					   struct io_worker *worker)
+					   struct io_wq *wq)
 	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
 	unsigned int stall_hash = -1U;
-	struct io_wq *wq = worker->wq;
 
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int work_flags;
@@ -576,7 +575,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(acct, worker);
+		work = io_get_next_work(acct, wq);
 		if (work) {
 			/*
 			 * Make sure cancelation can find this, even before
-- 
2.45.2


