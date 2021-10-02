Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E020341F92D
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhJBBba (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhJBBba (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:31:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D7C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:29:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h3so315819pgb.7
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cLXrzkhBh7ub+gRvCSepp4Xt9uGIFp5+KLFIU3bV3I=;
        b=FCEQsaeBOlsW/oeI5zyhCbDx3Vs1WC6F0IcE1yDGUq0cXR2M41+yYY9nZO9+YIHpSN
         lukGFn6A6u+kmlQUa9ZIdbC39DH03fJGMe8CVe93r3ztllZgM5hr7omkNPtOhFX/oi3v
         j0ux1K99rFXpJVy9kAUOcqfe4u0KvbOWituHuBfXKkmTNSkHOC9VmM21Gp6Ubz7Iu8yE
         R464JaymegKpWkJs1R/pPE6oIW9ncI7Dl+W2qALV0VzZ2dzqkiMkRAIDq5huWzsvZdbh
         0AgNpKutgECl+cjjbaDmfeLo5aimPQppWCiHuacVmaCcue/cTFATYgfTgIiETEyLq/YO
         qpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cLXrzkhBh7ub+gRvCSepp4Xt9uGIFp5+KLFIU3bV3I=;
        b=HbphF9NSkruvtmmH67Gz2v7wdeDzW0Yv0DWG7kbXXqmPDsjU9QtFYeE2X6s+MSRPLw
         BmFlKpU8kzgnVFF+3Aa3Ivab7ZewgZson66fYU9TeZi1sITTeKiwd+J6Bmx3f/xF3Od9
         UdvKICYWO6Eh6v2Y8t4/NOUNgHNoU+jMJNH9WjxZf3sD3AMWLrR6diJU+7PWhjKW+TD9
         WNeVAFtvQiJKnO2CDfxGReO13ei/rzfN7evBk2ZIgUjAymfsBGo0JQ3gV0HaSH6iugra
         XEvY6x5D6X5H2PdVYp1KzU3FQxbzPjGBkKwtyxuif5FLQqW4E2GWmY1efxskGZ4IT1SA
         iWuA==
X-Gm-Message-State: AOAM531/MKa9MrKBDhyPq11VmK6j5jMD+DfniE52WEOMOvPEZbUJBkWs
        1J3+JsrIcsM/N0nz2/p214RcTw==
X-Google-Smtp-Source: ABdhPJwGbGYxJS8q8KBD76/BBvCmH7l3EEoP/EdZiPNE/MOEsJuoLceWAyqBIJh1+SYf4PS+XCOqVw==
X-Received: by 2002:aa7:900c:0:b0:44c:bfc:485 with SMTP id m12-20020aa7900c000000b0044c0bfc0485mr8457273pfo.38.1633138184863;
        Fri, 01 Oct 2021 18:29:44 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id b13sm867654pjl.15.2021.10.01.18.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:29:44 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 4/4] src/{queue,register,setup}: Remove `#include <errno.h>`
Date:   Sat,  2 Oct 2021 08:28:17 +0700
Message-Id: <20211002012817.107517-5-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002012817.107517-1-ammar.faizi@students.amikom.ac.id>
References: <20211002012817.107517-1-ammar.faizi@students.amikom.ac.id>
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
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
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

