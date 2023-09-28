Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCB7B23D1
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjI1RZ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjI1RZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:27 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0DB1B7
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9ae3d4c136fso335440466b.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921924; x=1696526724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwcbO19kHoooGXVXpd3ZWHbtBSLBsnmpj+7juMc3wkU=;
        b=l6I6EJaiBTJeRurbO3Mibnbw4c7dcTayckAOEsk+pS32rJSu6FGyiAQnde4ixFsjyn
         NhxA2+1A922UurrqCH6aqjWiwF0TQL/G0uePsaukxAzYzH6N3mSU9+EUiZ2mn4S1Boeo
         UATV3oxi5RbnMAM2jgfk5W92jFRWnW1drRZzfjH8WIH2/PRluCh9hb+/+wpvpbB5Dlm/
         3z8qNdGssEw+ZVLgGNy6FvMwoZ7cerGuzTg5HamuzlPbVT30F8rHOb+kSoKeeW648gtz
         oWPHrYqYK5UoBzhk5qmvaGkCTNbyxMPH0ahjbz3B3Q0fIMeU/xaumzx0OxtJ88Lj6qLh
         0Mug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921924; x=1696526724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwcbO19kHoooGXVXpd3ZWHbtBSLBsnmpj+7juMc3wkU=;
        b=rmlQxhAirLxh4lkY5qn4H+yoYtlO3F0nOYJbUzKrlLPqNqlDLLu5Oa3PbrFifh7trv
         x+nhKCeHAX00631wj6JFwUP65MlDmkQ3jljdSV0kqGL7TRjIDo+gsvacA6OA+o+CtYKS
         dN1f0Ixtn5UcE7jBOTuKYSOQQdx0OZojcLe176FIsHVtSAYtOkpVboa9OfczeahCFSYU
         GpcKZqkfIgl0U/2vCQFdsya3vwwKDCtOx0XXBrYoeyF1Dgf73M1cWF4VxoCpq4fVkY3V
         rjGDajPonYm4fow+BOz7NB/KWWGbtShRblV2IwLGnUtFFe6vLc0AUfjb3y917d9YaNfj
         MgKA==
X-Gm-Message-State: AOJu0YxYy7oDRVoKVSaaoPKgnA0ETBuA5H52xzTiHVleAyIMmpEcehhv
        Ys6O4WrBQfC5fFnEn3iBR9NUxhLUt/lPprBojSUnEigm
X-Google-Smtp-Source: AGHT+IH5PTU0ovSZZw4UQZLnYsvrY0gHgAqi1x1w4d5GG7gCr7v7vSaW+30EtCIFbXs7GRRlSsxM+w==
X-Received: by 2002:a17:906:2258:b0:9ad:e66a:413f with SMTP id 24-20020a170906225800b009ade66a413fmr1695851ejr.3.1695921924096;
        Thu, 28 Sep 2023 10:25:24 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] futex: move FUTEX2_VALID_MASK to futex.h
Date:   Thu, 28 Sep 2023 11:25:10 -0600
Message-Id: <20230928172517.961093-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need this for validating the futex2 flags outside of the normal
futex syscalls.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 2 ++
 kernel/futex/syscalls.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index a06030a1a27b..a173a9d501e1 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -52,6 +52,8 @@ static inline unsigned int futex_to_flags(unsigned int op)
 	return flags;
 }
 
+#define FUTEX2_VALID_MASK (FUTEX2_SIZE_MASK | FUTEX2_PRIVATE)
+
 /* FUTEX2_ to FLAGS_ */
 static inline unsigned int futex2_to_flags(unsigned int flags2)
 {
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 8200d86d30e1..2b5cafdfdc50 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -179,8 +179,6 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-#define FUTEX2_VALID_MASK (FUTEX2_SIZE_MASK | FUTEX2_PRIVATE)
-
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
  * @futexv:	Kernel side list of waiters to be filled
-- 
2.40.1

