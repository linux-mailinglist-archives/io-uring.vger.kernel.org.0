Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EB138F67D
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhEXXxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEXXxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:04 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65476C06138D
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u4-20020a05600c00c4b02901774b80945cso12307862wmm.3
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yE5GU0vY5Wo0MNjUWObl79J6ctuVla74Qouwv8UXako=;
        b=b1ke4LOHWV54zYeavwyKD3bjMCOJ70dhYxZCLWrSH7BSaih76t4s8HW55eEhCavWRA
         y7H469q1MfcUEk05l8udJZmtaqNA6+YAUppLKAnWdYnyDe22vaPlxDHlOrXnJZDNDF6C
         AY9dxms46r/7k4oy+Xo0JKMPSXq+gksoirkj31ltNGR/a9MhAeGGlaZ4womE9k9rxhFo
         BcMw2K+iODHQfQy+0H+srT1untl3LylEWWF5ybeQKiTnFrb+LzVFFYbppLmQYqQh8puF
         yksX7Zj8+27pts7Ji2KYV8/mckNWYCRmi1jjOVjPeFF82nk2ZZnB5XWYB74OUQErV67r
         EIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yE5GU0vY5Wo0MNjUWObl79J6ctuVla74Qouwv8UXako=;
        b=AK2GMhXLMdHm49qggX7KSDa73NFIPsWH1PQE1kIZWb628q0cEtqnyalhH1OawSSpE4
         kXngTkF1vKGoT878RlCoz5pOsMiKWcV9XjEACy3+TsJ7ZOgKHUdJlzfxR6jOhKwAq7aJ
         HV8px/Wvb1FqID1Oe8Ft3Mf1PIcTjLcKcLZp5G0Kx34Us3iLA0eC9eLdohy5c4d6tVa2
         Fndh74DR7vZrxLbWNzLGGT7YiOIxNiveH6y99AwA8ujW0Ygfpa5ZJrTOPaISkhyWOW97
         2EQ72nmy0NscXYDXa8infYQV1GhMSGa30W+xYwzpQBNNJwZaMlLX4WmXZF20gRyvdZ9o
         Yi9Q==
X-Gm-Message-State: AOAM533KlhsU8GdplzfLKaToXcNeNZaZPdVYR9Kt5gZsoa7l/iyDoFl4
        wXtvH/4vyf7vqykLSFiBM7s=
X-Google-Smtp-Source: ABdhPJzfvbz6xEnJmLqZvBrMJNPgN7v8iesLcZwRrd/UzrgQ9L3yecWo1/Ik1UuV/q1B83eFZ14QsQ==
X-Received: by 2002:a05:600c:4f4e:: with SMTP id m14mr1164084wmq.164.1621900293053;
        Mon, 24 May 2021 16:51:33 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/13] io-wq: replace goto while
Date:   Tue, 25 May 2021 00:51:04 +0100
Message-Id: <031ec5e0189daa5b21bf89117bdf30b1889c3f72.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If for/while is simple enough it's more prefered over goto with labels
as the former one is more explicit and easier to read. So, replace a
trivial goto-based loop in io_wqe_worker() with a while.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a0e43d1b94af..712eb062f822 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -538,12 +538,13 @@ static int io_wqe_worker(void *data)
 		long ret;
 
 		set_current_state(TASK_INTERRUPTIBLE);
-loop:
-		raw_spin_lock_irq(&wqe->lock);
-		if (io_wqe_run_queue(wqe)) {
+		while (1) {
+			raw_spin_lock_irq(&wqe->lock);
+			if (!io_wqe_run_queue(wqe))
+				break;
 			io_worker_handle_work(worker);
-			goto loop;
 		}
+
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock_irq(&wqe->lock);
 		if (io_flush_signals())
-- 
2.31.1

