Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9673418E67
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 06:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhI0EkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 00:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhI0EkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 00:40:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248D5C061570
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so2782827pjb.1
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vSKs8Ji5MTUM3fPeHzyQ5NSmb40DUR9VKVWlsEA2gs=;
        b=ilrJGA59/w4hzNwyshxn6VupS2WTmhS93aHNoCsGTdxxWo3ztcSYQT90x4wpM+2OB8
         A0UtmoLWK1twHCZybDfo0klKtb7Q2X8F/6qCjKtyclEHqsWPTgCK3RM/B6yOQOyFV/+6
         8l2XwW9BC7Yuz63/ZzfJUbqeGMYUVWY238Cs9969vfhO38nW2gb433Fr5LGVBc1kGy8W
         thAL8Mv6v+lU8MbxnS6EJpGXvldo/BmP2ncDyPioNLnbgjaOzJrdq4wn0rRMkfXWVCu7
         wGpjgb4S9+qSD1S3yqufkDXmVBi4qI/hu6rvFMcomNkKY4z4debpjfq3t0nJoy+maBoU
         v2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vSKs8Ji5MTUM3fPeHzyQ5NSmb40DUR9VKVWlsEA2gs=;
        b=rRa7RTzqolVcYt6hncVEL6Xm26rqe+mKGJWGHg6AgMrC5twDN62ZFlp++rMZu8WPzm
         XWzIyjK1brLGxZ5/IkiDUY/Wx+IrAD81/wa01WO241jPUYHszL1LRTrtq/XNYUPoLWGq
         +qZQ9qExRodh/wKE/fa+7Ao4Mh8zO+nZVXMZ7cXJruWuRsKMBWTFfEk6RG1r3fnTvXJT
         4QQNET51EQEhcil8MNBJQ35LxNjc+33hzzNiKuNY8p3cVAhmF5JxBo3HiuI2ksXfsLPH
         x8lQQIwKs9ydProTKUObqiyEAbQVIO0t39C+tOBXA4D5gB/fApmu4PCrSEKDJKBBnWKa
         P6ig==
X-Gm-Message-State: AOAM532tvM6J82XKCegy4mC0uLTzXUS7ey6f8kv2PaqZEEmbdHb4irtx
        fwgAJVuI8Ruo9QLzjlv2x6FAJdmdDIf84A==
X-Google-Smtp-Source: ABdhPJzEuU8jXArUGzG70cXQalSCAS4nx+703ueQkGEqTG/sv95EWFBoLMCViQkEz55P/dk6Ytx6dQ==
X-Received: by 2002:a17:90b:1050:: with SMTP id gq16mr17555063pjb.181.1632717510722;
        Sun, 26 Sep 2021 21:38:30 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id l128sm15623040pfd.106.2021.09.26.21.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 21:38:30 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 2/2] test/accept-link: Add `srand()` for better randomness
Date:   Mon, 27 Sep 2021 11:37:44 +0700
Message-Id: <20210927043744.162792-3-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927043744.162792-1-ammarfaizi2@gmail.com>
References: <20210927043744.162792-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The use of `rand()` should be accompanied by `srand()`.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/accept-link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/accept-link.c b/test/accept-link.c
index f111275..843f345 100644
--- a/test/accept-link.c
+++ b/test/accept-link.c
@@ -240,6 +240,9 @@ int main(int argc, char *argv[])
 {
 	if (argc > 1)
 		return 0;
+
+	srand((unsigned)time(NULL));
+
 	if (test_accept_timeout(0, 200000000)) {
 		fprintf(stderr, "accept timeout 0 failed\n");
 		return 1;
-- 
2.30.2

