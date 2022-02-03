Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338CE4A8C27
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 20:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353652AbiBCTF1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 14:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353655AbiBCTF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 14:05:26 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D142EC061714;
        Thu,  3 Feb 2022 11:05:25 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v123so2826469wme.2;
        Thu, 03 Feb 2022 11:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CwFIDxLrsJY5AT/tU5NARbAaRxrN82m4ae2GxSdsQ8c=;
        b=nQb97wY9KEcqxWpoyLJkJ/f/hNH57GFALTHstDZYp7pVASl19cJlmJ/lGL7F9mPHon
         RuOPXG4wrlMeKMrGq+acrZFv1P0p6MtCTPO1J+w3gztVPOO8TwjPS2qk6TQHOoxG9wQE
         EGoa1aqhfMqUKC80+2bA9MXZp6Q+JcMMsnetT/32OHdWZup/WfWZwJ7H5B3MHL9Oz3V2
         jVSF6Kf3NC3Itebp140aD6q9EoqJa78HmmARAojzGnnSyXvQaNPNaQRnb6uTABkB8a3S
         HVoJjIULRpncUjUZ5EM+BwMgalCXojb7sjrS4BejbYtBItcLg7wmDcEH4m5KS6ZtNs69
         65DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CwFIDxLrsJY5AT/tU5NARbAaRxrN82m4ae2GxSdsQ8c=;
        b=eVPkBu82U2td41C3gAM7q26lrPGcACQdqhyaCmSkO2w3jca/b4aN5IFRaODROgKUCC
         o3FnDez5grlMnao8Irs7t+cBgQYs2CzVihYtdO+FClNJCS98MtoVt9Z7zXXagB8nNQ6L
         gysCrS0XFFy6PXkVsnGNG1fmW0FdKdheUyVEHdAXjftExYE2q7QvVL+hrYpocSksVXPj
         iccC7T1xHNvhog5FlCof/WF0EzbqRuzKPrPE9yUhCkjM7fjiJmJgdksYsfm8Q/V2GoOt
         GCaVjMEnsNnoCpJT/Z1AgedIf6q2UyzFp55XKBOQQx8r9YBufOovTHG+jFXEVJVdYCpI
         t5Rg==
X-Gm-Message-State: AOAM5319rJdH2oZyFMjlFVjHz905/aIErl5vMhodsLqn6JR8sKnm8l8G
        Cc6Ilz/rZKhTdijUP61+LH0ajUYzj8g=
X-Google-Smtp-Source: ABdhPJxw3howmYa64wn51amImpugj21NG7NCDymxGM6GE3AdaHpKKB0wdJXfPAUsWPBDY4+F1uoZkA==
X-Received: by 2002:a05:600c:3ce:: with SMTP id z14mr11389567wmd.128.1643915124287;
        Thu, 03 Feb 2022 11:05:24 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id j19sm9226678wmq.17.2022.02.03.11.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 11:05:23 -0800 (PST)
Message-ID: <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
Date:   Thu, 3 Feb 2022 19:00:39 +0000
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 18:29, Jens Axboe wrote:
> On 2/3/22 11:26 AM, Usama Arif wrote:
>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>> suggesting to do the below diff over patch 3? I dont think that would be
>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>> present unregister can be called by another thread and set ctx->io_ev_fd
>> to NULL that would cause a NULL pointer exception later? In the current
>> patch, the check of whether ev_fd exists happens as the first thing
>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
> 
> They are cheap, but they are still noticeable at high requests/sec
> rates. So would be best to avoid them.
> 
> And yes it's obviously racy, there's the potential to miss an eventfd
> notification if it races with registering an eventfd descriptor. But
> that's not really a concern, as if you register with inflight IO
> pending, then that always exists just depending on timing. The only
> thing I care about here is that it's always _safe_. Hence something ala
> what you did below is totally fine, as we're re-evaluating under rcu
> protection.

Indeed, the patch doesn't have any formal guarantees for propagation
to already inflight requests, so this extra unsynchronised check
doesn't change anything.

I'm still more сurious why we need RCU and extra complexity when
apparently there is no use case for that. If it's only about
initial initialisation, then as I described there is a much
simpler approach.

-- 
Pavel Begunkov
