Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC54A8CB4
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 20:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353856AbiBCTsj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 14:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiBCTsj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 14:48:39 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546EC061714;
        Thu,  3 Feb 2022 11:48:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id f17so7134158wrx.1;
        Thu, 03 Feb 2022 11:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=05r8VUvrEvBBOH+uU9Wqr+6VFcZz//gtH+Z9bZ85nWw=;
        b=AD6JLrlw9Kac51I84aEr+fwId4/al2zxLrFnzx9c3ax287WdOzGTtTexXYaRGXsWbi
         Q4cV4kX1lPriHxQLv+H+V+/iJqOIX0pUhgTl+5gLIoJxr1KEUWncEAtB+uMA00emPBHP
         /U0vP6SvY/fqmyZNxVILQtqgnGCTjDl3AOJuQ2C35M+mJpjRkMLU51Gdy9UsYOi+zc7S
         ZyR4zt3Bqe20tkv8w6KAsRoZOtIft8ZNxSfw2o632OuHMFxkWm2XhlnUjvQUzJIGFQnW
         COB6h9a6/7wgoIqvtZxnom7FeQthAuTGCj0RjD1vl76vFSMcx7YzuI+utnfu15lxH+6F
         LGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=05r8VUvrEvBBOH+uU9Wqr+6VFcZz//gtH+Z9bZ85nWw=;
        b=v8qY64127YPsWNXAABzroOcoxfzzt/jSyPY31q9tWdFYcAZ6VyHNhJPUxfvR2yFDQ+
         PdfCvoqF8FLV0fyQ0HSjiX0VJx3PUrylArJybOLaR9PaD9ljO0CovPmW8SCnA2yaJAfj
         WpZeLs3qewGMTiO401atk4wqn/lRdeoahkjicFow4xhjMa2Zy0TG6vkLZwBcRWHL1s0H
         Ph0sE4S5X35QQo64qmVnBbb7IZesiOLdbWXPC4VKHLSaFCExyFsDTpcAxyTMNDSNsy3l
         Fu5MW4QXp9JmX4KV1y2Kqdcrd3BCUWOM9psAQlO0zOa4C1d4Sc6sxG/FcIgkix+78X7W
         /8SA==
X-Gm-Message-State: AOAM531uS4gxpSNtlajYDre+rqdyNZa92XGEK/SOH1ncGioNBPJ9AjZP
        L5XFSFrEcS15uzp/j+/UU2s=
X-Google-Smtp-Source: ABdhPJw598AxU0Zebv7U3/z3KQtFW+ksv+LzojsXGFelcFxqnUNxSgNZ7lq4ru6KBGIBVIVXImMa3Q==
X-Received: by 2002:a5d:6489:: with SMTP id o9mr28760589wri.628.1643917717328;
        Thu, 03 Feb 2022 11:48:37 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id j19sm9311230wmq.17.2022.02.03.11.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 11:48:36 -0800 (PST)
Message-ID: <fc5a2421-f775-8195-39df-8e4bcda38af1@gmail.com>
Date:   Thu, 3 Feb 2022 19:43:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 19:06, Jens Axboe wrote:
> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>> On 2/3/22 18:29, Jens Axboe wrote:
>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>
>>> They are cheap, but they are still noticeable at high requests/sec
>>> rates. So would be best to avoid them.
>>>
>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>> notification if it races with registering an eventfd descriptor. But
>>> that's not really a concern, as if you register with inflight IO
>>> pending, then that always exists just depending on timing. The only
>>> thing I care about here is that it's always _safe_. Hence something ala
>>> what you did below is totally fine, as we're re-evaluating under rcu
>>> protection.
>>
>> Indeed, the patch doesn't have any formal guarantees for propagation
>> to already inflight requests, so this extra unsynchronised check
>> doesn't change anything.
>>
>> I'm still more сurious why we need RCU and extra complexity when
>> apparently there is no use case for that. If it's only about
>> initial initialisation, then as I described there is a much
>> simpler approach.
> 
> Would be nice if we could get rid of the quiesce code in general, but I
> haven't done a check to see what'd be missing after this...

Ok, I do think full quiesce is worth keeping as don't think all
registered parts need dynamic update. E.g. zc notification dynamic
reregistation doesn't make sense and I'd rather rely on existing
straightforward mechanisms than adding extra bits, even if it's
rsrc_nodes. That's not mentioning unnecessary extra overhead.

btw, I wouldn't say this eventfd specific sync is much simpler than
the whole full quiesce.

-- 
Pavel Begunkov
