Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CEF75BAC1
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjGTWoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGTWn7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:43:59 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE48171A
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:43:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-682ae5d4184so284458b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689893037; x=1690497837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZ9UbrWFpnxO4PufmfLqfdf9NxHpIEXa/tPhwX1M0v4=;
        b=HqDLKWaFlSa5eD9mg1IyOvYMcguSRHqGkglUWiAyQdl/uf20FKNw1gqrEinP14hz6j
         vVFKCJCedgBsk0oAM+EMGTAm4BRX4nIQxokASMJBLr1yr7C9dw6nW51rxSPj8cNhJtrn
         40q9VflUq5+7qCqg8kMKOsVQge+ocmjhWkV1FaWnSuQsqMIZzV271WxdWiIDnO2ItYvN
         xXDAMPrscuIFsXig/4E4W44h45LCNYutjUopDD3zaktoHRuboaH5lBDhiIEtZQAm7SsM
         6Rk84VkLjpnM7mynYN8dvuxTsz77TqBitGevHG+6Y/+Xp7T7Ft+pX5Y/LbmC5dHoN7TA
         B/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689893037; x=1690497837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ9UbrWFpnxO4PufmfLqfdf9NxHpIEXa/tPhwX1M0v4=;
        b=PRVLR8YaSZcLhzxbteeUlXBPRXb7oC4uCVxGQk7NTBgBm7d6n3utmOyyumGkwVpilz
         A2hUyRtOsCuXVeZBcR1+Ld0a/9ZSxy/YD/5DZ7mzmU5F6b90v60pZJNWQ4fY9kS/5yi+
         it1v9t/lze2bvljHNbU+oyJqkMQTeIUp4LbakheGSa3/fPdYPg3OarmtOkIy4LMeQ3CC
         n77ztVrc19F3K+TD9ROGKYZsO8HGiUcM6X7/nErY2EPNh+aq4pl57Hn/ch47RnzOSWy/
         +CzTznj7U+TmJYvWOXe1/UOYOnTz3ywFyJLP4q8yvenj5VA4Jpxq0q+oDvIkz0B2HFf5
         cZrg==
X-Gm-Message-State: ABy/qLbArjMkfY4qhgRcgXtCe9GHLUxKwvOKbf4gtN74jc+/UJ1hzV4n
        1yuPMWS4NCCivdOtkT40UnuRow==
X-Google-Smtp-Source: APBJJlEQmJeviL+37gjiNcFnFytw9+eTKkpE7kLIEoK/RRHnKJPBDF5yBsD7fzU9qZngK8mJfUDYvQ==
X-Received: by 2002:a05:6a20:4312:b0:123:149b:a34f with SMTP id h18-20020a056a20431200b00123149ba34fmr252803pzk.1.1689893037099;
        Thu, 20 Jul 2023 15:43:57 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fm15-20020a056a002f8f00b0067526282193sm1649453pfb.157.2023.07.20.15.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 15:43:56 -0700 (PDT)
Message-ID: <b6abcc55-e713-ee10-fd4c-0780262f909a@kernel.dk>
Date:   Thu, 20 Jul 2023 16:43:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
Content-Language: en-US
To:     matoro <matoro_mailinglist_kernel@matoro.tk>,
        Helge Deller <deller@gmx.de>
Cc:     io-uring@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-parisc@vger.kernel.org
References: <ZLhTuTPecx2fGuH1@p100>
 <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
 <be208704-b312-f04d-4548-90853a638752@gmx.de>
 <ab42ee876fbab9cf10d6c1dde3164945@matoro.tk>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ab42ee876fbab9cf10d6c1dde3164945@matoro.tk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/23 4:39?PM, matoro wrote:
> On 2023-07-20 18:38, Helge Deller wrote:
>> On 7/21/23 00:30, Jens Axboe wrote:
>>> On 7/19/23 3:20?PM, Helge Deller wrote:
>>>> The io_uring testcase is broken on IA-64 since commit d808459b2e31
>>>> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
>>>>
>>>> The reason is, that this commit introduced an own architecture
>>>> independend get_unmapped_area() search algorithm which doesn't suite the
>>>> memory region requirements for IA-64.
>>>>
>>>> To avoid similar problems in the future it's better to switch back to
>>>> the architecture-provided get_unmapped_area() function and adjust the
>>>> needed input parameters before the call.  Additionally
>>>> io_uring_mmu_get_unmapped_area() will now become easier to understand
>>>> and maintain.
>>>>
>>>> This patch has been tested on physical IA-64 and PA-RISC machines,
>>>> without any failures in the io_uring testcases. On PA-RISC the
>>>> LTP mmmap testcases did not report any regressions either.
>>>>
>>>> I don't expect issues for other architectures, but it would be nice if
>>>> this patch could be tested on other machines too.
>>>
>>> Any comments from the IA64 folks?
>>
>> matoro tested it on ia64 at least...
>>
>>> Helge, should this be split into three patches? One for hppa, one for
>>> ia64, and then the io_uring one?
>>
>> If we split up, I would prefer to split it into 2 patches: One for
>> io_uring together with the hppa patch, since they should go in
>> together.
>>
>> The ia64 patch is probably unrelated, and can go seperately. But
>> there doesn't seem to be any ia64 maintainer...?
>>
>> Do you have a chance to test this patch on the other io_uring
>> platforms, without applying it into your tree? I think some testing
>> would be good.
>>
>> Helge
>
> 
> I tested this on ppc64le last night just to be sure, still had 100%
> pass on test suite.

Excellent, thanks.

-- 
Jens Axboe

