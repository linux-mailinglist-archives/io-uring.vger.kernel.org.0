Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53B53564B
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 01:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348807AbiEZXFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 19:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbiEZXFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 19:05:31 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630F6562E7
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 16:05:30 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g184so2543239pgc.1
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 16:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=I/SGGi6zU+9d/hVJxgLU7ij+L3/urzEryNeazQU16GI=;
        b=LKYCSzeeiIKoebtTgZ3+/5BB/XiGPstCi1d3zybyjk77rM9aLBm9XMfufNvRUIAvmR
         YvLMgXyYtsXJacsC8Ny8+IvTTQ3y0+0UTvHctShP9n4ZEFfoKHmkjJjquHF366P2ADWG
         dra8mM017Z0siI2Iwqfx5KTdwKe2dEw29r+KONShsYXenjeupl+YcUYiX1as4Nk6162z
         z7fUJaaJhNWTnZGUvzG4VxW40XY5m0UzCkZImt6kPmXa7gLi1A/OpHWqLSr6Ft4tBu05
         iYVE5mPbefLk+XmOK6Y5vJyqafYG9S5NkpDBgWY8R7tRxU6edj8B44BNG2Ci167is17J
         u9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=I/SGGi6zU+9d/hVJxgLU7ij+L3/urzEryNeazQU16GI=;
        b=3hxFgxcb8YlSYoiLlGZbuuTpWk3y2zGhcOgk7Mic3acOQd625wZTpii9rFTZPasx+u
         2p+jnxh53nAvyxEFLBP6lrgJN+S17WquoNINeRYkRzvrc4X0S2/dcYtWpnv8nYAiZZM2
         rnaAjLDfdYXtxUX3DcRrx3Nlq57yZUuV6Q2PkLlDx1cbBQVgcuknskuKa2xOd0eVXaMz
         13Mf1J3YHhVqCljAyMomkSbZ/lsD0u1pcFRsfFXyhwnDewGw/MOy5VUArZK40pSJoRLB
         fHB+uNIibUSpRSuG8amly8iOEkKfoebkruFC+xlNWZ+2J9joqZdhX6y+LljdK9EW/zMU
         Z3nQ==
X-Gm-Message-State: AOAM532pqAtrtOKAvHJ+QSZYCQ9JCfFdl9SysbViyBD+cw0tPeNYW2oe
        CK7egYWcjJ2YLfPKFXnmtG/d7hctEDj1Kg==
X-Google-Smtp-Source: ABdhPJzfLuWn9SCoAVfpaVbjYfAWr4nAiBRE917ExMrx64l0Ti0cZcXFfegUHZMRp15eBy9Z/TASMA==
X-Received: by 2002:a63:eb47:0:b0:3fb:10da:6699 with SMTP id b7-20020a63eb47000000b003fb10da6699mr4871660pgk.618.1653606329642;
        Thu, 26 May 2022 16:05:29 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w63-20020a627b42000000b0050dc76281ccsm2003531pfc.166.2022.05.26.16.05.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 16:05:28 -0700 (PDT)
Message-ID: <fdf98193-26d2-b543-acac-82e9557d3072@kernel.dk>
Date:   Thu, 26 May 2022 17:05:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: wire up allocated direct descriptors for socket
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The socket support was merged in an earlier branch that didn't yet
have support for allocating direct descriptors, hence only open
and accept got support for that.

Do the one-liner to enable it now, so we have consistent support for
any request that can instantiate a file/direct descriptor.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ccb47d87a65a..d50bbf8de4fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6676,8 +6676,8 @@ static int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    sock->file_slot - 1);
+		ret = io_fixed_fd_install(req, issue_flags, file,
+					    sock->file_slot);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;

-- 
Jens Axboe

