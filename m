Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044745970E9
	for <lists+io-uring@lfdr.de>; Wed, 17 Aug 2022 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiHQOWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Aug 2022 10:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiHQOWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Aug 2022 10:22:34 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EBF8F976
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 07:22:33 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n12so7381993iod.3
        for <io-uring@vger.kernel.org>; Wed, 17 Aug 2022 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Me5Eblpo77OL8yVoImUGgcZR3F3DnEB+a6/Z40BtEUw=;
        b=h2zL1ufdtgJJFFU+85KTEoC4O6YSNXK2JjaJPFWG36R7ur2vGdkcOVcYxNWZXJhUmz
         MdICl+1GPugAWr/Oi42oFCG7TN3IMujkNRDCNEKiBSEnEB/xbwWM6HAJUHCKFsdqtU08
         kQFHHK+7GYYAwWSTo4gRNLdJGVr0WJtoDLP/quB08ODjfQGsB5B6+QRiOteonJXRpk8u
         cxtDinQBhgntFAkMz0CmELxo/Nvd6rknf9Lbh7yH5aXf4OcecbHY/k6VTL8OfvVAfHot
         GxWX5yCxgJjEx7zuMdKJSjf4Tsb/ne3/pnEAsXVdyiNxg/M3XCH9DcGVjROOLd+eMRck
         Tk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Me5Eblpo77OL8yVoImUGgcZR3F3DnEB+a6/Z40BtEUw=;
        b=rrfrOmH87ftaNElHwlSArUPIXMcXUxPbfEinG9g9FLYO3ttqjoIgUmv71NGvk8yuO1
         duDTkcq3jjh5SVu8cOhcWs/PKVRa2ec6C3E4K0ht7mSQyDtseWgQaogh317QGsyxKi09
         4IrdCpGQmwekPipLeG33JEuXwXTDgnhTtzT9paeB5ga7bHKw7RDDNM0RQU8iRhnlbYii
         d1gtHW5JqrGEEvBmsYjIDIYjLOwvL4wLc5DLPxXxpvjAHLi6ljnG9YF7W7PsyTcsUpqZ
         109sdqSwflESSqwnnS694Pjqbbd+aIUNgCqCAbJ6EbVoDQjqwlqM9SlM1Z//HTtB0SFj
         nJFw==
X-Gm-Message-State: ACgBeo3AV5eVZqIF4cTf67hCg93ZujSUywC1l+OK7Oe3137la9zpU/a6
        KxHm/t2eLJaV3f0R7ABwtJ5kog==
X-Google-Smtp-Source: AA6agR7HQdtIfxPCr3oiJs2lcxa3+I+ci/q1ohQUdF0E5/wMxrEqfrF8MtdZR4Wj8edFWr6lWGHbLA==
X-Received: by 2002:a05:6602:3cc:b0:678:eb57:5eb with SMTP id g12-20020a05660203cc00b00678eb5705ebmr10575715iov.125.1660746152190;
        Wed, 17 Aug 2022 07:22:32 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003429446e53dsm5645789jad.43.2022.08.17.07.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 07:22:31 -0700 (PDT)
Message-ID: <408038f9-654c-611a-2c48-c1b5d660a6a7@kernel.dk>
Date:   Wed, 17 Aug 2022 08:22:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: KASAN: null-ptr-deref Write in io_file_get_normal
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiacheng Xu <578001344xu@gmail.com>, linux-kernel@vger.kernel.org,
        asml.silence@gmail.co, io-uring@vger.kernel.org,
        security@kernel.org
References: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
 <YvvD+wB64nBSpM3M@kroah.com> <5bf54200-5b12-33b0-8bf3-0d1c6718cfba@kernel.dk>
 <YvyPe7cKY2sLzbJt@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YvyPe7cKY2sLzbJt@kroah.com>
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

On 8/17/22 12:49 AM, Greg KH wrote:
> On Tue, Aug 16, 2022 at 10:57:39AM -0600, Jens Axboe wrote:
>> On 8/16/22 10:21 AM, Greg KH wrote:
>>> On Wed, Aug 17, 2022 at 12:10:09AM +0800, Jiacheng Xu wrote:
>>>> Hello,
>>>>
>>>> When using modified Syzkaller to fuzz the Linux kernel-5.15.58, the
>>>> following crash was triggered.
>>>
>>> As you sent this to public lists, there's no need to also cc:
>>> security@k.o as there's nothing we can do about this.
>>
>> Indeed...
>>
>>> Also, random syzbot submissions are best sent with a fix for them,
>>> otherwise it might be a while before they will be looked at.
>>
>> Greg, can you cherrypick:
>>
>> commit 386e4fb6962b9f248a80f8870aea0870ca603e89
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Thu Jun 23 11:06:43 2022 -0600
>>
>>     io_uring: use original request task for inflight tracking
>>
>> into 5.15-stable? It should pick cleanly and also fix this issue.
>>
>> -- 
>> Jens Axboe
>>
>>
> 
> Thanks, will do after this next round of releases go out.

Thanks Greg.

-- 
Jens Axboe


