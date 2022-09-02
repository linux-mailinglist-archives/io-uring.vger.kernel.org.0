Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFAF5AADEB
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiIBL56 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiIBL55 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:57:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45333BFAB5
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:57:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id jm11so1590377plb.13
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=fAIYTOVNC0Y9en3qoY/CCMBWg13mtNMclRpmW6TlQQQ=;
        b=ZYASr0ryLNgY2kx/XCCq4uGWYQmVFsCMmTQHn2kyfu1ZUg2sIbOOYWWFp0Bf8TsSGb
         XkMRgPtEh9wUL2KVTd6ycc0U9IBnLMSWu61tuGNDmyvu/1sL6aodRUkvbLlkPqHWXRwz
         TLrV7H95uHqhPMaTRcMUFPy1u5KSHThIl138mHiun9amHz6TaqwdDvavtQ03uHJTm6+E
         CLt2Sv+CglboSufVA05L/55wThYDcZym4dG0W2gJzWUZ/1YsuYmW5op2IBp9SkSDO4qm
         OGpqX5Zx6t2XI61/PDplZZOqVw21+gSrD+aFtObjK1riyAxByB69bqPOXTjClTn64cuA
         gtrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fAIYTOVNC0Y9en3qoY/CCMBWg13mtNMclRpmW6TlQQQ=;
        b=gPSGS9WrlvIXErShmvGtlxgt6W0V/++3XJl/l7s2xpub0F83OBMzL+70n8q8sKCao6
         /WSgNVnm7VNKoPmipwAVgWbAcMhC24m5CQoP6RCNO7XOCE4BSvONQQKu8u+Rb7aItI+8
         kk9+QTfb/PYbdyk+Vj8AzBuWwh2ZDuGUJ5cYho+nzWivcJwXOXF9MW9LBG8ESny+Hf39
         /8umbGVnUofliW9wSweu6U3n9npJV6vE6V6oCURxfP+AUu0kDYFgzmg95/FgbPf/amUT
         kux1RsKJ4IokCq+eSgckHyVPTS15tL2OIskbC1EJTj4ju8aiSTyeFEY8A+O9cU8PFAnk
         nUAg==
X-Gm-Message-State: ACgBeo3l0usVURHJUhNHLJrZz3iMfZSYVUAI26AOznBBTXyGVt5cLxJj
        5ldV/ShV36j2R998YyiuFNQn2sdjLBiTbQ==
X-Google-Smtp-Source: AA6agR5zUDetvuunQ3bTG/E/R34WfiutGCfuA9qC+UN5rZ2lZS8Ua7sNs7IzEtPwbDfCW0acZpt0jQ==
X-Received: by 2002:a17:90a:4fa3:b0:1fb:a751:6a71 with SMTP id q32-20020a17090a4fa300b001fba7516a71mr4471429pjh.157.1662119875716;
        Fri, 02 Sep 2022 04:57:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z14-20020a655a4e000000b0041d9e78de05sm1233049pgs.73.2022.09.02.04.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:57:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
References: <cover.1662116617.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Message-Id: <166211987502.16404.7763256959756330333.b4-ty@kernel.dk>
Date:   Fri, 02 Sep 2022 05:57:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2 Sep 2022 12:12:35 +0100, Pavel Begunkov wrote:
> Fix up helpers and tests to match API changes and also add some more tests.
> 
> Pavel Begunkov (4):
>   tests: verify that send addr is copied when async
>   zc: adjust sendzc to the simpler uapi
>   test: test iowq zc sends
>   examples: adjust zc bench to the new uapi
> 
> [...]

Applied, thanks!

[1/4] tests: verify that send addr is copied when async
      commit: 54b16e6cfa489edd1f4f538ae245d98d65d42db7
[2/4] zc: adjust sendzc to the simpler uapi
      commit: 880a932c8ae36506b4d5040b9258a91251164589
[3/4] test: test iowq zc sends
      commit: 713ecf1cf9ad58ceb19893eead2b704b27367a8a
[4/4] examples: adjust zc bench to the new uapi
      commit: 860db521db4c86a1cb5d0b672a8fba83a89f01f0

Best regards,
-- 
Jens Axboe


