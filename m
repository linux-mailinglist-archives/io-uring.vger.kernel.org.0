Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F426127A
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 16:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgIHOPn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729305AbgIHOPX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 10:15:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13059C061A1E
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 07:10:34 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x2so15515983ilm.0
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SD2hzMO6T/4qOzewCneSHaqX5BbMpoVB67UFkCuqdr8=;
        b=G/Gy4Eh5J4GyD0nvTqgc9eXcy1GSZ8wvRh5lIWYPCD/rwi7O0O1dTUDqlUrgw/7jzz
         es54IrHYqaVXGAOo3DJAq5NbaCetGukqvK+WhllhnqFq/JAWdNu5XQyiyt98e3q3mxzW
         mtHFVmrDQJhfsBqct48aAhuiKnl3sHSbZay0hxOAz1VqU+P7g84c8p1O620j0+QcC0m8
         agEGLSlxA0PQQSklp0g0SQvdCsX9B49f/MA3cveU/9o6TxJVJYAHqBog6P0F3HJpmXZm
         F7G8sGmyxjrC16wTuRNqNJWcLFM5UVjPYzY6n3PjYdk8kzUfALQIYbSXC0pL5KiW1J22
         b5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SD2hzMO6T/4qOzewCneSHaqX5BbMpoVB67UFkCuqdr8=;
        b=OFSiE6Hb+Hg4PwMwy7Ddp4lwCo4Is+JQr2g54QW/FwwsaBts3/mg7YCBnlz3EEG+SP
         0cQiDdUc3zhp1Eqc1/5RpV71BNse0jzq+gcp6E385qpLCsaWckzk0wBuA/YKn/h+1UfB
         WeQR3+KcqDP5k9KJfknBlQ9EK/5IHmMeVsJvv66rjkhh+oStUp0/CcBWmtigA5oFOI14
         klgoUlE4GjMVrFz+rWbRXAIRD70ZRlP+XuT0X3TgQG610tddiSPmQlLgLNq5e2P+1yai
         zSbV+qy36j9XRbHNDm7XF+GSJgE7OgzU2zCGpKEgzgNo4sKaDBtpNXgXBNOkJhy6ilOO
         bIhg==
X-Gm-Message-State: AOAM530KRYfr+8aWeS1XJvKPLJItZNaQ0wrgTjdLSfd27ubpzMcy1pPf
        6CcfKDya78440VJXlkPuEUoIxny2VSnBmLPT
X-Google-Smtp-Source: ABdhPJygpa6/GbauAeVVJxbpIlrZ1r05xQZvIPxbLHOqJxstD3YgnZLy/Yny137+lWWUXvGaS4TCIg==
X-Received: by 2002:a92:5eda:: with SMTP id f87mr22715650ilg.279.1599574233140;
        Tue, 08 Sep 2020 07:10:33 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c9sm10471525ili.31.2020.09.08.07.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:10:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
 <9123fe5b-f57c-258a-64c3-71fa4859040b@kernel.dk>
 <20200908081400.pytf6abmvp7ke7my@work>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be7b75e7-1ce6-4890-a676-90dbc8d7b1d6@kernel.dk>
Date:   Tue, 8 Sep 2020 08:10:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908081400.pytf6abmvp7ke7my@work>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 2:14 AM, Lukas Czerner wrote:
> On Mon, Sep 07, 2020 at 01:34:38PM -0600, Jens Axboe wrote:
>> On 9/7/20 7:22 AM, Lukas Czerner wrote:
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>
>> This patch really needs some justification. I generally try to make sure
>> that older kernel skip tests appropriately, sometimes I miss some and I
>> fix them up when I find them.
>>
>> So just curious what the use case is here for skipping tests? Not
>> adverse to doing it, just want to make sure it's for the right reasons.
> 
> I think this is very useful, at least for me, in situation where some
> tests are causeing problems (like hangs, panics) that are not fixed yet,
> but I would still like to run entire tests suite to make sure my changes
> in didn't break anything else. I find it especially usefull in rapidly
> evolving project like this.

Yeah agree, that can be useful.

> I have a V2 patches with that justification in place and some minor
> changes. I'll be sending that (hopefuly it won't take hours this time).

OK thanks, I'll take a look and get it applied if it looks good.

-- 
Jens Axboe

