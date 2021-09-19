Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59FA410B5B
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhISL6G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Sep 2021 07:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhISL6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Sep 2021 07:58:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F23C061574
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 04:56:40 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q26so23488469wrc.7
        for <io-uring@vger.kernel.org>; Sun, 19 Sep 2021 04:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LeWVepjYqMirBGP4GxudPs8njihHQswIFmYJxvL3NUA=;
        b=UUOE1or3dMfrOmDxGedodsy8hFK8rXuaZfaLM4Sph2maazqwiLowSEsdWqPcR0XsnX
         3MSOm07RGaYis95RKaK5nta88o3L2bz6sWmg1X9mNU1/+kO1fa2ywghK3jjzdiZr2Zf9
         ogS18mV+YYmOnv+HtdhM+TdWASLSLa91U4hO6SqI1kpojis438677SapZm+IZSoFZCmp
         Hu+VuX4O3v2FhshKlK9mQSOwTeIGN+si+b92rHwzkYp/Zx0tAgEzg03Sbe0Q35TPQYH1
         FQDzO5aBqncXmDVOsKLHrjcTbEPTEFsZ4n5yviOvNceZmAodlbR52CeOw8HQmBwugOp0
         yigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LeWVepjYqMirBGP4GxudPs8njihHQswIFmYJxvL3NUA=;
        b=Fs8OwU5191T2E3xiFgTcON9yK6neGu3JSrqzLtT0FL8HPalnTSHcIHWzHrbXscX4y4
         SENi0bMcDJ5QuUb/6nEayIMI6QgiJldafDAqGbs7p1BIuhDremxZh+TDQIrzW4228dTu
         V3uvy5DsuoI2iWRfdqwDG2ut7iE+97TwSmM5LjJq8uhoS1qtmgUxvs5lQ3f1kcZn2Nax
         IZ43RHmSU7Y1cdH73i9+66+X1gw1aN3jpqhEvU3V7hk5qhEldaqjjhPAFJMLQUs+kVpF
         l7BCZ7SHIpi528IeiS/kqrevmFOiNHwqmZkwGpo/E2C/aWQCxleFjtRQVkgbZvEOAtmH
         X/9Q==
X-Gm-Message-State: AOAM531mE6xe6N2gX1el7XzB+110FDNOW3adaX9PLHwyG4D2f9jAaci/
        pIiZH2UmtPBpPTkJe4dLDc+R3uy2fqE=
X-Google-Smtp-Source: ABdhPJystnd68E2tCj97gSoi19OVx5TnsidaB+MnvWbr2WinUqef/g470vsQq6U3Dr8Qt5+BmBEEMA==
X-Received: by 2002:a5d:59a4:: with SMTP id p4mr22842791wrr.149.1632052599221;
        Sun, 19 Sep 2021 04:56:39 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.22])
        by smtp.gmail.com with ESMTPSA id l7sm15298487wmp.48.2021.09.19.04.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 04:56:38 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <370104bd-b78d-1730-e7f4-6ea7c5ad50ef@gmail.com>
Date:   Sun, 19 Sep 2021 12:56:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 11:21 PM, Jens Axboe wrote:
> On 9/18/21 3:55 PM, Victor Stewart wrote:
>>> BTW, this could be incorporated into io_uring_register_files and
>>> io_uring_register_files_tags(), might not be a bad idea in general. Just
>>> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
>>> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
>>> failure.
>>
>> the implicit bump sounds like a good idea (at least in theory?).
> 
> Can you try current liburing -git? Remove your own RLIMIT_NOFILE and
> just verify that it works. I pushed a change for it.

Sounds like it pretty easy can be a very unexpected behaviour. Do many
libraries / etc. implicitly tinker with it?

>> another thing i think might be a good idea is an io_uring
>> change/migration log that we update with every kernel release covering
>> new features but also new restrictions/requirements/tweaks etc.
> 
> Yes, that is a good idea. The man pages do tend to reference what
> version included what, but a highlight per release would be a great idea
> to have without having to dig for it.
> 
>> something that would take 1 minute to skim and see if relevant.
>>
>> because at this point to stay fully updated requires reading all of the
>> mailing list or checking pulls on your branch + running to binaries
>> to see if anything breaks.
> 
> Question is where to post it? Because I would post it here anyway...

Good idea. We need it in a single file to be useful

liburing/changelog.txt?

-- 
Pavel Begunkov
