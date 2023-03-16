Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C217E6BC384
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 03:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCPCAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 22:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPCAG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 22:00:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE33396634
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 19:00:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13so282216pjh.0
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 19:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678932004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BN0T8h6Fid0teOjWiCV9SOtVt2asU9DqG+K0Sfivnf8=;
        b=jTi36fQcdQBMHxx8qOtG6nzhWkLdU9ySTEQ4th4kkQvTo1tVzXsHTVVWLxb/Al8vUh
         jjN74eEGIeQ6mLog4XiW7eGLwBs+/RnqLcjjaSpBJ1upAkrK8jTPf3+Qhh8GHMVDHfvc
         y+whYDUruEtg/twGJLeQ2LkrcJ2uqqJdEwaRoIfN6MRIshfQ5qAKTf84u+jPbdzgk8pm
         Y2GrYp0Ey7r/Rdxfs1JBTkC+vd8ZblwpDuvyxZDI24cE8TQsVXTLPGY+DCyXmSzJle1e
         QSmlcNT5cEYU5/tl85jjEhWAO01LCp5q9udTWSIivfP51A5U7BipfaPvtlEiO9QIKJxo
         sp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678932004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BN0T8h6Fid0teOjWiCV9SOtVt2asU9DqG+K0Sfivnf8=;
        b=0e7auqacRX3KK2krKCMoUA4uDD8hcfy3kDTjRUHy65YfiQT6tFyBiZlAIm8qLQEGUH
         85iigBUh+pUbO1b2LxA6bE1e+CPt7NJ9DY51jWvecDehMceL3dRe09NNyDi3x2C4qKQM
         Nva0cy5MlxfEUFPzUFX542a1eMPpQAxKmSaaEns7TadkMOMqVnAvGTFqmxUs6V+s+HI8
         nl08VlLDckkiA1S2/VbjeKEenZQDV5OnnO3+7PDt/UuUtBrhnAoJBcPeIQZ8r8Ulhoi2
         7XMhjFjxBUTzkW8ymPoiSlftYRLTPVmNbP3KGhKtJ6tHHHL8fbYeivlVBg4XENnCccv3
         vvFg==
X-Gm-Message-State: AO0yUKVkU6LrcNC1gfGhQhpHa2VGr8jk8eDsH2CJ3IChsIf1LJWkupu9
        zAFeHp4dIh+/RKKU9o0zsMBBUw==
X-Google-Smtp-Source: AK7set/Is6dLxtc4WaDptG3bQM+e66bS1nvPMWfqNvjI7W1oRQYFscnHvcEcK/dzZlS8/XA+bS0t1w==
X-Received: by 2002:a17:902:d505:b0:19a:723a:8405 with SMTP id b5-20020a170902d50500b0019a723a8405mr1671080plg.6.1678932004273;
        Wed, 15 Mar 2023 19:00:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o12-20020a1709026b0c00b0019a97f180fcsm4263052plk.37.2023.03.15.19.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 19:00:03 -0700 (PDT)
Message-ID: <e40d0a9f-f92d-f0ff-87f3-cb2c92f10c9a@kernel.dk>
Date:   Wed, 15 Mar 2023 20:00:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [v2 PATCH] io_uring: rsrc: Optimize return value variable 'ret'
Content-Language: en-US
To:     Li zeming <zeming@nfschina.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230317182538.3027-1-zeming@nfschina.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230317182538.3027-1-zeming@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/23 12:25 PM, Li zeming wrote:
> The initialization assignment of the variable ret is changed to 0, only
> in 'goto fail;' Use the ret variable as the function return value.

Applied - normally I'd just sent the usual auto-generated email,
but wanted to let you know that the previous email and this email
are all sent from the future. You need to fix your date/time on
your end.

-- 
Jens Axboe


