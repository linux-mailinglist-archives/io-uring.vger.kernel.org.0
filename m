Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4F11F0318
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgFEWt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgFEWt2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:49:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4389DC08C5C2
        for <io-uring@vger.kernel.org>; Fri,  5 Jun 2020 15:49:28 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nm22so3234593pjb.4
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2020 15:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FsXyHeejFFCHLuSs92j2aDN2Io/JQ2E6kep2zpjuyz8=;
        b=StWmTEruf+tFcVK0xLcr4hcabCL/ilrkqMd+zy3U8C3YcQv/1hHn9cfosi48b/3sSa
         OcQAJtJA92CboLd0FTNyRubN9nyufg9mcY/c6CmuLOLKq7lvQa+w56iaoeHs9R3CASm2
         lxao6pqS/3p5G5EVj4JbsV3Ax5arLcKw3KkwwJvGYUgXXmZ5zYG9QYKegfoNfwcTr8+U
         aJnJLnPAZK/ph6SwL/F7UuAv56biUpB7ZXn7P46gU883uewb/PCstGhEa0U6XlLV2yzl
         lm68FFscv7V2cldH7qV9t8a8C9QJ5rHH/o17pFLTPdIoiXh4+3ZRqismCYIzPFCvhMwv
         xmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FsXyHeejFFCHLuSs92j2aDN2Io/JQ2E6kep2zpjuyz8=;
        b=QGFfy3aE9lqvs0lmfN0ahGLuSOLlFSWBFogIuOl27DR9F1vH54muBNHSsmJRCDju+2
         9p8X6MzSrOcYjK5idsI2mCxZkmsjhVpP8MT9yVPYAIV6U3GDd67Pg7pfAlCbk/IgAFQJ
         V075yXgcfNoOFwNrbeUyZ2Gdy4kuQIDVJ7mNespYD62cwOGE+RkkW+tlAR99bskQQInH
         XAhm6LRZf953CV+epricZ+spoRFE538DkKSPF7FDGel38GWvvgZIolon7Z+o6CHCjQLe
         YCCpWRcYf2p4Y6aBZe6LGJhAp4fbPS3EMrrVGILrZZhuU/Q1AcpzHAz+k3KLTgGDlXD+
         48Dg==
X-Gm-Message-State: AOAM530CYjtluFr53kC5jnArtWlAxacsi6Oo6Aly9nHvUM0vocTVIYNh
        KmFcpqbEtVmNB1y3g1gwX0byDI5UQJ9wAg==
X-Google-Smtp-Source: ABdhPJxJBUYjQDQdDdC7tCFcrlKbAw753ZwMqEUe9U6DCnO3e7GQPhBdbjDmgLrLffVay5yqki7l/w==
X-Received: by 2002:a17:90a:c717:: with SMTP id o23mr5384687pjt.195.1591397367704;
        Fri, 05 Jun 2020 15:49:27 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q185sm549854pfb.82.2020.06.05.15.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 15:49:27 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
 <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
 <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk>
 <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
 <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
 <20200605223635.6xesl7u4lxszvico@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0e5b7a2d-eb0e-16e6-cc9f-c2ca5fe8cb92@kernel.dk>
Date:   Fri, 5 Jun 2020 16:49:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605223635.6xesl7u4lxszvico@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/5/20 4:36 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-06-05 15:30:44 -0700, Andres Freund wrote:
>> On 2020-06-05 15:21:34 -0600, Jens Axboe wrote:
>>>>> I can reproduce this, and I see what it is. I'll send out a patch soonish.
>>>>
>>>> Thinko, can you try with this on top?
>>>
>>> Sorry that was incomplete, please use this one!
>>
>> That seems to fix it! Yay.
>>
>>
>> Bulk buffered reads somehow don't quite seem to be performing that well
>> though, looking into it. Could be on the pg side too.
> 
> While looking into that, I played with setting
> /sys/<dev>/queue/read_ahead_kb to 0 and noticed that seems to result in
> all/most IO done in workers. Is that to be expected?

Yes that's expected, if we have to fallback to ->readpage(), then it'll
go to a worker. read-ahead is what drives the async nature of it, as we
issue the range (plus more, depending on RA window) as read-ahead for
the normal read, then wait for it.

-- 
Jens Axboe

