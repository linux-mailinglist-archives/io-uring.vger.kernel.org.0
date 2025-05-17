Return-Path: <io-uring+bounces-8033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8C5ABAA09
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E8203B1359
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA241E4BE;
	Sat, 17 May 2025 12:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRn09rMf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65881FECB1
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484801; cv=none; b=rjxrMWxkdZiGzcToEairgqbeD07q9SwrMoSq+/sGiQEb6b/mXW6nphX/wc4ej7wgeVSkJ8qhQKRgtPsMKBgIwFIlPuRtdZXQWqNVbccqpR8VM7ek0b8sCg/UgKgqGWJ779JDJO+sRdnYik+8+OVA1MuAyxfUC3N/3sszgqxWD5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484801; c=relaxed/simple;
	bh=kXn+2m9u9lXzyJlCNbOAXxuoSutcUczVAp5Wcn+sws0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKSSzFkePP7x16TMHxGoGTdmnYv+xSX/xXIlPJuIB0wBQOYYrHIcXoAg55NfwqYE1yCnXYOio8cZ6bSgLRIuy0UT/kAmrWF3esnqnjv1s/5Tvx5CSy34HcYE6vR4SyUo7GjNjqqxrr0qIlJyhioNnfNXPT20ayk9ES7c+L5FXLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRn09rMf; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-601aa0cb92eso300750a12.0
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484798; x=1748089598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQQhbGK1aR7BgmvlGw0fTwctJcflHAp85lIJWFKv/QU=;
        b=HRn09rMf3X8y+DlfpNRG0WDzH3Tnq2F+0FW1Qk8+YqH5W3opz0V7vdZBClP1Y1ZkGz
         3kz3GLu/QKCSJdv9SzQP/0L/8clmL3PeQ/ym8NcFF/6gZL6KkGSwijt2leDm4XPx+CRx
         niU3zRSJ3wceAheIzCrcbUv/Z9JL8Y1ARVGyITRF6T/5fk50JAx0+7RmnETbyMAV/J4H
         sG9Dg1oO0QhKxvIEzXHPbzS46tiiapTp0HRGDn+5ZGyW8A5rH2JGpEtrw6eRujiavKWT
         3MsrJSmSBoc8FnNo/nM09RIClCrEmz/ITmS4iZOfQWLHoxqA4fl/QM+LLS7h11aZ+Rm1
         oE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484798; x=1748089598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQQhbGK1aR7BgmvlGw0fTwctJcflHAp85lIJWFKv/QU=;
        b=ELNWH55t1P9ABNoFbSi8DzYMTjpIeSQHeS6pgTh+AHpNMD+/tYQb7wKhTMfB+LFZ4/
         B+c21tGZuNlz1CarW/2hUO7QK4+da0NkkjsmdjrDa6C+ZWhRYz1cVdSHbUZc96CsaCrU
         LK2+Vv8stFuEdWz4K6yJi49Cei5GGJUc2llTX95PleSqHdN4SE1cEbmwVvSE9CFDaDdG
         NeoymB/e6Dhu3GAB/QnHvf+cLTJu5lg7ctn4t7cPV08AEiC2+LD7ezWRLgAktFHfjNQs
         K3+zvbA5O83Bg0uZiCDFpMl/j6Emnu/Er+fOu47W95pmytbALRJ3efKwoVN2axGVDEY0
         o/2g==
X-Gm-Message-State: AOJu0YyKaFakLa+g4y4uhQFw22x4Gwf3Q5Jfu38N5XJQatfm25SRwelk
	tRuKplaBgs5GNiw+k632YNsAdUKE57w/un5e3YeBGl4ZqpHN51uyL7z6aRMsyw==
X-Gm-Gg: ASbGnctbidipmCL48NF57dD2hox5MoZzBHbjHl4gVazmQOxL7GAJ+IsA2farmuXTLfj
	I4phuEMLLrh2+t02tpEwaGa3CSbW4FSxGqkNnOAFQEzPWePZFTa7ht5SsdMSdo7iN8wMLkEL1yK
	3XL8V7mXoLbjW7tuAwCEr+f6T/Di4zyw4q+6VknP0UDFY3YWFj21+SegTgqayTrH3MhiY2C3ksy
	T/AxUbN+WszeqOOAH2FJ61TUL8ypYx6j7MTlNvmvhM0XHZpsGp6bwignL/iBegSgYN118zM5MHb
	6l2hhscFuwpvODWrfWDECxxF8sM/1q6MWOkAmNbQaKGzTsVbNntkcNI5mcUaUqw=
X-Google-Smtp-Source: AGHT+IEETARThoFd+6wPeq4TIGg85J/NOb00RnCdGVxKJkGHJtwFJQ9RG9WtCxLWWPohbFQcIJ71Qg==
X-Received: by 2002:a05:6402:35d3:b0:5fd:2e33:fa49 with SMTP id 4fb4d7f45d1cf-60114067fddmr5210129a12.6.1747484797609;
        Sat, 17 May 2025 05:26:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 3/7] io_uring: open code io_req_cqe_overflow()
Date: Sat, 17 May 2025 13:27:39 +0100
Message-ID: <c5bdfdd12d7547aa678615ea3f3df929154dd1e0.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch, just open code io_req_cqe_overflow().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d112f103135b..fff9812f53c0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -763,14 +763,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static void io_req_cqe_overflow(struct io_kiocb *req)
-{
-	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				req->big_cqe.extra1, req->big_cqe.extra2);
-	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
-}
-
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
@@ -1445,11 +1437,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 				spin_unlock(&ctx->completion_lock);
 			} else {
-				io_req_cqe_overflow(req);
+				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
+							req->cqe.res, req->cqe.flags,
+							req->big_cqe.extra1,
+							req->big_cqe.extra2);
 			}
+
+			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


