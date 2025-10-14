Return-Path: <io-uring+bounces-9992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F35BBD8D65
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 12:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F924243BE
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 10:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624C42FC026;
	Tue, 14 Oct 2025 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFFW+yLw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC642FC03E
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760439426; cv=none; b=Irq5bdN+QI3AczLfWZIwn5QB7DoKmzf2Fm8pFmwvSHgQD0sHnfnynWI7wJ8t1dNZ2P1tWV4effo/xPt7J/kvayelDDks358EhTmCZLwX5ZebUvJBMf9cwmStJgLtGCK2UeGic9HkoS4Kyn7bbSp2VnExUO2ppdO3UyE2RVTZH2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760439426; c=relaxed/simple;
	bh=sUSj3k8Xp4MvzgAud3dXM9Tg8bZRitDVr+5zq25ox+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMGHk5Nvk+T3DoGcK6aPQgryZ6VQB9CgasJpmzB/MYMoQd2XDFcDdWG1QphjNkAz2wvYtV715Nr/EFbsxIYa7uZ7tiR3U8hd0mMLfr7aPqCOqPIo+jDY3p6jNmBa9vUv1AAUuWloVzJjWkBpKNfGMDMWnkYp03D6b4LFd65EyA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PFFW+yLw; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so43721295e9.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 03:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760439421; x=1761044221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLkdl1JMddJCYXD+7oQ209x2RFanZURwRZxzLVqfzkg=;
        b=PFFW+yLwwOdatfSIcTjo4Q3r4YGfWxfK1PD4cxy/YsRfWGN88sZDZid56je6AKWveH
         kozPj9FoY1BZPuQsovt2LR806bS3IMUp6lgwlJ8g8XJgM4dJ+XVTC2ntVGFk6U8+U1V8
         DVvpKAywSnVA+Mgyqwrtukk240wxRz6UNUeG77x8QMLRE2nKEJ914qv8WGExnvBaJNgG
         WvdIU8JuIOtdvza85eQ84yrAwhmv8Cvo8Rdks/AkL65pW/B0OWoRz4ZlLeKT3JhhWYrq
         IcE+rx5KwjrpqwfajbO4NAyiJ4JNm76+ChI7z/Mqj15YexDQTnYRAOHPVlE9SyAye6q9
         vcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439421; x=1761044221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLkdl1JMddJCYXD+7oQ209x2RFanZURwRZxzLVqfzkg=;
        b=nicb3owASE+qVZegGtGXXnJNnq5o+1gsCINT7Op9xG0V5pvDGenJ11gZXemnUnUeGH
         kRuO9E/aWDGxgUX99dHG5I6YRydBCpVhIuoYRxSK/ezW+sgpSzM28vgb7WljC4tBEl6M
         qlts7pGXPTPtLfa/aD2vKkpiZacQDwlyFU0Yk4BouQtQ1b/2XSxDET0ewYNaGOXkyDXN
         vWiKwiVJNcTOBBaDUil57bPqBGRPQeyJoZlpRV442isowWbPOlrGTJbbpLCY5Emn5cCI
         F97dk4CtD5ZC7LMllqoqInR3z4WRyHvtGDHK+ZOvfhmJqY2RCtcqOySbzsW/PbmYbeIS
         J1lQ==
X-Gm-Message-State: AOJu0Ywq9fvc/racU7mGUbRsdzxSFfrbYk4Kbaze0cH1Vy5gJxNRcjer
	XCgYX3a190Cs/dhOArjwGnrA4J6K5WcU4iqIrLELeWfzY6WZj3JNepSAFPa9nQ==
X-Gm-Gg: ASbGncvwCMLuk+G21XutfC3YQ4nqANhs45FRyPZ+Mg5CLNd8EPuL9LABReY6c443336
	1xroGLpT9XH5npTg/9GuEdm3SV4BzCzumqg3Y6tLFS/g22Z6uPKevQR1DVVGwvfjrLtq7VmnlIK
	mpUM7NqD1V09+nUVml+fBRMudtItaXPQFeHbX71Jkt4QjjKST4NtS+TaFS4nl/XMSYP5XJdxHD0
	wEzJ/bMdynjxWWDDlqiRlvDCvzIMXqKR1bKC/fYEQ1QB3e13SrXwaOLvxaHSNBLYH4w5Ue7QFMm
	bdjimNdBVlgm7lM2AFWcWC20rAPyPQl3QwQjB3k/wEWSU06lrQvznFzuaX5p0ziY+EBtqkAOMA5
	GbL1yXDBNT3NEdd8YdSgADziljPqhmdiFR30=
X-Google-Smtp-Source: AGHT+IHenfyf1eQqszaWtvtjceWck39rt4aBrg1ISbHULyb4nc9+OrgRNHCAHQ+4thXFpo2UhsfpVw==
X-Received: by 2002:a05:600c:3d87:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-46fa9a9ede8mr169839555e9.12.1760439420814;
        Tue, 14 Oct 2025 03:57:00 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497b8fcsm235694115e9.2.2025.10.14.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 03:56:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: check for user passing 0 nr_submit
Date: Tue, 14 Oct 2025 11:58:09 +0100
Message-ID: <1a39321ae5b863708e736d5e9e9ff7533bed7c32.1760438982.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760438982.git.asml.silence@gmail.com>
References: <cover.1760438982.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_submit_sqes() shouldn't be stepping into its main loop when there is
nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
which should follow after all user input truncations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 820ef0527666..ee04ab9bf968 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2422,10 +2422,11 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	unsigned int left;
 	int ret;
 
+	entries = min(nr, entries);
 	if (unlikely(!entries))
 		return 0;
-	/* make sure SQ entry isn't read before tail */
-	ret = left = min(nr, entries);
+
+	ret = left = entries;
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
 
-- 
2.49.0


