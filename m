Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADFB54C727
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiFOLHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343608AbiFOLHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:07:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DBA2BE0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:07:39 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so22446353ejj.10
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=mRWDOcP+mU1M0wCj+HTSy5pvbyQPOfmkCaO9rI+KLQc=;
        b=DDmIpUI2OmF5PxvsSNXNX3oTEiNRwQzyw1CfhONbBy4ywoSq0YysFEDWy9B1HR18ys
         CMXVRoURcpUdEZM45VMqygXxFb7K/iUcXcyO9okFvaA9nFenEVZI3Qsm+Vz8+2HnGj4/
         nDW5QkXpzuNBhIlDsLZRDoh8ePWDIC3AHK0YEZ09nmbNEisOZnUYpAuuRdhsY3gIMJRc
         +A85PyV0aPoTgctLSLqFZMCjYhy3O/Ssj4VwVAdjHaA274a1S89NEntiQpMu2q6Wnddy
         CXyxyUagWt+vpDG/Sk5RlR1YNs1DjJzGHJ6UYC5JsDMt9eWbYGRe8hY9nuf2c0JyI8As
         kZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=mRWDOcP+mU1M0wCj+HTSy5pvbyQPOfmkCaO9rI+KLQc=;
        b=7mOALJEd9p83Uwstzr7MnTC7TQC/CcDa3NAGiHFhidoEY6tHC40p/tNdxYYVd4s0Ju
         2b64f4Cy7FyREeGBWkw14s986rue9yPGqtA0G02cGmv7zRWrOn9TSrvBpKO2qr4D2Nzn
         HhJVatqEJMbXx13OkN337QRyXfUBe6HKFwCkWB8MluGGCUK7A7j/0puEoQp7u7Za/9N+
         aO49LuTHtd2bciF3jE77AQTg9PP7pCTYmYOnoFE/7ltnBGoVqZ9YS2tfvrF+RsaDMwV0
         4JanHpIcZxuShXtL7v/siSNO8X8aJKSTmdaC5crV5CgC0xYoNizaI6wKqdDAXOQsPI/T
         MZvQ==
X-Gm-Message-State: AJIora9/PxXBIwCVwP1zcNFbZCBaXmwYFGpHmuSujEk+upE50Td+swTf
        J2QtI1xYXbjB/YqHevIuFuLTNSYwaA0fEI0m
X-Google-Smtp-Source: AGRyM1v0ieQ6zfbp4He1LaKH/tiV4UjddnvqVlj/4+y2TkxMZybXdvRSDsCzReP8x8x7ECfXJEQ4aQ==
X-Received: by 2002:a17:906:778c:b0:712:134c:dd9a with SMTP id s12-20020a170906778c00b00712134cdd9amr8160666ejm.474.1655291258012;
        Wed, 15 Jun 2022 04:07:38 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id da26-20020a056402177a00b004315050d7dfsm9072094edb.81.2022.06.15.04.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:07:37 -0700 (PDT)
Message-ID: <85b5d99e-69b4-15cf-dfd8-a3ea8c120e02@scylladb.com>
Date:   Wed, 15 Jun 2022 14:07:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
From:   Avi Kivity <avi@scylladb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <1d79b0e6-ee65-6eab-df64-3987a7f7f4e7@scylladb.com>
 <95bfb0d1-224b-7498-952a-ea2464b353d9@gmail.com>
 <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry, hit send too quiclky.


>
>>
>>> If this is correct (it's not unreasonable, but should be 
>>> documented), then there should also be a simple way to force a 
>>> kernel entry. But how to do this using liburing? IIUC if I the 
>>> following apply:
>>>
>>>
>>>   1. I have no pending sqes
>>>
>>>   2. There are pending completions
>>>
>>>   3. There is a completed event for which a completion has not been 
>>> appended to the completion queue ring
>>>
>>>
>>> Then io_uring_wait_cqe() will elide io_uring_enter() and the 
>>> completed-but-not-reported event will be delayed.
>>
>> One way is to process all CQEs and then it'll try to enter the
>> kernel and do the job.


But I don't want it to wait. I want it to generate pending completions, 
and return immediately even if no completions were generated. I have 
some background computations I'm happy to perform if no events are 
pending, but I would like those events to be generated promptly.


>>
>> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
>> there is work that requires to enter the kernel io_uring will
>> set IORING_SQ_TASKRUN in sq_flags.
>> Actually, I'm not mistaken io_uring has some automagic handling
>> of it internally
>>
>> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>>

Is there documentation about this flag?


>>
>>
