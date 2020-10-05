Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BD9283973
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgJEPYv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJEPYu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:24:50 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C90C0613A7
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:24:50 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so9578722ior.2
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:24:50 -0700 (PDT)
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
        b=PKv6ApOP/1PzIYjNwwgZZ/8BeC5WZqVQ7tiYBsowPSe0770Y4zGYaUNFLyLIrTzWH4
         ryDnKAYl7bB9EKu1d73itTcnbG6WI1HoowEwICE3SmLmQO7k8zoIfGioAb1zKXiMgmh8
         TaTdBLi8myKH2+668uqdDLiofKAIfdiQAA+ZyZEAlpW5iGMKDA8AS2Es6AWI7QWMIpJi
         JNya+/qXy7NGziw5HBJgSt1eNqo6SiNYnhXteeiBNMOCbd++RekGjoqQUZgyJA6pWD8g
         2Bkivk2qBwLPNV5TSSlukfUnKlK66UxAlNKaUP6JwB78FaRhzI7OvFfTmh8YaPSPKICd
         xuBg==
X-Gm-Message-State: AOAM530ipOrV941TJcOlYKl6NvaxM2HIRG+MQIKx7AxBLRC7hH2N5Etq
        81dGJCZealmt0N/ZmFv44TVhdU58aYREAQ==
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

