Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8503EC3D1
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 18:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhHNQ1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbhHNQ1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 12:27:18 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBCEC061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:49 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so17491623wrr.9
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KxstxU9zNqFzYoWEM6dfTjvG3yGOl98F0ISMkJJ/K04=;
        b=ixMmz5LBGrxkd9japv8ZIu5AB5rtYwR8cKPybc17CXoqonM32s+WwWfalGEyu5Bq9j
         dx9EQ3sy5zAE4m/HEWvlNzjrSdBMYZI9gY66113gMrvPS90pIcIS5SEbXFG3xZwDCwW6
         xkA4M8fiMoNdZ/ms7QpnJx9AOVXr/JyD0vTL3/Ixv3qKtQkHnP36DBNQKHKcYGPEoG9+
         97FUT2SlmHUG64N08RDnPzScZP3iqDaZ3spiQ+OmmRTOeFjC4ebIR3Mo5xIiMkO50UuS
         qc4bTH/Z7iU35WtsBLxesaTWCbeQFiqICz61MDsFM7g9p6OXTUnzSpF2MZLVEZGPvQBh
         kHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KxstxU9zNqFzYoWEM6dfTjvG3yGOl98F0ISMkJJ/K04=;
        b=qpDtHMnjvNHV8szoj5YZTmH68q3hFifL0m8J+y7GIiYUZ3FKbYMkCHLqx/EEGUrIfO
         5Oxm4FFxJp6JVP3wbQG5Z62udm5uCinaM5f9IbTaFdXIjPeVjoB2ahaFNBKexuFX/m0t
         JHEFLb1UG4QqUPMHkhCCjAFnyCqp8BmDEmC1cKAQkK/IYDEFDG/OL7fqYUW0763qP5v6
         8pyREAI683KdvrJL6mipVi4ayPNq4gN+WgzZWZ8C9rub4ppRIfZmIexlnZIw0JHVvBco
         wbvyAcJTapM1fmyvIs5k+B6chXTtKT498RPKO0GNTaJX9IM/92cd5cZxr8NtQWU36l8a
         08Bw==
X-Gm-Message-State: AOAM531ouxMP6GiOPw7m9s1YgkLXjJd3geOaKbBUshcXSCEEcn9xvs1f
        rj90qkBF/VOgdibRw5Bzugo=
X-Google-Smtp-Source: ABdhPJzlTZTH+9FAesj+4Coi6EfCXa5bjO0WJE/n7iBIvL1qBX0LydN/Cq6lNzh+ZpkzxkJnyPlQMQ==
X-Received: by 2002:adf:ea09:: with SMTP id q9mr9079843wrm.64.1628958408400;
        Sat, 14 Aug 2021 09:26:48 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m62sm5028263wmm.8.2021.08.14.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:26:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: don't inflight-track linked timeouts
Date:   Sat, 14 Aug 2021 17:26:07 +0100
Message-Id: <c1c1d3086dd08ff8acfaaa79ba7b06d111915cc6.1628957788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628957788.git.asml.silence@gmail.com>
References: <cover.1628957788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tracking linked timeouts as infligh was needed to make sure that io-wq
is not destroyed by io_uring_cancel_generic() racing with
io_async_cancel_one() accessing it. Now, cancellations issued by linked
timeouts are done in the task context, so it's already synchronised.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d9a443d4987..d572a831cf85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5699,8 +5699,6 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	if (is_timeout_link)
-		io_req_track_inflight(req);
 	return 0;
 }
 
-- 
2.32.0

