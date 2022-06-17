Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA55354F6D2
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 13:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380518AbiFQLhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 07:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381599AbiFQLhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 07:37:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13AB6A43B
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 04:37:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e11so3953548pfj.5
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 04:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=ZoMX4Hu5T8K9iAkYCGOsLuT9WiRMz3Ye5Wamw7NeV6s=;
        b=IHh+dvTESpOF9LewkOFKQakLX5uAR5cEu548mqSlyc2vOCfycOhzQ1yCdyR6HqXPbl
         slPhtRXt6ZvrxwbCcMqPIrvysdB82lXjVjyqZOO3dhgPyLKMXSvXNPr31j40+uef+5YO
         okevICVcCNEmJDEzShAaee/SbyrCTCM9RkHRuqnE7wkLbh96mO24SHOtNiNOK58RclFe
         T53HyMEH8O3KPcL3O8SETjtgYE7UDSBtum7iHJX93bRj6F+rpTTO7zvC5iOHFwYuFq0X
         QYPMFj/cP8RkyvYIkkQHdcEPbuwW7xPou9HAYeo6Jc9MYWIhZS3foqBceazCgg3PmCQU
         Sc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ZoMX4Hu5T8K9iAkYCGOsLuT9WiRMz3Ye5Wamw7NeV6s=;
        b=TMMbioecOZd4lED04dKfQLoDr3g/1CbogAQw32kpEu5YCMYkDFU3brpA1cixEJOTRx
         RoR2T6yTyBUedmRIwE2bYjDbSDoMpOzM9RiOzugQ0VEjckgfmN8J8XntTnQE35M0GLhW
         Gfwl5ng8Mhg/eig2WF2BdSfsuvuI3hqADpempIbc2DKhxWfqZMj5FIQGN/fA4mr22wai
         DbOlPaSY7gYJHZcSY1nzyu19Ga98dJYSAwk2vH8f46Fyhi5P1+zUNVZOMX8SCG9tX79/
         KxSsqJaizuC4i6XImdKyL1sZlyBgARR93yoDY7asafiR3U5BklGBbiCi44zs1hM784IS
         0MkA==
X-Gm-Message-State: AJIora/cha3EsbRq3aNGgvTRTaNP8wxu10/fVn3LARIhaL5vQR4dEPvc
        wR2sXeJWalimyDsVExYojvPYSODGNJq+9g==
X-Google-Smtp-Source: AGRyM1vQwMAWYuCdBg7rTrieh6OeIUmYiPAqrXiFDTPDy0e7Wt2MURNcGUP1K8NvUVugxX0zAiXNiw==
X-Received: by 2002:a63:9c4:0:b0:401:a7b6:ad18 with SMTP id 187-20020a6309c4000000b00401a7b6ad18mr8740206pgj.523.1655465844090;
        Fri, 17 Jun 2022 04:37:24 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f78200b001676dac529asm3363127pln.146.2022.06.17.04.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 04:37:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1655455225.git.asml.silence@gmail.com>
References: <cover.1655455225.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/2] use nop CQE32 tests to test some assumptions
Message-Id: <165546584306.253486.15819193032366223664.b4-ty@kernel.dk>
Date:   Fri, 17 Jun 2022 05:37:23 -0600
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

On Fri, 17 Jun 2022 09:42:40 +0100, Pavel Begunkov wrote:
> Pavel Begunkov (2):
>   Revert "test/nop: kill cqe32 test code"
>   tests: fix and improve nop tests
> 
> test/nop.c | 54 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 41 insertions(+), 13 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] Revert "test/nop: kill cqe32 test code"
      commit: 203abdf5f0bf78a58d59f3f4a4e8561cb76b10f4
[2/2] tests: fix and improve nop tests
      commit: 540ca1c11016ed50940e3f6f555a986356578646

Best regards,
-- 
Jens Axboe


