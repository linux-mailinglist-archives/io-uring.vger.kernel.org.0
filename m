Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1919B40C5EE
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 15:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhIONJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 09:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhIONJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 09:09:17 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45ECC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 06:07:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i23so3831334wrb.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 06:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kngTyycORCLSwARpfVeNganjeFXcAmkFPNgjMRfEAB0=;
        b=cel3c8huCNb2+Q2W+cDcD3v2aw8vRR5j6V/d1encENY5mE9LyZBp7rVrE8ER0Y7t9U
         ZmuAUtFK5nLUhalg4icAz9PYw2oEI2WrJV1FKPgmse1LAJsl6NDsyzsH1hI4Vi7NWvcD
         iHFQNkkBxYrZmUpe9Ll9cBCnnYLdHYQTCEAiGLQ7HY66QNmMpwc7UBAAVE6EFF0CwnYN
         dH5BX22YrWKP8hzAZEsda1NOF1TKVftAgnPXrdQEhozD2VyX/u+4RqLUVmueVedpVILv
         wVPgz/nABRI1l15rHyIObNiWSgqI25mijOZpMYG+RIkP2iMBqL3joBUJfKgviNyTC2ei
         akzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kngTyycORCLSwARpfVeNganjeFXcAmkFPNgjMRfEAB0=;
        b=rzNczpu1kjhDTlOIE2/WCygT3CL7HzPFONkIVz36R/ry6gvhYi1rNH/YSyEn9CJVbl
         mDSfs7Ca/p8atzMYItjRQVQg6io0S8EnsY7jGV8dGO3hy5xfRoc9iqPZhyAiLhkT5txo
         AyxwukORojh7lMDBDzSPVKogMR0DotFNIXKeMIc5tANsJ0iuFdxNHZ6pJeMH6h5+EFR6
         ue6eHQLqSvmJQInAU53kbmfM1dNrnUE6ONCisqrcYPxJbYZZN2IoT9Otd4eKNdbkMNjk
         inBAlCGIY/VPFiWvN+eOHsCO8Xsom+pVPrU/Hwqec+oOSwbJs1MBC2A3nXDn9Wr4qUis
         gjDQ==
X-Gm-Message-State: AOAM530a1wmL+pFovPinsqeRLJJeULAZxdwACpfKz9c5VlcKAu2yYxSG
        0ASdUlYuH7p7Ee9ZPJOZ/wCscjrdmsI=
X-Google-Smtp-Source: ABdhPJzZzXwUJ0bmRB0MsK+YjG9sHsjUvCcqJMl1xmk+qlp8/Z5iMZE38prlQlH7jzfFchKFyHoEIw==
X-Received: by 2002:a5d:4579:: with SMTP id a25mr5090955wrc.222.1631711276958;
        Wed, 15 Sep 2021 06:07:56 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id o8sm13283870wrm.9.2021.09.15.06.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 06:07:56 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: remove ctx referencing from
 complete_post
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <60a0e96434c16ab4fe587651448290d61ec9a113.1631703756.git.asml.silence@gmail.com>
 <27450ede-6a8a-1262-82a1-3e8749faba79@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e93ff90a-0cf5-b434-66da-924255cab88b@gmail.com>
Date:   Wed, 15 Sep 2021 14:07:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <27450ede-6a8a-1262-82a1-3e8749faba79@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 2:00 PM, Hao Xu wrote:
> 在 2021/9/15 下午7:04, Pavel Begunkov 写道:
>> Now completions are done from task context, that means that it's either
>> the task itself, task_work or io-wq worker. In all those cases the ctx
> system-wq as well, not sure if that matters.

Yep, missed in the description.
fwiw, io_fallback_req_func() explicitly pins ctx.


>> will be staying alive by mutexing, explicit referencing or req
>> references by iowq. Remove extra ctx pinning from
>> io_req_complete_post().

-- 
Pavel Begunkov
