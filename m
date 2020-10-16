Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB192908C5
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436494AbgJPPqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436485AbgJPPp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:45:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BB1C0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y1so1491814plp.6
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CEyNy+bPS0s4pYe/JHkVQQqrkaXliJLJ2vS2GR6tIhQ=;
        b=U61He3tk22ihGv3I4dp2nKE1dqkIgWw7OLc8Uk/5fhvaeydetrijC5iKLMHglcj9Ab
         ld58vZPkIkjZ0xY9HIWtQgyEnyI0nFXHL4J1qzoyvxPpmCGLOLwubA3tWJ092Bjpbi+D
         QpDyXJT5YK6LPu0XysRMp88dxLIxOlg/3l4pT/2iknTSundplNxr72A4GdopxaLKZNGP
         S4mu6mfFqUsxZowdr7mP07K64XFhefzcj2biDBPIN/0/4y5Y64+WpaXDMI+ioE+Tg04i
         mp4VLWugb1xJ0sDCf06KbcPDlzm8ihbZ/t71MYScOzOo/09n64MP0qo2uhpe+4+I0FVs
         +2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CEyNy+bPS0s4pYe/JHkVQQqrkaXliJLJ2vS2GR6tIhQ=;
        b=XcqFX2rZz4saIVnxxVxyVjD8YdSBnxtH7A0KH0oNtIIMlapV4Vo9Q8Xh3PUt5yhPaQ
         nbk0A6NHy9aBIWYdx8zrFDbbJw8YLoj0Tbq8QyBsc4lh7wgMocnri+6w23z3Nv1epxZ5
         PZ4loeYVNVdEUdkb9+h3GdT3fG0nO4VCrWhAL2lRDoiWjRM4ZmpyUWiQxtLt13jcbj0d
         91wgrLcmCC5ZaaXe6Q7XCIl7KNm2akm3o517zmfgIitXa8clu6O9sCFaUIAm7bL0YPSA
         oZCCKvwxxkBd/G2TYVJdxhwdrNp6RgZYlieIlEoTC8B+4BtlmFx7oYMPtwLV5jYemuqJ
         2jLQ==
X-Gm-Message-State: AOAM532EbnNQpHmjMVDoFjKbc4Aom59h5Vg1bXrWBdePO2gnbWIwpgra
        YQ0lrjfm0SzcH0bD60666yem3FpapKlahAnT
X-Google-Smtp-Source: ABdhPJxgbXcgnC9Tgbr/oVLMXP6mQ2R1zy/ycjsZ1wP5fZLAlKeXl9bQtPEFbJz2REAubOcpeQ4TRw==
X-Received: by 2002:a17:90a:9509:: with SMTP id t9mr4487437pjo.188.1602863156236;
        Fri, 16 Oct 2020 08:45:56 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s11sm3346194pjz.29.2020.10.16.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:45:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] x86: wire up TIF_NOTIFY_SIGNAL
Date:   Fri, 16 Oct 2020 09:45:46 -0600
Message-Id: <20201016154547.1573096-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016154547.1573096-1-axboe@kernel.dk>
References: <20201016154547.1573096-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All we need to do is define _TIF_NOTIFY_SIGNAL, the generic entry code
already handles everything else for us.

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

