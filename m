Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E754B40C17F
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhIOIQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 04:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhIOIQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 04:16:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B17C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y4so451052pfe.5
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5oBh7fFx36onNjQvvlNr7cbemNgOfUY3SbblIYMxo1o=;
        b=f5uGFAXYmBDjQu7Tp8j80GO8lOEw8KtosQUkfmSNwxRWAUU9yIVaKwiRzWA1sjLCOt
         ty2WIpRHhbz+AAhf/MWpBVSCVFui4mQr44fmuhO74Icnn6bwNaqvOr6hZwLF30vUCMPB
         yEfbVkNF+hutJg3LRfU8RnO+iZ9Tq+34j17OMLJfAiz6eAgCNsyR3p1QBZKhADDdPK54
         bA9a9g6Wrqpa+Jpo3ntVq9j6+yzay8k87kYcfveXBxYt6z//sB2GgkasMNsO2afH8wtn
         p0/gJJGcsoaCSw2z8mG1+xyeQJjt15uw4NHoVYrHnpU3yAq8DzpGFtqlp3jSbTFfBMQG
         IxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oBh7fFx36onNjQvvlNr7cbemNgOfUY3SbblIYMxo1o=;
        b=4Cm23Fi/MsRp7JQZG478L7jCBUbPcweARRyNqqcpUPd3STSItSZXpNILUQCkGgD74i
         14lXCCOnnhnJ6F062JW4qN3DCa6XaU7mSopOQGYL0U9+KfdcSFfKpApq6FDShPXJsFYW
         /Z2nMs4jH4EiRVpr6y0sUESR7LbCRnlouA8ad+33PMlQw+t7exmPkxwj38qoKOnufUTy
         FIQ5WTus98xhVM2iEJu7XOQl7jPGpPcNI1OJL+JvE0rmDdtT6U8pA6c39BImj89jxuf6
         bo3MWaMvzY4xLzz1ZZz0mN6XqGmDTL8a0nLDuflJklEniAKGwknEjBDRVPDgozcygM4u
         zlcA==
X-Gm-Message-State: AOAM531hqA+7fpOMSVLS0fmCzmD096tquTvTtnDcOYA+5a4GglBfEoVF
        8NXoW8Z61xl5VX8vmH5L0PiJtRCxEgY=
X-Google-Smtp-Source: ABdhPJxP0Qr+d7JRM8QmRSB7bIk1xpkBrm93NzS6miTIpp5gZw1K4X4rBsnA/u0EFOnHXSKbsTPP9g==
X-Received: by 2002:a62:2cd8:0:b0:43d:e6c0:1725 with SMTP id s207-20020a622cd8000000b0043de6c01725mr9230453pfs.55.1631693688982;
        Wed, 15 Sep 2021 01:14:48 -0700 (PDT)
Received: from integral.. ([182.2.71.184])
        by smtp.gmail.com with ESMTPSA id x22sm12643076pfm.102.2021.09.15.01.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 01:14:48 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: [PATCH liburing 2/3] test/send_recv: Use proper cast for (struct sockaddr *) argument
Date:   Wed, 15 Sep 2021 15:11:57 +0700
Message-Id: <91812264f5600e1a460203d5297eb43aa978f9bf.1631692342.git.ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2d53ef3f50713749511865a7f89e27c5378e316d.1631692342.git.ammarfaizi2@gmail.com>
References: <2d53ef3f50713749511865a7f89e27c5378e316d.1631692342.git.ammarfaizi2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit fixes build for armv8l.

Sometimes the compiler accepts (struct sockaddr_in *) to be passed to
(struct sockaddr *) without cast. But not all compilers agree with that.

Louvian found the following warning on armv8l:
```
  send_recv.c:203:24: warning: incompatible pointer types passing 'struct sockaddr_in *' to parameter of type 'const struct sockaddr *' [-Wincompatible-pointer-types]
          ret = connect(sockfd, &saddr, sizeof(saddr));
                                ^~~~~~
  /usr/include/sys/socket.h:308:59: note: passing argument to parameter '__addr' here
  __socketcall int connect(int __fd, const struct sockaddr* __addr, socklen_t __addr_length);
                                                            ^
  1 warning generated.
```

Fix this by casting the second argument to (struct sockaddr *).

Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
Tested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 test/send_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/send_recv.c b/test/send_recv.c
index 38ae27f..1ee0234 100644
--- a/test/send_recv.c
+++ b/test/send_recv.c
@@ -200,7 +200,7 @@ static int do_send(void)
 		return 1;
 	}
 
-	ret = connect(sockfd, &saddr, sizeof(saddr));
+	ret = connect(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
 	if (ret < 0) {
 		perror("connect");
 		return 1;
-- 
2.30.2

