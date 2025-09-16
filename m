Return-Path: <io-uring+bounces-9804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC00B59A27
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E9413B24D8
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE6432F77D;
	Tue, 16 Sep 2025 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dan87C+t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542F5329F05
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032815; cv=none; b=mvNkFsWd/iWhlI0QidgdoL0P7cMW9FXxWffigKqXMYB1k8FMs3H8B+CyZh1lwf58dwiSDIBJeROQWOFuGVoDOCUOPkNTFtvlYujlJcPG5Itvyp2cP6ikgBQLYKLI8cqikQ1lavWCrme6j7vZemdekqt3URXK+e77WDc5CcEdD+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032815; c=relaxed/simple;
	bh=g4MftbRK97uaPTNqkfHTpo3XTx2Uokw8lxGpAx8oc3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKDSvdm6iM2TUCpiWARo1DJ3THgJx+1OvwwumTQN6rcvBAqXRWg6HimaXLgfO0QG5Ro67JY8fp5XxvuhXRYlbvSOLJZKNi3EH8Y+meNRwOk9G5JlCWYbYalUesmbzoPifuUkBA8iJjY1UUxBLYGNKnVtrpwQX2lwq6vXj/xw8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dan87C+t; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dcfecdc0fso55562365e9.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032811; x=1758637611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5mPB/ajlezba9OcsHXolpRsK04nUVrxLVFQVFJ4vSE=;
        b=Dan87C+tNj/VwSJ3bMItpMMbTpShWGSXZKoUdPn6/3SPoCybQ6w4ZrNWxn0OzdFJci
         Tln+BrjcY8kndM1el+8sDkkjfh7YDw1poowtEV90iJkmKdRNkNUd6pEveayhVjpepXHQ
         lkKMcbrBYmWRbVTRRqBkfK2t4t2hZB8H0qPwg4/F3NY+im0GOzzQ/HMf4gYgLEzNmEpK
         ObcrmHit56T9aEE67A2WHFgNwKlH9uL3O7TTofx2OoBg67RUzWjA77lBRRijYCvQ8gaq
         fe3WaKtLytAMsTUtHjeRZ1Bwq4+5VXBmZzjvRgPTjulWFjZ3J6BSFbQD1TvCpz0hZmE4
         CA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032811; x=1758637611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5mPB/ajlezba9OcsHXolpRsK04nUVrxLVFQVFJ4vSE=;
        b=KU4IWU0xSTl4/vYuWhvhUDv0c+ye3n1AKhW4N2ER60Kkukyd/o7Fua5TO6QRaJMFCT
         rzAJcnLdZdSFIjFrkCxzWJcLPFaMm3K1Tmeadv+Q1ZuHuKQf929OxRIdN33jWSIuRjrR
         O0n1V7zn3xyVsoArx5CzuJ6BzyNhQCCUTmM5TiAsvELpfDjPQCOzMaNVivU1s4Zcch20
         ws2dtnUAKFQCrHEAyW6/jGxfMtCnNIm1cAaU3C83bxdH7XCUeLZ8I2QFFs1u8kva7Ndf
         cPKRDms+is0363mcAcp6te5TPLkmeMwrWhsn+px4yVEUE32WgzI8F3SuJB7ULRxetCBo
         y0jQ==
X-Gm-Message-State: AOJu0Yx+VjhhMOVg5tAnlOhGAFTD0PYK5bQxFShN9wYxl5CYp4EhvpAs
	g0awnEBus0mzUpQBVEfeZQPFJPZtbkJhf9FDx36o7AmBv/8R2stCb02cJb4rjg==
X-Gm-Gg: ASbGnctqHyYYt9zwrJkUshwrNRilFchObgSyuVR/D88FCmh0gZQasMJbhx4maCQUwng
	wUNhLuikUWwjgsuhxPRdlsuXkYsmQVqKuMgSKhhO8P0299xeCfd8RKlUkCHLYUVdDwDS9Hi4qCF
	ZdPYDquOZDuoDlJxpw+fDmUIbC6dBmFZjw+xUZFhNOtBwzTzXFrPxPgGH/NXKoCJR0AIsv8m2C/
	gXZPmsJr/6Eattv4HG1g+e+AcfGkuHpg2/ixWf6MJLG5Q7tfY74o6F9CwExzKG1B2XEhjrTXH8g
	wl3Gzfn/KAUOJjXl05N6mlM+c3N4wIwXlkwKh36HzOCcNVcYNAurr82FMZQqu/e7qZ7qcYWcYvN
	edpBhhA==
X-Google-Smtp-Source: AGHT+IG56d3uwFKHBHEKA0hRQ/cEwgPlxlygLDJb71Qrd5b5Nu5WaVkE0Bo1D9KmfENJ2iet0EnN6Q==
X-Received: by 2002:a05:600c:6549:b0:45d:5c71:769a with SMTP id 5b1f17b1804b1-45f211efde9mr106819395e9.26.1758032811095;
        Tue, 16 Sep 2025 07:26:51 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 04/20] io_uring/zcrx: remove extra io_zcrx_drop_netdev
Date: Tue, 16 Sep 2025 15:27:47 +0100
Message-ID: <651db906a0c3eee7e83c83a9d4edd6260c0a4413.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_close_queue() already detaches the netdev, don't unnecessary call
io_zcrx_drop_netdev() right after.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index bd2fb3688432..7a46e6fc2ee7 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -517,7 +517,6 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
 	io_close_queue(ifq);
-	io_zcrx_drop_netdev(ifq);
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
-- 
2.49.0


