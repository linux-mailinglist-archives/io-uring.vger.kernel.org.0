Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6E65A9B6F
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiIAPUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiIAPUr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:20:47 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F2E5F20E
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 08:20:46 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e195so8899773iof.1
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 08:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9gvSECXdigkGlg+PS+Q2HjXTqCiJxw0dXLJ/QFA5yWM=;
        b=a073rtILV+Jo5rovWKeeXVLU8IY9aCaGK0pNdjcZt+PGomCqpcwemk0qum6EO+I/fE
         jq9Bp2jAgPLVsX90ihnJdPvHKk4kFyw3cFVA/UHMtfTWmgCop73BMBZ4NPFnBsTNBc3d
         Jf41aO0qhY3qkMCvQjHpHfMj2ZjuDnRqW6wgZNWP07MwuzNjxQ1YNpI5HDpjk8p0evHO
         2pWsYzj+NeOQFJbuqmuA62f1SbpRJbq5SdDdy+wjhtC9LodATUahqf0XchzLsi75jOTA
         b7O0oalADQfRHe3muUKDrCFBkMQNR79Ev3o7lmdUsb/qK6nwiFREpaH83UqShGeFuXN4
         XmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9gvSECXdigkGlg+PS+Q2HjXTqCiJxw0dXLJ/QFA5yWM=;
        b=JYrApw/gZn4Q+yAx3LFItAZsKATEddFBPbyWjh81W4Hh9Ih2KBTxLT2khrL4giwrLo
         mBDyjdWZVf33CJMFft8zP8DP5bt3N/sOwO99ouGPsYfTpUcj6c/tup4xwW759x5PwvER
         PbfdrOrjFHwXMZKoBxpYMCeFKV+ix6IdqZeI6UJEstoSONcnLJOFxsLwzF0Yl9qtjHpP
         PNPglVAnJVC6389KtrtfVOJWhRcmYR8WuoLM/c2Mm3vd/VzNML1l4X+7zyML5qBGWnZQ
         HDOQQE+E3RFBlPViLEkk9ArM/bwL5rEsskv9DFAT64GaOe3t7KE6TmDuvPckgwujNymu
         Ie+Q==
X-Gm-Message-State: ACgBeo3luRo44nwPp7XEnr288Zm8w6Hjt8pZxc0mzSYg/NdZGkAGc5Q4
        WxOOLZk+T2iUNaVO9sCTbEcVsg==
X-Google-Smtp-Source: AA6agR4DE71cU2cseNk08wIfGsRwkVhTjnhsCpB+gthyxZO24qHAHkDUQKKEK4ewPbjK1KHCA8Z/VQ==
X-Received: by 2002:a05:6602:1542:b0:68a:65e6:3a37 with SMTP id h2-20020a056602154200b0068a65e63a37mr15266707iow.202.1662045645699;
        Thu, 01 Sep 2022 08:20:45 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n3-20020a92d9c3000000b002eb3b43cd63sm3651156ilq.18.2022.09.01.08.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 08:20:45 -0700 (PDT)
Message-ID: <d89b264b-9155-9ff2-3173-60feabdf62b1@kernel.dk>
Date:   Thu, 1 Sep 2022 09:20:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next] io_uring: do not double call_rcu with eventfd
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220901093232.1971404-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220901093232.1971404-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 3:32 AM, Dylan Yudaken wrote:
> It is not allowed to use call_rcu twice with the same rcu head. This could
> have happened with multiple signals occurring concurrently.
> 
> Instead keep track of ops in a bitset and only queue up the call if it is
> not already queued up.
> 
> The refcounting is still required since as far as I can tell there is
> otherwise no protection from a call to io_eventfd_ops being started and
> before it completes another call being started.
> 
> Fixes: "io_uring: signal registered eventfd to process deferred task work"
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
> 
> Note I did not put a hash in the Fixes tag as it has not yet been merged.
> You could also just merge it into that commit if you like.

I folded it into that commit, thanks!

-- 
Jens Axboe


