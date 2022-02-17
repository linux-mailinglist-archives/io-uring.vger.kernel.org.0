Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE394BA50C
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiBQPvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 10:51:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241647AbiBQPvg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 10:51:36 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005EC2B2FFE
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:51:02 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z18so2573210iln.2
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pwVgJOZ/Ol2g92l1rNwj7a+wNfyyuDtSekzqAfAwkvc=;
        b=BkwggVnU10JDQWxf0JnKO9utjcsknKkwPF8vRW9V+RP0ljb6/Vgqzn69Nzbny5ko7d
         kr1CWU2UYAA2BkyeZpjj84Na/34cjbfqJDKg/WPkO1UR1V/zhabIrn85neKd/lCuZhYx
         I4FQrKjBotBkJNeSGkSQpTSsP4EMuHN4izvbWHYM9A9B4OkUE9v0UudZjdMNt45Z4cVr
         GCBGc2JqoSsogs0TC0u0bSXpCXxEyeL6ms62LpLTSToeKQ3Ym5sOgVz2s1dCWI3gJX3b
         s6J5D4KOmAtz1/pFdc9L/EuyXoxTIObNaUUh5ihOF/WPLquk862o+T/DnssZsrhuhpkR
         hWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pwVgJOZ/Ol2g92l1rNwj7a+wNfyyuDtSekzqAfAwkvc=;
        b=dxMApRh5Qm7BbnD0tUXFwX+hxiQe5MD9QUvoMlXbWvt5vbONJLsKaCZZB11j59MlPR
         Dt2MDKGtqpQRuEyuHNnLnDtlgKejSZBTIVksLysePC4D3MrrIWDlB0gD/lU0Wlb3C7eW
         O1i6NKxN8g0ShBK8FSfHN3lXURfcOF+kq4sJMcHwyBStxfMnO6HbCRcS/jjgjG701zoz
         JDheY4IZUkVeXXO4GRAvvxxkMF4BeTvFHdMBrol/KeH+p4qh71axDY9oGWUpuzMRad9G
         TL8NIvic2zrzIaN89QYZ42nj92rvXljJxDHZTcE20tU9gzyASrkxb4xR6fL8qmdpYXvK
         EW3Q==
X-Gm-Message-State: AOAM531yPEwLlHs3UkItVJjGnsHhFTlw29rUxA867epjUNABLgLEuLDM
        HXOWJidFEjOOVV5m0x0FkK2NsQ==
X-Google-Smtp-Source: ABdhPJw0DRDT4raNzuDfpXbF+2DJuhvhqILxEiWgssr6hFUI9RMbPFGX8naA7JjRWKu8d+XR9Wb8vA==
X-Received: by 2002:a05:6e02:1706:b0:2ba:fca5:eb2 with SMTP id u6-20020a056e02170600b002bafca50eb2mr2402874ill.267.1645113061999;
        Thu, 17 Feb 2022 07:51:01 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u12sm1978969ilg.51.2022.02.17.07.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 07:51:01 -0800 (PST)
Message-ID: <b11ede2b-b737-f99a-7b31-20d6b4eccb42@kernel.dk>
Date:   Thu, 17 Feb 2022 08:50:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC 01/13] io_uring: add infra for uring_cmd completion in
 submitter-task
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Pankaj Raghav <pankydev8@gmail.com>
References: <20211220141734.12206-1-joshi.k@samsung.com>
 <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
 <20211220141734.12206-2-joshi.k@samsung.com>
 <Yg2vP7lo3hGLGakx@bombadil.infradead.org>
 <CA+1E3rLpKp0h2x7CoFPXwsYOc4ZYg_sqQQ+ed8cJhq77ESOAjg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rLpKp0h2x7CoFPXwsYOc4ZYg_sqQQ+ed8cJhq77ESOAjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/22 8:39 AM, Kanchan Joshi wrote:
> On Thu, Feb 17, 2022 at 7:43 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>
>> On Mon, Dec 20, 2021 at 07:47:22PM +0530, Kanchan Joshi wrote:
>>> Completion of a uring_cmd ioctl may involve referencing certain
>>> ioctl-specific fields, requiring original submitter context.
>>> Export an API that driver can use for this purpose.
>>> The API facilitates reusing task-work infra of io_uring, while driver
>>> gets to implement cmd-specific handling in a callback.
>>>
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>> ---
>>>  fs/io_uring.c            | 16 ++++++++++++++++
>>>  include/linux/io_uring.h |  8 ++++++++
>>>  2 files changed, 24 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index e96ed3d0385e..246f1085404d 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
>>>               io_req_complete_failed(req, -EFAULT);
>>>  }
>>>
>>> +static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
>>> +{
>>> +     req->uring_cmd.driver_cb(&req->uring_cmd);
>>
>> If the callback memory area is gone, boom.
> 
> Why will the memory area be gone?
> Module removal is protected because try_module_get is done anyway when
> the namespace was opened.

And the req isn't going away before it's completed.

>>> +{
>>> +     struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>>> +
>>> +     req->uring_cmd.driver_cb = driver_cb;
>>> +     req->io_task_work.func = io_uring_cmd_work;
>>> +     io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>>
>> This can schedules, and so the callback may go fishing in the meantime.
> 
> io_req_task_work_add is safe to be called in atomic context. FWIW,
> io_uring uses this for regular (i.e. direct block) io completion too.

Correct, it doesn't schedule and is safe from irq context as long as the
task is pinned (which it is, via the req itself).

-- 
Jens Axboe

