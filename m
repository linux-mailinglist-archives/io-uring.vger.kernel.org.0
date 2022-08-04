Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E79F58A337
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbiHDWW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiHDWWj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 18:22:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FD8287
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 15:22:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id w7so1038055ply.12
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 15:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=o5f1SwhRViTVJG/g8beJMDU1s3QGPt5r+m5MaCdOsSc=;
        b=fE+0+z8m49tI8U5TItcI0vstoGYtRpFm9O0C5iiSQBwhEx5evEY5KCvVLBn8jJDrJJ
         6xMKV+9AvBnf48l5u0YdHCrsAn9bf6XHkzPzD1KXrIbLNCxd2RVIaGcfOeNLhFPWQ7im
         Cn1KyCwprq5MI6lcr/aOUggUDTyRmeOohhpo+14TabfVqEPKHy6E8fe5P54VU7Ed2rPE
         GyY0Qp8f4t0TZk18/KsD0EfnIORewND1XAyI09yGTn4e1pEY54sECP60m6VjZjh+0DqB
         D+U+gxg/kL9HTTiV+Vxs6YStT6d7CKNGBlcJi3ptufR1eoaJqcSMECZoAfCLHfdSgNTo
         hMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=o5f1SwhRViTVJG/g8beJMDU1s3QGPt5r+m5MaCdOsSc=;
        b=sPZTyVFUq1oNVQfIE6J6YSu5zCKO5NiSEX/xImoXWkhn5M2aEby/eyTczTbdndtNTU
         iYitSDkSgbTgVFgq9RU87C9/U8Kow16V3YvmQI36DinCByDOLgM1grK7Z0TuOAqMUS97
         +cX1d+3wYMQedRZk6PyWWD1OivhyJeyqIXQPwc6aVpQ8Io46frw1hiO4C8Z/fZk0qWnX
         5MFfP9xVD6JOumRwhFyBFL7kYEOMyWbT+HqoGyNqti7M0VV3A4y1G2EB8rCfwXvTbftT
         yYCTkkQRGRR0O4ftMWs60NYhGqSpjj5kjmEb3CS9DxDbRmFGNA1sIvUX+uZX4WCkdutN
         Gnig==
X-Gm-Message-State: ACgBeo3BsO5siI/gXS8KqKpLkFPFbudyRMwsdR3b2+pZEFGpUe+TwCnZ
        c4kLdt3v3NAgJlmH3ECL18oWlhU5j/yEyREa
X-Google-Smtp-Source: AA6agR7G6k2u8P8JsYPgJ15OdG4xvXarx+TatXTtpf4scNknpf6RTT3Kw0/UearPuiqo84/toUdOKQ==
X-Received: by 2002:a17:90a:f18f:b0:1f5:1683:3f63 with SMTP id bv15-20020a17090af18f00b001f516833f63mr4262062pjb.105.1659651738155;
        Thu, 04 Aug 2022 15:22:18 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:765b:12ab:9b40:fadd:2785:d5f6])
        by smtp.gmail.com with ESMTPSA id t123-20020a625f81000000b0052e27fe53b2sm1498187pfb.82.2022.08.04.15.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 15:22:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1659622771.git.asml.silence@gmail.com>
References: <cover.1659622771.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/6] improve zeoropy testing
Message-Id: <165965173690.108308.3119398589636739296.b4-ty@kernel.dk>
Date:   Thu, 04 Aug 2022 16:22:16 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 4 Aug 2022 15:20:19 +0100, Pavel Begunkov wrote:
> Add test cases for TCP and for short sends.
> 
> Pavel Begunkov (6):
>   test/zc: improve error messages
>   tests/zc: test tcp
>   test/zc: allocate buffers dynamically
>   test/zc: handle short rx
>   test/zc: recv asynchronously
>   test/zc: test short zc send
> 
> [...]

Applied, thanks!

[1/6] test/zc: improve error messages
      (no commit info)
[2/6] tests/zc: test tcp
      (no commit info)
[3/6] test/zc: allocate buffers dynamically
      (no commit info)
[4/6] test/zc: handle short rx
      (no commit info)
[5/6] test/zc: recv asynchronously
      (no commit info)
[6/6] test/zc: test short zc send
      (no commit info)

Best regards,
-- 
Jens Axboe


