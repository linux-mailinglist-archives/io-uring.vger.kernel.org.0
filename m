Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B715753E1A
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 16:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbjGNOwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 10:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbjGNOwn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 10:52:43 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C3C1BD4
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 07:52:42 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-77dcff76e35so21530139f.1
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 07:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689346362; x=1691938362;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JAmunczEJZFXmZmHXM1b+lVlqoJeo+37Wzbf/I2rzuk=;
        b=SEXK0AEWpeZ+PSHHyWI4issvXXGelXWSsFqVGgJFtbl590xsUVQLTSG94AA2elEUEJ
         YVLEHKIdOrgh5aqhkpxiddvzDKY7dsW1UVZrudb1DvejpaKdvXDDVRTx6j0zxZ/8/JJ5
         iEtKeOMR9jSG9y+x4kVWbZiPXd1GB6P7Y58+pMnvN3oIykfGU97JUNG2WA3poicjKtt6
         lLCnWPleldaLOvVX00IlU1ro0LPYJeEQbUdwHuYrlAhjMPlpaHVj0nUIh93Tmiv8FET6
         +TFuphVYLgEvbYh4Vm9750UMBXoCx0YAe/1yhJH5liGr6qwEr1g0KC8oo/C/vTVK+rzW
         az+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689346362; x=1691938362;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JAmunczEJZFXmZmHXM1b+lVlqoJeo+37Wzbf/I2rzuk=;
        b=llXJg0rWrdvKinl4Ts3KeYWPi8tt6qXQcw3xGw7Z/63WDOUlWY8JBFInSBNapy2tPb
         RfDyHBEVnAuFcjWQIDUQPAtr28gbH66PmbJG3hoh8KZdM5H48+dMNeVqL2aSaSpwjD2L
         2BTZ3DsXZK+4EyQTrHJNA7vD1d0f8CG5xnKAsHCi9+qaApjqenEEy5H1LsXIEZaUWHip
         8yDjgt5SynWLQIJREgfCBRZ+fjcxb15o5OgGi8ir2mpd8ZF05sDQd7P83l0AQXxMl8sz
         UCuYeWKQSZAES2XP0OM5w3VV73LQzhujdszRL4GH5NaBHNHJF92egW5+dSIz8V/vSjbP
         WwAw==
X-Gm-Message-State: ABy/qLYvpNCEOGNKcJKq6kdDaP26vxctcjGVVpJliwHAcc1MLRdm7EAS
        Gp4BEwsO6ew0cwDJKlCXkVjgrokjq4yFJa6iOTw=
X-Google-Smtp-Source: APBJJlEWtOeftyE9WaGt/sW0C8jvzHGspQW6CwjILQtd6tjwhjPIhbAftPrYIZ9aSMDxtKsfJApJTQ==
X-Received: by 2002:a05:6602:360e:b0:783:63e8:3bfc with SMTP id bc14-20020a056602360e00b0078363e83bfcmr4727005iob.0.1689346361873;
        Fri, 14 Jul 2023 07:52:41 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ep9-20020a0566384e0900b0042b326ed1ebsm2657638jab.48.2023.07.14.07.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 07:52:41 -0700 (PDT)
Message-ID: <bcf174d8-607b-e61a-2091-eccd3ffe0dfe@kernel.dk>
Date:   Fri, 14 Jul 2023 08:52:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
 <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
 <20230713172455.GA3191007@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230713172455.GA3191007@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/23 11:24?AM, Peter Zijlstra wrote:
> On Thu, Jul 13, 2023 at 01:15:13PM +0200, Peter Zijlstra wrote:
>> On Wed, Jul 12, 2023 at 10:20:13AM -0600, Jens Axboe wrote:
>>
>>> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>> +{
>>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>>> +
>>> +	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
>>> +		return -EINVAL;
>>> +
>>> +	iof->futex_op = READ_ONCE(sqe->fd);
>>> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>> +	iof->futex_val = READ_ONCE(sqe->len);
>>> +	iof->futex_mask = READ_ONCE(sqe->file_index);
>>> +	iof->futex_flags = READ_ONCE(sqe->futex_flags);
>>> +	if (iof->futex_flags & FUTEX_CMD_MASK)
>>> +		return -EINVAL;
>>> +
>>> +	return 0;
>>> +}
>>
>> I'm a little confused on the purpose of iof->futex_op, it doesn't appear
>> to be used. Instead iof->futex_flags is used as the ~FUTEX_CMD_MASK part
>> of ops.
>>
>> The latter actually makes sense since you encode the actual op in the
>> IOURING_OP_ space.
> 
> Futex is slowly getting back to me; I'm thinking these io_uring
> interfaces should perhaps use the futex2 flags instead of the futex_op
> encoded muck.
> 
> I'll try and send out a few patches tomorrow to clarify things a little
> -- the futex2 work seems to have stalled somewhere halfway :/

Saw your series - I'll take a look. In terms of staging when we get
there, would it be possible to split your flags series into the bare
minimum and trivial, and then have that as a dependency for this series
and the rest of your series?

-- 
Jens Axboe

