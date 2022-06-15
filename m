Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57A54C85D
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348448AbiFOMV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 08:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348025AbiFOMV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 08:21:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FDF37BCF
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:21:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e24so11127969pjt.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=5deDJA2UwdyPK58M7HWavBDB7a0VgLcU3mBGKqmFdkw=;
        b=oJdu8I30XTQ0r3tMhzE2lGN7P3te3uZv6CMKKtp4aLw1coqxi8Fto86juzjNqNrXi+
         btjpYGjpYMr0vl6YwpZ7hobPJ3X65EQfmlIPVTZVsw1TL1EgoDwP3+oNlGuTq8ra5xnN
         OPCtCoRSurltZx0o6gYmjj8dqabbfF5pYPMnfoHCBoVAzHlgmPI8FsEKghD5/mI9Yb2B
         +AcpUTzVjo/CS47YNppTvsTLOSJz/vcLDisfs4Qh4ZKNPK2NY1OIC6Sw5ckbMEIVcc3X
         lO6QXAq1z2W9FuHfHBawAOWpw8l4tzKHqbCWDZPHnvUUtL3GKIBlqzwHAfSaGNGBH981
         QHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5deDJA2UwdyPK58M7HWavBDB7a0VgLcU3mBGKqmFdkw=;
        b=2eZle4ps+lQEC5r/LsET9QTUU4/pdXoht23IrdJkRmq6ryF4lQ4js3/xSqAbMiC/zy
         8O9IAasF/QOdifySNEjL6zJiQO/kt0COIPVPz1eiEoFfAyTEiMkjD9NQJX6VIH2J+RUS
         pIN/oF9zewcSA/PrYNTm9LZyG2EjVJwUY+uA72F88E7HJyns5kLj7Vo1f8ZAsMKtCGIq
         viorKpD4hQhf6NSsTF5cSXqWFuN0qZ9q2tMyPlomM1gDez/RbxPhfWGyg6rC4/jASh5t
         1E/kRQb7pPNzJrBkBo4LUNLCpEhGVof4yLpHIepiYtw4HBDRcqfj7szOJq6MQCILmGmx
         A/Cw==
X-Gm-Message-State: AJIora+5Ku4YkSXRIZtFdYlcz4MYAo8W06pGAsIh5owRYm9CkhKKftiy
        Uag040741/1G12T2+NkfldXYtQ==
X-Google-Smtp-Source: AGRyM1v1uvOulSgIe2kOKR1/DqiXZFacdVJwwtGyW0kGtk878se80vutehrWi5IgbvVSQLpJEaMM9A==
X-Received: by 2002:a17:903:11cd:b0:167:8a0f:8d44 with SMTP id q13-20020a17090311cd00b001678a0f8d44mr9011526plh.72.1655295683356;
        Wed, 15 Jun 2022 05:21:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a170902b19500b0015e8d4eb29csm9124382plr.230.2022.06.15.05.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 05:21:22 -0700 (PDT)
Message-ID: <4612ee3b-a63c-2374-9fc1-db099b2f6d78@kernel.dk>
Date:   Wed, 15 Jun 2022 06:21:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
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
 <85b5d99e-69b4-15cf-dfd8-a3ea8c120e02@scylladb.com>
 <35a1fca7-a355-afbf-f115-8f154d8bdec6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <35a1fca7-a355-afbf-f115-8f154d8bdec6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 5:38 AM, Pavel Begunkov wrote:
>>>> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
>>>> there is work that requires to enter the kernel io_uring will
>>>> set IORING_SQ_TASKRUN in sq_flags.
>>>> Actually, I'm not mistaken io_uring has some automagic handling
>>>> of it internally
>>>>
>>>> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>>>>
>>
>> Is there documentation about this flag?
> 
> Unfortunately, I don't see any.
> Here is a link to the kernel commit if it helps:
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=ef060ea9e4fd3b763e7060a3af0a258d2d5d7c0d
> 
> I think it's more interesting what support liburing has,
> but would need to look up in the code. Maybe Jens
> remembers and can tell.

It is documented, in the io_uring.2 man page in liburing:

https://git.kernel.dk/cgit/liburing/tree/man/io_uring_setup.2#n200

-- 
Jens Axboe

