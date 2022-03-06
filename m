Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856044CEBBC
	for <lists+io-uring@lfdr.de>; Sun,  6 Mar 2022 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCFNd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Mar 2022 08:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCFNd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Mar 2022 08:33:28 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE0B32EFA
        for <io-uring@vger.kernel.org>; Sun,  6 Mar 2022 05:32:35 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y2so11838523edc.2
        for <io-uring@vger.kernel.org>; Sun, 06 Mar 2022 05:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Lvhgk6J7Dmhx67PC2uz6OlImP3hHZFWy38a0pNnw9pw=;
        b=MMEfoYXd1ARoXzkXWFYPiZpkd/9A/RHbPSfhgcHQibFg6bQbevtqcJNhEhYLseJ9vI
         PCyvPXvIHu7IHjY1wyJMZaRgkZTg840TsXd30DcYD7HQGUmzHUMV9NVXuWEOKT9AVcjN
         uY/bw+IGrt13PUpfOlXD+c4qTaxkozo5fNVe/3NZI6ctdLANN/NDkD0H2a6zjSyRItnz
         DrrDDkbs/qCgbV9GPtDarSiR3kcdvbn4y432SsZWKDjLmntj49vlFcDmBShT0bc79BgD
         yYe+cZF8pRqKAPbgc+p8nM2vVqaDK/Fz0I9fEBbQW1V84Xz8t3SGLyFqbCNta1iSTZkW
         JErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Lvhgk6J7Dmhx67PC2uz6OlImP3hHZFWy38a0pNnw9pw=;
        b=edLzq+k57q5jYIgWHE4M+pt9jj+U3NiS/rVH0XO6TwagZ97szRiV0JBTT3eoU1Bno5
         pdoYYD/33jZeOoeRoD5j1zpQ1X6Y2p4EFm2st0w/X+AO3WeRUf/vDeuz0IiImEWJHkPS
         TMln2qU5MU1yG0KdJUT64P/cDlzATQh8G3wXAHDak4pJR/xxnqftZXQtIg1e8X+5Kc4R
         gi9kgPCmcANHdCPEtljb/HZxNth0gBJe3cy3bOpb76Supb6bn7JGmwNiV6aTS/2GRNS3
         99aPshER9AH8bNSvHLoyK1knWzpqw90QnRmmhY19viFA7YfzUNAUWFSlzFl6NDDf/Mj+
         jdUw==
X-Gm-Message-State: AOAM531B1fTibNsCf8eu65S2IGxa0Qb+d37vpZems9UVVkzOfTUow8AN
        hY9V0Yds46/NElZ1k8qo87jNyoMhDqNKjI+nZjw=
X-Google-Smtp-Source: ABdhPJwp9T45hP5Jy89Mw5x3FKfjDl0aC7W1+5zhupsqWlSbrGvyg7FRvVsqH/3IUXYwhd4xOFMWTg==
X-Received: by 2002:a05:6402:5171:b0:415:eed0:664a with SMTP id d17-20020a056402517100b00415eed0664amr6831212ede.117.1646573553310;
        Sun, 06 Mar 2022 05:32:33 -0800 (PST)
Received: from [10.0.2.15] (89-139-33-239.bb.netvision.net.il. [89.139.33.239])
        by smtp.gmail.com with ESMTPSA id f3-20020a1709067f8300b006ce051bf215sm3806642ejr.192.2022.03.06.05.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 05:32:32 -0800 (PST)
Message-ID: <768398e5-4909-6c7a-aee7-f36210f41a8f@gmail.com>
Date:   Sun, 6 Mar 2022 15:32:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: fix memory ordering when SQPOLL thread goes to
 sleep
Content-Language: en-US
From:   Almog Khaikin <almogkh@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20220306103544.96974-1-almogkh@gmail.com>
In-Reply-To: <20220306103544.96974-1-almogkh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/22 12:35, Almog Khaikin wrote:
> Without a full memory barrier between the store to the flags and the
> load of the SQ tail the two operations can be reordered and this can
> lead to a situation where the SQPOLL thread goes to sleep while the
> application writes to the SQ tail and doesn't see the wakeup flag.
> This memory barrier pairs with a full memory barrier in the application
> between its store to the SQ tail and its load of the flags.

The IOPOLL list is internal to the kernel, userspace doesn't interact
with it. AFAICT it can't cause any races with userspace so the check if
the list is empty seems unnecessary. The flags and the SQ tail are the
only things that are shared that can cause any problems when the kernel
thread goes to sleep so I think it's safe to remove that check.

The race here can result in a situation where the kernel thread goes to
sleep while the application updates the SQ tail and doesn't see the
NEED_WAKEUP flag. Checking the SQ tail after setting the wakeup flag
along with the full barrier would ensure that either we see the tail
update or the application sees the wakeup flag. The IOPOLL list doesn't
tie into any of this.

 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4715980e9015..99af6607b770 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7608,11 +7608,12 @@ static int io_sq_thread(void *data)
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 				io_ring_set_wakeup_flag(ctx);
 
-				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !wq_list_empty(&ctx->iopoll_list)) {
-					needs_sched = false;
-					break;
-				}
+				/*
+				 * Ensure the store of the wakeup flag is not
+				 * reordered with the load of the SQ tail
+				 */
+				smp_mb();
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;
-- 
2.35.1
