Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C650783C
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 20:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356976AbiDSS0t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 14:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357027AbiDSSZA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 14:25:00 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EEC403DC
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 11:19:04 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f5so11066363ilj.13
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 11:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wokerGmckRYYAuG7vnvwFGdqzKxOeMPs8itH9toPUxU=;
        b=5AkJjFoLG48rzJfkn9rUwXkrViq/pEHLu/h2dyriVkRddxacAw04AnV751XlATXYOV
         rrQTK0efnIZxBekjz9efpA8deIP2/EV5wUdDYTszpehfFohq/LAqKJJHBklKgM3gcPGk
         zArXxopunBkFaC4RWFJmQILQggYpyVNyhgRa18K4p7UmSeHs+53NOMTqXZiGf0R4Azxm
         D4l9hWJDkk7e+3YfkDz9m4TxKyQ+vCCzYxmH9sWCfl2s0+5oY/9wGbxb3fHRHUNCX9d2
         bUziMkCj/WTpLK2YfXmZY6dDZSRRPnbFo6WFxOvIOCckVGqTRj7G7e4S2h2jvzAbzP+B
         pAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wokerGmckRYYAuG7vnvwFGdqzKxOeMPs8itH9toPUxU=;
        b=CYFHRpbasZRe9SxgV1hLFFNJIziSjjCvdLonpRsPmeUwlXBl9GpcWSIN9gQRrj7k6H
         PYaFFWI+wymoZdXDDpuxpk72AZuaz8BuKWY4DErUcRQFAcW5M8XaYmpYuwJT4GnN7s1Q
         +WtV1EFYLaLSypX5EaLQTfq+RrMBJyRQnEqV1maCn6rcqO5/R44C7b7LIANdxO28GZxe
         9gaYFERA8JE1d3CTN5hyiVMIsP6tc5h+Ihtari/eyl1MqSjkpgqWzHJ6MfayKmYlTpE3
         85GWf9NDMl7ccXKW2aGDUwB+hDUEa5Mq7NzlD8XQE/bNzlCd6H5bqg38IjY2M0whiPWW
         wJBw==
X-Gm-Message-State: AOAM530OdKZoklqY9H+7CfsS/QL9L7uRQnuLXFwGTEhNArcOaWEuGpvb
        EYE6Vd0/b/9anmA4SGdOp8EGSg==
X-Google-Smtp-Source: ABdhPJwkDanwvNiImGwk18e3bS6pqNiYmqfNcUDzvNso7qtDM5g7c1/buvdEr7oCYUwpJW5k8RTCww==
X-Received: by 2002:a92:c561:0:b0:2cb:d912:bc83 with SMTP id b1-20020a92c561000000b002cbd912bc83mr7308075ilj.81.1650392343046;
        Tue, 19 Apr 2022 11:19:03 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e18-20020a5d85d2000000b00649254a855fsm9592310ios.26.2022.04.19.11.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 11:19:02 -0700 (PDT)
Message-ID: <586ec702-fcaa-f12c-1752-bf262242a751@kernel.dk>
Date:   Tue, 19 Apr 2022 12:19:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com>
 <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de>
 <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de>
 <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de>
 <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
 <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
 <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
 <CA+1E3rJHgEan2yiVS882XouHgKNP4Rn6G2LrXyFu-0kgyu27=Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rJHgEan2yiVS882XouHgKNP4Rn6G2LrXyFu-0kgyu27=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 11:31 AM, Kanchan Joshi wrote:
> Hi Jens,
> Few thoughts below toward the next version -
> 
> On Fri, Apr 1, 2022 at 8:14 AM Jens Axboe <axboe@kernel.dk> wrote:
> [snip]
>>>>> Sure, will post the code with bigger-cqe first.
>>>>
>>>> I can add the support, should be pretty trivial. And do the liburing
>>>> side as well, so we have a sane base.
>>>
>>>  I will post the big-cqe based work today. It works with fio.
>>>  It does not deal with liburing (which seems tricky), but hopefully it
>>> can help us move forward anyway .
>>
>> Let's compare then, since I just did the support too :-)
> 
> Major difference is generic support (rather than uring-cmd only) and
> not touching the regular completion path. So plan is to use your patch
> for the next version with some bits added (e.g. overflow-handling and
> avoiding extra CQE tail increment). Hope that sounds fine.

I'll sanitize my branch today or tomorrow, it has overflow and proper cq
ring management now, just hasn't been posted yet. So it should be
complete.

> We have things working on top of your current branch
> "io_uring-big-sqe". Since SQE now has 8 bytes of free space (post
> xattr merge) and CQE infra is different (post cqe-caching in ctx) -
> things needed to be done a bit differently. But all this is now tested
> better with liburing support/util (plan is to post that too).

Just still grab the 16 bytes, we don't care about addr3 for passthrough.
Should be no changes required there.

-- 
Jens Axboe

