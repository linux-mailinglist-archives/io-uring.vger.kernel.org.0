Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D938535294
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348302AbiEZRgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbiEZRgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:36:16 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6BD1EAE0
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:36:14 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id d198so2236916iof.12
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=nA9C9Zqy0/zetHpSiqtRzY51iIPmDddriXFJdyHKqk8=;
        b=RhXsSv5KyPzqGyjzeqhFAprrwp4EBss7Ru+5A+6hVDF2RQEVdxDF17eSWjSMg1AWmN
         rWr5SxT7ooc0HQCevND0xog9LBJGoQrpUfiD0rm/2OnVuHldyXyPI1BQFzGuHP0t33f2
         tdkIZe2QTcyc/5UVAnyyKAVQzfs6wH6tkJ0VJxznX2bjrpwBZ1vC680hbRvQsihii+30
         MC7/VCJqErWxMHr3JA4m+YvCy1Hm6q4Yf16dhuhLXx+rKBQCdNt1ZoQJJ7TSOxq3f5I/
         xrD6W5YAqr3EJOOZhPE+/S9TnUs+AK3mXNrL6KzRCV3XpPactRZN0eKxVjfFHwYDEwxd
         d1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=nA9C9Zqy0/zetHpSiqtRzY51iIPmDddriXFJdyHKqk8=;
        b=IXgcd49du5mY+sYlzyGeg6i8b30sji5f7rECYuKv7BC6DSV/3jsbeNuoCxRisylXZ9
         cftQ/j8rVtRdDCuqUXw12ZJOxTi3QrEI6yWedJuZm7yCs5QuIGGH5ubOrbNN/vXzGCHF
         inHJbw2IY9xuhVFWB7S3wpLth7PN33afp0efrHKN4aycnDv3nvZlnC/+uJUtphvrtvpG
         fhWwLu2qi/wU5GEVBhU1k9K66QzJIom/AmAK6k4rV4dnwprEW9uCaWYXWtVcFL8wJ8LZ
         2DGmGsMJpL5HC59cpxqoKr24k3t2/PjMlCkEUvH2fUK1DQReCe6pAPfQzrcxmAbQ/PNV
         nWow==
X-Gm-Message-State: AOAM531aO1pOOFN9M3ttNcJ6SVJ+m2rY4i74DaqrQmCqzC9Ssmlv3u0G
        qywK0sLccC10bvYPGwOl5eW0sXKpvDP3FQ==
X-Google-Smtp-Source: ABdhPJx5Yj7psqYj74nqsJzQkanbFEv7nhwFtV3NucYNDoQ12sj4YDr8IMmsXizBRB9IB77RKse96Q==
X-Received: by 2002:a05:6638:218b:b0:32e:9612:109e with SMTP id s11-20020a056638218b00b0032e9612109emr18235664jaj.192.1653586573762;
        Thu, 26 May 2022 10:36:13 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y8-20020a029048000000b0032b5e78bfcbsm539829jaf.135.2022.05.26.10.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 10:36:12 -0700 (PDT)
Message-ID: <2328dcd7-f9dd-3ca2-510e-60269d64c352@kernel.dk>
Date:   Thu, 26 May 2022 11:36:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix a memory leak of buffer group list on exit
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

If we use a buffer group ID that is large enough to require io_uring
to allocate it, then we don't correctly free it if the cleanup is
deferred to the ring exit. The explicit removal paths are fine.

Fixes: 9cfc7e94e42b ("io_uring: get rid of hashed provided buffer groups")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f7e1fc85d266..ccb47d87a65a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11065,6 +11065,7 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
 		__io_remove_buffers(ctx, bl, -1U);
+		kfree(bl);
 	}
 
 	while (!list_empty(&ctx->io_buffers_pages)) {

-- 
Jens Axboe

