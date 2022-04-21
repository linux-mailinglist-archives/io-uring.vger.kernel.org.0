Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A41509BAA
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387251AbiDUJIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 05:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387317AbiDUJHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 05:07:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB412619
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:05:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v15so5615729edb.12
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 02:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=CppwTvtqDVbg6wy8V5hV3QdHbRY5liAvbz/PHLPkRhs=;
        b=VF5UcsH+hjMWlfReNbaNxN0fQCHW/yMA8+bJOs/KHBIhqT2MxbM9WJcvRluJhYbHSh
         f5gjoYm4cQcvZ/vz94InDHev6ZoYg9oK+gxcUEJdQmMfuyqmoWVeCVzjtu3W9F0edsY6
         M7SRcld060wKH/uuAltBBVqmdOF1R3RTx38suGh9lju+3+vysZcQseH8saiOzRg5BYdF
         0KjgRWA3FWX1SXwhTmcZAHoc65EvbXmaWPYnK1Wwpu7tR4bc+BWhlLZt82ImA6WdJy7y
         ZqcRTt+VSwFC1V/skgLcgqVKERr+AQMZjZjpQx1hOkM7ftkC5Oy2vXydkii8Yd5mH+a+
         zdTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=CppwTvtqDVbg6wy8V5hV3QdHbRY5liAvbz/PHLPkRhs=;
        b=5zAex6y48fZZjtQVO1LQld/Xc/V/e9/hUxgHAMy5Etawr2Fccko8GeNlhFTtHXE8lf
         Zfh/4qwoK/3le7gJSQ0CvtczPyHZ0dTCtUWJLFVK8ParR79sJCFYatlSsh/ey/9oy/Hv
         vs+gLe2FigD4gBqqxBf9oFZxoA7BxeMx6TzHavVbZL90LY41fpNKh9KXHzgEeBxxcica
         hfggYjyy+v11S0OrH02O1LMwUXV2RFJUac1bSF0OEVge6bjMXTMjAWoPYFEYdqSLJQI9
         3A5+lbsoLmQr9uaP1nssR4nN3FAV9rvQxko298anxp0if0XmOZIYV3/2zmLf2MTRLqfV
         ZcPw==
X-Gm-Message-State: AOAM532PmW7ooejOqD4Em0Ava8ZGyTqa3iHCr6Oo3aI53Ac5c+Uwy74T
        WDc91tUePFRMZPtBG+YTBym2ILFuMuV/7w==
X-Google-Smtp-Source: ABdhPJw2jkfh/SLZCJKhJ9obSHw5mw+KI813JGkGGbyT3sqY2YWDwL+OqfCA43A7FZj4wDqSssod9Q==
X-Received: by 2002:a05:6402:430b:b0:423:d384:acf7 with SMTP id m11-20020a056402430b00b00423d384acf7mr26292503edc.67.1650531905054;
        Thu, 21 Apr 2022 02:05:05 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id e26-20020a50ec9a000000b00422d1221747sm9198774edr.81.2022.04.21.02.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 02:05:03 -0700 (PDT)
Message-ID: <621a86d5-f002-803f-8293-297e3d4e3a85@scylladb.com>
Date:   Thu, 21 Apr 2022 12:05:02 +0300
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
 <96cdef5a-a818-158d-f109-e96f0038bf14@scylladb.com>
 <686bb243-268d-1749-e376-873077b8f3a3@kernel.dk>
 <1a7f2b1c-1373-7f17-d74a-eb9b546a7ba5@scylladb.com>
 <1c65ed64-b528-5b0d-48d3-a948acb4520b@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <1c65ed64-b528-5b0d-48d3-a948acb4520b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 20/04/2022 15.09, Jens Axboe wrote:
> On 4/20/22 5:55 AM, Avi Kivity wrote:
>> On 19/04/2022 22.58, Jens Axboe wrote:
>>>> I'll try it tomorrow (also the other patch).
>>> Thanks!
>>>
>> With the new kernel, I get
>>
>>
>> io_uring_setup(200, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=256, cq_entries=512, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS|0x1800, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=8512}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=280}}) = 7
>> mmap(NULL, 9536, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 7, 0) = -1 EACCES (Permission denied)
> That looks odd, and not really related at all?
>

It was selinux. So perhaps there is a regression somewhere that breaks 
selinux+io_uring.


The reason I encountered selinux was that I ran it in a virtual machine 
(nvidia + custom kernel = ...). Now the problem is that the results in 
the VM are very inconsistent, perhaps due to incorrect topology exposed 
to the guest. So I can't provide meaningful results from the patches, at 
least until I find a more workable setup.



