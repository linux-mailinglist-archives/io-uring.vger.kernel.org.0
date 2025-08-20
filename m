Return-Path: <io-uring+bounces-9121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F54B2E4E6
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E9741CC245B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799B42797B5;
	Wed, 20 Aug 2025 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y+fwD9sU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3245B21A
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714383; cv=none; b=SiNNPIMq/CUhyB6g4sm0kK3g0AX8f+X9L9FMKxHVaxwCMHn0ClhjOEEtS12bNPjEj2jQIt4lnNQBYSfPHkZvFopPcgV76dC3iFQHr2zvBWd8rSJKDPdSFqBIznXgDAfl+VsqVE9IGFmXG00zJ0BTGb8MLK5Tkbxc0iHiSiEmMQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714383; c=relaxed/simple;
	bh=a/R2HNNouPv2W8y/0CWF/5DQ5C29kYYu1PMEveML6fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I44s2+OVzjcuWMglr7I8Z92IhK2uPkIuh/aPauS2D5exzlZiMtqgvprae9Woc4hXANgWKv21oI/K9MfGdQNuihn86TZXlRpeD4RMhSCMT6IlMBn7yjvwN8gh6z/MyCLinM3kDgzW+H/HMXQ9SqlObqOlTZC2Q+9P6Gi9GJ4Ovzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y+fwD9sU; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e57376f655so1017175ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714380; x=1756319180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9qoEQauYmXR50CmZe3eNlG2zbjgA3Q5M9zPoB/NRh0=;
        b=Y+fwD9sUqmY0nHQa0j43bw9tBoRjQjAdLFi15YFUhX6QQeoIyxiuGTdgDQvO0lIJNI
         kG/ei+1u/4qO1rQQQEH+Fe/y9QsT0DKQKwylXqBoYjTgrHOYGW1687Utw7xL1X41vDR9
         fNj2GID5J3+Gez/Y1PAWbkKMPxHI/Q1H9zHfulpsgtf257Wppbxrpph2RTGNMrgnIM27
         zkzkYFEzExGjZ/UyFLjM7O1etFArW1PahhgWmbGLctS5LDq96FsSoocWRw55tYk+xav5
         NjAh0Ul7pD5MGQa6l7NYv0q/ny2t4HDcFOHCYI1k5qwY4cbSYspWkABaopxpKr9arYev
         FwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714380; x=1756319180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9qoEQauYmXR50CmZe3eNlG2zbjgA3Q5M9zPoB/NRh0=;
        b=pF/MDei6P/NBztyLLLPNyoLEq/uzPFc/dAN3Sh7WCbRBrE8kR37ObMtmQHZoItIrWV
         zbdO2poxOL2NsVAtT0luK3SvQCfnNDEkj8v6/lzAVntVpOR424ZK8uG+AVwFaO/I/PHF
         UTPTfy5hvwDQzN6USmKeTEQWIgvcMBltBp2V2XljD9wpJua8B0NtDC7Gt6HRqU4nK9wp
         KT6aSg+7VDJhX0AODIwgssb5vc+vHY+u+krNVenz5Zx9rQwYteZKDqhEj35J38P5NdXj
         EpH6qPBZUjBy7vwmJS2XUutbQKOOrvAPbzhX+z8b221hY1ORB8G/ghdQmJuc1CpWTKio
         zecw==
X-Gm-Message-State: AOJu0Yx832op1gFDnlBTzC7bnmQHogDcn6YTB9DDynHUcxMSjls0/4IZ
	UK7SfCYespQM8kOkafPEIZd+cUfhEx/3CFl+X9nFKpYFfQlPZeu99/eFimIFZbAngYiefMm7z9E
	V76EJ
X-Gm-Gg: ASbGncsspTJvSrQG4qPjMAseMDPwX68M7ZQq41CtqkcJjSy/pCGXB7jQUc49caA+7hG
	nrp2Jou2c3fU5Jo2eW4RGXDWockLDwggObs6TweNwj8Lhyw/NnUt6DO3kgmE9A7KPV/1SVXbsdU
	qpmKwKoZv986GYg8WhKmMhBSLcGIJmc6iCNFQ6khi+HDhGuXr+IaU14amapB7bGUCGs4Ws3k3rU
	9FzJp8Spsctv8ndtCXlkDcyMUnJoHOmGW2E7iWrZf7DfkbZJiLLoHcMs3/qKbX+iqeO+UkJARVu
	LYJ6+xLQp22MD4x10MZX/MCktBELE8OpADDzfO+8cankguiB5cCbXLMbgOhlezMYn9gL20kueUn
	1Xi0lig==
X-Google-Smtp-Source: AGHT+IHSshHoW8Y+Xy4zI2AruZhuFIlouy9L7gtQ/TXm4qxMwyDe3r0Mcehs3TEibVbwrC0uZHSaGA==
X-Received: by 2002:a05:6e02:1521:b0:3e5:6a2e:e3bd with SMTP id e9e14a558f8ab-3e67ca22de7mr68369895ab.15.1755714380175;
        Wed, 20 Aug 2025 11:26:20 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring: remove async/poll related provided buffer recycles
Date: Wed, 20 Aug 2025 12:22:55 -0600
Message-ID: <20250820182601.442933-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These aren't necessary anymore, get rid of them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 --
 io_uring/poll.c     | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 37d1f6d28c78..53a500397d36 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2025,11 +2025,9 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, NULL, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, NULL, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
diff --git a/io_uring/poll.c b/io_uring/poll.c
index f3852bf7627b..ea75c5cd81a0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,10 +316,8 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 
 	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, NULL, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, NULL, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -686,8 +684,6 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, NULL, issue_flags);
-
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
 		return ret > 0 ? IO_APOLL_READY : IO_APOLL_ABORTED;
-- 
2.50.1


