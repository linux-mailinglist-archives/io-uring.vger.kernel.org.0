Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9FB1798AC
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgCDTKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:10:12 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41723 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgCDTKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:10:12 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so3629547ioo.8
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 11:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EeVZMzgw2sxr8W7NIqgi66IEBbuchRxu8LoT76wIztU=;
        b=kx3d4gstN3VJzi7PvB3hb6cXpuP/OpCBFhZDZIam3mH2XSoUeh4BxpBpzNsclQ2mb0
         T4vcsvkEwC+loq5ooNNwDVz9/qUE9AU/Hv+5vw2UTtO6S04NyD2FyxviR/OxO/M8DymU
         +uB2oo74C4VonB9O5+e94RKqmJ8LJnZN3BeO8ndQYNWQnnIcM73fM/LP14zwpchVx8f0
         ejQPoNJ5C+uG7Zy1g2P2Zag7vJnGa0wCwqblg2DxbAAW3Jco6SDRYK3sO7e2xFOldmgH
         kB6AcK6yoyTpWUccxUz+Emx2HKiNCxyN3YRXAHGxqhSxidwKPTouq01LvyUKrgyKPPBj
         7mLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EeVZMzgw2sxr8W7NIqgi66IEBbuchRxu8LoT76wIztU=;
        b=GbWFZ/udI5N6T/KBNuNrk3e62w5RwUXwdmIXusSfAGRCQTuRtyqb4oZy1XkO4z6lqA
         kPyZGdsBm8+uf+MOmOnELr9tQ5ijd1lmZHPGX4d6/8CBipjOMbxCb1es+a8UzddgCwTK
         7MBKFZPpGFNo8Q67nZ5oP5/iTOO7u409wvFftygG9/d6VjIilKZEEtQT2s/zoNqWDLSK
         f9riC7g7HmB5+F3D/0O0UOrliE7f5+FcXPPliBtbaORKqiiSKGA2J11SbrMG8nSJH9KC
         YtGM//rM9ZolgHaAi7CIQFz8mJGrh6uANyYP3KyXv14j4h6T/e6SlVSC7AW/0OIyaaEi
         449Q==
X-Gm-Message-State: ANhLgQ1Q9Nes/SP/dIR/fSpkmW0JIKL9Vpx9kVgLxcSGaur5huh21v2p
        gNiIhtAzu6GZZyunQ4vGNNT1Kg==
X-Google-Smtp-Source: ADFU+vu8yf/+Cd+qA9Fw+VYHQH7xvFPQMAmxOR4tDmpjCPafLrHPhvPP2aeHJVrFaoO2+teJyR2omw==
X-Received: by 2002:a6b:3c13:: with SMTP id k19mr3449866iob.25.1583349010313;
        Wed, 04 Mar 2020 11:10:10 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m3sm4462780ilj.65.2020.03.04.11.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:10:09 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304190341.GB16251@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
Date:   Wed, 4 Mar 2020 12:10:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304190341.GB16251@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 12:03 PM, Josh Triplett wrote:
> On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
>> One of the fabled features with chains has long been the desire to
>> support things like:
>>
>> <open fileX><read from fileX><close fileX>
>>
>> in a single chain. This currently doesn't work, since the read/close
>> depends on what file descriptor we get on open.
>>
>> The original attempt at solving this provided a means to pass
>> descriptors between chains in a link, this version takes a different
>> route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
>> what fd value we're going to get out of open (or accept). With that in
>> place, we don't need to do any magic to make this work. The above chain
>> then becomes:
>>
>> <open fileX with fd Y><read from fd Y><close fd Y>
>>
>> which is a lot more useful, and allows any sort of weird chains without
>> needing to nest "last open" file descriptors.
>>
>> Updated the test program to use this approach:
>>
>> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
>>
>> which forces the use of fd==89 for the open, and then uses that for the
>> read and close.
>>
>> Outside of this adaptation, fixed a few bugs and cleaned things up.
> 
> I posted one comment about an issue in patch 6.
> 
> Patches 2-5 look great; for those:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Thanks for picking this up and running with it!

Thanks for doing the prep work! I think it turned out that much better
for it.

Are you going to post your series for general review? I just stole
your 1 patch that was needed for me.

-- 
Jens Axboe

