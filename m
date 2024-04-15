Return-Path: <io-uring+bounces-1549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B1B8A5007
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61F80285FCB
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 12:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285712A158;
	Mon, 15 Apr 2024 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hdk2Zkeu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A321912837A
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185418; cv=none; b=FOz7aBCHw4FssCW0No6VjhrkFnnScgct3NsXeuTl5H5SJPLYwWgPhF0Nl8v2yGoznGu8Ix97DhE+m6/rK8P2g/xpvp1I3csPnh4NoSwu5IgvNFLjXIiVLUiZQmrnM5RxF8s0kxv89jjzAaMXCnFH2p2bfcWi5CbLtxTG96NMm5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185418; c=relaxed/simple;
	bh=94Jc17uk4Pf6C/B4vHwxda9iIvVWT74MPjsYtIWhPQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOG0C4vDU8lHOyx2LAdPRLMBi7rWhvf0rNnWGGvgVJpKBtfrNdT9+YTxUs2b9Vi4D2tM9C7H1iUzIrGg3NKNjmBuZc2Et7NwquavG9GRgs++iyCTxiC8vJnFyoPUTdr9dptUeZsNVhXNly/lnBkoh+/WqEOqYrQyJH6aFKDxk2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hdk2Zkeu; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-343b7c015a8so2627350f8f.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 05:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713185413; x=1713790213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsR5L+S5IOsCUVE0Md2lTpsSKRF46azdDy//jlaum7E=;
        b=Hdk2ZkeuwDTz+I9voSOjRTolKUI8iAhcZ0mJL/ZtwXzLUapbsbJFAII1iTtyMjXmNV
         UTBjysuYckT+F4T2dfR/T6QnrNL6rtEgv9VF1PUDvErLX41dgIRt0iRnIE43euR2MDXR
         1gnfizazc3fNpOkqxIUl0EqOOmwVZEqmuL92TkFbh3MXGbOIRCVEd6F0mXHdcKK8EbpK
         V/9Tx8DC/R73BQUl2aB55RKIvgQV6Na/dvNon52XwxDQYVp8T25EwHSNsXNXPHrqfEdX
         jQRUWg6QCbd+qG5x28RI3oDa288oc93ips5crFaeTTntdXC8THSr3ed5WZK47Qp9C1oz
         RlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713185413; x=1713790213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HsR5L+S5IOsCUVE0Md2lTpsSKRF46azdDy//jlaum7E=;
        b=wTpQqr+ZJ5ZTDXPk6IqrRscj5CaL/6lg4nxh33YhcfeesYfNskim9iOFvOlsWj/nbq
         n1HE0cnG2qQ/7GwmP1CJGX4QWjANYuxGF4yahsM25ojPDqu9KwhJYFWLga4UL/F/oYxd
         nycnqsiXSkEmrsskDHC2X/Oq4o1LpKFGKSXpQ5bboOo5XlMQqVHwEu7FmD33Fci/gS0Q
         YaZ6EjK1ff7PD785yeyeP7WKW8HwUmoSRCzLE9aCHAx5HfKXLnftKfhZHUOcOtTFjPn7
         hb0sybzVHULYTuEeSaPP2r5c91CGhOo3BpV0kuobghrOM0fI3azn946mNAEQ4oNOngAC
         gNTg==
X-Gm-Message-State: AOJu0YxbqH2dl8r5Hv2pdGriSb706efr7bgXjDlIgp1RItD8RBtcmgch
	tqNVOvNoaXq6oYqfcvPMrknS9be/z6rH+XpK9KWmpmE6CTXwOvJFyr6LQA==
X-Google-Smtp-Source: AGHT+IFgx/7f21KGxyBhwed//edYTzeU4wkHArsCh8fpstZxg/ZZ3XbBlAXBGTmeg2OPuSAf1iOrHQ==
X-Received: by 2002:a5d:6a43:0:b0:343:39ef:53b0 with SMTP id t3-20020a5d6a43000000b0034339ef53b0mr5131354wrw.24.1713185412054;
        Mon, 15 Apr 2024 05:50:12 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-93.dab.02.net. [82.132.213.93])
        by smtp.gmail.com with ESMTPSA id h15-20020adff4cf000000b003432ffc3aeasm12022170wrp.56.2024.04.15.05.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 05:50:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [for-next 2/3] io_uring/notif: remove ctx var from io_notif_tw_complete
Date: Mon, 15 Apr 2024 13:50:12 +0100
Message-ID: <e7345e268ffaeaf79b4c8f3a5d019d6a87a3d1f1.1713185320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1713185320.git.asml.silence@gmail.com>
References: <cover.1713185320.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need ctx in the hottest path, i.e. registered buffers,
let's get it only when we need it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 452c255de04a..3485437b207d 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -12,13 +12,12 @@
 void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
-	struct io_ring_ctx *ctx = notif->ctx;
 
 	if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
-	if (nd->account_pages && ctx->user) {
-		__io_unaccount_mem(ctx->user, nd->account_pages);
+	if (nd->account_pages && notif->ctx->user) {
+		__io_unaccount_mem(notif->ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
 	io_req_task_complete(notif, ts);
-- 
2.44.0


