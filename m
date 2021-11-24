Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB545C2C1
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348836AbhKXNcV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 08:32:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347834AbhKXN31 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 08:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637760375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPJilnIac+E/1S4aK4r1xPmWiIMnvA9sCROlm1Reb+4=;
        b=YiwZtieWnIe6es0MCIYwUiomvDFP6YR3+lBbWuEi0Y22joGNhbM61JyjxEBLGmpaRLVYUR
        9zxtEDsN+tzYe53NnRoTyc8SzNf3doiy1oUT3NYOZ6y16O2VRfy+kBysjLxYtY8Bru1q4c
        5SlC+5dyhCqwawlWoajj4juicS+qhYs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-1GihGIoMNkuatZ9Vn-oB-A-1; Wed, 24 Nov 2021 08:25:12 -0500
X-MC-Unique: 1GihGIoMNkuatZ9Vn-oB-A-1
Received: by mail-wm1-f72.google.com with SMTP id n41-20020a05600c502900b003335ab97f41so1455761wmr.3
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YPJilnIac+E/1S4aK4r1xPmWiIMnvA9sCROlm1Reb+4=;
        b=yX4PXBcenp9Sqe0xhy89ki1qvo62rHKdAIn4J9g1SPX7QKsTiSpvlqYCYNlfrdHZUo
         rvPpSR1I4xM1bruDI0HYhGiQdFUsKJ6yHO3UekVSx6SdFMw3CtY5HGKlTQF6g1GiDk4t
         6R3369vGVv/4rsbYBJK8Qfl9ZUjcG0G+Uxt4tW51z+W3d7xh8JO9Ngmm+nW4Iwj7tgUx
         ND6Bo8lNbyNhnma4kDPR4CkXOkFYahAhpK1EpMcQbtbeFvGO6hHT6tszT1vQQVGc91pP
         ceCE7JZ3e3ojnRSxqjA3r1WA7Ooide0ES4hMjnXvVJp/WvDyi6McnE5jbif6qaNki/EO
         Xvxw==
X-Gm-Message-State: AOAM530qJo5S3i/18aZJ0NdNzEIzjY6neJDd0k/5g5KT/b+Ghoh90zUR
        LAcnIwpr08Wt/WUSmopdzpoS+gY3fzhUpafoPsu8Nf32qToA/NFfmWbgOzApW9lP04yGM+SpX4/
        tf8l9ksskkHf4tUVK+o0=
X-Received: by 2002:a1c:1f94:: with SMTP id f142mr15517431wmf.192.1637760311303;
        Wed, 24 Nov 2021 05:25:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyk+ncnGnjxU4A8q6MYUYXWQOTDE6uMjmtInX9yqzD5DhRTt5y9jx2YvAZtwG8QWD4fQJVp4g==
X-Received: by 2002:a1c:1f94:: with SMTP id f142mr15517394wmf.192.1637760311107;
        Wed, 24 Nov 2021 05:25:11 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id h15sm5707861wmq.32.2021.11.24.05.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 05:25:10 -0800 (PST)
Message-ID: <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
Date:   Wed, 24 Nov 2021 14:25:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <20211123132523.GA5112@ziepe.ca>
 <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
 <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
 <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211124132353.GG5112@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24.11.21 14:23, Jason Gunthorpe wrote:
> On Wed, Nov 24, 2021 at 09:57:32AM +0100, David Hildenbrand wrote:
> 
>> Unfortunately it will only be a band aid AFAIU. I can rewrite my
>> reproducer fairly easily to pin the whole 2M range first, pin a second
>> time only a single page, and then unpin the 2M range, resulting in the
>> very same way to block THP. (I can block some THP less because I always
>> need the possibility to memlock 2M first, though).
> 
> Oh!
> 
> The issue is GUP always pins an entire compound, no matter how little
> the user requests.

That's a different issue. I make sure to split the compound page before
pinning anything :)

-- 
Thanks,

David / dhildenb

