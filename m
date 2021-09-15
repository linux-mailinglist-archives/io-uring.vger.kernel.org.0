Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C72840C180
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 10:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhIOIQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 04:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhIOIQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 04:16:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F22C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w8so1931834pgf.5
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3v5pICzI7YAo93jE7aozDJ4Qh239loxBwANtjiKwei4=;
        b=UAoTIrQ8s6ZTdjJAKRfy8oTvgEOTxHlbDQNUPjSoFpEuTbyqwrwH0ngYqS/tJya4Gv
         wbxMOJOxXkxG44iLnDIKao+oc50BQ6H3f4jMzfi1syzBinj5Zmc87NCd6fGThByNHEOc
         J6KE56XrZLbxANZ01izvnWxj+iVe6ztxlYONX+roU9Wg0kS5Zkn0BGkdvhj7OfD/RAiE
         OG6fyNTOFD2iluHBByrN2PqalJiE9fs7Gn3BM90r111YhqEgIlYHZLahH62rEZgw5Pfk
         Cgywj2IzHnwSKEjAt+2+8N7Xxg19kyYpDMLKQ6dal9c6175NF7/MBU0tYnGrekWi7GwO
         n8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3v5pICzI7YAo93jE7aozDJ4Qh239loxBwANtjiKwei4=;
        b=yoodQyRMdsC9An47n+nQFA2zqCvMaPVf2/cPtvSDjf8oF5VCrh1L/YMYDKxYutqfv4
         lxxo4rnBVFpE5ACqvHWMfy/d8gFohvSTX+ghYO53JxQ9g2ps2zYwScdTN96sxs/eoI8S
         Zgi94DgqXwLthFCPR2oZZz2YpF3NZjTtS0R8hdp1/LbzfB/SNbQMokfJ0tp7OryH+ak3
         +g1o5pCMYoGO0SFWGwP93CbqcoxNFIxQa9eQ2ixFPogxejjCZcJ70fvQ/CNNH2XKOnw6
         MVbq0hpYVI3kJFDjN5UcHlJEC6egOk/nsm5GTUaABsZ7g/HLkr1OeTWvqRpQhsOKBkoG
         /lsg==
X-Gm-Message-State: AOAM5334n6t85IZK+CWHI8eA0DdDEOezQKgs6oPKZxcXGRwpIvHGUWYu
        oxjL/v5OoIYk0nbiShX6Nk4=
X-Google-Smtp-Source: ABdhPJzYdwIVK9PwUpr8xXxn/FitrrPoHj5ZuWjdY5uXFsdarGoUr3GgTIpTQiaWXOTUnISH5IJdmQ==
X-Received: by 2002:a63:cd48:: with SMTP id a8mr19553482pgj.180.1631693690873;
        Wed, 15 Sep 2021 01:14:50 -0700 (PDT)
Received: from integral.. ([182.2.71.184])
        by smtp.gmail.com with ESMTPSA id x22sm12643076pfm.102.2021.09.15.01.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 01:14:50 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 3/3] .gitignore: add `/test/output/`
Date:   Wed, 15 Sep 2021 15:11:58 +0700
Message-Id: <b9aacc68090774c08f871720d3f8b575e62f8807.1631692342.git.ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2d53ef3f50713749511865a7f89e27c5378e316d.1631692342.git.ammarfaizi2@gmail.com>
References: <2d53ef3f50713749511865a7f89e27c5378e316d.1631692342.git.ammarfaizi2@gmail.com>
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
index 0213bfa..45f3cde 100644
--- a/.gitignore
+++ b/.gitignore
@@ -131,6 +131,7 @@
 /test/submit-link-fail
 /test/exec-target
 /test/*.dmesg
+/test/output/
 
 config-host.h
 config-host.mak
-- 
2.30.2

