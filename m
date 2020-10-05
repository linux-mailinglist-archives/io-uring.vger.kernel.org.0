Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D982838F9
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgJEPFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgJEPEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D29C0613A9
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:49 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q7so2745620ile.8
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azCwtwWl5ATB3D4FLVSirtqWYtNN30f962gtbhkaMz4=;
        b=Z/vWacxk6ekQJqGbV1+HSfZcW7SM2RNnKcEQKh3ezyQsql+bUCLabWcRykl7LFH76U
         E9JqNUhajy6vkhuFQP/dZo92Ewe4YaGw5LyAir1zo3x0Gm1RMtxIcL9TWrjaIyNTzYz+
         D8U4pU18BP7n1seyOn/iPN9PXEnIotfRbQCXRTB6tQcBdEI10Ba3EOZPFhMS5dNM1ykI
         KBK7J9lZGO0YegH86ejVQ9WO+zk604BW0hm2k5u+w02pq7E86BqNNiIQuPi9LgtEkVzG
         fe1ZtnPY2pejUWUKuj+halGETuqhfX4yMUSj5Ar+TwvQ76kkKJXRQONX909cHC4d1BUr
         FJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azCwtwWl5ATB3D4FLVSirtqWYtNN30f962gtbhkaMz4=;
        b=lu6wkqPFlEarSipFUitRUD9D/fNXydblWAeM6XYS7pkziftWBUaU9dcvd41wPZpXq4
         BMzkPfQdBqO5G0O/8ni3DSEKmB3FHSfQS6dDLLbyY2IYkQ0sCRef+7mcikiW4J9GHia0
         lxUgfq3h8aOCv59UR1m6BBjnNCL5394XfyoBAxhX4KPaTdF2UNbNNzgwMkqyweSnHFkk
         qmLockD/PgG2TiqCXyzjdjCf6b69MEGcS+h0G5HPPmKLZf+qMsX35TvsrvYLMWIhFG5e
         T1jGkDI/xJzJZtqw5DT/cZjOBKF2d++5KJ9YL4Z0JDsjHqhtZHdro9foyGbsqliBV0L4
         68yw==
X-Gm-Message-State: AOAM530lWBZQMZCLqI2DGfAQhGEyJe/dhnb/dG//SrWNw9yjr1hz+tu/
        4bpqMaRuhDvN0vKGn37wsO3YUVFVuXKfxQ==
X-Google-Smtp-Source: ABdhPJyse3fhw5d/uhWcVuCiiOAU49VBlsslmtKgMJPOQ45lfuqLFm+fY0FnJGFCyuPJu5zNKY+ZEQ==
X-Received: by 2002:a92:4448:: with SMTP id a8mr12205553ilm.73.1601910288673;
        Mon, 05 Oct 2020 08:04:48 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] x86: define _TIF_NOTIFY_SIGNAL
Date:   Mon,  5 Oct 2020 09:04:37 -0600
Message-Id: <20201005150438.6628-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The entry code is now ready for it, define _TIF_NOTIFY_SIGNAL for
x86 to enable processing of signal based notifications.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.28.0

