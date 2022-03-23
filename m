Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673B64E4A98
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 02:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbiCWBnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 21:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiCWBnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 21:43:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C876FF58
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 18:41:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q1-20020a17090a4f8100b001c6575ae105so3045441pjh.0
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 18:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8LWS8Tu499Dz/WYM5ibp7anTuYd4mn6MZuCdOuBE178=;
        b=u9tJ+j3d5YI5UgkOXDz2XUOElZhozk7XiIImUcObs2/Az2WbY+KAayscuv/jhpR0lW
         /KyzGwNTrBI+9G26XDRspZxZ+TYgY2VlkaNV9hh5bk4E4s4A+bey9jYPZnvPmDguhftd
         SuKuWOF5uGvH9HXJsoSLP1bN9Dr0+OtlzKpP9yx2iMvyT4xdSMG83IzkGgta9xeRqyt+
         jxh67C/URFXKOoKfYkAGPc0UuPctb1Tg2tL61c6V4PqnEuRgMLxxDhQ3Igq+43QRLE3D
         pjpuYqK8hcDHFpPl5ixI+QERnYJLOcFJ0kl87pHI4awZx3wqN4f5uXY2g/tPwVOkSa46
         Mm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8LWS8Tu499Dz/WYM5ibp7anTuYd4mn6MZuCdOuBE178=;
        b=A4cmbTE8dCJIG9HyF9wTWXJ+tkF25SLWTZ73VVNb9MalkhNrw7XsCDR2m5VuP67wbf
         NKPkPOoyMuNISZZ7a315VLcKEe59cYQ1K7KXXGsogZJD5NqSw4hxJsS2OCdpVN6YNSod
         Uqr0sLv3LPsUHdD7N6mPfLqcZBTTGHCPMCMw6E3GCxG2UKVQm2JIWm3wrjZqhecigFd+
         nv5KRVjDnB/MzRa5KR+TrrV2DN7Q6KIBnfLzJ2yKKfjzXTfAcWJ55uXMQWfawiPAvRE8
         vB/68d9PRWDJ8ZEFhTAaFaXOcED/3mJz1sMCIISVrZg2X+QvaKFl4Mkj+/4Vcik6ObDw
         ouyg==
X-Gm-Message-State: AOAM532aUF0KqnNISfwFOiLRtxEO+DEETb0tqoIhZb+xjgxTAJwSI+Q7
        jMF3W1Abm5LSyBVhv5rCBbcitg==
X-Google-Smtp-Source: ABdhPJxSRgW3m5jc7fEsNBHY6ceeLuGkLIYrOQuznfb7ISQCvU9m/1ZRig2qgrKGxL/KbKf6/RShzQ==
X-Received: by 2002:a17:90a:d50a:b0:1c6:aade:e4b3 with SMTP id t10-20020a17090ad50a00b001c6aadee4b3mr8657340pju.69.1647999699606;
        Tue, 22 Mar 2022 18:41:39 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w9-20020aa78589000000b004f78b5a4499sm22510061pfn.206.2022.03.22.18.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 18:41:39 -0700 (PDT)
Message-ID: <c7ce0850-0286-ec6b-2d68-20226e7bae16@kernel.dk>
Date:   Tue, 22 Mar 2022 19:41:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 10/17] block: wire-up support for plugging
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
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
 <Yjp3dMxs764WEz6N@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yjp3dMxs764WEz6N@T590>
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

On 3/22/22 7:27 PM, Ming Lei wrote:
> On Mon, Mar 21, 2022 at 12:32:08PM +0530, Kanchan Joshi wrote:
>> On Mon, Mar 14, 2022 at 10:40:53PM +0800, Ming Lei wrote:
>>> On Thu, Mar 10, 2022 at 06:10:08PM +0530, Kanchan Joshi wrote:
>>>> On Thu, Mar 10, 2022 at 2:04 PM Christoph Hellwig <hch@lst.de> wrote:
>>>>>
>>>>> On Tue, Mar 08, 2022 at 08:50:58PM +0530, Kanchan Joshi wrote:
>>>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>> Add support to use plugging if it is enabled, else use default path.
>>>>>
>>>>> The subject and this comment don't really explain what is done, and
>>>>> also don't mention at all why it is done.
>>>>
>>>> Missed out, will fix up. But plugging gave a very good hike to IOPS.
>>>
>>> But how does plugging improve IOPS here for passthrough request? Not
>>> see plug->nr_ios is wired to data.nr_tags in blk_mq_alloc_request(),
>>> which is called by nvme_submit_user_cmd().
>>
>> Yes, one tag at a time for each request, but none of the request gets
>> dispatched and instead added to the plug. And when io_uring ends the
>> plug, the whole batch gets dispatched via ->queue_rqs (otherwise it used
>> to be via ->queue_rq, one request at a time).
>>
>> Only .plug impact looks like this on passthru-randread:
>>
>> KIOPS(depth_batch)  1_1    8_2    64_16    128_32
>> Without plug        159    496     784      785
>> With plug           159    525     991     1044
>>
>> Hope it does clarify.
> 
> OK, thanks for your confirmation, then the improvement should be from
> batch submission only.
> 
> If cached request is enabled, I guess the number could be better.

Yes, my original test patch pre-dates being able to set a submit count,
it would definitely help improve this case too. The current win is
indeed just from being able to use ->queue_rqs() rather than single
submit.

-- 
Jens Axboe

