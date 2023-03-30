Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3764D6D0564
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjC3MyW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 08:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjC3MyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 08:54:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958A213E
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 05:54:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ja10so17968745plb.5
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 05:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680180860; x=1682772860;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWTY9fgaOifsZYb8jbgW7pMsMgH5XHtufT6T7sX4cKs=;
        b=DYwYYwHp7W+kfJzl/h86BLT1NQkIb1VnF8l/ifWdj07iWFhaqD9zwbl88qshA/msiD
         km3ze5x5yR2QXqGkv1EJcCL/Hpck0dB74tLJEhyKeczR1WXXwXmhVhDpCIdkwSPeklTY
         Iul8379yJ3TWTg7zP23d6Mbs1rvu9l8itYjLEKJA0Az/LXi77k8N4oTobooeCfoh2xer
         RIL9vduZxhPzVIyizYKPKq68G8tmmPIuj7PauaEIxC7LtUxwbyZ73fp+owo0VYQRnflS
         KQSIb62QADKsjYcqh9vhA5Dr8ldzJro5FGMp9007hb1Mv0/Gm252nW0jd/eSVtzZcm0c
         oN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680180860; x=1682772860;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWTY9fgaOifsZYb8jbgW7pMsMgH5XHtufT6T7sX4cKs=;
        b=p2qwKlKq+TSBDTM2rZM6eubsqXrJk1uxDT2e743rTWmak+KBUBZ8cn0sNChnb+SF91
         9hsPFIuYRxYeuLc12E25KCRq5jL2pTdlY4OHJhqLiNoXhV+DHKPD4hlyXkqLO8bikVOi
         r/w5gKVnEcNNFz88ditvki7QBa9o7gVKeyx1cRVFNJIBF3nkyG2HspYnfzDNXrwbeMjn
         h0UkbF9hgQPGQpG0PktDEliakcjMlzyDnokctZknlMh/I0b+xQgCGqTxqJY1HPUC4n1X
         Ij/zsHUvzar+hFvWxL7aDT7DBt122QaKAaqWkCHgva94FmLTgj2tAJqC9f0O9Nq+uzcw
         Bc+g==
X-Gm-Message-State: AAQBX9dCaB8QXqeyW5bjkUolR+y/NTI/BedgbRZ6DM3kqiIMGKSUaJ0W
        uVAOJCnZCtY3BcB4amgISHFKkw==
X-Google-Smtp-Source: AKy350ZmHFJb6TQSB/g3V8k87LPKwov8zZyVSXNHtFzs2x1xJ9sBsp++As2AwKCa/afSVMpO4ozJsQ==
X-Received: by 2002:a17:90a:d58b:b0:23b:4d09:c166 with SMTP id v11-20020a17090ad58b00b0023b4d09c166mr19261659pju.4.1680180859977;
        Thu, 30 Mar 2023 05:54:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s5-20020a656445000000b004fb3e5681cesm23430973pgv.20.2023.03.30.05.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 05:54:19 -0700 (PDT)
Message-ID: <ae73b214-7942-8011-beed-1e74d692cd7e@kernel.dk>
Date:   Thu, 30 Mar 2023 06:54:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/1] io_uring: fix poll/netmsg alloc caches
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0126812afc5845096c987c1003e2ec078eefcd8a.1680172256.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0126812afc5845096c987c1003e2ec078eefcd8a.1680172256.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/23 4:31 AM, Pavel Begunkov wrote:
> We increase cache->nr_cached when we free into the cache but don't
> decrease when we take from it, so in some time we'll get an empty
> cache with cache->nr_cached larger than IO_ALLOC_CACHE_MAX, that fails
> io_alloc_cache_put() and effectively disables caching.

This should go into 6.3 and be marked for stable, but it's against
the for-next branch. I have hand applied it as:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-6.3&id=fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3

-- 
Jens Axboe


