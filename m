Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BC83A1212
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 13:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhFILKt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 07:10:49 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:35710 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbhFILKt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 07:10:49 -0400
Received: by mail-ej1-f51.google.com with SMTP id h24so37874111ejy.2
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 04:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2OBxsaTpbwkO8bZLNcvPrwN82dGzENxh1xaU5bxzqg=;
        b=itnZWaW535G77RtuT/9xYjszAAFQU4NVs2K6XX8VMNfNXavQ/CtPn6tJUmfwagSeqY
         9ujdLoVRaYECdJDq706Zl9fhNKAPtX8NiI/I/cmD3y0Ta4OOo1WV6ZLbKudQgFGrCOTe
         PP97Vvrv+naZzJte2nLft7/XIpzhRrtfFdOVKns5FkD180Qp3StwJN03b3yUZvVM3T3W
         A1RDfjacySTIb25raSP9efnO3fJcNv4pz8hciyqGeMYuzKfFvrpckGvgmVageietJbsE
         oqMW0sO3htvam1GpyIN+N7k3+4xBfLQx0OZu2fLjMFNi0KIllJ9Lme/MBaNBlGRxDMyg
         Cs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2OBxsaTpbwkO8bZLNcvPrwN82dGzENxh1xaU5bxzqg=;
        b=K4vC2bydj67vrO8J9QVXK17KW0MOTG3S7WZh7peUGFjhWPEJ4/BWY53WtzR20OmJwS
         t+OL3ACF8u3a6yxoLUwhYlc1ki/gttAcFxWCmGBiY3mLdc8VTftAZSyNmoZJ3SlFB8T7
         VYhPjP8Q0UWk8VFrhZysVOGvEF/6Ko6YqpsTntQQww9hf/RFbvzP1JqZRG5SCWDIA4Th
         0c4AnhCOdyGvk64YZ6cRA845rpvEik+0Gr3pqyNtVWPo52NrGpRNbv7hlGwUfgA1avPA
         z0PhOMzYSyfKfeVnc30Dyfh9HNFVcF/St1mLmCubY9dF91X+PQI5pvNwLideNvPHg7Dz
         wQHg==
X-Gm-Message-State: AOAM5305okSk0xqGZC95cVoK4LTb/SfG/+fhAST5Xn2YnIyUqGT8ZWvl
        sD4JqfJfTUHIh/14iPPt34I=
X-Google-Smtp-Source: ABdhPJxnX721z1zvCjbieJbjW6yUxciWeIN3LdwplbKaWU9p4CbTOQqhVJ1xeXfyayJ/cL7i3CZ9Xg==
X-Received: by 2002:a17:906:848:: with SMTP id f8mr27341886ejd.198.1623236861422;
        Wed, 09 Jun 2021 04:07:41 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c092:600::2:c753])
        by smtp.gmail.com with ESMTPSA id h7sm973040ejp.24.2021.06.09.04.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 04:07:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix blocking inline submission
Date:   Wed,  9 Jun 2021 12:07:25 +0100
Message-Id: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a complaint against sys_io_uring_enter() blocking if it submits
stdin reads. The problem is in __io_file_supports_async(), which
sees that it's a cdev and allows it to be processed inline.

Punt char devices using generic rules of io_file_supports_async(),
including checking for presence of *_iter() versions of rw callbacks.
Apparently, it will affect most of cdevs with some exceptions like
null and zero devices.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

"...For now, just ensure that anything potentially problematic is done
inline". I believe this part is outdated, but what use cases we miss?
Anything that we care about?

IMHO the best option is to do like in this patch and add
(read,write)_iter(), to places we care about.

/dev/[u]random, consoles, any else?

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42380ed563c4..44d1859f0dfb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2616,7 +2616,7 @@ static bool __io_file_supports_async(struct file *file, int rw)
 			return true;
 		return false;
 	}
-	if (S_ISCHR(mode) || S_ISSOCK(mode))
+	if (S_ISSOCK(mode))
 		return true;
 	if (S_ISREG(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&
-- 
2.31.1

