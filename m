Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0C51D88F
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 15:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392263AbiEFNRu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 09:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343648AbiEFNRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 09:17:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAAE5B893
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 06:14:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y41so1406280pfw.12
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 06:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ihidgXYB4xhjPn48/H5XkAMtFgyfgQGRP//jjSqAZfI=;
        b=7mtkz5L+M6CyMpuvSrwmf/po6soshccZkNmunBuH8V68CckpXuXwnPczrcP8Zarrqw
         wlEISzVXGgr3lE/+qnQXce9zh/MWgauJ09HVHypP+wQ+ZKlUWGWQV20qtf3E9eaHM4uO
         itgDW03k+VhpYeAx8L8yDX2zfAPjjRO4XstYqMvOCX1LFKn61uSiYRa55ZgnEh0BYsef
         4F098W0akvQnlNELLFIWuPxCghX8RToOcCzZALCu9LUy4UA5cisgcnmBiKxGtaNUAnFB
         1q0iZr9MOaZoYUOsZh8dqSC28pA2VuCPCQRuPD+SBAzj2LbwDPrrzpLvi6o13jp0gKwq
         TqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ihidgXYB4xhjPn48/H5XkAMtFgyfgQGRP//jjSqAZfI=;
        b=bpGkVCRl7I1XAqu+VZVdIX+Ul3uF/aBnmLdZSafkV7TenpA9wC+UkyZLAxIoLDdHdg
         TwovJ1ylkgzhgzdkTo/IkzYFlGgG+dBa3ke6m14RY09zo5wVv/U/BGWAMGM+dlyV/BK7
         nkurSYbMcVvYtlmxUrhYR55qVOZ4HNqFJlut9666xzPBJuSZgZUnPraS5KiBqKP+hi/P
         YRVZbwyuD55XyPv/7fBh6L8dZ4PPsgrSFInjVp7oopCX/PY+zryKAH/vCbT9n7Nlqkt6
         LikZ9cf3tUyEu83W9fzDNnyeBFcP00WmIJbA94bBzBqBz9gxW22+lEG8o2BWqejqa5tj
         a3vw==
X-Gm-Message-State: AOAM532iGTqoTbAW6ohdAuNsL+wETyAqclH6il6UIAxax0rNy9qH60Oa
        ybr+NYw1bOvdYtULYOQS3gQZCkWEptjfdQ==
X-Google-Smtp-Source: ABdhPJxbgh99Uq2Q8nb4hWzt4D5dqalKDU8yUhhAXreQdsMJpNz9gHsObYxtOvni+z64QBRJbROaeA==
X-Received: by 2002:a05:6a00:1784:b0:50d:d8cb:7a4f with SMTP id s4-20020a056a00178400b0050dd8cb7a4fmr3481979pfg.23.1651842844406;
        Fri, 06 May 2022 06:14:04 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j8-20020aa783c8000000b0050dc762818asm3322528pfn.100.2022.05.06.06.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 06:14:03 -0700 (PDT)
Message-ID: <ac5bc77c-16a3-77b6-df57-823e16c89a70@kernel.dk>
Date:   Fri, 6 May 2022 07:14:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
 <20220505060616.803816-1-joshi.k@samsung.com>
 <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
 <a715cc61-97e7-2292-ec7d-59389b00e779@kernel.dk>
 <20220506064249.GA20217@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506064249.GA20217@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 12:42 AM, Kanchan Joshi wrote:
> On Thu, May 05, 2022 at 12:29:27PM -0600, Jens Axboe wrote:
>> On 5/5/22 12:20 PM, Jens Axboe wrote:
>>> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>>>> This iteration is against io_uring-big-sqe brach (linux-block).
>>>> On top of a739b2354 ("io_uring: enable CQE32").
>>>>
>>>> fio testing branch:
>>>> https://protect2.fireeye.com/v1/url?k=b0d23f72-d1592a52-b0d3b43d-74fe485fb347-02541f801e3b5f5f&q=1&e=ef4bb07a-7707-4854-819c-98abcabb5d2d&u=https%3A%2F%2Fgithub.com%2Fjoshkan%2Ffio%2Ftree%2Fbig-cqe-pt.v4
>>>
>>> I folded in the suggested changes, the branch is here:
>>>
>>> https://protect2.fireeye.com/v1/url?k=40e9c3d0-2162d6f0-40e8489f-74fe485fb347-f8e801be1f796980&q=1&e=ef4bb07a-7707-4854-819c-98abcabb5d2d&u=https%3A%2F%2Fgit.kernel.dk%2Fcgit%2Flinux-block%2Flog%2F%3Fh%3Dfor-5.19%2Fio_uring-passthrough
>>>
>>> I'll try and run the fio test branch, but please take a look and see what
>>> you think.
>>
>> Tested that fio branch and it works for me with what I had pushed out.
>> Also tested explicit deferral of requests.
> 
> Thanks for sorting everything out! I could test this out now only :-(
> Fio scripts ran fine (post refreshing SQE128/CQE32 flag values;repushed fio).
> 
> I think these two changes are needed in your branch:
> 
> 1. since uring-cmd can be without large-cqe, we need to add that
> condition in io_uring_cmd_done(). This change in patch 1 -
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 884f40f51536..c24469564ebc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4938,7 +4938,10 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
> 
>        if (ret < 0)
>                req_set_fail(req);
> -       __io_req_complete32(req, 0, ret, 0, res2, 0);
> +       if (req->ctx->flags & IORING_SETUP_CQE32)
> +               __io_req_complete32(req, 0, ret, 0, res2, 0);
> +       else
> +               io_req_complete(req, ret);
> }
> EXPORT_SYMBOL_GPL(io_uring_cmd_done);

Ah yes, good catch, I missed that it's cqe32 exclusive right now.

> 2. In the commit-message of patch 1, we should delete last line.
> i.e.
> "This operation can be issued only on the ring that is
> setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags."
> 
> And/or we can move this commit-message of patch 4.

I killed the line.

> You can either take these changes in, or I can respin the series. LMK.

I folded it in and will process Christoph's suggestions.

-- 
Jens Axboe

