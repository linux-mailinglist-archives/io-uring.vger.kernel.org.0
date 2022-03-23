Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D172D4E4AD2
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 03:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiCWCTY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 22:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiCWCTX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 22:19:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD47370076
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 19:17:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bx5so346575pjb.3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 19:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eI61FWNjxNcvotxhTa64BG5fyhSEhuZwOn+ohZrc1yY=;
        b=k/h5WsdCLzhFU8jtxU82HEPtB6IfaSlxfKST3cuVgAwxE7RbWtEC/WRhGlR4qif4+6
         DzCiLrzDzVVK0DtpcO6+wC8OXBhB04beACK7zsWp+5a6ImcpZ9RikSOI4lyXtlILvy0N
         35oclVAPRwg+HB/yYntPrGdIDEmbEg81ihaEE9Wasmlt2u0fiv5uEym3POmJ2tzebH81
         mD9QgeOPCGH4dgN/VHGtfRn+8qReXCBTtNRy/MoZzOOA1yECD/0Vm4OrNCvXjgUc0j7h
         9TBp1tR9XftXsvDTcVOOje80fDDR19xw0IuMs1PTgMyml8qygT+jv7X6b/OGQJ7b+XRq
         0fTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eI61FWNjxNcvotxhTa64BG5fyhSEhuZwOn+ohZrc1yY=;
        b=tWXFuUwwSjo/196mM3WmwmaEGGXwz4WDxuhBs/fF1viWwGfz2+8raGJd3m7SxrTNQl
         JivYfb3i4qZZxduwlVrhllnxpYlfomfEZlVpeD6R4237VHRCOFHYOmqLn17nYW6tOC9N
         3HBTjCVnbz9t0lM83Ceh/691ZJi8B/ibkrlvTRgQQeYhTJak4N1UyfU33ZiyMJMGTupM
         xsNRla8xC9OxB6K5i/vvRhk1VvFznVLgOYv9XNMEpi1gTNf2Qrj8oED9Khi3W6/Alquw
         uHZGJogoXotG9MiMvO7MHXpZVJF6cDWGNXQAd8v41dbBcC8A2VbGVvvNh9QLKq6b/wlK
         2MfQ==
X-Gm-Message-State: AOAM530kj8DNd+8UsCEc/o5q58yUZ9Fy6fSfRKmAZ802DqcePGaGA24/
        OieYs9YvaB5HOpkan2sNlCGcZA==
X-Google-Smtp-Source: ABdhPJxtpgQpvbh5V5/2fg02qSRoT2lKlieuvf0XA4fL90y0FXVYDPKsEYxGzFPH4mzGlClL2NkgQg==
X-Received: by 2002:a17:902:d2ce:b0:154:2e33:5663 with SMTP id n14-20020a170902d2ce00b001542e335663mr19559776plc.141.1648001873157;
        Tue, 22 Mar 2022 19:17:53 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y13-20020a63b50d000000b0038297275c00sm5579534pge.34.2022.03.22.19.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:17:52 -0700 (PDT)
Message-ID: <b223b7bf-0688-5020-ca46-3616f2558aaf@kernel.dk>
Date:   Tue, 22 Mar 2022 20:17:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 10/17] block: wire-up support for plugging
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Kanchan Joshi <joshiiitr@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492@epcas5p4.samsung.com>
 <20220308152105.309618-11-joshi.k@samsung.com>
 <20220310083400.GD26614@lst.de>
 <CA+1E3rJMSc33tkpXUdnftSuxE5yZ8kXpAi+czSNhM74gQgk_Ag@mail.gmail.com>
 <Yi9T9UBIz/Qfciok@T590> <20220321070208.GA5107@test-zns>
 <Yjp3dMxs764WEz6N@T590> <c7ce0850-0286-ec6b-2d68-20226e7bae16@kernel.dk>
 <a1693c16-151e-60f0-ed8d-25e98dce57d4@kernel.dk> <YjqBfpLVhJ3nZMur@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YjqBfpLVhJ3nZMur@T590>
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

On 3/22/22 8:10 PM, Ming Lei wrote:
> On Tue, Mar 22, 2022 at 07:58:25PM -0600, Jens Axboe wrote:
>> On 3/22/22 7:41 PM, Jens Axboe wrote:
>>> On 3/22/22 7:27 PM, Ming Lei wrote:
>>>> On Mon, Mar 21, 2022 at 12:32:08PM +0530, Kanchan Joshi wrote:
>>>>> On Mon, Mar 14, 2022 at 10:40:53PM +0800, Ming Lei wrote:
>>>>>> On Thu, Mar 10, 2022 at 06:10:08PM +0530, Kanchan Joshi wrote:
>>>>>>> On Thu, Mar 10, 2022 at 2:04 PM Christoph Hellwig <hch@lst.de> wrote:
>>>>>>>>
>>>>>>>> On Tue, Mar 08, 2022 at 08:50:58PM +0530, Kanchan Joshi wrote:
>>>>>>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>
>>>>>>>>> Add support to use plugging if it is enabled, else use default path.
>>>>>>>>
>>>>>>>> The subject and this comment don't really explain what is done, and
>>>>>>>> also don't mention at all why it is done.
>>>>>>>
>>>>>>> Missed out, will fix up. But plugging gave a very good hike to IOPS.
>>>>>>
>>>>>> But how does plugging improve IOPS here for passthrough request? Not
>>>>>> see plug->nr_ios is wired to data.nr_tags in blk_mq_alloc_request(),
>>>>>> which is called by nvme_submit_user_cmd().
>>>>>
>>>>> Yes, one tag at a time for each request, but none of the request gets
>>>>> dispatched and instead added to the plug. And when io_uring ends the
>>>>> plug, the whole batch gets dispatched via ->queue_rqs (otherwise it used
>>>>> to be via ->queue_rq, one request at a time).
>>>>>
>>>>> Only .plug impact looks like this on passthru-randread:
>>>>>
>>>>> KIOPS(depth_batch)  1_1    8_2    64_16    128_32
>>>>> Without plug        159    496     784      785
>>>>> With plug           159    525     991     1044
>>>>>
>>>>> Hope it does clarify.
>>>>
>>>> OK, thanks for your confirmation, then the improvement should be from
>>>> batch submission only.
>>>>
>>>> If cached request is enabled, I guess the number could be better.
>>>
>>> Yes, my original test patch pre-dates being able to set a submit count,
>>> it would definitely help improve this case too. The current win is
>>> indeed just from being able to use ->queue_rqs() rather than single
>>> submit.
>>
>> Actually that is already there through io_uring, nothing extra is
>> needed.
> 
> I meant in this patchset that plug->nr_ios isn't wired to data.nr_tags in
> blk_mq_alloc_request(), which is called by pt request allocation, so
> looks cached request isn't enabled for pt commands?

My point is that it is, since submission is through io_uring which does
exactly that.

-- 
Jens Axboe

