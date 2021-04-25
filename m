Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA9E36A9D9
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhDYXR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 19:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYXR0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 19:17:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519C3C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 16:16:44 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h4so44811236wrt.12
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 16:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=twGL60RLTZCR1VeCjb2rV9HJyEJ/DWkulCLOM08aWqg=;
        b=JYw2gOaT+uRdlWWtVtU7VB7+3dy+URneu9Lt3zSWHoFCXTMSj8MX6VTRiQ8SFI2Ifs
         JP/44YpV/AMOjccGvXC0ETHqrDG9lWCI05qs37uQS6DUssBWJVBEbDdWDLpNCpXBPPa5
         FsmQ4ORDr8IQ6Mm0v4n4fPocZ/uFrbMfF+3H8O4ZTKb60B7svzQf7KYkKu76N7RzT9+7
         AJnlGKZAhealb3EbyKT/UY46d9oF1PEObJXPfympdypub0g3P0zkTQ6Ln2TAqb4B4yWb
         zjl1KOmRlLzx0NE49HxujzlX9aK4xBWuM3d+J9GCsOYOpc90SJwlpIdmxK5JqyRtU3sT
         Kt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=twGL60RLTZCR1VeCjb2rV9HJyEJ/DWkulCLOM08aWqg=;
        b=g60t997SVIfUrHCgeoUZ8aIaRwWkmUgEel64JsC186BM+7egBSXxfFavICX2lPKaIH
         biWKqMzkVcpn4PXXDzfwDvUsQyrh9e4hR/d8Dyb1b2FxuPbtUaH+vxSqES8qUux7QKGS
         VJGWgSDzpEm3rOOq71+NOMHaE8kqJha/UrbrncaG6I+8dZVxlNJcufD2iQAEpG5PWUX3
         AZB7tmXTIyPLNHF1sO3Wr/UTCIRF4NUhrcUeT1R9fnGMoHexMX7CVZgXRr75z7uf1+aH
         UOZ/8JDNSANM54lRgi+6nywLRy/eW3bRvAEf6xZGEK1wfhY7Bl4KqV6jxL4/CosixVTc
         OoCw==
X-Gm-Message-State: AOAM531BhN6ESAJzKE2Ercz2bwrJO5ESqNVTXxVZZy2oR0h8Tl0zluqz
        R5OxN+AzValREvgQRVFolfk=
X-Google-Smtp-Source: ABdhPJxJ2WUaPZrsQH4fpyEeaRRR3oao6V8Cvs5cjvx7B8+3JqefcVLjxzQ6ztAYOrzu12xbJQnmWA==
X-Received: by 2002:a5d:650d:: with SMTP id x13mr19242497wru.264.1619392603125;
        Sun, 25 Apr 2021 16:16:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id u17sm16649956wmq.30.2021.04.25.16.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 16:16:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH] io_uring: fix invalid error check after malloc
Date:   Mon, 26 Apr 2021 00:16:31 +0100
Message-Id: <d28eb1bc4384284f69dbce35b9f70c115ff6176f.1619392565.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we allocate io_mapped_ubuf instead of bvec, so we clearly have to
check its address after allocation.

Fixes: 41edf1a5ec967 ("io_uring: keep table of pointers to ubufs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Would be great if folded in

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1cdc9b7c5c8c..261279f56838 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8265,7 +8265,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu->bvec)
+	if (!imu)
 		goto done;
 
 	ret = 0;
-- 
2.31.1

