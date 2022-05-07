Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B351E853
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 17:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385984AbiEGPzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446624AbiEGPzm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 11:55:42 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBED396B2;
        Sat,  7 May 2022 08:51:54 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id a191so8513571pge.2;
        Sat, 07 May 2022 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=2oAxtV7OXPjo1uzgCFDu7xXGxFy1f3aMRQk+dkeOZW0=;
        b=TWAN52yrzb1Pm6HDrRn/+2aGp8gPsvGZId/P6LUU4Fykemre7nmjQ8rJo4+nfMmeno
         Hq/gaWsY1X9Pl9yuoYcc3v1GNOxqWlln5t2aY6lwTobCV+EYj+YHZ+MWmn9KqHtLp4mp
         IOIT86XxwDcoo2QXc73fRr0WxUaHNitScZYp/jfYoz9VKsTQ15NGGuPj9hmhN6/XxsZl
         WVhwtuHV0l4NQK5nBxaRhAmbG/cjf+CvMDBb13bgSM5a9TpgEKas2/lULymyEBVOqyYw
         EjauA4hUffbdsGJ8E059i5vV5gWowhtof9eBnhHjrWH4FGb/FpL3pDo8z4kPbgztLXaT
         dSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2oAxtV7OXPjo1uzgCFDu7xXGxFy1f3aMRQk+dkeOZW0=;
        b=jNMxr+6smVFUL0sT4aBK/7tfrzrGRcMpYy7MHB9dMW7tZF9SwMeAu4mcTmoh+9JFFF
         Ob5LCWiNV0eFFdOgVC7/1y4/pjLJ3XzTaEwThAYer+l+tVICvAU4/KDxJq5mLLzC7K0T
         Lzd2nvGm+pqgAVUxWUILtoIjPwdeGSYpFAFj+WNKLHdEIoPAs65ePTT6588RKXAoiQ9Z
         3hXRFeKsx1xWGmzDqA7TBsMKxVbdsTJHvn6eusEZhr/wrwiAlMXBtztF/a3Fqp2L5Mpm
         K06OcAds+AiW719VIcp6U7fXv1FwsKyeaNv7QEKuJudZdm/0iKitoC4H872Uwy+Xp4xK
         Nrow==
X-Gm-Message-State: AOAM531Ysql/2bm47ohTbMnNy/jexCF8Gl9oVmTduzGQjZdDyopL5Lg6
        z54DwVfDbki9RxHU8YzGdl1rkt2cK7COTevV188=
X-Google-Smtp-Source: ABdhPJzj07bjZLVajqEeHOAvJARaSsSdfGvaNJaCbiLTgtZpydOo//n92Z8MTuzYh7sVkunFpl1qgQ==
X-Received: by 2002:a63:8242:0:b0:3c2:91b4:7c61 with SMTP id w63-20020a638242000000b003c291b47c61mr6845530pgd.268.1651938713894;
        Sat, 07 May 2022 08:51:53 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090270c400b0015ec71f2d7dsm3788967plt.239.2022.05.07.08.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 08:51:53 -0700 (PDT)
Message-ID: <c347be9c-0421-c8a1-1d9d-26ef7fc377ec@gmail.com>
Date:   Sat, 7 May 2022 23:52:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <20220507140620.85871-2-haoxu.linux@gmail.com>
 <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
 <c55de4df-a1a8-b169-8a96-3db99fa516bb@gmail.com>
 <0145cd16-812b-97eb-9c6f-4338fc25474a@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <0145cd16-812b-97eb-9c6f-4338fc25474a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 下午11:38, Jens Axboe 写道:
> On 5/7/22 9:31 AM, Hao Xu wrote:
>> ? 2022/5/7 ??10:16, Jens Axboe ??:
>>> On 5/7/22 8:06 AM, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
>>>> support multishot.
>>>>
>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> Heh, don't add my SOB. Guessing this came from the folding in?Nop, It is in your fastpoll-mshot branch
>> https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=e37527e6b4ac60e1effdc8aaa1058e931930af01
> 
> But that's just a stand-alone fixup patch to be folded in, the SOB
> doesn't carry to other patches. So for all of them, just strip that for
> v4. If/when it gets applied, my SOB will get attached at that point.
> 
Sorry, paste a wrong link, should be this:
https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=289555f559f252fbfca6bdd0886316a8b17693e2

