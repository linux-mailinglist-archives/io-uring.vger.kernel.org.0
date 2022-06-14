Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0254B197
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiFNMwS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243230AbiFNMwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:52:15 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1E43BFBB
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:52:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so1233770pjb.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=DW3RedDOL/t8Pc7ESqZsnboTLO4uSaIuf9V8jm+PWIQ=;
        b=LW99f9o4FcFRaEbmkI0KX48plyzaDVCiXHsSZY8r/X2B+zapa0XVQWadtZUSqyykF1
         cCePxldhqm9ryRf1aL/Cyh9gQhA9bXAIIlmTdkAsHhwmRXLHMyaw+vPzLzG3SqVCVpMf
         9LgtJ3Wz8DL0sY+aU6T/PmCTqUUfHM8F2nDjPjxV/fThXmx4V9/myO7vs6BQogqY8yYW
         F6mcCvJp29xWlmF8XOPi2Qlmp5pAdFB/G/w+d3ggx2nRigjbA2U1CZ2XxpEhh3OXsYS9
         FgclBjscdhXN/+tpIZPBxwrydyLHEYPJKL73BdF1JAgwclyzjCulHj1DpjI0UdmhdqQJ
         Pr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DW3RedDOL/t8Pc7ESqZsnboTLO4uSaIuf9V8jm+PWIQ=;
        b=6WsiPOFciXixsUjC74Ygn0zKLbMEtxSSNKEmwTbVMDmOl9c2Ar0kx8PhaVR/tJnHC4
         uWxNvwIH4yb2o4ERRsepAUbg6goZmIxQFyOXaCsvtWnjUbUhefKhmvxsBAu7BS/0hDV2
         J+ZBRM/64H/XcJOfzWcRAg18XdUK+WocgwozUlyLRjONlC2vjvrqT2XVWiQuJtY/0GNy
         vz9jumq/kZRwRo/Ks6LmlpOxVcbgP8ITuqdytXJZsHBlv3PykLyt7qUD3/hSqtU6A9Xe
         ElUAYm8rrcAghtIovabT52hK9ZcjpRWPq/Zzmqj+kQsoyuwlcgiGdo+Id1/raTGcZngU
         I9rQ==
X-Gm-Message-State: AJIora+8BAfm5ZK/lQ4QkuQ422HOjUyp+8TRpQua2LZ6St14PXbuhbc0
        lgXCAkYc9c/1OWNvE6yTz7WfwkqqQLWjAQ==
X-Google-Smtp-Source: AGRyM1tSsPyMKoP7UetQXuTSvIv3szS0/R1A2ujM+eHJf2bCbysJZKKLdkVtDrtql8nJD7UqQOSWJA==
X-Received: by 2002:a17:90b:1b07:b0:1e8:41d8:fa2 with SMTP id nu7-20020a17090b1b0700b001e841d80fa2mr4486154pjb.204.1655211132440;
        Tue, 14 Jun 2022 05:52:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ji22-20020a170903325600b0016403cae7desm7100918plb.276.2022.06.14.05.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 05:52:11 -0700 (PDT)
Message-ID: <33f6f7cc-b685-704d-dfc6-f8a1c0b89855@kernel.dk>
Date:   Tue, 14 Jun 2022 06:52:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 05/25] io_uring: move cancel_seq out of io-wq
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655209709.git.asml.silence@gmail.com>
 <e25a399d960ee8b6b44e53d46968e1075a86f77e.1655209709.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e25a399d960ee8b6b44e53d46968e1075a86f77e.1655209709.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 6:29 AM, Pavel Begunkov wrote:
> io-wq doesn't use ->cancel_seq, it's only important to io_uring and
> should be stored there.

It isn't there because it's io-wq only, but to save space. This adds 8
bytes to io_kiocb, as far as I can tell?

-- 
Jens Axboe

