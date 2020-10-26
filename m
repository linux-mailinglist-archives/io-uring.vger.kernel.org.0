Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDC0299803
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 21:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbgJZUdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 16:33:04 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:33132 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732065AbgJZUch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 16:32:37 -0400
Received: by mail-il1-f196.google.com with SMTP id f16so2375610ilr.0
        for <io-uring@vger.kernel.org>; Mon, 26 Oct 2020 13:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p57zjt9VrV2qyGa7svHgIB5B1+EDfw64gtvhxwMqMTk=;
        b=0JkP4GlS94PbWCBzy0NFok6ujP6INO/wP6LbBEdRkk50xc25lmVt1MImWxpT9SdDDb
         4GU4kSZprYThu3CRwbDLkOlwjnLTHXzK5i6ABtbcRofX/EaAqSLAtgpPPcyvwPN0nWZd
         RWqco5BADXeAApYXR7YoXLjCYVY9UPvOYQU6DzCzTbhW4SMyQd4PiIjbpFJJ5h1TuVEW
         FKrOmSPKUo/b0OCX1XoJMoZcLCyx9eJ/45ANEhwJoEe0fUeQsq1MlwQ4eUVBX0Q4gIxR
         +CMCNk+39DnvY1aw1hpDPXmk+URUWuytdoRmkkwoTXxGlCT2RQicMd/sZXz86HlQiKjG
         ejNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p57zjt9VrV2qyGa7svHgIB5B1+EDfw64gtvhxwMqMTk=;
        b=R2OKNdYQanjhHdOhSuZG6Haw18xAgKIpGcIz5ncpvzF3LkFlwDemyNx9yJ6omNPB2u
         cRsDLS48+DLCSpqlv9l7y3tv8o3+SN3Tn62+XBsupo7/zEHJmtS+2TvDH/31YUbQCBis
         3CzpuOSSL0Vu873yRcP3GoiujnLqgVRduK8corFIEDKiqNNLGG6oVFW3WHS563Lsdmcm
         UJhFcUMWJsm4HMZvWmg2gFmvv/VUh2aam4u8LF7xQLLe3LU3dG8xI2CgsXZVyulDiqgg
         +YZvEYsSKV1DvJ9DtzLbJClPn+n6lbhfQEsGy+iznZOLQhErzwwnonqgGyDw+ABhBtbB
         YOyA==
X-Gm-Message-State: AOAM532DUyTdI4U0Rx1BPk/VV+m7aVA8SCLEqyWIAlv9Lqmb8PUoI9Oq
        MUpxqpJI711vIg4dxjX3R0WvIA==
X-Google-Smtp-Source: ABdhPJy12Pc2iazMva2iSOT206GioQO0vpvCFeoP4xUn0Qq25oW1JPY1yM/j7amJqiWh5VJWso2ScA==
X-Received: by 2002:a92:4142:: with SMTP id o63mr13427867ila.138.1603744356444;
        Mon, 26 Oct 2020 13:32:36 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e12sm6770373ilq.65.2020.10.26.13.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:32:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] x86: wire up TIF_NOTIFY_SIGNAL
Date:   Mon, 26 Oct 2020 14:32:29 -0600
Message-Id: <20201026203230.386348-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201026203230.386348-1-axboe@kernel.dk>
References: <20201026203230.386348-1-axboe@kernel.dk>
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
index 44733a4bfc42..b3b32f4c4d2d 100644
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
@@ -122,6 +123,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_SLD		(1 << TIF_SLD)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
-- 
2.29.0

