Return-Path: <io-uring+bounces-8958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDF1B26A01
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 16:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5824F17F6FD
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 14:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644E51DB34B;
	Thu, 14 Aug 2025 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PK6/AJsl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8361DE3A7
	for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182388; cv=none; b=PZcFtCH6dkDYzONvgLj9DFpWlgYLsPdvlKoxNaFIXYD2qP3rlST9+9yky/8cjdQaNa0SS4Rr/4Ijtzd4t2qOK2qXS4MchqWmz+m5nKepdzx/hn45JYHyKiHVdXJ/j9YHdfHaDQjJp/wKCnIeprH8DL5i57EH9lXvoowvkJlKXAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182388; c=relaxed/simple;
	bh=p747GqPQ0Zn5jGaiDjf75QtVA6/uGpORvb0Zqf3oILU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T/2LYgT39GjA6E/A9B0cWSF4ickDrdSk63uqLY3drIsBclt4bMlJI2MNAyUHhddMi5cxu+Z1i+pI34DzmfQb9ZkjOb/PtitZN5ueJe57zVNWq0bwqXVvgKW5ttBmbmzCLyYySSM0jLlUR6VsEEqMj5J+06RF7g9quruAbDw027c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PK6/AJsl; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9d41baedeso569157f8f.0
        for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 07:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755182383; x=1755787183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yh9fDdAXYwfqEoJ4heT/8UDxkiOhRbVALv5PV5fdYc8=;
        b=PK6/AJslMSlEvGzTQ6MShhfjrEbtx1PX03sjcc3FwdEZLo8i5cuu91avZnkU7821S6
         81NwES67pdpG9OVn7knw6JOPljZn5Z4Iw3L4oeswrDfcUMj8mWj2v2mpcll50yWcWs8t
         eR7R1MHljBjes0/e3eEMOVmHxRbFzQ0YL5oZCUtaGX2KX6bNwzdHsKWkQWtRqtRpcXE/
         CEPJQeLp7V7dVuXTo3PpQU8prYJYN7lgWmKLy/mfocUHBDEvcz7TSUtqMSfXbh60PI04
         SRS6p6OoYZEQfWx4dmgoWeCBYVCSqfCDobMFbCPI5QeVwrqrklg4KwnRWm1DtVNccHFz
         pM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755182383; x=1755787183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yh9fDdAXYwfqEoJ4heT/8UDxkiOhRbVALv5PV5fdYc8=;
        b=l67WujQxdSboK1k18RfoXs50ML6xo6Q6v8p3aN9v6V5YIbFoQWQZSbWy+nHsP8j20d
         +nQ6PR+HFGjhy3rCPKBTp6zNmavhygX6mHXDB/QDfBUAp7FJwEyQNMeV4KP/hFanQwJQ
         oXcNgVh8pmudpggOHQobmriUsFtFm60ohIn7Oyp5o+2l741AGnHAsEse5YpzM90TU+u8
         y6GbiGjb3gaLnHpbugjyR/wcGGJ04FsCwRKy5DRTiPXxRiiuG8fyMUoA5O+VS195Vrs1
         pK3L4JRrB1euybRuu3sZs7MgK5Hv7+f+GVa2LZXyfxiRkZFooFTX4uMBYspHCDDH5sfz
         T3BA==
X-Gm-Message-State: AOJu0YzNjMUZ6wFuFV3+9N84I3UAfO4C7kPdpeffG1+pzWo0AA0z7DcB
	IcpuSOGOJqLqKTIlL5uDVR2J3EshQeVVSWzBtxNzdMI0wn09In1N7o/9h521qA==
X-Gm-Gg: ASbGnctcHZ66whoLzTGltUEynR0whMH5UgChTv9ufhxMv6RvQsBeoJsMeFYy9Ko0fA3
	CFzPzpMsjjZv2kki3JKafOEiH9U4Sq2KvDGPNMx/E42WxtMCEVe/F37dOZ+JTKdK/RWMXpO/sQb
	n+mz3/YGPdJ2DAfmiKoUUvDfLUdQuOWX+guqywH488OVbQdJhCjZYoCIzcdPpa6snZZLX6HLhgc
	Zs/Z5ClzQ0Ta8sd6w7Hk+Tw1gEH5hRLP5kxe9TUuHLMhmzg08hTGfrSQHUqivyAECKSga+IsaWZ
	7+miXvuQbDKjtnzKxEV1ipS+WCBDEwzlg0kRWUd416ac1iDCpnBy1o0SEllclyRNnEjndJc9vZo
	0arNvFg==
X-Google-Smtp-Source: AGHT+IEt40bf2L1ieTWOUGOb8GBIytrZz+O3ZW7/v2+o47EBca9GGMCRlp9MlBm2esAF7bBa1Gvasw==
X-Received: by 2002:a05:6000:420b:b0:3b9:10ee:6e9a with SMTP id ffacd0b85a97d-3b9fc32e7e9mr2977642f8f.33.1755182383284;
        Thu, 14 Aug 2025 07:39:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:64dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b91330bf7dsm8772509f8f.28.2025.08.14.07.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:39:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zctx: check chained notif contexts
Date: Thu, 14 Aug 2025 15:40:57 +0100
Message-ID: <fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Send zc only links ubuf_info for requests coming from the same context.
There are some ambiguous syz reports, so let's check the assumption on
notification completion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 9a6f6e92d742..8c92e9cde2c6 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,10 +14,15 @@ static const struct ubuf_info_ops io_ubuf_ops;
 static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
+	struct io_ring_ctx *ctx = notif->ctx;
+
+	lockdep_assert_held(&ctx->uring_lock);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
 
+		if (WARN_ON_ONCE(ctx != notif->ctx))
+			return;
 		lockdep_assert(refcount_read(&nd->uarg.refcnt) == 0);
 
 		if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
-- 
2.49.0


