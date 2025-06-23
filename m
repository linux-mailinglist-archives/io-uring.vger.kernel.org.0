Return-Path: <io-uring+bounces-8449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C6D0AE3D99
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 13:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60E253A8582
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 11:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EA523C4E1;
	Mon, 23 Jun 2025 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UjfwSRV7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B323BD00
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750676555; cv=none; b=uuFVSGg2GX/4KwXl5KGs54Lq3ynJrsnXVB+lNRDuw8olRtDgvXQ/hWgOuJTz6D5t/Dc8bIc1ZKwpU1GUWfSkxbxcN5kIb0QHwx5nXGyhBFE2p0QThNf2arh3dcAwzab0sBocCsDXOFwxH3nVqUK7mirRRp80dEVX6NkYuLFkXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750676555; c=relaxed/simple;
	bh=b2FlwlmwI8Ta/m+zsmjbwyxaodM8DzvE/GhS0xD637M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UklxOfszuK/xhYVt5mZ2tVwjrDfkcTK8NM0Ged3bnah/a0890PBhJUZY2Bb0pPUF92hhOSHPcfne505iLIWLWMsPQwG9HkcNmyrZbJ+IPFuj6ypMj7ZU//9nBmarWYbET+G6RUlH1gqmiuNa9+nUKudOMFIAUD1IeneUnIKm9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UjfwSRV7; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b31d592bbe8so2717931a12.2
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 04:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750676553; x=1751281353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0EnuGd3NMPSPvhzdHaydDIkxTdKBobdsVJtk0rKvM4U=;
        b=UjfwSRV7CtiPu62ZA6jA6CAAGxCm93p14wEpB3NmZUSZhYWCs2T3M74zzqlfNMGeIb
         vwj2HnQuYi1OSReJ+M8MqZiEiIP6h9xFzQ5ET1cIqZVoHe78ble5NMG6MYl7zQ3XVqKC
         oOoYeseF7xZ6kmG8BWdTSQMM6UQVxxY+wU7L2rUxKbG6hwoU22bFxU2qXvz6UdkxnES/
         i1FeT5euWypwCDyTUf3eUKGW1ogPvaZD3cUgKOMJuEBuin+Lt4GlgHZ8mdZn5AgNFjSC
         uerQJOs9Tt+KEH9kNGVkRWRNRZAtcl0xk15+0plJw3m/fLaNqXMxazPLr/qlPQAYtWOo
         FKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750676553; x=1751281353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0EnuGd3NMPSPvhzdHaydDIkxTdKBobdsVJtk0rKvM4U=;
        b=UAkERSVWanm5zeZdbkbsCcfd6MYI7Citm6T9skT8/ODnhUglN04twCs66p37sYylNF
         ILfQvLm8cNoPjpQtG30smSj74uDE85tzS9X6cn//Wxi5Wr9ocUEmENOWXNWDYhZv/pvR
         PmicL0gs8rzfxCUDU9xaklDrk8lyDisQJ7lBFXj//+Gyqkwa6O3jCzKWV1GLLvVtp0Gm
         h6GS2HrS6YihI5LyUFE60vbDwTLs09YUE3AtfOtMFPFAQJIDMmbZDL+lsrVg0aq3co0A
         xXQpKXs2WC8ZY85GTXQu7e8c+ukA4YsEeZPBEQAHiMpZCqg3YlkUsEPDgMu5Jstk9U8g
         u3ag==
X-Forwarded-Encrypted: i=1; AJvYcCWHV5BEtu94djxLTZ1EcmUh/CmboXBBLBP10PkMR880j5hwOmHxrL4AA5A6g/Jm/qbpzogVsJm1Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnjSPNKyoeFlTGhWzv88ZGm3tI3AXtihg35qguxNuKomLdQI6z
	zTOfbdveNq+6HaUhKzN/ARYRp5AfQq3BOQpW9+2jQmvGlMYEd8zMNy0OPlFXDQTMVZk=
X-Gm-Gg: ASbGncse7j86O22ScCvZR51UcPXhXDAeovETn2uycQo7ubM08oLBEvc7PodkV7dBpEc
	tGjiamTgUATKEBwLlNFV9ByX6GJbYuuEDcZDVwHeDGaWjS+7oAOu+fWMqgTlPf9XK29hkjzpdpe
	FtKifiREZFGc5rAbEzuw99QYRLh+aEg1fg2/EG88XE2uBNNFAcdDMm+brUCem6H2ccn0HGfLKOt
	K/Dg2Uvk4u1I7TtMchZ3cS+0zza/bOQtC5XqTDd6m0HGP3wlJjQiYxjb5pnOn8/DK4CMCtuT1Lw
	fs4u2G3+KIU7/vuaRmc97oMgv/Jqx60fTvVeXMtDx0rsD/WgKOtVCs4YDqkM5Xv76LXnnftPZ04
	XJwXKESlMUkloDkXicSObrivv
X-Google-Smtp-Source: AGHT+IHDPrK43ttNxr8dk5F5FT3SBYOjjSRHp4RI8YZvVu0X2ZUOd8BOFRVZu/E5VXaiy3rn4xrTGw==
X-Received: by 2002:a17:90a:da90:b0:311:e8cc:425e with SMTP id 98e67ed59e1d1-3159d910123mr14251491a91.31.1750676552675;
        Mon, 23 Jun 2025 04:02:32 -0700 (PDT)
Received: from HTW5T2C6VL.bytedance.net ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3157cc19bbasm3970913a91.1.2025.06.23.04.02.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 04:02:32 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] io_uring: make fallocate be hashed work
Date: Mon, 23 Jun 2025 19:02:18 +0800
Message-Id: <20250623110218.61490-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like ftruncate and write, fallocate operations on the same file cannot
be executed in parallel, so it is better to make fallocate be hashed
work.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 6e0882b051f9..6de6229207a8 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -216,6 +216,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.hash_reg_file          = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
-- 
2.39.2 (Apple Git-143)


