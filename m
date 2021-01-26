Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933A33033F5
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 06:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbhAZFK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732034AbhAZBex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 20:34:53 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A852C0698D1
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:31:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g15so10173710pgu.9
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+rOSxpCfLAi+4QJn/ZTJAaummeegtELcLiTveho04CI=;
        b=UWaIPOZf1DpySwiZueylaccUXpXV1AN3+j8atad1KjzH/D/RpVZ5l3hlQX/v5oUmQH
         d3rRICZorJEri3Z9iIv8Xy9j5+GmIpUwhq5XlDgIEQNezEsvAJ5QySUzt0YkAtJi7FJg
         2hPIkp5ch6/wxqNbXuDfRqo7R3JqhVBrINHt8DA1I77ZyirpwmrEaAjeD0wRhdpUwD1T
         TrWsXqb3WJttrUzvpgMj24wvmEwzfpnvTCjaS8iJWpHf4foo1y3yODbwm8wIP8PM5GoO
         JAyLjYIzmMIJq6RfbD8giu3rLNshfBq49R0FHmCJ2Y+H31acHyUXjvJkjxdMmMSE64cC
         Q3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+rOSxpCfLAi+4QJn/ZTJAaummeegtELcLiTveho04CI=;
        b=N53la+L7iIR37SWtBCG1dMCsYedUr82NIVPxyfjBD1nQq4I16244epo2MWdQ0P81v0
         dc/S3lGvq68AOhgke1fWwFTAyvXoNg1Fj2qrHutYb2r5IvEztuufOrqFTshXvoXFgXNE
         UvgiXgAEkWPd/LJGCs8+JY6B7UF+qMZS+7T2tuN1zvyE3wKOsM+35q/eKJfNaJbz6Gj9
         PbYqnNwlpuXJCfjYAtvCnDxVvpoffVfdn7wqYaiXn7gTRGwFQ7pNgpe7CUjoZBnDfkjP
         P+HfeR3KlV/XwsJodkj34coURZ8vYJmmFfUWfDVrS2KT8keVEzvc9UhiL6q0o4b8lXSo
         HO2g==
X-Gm-Message-State: AOAM5316pEwUgZ9OdLJsbR25s1HMYZvgtDKkO6DszG3kQkXFNyS0tGfu
        bSrmXObLW/0QDyQ8weohM2cEGA==
X-Google-Smtp-Source: ABdhPJw/yNerFPWKVzIuL4CAI1D9Rd3HaYaJUu8ucVQX0KM9Vcty8CEowP26G39ZecukCySc5mtwJg==
X-Received: by 2002:a62:445:0:b029:19c:162b:bbef with SMTP id 66-20020a6204450000b029019c162bbbefmr2932755pfe.40.1611624686612;
        Mon, 25 Jan 2021 17:31:26 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i1sm18858666pfb.54.2021.01.25.17.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 17:31:25 -0800 (PST)
Subject: Re: [PATCHSET RFC] support RESOLVE_CACHED for statx
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210125213614.24001-1-axboe@kernel.dk>
 <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
 <4bd713e8-58e7-e961-243e-dbbdc2a1f60c@kernel.dk>
 <CAHk-=wgdL-5=7dxpertTre5+3a5Y+D7e+BJ2aVb=-cceKKcJ5w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <add91ec9-da8f-1eed-5c54-c94281b5ca99@kernel.dk>
Date:   Mon, 25 Jan 2021 18:31:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgdL-5=7dxpertTre5+3a5Y+D7e+BJ2aVb=-cceKKcJ5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 6:28 PM, Linus Torvalds wrote:
> On Mon, Jan 25, 2021 at 5:06 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Which ones in particular? Outside of the afs one you looked a below,
>> the rest should all be of the "need to do IO of some sort" and hence
>> -EAGAIN is reasonable.
> 
> Several of them only do the IO conditionally, which was what I reacted
> to in at least cifs.
> 
> But I think it's ok to start out doing it unconditionally, and make it
> fancier if/when/as people notice or care.

Agree, that was the point I was trying to make in the reply. I'd rather
start simpler and talk to folks about improving it, looping in the
relevant developers for that. I'll leave it as-is for now, modulo the
afs one which was definitely just a mistake.

-- 
Jens Axboe

