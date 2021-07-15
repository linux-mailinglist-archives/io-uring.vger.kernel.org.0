Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CF13C9CD3
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhGOKjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhGOKjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C06C06175F;
        Thu, 15 Jul 2021 03:36:11 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id oz7so4688618ejc.2;
        Thu, 15 Jul 2021 03:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wzJqs9cxilHIENiONBLdLggc6lvi7ZWmcjeK3sDHhqk=;
        b=AjrBbRWjF4HXv8tUaouRMBOMyihearAF0qvPcosRglhoySCH5vq5+JF/HcWsa3hIeP
         DSwYfC5I115M03/YX3+HjPh4IE+V3OUTHoLSaCs7RXSDcBJS6VuT5R0EGpllRpyyjffO
         k9spHNDhKrLKuDJD7/vrRAI3QcrGfLCyGnHGfLwAnAHF3IQX5DbPVAo4AY4birhxt/OB
         +5GY0uU/PEPTuEdUt5yCmRlar7kBh6zF19IQ9DarlERDRivRDL/YQse/Q2r2dIEf5TZN
         y7IDYl4CIpeB4g1p4fUuE5EvJjSHvwm3AekIgvjkytppG36qsMIVi4HlY1eHzkCJl9oa
         H7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wzJqs9cxilHIENiONBLdLggc6lvi7ZWmcjeK3sDHhqk=;
        b=R3ecLHp9ehLZMXu7hn5oao2FDKYpUscrT21b4oJDH0Y4mhrlNmkZxBR2c6wwvmURDh
         6/jbluHULjkoRpKhKSrjtvQLXv1/l+iX26tpiSjdjAvtt30gGlsLWNuWOLnwZCKHE/E2
         0eTCasnokCfGhr0Ng+X8WLjKCWAm/xfyxfNvXKmQns2WGBxfzvHyj4w0zXQ0aTZ/rzDf
         RRighUU3BNLjuMhx9CC2cn2gCWgjVeEMkHKvGnbvy/uGWZTC9KvNCeQjee+epcujeWhm
         PrYc4eZltm4f88lLhzxoPulG6Ly6XG5xhA8tamIC866DXP2prU2d4VG7iR4DAjAjDGLz
         jDPg==
X-Gm-Message-State: AOAM533/np50FyLtjkbHdy0UfQzmelUi6Ximu+AFvd3lhKjCWK+1qjaE
        CkbWVWDk8d+gylmB0SmPqbl0q/rgVqCm/tO+
X-Google-Smtp-Source: ABdhPJzw/zoZ0StK33m3kcX+YVbk7SpqgBUODSdE1XQnutplL+xxwTpd3rZGOT4xZGG1pLGg/0CkZw==
X-Received: by 2002:a17:906:d1ce:: with SMTP id bs14mr4891705ejb.183.1626345370482;
        Thu, 15 Jul 2021 03:36:10 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:10 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  01/14] namei: prepare do_rmdir for refactoring
Date:   Thu, 15 Jul 2021 17:35:47 +0700
Message-Id: <20210715103600.3570667-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
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

