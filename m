Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28FB54F93E
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382761AbiFQOel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382758AbiFQOek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:34:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C350B14
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:34:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e24so4117866pjt.0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mRvDDdP9BGRMPTO96iKrW8+OhudtcRJLxtzoTMeM9R4=;
        b=fDF9T1ci0dytwjJuroWesWxPtRcMate0XtY3nDJq5k5dDFvOfYgO8F0+OXWV4DCJm6
         j1PSR7au5GhWrTo4m6bwt+wDoZ1AgiRtAksTYniREKF6PgbfAB5uqdstOanxiHFAEzt1
         hUq0Aed7Uy8+hR+q3Tzfo6nH3QZ9xgRN3qLyeL6reRXRXldTYZBNHfukkPSv2Kn9AbH6
         trzye7HPyEJg4O3siWF4Bc6PzSOvRdaueZzfs9IwOgL9cPBUSUrMb8QeimmNtpd1lEC/
         ggEexZXjU9fI1F53Cb3UyGPkktHd+AafO37vYywkuYLg4TjO4pDEVWBErF7g7IynQUIa
         Cwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mRvDDdP9BGRMPTO96iKrW8+OhudtcRJLxtzoTMeM9R4=;
        b=aXFs6/GAWzfBYYcQkz9okfw0uu9BWEUzJMXSiV+l8XJ6kNJP28LRh9grKBxQo3Cz9F
         zsi4fUY44WY1VkDFBuvXp577/R3vIMlI0pg8QdGgby7arDrZM/sty67hKX8I2LROdV0k
         vMCqUA7jDmb4RB0OdBB8ZdPg5mQJ2aoyyyEQXoQw7BjFRPAfdZ6/WAiu2Ts9te4DJ7i9
         b3TgIZ9V/gNXfS25uIv7IzcSVePtGuOsurmPFF7na9Y2c8D3FMMnNS72S1nl8170DaBw
         RKCwhqUU4bqGiWm8aYigNAygi6cFzI1wwxLLUzhngZJ4WcMQ/wXN5d2Jd0AOPfIkR2RH
         9vjg==
X-Gm-Message-State: AJIora9go1boh0azBA9PdsIc/A8stAQAOON4Eo8yTumBRfY2m4TfX4OA
        6skvrLnQhqMtOL0Bn8FF2eiDWfvF25aK4Q==
X-Google-Smtp-Source: AGRyM1vzNwltMUIIW8czfRr21XgSdQVnsTz3who0G3JqIShug3aPKRM2oGASYXrimQMGA0l+jsF2FA==
X-Received: by 2002:a17:902:f652:b0:156:701b:9a2a with SMTP id m18-20020a170902f65200b00156701b9a2amr9894344plg.14.1655476479039;
        Fri, 17 Jun 2022 07:34:39 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a174b00b001e31c7aad6fsm3336020pjm.20.2022.06.17.07.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 07:34:38 -0700 (PDT)
Message-ID: <226d9192-3f99-776c-0327-2506de6ff3dd@kernel.dk>
Date:   Fri, 17 Jun 2022 08:34:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: net: fix bug of completing multishot accept
 twice
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220617141201.170314-1-hao.xu@linux.dev>
 <6704dc2f-87dd-62d5-7f95-871b6db3a398@kernel.dk>
 <ea7b244e-4c11-102b-51a8-aae061a8c227@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ea7b244e-4c11-102b-51a8-aae061a8c227@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 8:34 AM, Hao Xu wrote:
> On 6/17/22 22:23, Jens Axboe wrote:
>> On 6/17/22 8:12 AM, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Now that we use centralized completion in io_issue_sqe, we should skip
>>> that for multishot accept requests since we complete them in the
>>> specific op function.
>>>
>>> Fixes: 34106529422e ("io_uring: never defer-complete multi-apoll")
>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>> ---
>>>
>>> I retrieved the history:
>>>
>>> in 4e86a2c98013 ("io_uring: implement multishot mode for accept")
>>> we add the multishot accept, it repeatly completes cqe in io_accept()
>>> until get -EAGAIN [1], then it returns 0 to io_issue_sqe().
>>> io_issue_sqe() does nothing to it then.
>>>
>>> in 09eaa49e078c ("io_uring: handle completions in the core")
>>> we add __io_req_complete() for IOU_OK in io_issue_sqe(). This causes at
>>> [1], we do call __io_req_complete().But since IO_URING_F_COMPLETE_DEFER
>>> is set, it does nothing.
>>>
>>> in 34106529422e ("io_uring: never defer-complete multi-apoll")
>>> we remove IO_URING_F_COMPLETE_DEFER, but unluckily the multishot accept
>>> test is broken, we didn't find the error.
>>>
>>> So it just has infuence to for-5.20, I'll update the liburing test
>>> today.
>>
>> Do you mind if I fold this into:
>>
>> 09eaa49e078c ("io_uring: handle completions in the core")
>>
>> as I'm continually rebasing the 5.20 branch until 5.19 is fully sorted?
>>
> 
> Please do, that is better.

Done, thanks.

-- 
Jens Axboe

