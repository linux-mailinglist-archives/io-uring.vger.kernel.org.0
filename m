Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E123AD01A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 18:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbhFRQNL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 12:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhFRQNL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 12:13:11 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B00C061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 09:11:01 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id z14-20020a4a984e0000b029024a8c622149so2569013ooi.10
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 09:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vhESHB2fuprKm8qQn68AEA+GxbpLEhL/mzYCL3E+vDM=;
        b=R37sfzViltwUXr/gzNQ0xemD+gyVroAIGks6VP6ctNDVs4ruFihGex61iVk2bhg2Gk
         vcMshC6lM5nqrIbr0RhAQ/Cj7+4oKmybgiOfqWHq2hMpyzpRRPY2pt2G5qOyFLv/kT1P
         vPJ82s675u49TEW9hLbpy3fms+eDEaiDbQy6IXA0AoCDs+8R/1FWKKpadESxvd8FsTyd
         5xmWKyw+H6345GVLPM2eiqproimUAfDS0LaEHu0x1wVIcTLWkOhXkqfLDY70qg3Ri8mU
         LK0rSZRD+5nD0Ny2uoc4mziR7jqqFj1wL7Daq/MlcFKrBcFkicWoL+y4vGRHwR2uJE0i
         jDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vhESHB2fuprKm8qQn68AEA+GxbpLEhL/mzYCL3E+vDM=;
        b=hbHq56H3IqwZqUibfe9ZKAGZVyfIcZ9WBd1PJSlH/y96buqQaJFmc06vi2Zh6WotsB
         hOeulrT+L/JeCkU/2tejpFS5TiEezWBVA45w/KjDS2j72gsazxFjXaVpMQEpGztWLiVf
         EaIVMps8ZgSRyn+JVlMg4GZMfL6zRAYzeF4JyKrrjP+xvEirblgDFdnYsEiX+LdvBxJS
         55duhsgujy6yz4Le9Wwbm5GukGcc4a/uShYbML8d9hJPMlIGVVLESkgTygCAuXe+v+so
         EF1aynrI7CQdPSX8zcnMhcQpGkQhL1dx6+S5mS6AxIA1jBIm9sZtSSwB8ZDndaQ/xPVR
         R/ag==
X-Gm-Message-State: AOAM530eUp2tfU5p1Auq3soBIG+peHSzFOfND4lIw3qR/E2tnj8rUpl6
        hjN/jyMSUzLVjsT8Sv64bl3AfZU7nTh0rw==
X-Google-Smtp-Source: ABdhPJzenWHbYw70J0zk1/iySUjenjhRryHqwnndVtlVqnOhDMDQESlZnKUG7ZN2df+M160N9ZJhNQ==
X-Received: by 2002:a4a:d312:: with SMTP id g18mr4693350oos.7.1624032660987;
        Fri, 18 Jun 2021 09:11:00 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t63sm1825354oih.31.2021.06.18.09.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 09:11:00 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c4d5933-965e-29b5-0c76-3f2e5f518fe8@kernel.dk>
Date:   Fri, 18 Jun 2021 10:10:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/21 12:24 AM, Dmitry Kadashev wrote:
> On Thu, Jun 3, 2021 at 12:18 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>>
>> This started out as an attempt to add mkdirat support to io_uring which
>> is heavily based on renameat() / unlinkat() support.
>>
>> During the review process more operations were added (linkat, symlinkat,
>> mknodat) mainly to keep things uniform internally (in namei.c), and
>> with things changed in namei.c adding support for these operations to
>> io_uring is trivial, so that was done too. See
>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> 
> Ping. Jens, are we waiting for the audit change to be merged before this
> can go in?

Not necessarily, as that should go in for 5.14 anyway.

Al, are you OK with the generic changes?

-- 
Jens Axboe

