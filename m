Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F282C32D4D5
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbhCDOFI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbhCDOEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:54 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A1C061762
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:37 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o2so9295704wme.5
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rXiC3vrfVjHTlvyN8TLMDiFxVOB9fozl/TlFyl4k7Ic=;
        b=ALv4AVrtBhWwxiFga+Wc2hdJeI7MNucDYLA9TmvoVgxzas8f8INGA8hbcoaxjljiCy
         TcVO6cjfU/7sdiqgh5LQaoazVdXt3R7z2bOoOrQAXyREQiojeS+31H8PNxmyVfcailDF
         v2Q0SkPDAKNf/R6lflpI0aMjNWTXRxJGpex1DWM1aSo2VVRRT2rHjoy6puKBiR7YLrzK
         e5xkiA9t1qTYLJm7TEyZBv1fL4YxY33YjiKCUiLCOc66QL3KS8pt1kjgDokM5JXsUECx
         l03Ee3Kr2sEZupjOeoXmtBqxJ78M3cWfQk/Xv8QAn2wUKNJ21I3faQPopJ3rpUscJEAg
         sL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXiC3vrfVjHTlvyN8TLMDiFxVOB9fozl/TlFyl4k7Ic=;
        b=uBEi/7mFlv5NN9hhnm/Oo4h4f4xXH8gKUDQxWZRypl2dVxA/RHatmQL48R4Jp7Tyl0
         Unv21mvc1/Mk3irVzXFVWm8XK6J8xnhg/POkt4AL3QzBSC7B4fGuMLDR6INyfxyeePDh
         tBumkutXL4Kaaru1GfbgzUT6sG8Ae6j6pAJdQPLlGuxjzIb/i7NKQtMEIEKOn4UX8b7T
         g7LlUSIu76lb5teVdDd94mzHKe376K3n/fJBU//ylBthKPGJW/JvB7Y4+YLTJKfQ8qMP
         TCF541kWuZQFOZKSoShMp6Bm5RrDDD9jHFR2ZxEVO5i13vvjZZlxyEn2yBjMT4EHi16D
         4I9g==
X-Gm-Message-State: AOAM532VMfB0skJFXsbam7mH593eg9zmBP8xrXBGES6pZbRND2sQOCjs
        d0hg3JxUzRPFAup7Dlh3lWQ=
X-Google-Smtp-Source: ABdhPJyFMpJp7nb8Y3IuRrWI+3Sb9L+FTNfkECTLSekLEMqnC2J68F3Zi1meNzjNtIGzyD1ic34pqQ==
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr4035411wmk.123.1614866616423;
        Thu, 04 Mar 2021 06:03:36 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: reliably cancel linked timeouts
Date:   Thu,  4 Mar 2021 13:59:25 +0000
Message-Id: <1b512b100d137b14826b956f4766b7d6afaced15.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linked timeouts are fired asynchronously (i.e. soft-irq), and use
generic cancellation paths to do its stuff, including poking into io-wq.
The problem is that it's racy to access tctx->io_wq, as
io_uring_task_cancel() and others may be happening at this exact moment.
Mark linked timeouts with REQ_F_INLIFGHT for now, making sure there are
no timeouts before io-wq destraction.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c340d7ba40a2..f82f46c604d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5500,6 +5500,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
+	io_req_track_inflight(req);
 	return 0;
 }
 
-- 
2.24.0

