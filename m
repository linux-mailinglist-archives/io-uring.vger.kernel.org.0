Return-Path: <io-uring+bounces-10884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8872BC9C40D
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 17:41:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A08803A396B
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 16:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C3629ACD1;
	Tue,  2 Dec 2025 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DKFfZEMq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f97.google.com (mail-lf1-f97.google.com [209.85.167.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317FC296BB7
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693694; cv=none; b=QEgo2V2OPKuYdsrhukJ6QVW/sOMavhqXUe1r21aDLbx4ewoR4e2er6d/Ed8MK1jgHLPJE+bvr1b8qR9aJ8UTxUe3y0UvftR1+RrJZskuTLOmf4gwFNPxrJ2bqZEmb1X6+xO+BAlJN7kzUl426Fdmn+NtHeJI0jlZILXPF1ZVNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693694; c=relaxed/simple;
	bh=Zk0JVKoYfkCheOrVobznZozm23gYMK18Cdmu9FrpyWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ismHICvlCJdyQf/DKmRpW3/e+4fWGwLsNZF41KexLCwtED2jueLCwG69laJaz7TqiBfCeHEaWPNtEjxvxCkxapYJwgqHtqNOR2ShrpCWIxaUq9vIFdwWMtNQB7qZ/dGF5DhGCnOK9jATmZxegYvMrO5n5467Rs0mc2LifMZmpI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DKFfZEMq; arc=none smtp.client-ip=209.85.167.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f97.google.com with SMTP id 2adb3069b0e04-59425885f65so363386e87.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 08:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764693690; x=1765298490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSh44cQzjtdGPP7ZkMiUuvtvC2kNFUBgK1XOgo7qc3U=;
        b=DKFfZEMqFHexRKOHHtOL3qN6vr9l4cHkHiV22PsEJEfWAoByM5cROMm5k//7M7vRRQ
         Li0qi4D+z+puNkUdJ4xhbnFMKvBv4nHsTX2uqrqen+UsUt+cx/tMesu33rP8qTrFo1mD
         fXZ+Kj5aKiI4EwuK4XYvH1DxNlDRYTWTP3MgaI4Dt2499bgc64ufFlpMYac0F8n2Oj3Y
         jwSB8/6ywAe5iMsS6Ihdu7Tvv4l6MURq86srXv16BykAGTw3qUwdHFnLYvgbU8jJsUWQ
         dPjKY6IvVr1HHOKyoTOJgI5lGzt8O0OXJEZnO/w2C7+ZNeoabFSfUmtg+qtgbfTLmZSB
         Iveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764693690; x=1765298490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qSh44cQzjtdGPP7ZkMiUuvtvC2kNFUBgK1XOgo7qc3U=;
        b=GaRa/hS1A2jEaaz0lYA5tdj7iBVzIXdKhIUdxcpFnQsrohAb8JD7xEJJVtqKCt/nbu
         uCMbQgobE0inWe6w7H5EYbKBifR1bSccqki3xaa7LgpMGXUiK1pFNJ0EZBzMBoebEVc3
         wu4isy84BnCUkWWXwOkPc+a2vSIChjYZixPTZEzTiZu7Ad+6rPzrGI8CegBsXOuyaxDj
         /3dooTkytOdBDNCR0TvTxXIqh2y8wDnx11/24oOo4aGlKxXpW4zZrqWQh1EitucWCfJ+
         MpNiK4OYbll+5cUB1JGplFOznTQIuQQa31rvpkghv2+9hKaySPYEpeIDGfx7d/06BHB0
         VVew==
X-Gm-Message-State: AOJu0YxILg3t1sFOezp2TbbIjuzWe8hVO/JeGmOfct3hm4oSvGvgGh4Z
	zm8TC7iGoFRlzmVgtmlEUz3UcrU3/6ol95CigDPZvrmhKlR5RJ8VazuxNZYJHW8QmIO22qdKbUV
	szl115DKR9CYdVtQRt/wS3d6Jl2/NQajvO3rW
X-Gm-Gg: ASbGncsEdt9LZxydSw1RK2EnKlF25oVYwlReLVpRpu58r1W7N4FMKPBvYRqyesWF9sg
	IdQsSG0FcZP+om/R3Hz7mr2VREfLbGb05nXNPwB/rtTg6zYSYGe5ioL0z0oLoUWOYN85dsDoeOG
	Um1Zj8blXO2h2eOz//UbDElmLTzCWawvsA0r1csqYaOVIvb30ejbLB2A3tDmqAsAw83sacH1EQs
	fMktBDdqjFsFL6FuN6ye7VjOiSMupZkeZD2siHNRH6LV4S5dkeTF8NEdYFy2Wgti9NmPJu4Dv+u
	LrgxAIN0AkSWs+g4pzZsojTPe2GO797Hn7Mlq0ZMr8RdXiEl4wdA4exCHUHWv90/pwYtR4ZW18R
	Wj72q2wdoQbPQw0u81obnUkDo4tkQ81jrnO5QlevsFw==
X-Google-Smtp-Source: AGHT+IGAj4lN5JVEn5cefoVMaFXAMaPw0tiPIWWlYo038AsLD/CuVuHgq+4QblwZCI8hQVWAyr4TcLW47krb
X-Received: by 2002:a05:6512:2211:b0:594:93b8:88a0 with SMTP id 2adb3069b0e04-596a3ece806mr8132550e87.6.1764693690037;
        Tue, 02 Dec 2025 08:41:30 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-596bfa489a2sm2537006e87.44.2025.12.02.08.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:41:30 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 630F5340361;
	Tue,  2 Dec 2025 09:41:28 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 62879E41DB4; Tue,  2 Dec 2025 09:41:28 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 2/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
Date: Tue,  2 Dec 2025 09:41:18 -0700
Message-ID: <20251202164121.3612929-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251202164121.3612929-1-csander@purestorage.com>
References: <20251202164121.3612929-1-csander@purestorage.com>
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
index e32eb63e3cf2..d0655082ced3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3473,10 +3473,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	 */
 	if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) ==
 	    (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
 
+	/*
+	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
+	 * but other threads may call io_uring_register() concurrently.
+	 * We still need ctx uring lock to synchronize these io_ring_ctx
+	 * accesses, so disable the single issuer optimizations.
+	 */
+	if (flags & IORING_SETUP_SQPOLL)
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+
 	return 0;
 }
 
 static int io_uring_fill_params(struct io_uring_params *p)
 {
-- 
2.45.2


