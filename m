Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B454EC4E7
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 14:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345137AbiC3Muq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 08:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbiC3Mup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 08:50:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB65E11C7EE
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:49:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso6046164pjb.5
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6TyadOMbq8Ov1v/5Z6p00Pdg7Rb2lwkgiVV6mcFRlVo=;
        b=7EWuShuEG4T/roB4yxjYVUKU8UosEoFiLJZSoiD3aw/10seScZJphYr4vob3T/KfQh
         D+l4XbpD+t+Tys6VtBL478NxwChmMIFF2entt/tZnaV63YVbNZ6DDTbDA4GKaWsKWP0y
         EQLBfTv9G6A0/77tdTzxQUaDgi8R6005a/tJv3UltyEhDDSQpXTegpF8Vds8eWPSpTEf
         9mMQ+OQ+JjRYsI11mHpsOWmWdDwDsvXOCnooKxWHAAENgM0d4ZbHS/pGB3DFyuU93mgw
         1PGOibe30yjHvTBEil4Wb6PWRcPLR+ZN9Ltn3jRstBoCXO3s3tswX1H7nc0iCvexv90p
         f9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6TyadOMbq8Ov1v/5Z6p00Pdg7Rb2lwkgiVV6mcFRlVo=;
        b=O7YC19UoY8/909gjbgH05vSeGhfdw496Jfpd/aLHH2gDjduHtBeCixUZsJJii9X78y
         0VgUuqSbXGaddBQwESbxHFiMXylZf5+jqJn7HRDvXe+Nj0cqOQSYeJ+djloPkRaub45v
         bMyfLkE/3w8GeuBHmfrcG8Hu9EEf8NS9Sz5RCrzm/pBg2jKyy3ikbw17ZRLIWQssX+Xg
         aorrZPZtq6JhRmf49Er3Bw/NXRjKA3NRtDH2ICseIf16ZIHThjF6hAVsW3Sz6Gef6vAO
         NJafuqU3yuTRhzNuR1SJCc5rkz978rfAwsp+T9HioT3CGuSycDUwmpQmPAuhXF806skw
         O3Tw==
X-Gm-Message-State: AOAM530W3tmblXxpb+x40ErmuFE3KfCrn3TGkV83QbGSgW3TO0gnG9EL
        FbMfCTGigXfQW4W9vAYA+HJMGv6vYIsPTFJI
X-Google-Smtp-Source: ABdhPJxcTM2PcZyDrOtM9DSW+r9h/7RhueVM8/uXKCEPii8JxoS9Zeb82Ugr5qMBPvwt2kwADWdAXw==
X-Received: by 2002:a17:90a:e2c9:b0:1c7:9878:1d15 with SMTP id fr9-20020a17090ae2c900b001c798781d15mr4885061pjb.150.1648644539659;
        Wed, 30 Mar 2022 05:48:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm6253485pju.15.2022.03.30.05.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 05:48:59 -0700 (PDT)
Message-ID: <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
Date:   Wed, 30 Mar 2022 06:48:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/22 6:43 AM, Miklos Szeredi wrote:
> On Wed, 30 Mar 2022 at 14:35, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/30/22 2:18 AM, Miklos Szeredi wrote:
>>> On Tue, 29 Mar 2022 at 22:03, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> Can you try and repull the branch? I rebased the top two, so reset to
>>>> v5.17 first and then pull it.
>>>
>>> This one works in all cases, except if there's a link flag on the
>>> read.  In that case the read itself will succeed but following
>>> requests on the link chain will fail with -ECANCELED.
>>
>> That sounds like you're asking for more data than what is being read,
>> in which case the link should correctly break and cancel the rest.
>> That's expected behavior, a short read is not a successful read in that
>> regard.
> 
> Sorry, I don't get it.  Does the link flag has other meaning than
> "wait until this request completes before starting the next"?

IOSQE_IO_LINK means "wait until this request SUCCESSFULLY completes
before starting the next one". You can't reliably use a link from an eg
read, if you don't know how much data it read. If you don't care about
success, then use IOSQE_IO_HARDLINK. That is semantically like a link,
but it doesn't break on an unexpected result.

If you're using LINK from the read _and_ the read returns less than you
asked for, IOSQE_IO_LINK will break the chain as that is an unexpected
result.

-- 
Jens Axboe

