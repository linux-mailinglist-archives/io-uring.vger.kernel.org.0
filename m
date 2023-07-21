Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194C175CD03
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjGUQDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjGUQDQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:03:16 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181B30C1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:03:08 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so28027739f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689955388; x=1690560188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60YtP11fEju+1ygyzm8XPMrMs4DwQwaXPilPBUs5RpI=;
        b=e17MUMueFLrIIhzNGY3C5xlpNS7p5TOniyVtggeL2HiNz3zIx0b/A0TKC132ko37AT
         KInb9/c85Z+Jrvqzg9bNqEkJxCWoolyWr7ymdbVKdMwtU75B4n70bL4HJD2AK/wkUsuM
         BpjXx8X83A3DUaoL+gqIkvWIlOqESPSV5LI/2QoHoedooR4CC1KqEAVZQVZfxCZy+sJB
         DqguGyhJCkNDf0L6bhbPkjgvhZY2LWm76BFb1zi40qd0s/C/qUkd+kLfaQaV4BtASQJQ
         Mogk5LeaYcDTcH6jrQm5VJkbfURm2y4T6SQybnbyWMYvzSdSUg7ISoX86P6cuFNKrNSk
         x0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689955388; x=1690560188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60YtP11fEju+1ygyzm8XPMrMs4DwQwaXPilPBUs5RpI=;
        b=YBff02xIV79bpnIHnFU+JAnIi/J37f/a3R+DNZzMcbRBm/7qJb65LJIW4l19gZEIRy
         ORX79AcFQRoB9OYaBBIEYEzA4sAPr2J+MjqHMKzi6da5DWMMF2Kqac00FRK+CMOke4AE
         MZr916RXOqkWtNtmg6um2+EQ1UtbWq/FbS/Bol+RVsFEbs2Xad8TuGEJZqB/vou54Etw
         RTfzJwMiz5LoxTOW22N1cTjv2G0+o/fr1XcQKTha5OY3zCDYu5680mpwrc0YqcETgvL2
         bw7mkwQhBLoMDycA+CTE8ao4tK+Vrq2ohHR9Jl3vhg7zysic01H9yixgSa4Pe9fn37Bg
         QNLA==
X-Gm-Message-State: ABy/qLZRDPP4EjM0tN40hwQU57gQXr7uXwM/Ivy6rtAjpusn7yB82z3E
        sz/QFC04Q79zJUb0lWFKnlkHsw==
X-Google-Smtp-Source: APBJJlHOUPPdoPZRRy7znHygcklexmesBUi9leBYiKgVAgJzlC7MSvoJZO0fFeeocJSfRNm+LQlXvQ==
X-Received: by 2002:a05:6602:1a05:b0:780:c6bb:ad8d with SMTP id bo5-20020a0566021a0500b00780c6bbad8dmr2343621iob.0.1689955387886;
        Fri, 21 Jul 2023 09:03:07 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r17-20020a6bd911000000b0078680780694sm1156144ioc.34.2023.07.21.09.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:03:07 -0700 (PDT)
Message-ID: <e3c86a40-ad61-4c56-fd20-1afac7c90505@kernel.dk>
Date:   Fri, 21 Jul 2023 10:03:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-xfs@vger.kernel.org, andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-4-axboe@kernel.dk> <20230721061554.GC20600@lst.de>
 <5b14e30b-1a22-b5fe-1a21-531397b94b16@kernel.dk>
 <20230721155506.GQ11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721155506.GQ11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 9:55?AM, Darrick J. Wong wrote:
> On Fri, Jul 21, 2023 at 08:04:19AM -0600, Jens Axboe wrote:
>> On 7/21/23 12:15?AM, Christoph Hellwig wrote:
>>> On Thu, Jul 20, 2023 at 12:13:05PM -0600, Jens Axboe wrote:
>>>> Whether we have a write back cache and are using FUA or don't have
>>>> a write back cache at all is the same situation. Treat them the same.
>>>>
>>>> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
>>>> two cases that provide stable writes:
>>>>
>>>> 1) Volatile write cache with FUA writes
>>>> 2) Normal write without a volatile write cache
>>>>
>>>> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
>>>> update some of the FUA comments as well.
>>>
>>> I would have preferred IOMAP_DIO_WRITE_THROUGH, STABLE_WRITES is a flag
>>> we use in file systems and the page cache for cases where the page
>>> can't be touched before writeback has completed, e.g.
>>> QUEUE_FLAG_STABLE_WRITES and SB_I_STABLE_WRITES.
>>
>> Good point, it does confuse terminology with stable pages for writes.
>> I'll change it to WRITE_THROUGH, that is more descriptive for this case.
> 
> +1 for the name change.
> 
> With IOMAP_DIO_WRITE_THROUGH,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks, I did make that change.

> Separately: At some point, the definition for IOMAP_DIO_DIRTY needs to
> grow a type annotation:
> 
> #define IOMAP_DIO_DIRTY		(1U << 31)
> 
> due (apparently) triggering UBSAN because "1" on its own is a signed
> constant.  If this series goes through my tree then I'll add a trivial
> patch fixing all of this ... unless you'd rather do it yourself as a
> patch 9?

Ah yes. I can add a patch for that and send out a v5. Will run the usual
testing on it with that patch added, then ship it out. Risk of conflict
with io_uring changes is pretty small, so would be fine to stage through
your tree.

-- 
Jens Axboe

