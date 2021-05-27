Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FE73930A3
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhE0OVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 10:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbhE0OVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 10:21:01 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFBBC061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 07:19:27 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id f22-20020a4aeb160000b029021135f0f404so145672ooj.6
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 07:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XHKwLF2v3V4VWqYx9n7FC4fqjL2IydPIckhglGl3aBI=;
        b=vdx889mKtXxmmUtYyUT/xQmX2vtJuYXBCeuf1weEQ4rWMaorY2PhYVEtNtnp13g5fJ
         ak1m+/QKXN7O0xTFFlIBo28Txs/zXK44Pkt/G62rSiLnrRjlh+bHWwGk9lV3F6r14Jht
         JL6Dw6ojRKGoCHZThCY0GBNH88sF+lS9vBbEkO22eXqDMHxfiZoW9h7LIjyR7gThSp+8
         QbO4S2wB4T8rrS8yEblcB9WA9pH5TseuavX5SKL2vlOTP19XqjYQ0lRlZ2W2vjgcORP+
         sUbL1C4+nuCaBdu+Bd103z3tYu5YEj6sF6riCfXvBKvz9kJVajuUjEVO4YADZ46yfyVM
         iG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XHKwLF2v3V4VWqYx9n7FC4fqjL2IydPIckhglGl3aBI=;
        b=c3ZQDwfv3gylQu4ab8sPsL4MzbVOsaiHafxHDsqzudGndqA9R0AU/SXgvt6a9kS81X
         115Haz1y+832SSKOYroeuf8zAbH1jYH25brs7iEt1N6S53fwqDI1X4Pr1vOLVHrULfYJ
         Dp9VJKGOpoxlJC+q5ggn3xVyl7pgnptY5KnHUzEuUuVlVrncQNnvdTGs23eCfrSdl52j
         7ViATjtCX5mrWJPn0LZwk/4ThBVi38rNiHvJ4gNhgFb6gps2quTg1ZvpqGmcd6meGU6E
         Py6y9pUZUSbWYTK0EZMNl3bcAY8mOGE/tSIN8kbcVYvtKRRTmg/8ZzbrpMEl0s6Rsdej
         LbGg==
X-Gm-Message-State: AOAM5311Wp6WTXVrHHURTWKfLJ/MK3SdKdUi1qotH5k/q77Twt1dl/X8
        u321wnh1l3znbqDkYnHFszBmqw==
X-Google-Smtp-Source: ABdhPJyOUhN3gC5sEntgg5uHfW405nngphDn5/C6msJmpeXMMhBJ2hA/axxrhd+5wNLER1eaSw8FLg==
X-Received: by 2002:a4a:b085:: with SMTP id k5mr3021821oon.20.1622125166561;
        Thu, 27 May 2021 07:19:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id m1sm507110otq.12.2021.05.27.07.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 07:19:26 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     Justin Forbes <jforbes@redhat.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
 <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
 <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <01c2a63f-23f6-2228-264d-6f3e581e647d@kernel.dk>
Date:   Thu, 27 May 2021 08:19:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 8:12 AM, Justin Forbes wrote:
> On Thu, May 27, 2021 at 8:43 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/26/21 4:34 PM, Justin M. Forbes wrote:
>>> While IO_URING has been in fairly heavy development, it is hidden behind
>>> CONFIG_EXPERT with a default of on.  It has been long enough now that I
>>> think we should remove EXPERT and allow users and distros to decide how
>>> they want this config option set without jumping through hoops.
>>
>> The whole point of EXPERT is to ensure that it doesn't get turned off
>> "by accident". It's a core feature, and something that more and more
>> apps or libraries are relying on. It's not something I intended to ever
>> go away, just like it would never go away for eg futex or epoll support.
>>
> 
> I am not arguing with that, I don't expect it will go away. I
> certainly do not have an issue with it defaulting to on, and I didn't
> even submit this with intention to turn it off for default Fedora. I
> do think that there are cases where people might not wish it turned on
> at this point in time. Hiding it behind EXPERT makes it much more
> difficult than it needs to be.  There are plenty of config options
> that are largely expected default and not hidden behind EXPERT.

Right there are, but not really core kernel features like the ones
I mentioned. Hence my argument for why it's correct as-is and I
don't think it should be changed.

-- 
Jens Axboe

