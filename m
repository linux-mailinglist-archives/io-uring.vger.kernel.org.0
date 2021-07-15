Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D63C9CDA
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbhGOKjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhGOKjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:11 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0375C06175F;
        Thu, 15 Jul 2021 03:36:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x17so7352776edd.12;
        Thu, 15 Jul 2021 03:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+MzqW1FGpWE2/HiJKOcK3CZTGi1+seN/N4XAEsKSZdc=;
        b=Ted1BYctJSCxbISGbSsNCjKXurpNL62YS2kRbLifNPFOEeKz3WY8IrdTuyZ84VXzkj
         acoAwrU3D+wzw/eyPmso9pyo+wOuiGFWB0ZRGxIOrhcC7Switewy1uGRlt0jkklYxERD
         Pz9IxJtDTIGDtw67Nowrt+B+MYxlST1NZksOy/5w3P8dnQvXAPsLE/xVJ7BL9gCpkXFQ
         y4ZINj6pFEUDiHJXjIWvCKMEUTQJd9T/6PqtnPV+d1iLhezHKR37LQhoJBuDoAJGxAVG
         rHsEBVA4oNqdeoGyec5t4O4vP/I/L85rQ8JgFmycD2wgvxW893u1sWz2ll+U0XobR/ox
         2iXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+MzqW1FGpWE2/HiJKOcK3CZTGi1+seN/N4XAEsKSZdc=;
        b=H65Z4RluYywZy5XXIuW25LX5i0lNfiaH7tpfOwOUZAocO/Yjjn2RiwYOMJ224LfFt4
         wOw9b+tXcdxMhV4McASmi6/IbDhTWncgWJdNF6qHo2HzhvRfuDRsL2OTomlRm3VOsaRN
         H3FrR1Oo5oQMqbpRHLiYTNxCj6OjUV40Dpg+k1NxYD8fjFdp3MWfYql1CGtAV06Wal1Y
         AX4pdMHyeyxDtxy6k6zKiNpK7dyfnXUAvg+giI/wuYUZSPchrAt3m0cDnkf2dREzNY5F
         g+FHbYb10GYUknT3Hvyjld1tjLzb06hy8wX7bzON41TDWUxFXXLN3ldZ9dYAlLCFQYtk
         z6LA==
X-Gm-Message-State: AOAM530hdj4nU9VfUoi9athAh/QsWGnHDaNdhdv6jSLt8Vj0z71ArCYY
        2dNeKna0SE2XIR1l2nhGOAA=
X-Google-Smtp-Source: ABdhPJx6iav4p2Q0EIHf7kw+DbSivAtmM0ecFiPlrjPRVkr0D6A5vxkCMxc8fGbrw+E9x5Bue8wusA==
X-Received: by 2002:aa7:c804:: with SMTP id a4mr6031749edt.294.1626345376585;
        Thu, 15 Jul 2021 03:36:16 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:16 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  05/14] namei: prepare do_mkdirat for refactoring
Date:   Thu, 15 Jul 2021 17:35:51 +0700
Message-Id: <20210715103600.3570667-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main mkdirat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Just like the similar patches for rmdir and unlink a few commits before,
there two changes here:

1. Previously on filename_create() error the function used to exit
immediately, and now it will check the return code to see if ESTALE
retry is appropriate. The filename_create() does its own retries on
ESTALE (at least via filename_parentat() used inside), but this extra
check should be completely fine.

2. The retry_estale() check is wrapped in unlikely(). Some other places
already have that and overall it seems to make sense

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 703cce40d597..54dbd1e38298 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3861,7 +3861,7 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		goto out;
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3873,11 +3873,11 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 				  mode);
 	}
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
+out:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
 	putname(name);
 	return error;
 }
-- 
2.30.2

