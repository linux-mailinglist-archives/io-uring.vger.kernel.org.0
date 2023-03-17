Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C079E6BEEBD
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 17:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjCQQqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 12:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCQQqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 12:46:18 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B509AFE9
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:46:10 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q6so2560637iot.2
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679071569; x=1681663569;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IyaC0gSghSXSHopVWioj4e7BuaxL3fWGZcfJjEgbnGU=;
        b=4nhrTbmVaHYU9Ad1xFbVgwSsrRevhMWmCdtBqSOMESYpOig44QLUBTIL/mlRv/SZm0
         XfxdY0asiy4D48Q6+ambAXdOsMrSIcK7fDd+zuiLDTzTC95mb1J9O957pCOjcUpCgWbt
         ki/l/Uujvzsy2ssMhPFN+2i15di5DyOzbtrH863KhXeHz6rau2WEfaF2B0/cDfNgqjfe
         6Oo0nb77b7Z13W0+aOi0pOKmEBq7AUxMAHdRkXQquuFzYiCjDaM2J0GZaZ31e+Pb/v6R
         HB8aBGTl0xLFnbGyWkJCNz2tJfJMOyTQRtM5PpKgXa7IKfdQ0BR/aJMUa9eb4oLzb8nV
         RYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071569; x=1681663569;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IyaC0gSghSXSHopVWioj4e7BuaxL3fWGZcfJjEgbnGU=;
        b=o6UaGqqEMwdaYQnUvbZxHcYiVeYLav9a/pSpUi/kSrHOGg2xnab73/5BX5fxR/Wsvh
         aDst9zM1ps/uCEN/2PhgYfYzmOLH6Tg1IKL5D3noYENbcvF4wNAQoahD/rNY+QbZwKDe
         ZpIaLPewJAtBKV/rJBmH/3xFtFjOPAzx1RLyDmeQnGMrcufaJoQ3tMCLJtdeD8w/Lq/I
         dMJtEyDGdZZulKl/I+gl4ksYLaulNOMNxdzXvS8Z6Zw2PORx657SGn2TUmpi2VAE4B+x
         e4txvm/+2+iL4AZqXiwZby/0MN645BXsC/XKEu5jvInMFpf9Sf4glOCzyAUGlj7dtX5T
         o/FA==
X-Gm-Message-State: AO0yUKXib7ETK6O8waku9KJD5m12iYOtfHwwgKsRvliBNMEzUuSI5Don
        KwyIn9VeOsOSvUc3ayS8vQY3pbVKKBMC8AB7ASL13Q==
X-Google-Smtp-Source: AK7set+RNv20CGeg8qJ/z5ri0vR5zBJoDCXiu+Rfd+k+x3WtBTyVvxvLbiaDJW/YB/9CZzFkP6FZeg==
X-Received: by 2002:a6b:6e08:0:b0:74e:8718:a174 with SMTP id d8-20020a6b6e08000000b0074e8718a174mr5968188ioh.1.1679071569332;
        Fri, 17 Mar 2023 09:46:09 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e34-20020a026d62000000b003c50d458389sm830323jaf.69.2023.03.17.09.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:46:09 -0700 (PDT)
Message-ID: <a0c3e328-badc-3f54-f7ff-b468a316a9d3@kernel.dk>
Date:   Fri, 17 Mar 2023 10:46:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/kbuf: disallow mapping a badly aligned
 provided ring buffer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On at least parisc, we have strict requirements on how we virtually map
an address that is shared between the application and the kernel. On
these platforms, IOU_PBUF_RING_MMAP should be used when setting up a
shared ring buffer for provided buffers. If the application is mapping
these pages and asking the kernel to pin+map them as well, then we have
no control over what virtual address we get in the kernel.

For that case, do a sanity check if SHM_COLOUR is defined, and disallow
the mapping request. The application must fall back to using
IOU_PBUF_RING_MMAP for this case, and liburing will do that transparently
with the set of helpers that it has.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index cd1d9dddf58e..79c25459e8de 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -491,6 +491,24 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 		return PTR_ERR(pages);
 
 	br = page_address(pages[0]);
+#ifdef SHM_COLOUR
+	/*
+	 * On platforms that have specific aliasing requirements, SHM_COLOUR
+	 * is set and we must guarantee that the kernel and user side align
+	 * nicely. We cannot do that if IOU_PBUF_RING_MMAP isn't set and
+	 * the application mmap's the provided ring buffer. Fail the request
+	 * if we, by chance, don't end up with aligned addresses. The app
+	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
+	 * this transparently.
+	 */
+	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
+		int i;
+
+		for (i = 0; i < nr_pages; i++)
+			unpin_user_page(pages[i]);
+		return -EINVAL;
+	}
+#endif
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
-- 
2.39.2

-- 
Jens Axboe

