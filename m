Return-Path: <io-uring+bounces-7307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0563CA760A2
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 09:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAEB3A3A7A
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 07:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A50741AAC;
	Mon, 31 Mar 2025 07:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTpFZK07"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20971E492
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 07:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407693; cv=none; b=m1ZUWo5igceFseJFBalbU0uoXfRYegjmbk42thNiMleOMaOrbF7lO5vLgu1Hl/nA20psPQnIlG++YjZ9WyeWHddl7NJT8Vpl+d87RaAok2ErmLS4HNKrBD6hx8j+VbcPvCbXbsiMsODQ/Ja4wiLcNGtwpdKlnATHFpRG0kGj18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407693; c=relaxed/simple;
	bh=73b5a+NfRy3/5cLCeZCwwORRs74OSsC/h8C4erPURQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gjD08x8uTm2mW3vXSwowbgkWMDlsRf4oSzNvOch4orH/8BWE86Wp8bkNFtvo5DOrLCD3ieBVzH2So/9Zi+ecLgX3ov0UJT9bil3XPvAF3l+LfSYgw6qSjHp0X0c9vl1ZUCVWng9/avNoGc5KyRPL3fp3VZRDRH4kzq6ZxFpBcOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTpFZK07; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaecf50578eso730001866b.2
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 00:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743407689; x=1744012489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KgL3MQD+Fy02a7r8mlxeiLj6ssB9daljiX1Kbz7eF+c=;
        b=nTpFZK07mtIog8onJr7niUfGc3RmWpfMwdcFiO3ijT0gVNYLj4ghYBhls2MIBXLPXw
         Ab7mZN4kL2CBm1Ge2I4cy5rxWclQ16lazNVtrPWYlofcAFd31MhITm40JgtNKNChMMgB
         HxR76DLJiYbaWRVIa57Cqe5tzHc5AFZtKuMENGcnuBpVIw3pH88nUWbBRZo3gQodqDH4
         PJwLfdK3pnAx4Epj5VUw9WIuGrXTV3/D/HjsjPiB1G8iECxkTCLU1sTX/Z3UNgUC778J
         EdfKy8mcWzxdS4YwotxElbqfX/mFXXguJ/4pXBsN0N/FzaujRxCT2tRPihaqJ+3yhTtz
         QIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743407689; x=1744012489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KgL3MQD+Fy02a7r8mlxeiLj6ssB9daljiX1Kbz7eF+c=;
        b=NF2pDDbFx+5whgv4YH4FmQ4HC0s5hQQc/LceNlLfbX0wPcxxuQ03315HD+3Lk+p0h0
         8BLCmuu5MLhjgZaemAkbdkWUOct6/JF9wvfDe2oq+aROhsQePAkwKq/Ym0kj4gkKs2L2
         RXB9h+lV/CPMV2NRayXxO2cRNfjbymn0Nmof6azO8nVVxYcgVPCPIrCtgm/FAga4cCbr
         RFjKUbsuoLf4gXCv4FR8PIhroPDXLdADgWbxeCAHZsISE1UQb9IPHeWUm7ju1+izkUDZ
         kaxgCekHoS24jIGQ3WMMwwfwNwPixF6bOBZeiGkOJD/VG9Tji1NsWojiFeORKUYtYoqL
         0r9w==
X-Gm-Message-State: AOJu0YxVPMuyyXnZs9wCug39bHzJbQKMkVVfZaEt4urcEQdUl2sgOQAQ
	q1okblLGSi88L46DXMST+bVqY7AC3ToovhKAFHtf7JhcoDCOB58lZ7fGeg==
X-Gm-Gg: ASbGncuw3iqe71MMJEP4Hob6E40LHc92JBwvkq1510uGCpgyBQoaeU4Nxe0Vw4VCBrg
	epoQRUeD5gD3WxkfxK4kSsEmsi4KXuVkwneMn2OBs6rE/Y7Y3KbN68YG9TiGi5ldupEg45S6AbS
	i42bYWlh8QZgZ3/adKW5B36K7dnaAM8ky/e7nBLBMC0Gwaa44z7yA2nC7QuW5AL/uMQ619YdmJZ
	2MDab3C7SkwSXRKoUZPUUqhCQtwGsIjWJ60wy6gawWnnq3AIelcaWWiXt61BsKBzXSvn4Q6GQSf
	EUxA8+CdPJS1Ajqe6OVAMuPcrQA=
X-Google-Smtp-Source: AGHT+IF/6+OxwUlmAlv1rqJV+DFWj43u+UoJI2BhbX3ctBGo5ee/r1u0KFJkevCOyLmp5h6D6+RmfQ==
X-Received: by 2002:a17:907:7202:b0:abf:6ec7:65e9 with SMTP id a640c23a62f3a-ac738bdb21bmr667442466b.43.1743407689135;
        Mon, 31 Mar 2025 00:54:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:345])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac719621718sm594574666b.102.2025.03.31.00.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 00:54:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: make zcrx depend on CONFIG_IO_URING
Date: Mon, 31 Mar 2025 08:55:32 +0100
Message-ID: <8047135a344e79dbd04ee36a7a69cc260aabc2ca.1743356260.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reflect in the kconfig that zcrx requires io_uring compiled.

Fixes: 6f377873cb239 ("io_uring/zcrx: add interface queue and refill queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 9e2a4beba1ef..4b949c42c0bf 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -5,6 +5,7 @@
 
 config IO_URING_ZCRX
 	def_bool y
+	depends on IO_URING
 	depends on PAGE_POOL
 	depends on INET
 	depends on NET_RX_BUSY_POLL
-- 
2.48.1


