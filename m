Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9978FFBF
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348358AbjIAPN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 11:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjIAPN2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 11:13:28 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C7910FD
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 08:13:20 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-792973a659fso28158639f.0
        for <io-uring@vger.kernel.org>; Fri, 01 Sep 2023 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693581199; x=1694185999; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9UE7oLQ83pGDXx4WjLw45n2Dhge6/gS6LK9Au9LAjtE=;
        b=f6k40V6EwNA2ZvWuF85qMNB9UqREh81k3VvmioX7yaMg1Fs2sD4c3HRrKMMzhBkPPy
         rgr+4pCHid8rU80Gn9PwWLPSY0FFb+yZayfsXInI1dvooYmEeCuyeKNjiTvYTddPvMHs
         fqeiBS4WxQrakB6ALHxe8NT6TvnZx1sjBFMXf5VDClYwVeplTOxOx2GsWe2ywkkVZK5/
         wDCGn/dpMnOPDLCBmsaG4YtZQ2egMjajLa2sySFReU25VlPNISP8oXSWdrDR1Ywd4ZS+
         aMXkcGRToO9da2kVLY1hJKFX3R2YDY4rN3l46IAL+1vyirS+kvWNYZDOa7EGrkRceK30
         /vSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693581199; x=1694185999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UE7oLQ83pGDXx4WjLw45n2Dhge6/gS6LK9Au9LAjtE=;
        b=TpW4eP6spsJksXDtRLgywMBdTd5GYV/8Su8qnYMEwj6baFY/7FY2HVHX/+wHvj3qBV
         NF8rs5xG6mxe8eofG4C2tT6i9gTFDasVsLhDmThS6CPfQVnRP2vwc7Zi980n3Ar1Gp8F
         azTuiIR0dOkVXSchSvOeUOSd2hQrEXjePWTI9Wl6nDZBnlCn2xADGGgHFf52Qr3y8uxK
         dxwIEMgkVbd458FUvxCfJS4jdhd+pvJ6EQUiBSREAi3N0Wad3GduVJXRthAzhZET4XlZ
         UhUTpoEZgm9H9q3hz4IkinX5IpfmnsIRz0Cf/b4GeZ2Vl8p47ltE8gx8Hc1FMNW/QIdo
         K60g==
X-Gm-Message-State: AOJu0YyNigm6tJs4JUj5o04bL1ZPg2b9D/8AJLhLuWLkDp044DYCFZqz
        PiW+YoEfU2pSbJPn2XW9zIuYDw==
X-Google-Smtp-Source: AGHT+IEc0gj+C3cMhobyRMtUY5K7UbtQ0qfQxrBG2d7sHpcNr/6rWr2Hc4O3TX+C82bzJrYROcn3UQ==
X-Received: by 2002:a05:6602:1a0c:b0:792:6068:dcc8 with SMTP id bo12-20020a0566021a0c00b007926068dcc8mr2978361iob.2.1693581199549;
        Fri, 01 Sep 2023 08:13:19 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q8-20020a02a308000000b0042b358194acsm1080745jai.114.2023.09.01.08.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:13:18 -0700 (PDT)
Message-ID: <a9313063-c539-4e0a-88c3-155c974add99@kernel.dk>
Date:   Fri, 1 Sep 2023 09:13:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <78ae000c-5704-4f59-bd2a-79e8cbeb9aaa@kernel.dk> <ZPH/QEXmh3NiY736@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZPH/QEXmh3NiY736@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/23 9:12 AM, Ming Lei wrote:
> On Fri, Sep 01, 2023 at 08:47:28AM -0600, Jens Axboe wrote:
>> On 9/1/23 7:49 AM, Ming Lei wrote:
>>> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
>>> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
>>> Meantime io_wq IO code path may share resource with normal iopoll code
>>> path.
>>>
>>> So if any HIPRI request is submittd via io_wq, this request may not get resouce
>>> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
>>>
>>> The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
>>> with default null_blk parameters.
>>>
>>> Fix it by always cancelling all requests in io_wq by adding helper of
>>> io_uring_cancel_wq(), and this way is reasonable because io_wq destroying
>>> follows canceling requests immediately.
>>
>> This does look much cleaner, but the unconditional cancel_all == true
>> makes me a bit nervous in case the ring is being shared.
> 
> Here we just cancel requests in io_wq, which is per-task actually.

Ah yeah good point, it's just the tctx related bits.

> Yeah, ctx->iopoll_ctx could be shared, but if it is used in this way,
> the event can't be avoided to reap from remote context.
> 
>>
>> Do we really need to cancel these bits? Can't we get by with something
>> trivial like just stopping retrying if the original task is exiting?
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index c6d9e4677073..95316c0c3830 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1939,7 +1939,7 @@ void io_wq_submit_work(struct io_wq_work *work)
>>  		 * If REQ_F_NOWAIT is set, then don't wait or retry with
>>  		 * poll. -EAGAIN is final for that case.
>>  		 */
>> -		if (req->flags & REQ_F_NOWAIT)
>> +		if (req->flags & REQ_F_NOWAIT || req->task->flags & PF_EXITING)
>>  			break;
> 
> This way isn't enough, any request submitted to io_wq before do_exit()
> need to be reaped by io_iopoll_try_reap_events() explicitly.
> 
> Not mention IO_URING_F_NONBLOCK isn't set, so io_issue_sqe() may hang
> forever.

Yep it's not enough, and since we do only cancel per-task, I think this
patch looks fine as-is and is probably the right way to go. Thanks Ming.

-- 
Jens Axboe

