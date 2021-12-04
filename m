Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80508468792
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbhLDUx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 15:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhLDUx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 15:53:29 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F15C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:50:02 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso7511810wms.2
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lfJxcTAm8inuqMGiz6cxE6zO0BaMHnf4Bh4F3FzbQPM=;
        b=DdNQXvb7g6wJ8rqcLjC2EPfke+dst0Dsgw3vGa01CA4d+pibaJ80Kfk4Gisp+FQgcP
         q35uYB0r0xdYkpXfawy3E3ob092P84pMYcOhxF4jFREyGIykWp+g1a7jtTvbWHVXLivv
         McKK8FQ9anPw3vzUNBOIP/lTI6QAKsLuviUCKJ1L1xspvAOS8KxOs04FkWdUCDlOvnfz
         +xsZD0AJE8p0xI6gBQs6yATBkjsKaC8yUT4Y1poxR7HCn5QaYd2ZVUrJNC703/i3WAXM
         bW/YO0+0VE/4xDGbYdQimvHDlG95epJOwBoPaOnzYq0XOE/Nzp9WHy5shAyJqFJBv5XN
         LTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lfJxcTAm8inuqMGiz6cxE6zO0BaMHnf4Bh4F3FzbQPM=;
        b=jj19JhcawDlg6JlitRrfzfNSEgApd3k1CdcOvajaqAWlyrIqr5MKjmah1N9GBYjg9i
         N4JVCTy8YfU4vndFWDEPDF3EdlBWfsGkRgAqDpsqbuUqZyYwbrhUDzi9oNFETdJWg0lY
         vF/bUTGP/wdaL2aRefCcQAdoqicYV7LgwvPxaj+hFvnWZv7bOxJtkEzZP9Dy21IrRI/t
         2Vk4UhGTg2BCz0l2UheGH5umQM9lWuf29nHRT9lJAGZbUraRFLDNi3jRTtpj75FepKBe
         OcWdfpmbuvIGsb+pzPWHcdHNlxS+2E7yGiEZdRkJGV07W7UV2EHpJ7Bbt2ohteqsKc6B
         UTzw==
X-Gm-Message-State: AOAM531qkpq0GMQggLNfssoYUNN41x+B9V3NEjkL9RiFsZ/ISrT9RTO+
        IYFqmGTOxmNeal15b9JOSLRLXGiu01s=
X-Google-Smtp-Source: ABdhPJxvLby8H2l+qwpzKyaZzki8/MBeLQTAc3e6jwKQyhIFE1s5gCufNNFSry7j2cZsELJRMT88Kg==
X-Received: by 2002:a1c:447:: with SMTP id 68mr26086569wme.69.1638651001104;
        Sat, 04 Dec 2021 12:50:01 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id k187sm8393143wme.0.2021.12.04.12.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 12:50:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: tweak iopoll return for REQ_F_CQE_SKIP
Date:   Sat,  4 Dec 2021 20:49:29 +0000
Message-Id: <416acc6e18b03bf41009e5ae3765737201e7c87c.1638650836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638650836.git.asml.silence@gmail.com>
References: <cover.1638650836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, IOPOLL returns the number of completed requests, but with
REQ_F_CQE_SKIP there are not the same thing anymore. That may be
confusing as non-iopoll wait cares only about CQEs, so make io_do_iopoll
return the number of posted CQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64add8260abb..ea7a0daa0b3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		if (unlikely(req->flags & REQ_F_CQE_SKIP))
+			continue;
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe(ctx, req->user_data, req->result,
-				      io_put_kbuf(req));
+		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
 		nr_events++;
 	}
 
-- 
2.34.0

