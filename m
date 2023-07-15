Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AC7549ED
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 17:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjGOPxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jul 2023 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGOPxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jul 2023 11:53:42 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2C132
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 08:53:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-682ae5d4184so745377b3a.1
        for <io-uring@vger.kernel.org>; Sat, 15 Jul 2023 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689436421; x=1692028421;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WPCqo8iewzUqL/ddGBe6+S6dEkLOVcWxfp8omyzuiNY=;
        b=u+nU7oQ5lJVB+Ey7umlrrXLrE1jwY61Xszj01R2QmutYFupx4M88Vopb6w60v9tWpI
         +T1QV4WV97zQLpZWcNJlWOUvogmqLL9Hrjrq6QQgAnKa8HEvhzWRf7qLOSwBEvO5U8dN
         wJ8x0lbjdiF4v8CISSKsBB40FsUV7/1gvsFzz4vzzl8fHeTYApqZe/zoSx2OVO3kDcw5
         wxGz0rDPMzDc5E3abhCPAaTtmuQPCoHDAjbIlBgeT/TJO1zi2h/spCTlpCDxeKOtov9R
         EtmXUgPNEQgjBlylLcdX5IQw4zrxZFbM3kP5jALD2El9wuzaJTsx3q/QhQQP25pC5DIr
         O5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689436421; x=1692028421;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPCqo8iewzUqL/ddGBe6+S6dEkLOVcWxfp8omyzuiNY=;
        b=VPWbmDg04l90KVwRlUVX0bVxGtObMAk4YjzS9/cgaZ2uQQWxBq78B6OAsLfdXkyTvn
         dK7kkIyMzua3FUidtmUrF8iKKSeAzWCA8IHRQkOeajbgmDD85NC+dsx9zw+KJAFpD+Aa
         CpJtULKuVMPzBUst4j8DTPQMlSWj90I4wGSjh3wn1aORJ7GBR72dPeB8WVh1RmCIIMMr
         sXWTe41rLFbvZUC45qyB5hY8p54z0Y5TuN+EHxMBcSeLYFx0Ycccy7Negkys+tV+Fo0w
         kzbdWUpRY0bBSDkOjKDyU/xUtYb9+9N5QLDu/8355gMHCbPeexnFsr3AoxoTzy6kC9og
         ojJg==
X-Gm-Message-State: ABy/qLYvakHQUIkZwxWpHao9dOsreeXJjJTInC3zGWfo8SEW+j8Gop3o
        Ogkfm6U6nRapd2cOpq+3NXMLDorMsBxd3xg+rcU=
X-Google-Smtp-Source: APBJJlF/0Q0FFEZJNVbXQiZafxYFoIv08/+gIiFr61/1fYynlv4KBhL/IqrdijmCFcNHmjQZppBGQw==
X-Received: by 2002:a05:6a21:998b:b0:133:6e3d:68cd with SMTP id ve11-20020a056a21998b00b001336e3d68cdmr3250512pzb.3.1689436421220;
        Sat, 15 Jul 2023 08:53:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f13-20020a63380d000000b0052858b41008sm9448094pga.87.2023.07.15.08.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jul 2023 08:53:40 -0700 (PDT)
Message-ID: <f2161437-fad3-a50b-4f64-340a81e0d865@kernel.dk>
Date:   Sat, 15 Jul 2023 09:53:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Allow IORING_OP_ASYNC_CANCEL to cancel requests on other rings
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <62f84473-f398-fb00-84c0-711c59bd9961@gmail.com>
 <225f5595-bd8a-aeb9-049a-d8879d619a1d@kernel.dk>
 <c5626637-e85b-a567-46e9-45c01ce87852@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c5626637-e85b-a567-46e9-45c01ce87852@gmail.com>
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

On 7/12/23 12:25?PM, Artyom Pavlov wrote:
> 05.07.2023 21:32, Jens Axboe wrote:
>> On 7/5/23 10:44?AM, Artyom Pavlov wrote:
>>> Greetings!
>>>
>>> Right now when I want to cancel request which runs on a different ring
>>> I have to use IORING_OP_MSG_RING with a special len value. CQEs with
>>> res equal to this special value get intercepted by my code and
>>> IORING_OP_ASYNC_CANCEL SQE gets created in the receiver ring with
>>> user_data taken from the received message. This approach kind of
>>> works, but not efficient (it requires additional round trip through
>>> the ring) and somewhat fragile (it relies on lack of collisions
>>> between the special value and potential error codes).
>>>
>>> I think it should be possible to add support for cancelling requests
>>> on other rings to IORING_OP_ASYNC_CANCEL by introducing a new flag. If
>>> the flag is enabled, then the fd field would be interpreted as fd of
>>> another ring to which cancellation request should be sent. Using the
>>> fd field would mean that the new flag would conflict with
>>> IORING_ASYNC_CANCEL_FD, so it could be worth to use a different field
>>> for receiver ring fd.
>> This could certainly work, though I think it'd be a good idea to use a
>> reserved field for the "other ring fd". As of right now, the
>> 'splice_fd_in' descriptor field is not applicable to cancel requests, so
>> that'd probably be the right place to put it.
>>
>> Some complications around locking here, as we'd need to grab the other
>> ring lock. If ring A and ring B both cancel requests for each other,
>> then there would be ordering concerns. But nothing that can't be worked
>> around.
>>
>> Let me take a quick look at that.
> Hi!
> 
> Any news?

Not yet, haven't had time to look into it yet.

>>If ring A and ring B both cancel requests for each other, then there would be ordering concerns.
> 
> I am not sure I understand the concern. Do you mean that task1 on
> ring1 attempts to cancel task2 on ring2, while task2 attempts to
> cancel task1? I don't see how it's different when both tasks are on
> the same ring. Task2 may run when ring2 receives the cancellation
> request, but it looks similar to CQE for waking up task2 being already
> in competition ring. In both cases you would simply get -ENOENT in
> response to such SQE.

It's just a locking concern, that is all.

-- 
Jens Axboe

