Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3420CA41
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgF1T6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:38 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37543 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:37 -0400
Received: by mail-pj1-f66.google.com with SMTP id o22so2026002pjw.2
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vk7t75vGYw4Yl1hY+pAqMimacW4uZgAxQ8T/HD2+2jg=;
        b=sHvoawlj1Cg19aHYRgPeKZMjtU+AR9zOiIRIyx37ifzIHtumjzEmKx1vB4N8DZiL5J
         JAkRStLrJHXxGgMjpyEpEcLiLVqFKV7WwccdfqrnA5DFbp7505NkSZEOW9HYonkOrV7x
         +bI1+KISZFbNBHHx7MWAxDhg7Z74tAEWBxwt/4dp3t2U2arPfD8j1RG6Po+7oJbFnS5G
         /XAloYxB4p5GxsOarqnA8yhUyrtahTCUraGU/jFRpCWi60twnQkw0UZCS5Jy+z5RQs7g
         WkN/VjURP2cobP8wcD5ATZQBM1gJgu9sNFSqQfu2Ee0N0dMUuhWwjyVsivaBie4DQrMU
         yFKQ==
X-Gm-Message-State: AOAM533qILS08hbggZxmoLLauyuJpxMHSvOT5BjyAWI6hfoJ7FT+JSUv
        ZgALDReEJT5e1UQHVEwTTzKEVYG1
X-Google-Smtp-Source: ABdhPJzvNdU0/TexIO5Wxr100+MTpK2sKdJmg65Zll0ZEDTXwbcaNgimItyrXNc82E6fxtoAzWh4yw==
X-Received: by 2002:a17:902:ba81:: with SMTP id k1mr10952924pls.218.1593374317166;
        Sun, 28 Jun 2020 12:58:37 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 5/7] configure: Use $CC and $CXX as default compilers if set
Date:   Sun, 28 Jun 2020 12:58:21 -0700
Message-Id: <20200628195823.18730-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change causes .travis.yml to use the compilers configured in the $CC
and $CXX variables. Additionally, make the configure script show the
compiler names.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 configure | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index c02a97875862..223192b8a5f9 100755
--- a/configure
+++ b/configure
@@ -9,8 +9,8 @@ else
     TMPDIR1="/tmp"
 fi
 
-cc=gcc
-cxx=g++
+cc=${CC:-gcc}
+cxx=${CXX:-g++}
 
 for opt do
   optarg=$(expr "x$opt" : 'x[^=]*=\(.*\)')
@@ -315,7 +315,9 @@ if test "$has_cxx" = "yes"; then
 fi
 
 echo "CC=$cc" >> $config_host_mak
+print_config "CC" "$cc"
 echo "CXX=$cxx" >> $config_host_mak
+print_config "CXX" "$cxx"
 
 # generate compat.h
 compat_h="src/include/liburing/compat.h"
