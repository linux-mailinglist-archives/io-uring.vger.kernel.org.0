Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01F3C9CD7
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhGOKjK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhGOKjJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA34DC06175F;
        Thu, 15 Jul 2021 03:36:14 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hd33so8460399ejc.9;
        Thu, 15 Jul 2021 03:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gv8tSwp/UrSv6bP9FmaW3UOv2WYkCE+hVRpziUUM44U=;
        b=arbCitrRmd16oFgRa6rxEQCAEiz/etRpQ+SV/aCz4QUTXOD4iLgFWC5svyOACfPdvF
         6+dFK/lZSmi80MbGiASaialv0062VaGEEqsBohM7aU6SQASIo8huztQWJ9LtOVaVeE44
         l7sljdNhm03j1rexAUdA0PW1qhKg+aOgV1fjN8Y4mlweoqSI6ZzdMUT9svPBPoijMoNh
         NQOXYwh2NdLneQlYOQn2Cm/eaRu3iieYaBoaiRJH1E5KUAaaLWS8F9MEZWnALfFOva5Q
         kTHsJrEElsT/FWnkxRWVx9kKdzX9bx9eJ1EUWyARE0QYqyjUGWeAElEB2+5LOQP1eEU5
         3KAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gv8tSwp/UrSv6bP9FmaW3UOv2WYkCE+hVRpziUUM44U=;
        b=Kerxz/MoQYi48ksB2ywrHp2sY2CEenhA3vs36A7u/Jd1bpJlWFyTyxG6qL/DhTax+a
         O/psWxEqeJpkm3Phkb1hLjZ8akwx0Ss7UFLRx7hcGG9BmA34UnTkP841KHd7ttS8S3Hd
         HhxkN8NziC2qUDKfycGuIrEAhuwPwLweztJOHsSVmn4c0pKtmRfLyPNv9wekiW57Lns/
         3yEUOQ6ugT6LvxLygmVO5CtMlZnHGpHw1BC2Of9iVh/Ta7QIYWMUDXlThbE2PlGN/Vah
         9OTGZrfdX1PPku/TfLJTFEUrBF3y2nxSlN/nn2WDNB/nHin6d7NzS3lMHgP7Qdo+HgWf
         mJGw==
X-Gm-Message-State: AOAM533kHEMIcDBvD6JjyBf4VK/vZmFktRXoPVRST22kOTVbB4USYfar
        z3mCw5sMxebcpe9vO5CH5a0=
X-Google-Smtp-Source: ABdhPJzEiWbjuLg8RD7oDI3is9ZLR0jmXmhdG5XmXg0WKg+Adl29mbzr5o+xL/VMmAsu5W6Bn1FgNA==
X-Received: by 2002:a17:907:170c:: with SMTP id le12mr4970912ejc.288.1626345373584;
        Thu, 15 Jul 2021 03:36:13 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:13 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  03/14] namei: prepare do_unlinkat for refactoring
Date:   Thu, 15 Jul 2021 17:35:49 +0700
Message-Id: <20210715103600.3570667-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main unlinkat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Just like the similar patch for rmdir a few commits before, there are
two changes here:

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
index fbae4e9fcf53..6253486718d5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4148,12 +4148,12 @@ int do_unlinkat(int dfd, struct filename *name)
 	mnt_drop_write(path.mnt);
 exit2:
 	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
+exit1:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		inode = NULL;
 		goto retry;
 	}
-exit1:
 	putname(name);
 	return error;
 
-- 
2.30.2

