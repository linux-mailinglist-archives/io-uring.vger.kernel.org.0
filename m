Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C2A59061A
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 19:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiHKRvf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiHKRve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 13:51:34 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E8BA0624
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 10:51:33 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g15so8718234iob.0
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 10:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=EQ+GRCeAW1keVeHbRGzcZCOrofoztEXgzZOrq1/0DmI=;
        b=cte6u2UxwyEWoFQq4aNApHb5X3wBpYaCR1M4SBxNeNO+n0fttKZAyhWtpCTyZVsqcd
         zFvr+k/QWcKqAlf6mFLmJObjop+Lko3yXse7MB3OtwY6QjPzka+1nb8CnxI3snp9zwoD
         ULMhPcPTGmRFQDGlG3bd9VsQ9I18z154ZkSDQmXuSjvUwtQIGHuHEnhUlk+6SAFKPdfV
         rZGVqL4XogHOK5U6G8mEomqUh2EEWxRdVbvuzAJkQEyXLO+kZT/pmYSPeI9CQ9jaByWY
         pW1DT560QFkO5M9+q0tZqytenva1bRGcXzbc+wtApL1uyUCBxOa9qEzJpng8eetCXwyV
         GVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=EQ+GRCeAW1keVeHbRGzcZCOrofoztEXgzZOrq1/0DmI=;
        b=TNcXP5FJzG1OfCWrV/xcoKf/Nal5XU6uzJcqlQjG0NbNec8TVp+F9gezp5dVlm1+sq
         JJoCITjswJ8HecMO9eJYrdyTIsYcb5m6dsXNyVLuXS2f7T/kaTyp1uMJCQUaBWBBa5J1
         cNcMkkNiwod7qYJJmRk2zmyZhLeC13Pd3Jy4cb2J3QC6kLTTuANXqu51pQf1zRrgqfet
         3sLtM5DW/yYgYvICXte59Uku+wmUPWROIDC443av2xXlhJXIiUqX/0UfucAK6jZu7xiR
         oWl0EcNXlVZ8huP4tRpZjA/1miten1jt73M0jVkjQSBd5/ZR7nxAEAB3pgf4VkkI4GwI
         yX2Q==
X-Gm-Message-State: ACgBeo1YpSH+2Oi5HgtS7mzG12RYWVeDfniEaC2wWrtp5EfA1sYtk/K5
        IiGNjaSz1HZJ2waZm5PXVJ7y4g==
X-Google-Smtp-Source: AA6agR5ok46F7Jk43FhWd3Ujgot6AjP169PdV0Ly/9TpH2geZx00oUdrEIYFBhFK2Kf3hF2sG/SSqg==
X-Received: by 2002:a05:6638:3183:b0:341:63da:2f37 with SMTP id z3-20020a056638318300b0034163da2f37mr200157jak.237.1660240290584;
        Thu, 11 Aug 2022 10:51:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w2-20020a92c882000000b002de30ec2084sm3508784ilo.75.2022.08.11.10.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 10:51:30 -0700 (PDT)
Message-ID: <9b80f3d8-bef6-11a2-deb2-f94750414404@kernel.dk>
Date:   Thu, 11 Aug 2022 11:51:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     anuj20.g@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
 <20220811091459.6929-1-anuj20.g@samsung.com>
 <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
 <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
 <20220811173553.GA16993@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220811173553.GA16993@test-zns>
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

On 8/11/22 11:35 AM, Kanchan Joshi wrote:
> On Thu, Aug 11, 2022 at 10:55:29AM -0600, Jens Axboe wrote:
>> On 8/11/22 9:38 AM, Jens Axboe wrote:
>>> On Thu, 11 Aug 2022 14:44:59 +0530, Anuj Gupta wrote:
>>>> Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
>>>> error handling from handler to core. But for io_uring_cmd handler we end
>>>> up completing more than once (both in handler and in core) leading to
>>>> use_after_free.
>>>> Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
>>>> of error.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/1] io_uring: fix error handling for io_uring_cmd
>>>       commit: f1bb0fd63c374e1410ff05fb434aa78e1ce09ae4
>>
>> Ehm, did you compile this:
> Sorry. Version that landed here got a upgrade in
> commit-description but downgrade in this part :-(

I fixed it up.

> BTW, we noticed the original issue while testing fixedbufs support.
> Thinking to add a liburing test that involves sending a command which
> nvme will fail during submission. Can come in handy.

I think that's a good idea - if you had eg a NOP linked after a passthru
command that failed, then that would catch this case.

-- 
Jens Axboe

