Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7F44DDC58
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 16:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbiCRPDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 11:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiCRPDl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 11:03:41 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC51D78BF
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:02:22 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r7so5004730wmq.2
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=gGq/nKPdmtv2ZG0iPW1Xpo7Gmvkuu1Z1Jrcb2+k23Fo=;
        b=B130cqAk5s9UwNNKR/QAE2dca9T5nmT5LUAbPGozq7OcnCSwT00LzRWxUaV72xy+M3
         Q2TSgOAhIDNvU3DkJ6zsvRS1SxkM3/TlnJlI62eWR7pkk6J7PiMDVzs213yYJ3YN5crd
         trcgTj771M7cAS7YjX+xJX1V3qBlmepVrZxFURw7bOX4L0fyY/GYcAkqm3mC7QRM06X5
         bpZsofUBn2YtvKA8vEA1GP026pHQ/JQGrJ5/Znv31Ky/1KWcc0y31rgRsjmrrwWiG/PQ
         skcVWIiM7JfzTxK+OSb5+Sd7JjjqMz8L9v/Mq4VNbvrYvkqRjvPwhGPnZWN3a/EOqeri
         dlww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gGq/nKPdmtv2ZG0iPW1Xpo7Gmvkuu1Z1Jrcb2+k23Fo=;
        b=Hs0z95U18V1aLD+uWpD8UqwFqxFCEdvEqI8xVg3NgHRJtqyexKPxewrlF6zdJ6LijR
         buXHcaiGvQAQ3Fo7RDil9vtHw/kyTDZxN03Mqfowtp8qXDiDImNyrnEClDHz3JiSeXL2
         DizkSt9IRyxcSC5vQSGy8GZTXzx0pJ8TIOBOwqHCDwYsUn3/LDPSs6bE5xtucCLqopzJ
         ZQbY4u0I69FfNqMFrq6pVnjJKQiHiuI+QNjs+17ejTwV4Dp+4QqXaYGg/HNMSI/gbcLL
         inPz6ViQyPsaEcQgfLZdwNwsfL8R2INGgHpcFrP7wgjvhAq/3wcQilg3oPinknh+crrS
         ws7w==
X-Gm-Message-State: AOAM532TkvK7LoMyMEejWV/01iAbbg75pJCBJxJN85S5fI6SKdTgDIfN
        M8fv3CSjy7T99KaDl2NbOoLuJekM7kjOkg==
X-Google-Smtp-Source: ABdhPJzuw9IJxEkEOzCpaBFeAzwtE/FoSnK272hNktfbCOJSYjjbrGyqgEzjXR6y5XdRkCju0jP5Dg==
X-Received: by 2002:a7b:c30a:0:b0:389:9e1e:a15f with SMTP id k10-20020a7bc30a000000b003899e1ea15fmr8356526wmj.28.1647615741347;
        Fri, 18 Mar 2022 08:02:21 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id t187-20020a1c46c4000000b0038c043567d3sm6951931wma.1.2022.03.18.08.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:02:21 -0700 (PDT)
Message-ID: <458031c4-2eca-7a9e-ab9f-183a2497af48@gmail.com>
Date:   Fri, 18 Mar 2022 15:00:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC 0/4] completion locking optimisation feature
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
 <23c1e47b-45e5-242f-a563-d257a7de88ed@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <23c1e47b-45e5-242f-a563-d257a7de88ed@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 14:52, Jens Axboe wrote:
> On 3/18/22 8:42 AM, Pavel Begunkov wrote:
>> On 3/18/22 13:52, Pavel Begunkov wrote:
>>> A WIP feature optimising out CQEs posting spinlocking for some use cases.
>>> For a more detailed description see 4/4.
>>>
>>> Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
>>> QD=1, and ~+2.5% for QD=4.
>>
>> Non-io_uring overhead (syscalls + userspace) takes ~60% of all execution
>> time, so the percentage should quite depend on the CPU and the kernel config.
>> Likely to be more than 4% for a faster setup.
>>
>> fwiw, was also usingIORING_ENTER_REGISTERED_RING, if it's not yet included
>> in the upstream version of the tool.
> 
> But that seems to be exclusive of using PRIVATE_CQ?

No, it's not. Let me ask to clarify the description and so, why do you
think it is exclusive?


>> Also, want to play after to see if we can also avoid taking uring_lock.
> 
> That would certainly also be interesting!

-- 
Pavel Begunkov
