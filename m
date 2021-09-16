Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D36D40D291
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 06:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhIPEdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 00:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhIPEdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 00:33:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B17C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:32:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q23so2631878pfs.9
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IKKFiBYRwo8gBTncII6hSGlQKyzgSrn9RC6gYrPdVSQ=;
        b=JANO7SMkUo2oDvfmme1ImDODrpPOdJIZ7/vr3StG0giPtQiYYiHG7B54LwRCaKNc56
         whlQKG6kHxvWEBWNY7+pdRQf2DgHVCzH7doU0XYwEHkkHrdkLfsULu6XlKrcD5aSZemo
         gesvzJr4sYVQO5qHTZh94Y3juzBjam3FeKMuOZCbwgsVMHgrSnM4EJjJN79ZO4RDsnhT
         NdA7/L7rLgtkKee3iF72IZ2CfoZ0ffHEHQByyqIcCX+tFVgzImHLPIzzzE1gtRTGT4xH
         r/9KPhpknmGkphHLz1eHmkGXmT/LiVZnP9rS0JSk9yx/S/iHA13UaKymW3coDi/L1nDz
         EyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IKKFiBYRwo8gBTncII6hSGlQKyzgSrn9RC6gYrPdVSQ=;
        b=4JETUtqpJ50XX1MbuXK+PaQcDYoydFEGQmS/IAv0K+boC2fgZYGf0GzfyvQNRjbgmQ
         aYa3t9x/fZjlZXZlmmYQTimUaEJ8JemtMivi8q8uwwt87qnvq6P69fP8j9GJvb/BKtY7
         tUuY5qdHsWqri+ispwo2YLeyP6hToApaNtTh2v4G0ER0hauc5bSUt/bP3t2DTN001loN
         21Ou3DpZY8XnUk8RQR6ZHGikS9HYAhG37To826JKPZF5iDcvIgR31Y36zdzxjih0FJhP
         /kxy3aELG8lBQ3S43ubDkrTIy8IziYsf9H5x37A4rIzm+dGvD4u/PkWm4rVBCU8N8ylu
         gliQ==
X-Gm-Message-State: AOAM533PwrcvVMhCLELFng54ORTZ5dv8dEX14GB/XnEFkj9mTBPpPt+H
        sSmAjswd7cwmt/wx+8Qj3v55aHW4VXI=
X-Google-Smtp-Source: ABdhPJxoKV8JqhkWjKfnOyYBTciILABWj4Xi2slaY6sGXm0WsDStXw4aAHEGMEVLk+2R1Zo1zYfEdA==
X-Received: by 2002:a62:7985:0:b0:437:36f1:d0df with SMTP id u127-20020a627985000000b0043736f1d0dfmr3060256pfc.52.1631766721444;
        Wed, 15 Sep 2021 21:32:01 -0700 (PDT)
Received: from integral.. ([182.2.37.93])
        by smtp.gmail.com with ESMTPSA id t5sm1305076pfh.140.2021.09.15.21.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 21:32:01 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing v2 1/2] .gitignore: add `test/file-verify`
Date:   Thu, 16 Sep 2021 11:31:42 +0700
Message-Id: <20210916043142.210578-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916042731.210100-2-ammarfaizi2@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

v2: Forgot leading slash.

diff --git a/.gitignore b/.gitignore
index 45f3cde..bd0623a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -54,6 +54,7 @@
 /test/fc2a85cb02ef-test
 /test/file-register
 /test/file-update
+/test/file-verify
 /test/files-exit-hang-poll
 /test/files-exit-hang-timeout
 /test/fixed-link
-- 
2.30.2

