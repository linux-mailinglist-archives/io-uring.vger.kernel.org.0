Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D82665E53
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 15:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjAKOtu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 09:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbjAKOte (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 09:49:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77F7EE04
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 06:49:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z4-20020a17090a170400b00226d331390cso17424553pjd.5
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 06:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yW8vy78r5/CaJ+7JPaSH55j7YIiKU2q/2tyilmGr7VY=;
        b=uqaNLzwqoyie1yMZ8bKUfxYvMpHBmor0F5f2p7il9PAgUPhNL1mWxIXl4stcdX5YQm
         mcRrkZP7vl+11YnWaZ05ogkXVpu3v46XfoPdHq8ql8TEk7qiKXybUVYFkNFmx/x0MMaT
         tCHhdLdu3m2fa8Q0mK35isWG1V9mOA8KiKRn+F/QeW8W9prZ+t98CVZPPq2lau/ZPqIe
         ioQaUm6aCLHNFmECFE3KTDaBG9/yw7osa3fFlF9M84uJ3fcC4fTMSCRlx+4mDajR+IzN
         boGDtGQZcKAzW5/oPeEPAbnAv9hpWa2otveBuVtO5c+D1ppttnWw9PyuEOiRyuNps4CT
         evEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yW8vy78r5/CaJ+7JPaSH55j7YIiKU2q/2tyilmGr7VY=;
        b=OpGGbH2nCRbR7mH6ySBlUXiXqTSlHrNi9+NczTKmzEkLWou2AKA+aZWnibAwCcRBNE
         +yq/OAb2fGk/13fR+dAcoIBibPbbGOUS9qB/j0ow1PZ9ihaMoKZQSufhwsRnyumYwF1c
         h8xL/wXQjcmp+dxRo5vMhOaFYUX3nkwjjKm40eWohpx+4mSaVOd+5qGIBbAC7AYc4b2J
         pCx9lJak+OFzyTIkW6BMQiplNBwsu9F1/zSq6lus4R8OLyBgy2ZCIz2dJFis/aPX9hW/
         QhL18eUKJAQ3yoEtzxHDnjpimlWJRV9RHA5EDuBfZbD57B3O2QRywV7b8F07+GMozDwb
         0SVQ==
X-Gm-Message-State: AFqh2kr4+RQsWzqD3PRQ1C4pL48Rp3EIWS5SOr/NjfM8h757sL93sxkn
        wqelHeEMC4GKojz8cn1O5MnGhQ==
X-Google-Smtp-Source: AMrXdXs/LnmncAUxOJciTiscI3S1kf8k8Azjv6Ail+7XwYbQxAT/n9d29Pe9YmHsFBNbahlQ7ogrrQ==
X-Received: by 2002:a17:90a:bd0c:b0:219:3e05:64b7 with SMTP id y12-20020a17090abd0c00b002193e0564b7mr17179052pjr.0.1673448572299;
        Wed, 11 Jan 2023 06:49:32 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a6a0c00b0022713d5733esm1728465pjj.30.2023.01.11.06.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 06:49:31 -0800 (PST)
Message-ID: <63d8e95e-894c-4268-648e-35e504ea80b6@kernel.dk>
Date:   Wed, 11 Jan 2023 07:49:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] io_uring: Add NULL checks for current->io_uring
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20230111101907.600820-1-baijiaju1990@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230111101907.600820-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 3:19 AM, Jia-Ju Bai wrote:
> As described in a previous commit 998b30c3948e, current->io_uring could
> be NULL, and thus a NULL check is required for this variable.
> 
> In the same way, other functions that access current->io_uring also
> require NULL checks of this variable.

This seems odd. Have you actually seen traces of this, or is it just
based on "guess it can be NULL sometimes, check it in all spots"?

-- 
Jens Axboe


