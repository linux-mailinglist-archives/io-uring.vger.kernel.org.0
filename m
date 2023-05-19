Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0353708D5A
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 03:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjESBbc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 May 2023 21:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESBbc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 May 2023 21:31:32 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159F2E3
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:31:31 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-51f405ab061so255567a12.1
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459890; x=1687051890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=niC0geNUue6Sx6QFsUb2nuJDwhXo/8zDEY5ILi3ihqk=;
        b=20go3clJ1vddJwF/2rDnrRCoRIfrDA+E/hgI2+HFlnFjWFs0TWPuAo0I0Pq28voNiC
         z1lWj/uV1eZmxVVy7BmFyOEB0ExR4aDfF4IqJgLFHmSyIlQP6uX+Wc7y49ZjROs+g1Ym
         zfAzonjtW5GgJsr/qgNbo2GhorlfNC+tXm+fEfcMg1UhB7E9wZOSWeumRDO9h5qIuJmu
         X+FkR3kpJDXLUBM/padjdCN11f5o7f20c5+MtK9Q/GFvV3CZgRWi17hMeYB8piyMcF4X
         FpveZxHfJTakQk3tTMHWo8FlF0SRbzlJX+ZadX1t1blImpHP6BiumfN6Hfi+D/aKVpHo
         raxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459890; x=1687051890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niC0geNUue6Sx6QFsUb2nuJDwhXo/8zDEY5ILi3ihqk=;
        b=Yr7JERVCi/1sXFqAORgwl2j9+AC8u8jZmtKPReZ6ZqgvwQ8u9ig48Yz6hgaG4zNwIp
         nJ5fDajBbBFZJk3uzgiXrdBrHUlXCLAkq/yWudQgxuy4gfMZotNdOl8z7D9PPK8Fymhk
         7xbiEZfrps7Xik1s0bRkJJCbtMjIUkkp7abUwCU5Ip6BQjFxxLS70w2BCAMrBjw0YL1b
         o3UntbUHNblknotdnGA7uiyhAOnVeKHYzW83fTbtPmvFP25NkkO9cNJR6yE5rPy7+8BG
         SJXmqtqNfzzyCwUPKdCwtM61yH+Qdkje2Q7Pp+lRVp72t3jaocexBiaFW82rJTlGnuDB
         nc9A==
X-Gm-Message-State: AC+VfDyfx359aJzIWPEcq7n0Nvp461GtqcOuTY2/FzaFD2jd5eiKY+Su
        b9iVWt4U3ajXaNvzyeW692RBbw==
X-Google-Smtp-Source: ACHHUZ5BD/jJHV36vIA5yZPlqUmeOccOnDGXKSjorNTpD7jLOzJmOr4nZhlcpiUxYsHVqR4rYQpoKg==
X-Received: by 2002:a17:90b:3802:b0:247:9e56:d895 with SMTP id mq2-20020a17090b380200b002479e56d895mr691582pjb.1.1684459890571;
        Thu, 18 May 2023 18:31:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090adc1600b002471deb13fcsm320675pjv.6.2023.05.18.18.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:31:29 -0700 (PDT)
Message-ID: <4861a3be-543d-3c1a-584a-b2f041c16bc1@kernel.dk>
Date:   Thu, 18 May 2023 19:31:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
        olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-1-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A few minor nits, apart from that looks good to me.

I'll let the networking folks take a look at the NAPI helper
refactoring. I ran some testing and it is a nice improvement for the
expected cases on my end.

-- 
Jens Axboe

