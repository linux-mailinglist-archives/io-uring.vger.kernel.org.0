Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59720F47C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgF3MWe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C752C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so20269721ejd.13
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2fBEcaC8ht9mx/8GPjQqEZVahRzLqdHB9X2NyeF2FcA=;
        b=mEnVcba0jPf4HETswd7gxgg1rZ94WqovpsvWzYHRW/rZyaaxp7dkfq5fy84c0sdTZO
         d2iTA/1tI+uZPTPL4zdw74YbbzzL9W3yBJQKgXlV83J4N/ip4WkIgWjszGGMcdWLxaE7
         C+Xtx9s4B7U41XqXlTXvDaLMmf3efAes8iI/fwNsZHU+jAURCYCXA5LmM+HzJ5+SOoz+
         +/eX+rEt/UIwLEIN+HPh9Sd7Ivwjt9yec7SZKaiRFaj46aJYeqyQrSNrPEIL5h6yjDWC
         c4OuxbBFnRJ1vC8/NQkm6QY1Y+yuH1TD72z6vUtiPvGtqnA/4u6ZkdH7UyGsU30FdVk9
         Zb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2fBEcaC8ht9mx/8GPjQqEZVahRzLqdHB9X2NyeF2FcA=;
        b=g4aAjlGKkfuxGSJOumm/pUmX6oX73WWCWYZyvtcTlNn5aW7CQqWqE0rZzDHWRN2kcV
         9bQtadZuqdKSl5gfcGT4fw3NY9ZP5ljtDnpi2XZXEAdq7XBNNI7voSg8DQSu6P3ZmxAZ
         slE052YjhFlM9DuLQXtJjWwjUKHQ7AMAucyft7AzUvW2mxZdgqil0PNPSJU8wiRdc8td
         XUsxhCZ/2DT7GzWEID11FH9sekg9VlLGW3Cw5cvt12l1cdoqohWu5ZFRb+aHOZ0gLq3c
         4EvcHcSby3I4UGMiRJ1Bdaa96y7XVlyK3Jg0ig5TqQL0XQ2PuPOkAI4K5FFS3aJlYAbY
         zjsQ==
X-Gm-Message-State: AOAM533N7JvinpP5mURFfPoRI9/6CoSce210TUDKeXhgLxk+enyK+Ik8
        FYlsNM/Ln4sL9TwJh2DClLc=
X-Google-Smtp-Source: ABdhPJwU/LNHFHsJIDXFLSbLcdp1vtYlCkrE2iCsJ7UFwR6OT2XWbR4ie8tINo/Z5ql/FdCmQ/+IPQ==
X-Received: by 2002:a17:906:4f09:: with SMTP id t9mr17818920eju.110.1593519752254;
        Tue, 30 Jun 2020 05:22:32 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: fix commit_cqring() locking in iopoll
Date:   Tue, 30 Jun 2020 15:20:37 +0300
Message-Id: <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't call io_commit_cqring() without holding the completion spinlock
in io_iopoll_complete(), it can race, e.g. with async request failing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1ea41b7b811..96fcdd189ac0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1923,7 +1923,10 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			io_req_free_batch(&rb, req);
 	}
 
+	spin_lock_irq(&ctx->completion_lock);
 	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
 	io_req_free_batch_finish(ctx, &rb);
-- 
2.24.0

