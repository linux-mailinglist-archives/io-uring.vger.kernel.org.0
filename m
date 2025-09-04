Return-Path: <io-uring+bounces-9566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE837B443F2
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BC2A1CC0921
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 17:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C681E234966;
	Thu,  4 Sep 2025 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="AMWec8tx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f226.google.com (mail-il1-f226.google.com [209.85.166.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1F02D47EB
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005754; cv=none; b=DjUzDs6o2vcTQFOT7y54S1oVbLfFp2gfAi4yBDwZ15JFJmLAzXamjRUETMJttaS31XPIHngWaPH1skjO814GLRdnwsUqIoSgJQ5St0r+1imXzCF0PaFm6JirqoPNpEZcNgYJgY+ZN1qUVIZOUweGFNKplqibPx4/iQ2Zr/NVSOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005754; c=relaxed/simple;
	bh=4EJdvMqrIYCvAJeNvKYQAAuONryGXpzTRoA/GVqa/Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imiejUCpksZECkEqbpNY9zmNhy7KDDHwmICNwKSvYnvFxE/ZVQx5NHVOH3tW65sa4oJhDU49yqZCe6AYb9YrJblO5gtFr4DK9h8DTiiygU8VryPom3GaLSegESz991fFB2Na9tGJ+1QoNpzKXiU3Vy3UQgXyGd3RaNd68lYIcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=AMWec8tx; arc=none smtp.client-ip=209.85.166.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f226.google.com with SMTP id e9e14a558f8ab-3f65df713fbso1281555ab.3
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 10:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757005751; x=1757610551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVTxjV0mJqvDlcDpQyKjIaqAIkiVF/PV1uLNyI2CP5o=;
        b=AMWec8txgLGA7vwM0Z/K6Yv90nXf4C3IQaIjR0lGZiZ1I+g0POEjvzaXqrg9aCpiEK
         9rQWvm9uW4nZYWZ0ZJL/qCaipoyRe+/z5FO26c/Jz/S8Jz6F5n8PG6hJ/2a4f+fLtuaI
         AVbLGywfQNDeEiXNNMhjR8aEsBxXm4mqFeplJjPVTtVQqRAWH5LaSa/d7kuH5UpkijW2
         vc5905fdsdDDyW3wBoREk07P9jV946YYWFULB9Ylw1uGPcT9hMc3+YVhY4RcQ0aUZf7y
         xzUBIlcYvFXumKf2KBwrcPlLF6zEyEjRNA73pE8ptgSVCg0YOLsjINcA/t58OCJR/tOK
         MQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757005751; x=1757610551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVTxjV0mJqvDlcDpQyKjIaqAIkiVF/PV1uLNyI2CP5o=;
        b=cAEWlHEFko3jJn6IJrN/w3XgcZnQpgrAmT74c29JwibTB40+cEc6724Qyqa2vXwwdH
         w4wbzV+G4JBxfF7jRrr3G6NDIvKyuS8HjrRgVcdkmQ8UMcd9t+XRvQ8bF6u15LeSVvVJ
         uyEHJQTzdWeCeXMV5W2Xq8LhnqT9G37j50lsnVQUWaQ5M1aEB9GumyJmO2g6WWTjKE33
         MGJF6LQjWiDiTUm/qs4mHfKvYY43lm0eJZfSOPs2/nA+oOGUR8uR9Wdc9xVgRMl9PsxI
         thZ/llyo1ZYvIn0pJhm2EgyfMrIAu70qEu/qHg5wrSg4CQV0tbBmd3CI+sDWz10dUeCf
         IpmA==
X-Gm-Message-State: AOJu0YxqPS0gSI4DsOwurnkSB8x1g124OHouT8SSMJ0pUhVDXbxOivV3
	TfuFw0g0F1Sajqkoi60hPXboSgjFp69H6DIz6acJzg5XWh/eGQ7Eyq0iCn4C/rxktu1ltBeD7Cb
	JDRGLhAkQG0Z5cI8u8u618WipCrEXEqBCEFZ+
X-Gm-Gg: ASbGncvtwZkH/DixazQTrT5vALnDY65YwzIkptWE5gw6zC/ZepbPfwfsYXgKcV1L/+z
	JKYMSmFycrCXA2ILGF/zTrhwCCKQAl1bwzorc5OI9AlbfFtKeHQzoeaQvjQZ+Gi/DXNTouRga9/
	w7vdjL9iFqIU2pJO5fCOko69FXkf2EWplOVLJ3lpYJcVYKYJFZhfEpdjxmbhLLC4fpSzLheVEtO
	mjHKEuIIu3yXL57GYJoyo8WuQXC1ctrX2xnuTBZJmJP3Vu4DpLfYiHanoNq3mWzA/P9bzRw3DWR
	j52YcAkjowISl+FfI7JC6mJbx6dbkLnGbeuGaixlpqIkZkqAbBwaecAp6kMtGHm5NGhDb9+5
X-Google-Smtp-Source: AGHT+IE0lZfGt731rn5d1UAUZe1ngI1v3uSXy8aFU52mwbq1dHjZ9I2FSA6BGtpmM4zV4hgx5lsHZhfmladu
X-Received: by 2002:a05:6e02:1d8c:b0:3f1:a5b9:4a3a with SMTP id e9e14a558f8ab-3f3221b05c1mr128641845ab.1.1757005751241;
        Thu, 04 Sep 2025 10:09:11 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-50d8f31b06bsm982808173.48.2025.09.04.10.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 10:09:11 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 005B83407B4;
	Thu,  4 Sep 2025 11:09:11 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E1D28E41979; Thu,  4 Sep 2025 11:09:10 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
Date: Thu,  4 Sep 2025 11:09:00 -0600
Message-ID: <20250904170902.2624135-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250904170902.2624135-1-csander@purestorage.com>
References: <20250904170902.2624135-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
but it will soon be used to avoid taking io_ring_ctx's uring_lock when
submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
is set, the SQ thread is the sole task issuing SQEs. However, other
tasks may make io_uring_register() syscalls, which must be synchronized
with SQE submission. So it wouldn't be safe to skip the uring_lock
around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
flags if IORING_SETUP_SQPOLL is set.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 42f6bfbb99d3..c7af9dc3d95a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3724,10 +3724,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	 */
 	if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) ==
 	    (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
 		return -EINVAL;
 
+	/*
+	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
+	 * but other threads may call io_uring_register() concurrently.
+	 * We still need uring_lock to synchronize these io_ring_ctx accesses,
+	 * so disable the single issuer optimizations.
+	 */
+	if (flags & IORING_SETUP_SQPOLL)
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+
 	return 0;
 }
 
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
-- 
2.45.2


