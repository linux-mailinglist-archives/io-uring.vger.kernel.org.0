Return-Path: <io-uring+bounces-9171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72989B3003E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 084EC60007B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FFB2E0418;
	Thu, 21 Aug 2025 16:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="P+U2XDhd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D7A23E359
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794001; cv=none; b=u5L4a6zbkYcb5cp+9fNM+fnNHAAQOQWmvu1SVJD4S60nKYa6TVLReOQHVJUp+37T0PZLcSEAyiH9wU7Wx9AFM1pehBhDWufqhOOWsRerGlqKowe+F0G7eOk7HY05JWjTiGsaIx02i3LY7fQCNeGNvHN0KT/fmDwDwZyPnbsr860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794001; c=relaxed/simple;
	bh=Tc8yEQTA1rJ8UJdlmefEZBaHQOO4+FSlAYf0wuNcbMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGnMjwl8wQsIpVlzo/be1Aux6TAMw2AfkCO3RA9ieiNIefSx5NbBjd8n6DR22+Z6/4z4y9uN8znaVSDOsNlRznLHK5TSOypAsexndp09mh76bnvbC0ACN4DFX7X8ACRozt6GlP377vSYG9KvOYhq6vfbxyBFhq1HkgHj6FRDO5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=P+U2XDhd; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-76e2e8b3a8dso90846b3a.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755793999; x=1756398799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrWp3xvC+9m7Tx5h8x5GJmXkfCXshPmcmt0oTDRA0H8=;
        b=P+U2XDhd/vPwk1rmwujvNFC9fNagb2fZDluI1awA3oVkCG14onmd0Jz7OkpZMS7uKo
         au0rMToSf5w4yJbmd55JyqA9eMOa2G1LaImmKEl35JR4qhDnPyM6xbagC3kIrcVDVvMi
         BAZJgVpY6wl91McFnRASr8XzUbqFJm2FJviaxObXfnxmg2Smb90SRgeAOZIjXAoHTKhj
         9Hti+gAdoSZDl2jwLeI/KWyClhWXE/xqS52cttuZUTPCvbEC0s9WGqYvGyJJB9Jubdu6
         I9WIF5wys23L/f0hZITPKQZYH4CHNQjX8aKI3NueG9PkKRynkXBvEg/6RCGOa4So3civ
         WmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793999; x=1756398799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrWp3xvC+9m7Tx5h8x5GJmXkfCXshPmcmt0oTDRA0H8=;
        b=afketGX/fEi0IyRX7Iheyz+l1RHFrII8z6TIGUTqCH7ktCIk2UvRnqYiEEJ3cFLeWU
         GmTrvlgliuXMfdYMminwwwFFYThnIpXeiJxZjKn7bN8K5KMLiE+cKsbLzuxffKbkR9zc
         aHmsHSDFta+cdolQ9jKrTYJZ8ReH/jkfxvuOzhrLtNj5xsLZet70tx9a/KWEUpWKvndA
         IwdxOVYm840h8Lnz3sCCiLZedPgWsC4meaESNI7QWMCnJGJWiCo1vKlV/TH+U4/Q29O8
         lKtJEU8Ne67reaKKr2VKcBTlTvJzapHBORu30JLn7ccBeTI+k0Y0DULtRR8N9FTp8ClR
         /IbA==
X-Gm-Message-State: AOJu0YzzP93qiog/5SJtiv8aHxqlSKJhqGSeBAxQS2nfKfyHn5wsybJP
	8QwsjP6sEM1xcfMq1ISm1XCz+MJHna4PnVajS3HAbbMcPhZYxLnFwQl6QP5idz2AkoSKL3Fr+uO
	4xNfxUHkRXyDlGlRdsYcaLCETdhUR8ilayC/o
X-Gm-Gg: ASbGncvL4+nTnY/Ey6B8Wsc7WlpTSQcRV1Fw7zeRhcglSgVSaCZshjbkwfZl63g0iJH
	BLME28rNNzOAPkayobhChMISbjuLDlFumIy5t3b2Gu+iAEPKOfUw4D4Uzq/PVfmBo0rwxeGYp/J
	Dpz33sEhYdDnSII4cxN0JFXEZpDzQRF0lHw5IYcIiNLI3/VyOAkcpbDtNWLI2+qjozxnwwxrMbN
	TrBqvvmK0iEo/FA5NcTrDu3AN0PAkqV75lS1/7rxACtVfIthdPGqAKN/xq/C9SNR9FgHCXwa7pf
	B7M5QCafLP5cY/OOOwabzds5Z5/8dMxGfSoTOp7dZbj9Q7UfCYevimLzLfr/tcWxYvGQF/Q8
X-Google-Smtp-Source: AGHT+IGpg7cqfGsEJ3UoNQSXvHQnnO51/zv+qk7w2xM+4AMEMOaFWmLkWW0k7apoEMXgvuEU1UfP9mJRScJx
X-Received: by 2002:a05:6a00:2193:b0:76b:f23f:65a4 with SMTP id d2e1a72fcca58-76ea329fa14mr1429161b3a.5.1755793998765;
        Thu, 21 Aug 2025 09:33:18 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-76e7d29ec5dsm693386b3a.16.2025.08.21.09.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:33:18 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 39F823403CE;
	Thu, 21 Aug 2025 10:33:18 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3794FE41D60; Thu, 21 Aug 2025 10:33:18 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 3/3] io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks
Date: Thu, 21 Aug 2025 10:33:08 -0600
Message-ID: <20250821163308.977915-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250821163308.977915-1-csander@purestorage.com>
References: <20250821163308.977915-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_prep() checks that REQ_F_BUFFER_SELECT is set in the
io_kiocb's flags iff IORING_URING_CMD_MULTISHOT is set in the SQE's
uring_cmd_flags. Consolidate the IORING_URING_CMD_MULTISHOT and
!IORING_URING_CMD_MULTISHOT branches into a single check that the
IORING_URING_CMD_MULTISHOT flag matches the REQ_F_BUFFER_SELECT flag.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/uring_cmd.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index c8fd204f6892..482cc5be1f8d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -199,17 +199,13 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
 			return -EINVAL;
 		req->buf_index = READ_ONCE(sqe->buf_index);
 	}
 
-	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
-		if (!(req->flags & REQ_F_BUFFER_SELECT))
-			return -EINVAL;
-	} else {
-		if (req->flags & REQ_F_BUFFER_SELECT)
-			return -EINVAL;
-	}
+	if (!!(ioucmd->flags & IORING_URING_CMD_MULTISHOT) !=
+	    !!(req->flags & REQ_F_BUFFER_SELECT))
+		return -EINVAL;
 
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
 	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
 	if (!ac)
-- 
2.45.2


