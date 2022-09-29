Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A397B5EEAF0
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 03:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiI2B2s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 21:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiI2B2p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 21:28:45 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FED11E0F0
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 18:28:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f193so159096pgc.0
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 18:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date;
        bh=O/hCPjFEiXd9B1ts60Qi65mFObrUE6NMYDeqV7xrB4c=;
        b=7KRqAhxFjXqiDrn27iuB/FHUXjwiSGuFQ8tbKejBiw+fGIzgaVGp1AnMBYBumDi2Rm
         npYUSbljKV9FtzoyVfB4UCXaQvdtZbeuDALf3WLnR52APhZMkA47QBrRAxnjX3O/y3dZ
         P4i01Xt03GEgc6WzPMgHb+v1sJpE6WhSWcyTWiYV+67INRgZc1fk6vo0EU+DF7KdzYF0
         J9pQMsvcQHPQy660cvjpHse/qzxIrkQG7T1l+O+QBIy558y3gyH/pQYaaF3xHVrGqlrn
         ThtlgXTyIN7C5x4/eYY9InAg3/yPUmsliDt98uJftFDnqrlveGcelywZMjd/Bk4yZtxy
         UyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=O/hCPjFEiXd9B1ts60Qi65mFObrUE6NMYDeqV7xrB4c=;
        b=vHk2CJwiPu3yMJmLd/8Kkxm8bQYlIs59n8Mrp7TNBEVnN0EUEJosoG1zDaSaKQrkpX
         upPl7thTxQ5OvWGPY9K9159Djd3mpXOYG6FXpSRAPbQtnbsyscmbRRjFy06MaLNxbeq7
         nGmQJnoXMsLZpLQmyBgEht1xLiwqUMnU0kGMxTfaUrjE9nn4slBg2buI33z257rYVEeZ
         HMMpQOJQb4arYCX500C19SJMVIgRASQfg5n1IJflSxSzIyc4Ath6WLkDJvBgWfwfS+Ls
         PP5FoYPQtpVmWKWlhV8dtlEWNWucy1Oa4at7+pvjizagZYRXRKn+/FneIynHgUveHwaV
         4VuQ==
X-Gm-Message-State: ACrzQf1wV84ac0ibKZ1ExKE20mRG2D1CCYz7uEg4xF/9eC0IxxeUFM74
        k/j+TH2iQV0cJSlkPRBFUuVWa8KF24EC7Q==
X-Google-Smtp-Source: AMsMyM4BrHCm7XD0tR3VHozr1nCFPnvf/7qNjdoCfB5/lmUk1n4wIhjIAcFFVjSfEmkMtdFZbgZpiA==
X-Received: by 2002:a05:6a00:3287:b0:542:33ca:8bce with SMTP id ck7-20020a056a00328700b0054233ca8bcemr954508pfb.20.1664414921257;
        Wed, 28 Sep 2022 18:28:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a188-20020a624dc5000000b00540f96b7936sm4710070pfb.30.2022.09.28.18.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 18:28:40 -0700 (PDT)
Message-ID: <6486d37d-5e4e-9770-ca1b-27ee231d0a41@kernel.dk>
Date:   Wed, 28 Sep 2022 19:28:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] io_uring/poll: disable level triggered poll
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <68178467-39c2-adb9-0358-4587ef01cf4a@kernel.dk>
 <55ed62be-e300-d961-3a9c-c75b0ed59318@samba.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <55ed62be-e300-d961-3a9c-c75b0ed59318@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 3:11 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Stefan reports that there are issues with the level triggered
>> notification. Since we're late in the cycle, and it was introduced for
>> the 6.0 release, just disable it at prep time and we can bring this
>> back when Samba is happy with it.
>>
>> Reported-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Also reviewed by me.

Added, thanks!

-- 
Jens Axboe


