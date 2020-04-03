Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006D019DEEC
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 21:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgDCT5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 15:57:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39958 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgDCT5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 15:57:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id t24so4035575pgj.7
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XJeSYTzoZD7V8cNkO4sSVLtQGRkqw8/8JoFECD+BUKQ=;
        b=Vb15zMNwnIjq9XInfeS+SdbxwKf2kydd1ZUX5U0agug0MOOGVxwH4P+nQmQL8jDfmA
         E46RfTKbEoOSQRmVm80eqZGK2EVQ0xR5tvZ1Hl4UtYlz0+ztPapmvrY4pJxoCc0tEw/s
         nCaurvi8IUQ0/oxvrgy6v+XLd8+LEIpsvaE+PrmwEONK7BRS7kWjrDPjVBVicmLPXQUN
         hh8O/BBEWZhNeSFNKYWHuYfBCb1scApdPwFwSb1jL0t9qIa8EYb5BIxxvUtisq6mTBoy
         OVOUC+WKVcQ3vmq5MUPXQBiuAIde/0x5Dhok9bvei/Q8zqbji6K6P7NR9STCiDVHFfN9
         HKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XJeSYTzoZD7V8cNkO4sSVLtQGRkqw8/8JoFECD+BUKQ=;
        b=kWk5I8Ro8qkAkp6ueoZCfOgwgfDWfs+NyALY9Dp2XCUXgaByWIc03lW0lEkNR3tKRj
         LfaBUL5LjupM0/4XXmwF/qitv1pAj5sYAi9pcPZhQhD0RfY5Aggaavtclw6NFsLj6KXC
         TCCZPv9oOOm4YCjPdr0FUOedhfDZASDz7xwGg6FhG/BHprBXL7zfOycfJyolO1kbbV2f
         XOjv/idS/7QgGoe5Wp0DzKNpBU7czGx98uFxlOT+mW94M5yPJDbCEQFMQiNA++zmJYhX
         9Ue7lkEppAofEaOTuEg5b7Xj0l2pUS9/e6EprScODTIbbZd0Nr7ld1R+XICCHtd9yyL2
         L/oQ==
X-Gm-Message-State: AGi0PuY3i10D7JRiZaV+S2Avr73xqcSrb9iwwhoeHNmDGkvVDUudEbAq
        3j/1gFu9VVaJ2FoBg+p80MW0YUG/hZdm5A==
X-Google-Smtp-Source: APiQypJVWYDTLSmLdnboRIRIZ2UvpisQeG/rte9iXSdQRkVLvc8Ic09j0MEm0/+tLeMy4klNUqfxUw==
X-Received: by 2002:a63:553:: with SMTP id 80mr9727605pgf.147.1585943861355;
        Fri, 03 Apr 2020 12:57:41 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::15af? ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id i34sm5741328pgm.83.2020.04.03.12.57.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 12:57:40 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove bogus RLIMIT_NOFILE check in file
 registration
Message-ID: <30feca68-3d80-5c80-4139-5298a1aff733@kernel.dk>
Date:   Fri, 3 Apr 2020 13:57:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already checked this limit when the file was opened, and we keep it
open in the file table. Hence when we added unit_inflight to the count
we want to register, we're doubly accounting these files. This results
in -EMFILE for file registration, if we're at half the limit.

Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2460c3333f70..ce76157c2f95 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6216,13 +6216,6 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	struct sk_buff *skb;
 	int i, nr_files;
 
-	if (!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
-		unsigned long inflight = ctx->user->unix_inflight + nr;
-
-		if (inflight > task_rlimit(current, RLIMIT_NOFILE))
-			return -EMFILE;
-	}
-
 	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
 	if (!fpl)
 		return -ENOMEM;

-- 
Jens Axboe

