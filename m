Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF020507A6B
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbiDSTog (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 15:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243888AbiDSTog (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 15:44:36 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7004132A
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 12:41:52 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u15so34986047ejf.11
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 12:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=AOKbpuzuN4YfWtxm5SoN7az+ElLl8kaH5cP/nxclVTs=;
        b=Qmy/1gf8tZtcQ7jUo65nQcKbPcMd7CvRse1vAJe9qlShwE8W5mbW7b140dIxBDjoYS
         HLiGdC4L9tASwyAouzUPysaurNifne0xBYxO4ly5QyO12uPjccC8bwAA3+k/ZWRsFySk
         QRgbziJUPnY+PtWLjQIC9YamgOp585juOMECBHUFCp53VRjwPlWM+PCvIZ4L92zfXIfl
         u0TAAowdmeCGxU3hPCrpydl9hKWwlzVR7oehs95kOe5nseQ6VlBtvtl6sp2yCzsvy7sV
         BKHRhwOKQMdubigdNVt6Ns9Xh7m62hKuy+cZRuEiYfu1Nqax2i1i0+xJyQVEufdWW8Gz
         Il+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=AOKbpuzuN4YfWtxm5SoN7az+ElLl8kaH5cP/nxclVTs=;
        b=ygu8ekNcaOz+UXURvy++y4m5/kF1JD1aYSV0pS27FhHCYc0ARtTjQBmf2CWcPRRgVs
         pZ6Sem7Wz27QohARFfLQDNM4rgImTv5rsYWuslfZAalqJNfFAKWVdGmApduyg7yuZJAq
         P71EjzSPj037j6MbtRJisnHL6x1JPYjwaVgu2LLPpb86QlTNor/2HXYs5Tdp4FG0X2wO
         Eui0iQmX2aynYlyYsGP4A95IV6WwiyAoIQPmPoE7Ys8j7p7gpX0VSkIrf2xUj5Hb3CTZ
         fPuRDPXsMd422YFixHc4gMCidBP+8eBxUQr5Phwawzz+sIc5ml4CuU2H4HwEzn3ukAsR
         FgDg==
X-Gm-Message-State: AOAM533revOHY4jH9eBvoDmPXm5R4E/8eGihO0LvvFNNwZhmXUrbyA78
        6d6UCCKg6Fnb4fwoVZEpD0bebQ==
X-Google-Smtp-Source: ABdhPJxgP4T6g1owzTghaEN83SsrY28mLwYKM9Y4e0Si6awlvDMX+j2aZSI9Lf1BhFXnaNOj0YcHdQ==
X-Received: by 2002:a17:906:469a:b0:6e8:76c2:1d58 with SMTP id a26-20020a170906469a00b006e876c21d58mr14738695ejr.371.1650397311274;
        Tue, 19 Apr 2022 12:41:51 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b006a767d52373sm5935869ejb.182.2022.04.19.12.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 12:41:50 -0700 (PDT)
Message-ID: <96cdef5a-a818-158d-f109-e96f0038bf14@scylladb.com>
Date:   Tue, 19 Apr 2022 22:41:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 19/04/2022 20.14, Jens Axboe wrote:
> On 4/19/22 9:21 AM, Jens Axboe wrote:
>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>
>>>>>>>>
>>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>>> inline completion vs workqueue completion:
>>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>>> completions.
>>>>>> I measured this:
>>>>>>
>>>>>>
>>>>>>
>>>>>>    Performance counter stats for 'system wide':
>>>>>>
>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>
>>>>>>         12.288597765 seconds time elapsed
>>>>>>
>>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>>> counter.
>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>> expected.
>> Might actually be implicated. Not because it's a async worker, but
>> because I think we might be losing some affinity in this case. Looking
>> at traces, we're definitely bouncing between the poll completion side
>> and then execution the completion.
>>
>> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
>> me know what base you prefer, I can do a version against that. I see
>> about a 3% win with io_uring with this, and was slower before against
>> linux-aio as you saw as well.
> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
> believe may be the underlying cause of it.
>

Won't it delay notification until the next io_uring_enter? Or does 
io_uring only guarantee completions when you call it (and earlier 
completions are best-effort?)


For Seastar it's not a problem, asking about the general io_uring 
completion philosophy.


I'll try it tomorrow (also the other patch).



