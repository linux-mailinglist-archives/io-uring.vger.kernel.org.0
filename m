Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A1C4AC8EC
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiBGSy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 13:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiBGSvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 13:51:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC7E0C0401DA
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 10:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644259901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NvU5tprvh+UDdv26EAx+wVN7Ocpyn3c3CsBDj5+9PsM=;
        b=ICFJGHbcWg3z19WwllZGke8fi70HGdhzrk0NBDVJfPbsJ8qXe8v4/BpjfK4Ny6JyXxiOl3
        uZ6SVaUBp50fE4t/degM2/zuPVFi+WzHqZE/49ur9kE4XLFOG8CQirpcG8+ggIeY05L58w
        tL74qLyVewV1550jCKiCUsbGE/ibosE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-s-unHs7bMJ-yDfizPu9XSQ-1; Mon, 07 Feb 2022 13:51:40 -0500
X-MC-Unique: s-unHs7bMJ-yDfizPu9XSQ-1
Received: by mail-qt1-f200.google.com with SMTP id z1-20020ac87ca1000000b002d11bc8d795so11723319qtv.17
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 10:51:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NvU5tprvh+UDdv26EAx+wVN7Ocpyn3c3CsBDj5+9PsM=;
        b=ydqBYVSFa3oGWbSFPK2XdZ/XzBAYiRh1M8+pLREjotuo45ml0AkWQtg01sawuDw73c
         wZSuQdk9WhmNqaMI36I5Nt0vHsaeeV6D/NsSjylEZZe8R/Jn7wgJ+4SV//7+a5M9nihg
         oVl4iGmgOJyJJ6F/NeQKOoqFhtFBu4FNVMetOZqZVYvcFXRTLP1mus4k7122O77PtxNF
         mKolBIFGk/bsClUGKghGvmBrP8MlRBFAVBNKgx3cOclkQKpM7wAWSsdY+oz3qla+B54M
         rj99s2sW7NLaIeFKbS3c3gXYJK6v3382GzToWDnELuOZzcVGq17Cg1u07K/exYFRaKgS
         P/Vw==
X-Gm-Message-State: AOAM533LzM26e5poyOx0Dj9bfU59+MpgppRTYls1LXljNy2A1DYER/s1
        WXcRgLlxFncLZDBHKVs4gTu2ghRoipqL+yw0SLn3r25crokimUd663IQrbOYL8lRnglQnXyOsGL
        obqSVXiGSv+2ipBRaThQ=
X-Received: by 2002:ac8:7d0d:: with SMTP id g13mr644667qtb.168.1644259900315;
        Mon, 07 Feb 2022 10:51:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwu11695XI9Zsd4rsyupYe/UJYMLSTJVRBNGwcwiBFgOq5vyomoglH0AfFajDCRhiqB7vAv2A==
X-Received: by 2002:ac8:7d0d:: with SMTP id g13mr644650qtb.168.1644259900108;
        Mon, 07 Feb 2022 10:51:40 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id u9sm5826890qko.110.2022.02.07.10.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:51:39 -0800 (PST)
From:   trix@redhat.com
To:     axboe@kernel.dk, asml.silence@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com, usama.arif@bytedance.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] io_uring: fix uninitialized return
Date:   Mon,  7 Feb 2022 10:51:26 -0800
Message-Id: <20220207185126.2085525-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The clang build fails with this error
io_uring.c:9396:9: error: variable 'ret' is uninitialized when used here
        return ret;
               ^~~~
Return 0 directly.

Fixes: b77e315a9644 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aadabb31d6da7..74afb96af214c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9393,7 +9393,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	ev_fd->eventfd_async = eventfd_async;
 
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
-	return ret;
+	return 0;
 }
 
 static void io_eventfd_put(struct rcu_head *rcu)
-- 
2.26.3

