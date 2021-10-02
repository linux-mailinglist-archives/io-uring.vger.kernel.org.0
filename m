Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C941F944
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhJBByy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhJBByy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:54:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19922C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:53:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x4so7402417pln.5
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7qoYGc8RfOYlXJq+zVDzZKk/zkMWH2ad6cuIXegfdY=;
        b=ZUPkkknt1qxqIWfldpv+4O+BWqS/4l5pa7U3qc9QnVGPMKDgjR17rmnN/poNGFBgBI
         YPmRenxGjdMKUwbKOkbva8kCJhGUj6k49c/o9ESrxRAQznv3lvOPrm2DVR0QuSu57LCd
         UNqhvzpqcFZWsQSRyRPTtni0fhIxOz64bQaMW5yVUE/PPxTcVcdQrIiORlySf+q5Ttdj
         Vg2kCXJgGDWyR7dhFST452Sy3EKtNcSkc3/BqlcjW4GIvldeJ4ndxkifvJjH2fe52tee
         o6oiLBmjCi5W4NPQ3TbAVpY7Mol3rVOWnbyvcgF4fsRK2Sq8IVtBVtUR5Et1igrTjn/m
         fNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7qoYGc8RfOYlXJq+zVDzZKk/zkMWH2ad6cuIXegfdY=;
        b=wyHVWGLMgpCd38/ntYUAhgvuTfbd1JQbuncVvfDtjNbDUCXaVV45d+n9/aWPq96RhY
         +nL/33Se3kZr6kqr396WeFpVYszB5RSS4nf+lKZo69vkJRiLlKI2/NJVFlkdporbU9NU
         PEVzRbBk26vIj7D1hkviPbPm4+RBve8KL/Cn5/RjRW1683K2bsfyjO35l4FMrFvn94wu
         /Q/ZoAXWIMO6QuK+nWqxhjffrkdYiSAVGkrPd84IdbKGxOqDpiYMiGYLK+ANRlvlXiCw
         IlvaJyKc25yR4yQjja3qK66dn//hX77mjWdZoRNgfB6OxuikkY2cJFWWssfRzY/H/ieK
         94bg==
X-Gm-Message-State: AOAM531xxt8E0ioJvIvONCt7Z8f6MKM1gYqi430UOohw6AunqUimgutz
        xN6zwqhomztLT6MG5pVM2uJYIg==
X-Google-Smtp-Source: ABdhPJwVhCqArvitOU/88tgyHXYmZlsBTorNoBmTdrVF41bXjm7imf/OmBVIFLJ03lZ+GAIiaAJeyw==
X-Received: by 2002:a17:90a:7602:: with SMTP id s2mr23068645pjk.197.1633139588639;
        Fri, 01 Oct 2021 18:53:08 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id u4sm6989804pfn.190.2021.10.01.18.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:53:08 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 RFC liburing 4/4] src/{queue,register,setup}: Remove `#include <errno.h>`
Date:   Sat,  2 Oct 2021 08:48:29 +0700
Message-Id: <20211002014829.109096-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
References: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need `#include <errno.h>` in these files anymore. For now,
`errno` variable is only allowed to be used in `src/syscall.h` to
make it possible to remove the dependency of `errno` variable.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    | 1 -
 src/register.c | 1 -
 src/setup.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index e85ea1d..24ff8bc 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -5,7 +5,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdbool.h>
 
diff --git a/src/register.c b/src/register.c
index 770a672..43964a4 100644
--- a/src/register.c
+++ b/src/register.c
@@ -5,7 +5,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 
 #include "liburing/compat.h"
diff --git a/src/setup.c b/src/setup.c
index 7476e1e..f873443 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -4,7 +4,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdlib.h>
 #include <signal.h>
-- 
2.30.2

