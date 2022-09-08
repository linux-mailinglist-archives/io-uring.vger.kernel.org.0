Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D6A5B216E
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiIHO7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 10:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiIHO70 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 10:59:26 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F213AB
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 07:59:22 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id y187so14356447iof.0
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 07:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=FEO8NITNPZmEXTv+ankOgOeVF25NuxUwPrQ+p+mk7l4=;
        b=S8iD4QZPhdQwJgGlvghdRbQKRVZO8GSNbfl1WZfGENGNImzB+exmXXDLtp5CpeFCey
         NTlo/iXyY0prSGgLhapDIT01HFJNjd9HZAMCRrzY0bpD/oylOVsS+HQlvHMkBao/v4Vv
         F3NtBhkIEI/bfBzTwxNOHHtg5Awn4tGH60Py3mo4L9TslAovuRnFzzK9WeXJX8ofIJBD
         mgyEl8BZ7EhzdLTRGCze5+wb6XOt6NBFV5S0cvJDJAwyALq/L5pALBSGTrRUXJd9h18l
         zV3MfXObJ8DIvq2gjdEl5oGIq/Qi3gknub3A3mm2p3jYk2Kie8TflDS55ngWD02qD8SY
         DTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FEO8NITNPZmEXTv+ankOgOeVF25NuxUwPrQ+p+mk7l4=;
        b=5x/YkejiruusJZXV2PoyO2dBHumWltuSGLm/tgisCWokKvMg/eWURXFYI8BQUZVLkK
         1BfGs4KM1LReUspQb/P2wTF2Jw13ubVHwDiF5HD4yNm6pbwkNzREDPwlMnpP8wriuLKY
         K6OlrEG8fmVKcWUTJKpT7pPJq6z63ud09oXopxrpoIM9/+9G1+4hpICbO7F49D6cup6w
         06nsu9mKJCfnqUcqrBPpXpgYJ+GNBECqp39jT5wipaAmHYoJ+78kSBYw5S6rO9JVqTc9
         NkkJiBVKW2bhrcK2GjS2eE0POdA4J0WSH3Z9yXCjBV2aEdyqOSH5qrizqfnNNfUoAzM3
         7yLg==
X-Gm-Message-State: ACgBeo1Hq0FzZv8rtdctrtQvASdYFBluYVoAQnAxTpybdUPMCkHgOKcw
        aXuImKfLil/xrs44sTk+8VnJyFTRUQ2K6w==
X-Google-Smtp-Source: AA6agR6G+KX33h3Lo94Po2lMv/BH3LE+CKiMjJ9UgWhG3zwg5s5ap1mvuPgbEPswDDGry5WTZrYPLA==
X-Received: by 2002:a02:904c:0:b0:343:50f4:48a2 with SMTP id y12-20020a02904c000000b0034350f448a2mr5161410jaf.22.1662649161891;
        Thu, 08 Sep 2022 07:59:21 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x10-20020a056602160a00b006889ea7be7bsm1121523iow.29.2022.09.08.07.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:59:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/8] random io_uring 6.1 changes
Message-Id: <166264916121.478770.15106624727300580789.b4-ty@kernel.dk>
Date:   Thu, 08 Sep 2022 08:59:21 -0600
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

On Thu, 8 Sep 2022 13:20:26 +0100, Pavel Begunkov wrote:
> The highligth here is expanding use of io_sr_msg caches, but nothing
> noteworthy in general, just prep cleanups before some other upcoming
> work.
> 
> Pavel Begunkov (8):
>   io_uring: kill an outdated comment
>   io_uring: use io_cq_lock consistently
>   io_uring/net: reshuffle error handling
>   io_uring/net: use async caches for async prep
>   io_uring/net: io_async_msghdr caches for sendzc
>   io_uring/net: add non-bvec sg chunking callback
>   io_uring/net: refactor io_sr_msg types
>   io_uring/net: use io_sr_msg for sendzc
> 
> [...]

Applied, thanks!

[1/8] io_uring: kill an outdated comment
      commit: 89030aa91f5f8bab7e35c5a82e0b279975034b2c
[2/8] io_uring: use io_cq_lock consistently
      commit: 794aeb01d83ec5c1cb5bcf4a14de60303f82aea4
[3/8] io_uring/net: reshuffle error handling
      commit: 6b505138766270555754093a47fb3400cff167f1
[4/8] io_uring/net: use async caches for async prep
      commit: 211fd9172521f9631ba9d207410810f40e6990e2
[5/8] io_uring/net: io_async_msghdr caches for sendzc
      commit: 4331248c61de902ac5831f5c0c55a3d93ab2e3ba
[6/8] io_uring/net: add non-bvec sg chunking callback
      commit: 6f8a4bc02e2f9d2e66d3d06eb8323dbd344ec417
[7/8] io_uring/net: refactor io_sr_msg types
      commit: b3f3e9e18b240f0ecde85901ad0c7f19e12870b9
[8/8] io_uring/net: use io_sr_msg for sendzc
      commit: d5e0b61591ea1993c8c79bfa1aedb437016d212c

Best regards,
-- 
Jens Axboe


