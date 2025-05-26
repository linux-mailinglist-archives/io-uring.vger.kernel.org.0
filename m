Return-Path: <io-uring+bounces-8103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8957DAC3AA6
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32E6C1894CD7
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AC341C64;
	Mon, 26 May 2025 07:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLHpAq08"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690481876
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244684; cv=none; b=bqnzfUzWdEN+3yzqJ2l6xwe6onyd4rO7r2ypf3FS/wW7aKHkE+2xjuvH1+hqru7TK2oMsiWhf4QgYXByjOUNxh0ZDsvcZH6vQNnkQrCqoQ4Tx/a4bDVHoLZBJB+Wg9hHB4uaw7J2qU5Wb0EL1QfxvD/0Ne9K+aYQeX3UWZcPTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244684; c=relaxed/simple;
	bh=46mz1eyx4KNdQheyCEDmz2foCY70Tctq2mYfjtbMpd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bpGzXtpSRmu7X2zl7BxPkHyWCzq1bIpmrDlqc0Syp6/Vos8ulPdm058N7/fCnki4H8pWNd8kzOBKbTtfj9P7VfZJ3SEms2Ws3xjIzsfBA9oY2PQBbIrd7XC0WfZXs5CxdJg8rK0GmsJf5BZKes4gUr+N4WtXmJbcTCnk4iAJKtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLHpAq08; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad1b94382b8so328579966b.0
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244680; x=1748849480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eZCWrqFaNIdROy4e1wca+K/ZMCQl2x5LmLWzc1QgpAI=;
        b=CLHpAq08y2WCxDaKAApsuzAPcy9TcwebnSblzpe4ZAD08Tkd/aor5tEixaT1/KZIuU
         pxY7DyjI48a94ZLctAIjR50FAMZlNDANdtryU2UxaxWZ0LvEyr+AlnqSmOtIxn0K9BLT
         QgnG5hXrdAaapZsyG1g36YEVXYlAs7RW2yNwkUWBxcF0pnEjXxWA6/H88j0n8635e0Tn
         8SIlsj2l5wlLaXh5OeOIn/dYbRbI3iSqmdkK0ybyIw5kvDhsQeqNG4LlQy+JnLvxybKq
         KTvSntTnuVqyOE1LAd0/8vFlJRS1HIVaVviQd1BtZ8kVEg6Bo19P+rYEICEd5MmFdAIE
         yWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244680; x=1748849480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZCWrqFaNIdROy4e1wca+K/ZMCQl2x5LmLWzc1QgpAI=;
        b=NWqBJepYcSwKfIUE9wi/AGBDWCU+qswzbdbhi1yCTYC07TMlaFdecvw5JNMkZXFmiQ
         MBUL61Js1xNqzSXw5U2iJC4ndARwy3xX5H69pDc0uc5rzATYwgH8gDuCwIa+oDK+mh2r
         JY4YRmoigfTPyRsz/UYNgAfVrtB0OiBKENJFK6YExsetqr/32I0GEW7jzloR2LyOV/iV
         LygLw7tbGvvD5t7515LncfoZjN1I3PXnEj+1Dg/5XnZU7lE/NXIzmDS+4XRivz4LxV3m
         ij2aapmb4Cs8pivo1+I6c3oQNByeb4T3eV7Vrf/z802X03Lk1kPsHOT3aKIP3FPWED2S
         sLrg==
X-Gm-Message-State: AOJu0YycBMADdJcofaRb9DQIodLCwW6IOVsg1pjNmcmPRNB0lrNB7xWz
	+zMMrX9YZTUeQyTvidGSPP9eTdMn8iaiXHWSihQWpe4JMNFDYOjR/UAIzDtKfg==
X-Gm-Gg: ASbGncu6Bc8T/VWzOPdOBQcCgtvWtCRVq4ZFV8YnVnmWIWtERz8mu7MZUa156s+Dyz7
	98uvEWOV11OcvVP5+nArUFgXYol4FGjVsHeW9KIIBNhDz903g36dZ8NKm3f/pWTMO7GJoylMd4g
	sbCGzx47u14m8vdA9LbJohWC8cMjnzdmmLQdjmJWgU6p68s4xcqLDRDrNjC6yCIbT7G8NxwK+bW
	v9o7rFpcy6q/2zC91WboNC/H59BvxCK0GUbAYfYP0XdnlQBUa3KmS3FI+CSrCPLOkyXkCFaG3ls
	uboy74rtTzExnTbU6+UXVAEXec5HDfP8h9DHdjWdl8+cs5qjF9hk+jsHHoE4gr39
X-Google-Smtp-Source: AGHT+IEDoHhHXJgRkoAx/HCGLorpCqOhBCoFPwRGepC1CXQ+L2cpVZYGsLGENfCbvm0oallks0J4xQ==
X-Received: by 2002:a17:907:da7:b0:ac3:17bb:34fc with SMTP id a640c23a62f3a-ad85b2f3465mr711484266b.52.1748244680046;
        Mon, 26 May 2025 00:31:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 0/6] io_uring/mock: add basic infra for test mock files
Date: Mon, 26 May 2025 08:32:22 +0100
Message-ID: <cover.1748243323.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring commands provide an ioctl style interface for files to
implement file specific operations. io_uring provides many features and
advanced api to commands, and it's getting hard to test as it requires
specific files/devices.

Add basic infrastucture for creating special mock files that will be
implementing the cmd api and using various io_uring features we want to
test. It'll also be useful to test some more obscure read/write/polling
edge cases in the future, which was initially suggested by Chase.

v2: add rw support with basic options
    implement features not as bitmask but sequence number

Pavel Begunkov (6):
  io_uring/mock: add basic infra for test mock files
  io_uring/mock: add cmd using vectored regbufs
  io_uring/mock: add sync read/write
  io_uring/mock: allow to choose FMODE_NOWAIT
  io_uring/mock: support for async read/write
  io_uring: add trivial poll handler

 init/Kconfig         |  11 ++
 io_uring/Makefile    |   1 +
 io_uring/mock_file.c | 344 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  47 ++++++
 4 files changed, 403 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

-- 
2.49.0


