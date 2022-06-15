Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E5554D3A1
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 23:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346887AbiFOVY7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 17:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350111AbiFOVYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 17:24:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25856208
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:24:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z17so12542831pff.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 14:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=AAC8c/O6Pqe5bEl8x1BOHe3yKkk+gIiV0DQf54Kpe3E=;
        b=xBkpm7d0gXdADVRM41Hn9ksqyFFKfDaS170mqjvv1wPr6LsVudbdSOdCjmUgIlpDop
         mRuVmhs3BvmAieguIVhyvrE2MTiMoGE2Voy/HYbMKk3E83oquQJfwn1cOm0Lt1lbvvX2
         xV3d59NFP3Ly4kaffSjPSvsM8T+LpBu93hTccyrIQ7Z9Ej4B0+gsWCTTkcPC1telupY1
         NcgfXusD0Dh5DoFW5LAXOWxxjuVQKKNrqw9X4Tva6P5q+88U2hUFUoLqzPex82E2Jfnb
         ciuD+jj/ZPvkbtUIluowSzm+haCQHLtlbJ3gSBW2DNKVHGw7/2IUFbfLYwmPDUJapjXm
         M+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=AAC8c/O6Pqe5bEl8x1BOHe3yKkk+gIiV0DQf54Kpe3E=;
        b=MH2bRtXCQXFKVeTOy4jew5WVFZ45w0yEfJxtFlW8qzEBH23659Y7rdCQPBVS3dLalC
         3l/XNd1CbfGNfovqDZvFWrfiidvxoL6/Lf6wUFQqCEq3wOdAwoSrWLsexKEcgnIN9s5F
         IvOQdZ8WehebwaSYCqeUC69qpxDis5keA8hEKAvaZPe+4vEu9k9NbEXizt7k5wlvrcrE
         iL5KKsOn7WfHRDCFAsA/We0lqajqyn3m7UK1uN8qsJI0OsKieqGsvH9vvafiihLHZLvL
         cjrsD6VHDCTSC3QkZ8rL6Na1MdSOnczcOvm50g6RgnXusR7VR3NawYJ3rBjtsVk1sUdl
         jFbQ==
X-Gm-Message-State: AJIora+AmKygkq2duxF/E6MrbXIqlZuOPRq3LUmXCgKgC5GdCgWjHV8O
        LbbEWm4Xvwme9OgS1+1GH01fJg==
X-Google-Smtp-Source: AGRyM1vvZLjVOZtQ2oI4s9zWKgQPuK55t60GhQxTXFTAZ+HGAHmtr/zxAc2SjNEJyUNQhjjsLuxwkQ==
X-Received: by 2002:a63:1b53:0:b0:3fd:168e:d9a with SMTP id b19-20020a631b53000000b003fd168e0d9amr1515955pgm.617.1655328294475;
        Wed, 15 Jun 2022 14:24:54 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902784800b00163d76696e1sm91587pln.102.2022.06.15.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:24:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com
Cc:     kernel-team@fb.com, asml.silence@gmail.com
In-Reply-To: <20220615113733.1424472-1-dylany@fb.com>
References: <20220615113733.1424472-1-dylany@fb.com>
Subject: Re: [PATCH liburing] convert buf-ring nop test to use read
Message-Id: <165532829344.853523.15656103547403478325.b4-ty@kernel.dk>
Date:   Wed, 15 Jun 2022 15:24:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 15 Jun 2022 04:37:33 -0700, Dylan Yudaken wrote:
> The NOP support for IOSQE_BUFFER_SELECT has been reverted, so use a
> supported function with read. This also allows verifying that the
> correct data has actually been read.
> 
> 

Applied, thanks!

[1/1] convert buf-ring nop test to use read
      commit: 649d7468ffc2903ca659e976c134e5602e4810bc

Best regards,
-- 
Jens Axboe


