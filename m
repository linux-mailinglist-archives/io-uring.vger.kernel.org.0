Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D25B4D486E
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiCJNzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 08:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiCJNzQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 08:55:16 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA5F141FDA
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:54:15 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so3428944wmb.3
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tG61MNyQv0F78MSFc/ziyx+z/uiooZuGAPO8ztJ9ORs=;
        b=dVdmqtRfclU6RsZL/iHxShVltxcjMVrkRpaE+ryhnOHI/hVSh4C6SAviTtOlxpvbLm
         j0R+exYR1h9ZiiTXG/cWl1Esrl3ryj4vQttXr8LLJKs7IJLUEOGQoZwhG/o0ncyuU1p+
         48jz3GknKLbnRKhx9/akyxpDKfpgrdVRatZZKwysiB50XauGk/kcyNtHJMWDeAUh3TpP
         +iCSn59dRr+pmtYSUUD28TVnCBunJLjU0vz12vOuOFI52ZKXDMSiChs945o1795B47k/
         Ym6GUk1f6nnAL/yThfiG2giV0QOdrhUMphPNW/w8YB+Vc03wX2mV231OnUWbV0b1mBts
         FzVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tG61MNyQv0F78MSFc/ziyx+z/uiooZuGAPO8ztJ9ORs=;
        b=7sEQIBZIw5Z+DC46Ui3Yq+RWEVSCaTLXt1ctjydquN6stxboiRx1sMlFtSY+feA5VS
         i34A8CzFzjcxR8XbZHY9u5qIpt/THnNemcI8S7K30xjqjwMEpuW7vz2cZObdujDjsnG6
         yTPZWIEq3h2zeGTwTs27dWzwT29xIm7ZBSVV9UBf7jIaJ/mJ4+cMR86qGqbuuB2XthtL
         wHAJkNhex1cBY028RFBRdfIqt6K6J1D3VbhH2SBezpOgFcMt7NlokqbFyuuEbXMXfb2T
         J8bOmVWalwgsbLB0e98MSWA0ptEdVeyxb1XtRn0fObbGhCn3VaJxcqoU9m+SquVWPzb7
         6i7A==
X-Gm-Message-State: AOAM533rFblE74eFeiO4yBjzu32jIT9I1qQICoImEcWK9UstLTsKIlHb
        JvzOJccvUBIVNZpq2JSY3jzuHHrOSGU=
X-Google-Smtp-Source: ABdhPJxEEaOep1FYuQipyYx0OSSxdH3qqd73fpKTqixkGYMOwezJimCl/3gtt67dLXBAUT9DKWsbow==
X-Received: by 2002:a05:600c:1ca7:b0:389:a45f:bb2c with SMTP id k39-20020a05600c1ca700b00389a45fbb2cmr3619729wms.188.1646920453617;
        Thu, 10 Mar 2022 05:54:13 -0800 (PST)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id p16-20020adff210000000b001f062b80091sm4123959wro.34.2022.03.10.05.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 05:54:13 -0800 (PST)
Message-ID: <c8895ed5-c875-2645-c9da-22393872a99d@gmail.com>
Date:   Thu, 10 Mar 2022 13:51:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Artyom Pavlov <newpavlov@gmail.com>,
        io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <745ea281-8e34-d92a-214b-ab2fc421acb8@gmail.com>
 <a420eab1-94a3-9d3f-1865-fdb623a9a24a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a420eab1-94a3-9d3f-1865-fdb623a9a24a@kernel.dk>
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

On 3/10/22 13:43, Jens Axboe wrote:
> On 3/10/22 6:34 AM, Pavel Begunkov wrote:
>> On 3/10/22 03:00, Jens Axboe wrote:
>>> On 3/9/22 7:11 PM, Artyom Pavlov wrote:
>>>> 10.03.2022 04:36, Jens Axboe wrote:
>>>>> On 3/9/22 4:49 PM, Artyom Pavlov wrote:
[...]
>>> OK, so what you're asking is to be able to submit an sqe to ring1, but
>>> have the completion show up in ring2? With the idea being that the rings
>>> are setup so that you're basing this on which thread should ultimately
>>> process the request when it completes, which is why you want it to
>>> target another ring?
>>>
>>> It'd certainly be doable, but it's a bit of a strange beast. My main
>>> concern with that would be:
>>>
>>> 1) It's a fast path code addition to every request, we'd need to check
>>>      some new field (sqe->completion_ring_fd) and then also grab a
>>>      reference to that file for use at completion time.
>>>
>>> 2) Completions are protected by the completion lock, and it isn't
>>>      trivial to nest these. What happens if ring1 submits an sqe with
>>>      ring2 as the cqe target, and ring2 submits an sqe with ring1 as the
>>>      cqe target? We can't safely nest these, as we could easily introduce
>>>      deadlocks that way.
>>>
>>> My knee jerk reaction is that it'd be both simpler and cheaper to
>>> implement this in userspace... Unless there's an elegant solution to it,
>>> which I don't immediately see.
>>
>> Per request fd will be ugly and slow unfortunately. As people asked about
>> a similar thing before, the only thing I can suggest is to add a way
>> to pass another SQ. The execution will be slower, but at least can be
>> made zero overhead for the normal path.
> 
> The MSG_RING command seems like a good fit for me, and it'll both cater
> to the "I just need to wakeup this ring and I don't want to use signals"
> crowd, and passing actual (limited) information like what is needed in
> this case.

Agree if that's what is needed.

To clarify, another approach I suggested is to be able to submit from a
different userspace provided SQ, so there is no locking around the main
SQ. And this doesn't cross a ring boundary, one will still need to specify
only one target ring fd


-- 
Pavel Begunkov
