Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5983C9D10
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhGOKso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241613AbhGOKsn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF3C06175F;
        Thu, 15 Jul 2021 03:45:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w14so7422215edc.8;
        Thu, 15 Jul 2021 03:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wzJqs9cxilHIENiONBLdLggc6lvi7ZWmcjeK3sDHhqk=;
        b=RcDFthTCV4TOFu9dTLpXXrh3Aaj+Y5OETVo0gIUNIODO9zllsuIlwp5Izkv4gOY+w0
         c5h8cRD2Rfb6a+Jb7KPmYU5Enzq/PHwk/Y8pSv9AV6wQ30cfFcDbJWmgl154LYmPAIC8
         IqNfLci7CfY5VyMBEUCpEaj5ttroop0gJgKUhjJUscrYR27bccG0FvDPNMD5PyX/HTlB
         dZqVLDan0ie8F6J5f52nrfGOH/rZEqq3prjadIe5elrX/8LTydJWhn6yg5nX61G1fELQ
         etftdIi+/KgtTRegtZ0QvB7xJdhRT3EvTalqkOt/25/Q3AuemEHyaDH4dJ8Qml/Wo7Af
         xaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wzJqs9cxilHIENiONBLdLggc6lvi7ZWmcjeK3sDHhqk=;
        b=MB4j9vCNsYz/WIaGAYSQ5OgZ39YmC7QrDQm3dnaAyXvyiiiSZCG0/nq+PxNZI9REc+
         uN0typJYn+dJ5GKr8Sd/TeJ4B9fEb3BofTk86wuGXBTW2h88BcJqoKcNodMn5of0JX5k
         zgJMg8xbiDzJN3ZSFLHhs47A6xxRH3cNl0IkpKwmctng3ou0A4hzN892tDWJ5pTBCWRF
         ofFRXfHZ4hEsKKcaEVdPxmrxP8L6A0QoXL7E96S46JKtQtiSohtpL337/nmarvMdkXCX
         CvLFFOcsze3RTwkRY8g7bnvbZXhCXSzvjq3FJFEwVzTLVxo8bkKjPVHLShjqcyRQW6Re
         5Vjg==
X-Gm-Message-State: AOAM533SpcPwI4Nm9zsQAHnevEo6PgnxApqw1H5pLVqBanVSrJvAR+TA
        1dF4U8kJ+Yfsm0RS6wqStug=
X-Google-Smtp-Source: ABdhPJwmAiAbqn3u8vr8Sz9H6rXDZFMqwEfbYn0VNLTkpSDweMhNdTYge9znG1S0jAI32p7f7pXrQQ==
X-Received: by 2002:a05:6402:3192:: with SMTP id di18mr6180049edb.186.1626345949424;
        Thu, 15 Jul 2021 03:45:49 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:49 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 01/14] namei: prepare do_rmdir for refactoring
Date:   Thu, 15 Jul 2021 17:45:23 +0700
Message-Id: <20210715104536.3598130-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main rmdir logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Two changes here:

1. Previously on filename_parentat() error the function used to exit
immediately, and now it will check the return code to see if ESTALE
retry is appropriate. The filename_parentat() does its own retries on
ESTALE, but this extra check should be completely fine.

2. The retry_estale() check is wrapped in unlikely(). Some other places
already have that and overall it seems to make sense.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b5adfd4f7de6..99d5c3a4c12e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3998,11 +3998,11 @@ int do_rmdir(int dfd, struct filename *name)
 	mnt_drop_write(path.mnt);
 exit2:
 	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
+exit1:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit1:
 	putname(name);
 	return error;
 }
-- 
2.30.2

