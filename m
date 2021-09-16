Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91A40D289
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 06:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhIPE3S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 00:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhIPE3R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 00:29:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CF0C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:27:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j16so4758373pfc.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHARU7s3O/uDpULGZmZVq1246qJjj22HEkj1xOAJHKo=;
        b=jzxM8ByoA8ukLbl6Z+uRA22VIWyzOZCOkEP8s0f5bRP6N7oSvtKLYWya/CapSdctoK
         OR44Sg6kmtlVdHtPgu7Mmh0SxPcMn3Xk4lBL5bPyBHtT61feOH9HAabUAyE9LjW8C92w
         +q1eimLBpTXEZm9f7hn/1eoo/IsPtFA+eIcd2Zzig3/WaYVwDuFAvwL6Hky/58STg/n2
         6JwiKJmPqvnRzKvm4mAEFfZBaahrk7JwXO/5rpaR2BPVLPp7Ut86p/W8/6dLR5E6j2Sq
         b9BMumo3m/CvZnge0nIcEUUMK7WUuYPZZnYDKw/OmYqmZu8vJHJRMVUgrtZZnzGsUsrP
         6oTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHARU7s3O/uDpULGZmZVq1246qJjj22HEkj1xOAJHKo=;
        b=fATwfpFhwZ3mWftQrOXl/ZhANNTwb5gzjvq1GSm+K8UXOs3vua8Q5ZQWwq5YeiDtCY
         WHLHbt7E3ilGN6ssNpZu2+68InM5c9RsmBw2fu6O9wmA3XGYc3nspSmBtwMzEipNd3VK
         wSssJrpWG2ZBqUT2Ly5wyXw9ZE43XqcgyhLGxJfy8fosVGJlLiAeKHDDWUPXijnPSZTN
         teSoj9o5lC9MbWGu8tdpwQmZkGDwKqA/lwSgkY5qTR02QQ2+iPF74EQcQ1D9K6bC8rog
         mYxXPZ+VYfBnvT1fchqxzB+etoNiZf/0wB2vgwUXHDzQOvRDd8PizeG66MafLV8zYtD3
         BOwQ==
X-Gm-Message-State: AOAM533iP+Mx39V1hMrDaqNX+OMJQuimezyEA8glQn3BFv6VYbKkeK0h
        +5v4FW5Mpbd5XR8ssxUnrDI=
X-Google-Smtp-Source: ABdhPJwg9nnZ4ugezPEVEYiQjeBlYyEQlIZS2dgAf9tDyzSAZklhBpYGJOscUSWyaP6f2uYdlJOivw==
X-Received: by 2002:aa7:8088:0:b029:3c1:1672:2f25 with SMTP id v8-20020aa780880000b02903c116722f25mr3204097pff.22.1631766477637;
        Wed, 15 Sep 2021 21:27:57 -0700 (PDT)
Received: from integral.. ([182.2.37.93])
        by smtp.gmail.com with ESMTPSA id q3sm1521216pgf.18.2021.09.15.21.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 21:27:57 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 1/2] .gitignore: add `test/file-verify`
Date:   Thu, 16 Sep 2021 11:27:30 +0700
Message-Id: <20210916042731.210100-2-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916042731.210100-1-ammarfaizi2@gmail.com>
References: <20210916042731.210100-1-ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 45f3cde..bd0623a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -54,6 +54,7 @@
 /test/fc2a85cb02ef-test
 /test/file-register
 /test/file-update
+test/file-verify
 /test/files-exit-hang-poll
 /test/files-exit-hang-timeout
 /test/fixed-link
-- 
2.30.2

