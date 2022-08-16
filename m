Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5A55960D5
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiHPRLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiHPRLJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 13:11:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D084786E6
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 10:11:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u1so15782115lfq.4
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=3dPYdcJsyINk9rDeMSkuzvUuJjYXRQMw7D3oLvy5aVg=;
        b=CSArwysptEgVYJfdWY95ZcBzcxoF9DK+C6tMeSGEKz/uwEPYzxd3g+hAvLE8DCRxTk
         ++nvDwGAMadcMS3uVpYR4l+13S4nHLbEnezHwoJMyfB4x7b9EBLTEV1MINgPKKUvtv0K
         F40fHmvfVfqORp+Vu2eGDOFpZzWY3y1NIs9h31gNVNjS5SLAcq1O4BUCmTU7J1eT1ewW
         L1Ig3V0hs3K76vK+Fjp1YDKOIlVNJiW7DRilVBd/QpBd6MAogAWUP/AxuRzlzp9mRolY
         HlvgfiTOengng3jpxX1lMGoTwGnpZilOBNJ5aCS7zzltqvzM3QCW2mWa47pgiUm7EfEB
         B68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3dPYdcJsyINk9rDeMSkuzvUuJjYXRQMw7D3oLvy5aVg=;
        b=roc/Aqvj00WhISYJQ1ZpLkY64hCTMfrizJGSnbEwEmLHwYHjnZVvwmEcLD9iowSDya
         uRD887hKhRSQK/HOE0XNYOVFE1suVz5SDUQm5QE1ryQZLPWMehMWiZZ/8RZSaF5valTp
         5p2M9m4Gv+Pc84V7b2Ho5J0xVrgrYkBrTxMN5tfdscH3jGt6nU+zFkOXINB9jFlrnP9S
         AzmsAMVcw8GIO7K8PFNyxpAyeSHRw04RGKY+Wlhm9ZMJxYC4CW7tHA5ZNj8LqnJeiRkK
         haiVbWVprA1lCniw4/PWDwIhJChrUCzQ8ftX7ZW4gIe2bnlqqRz3DW5JGd/x3MVAgIfH
         IxNQ==
X-Gm-Message-State: ACgBeo0b0hRkZwZH8tb88x+E5KOA793A8GObe85mBaw1TrLSpHcxaV/H
        sfEHXmsaTWG0ftN9jYzd4yEyW7rmGg==
X-Google-Smtp-Source: AA6agR4cdPQZ0scZPYSa2Xy5/ZfpZmiDtTQuFj+SqQuYiA9PbLENiFe2AFS5aOjF7bGG5THREg22yw==
X-Received: by 2002:a19:dc19:0:b0:492:9030:9174 with SMTP id t25-20020a19dc19000000b0049290309174mr2766851lfg.644.1660669866619;
        Tue, 16 Aug 2022 10:11:06 -0700 (PDT)
Received: from [192.168.100.39] ([81.26.145.66])
        by smtp.gmail.com with ESMTPSA id r14-20020ac25a4e000000b0048b1ba4d29csm1435259lfn.257.2022.08.16.10.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 10:11:06 -0700 (PDT)
Message-ID: <be86119d-1f4e-5893-7fcd-13eca88b8309@gmail.com>
Date:   Tue, 16 Aug 2022 20:11:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Adding read_exact and write_all OPs?
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <b9c90ccb-c269-7c78-8111-1641af29b0eb@gmail.com>
 <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <e42348ef-af67-d0d5-9651-89ca9e5055de@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Is there a tracking list of potential features for io-uring?

Unfortunately, I am not a C programmer (I mostly work with Rust), so I 
probably would not be able to implement it myself.

But either way, could you point to relevant parts of code? In theory the 
changes look relatively simple, but I am not sure how hard it will be to 
implement the new OP codes in practice.

Best regards,
Artyom Pavlov.
