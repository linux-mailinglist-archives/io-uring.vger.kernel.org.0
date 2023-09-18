Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12447A4F4A
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjIRQi6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 12:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjIRQiq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 12:38:46 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77977199D
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 09:10:57 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-59c06cf1614so5016587b3.1
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 09:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695053443; x=1695658243; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7iWbebg10gnFWR7iM1oWW4Z9fG3e9i+/WJObqob0t58=;
        b=dv2JMAbeA04OuEYleRuKPyCrSKLcIW7LVb0a8a/a4SQgbDLyVAHuiS7eAGj85y+MiO
         TqCKXt0WniimcLzRTnYii4tMmhekebY0Zp0+n2y+z0Gz3QAgpOvXfjvYR06enb+oT7m2
         qn+jzp7dpBWCeeoP7uZcZ8Bz4iirVAfFU2yiFfymDczxlRxgq8TPfgj/4vio5/E+Uc2O
         5906L5H8fzS6h+lx7gMe9nh6R0h19U9BCuOXllZJFyj5/rNxAlO34Vd4LfocKhCesux1
         onUn+PL/gihRkaGZyS0HfC0Yk9ZkVCPtTN0A542g/cbA5PAfwSxRY44+BNoaza1eDUb/
         exKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053443; x=1695658243;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7iWbebg10gnFWR7iM1oWW4Z9fG3e9i+/WJObqob0t58=;
        b=gowDca99pKxKw5c1ghiAfiNoEBz7wlPx6SPVEmwV3j2+H7GMCixrTfkfzOYhYGHn2p
         1Akf2JrBo5W4YQI2jgmU/1aZ0pwvXk5Qk4MEJeA+b5tr6Vxa++ZZ3L4zYQhrnfgjZanV
         sdErD298wI46WXj4VYkMuDlzcz3jthCsY6nULjeaGIofyYiZq91zLC8Q6JwgHTOTBYKr
         ch5yakZbCeCkjWao2651qZsJR8u5D2GTK2MlNgIC3p3FOy4//WGwA40o3oKuOjHAhJFc
         CF4bwX50zD3/VIJPhI0IYDzna9U7szGQQ/CHianibIxinWcP2iMLoBIFIzLiZ4awXuMC
         /DBw==
X-Gm-Message-State: AOJu0Yyv9wJTnA33QyfGabS5vyY7tU67vxQOGjVikWLp0r66KL0Nk1iJ
        iiAFoiU+oA9MHzKXe4SHk5anxpQGU4i8r4KitUtQjw==
X-Google-Smtp-Source: AGHT+IHGWRTSLzgZTvIMZdns13ovPmqiV8pBpaTltJZjgdLGTo/zbP9EC3nybcTa+ExfOJG9jb8BdQ==
X-Received: by 2002:a92:dcd0:0:b0:34e:2a69:883c with SMTP id b16-20020a92dcd0000000b0034e2a69883cmr9338192ilr.1.1695053038244;
        Mon, 18 Sep 2023 09:03:58 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c5-20020a92cf05000000b003459023deaasm1550824ilo.30.2023.09.18.09.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 09:03:57 -0700 (PDT)
Message-ID: <6067f24d-a641-441e-afc2-dd190f8a6931@kernel.dk>
Date:   Mon, 18 Sep 2023 10:03:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] io_uring/ublk: exit notifier support
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20230918041106.2134250-1-ming.lei@redhat.com>
 <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk> <ZQhPhFwgSLvR/zDM@fedora>
 <5706fa76-a071-4081-8bb0-b1089e86a77f@kernel.dk> <ZQh0p+ovm1sd3Vau@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZQh0p+ovm1sd3Vau@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/23 10:02 AM, Ming Lei wrote:
> On Mon, Sep 18, 2023 at 08:15:07AM -0600, Jens Axboe wrote:
>> On 9/18/23 7:24 AM, Ming Lei wrote:
>>> On Mon, Sep 18, 2023 at 06:54:33AM -0600, Jens Axboe wrote:
>>>> On 9/17/23 10:10 PM, Ming Lei wrote:
>>>>> Hello,
>>>>>
>>>>> In do_exit(), io_uring needs to wait pending requests.
>>>>>
>>>>> ublk is one uring_cmd driver, and its usage is a bit special by submitting
>>>>> command for waiting incoming block IO request in advance, so if there
>>>>> isn't any IO request coming, the command can't be completed. So far ublk
>>>>> driver has to bind its queue with one ublk daemon server, meantime
>>>>> starts one monitor work to check if this daemon is live periodically.
>>>>> This way requires ublk queue to be bound one single daemon pthread, and
>>>>> not flexible, meantime the monitor work is run in 3rd context, and the
>>>>> implementation is a bit tricky.
>>>>>
>>>>> The 1st 3 patches adds io_uring task exit notifier, and the other
>>>>> patches converts ublk into this exit notifier, and the implementation
>>>>> becomes more robust & readable, meantime it becomes easier to relax
>>>>> the ublk queue/daemon limit in future, such as not require to bind
>>>>> ublk queue with single daemon.
>>>>
>>>> The normal approach for this is to ensure that each request is
>>>> cancelable, which we need for other things too (like actual cancel
>>>> support) Why can't we just do the same for ublk?
>>>
>>> I guess you meant IORING_OP_ASYNC_CANCEL, which needs userspace to
>>> submit this command, but here the userspace(ublk server) may be just panic
>>> or killed, and there isn't chance to send IORING_OP_ASYNC_CANCEL.
>>
>> Either that, or cancel done because of task exit.
>>
>>> And driver doesn't have any knowledge if the io_uring ctx or io task
>>> is exiting, so can't complete issued commands, then hang in
>>> io_uring_cancel_generic() when the io task/ctx is exiting.
>>
>> If you hooked into the normal cancel paths, you very much would get
>> notified when the task is exiting. That's how the other cancelations
>> work, eg if a task has pending poll requests and exits, they get
>> canceled and reaped.
> 
> Ok, got the idea, thanks for the point!
> 
> Turns out it is cancelable uring_cmd, and I will try to work towards
> this direction, and has got something in mind about the implementation.

Perfect, thanks Ming!

-- 
Jens Axboe

