Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C420F28F307
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgJONRL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgJONRK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:17:10 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266D9C0613D8
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:10 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p16so4007942ilq.5
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxhH8LOM8Aikfj3NKrbZcGF2ZN+2TcVACSDxs19TXeE=;
        b=sIlEnx/9nWATWRyclEanjLwn7C6DsCywsZzmNs/Qe1bgTsDt6pFHncvr5DcnHIdAul
         FGaBkAQiOjZqliXJrLyB+5MYOoH5ueqVJtMjmDhWpQ5LTaKo93ogIXvjw9zaVM/l8s5W
         qAo4ihfo+8TSu5SRzqf+GQlbDJCpTyBqsRFjc/sohKhdb9tRDw1mzIsmmWcf+Q6wCDdj
         vJTJrzY9S7NBu8pRUsGPn77tj8ZMb5yEW5FyeoS+Hbp9++ihWpenpt3DB0twmyhfpDIV
         pe8cbgJ78DEMBUf5In05oUaJ/ISCYQtY9/uCeBbjKDvYCMsJSz4OSPuM6FzfQovm/geT
         4WLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxhH8LOM8Aikfj3NKrbZcGF2ZN+2TcVACSDxs19TXeE=;
        b=W31vwo1RY7P5A3632Llh632+Xz6NpdFHcd6hD5caU9DPWG4gcJHAxfyLWSZKKyzF1M
         aKKpKK33SoOYu9Rg2SfXhKow6p7Fu7osXzTzYMjCNxhvnn8pKeokd4dFhmCu0XSXrqqv
         gRm7MxN+BMW98c9rV4kkqx1sP6O/u1scbrmGCCZBgJYMlaOoco3IoGb+BJi1BzWk+bFB
         FXSnGPxrf4aFBPutSAtdM/eVbpz3OQsa96yOYAvlC+6nliHwvsQBf9LmOpD+NFC8Qx0V
         afFrR+9/KitO5vdYGwg05x6VlU7vl4DIxQhAPaV9bbseMTlyxtcTq62jz5Cz8qu7Ge4A
         6R+Q==
X-Gm-Message-State: AOAM530KUQnkGvaJeWCx8kpVvwQaZOu9DngHMeg1AkMPSZtv4Hrmye1t
        9ZIAPS+tx5mYTXkiYszzudH49w==
X-Google-Smtp-Source: ABdhPJw+VHtfsn87UA8qUjUhfF6lgAuwBuMto/fw7GgjedE6Sp5JOcrS9Z/o7J9csXRDJdI7DQzYsg==
X-Received: by 2002:a92:8b08:: with SMTP id i8mr2801793ild.35.1602767829429;
        Thu, 15 Oct 2020 06:17:09 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m13sm2486736ioo.9.2020.10.15.06.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:17:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
Date:   Thu, 15 Oct 2020 07:17:00 -0600
Message-Id: <20201015131701.511523-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015131701.511523-1-axboe@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already get the ti_work passed in arch_do_signal(), define
TIF_NOTIFY_SIGNAL and take the appropriate action in the signal handling
based on _TIF_NOTIFY_SIGNAL and _TIF_SIGPENDING being set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/include/asm/thread_info.h | 2 ++
 arch/x86/kernel/signal.c           | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 267701ae3d86..86ade67f21b7 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -93,6 +93,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_SLD			18	/* Restore split lock detection on context switch */
+#define TIF_NOTIFY_SIGNAL	19	/* signal notifications exist */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -123,6 +124,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_SLD		(1 << TIF_SLD)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d18304e84c09..ec6490e53dc3 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -808,7 +808,10 @@ void arch_do_signal(struct pt_regs *regs, unsigned long ti_work)
 {
 	struct ksignal ksig;
 
-	if (get_signal(&ksig)) {
+	if (ti_work & _TIF_NOTIFY_SIGNAL)
+		tracehook_notify_signal();
+
+	if ((ti_work & _TIF_SIGPENDING) && get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
 		return;
-- 
2.28.0

