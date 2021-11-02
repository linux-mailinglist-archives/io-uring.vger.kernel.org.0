Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D84435AA
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 19:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhKBSiX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 14:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhKBSiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 14:38:23 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707A1C061714
        for <io-uring@vger.kernel.org>; Tue,  2 Nov 2021 11:35:48 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id p204so15087436iod.8
        for <io-uring@vger.kernel.org>; Tue, 02 Nov 2021 11:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pOJAHEYIQXJ1iIGx//cwchYlhS9N29CwNOwhnCdpXR8=;
        b=ZwfTmiiTmU9f9KNi4a0jOvoO5/19q5HzyTBmB8688JJHbSpuwXl8GA2nS+FqftUMFT
         lAEUAzgFmCk4iNBWwa2tYBwtfpPfR9/NUlXFXGedlG6YoYFPsnS6gDSEgYs9yQTO6nXx
         WQLrTYnLHbfP5Cg80ucz9WcMMaEK6EHs5fVUefAhnO541He4jsEsIkwN1zTwxIH7UsIB
         muQMKp56u8ygQW68JB158zeB3YmmT1wFmVeT2ycqmB4hagR36VTm5w1SRhUtI5bWIAZW
         RiDC1gzvV4khg6asWb7pRzkbtbh78MI7V6TjYwBBAKdU6kRt00+sXIsGpB0wjnVzpBQ1
         CE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pOJAHEYIQXJ1iIGx//cwchYlhS9N29CwNOwhnCdpXR8=;
        b=krBHSPR8eBA38zIOOtxP0iNaXDMOICzWBo/MtnKzehL8/Z+Bvu9PJFRC5SrfI7k53u
         Lzn5/5ie5qjDE7Ups9Vpnjqli1Dwl6r0pODPkZTCC3Um70jl3Ll/l2orSMC334YAysh7
         Ol/2DikQIlTBb2Bl/5633s+z0O4nStEOiO3tlalGWQHhzjI+wFdflV3B+ksyj0vQkqwu
         pI6dxbS+xX6kCZLJeN7OiaVTqJhBDSnri4y6gCLOg1UEMGqjG1Hi6xKOXEV/S32lgvHF
         7YZb1fGbc5gqLg/Ap4j+Vm7iuFWWp6pLvqFf+q+IYoR0Hy7W/8RRdAv8DklHMWqZn0I/
         C0Sg==
X-Gm-Message-State: AOAM530LMXXgNDhMy6HfTKsgoxZ1AI1ESEh6MIsvbLHkO/wYKnlYwJHT
        jciK3ekom+4KO7cULut1YZ9/ToxFUn+sfA==
X-Google-Smtp-Source: ABdhPJxiVeSB6cK6q1DK3zUh2j2wFwNVXduZr+FeK1LzDkqJCbsIiS/NEddbEAblE9uKk4eiRh6hRA==
X-Received: by 2002:a05:6638:2650:: with SMTP id n16mr29588488jat.72.1635878147572;
        Tue, 02 Nov 2021 11:35:47 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j13sm8492073ila.6.2021.11.02.11.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 11:35:47 -0700 (PDT)
Subject: Re: fix max-workers not correctly set on multi-node system
To:     beld zhang <beldzhang@gmail.com>, io-uring@vger.kernel.org
References: <CAG7aomWpq3Gt9z9uqAQ5VCA_6pXgvVrL47yVx88xzX6bbotUXw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d1021cc-98bb-5103-326c-e9a1738a4db1@kernel.dk>
Date:   Tue, 2 Nov 2021 12:35:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG7aomWpq3Gt9z9uqAQ5VCA_6pXgvVrL47yVx88xzX6bbotUXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/21 11:36 AM, beld zhang wrote:
> in io-wq.c: io_wq_max_workers(), new_count[] was changed right after
> each node's value was set.
> this cause the next node got the setting of the previous one,
> following patch fixed it.
> 
> returned values are copied from node 0.

Thanks! I've applied this, with some minor changes:

- Your email client is not honoring tabs and spaces
- Improved the commit message a bit
- Use a separate bool to detect first node, instead of assuming
  nodes are numbered from 0..N
- Move last copy out of RCU read lock protection
- Add fixes line

Here's the end result:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.16&id=71c9ce27bb57c59d8d7f5298e730c8096eef3d1f

-- 
Jens Axboe

