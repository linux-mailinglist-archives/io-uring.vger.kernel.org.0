Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EB87A4F8F
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjIRQqF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 12:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjIRQpr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 12:45:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D25E3A9A
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 08:59:45 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6905cccb9ceso1039547b3a.1
        for <io-uring@vger.kernel.org>; Mon, 18 Sep 2023 08:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695052534; x=1695657334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SvOcpVdAsc2Q4sYYr3R8yxC4JPBSNRq7YUUT3oDYb4=;
        b=mLkL3T3NW9tNUXenw/npRJl1nJqo9m8G7YdcZ/oAeRZcHdoQiPiQWgFw+TOuOlMaom
         v1dKQLK80o597AsnMg8+ECzVsAd3XM7Cxu/+AhU+swR6tgpUWcwz0zmQvpPA5qEuEt3N
         nqMHOLECGk+p/oymyin7nYIhRsDMgrF7OvvnzByeBjvTbJiSLutud967vYxdR9cWl2wS
         j8kW2OSyCjgCw+UywqlID5TUGQOeGELssONzG0z8E3DarSn6LrDNdodayhXhN3sVOlhU
         Ezqgf/VSZXA5SzZolvVV1gG6xZuJDapQc9YO3IWPo5iAkboW4VoP7oXDxEuF5quxM2f1
         fuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052534; x=1695657334;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SvOcpVdAsc2Q4sYYr3R8yxC4JPBSNRq7YUUT3oDYb4=;
        b=M/agbn7CiTFGvLViptKlm8Z1draAjuJk1pCKERFkZ4DCsJ59Axyb3gphuPfNBKxTQo
         hRAmPMK2xw0D1URmZO1F8sekwmjPuHLJ08l6aNlr+dR6TOmdW0UvrdEke4CSN+b7EYIT
         zHx7OQxF5XROMh6G01vUmIx2qy04J0r20CmPYFLIndiVldH9MIkSaEorr4WE5H/r7yGp
         mmjsvY8hz7tvfNZe2hrb+E/1Lp7DMcri1FKQ4RIXagJln7VLB+7G7vMZFASQW2pQSc6F
         IwItG91L1ZBuVQaHePGHUR9dnoeFKGqZNOZfXiAZFTbzoV3TMkimEvp++t1R+/Eoq7V/
         iedA==
X-Gm-Message-State: AOJu0YxPJrrgLFjJe1CanAqd4TE0Bs0kjIwoefwGyJlQZ9RGkqroyeKx
        W0ITSKKvrwoNOQrqIAFiPytzGaUvxZ+HGbQiF3en9g==
X-Google-Smtp-Source: AGHT+IEeNsH5iLqdPZDOtg64eKzIqKRtriPRwLcj0JBMtkee1d9rhsNJN57PvcJUKCLWuGM33pvJcw==
X-Received: by 2002:a05:6602:1681:b0:792:6068:dcc8 with SMTP id s1-20020a056602168100b007926068dcc8mr12834859iow.2.1695046509302;
        Mon, 18 Sep 2023 07:15:09 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s21-20020a02ad15000000b0042b3bb542aesm2831645jan.168.2023.09.18.07.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 07:15:08 -0700 (PDT)
Message-ID: <5706fa76-a071-4081-8bb0-b1089e86a77f@kernel.dk>
Date:   Mon, 18 Sep 2023 08:15:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] io_uring/ublk: exit notifier support
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20230918041106.2134250-1-ming.lei@redhat.com>
 <fae0bbc9-efdd-4b56-a5c8-53428facbe5b@kernel.dk> <ZQhPhFwgSLvR/zDM@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZQhPhFwgSLvR/zDM@fedora>
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

On 9/18/23 7:24 AM, Ming Lei wrote:
> On Mon, Sep 18, 2023 at 06:54:33AM -0600, Jens Axboe wrote:
>> On 9/17/23 10:10 PM, Ming Lei wrote:
>>> Hello,
>>>
>>> In do_exit(), io_uring needs to wait pending requests.
>>>
>>> ublk is one uring_cmd driver, and its usage is a bit special by submitting
>>> command for waiting incoming block IO request in advance, so if there
>>> isn't any IO request coming, the command can't be completed. So far ublk
>>> driver has to bind its queue with one ublk daemon server, meantime
>>> starts one monitor work to check if this daemon is live periodically.
>>> This way requires ublk queue to be bound one single daemon pthread, and
>>> not flexible, meantime the monitor work is run in 3rd context, and the
>>> implementation is a bit tricky.
>>>
>>> The 1st 3 patches adds io_uring task exit notifier, and the other
>>> patches converts ublk into this exit notifier, and the implementation
>>> becomes more robust & readable, meantime it becomes easier to relax
>>> the ublk queue/daemon limit in future, such as not require to bind
>>> ublk queue with single daemon.
>>
>> The normal approach for this is to ensure that each request is
>> cancelable, which we need for other things too (like actual cancel
>> support) Why can't we just do the same for ublk?
> 
> I guess you meant IORING_OP_ASYNC_CANCEL, which needs userspace to
> submit this command, but here the userspace(ublk server) may be just panic
> or killed, and there isn't chance to send IORING_OP_ASYNC_CANCEL.

Either that, or cancel done because of task exit.

> And driver doesn't have any knowledge if the io_uring ctx or io task
> is exiting, so can't complete issued commands, then hang in
> io_uring_cancel_generic() when the io task/ctx is exiting.

If you hooked into the normal cancel paths, you very much would get
notified when the task is exiting. That's how the other cancelations
work, eg if a task has pending poll requests and exits, they get
canceled and reaped.

-- 
Jens Axboe

