Return-Path: <io-uring+bounces-10893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFAFC9CFC9
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 21:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1C664E3351
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 20:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2662F744F;
	Tue,  2 Dec 2025 20:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KICAI0kf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3162F746C
	for <io-uring@vger.kernel.org>; Tue,  2 Dec 2025 20:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764709075; cv=none; b=qTrKcCqjy1d8zB3GyM4E28qZLo4l2r9mZYeM4GpStn0rAgFqflYD7/nxIzn+RaLF2OrFKty6tUiTFXDKEm2mvd+R9aiQtkVWPvY21RoQvg3bIJIKnMlQJji641tT3WOG1gvnG4IWmzlQa2g+fHsYpFu5fAKqetCXRkmDfZoeLg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764709075; c=relaxed/simple;
	bh=sX0ww1/l52mEd0ETRBUj2OEXBY14nu/Cxss4GuQO1UY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QigoLSgHWDtl/NUbE5le/TRGze4YBR1wQIPfylCZwFsX0W5K7QuZeatlOCoKCyRaclXsyXZLF6FGb3h5pfMQ7zLOpX6by8ZVycOaM+3YmKWzzhT3Shru1oGM6HFk0c8d1hcUeAxlEg57cuyHGPywodR+zdKFcM5tXQoqC05FhcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KICAI0kf; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-29800ac4ef3so14064595ad.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 12:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764709073; x=1765313873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WCFY6ttRSuGdVF/JBzuDEsCiI5Xdw0CqLhG9NMpubKE=;
        b=KICAI0kfoi/K+f726E1NcX4nZQLi3OONZSnnsZ3wGOIbmgRH8eM9F9LGOyvHAJy3j2
         rN6TcOueXAqaL1KjHukS+YOP7dr0g04iEmHrumcFcvgIakJnSstUi4+xY94S/iAjEnCj
         fAw5QtWDLLhklYaC8OqsNLZfP9lmL1ENahAbNfg4ihCTQw++dsIWRKyHEO0gJFPzmVFP
         IFg0dmJpKE2DBeF5O5SjjsZbkt1iYbjLwFTPuYUXlqLIvWzfAljQX2qKSL9+9x1I1cBv
         zhglnmVNXxb1bqOiwIfUh8pd3XyAgB5sCmAZH1od00XLlOsl59WrWqI9E0LpjW6PnYbi
         mcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764709073; x=1765313873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCFY6ttRSuGdVF/JBzuDEsCiI5Xdw0CqLhG9NMpubKE=;
        b=kHyWMxTC5mT4FF3YTR3UZz3N0130csHebEZMJsF7Co5LWlN1kEEaV90W4aMFLKhQBV
         DZdl+5nxwbKLMo4Aq0XsL7f5K7GMQcmGYxu4HSUPBqsgKG2ImwCSf8g+QjB7Kh4g+4YA
         NzRdJbwoQpRysJM2BWFcWcy+xEKuUPhSRb3FdHMJxM696wte8cKBIFgPwPJVHnC4640K
         +KK4Ke/AJabzzAxsBIAqGVrZ+M3Kt6bV8/CNI28QPLbQuuLeA91bueAqW8KnBvvA1B98
         b2p+qiPcSNu+mMN9I1fMhImXSzIuhQZxKokxlKe4xSvDmJj92u5lGIvDb7tlVFavWXjb
         Trdg==
X-Forwarded-Encrypted: i=1; AJvYcCUVI4HfRT7rRjRXoy9eKX1yLwdSCH7230CzTkaaNb69mlwevr4h5adHoq46rZD5tmQ4ecM337YEdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ2YuswCXnXBYQoBL4J1oZ+6bfux8i3qqgjcmVJnZ9nrkSVJ7g
	EQCUAKTCzGCdSnlIRN2+CCgfKnhnmOB/iwucVVo8Dmgx3T3t8G46uIOGQh6rrJ1Rsxn9/b8UoEV
	rfSljmD1wGHiisKqrXISAkN+VOvrq0S8oAA7OAy0haT2CJtALsXWd
X-Gm-Gg: ASbGncsUU2uRoGnB1NOraPCh3OL1flHgM9BhD3eGDpZ1XeBETWp3Zk7wh68K8NrnT3y
	0Efg7xFBRvLq0+3tL6ZEqwh7pit7Q25SrL2T1TJdApiaFv9AUEM/uLa/BigYmEOtx2tTjR1o0br
	YKuFGDGdJMyJW4eMV3cqiEjJRHwLkn5SWy/mbDVW0RuXYmP1+mkQreIejnuWS/C1c97h03cjW7i
	hIO82pDe4QH8mPJ79U5mvdOS+dj9eU6ZrFESUSIblV9KxW8E7TcESydOPBfxCQhX5fgujUcXolZ
	0Bxg5ME0t/fpdsHuerhrPkiEiRs+vdLo8VotWpWNPAtNv3CCMIxPJw1YhR1Tp6jtuoagVDJomg5
	h2iHIESIB6J/tvNUmf3KvdLK1zYI=
X-Google-Smtp-Source: AGHT+IGxthmxn51MtajamGGrOy6wmhrHdngQ16dAA5HyliKSnwYsh2b9iAmV7GSW2/6+01Fcd/I9//wd9zgC
X-Received: by 2002:a17:902:fc4f:b0:298:371:94f1 with SMTP id d9443c01a7336-29b6ff7b956mr275657085ad.1.1764709073003;
        Tue, 02 Dec 2025 12:57:53 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29bce453e6fsm22538065ad.23.2025.12.02.12.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 12:57:52 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 3F5233400C8;
	Tue,  2 Dec 2025 13:57:52 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 46AF0E41C86; Tue,  2 Dec 2025 13:57:52 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/io-wq: always retry worker create on ERESTART*
Date: Tue,  2 Dec 2025 13:57:44 -0700
Message-ID: <20251202205745.3709469-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a task has a pending signal when create_io_thread() is called,
copy_process() will return -ERESTARTNOINTR. io_should_retry_thread()
will request a retry of create_io_thread() up to WORKER_INIT_LIMIT = 3
times. If all retries fail, the io_uring request will fail with
ECANCELED.
Commit 3918315c5dc ("io-wq: backoff when retrying worker creation")
added a linear backoff to allow the thread to handle its signal before
the retry. However, a thread receiving frequent signals may get unlucky
and have a signal pending at every retry. Since the userspace task
doesn't control when it receives signals, there's no easy way for it to
prevent the create_io_thread() failure due to pending signals. The task
may also lack the information necessary to regenerate the canceled SQE.
So always retry the create_io_thread() on the ERESTART* errors,
analogous to what a fork() syscall would do. EAGAIN can occur due to
various persistent conditions such as exceeding RLIMIT_NPROC, so respect
the WORKER_INIT_LIMIT retry limit for EAGAIN errors.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io-wq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 1d03b2fc4b25..cd13d8aac3d2 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -803,15 +803,16 @@ static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 	 * Prevent perpetual task_work retry, if the task (or its group) is
 	 * exiting.
 	 */
 	if (fatal_signal_pending(current))
 		return false;
-	if (worker->init_retries++ >= WORKER_INIT_LIMIT)
-		return false;
 
+	worker->init_retries++;
 	switch (err) {
 	case -EAGAIN:
+		return worker->init_retries <= WORKER_INIT_LIMIT;
+	/* Analogous to a fork() syscall, always retry on a restartable error */
 	case -ERESTARTSYS:
 	case -ERESTARTNOINTR:
 	case -ERESTARTNOHAND:
 		return true;
 	default:
-- 
2.45.2


