Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9172314D538
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 03:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgA3C2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 21:28:17 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34657 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgA3C2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 21:28:17 -0500
Received: by mail-pg1-f194.google.com with SMTP id j4so836821pgi.1
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 18:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LRUZp5Ct69nvTAMXHhvPw+FcbuYzqpVNkfl5DZw62+o=;
        b=MDMeCpRm3bE4nokkCbS3W81xwYn32wRmz/n36EYhV5VMFGBbUHgL2wXMdb57EJCajs
         kQWx82Msf2CCxULgbVQzMHogzTmfM5AxK9ArTDyGhxstugpGs2ndjHgedtqs6tQYsS65
         DpA+Is9xzMklbHvFDfuxU35rlYJMwt1BFFYT0pf3JMu3eraNl1BCM6im7tkLHxtQCZ5X
         7OrtSw2IcgxEwz4pK2TI6W8RXvrjXC55/je6ru73gNEVESLUQrgOi0zEQF+HhbQQa67q
         pffAGpcCCUGdamBHY2OveF19NQvDr1AUg1kduecOQRfK/ozGzJA/PEKcoCIrNdED91vK
         URYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRUZp5Ct69nvTAMXHhvPw+FcbuYzqpVNkfl5DZw62+o=;
        b=uAuy7HD7cfJHwBQVUU/BG7qiwNIEw1W9+Aa3TVRMkFbdwulNsvIA9QokClpAO7sOPB
         vj5hkVoIGEkelU3eruc3YUCobheeEQh360WLCxUd0Orxp13PPnqICTSVlwq+SwaB/+7K
         Yh+sedqZ695g2EmR22xkpMwQpEykvCNMy0FbV5ognQMr51ZZeInqIVPz6EodaOfKhFGf
         y4nnW2sL2xfUWm/FuCy7DPieZyPcPFnD8hB9an82wezGB5U1WQGfCOXLpcLv8isbyAIc
         nmAn6t4BAy3KDBrjlOR4tnLYzJXssg9Gth1B4Ve1kEeTX8W+dhX5C7NyDTMfZZAVuoeH
         tgww==
X-Gm-Message-State: APjAAAUv8fRgxxmKXMtpkRjJspJUeDyI02EHVDRI0gQ/qkOZSL9vk2PC
        C5z5LEizcVnUUOXvGnuUXL2LWQ==
X-Google-Smtp-Source: APXvYqzScuD6hh30QAkIN97kDbY5pikBpRfGbELTeEQOrCJdO+RImn3MGwfADsD9aVRr+pydbDw/tg==
X-Received: by 2002:a63:4723:: with SMTP id u35mr2192743pga.194.1580351295187;
        Wed, 29 Jan 2020 18:28:15 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g7sm4206809pfq.33.2020.01.29.18.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 18:28:14 -0800 (PST)
Subject: Re: [PATCH] add a helper function to verify io_uring functionality
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <20200129192016.6407-1-glauber@scylladb.com>
 <a682d038-046a-4b72-b43c-60e3e559f9e2@kernel.dk>
 <CAD-J=zYCvw+tBRmS42w8X6rOc9zE+L7j5jpjDL-y0YqW6KyBAw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7ab7584b-303b-8a20-2081-1218ad6c49c0@kernel.dk>
Date:   Wed, 29 Jan 2020 19:28:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYCvw+tBRmS42w8X6rOc9zE+L7j5jpjDL-y0YqW6KyBAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 5:42 PM, Glauber Costa wrote:
> 
> 
> On Wed, Jan 29, 2020 at 3:55 PM Jens Axboe <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
> 
>     On 1/29/20 12:20 PM, Glauber Costa wrote:
>     > It is common for an application using an ever-evolving interface to want
>     > to inquire about the presence of certain functionality it plans to use.
>     >
>     > The boilerplate to do that is about always the same: find places that
>     > have feature bits, match that with what we need, rinse, repeat.
>     > Therefore it makes sense to move this to a library function.
>     >
>     > We have two places in which we can check for such features: the feature
>     > flag returned by io_uring_init_params(), and the resulting array
>     > returning from io_uring_probe.
>     >
>     > I tried my best to communicate as well as possible in the function
>     > signature the fact that this is not supposed to test the availability
>     > of io_uring (which is straightforward enough), but rather a minimum set
>     > of requirements for usage.
> 
>     I wonder if we should have a helper that returns the fully allocated
>     io_uring_probe struct filled out by probing the kernel. My main worry
>     here is that some applications will probe for various things, each of
>     which will setup/teardown a ring, and do the query.
> 
>     Maybe it'd be enough to potentially pass in a ring?
> 
> 
> Passing the ring is definitely doable.

I think it's important we have both, so that an app can query without
having a ring setup. But if it does, we should have the option of using
that ring.

>     While this patch works with a sparse command opcode field, not sure it's
>     the most natural way. If we do the above, maybe we can just have a
>     is_this_op_supported() query, since it'd be cheap if we already have the
>     probe struct filled out?
> 
> 
> So the user will be the one calling io_register_probe? 

Not necessarily, I'm thinking something ala:

struct io_uring_probe *p

p = io_uring_get_probe();
/* call helper functions using 'p' */
free(p);

and have io_uring_get_probe_ring() that takes the ring, for example. All
depends on what the helpers might be then, I think that's the important
part. The rest is just infrastructure to support it.

Something like that, hope that makes sense.

>     Outside of this discussion, some style changes are needed:
> 
>     - '*' goes next to the name, struct foo *ptr, not struct foo* ptr
>     - Some lines over 80 chars
> 
> 
> Thanks! If you ever feel trapped with the 80 char stuff come write
> some c++ seastar code with us!

Such a tempting sell, C++ AND long lines ;-)

> It's my bad for forgetting, I actually had a last pass on the patch
> removing the {} after 1-line ifs so that was fun too

No worries.

-- 
Jens Axboe

