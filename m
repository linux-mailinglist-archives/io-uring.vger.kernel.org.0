Return-Path: <io-uring+bounces-6031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D95A181B9
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 17:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 470937A1E25
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 16:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D84C1F428E;
	Tue, 21 Jan 2025 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQFYor58"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615781741D2
	for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475809; cv=none; b=dT8gkHq1kV6RRn8+Zjy9uSKx68Y/vzRPE02QrMGp2xWRe8g4DbxEzGdLssmdV57H/zn35aS/18MDz/nkzCkX7gTCLyNGSwKcz8918LYRdM98P4AwETUMiujGQ6HfH95NzosWAuiItn1XxyjTkKd6kQsbeWGuIvjVy/bAuzf2L3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475809; c=relaxed/simple;
	bh=pEyoQvQWT6idVibEeyq1Yg7Ofbc/zFY8E1cz2BUMuKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=L9MbTofzlqVQtyQ+E7Ar1Nr/1uQvtZ7c5bpHFtjlFXbp/dzkimRHHsguCv3tm600DWHReAhEoRatuV1GbxT8ng9pf6jIJoFCZx4P79TqqTw/h1sgPJfLk6PvhEWewscpQZpx8++1mkTC7NJTSVKtSB7U3Lt7kuM4D6ownsl/5KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQFYor58; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso139565e9.0
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 08:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737475805; x=1738080605; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A5EzkxHuBI8yDHTyPXO5W+a90sGmWcj3zVI9ThOaO6g=;
        b=JQFYor586rYOm73fO96mCrAc/uEmFKRAvO0MQ/JiXN8UI1Qn+StZJq6LLy7j+U0tfe
         JQ6ZnyayitJG98t0JvLJv9rWhs3ZwDyqYc0lmwzAmOEpYxIJ2cmch6Zk+CjiRJSI1Hpw
         Bd9vSFjSDSSwt9JFn6d41K8eB4VZ9MYvEpTHq07p/DPjrbYnyTNXx81QbIePmvIoxU8K
         IkSm6lAZJAOR8eP0c8LxCD+wfVGnOK11CUmgPvT/hpIDd5On2GenxggcwluOLc32kWWe
         ChigpZxLaBJR6s+MQcTqMP8/P5LK4OYZksogqozgv/0wOJCdTYAXeAMJH2vWKIknLDx7
         CFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475805; x=1738080605;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5EzkxHuBI8yDHTyPXO5W+a90sGmWcj3zVI9ThOaO6g=;
        b=Q+cWVztLURTwaIQf9tYT7Xz0Aac4IlVnJn84VFNKI1jpR6kxF5R0b0gQYWJ2YMwC9l
         ROamk6g8wcay2jg4XUL20Xwi9IJF1gPeutCGVKtewVJikBt4Lrti5SDBgs8aL6WNCyF5
         O3xKwx8dr0g5YVXxy3t0qBUP83dXF5gMXiYD3ntvCp4ZTlz7VUZeUmYxXrCyv3wf2tUE
         kYVqkU28ZIHQj9TE5XbS0GjFnsr7qo5HHJKxNHXD1pvGH/QT0eQOz9Dsh811jYxaZJSl
         1v7CTTJq+tEoSnwL523xqGtDsU+akqQWcSGq+aGLrosBPpnN4zNH8tjKP7sFORiMnbHj
         5TbQ==
X-Gm-Message-State: AOJu0YxeeQMoqVJib8BKpCxMu4YNPsB9dzYCkqU9C2/AVAEpVY4qcmsa
	Dp4U6Iq/7rpIFVJxfH4Tsa/zwzlxmLaAc4G+0Gfdc238VtoxX5DrcAFadP/WNf9qevgfIzsrjF0
	jH+tk
X-Gm-Gg: ASbGncsd25pTydhnG1zMLEuK5GkvK4rwHQFG+batmmEEsGO6Rzlph30RaMZqwoz7JCV
	DtC+4ZBLBVxFwdXLvltAIWVo+eqY3/0g/ZM6wqYRTrzW+PeD6VHPFHpksreZokXpZpqJP3F3aT/
	8fhLqf37tPW/soncOf7Av1157mPZpIe5vx0HRSroiAAQtN0jl4uDDwbSB2vE+bnMbAm8MTduOql
	1mMqZCOeszkbcGJLI2FO82NXD7yy0iTMi0CPAlAu8mBrYYBvHpY3r/XZGU=
X-Google-Smtp-Source: AGHT+IEnqGlP0mkhPSeKjo/LbQpcR7eQ4ujkEkN21jV24Yk8ZD1wCZ8hhCkkpGuo0nw96gn/DYUFCA==
X-Received: by 2002:a05:600c:564a:b0:434:9fac:3408 with SMTP id 5b1f17b1804b1-438a08f5d3amr3963895e9.2.1737475804237;
        Tue, 21 Jan 2025 08:10:04 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:690e:31d2:955f:4757])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389041f61bsm182804475e9.17.2025.01.21.08.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 08:10:03 -0800 (PST)
From: Jann Horn <jannh@google.com>
Date: Tue, 21 Jan 2025 17:09:59 +0100
Subject: [PATCH] io_uring/uring_cmd: add missing READ_ONCE() on shared
 memory read
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
X-B4-Tracking: v=1; b=H4sIANfGj2cC/x2MQQqAIBAAvxJ7bkENkfpKdCjbaok0lCKQ/t7Sc
 QZmCmRKTBm6qkCimzPHIKDrCvw2hpWQZ2EwyliljcYrcVgxR7/7Y8aFH3R2cg3ZqXVWgXRnItH
 /sx/e9wNNkA6LYwAAAA==
X-Change-ID: 20250121-uring-sockcmd-fix-75b73e5b9750
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737475800; l=1131;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=pEyoQvQWT6idVibEeyq1Yg7Ofbc/zFY8E1cz2BUMuKM=;
 b=VGKDcbuKJt9SxaTs68JubYzt2aCYSgWvTQYq38OChjFMCucq9gOfro/KxuUHhylrmAClv7058
 /Z0pFDEi5ttD+RlbGww3HQGEDjHhb4okleQguxFrqrM7TEVo7OgSfrU
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=

cmd->sqe seems to point to shared memory here; so values should only be
read from it with READ_ONCE(). To ensure that the compiler won't generate
code that assumes the value in memory will stay constant, add a
READ_ONCE().
The callees io_uring_cmd_getsockopt() and io_uring_cmd_setsockopt() already
do this correctly.

Signed-off-by: Jann Horn <jannh@google.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index fc94c465a9850d4ed9df0cd26fcd6523657a2854..f4397bd66283d5939b60e7fa0a12bd7426322b9f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -350,7 +350,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!prot || !prot->ioctl)
 		return -EOPNOTSUPP;
 
-	switch (cmd->sqe->cmd_op) {
+	switch (READ_ONCE(cmd->sqe->cmd_op)) {
 	case SOCKET_URING_OP_SIOCINQ:
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)

---
base-commit: 95ec54a420b8f445e04a7ca0ea8deb72c51fe1d3
change-id: 20250121-uring-sockcmd-fix-75b73e5b9750

-- 
Jann Horn <jannh@google.com>


