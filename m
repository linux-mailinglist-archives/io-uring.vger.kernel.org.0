Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8D324207
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 17:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhBXQZM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbhBXQYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 11:24:55 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC43C06178B
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 08:24:07 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id f6so2567423iop.11
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 08:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CuDukGtTqpFQ10aZsFKTc4QE+YxIfa/qMLoFHD2Isyg=;
        b=Uy0rmqhm48ljoUOR/CgWfn6zV9KA8ivxJ9UUVnJQOp2YqY+VxP5xfmUO55c5jU1oF+
         b9p6MOueZdYi7Uv44ufx0M8E7bDWJlQbOHjqeuHaNfJ41WFN/IKQlz3mrQMojQioUw/m
         pKAkufCV/WGL+g+ijjZJR3wgi4TO0Zl1+7Re92yWtSgan0Chnl3EpU/s7hnbwd/Z/L+h
         27K4UEpqIoIM9m0yiNlRpQ/58w3IBnrzMN+ZyKK2gXA8I/xtC6+qMH+wXD4uKbKM0wM6
         JGInCOQHfI2ZaKHEn1r/dGwVMlO2QKx8XaWNm2OguwsyOwEevTVm+HClsrc2LrN7fO74
         Fyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CuDukGtTqpFQ10aZsFKTc4QE+YxIfa/qMLoFHD2Isyg=;
        b=JClD3FLgC1NmG00QUjsxgKPoDSRUwak4GYLSdDzD0l3SYtKGNo2p85suGHqpO45dAL
         nRbIqb594QG/RU1JyuuevanE0NtsHw74PsxYwW5HjD7h65agoDK85E4oqkMDTJwE+22U
         hyn7RtMp8+o45WeTfYVB6rB2/57WIYjZEND/s0yFDlK5hA4AIUFxbLIut/MVu/POgJG9
         DWPloJXEb+HQroNjN9FBEBlRqUm/fuT+U9wuY6/6qoRq3d+m24VGKRKZg8a2Zq/rNuWW
         iWZYtOFUOagcJG1yCehehKqdysA4VXe8q4Vdbn/gIbAoo23/CWeXJ+m+JGNtaP0abQWI
         BvDw==
X-Gm-Message-State: AOAM533F2R0/3yKIzvIAkWnrNkQuEvx58ay3fOAYpKMNh8PzssS8iZXS
        xed+yT+jBCfhma6xAGNbplWI8qHLttwYQkLw
X-Google-Smtp-Source: ABdhPJznOC2YfNd1ZPs+6SCJ5NTUlbpRJbCYJGuZeYi2O7NmcU/qHyWeeDS+QjM1P3BM+0gzHIdfVA==
X-Received: by 2002:a5d:9250:: with SMTP id e16mr25028426iol.27.1614183846771;
        Wed, 24 Feb 2021 08:24:06 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a2sm2188902iow.43.2021.02.24.08.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 08:24:06 -0800 (PST)
Subject: Re: io_uring_enter() returns EAGAIN after child exit in 5.12
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
 <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
 <20210224043149.6tj6whjfjd6ihamz@alap3.anarazel.de>
 <d630c75f-51d4-abb4-46b3-c860a6105e4b@kernel.dk>
 <20210224045456.rt3c3pvvka7fpaln@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45c01300-e00d-094e-cfcb-f83d0746d928@kernel.dk>
Date:   Wed, 24 Feb 2021 09:24:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224045456.rt3c3pvvka7fpaln@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 9:54 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-02-23 21:33:38 -0700, Jens Axboe wrote:
>> On 2/23/21 9:31 PM, Andres Freund wrote:
>>> Jens, seems like it'd make sense to apply the test case upthread into
>>> the liburing repo. Do you want me to open a PR?
>>
>> I think so, it's a good addition. Either a PR or just an emailed patch,
>> whatever you prefer. Well, the previous email had whitespace damage,
>> so maybe a PR is safer :-)
> 
> Done https://github.com/axboe/liburing/pull/306. The damage originated
> from me foolishly just copy-pasting it from the terminal :) - I wrote it
> a test VM and was too lazy to copy the diff out...

I totally sympathize with that :-)

I've merged your pull request, thanks.

-- 
Jens Axboe

