Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495934FE641
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241788AbiDLQtH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244550AbiDLQtH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:49:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2285641F
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:46:49 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d15so17281778pll.10
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=gwOzfIKgGkpMl7eRrmcUFE7J21orn78ptzO4ar+0Kck=;
        b=3evLoZICzMSeZeShGZj1V6hyJ2jpjiFVsYkleLpsRsEy0adSLWTLT6k/6fVCmPg/4A
         9hYwv/ruWI+wIrFzx1N6fUpMMALBzmOT5gn4tzBQCKqXKD7SYxr8h0xXJ3pQMeXQ5ySf
         88w4IYPOd5p/IGtYSbh9Yfv+VCayHFzV0J6JSi6U/p9CSrGAE8vBPgqxyD85RXV5YBii
         flgJE44LFGxdvacFzVwOb3slezCWM6UGvbOwlJU1nAi2f5HrW2bGyFjBQ/F1NdbZRlji
         eOguf1nBMVsmk3Q4z2ODe7iFNfjvnZJq3ZsiEDMKGPmObN3dq6Hh1QQN8tqBiwJOM1kH
         PBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=gwOzfIKgGkpMl7eRrmcUFE7J21orn78ptzO4ar+0Kck=;
        b=4UQBeKcBbd5g9jqtGV0rKKKrVY4VXx/6ezWZsoYwCsxFHM0mqpk+QJmCkXmer+bykH
         KFrFdJ81anxbtZ1UeVp4f/cR4tqzmOKz5CCXIfwf7WLhU5tL0TWvbburKTlGwR++SCb5
         wF8Mzt+yez5W6qsDm3xC85bEmXApnYQLzVzMgsjs+aH+YZCB0Lil6l8UPawCY4d7ifxv
         rFovy8Hg1MR80Mup/lb2JZt4nm6jixEtkb9x7wPTAzEQWhjEfscQqZvYuK5LgdBts8t0
         hPhgsz/YW7r0rCht2Sv3laeC8N/LFRuwlywJ1UUQyGGmiwgYO+gvvnHWbfQx3WFUpmSX
         3gpA==
X-Gm-Message-State: AOAM532oGEpDY0LtzDXZ7ONvNohwOwXBP7y9BFsHdIfcbaNywFgqsDWb
        c0vPHobsCBtEsXEd6+33HZImCA==
X-Google-Smtp-Source: ABdhPJz279lFlBqz8ke+gVo42lSoGGetedrFyWhNmMXge6JO+hYIBjqgJdt9NnVM+iBMtAw0RzQOcg==
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id v10-20020a17090a00ca00b001ca5253b625mr6032228pjd.220.1649782008873;
        Tue, 12 Apr 2022 09:46:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v4-20020a622f04000000b005057a24d478sm15747355pfv.121.2022.04.12.09.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:46:48 -0700 (PDT)
Message-ID: <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
Date:   Tue, 12 Apr 2022 10:46:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
In-Reply-To: <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 10:41 AM, Jens Axboe wrote:
> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>> If all completed requests in io_do_iopoll() were marked with
>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>> io_free_batch_list() leaking memory and resources.
>>
>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>> return the value greater than the real one, but iopolling will deal with
>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
> 
> Ah good catch - yes probably not much practical concern, as the lack of
> ordering for file IO means that CQE_SKIP isn't really useful for that
> scenario.

One potential snag is with the change we're now doing
io_cqring_ev_posted_iopoll() even if didn't post an event. Again
probably not a practical concern, but it is theoretically a violation
if an eventfd is used.

-- 
Jens Axboe

