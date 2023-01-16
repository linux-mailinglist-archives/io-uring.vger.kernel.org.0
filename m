Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C80066D0CE
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjAPVRD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjAPVQW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:16:22 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991BB21A3B
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:16:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso4378089wmb.1
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vL1FgkYmuperknazhtcHJggYUVrMhKhCG6RZS3ghWPQ=;
        b=R1QlEPYohb+Aaoq6ZUyBA81Wprsajl2scXbOp4PzLNB1gZDJO2Lga/vZ2tqKpxhXL8
         oiucqpwUS3PU0TtsGG8Utb7U9mfygy847PGbpbyRa/XsBrNh4KPdkyfuvY92d882uaqj
         vVxLSlZJDW3VOxf6yrFnmIrdUOJP9utLR41ChM3vXrd+5Umg0MX0e0gyiD/oj6g2kGrw
         FM/wq7I4mO5nrPgFUYw1M6ISzg8Oy7VxkGIWaeWpXNpbY3UBVupszL33AZQYfFRPJXKF
         R4zog1N116i1sdiUsvE/p75UIHTurkPAjIieJep6AB+C7zd7tyIu+3iuI7QFHlpPUj/i
         WmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vL1FgkYmuperknazhtcHJggYUVrMhKhCG6RZS3ghWPQ=;
        b=246JInQOU0J+D4G2ymm4AT0Oztc8rg/DWZyPDhdjzZAKcB5zOcwKzPQGzRBmxyM07H
         DqhsWr+VNKL2IZLarXiVdgyrEO9vjvD1ThEX3YmtxksXWe3Fs6zv+FEhY2XUaragBwQ3
         IzBtZLSS7TFbOEGl4JtYKdU/hXwUT+20wd9OX4Fbh9ZED1TLu+REumtBMYbbufnICI6q
         DR0nSf05RT4b5hDMK+5+layW5ngCS3DNn6LGMSbMaNjlcJYp0iflaRzuuKsLaTbEQNVX
         mIHVdLdGSvVlEQ1EsLHxMbDisU5gDO/S23vgA2en9dCXM9wqVh+vmnRvFUwPqJiTaF5G
         FIlA==
X-Gm-Message-State: AFqh2kokXJxUbPMLzi7hlD0c53z6F4G0xUd4hVfRgC4n3mIrWE/pRDNa
        FVbn6oIR+PsV00tY4RXy3LQ=
X-Google-Smtp-Source: AMrXdXvUiupVSUqR61XyE2HDT1zqqnfnNEg/UknU6RtEQSuigGyji+hIcgtcmfP+zyhv3BMHD8VX2A==
X-Received: by 2002:a05:600c:224a:b0:3da:fa15:8658 with SMTP id a10-20020a05600c224a00b003dafa158658mr5113615wmm.32.1673903779150;
        Mon, 16 Jan 2023 13:16:19 -0800 (PST)
Received: from [192.168.8.100] (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id fc14-20020a05600c524e00b003a3442f1229sm44898961wmb.29.2023.01.16.13.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 13:16:18 -0800 (PST)
Message-ID: <011cdcb4-4ab1-f680-9409-d5234acf9a1d@gmail.com>
Date:   Mon, 16 Jan 2023 21:15:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
 <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
 <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 21:04, Jens Axboe wrote:
> On 1/16/23 12:47 PM, Pavel Begunkov wrote:
>> On 1/16/23 18:43, Jens Axboe wrote:
>>> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>>>> io_submit_flush_completions() may queue new requests for tw execution,
>>>> especially true for linked requests. Recheck the tw list for emptiness
>>>> after flushing completions.
>>>
>>> Did you check when it got lost? Would be nice to add a Fixes link?
>>
>> fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.
> 
> I'm not either as it isn't fully descriptive, but it is better than
> not having that reference imho.
> 
>> Looks like the optimisation was there for normal task_work, then
>> disappeared in f88262e60bb9c ("io_uring: lockless task list").
>> DEFERRED_TASKRUN came later and this patch handles exclusively
>> deferred tw. I probably need to send a patch for normal tw as well.
> 
> So maybe just use that commit? I can make a note in the message on
> how it relates.

Yes please, thanks

-- 
Pavel Begunkov
