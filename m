Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D6D45A986
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 18:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbhKWREH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 12:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238513AbhKWREH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 12:04:07 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E138DC061714
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 09:00:58 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id de30so22582637qkb.0
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 09:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CFoLHMr/Z5LPCRYETT9tnpkqBCibUyTd4qK2BHV8DYk=;
        b=nsTjfm6OvGB4aoB+P4zzFpoqRZc3fzSiLrwe7bKf9EdkEG0SLPsMrmMS6ZjUURyCs3
         RxG6LDALb0mczy36TEMfAQizjbQjSmNM8TDLDrr2PHheidsM/LJ7jreKQ7FPQrSkIwd9
         bQkQhZ8K8s4FOG9Wysbdf6aDQOohs78VY/ASSL/i5NoBuVVK4I5NGTSV/ap+e1DfZ++x
         2zligQ2hDJMjp8KKaESDPSxfJqaM2DAj9xa0dXU4Ms59fPVMQhLcgT26gsWkwWKQk9Ve
         xuU0hiF5d/iAnyCa6OrGGGGehHz9gSJLW1GdYm3YqlYvOEHwNIez3YoMJpI24eW2JjLG
         w6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CFoLHMr/Z5LPCRYETT9tnpkqBCibUyTd4qK2BHV8DYk=;
        b=hYchYpcQAZev93y4UcjV2SZJltIJYXDh9Ma+noiH8NslmiOzXkLMUp9sjbg/NRhywT
         AqbQ9bodb/68oesKoJPcF3jLILSmB5Uytn4kqe8OQ32RXd23GVCnQdUPj3OtfQ4JjK86
         ZN3/ZlUYA7ehqek3nFQhI7hEwCWPoIpyrxCCj8Bu3Pkbm6VO6aYDSNIUKVL53PUEClFk
         w6V2sqArgaE+vxfl5mTvYTvutROtp2dOaY/7H+mGctrOkGJi3ATRBrrYVHyCRpCK3IwK
         bNOz6F10DqPesHzYaCc3zR624qsYgU4hhYRC9FItf9cwL+jqudiymOzf+iTIxdd4KPrg
         QZrQ==
X-Gm-Message-State: AOAM532eDDH38gJY4jidI3zZ0SLvG6fKN1g1M2y1lbEi5XnO/Z3bWuf4
        05r5UgLWZ+lpNg/E42FQYphe/tCRhpjSSA==
X-Google-Smtp-Source: ABdhPJyCfsuzW9aNgeEoX01aT+J8AVygOW5MKRGQDmf+YbVxdYXAAzkQAco6yirK4ymbFWhPkmfgWg==
X-Received: by 2002:a05:620a:288c:: with SMTP id j12mr6002351qkp.103.1637686858082;
        Tue, 23 Nov 2021 09:00:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q20sm6629100qkl.53.2021.11.23.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 09:00:57 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpZA8-000DRS-L5; Tue, 23 Nov 2021 13:00:56 -0400
Date:   Tue, 23 Nov 2021 13:00:56 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211123170056.GC5112@ziepe.ca>
References: <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <20211123132523.GA5112@ziepe.ca>
 <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
 <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 23, 2021 at 03:44:03PM +0100, David Hildenbrand wrote:
> On 23.11.21 15:07, Jason Gunthorpe wrote:
> > On Tue, Nov 23, 2021 at 02:39:19PM +0100, David Hildenbrand wrote:
> >>>
> >>>> 2) Could be provide a mmu variant to ordinary users that's just good
> >>>> enough but maybe not as fast as what we have today? And limit
> >>>> FOLL_LONGTERM to special, privileged users?
> >>>
> >>> rdma has never been privileged
> >>
> >> Feel free to correct me if I'm wrong: it requires special networking
> >> hardware and the admin/kernel has to prepare the system in a way such
> >> that it can be used.
> > 
> > Not really, plug in the right PCI card and it works
> 
> Naive me would have assumed that the right modules have to be loaded
> (and not blacklisted), that there has to be an rdma service installed
> and running, that the NIC has to be configured in some way, and that
> there is some kind of access control which user can actually use which
> NIC.

Not really, we've worked hard that it works as well as any other HW
device. Plug it in and it works.

There is no systemd service, or special mandatory configuration, for
instance.

> For example, I would have assume from inside a container it usually
> wouldn't just work.

Nope, RDMA follows the net namespaces of its ethernet port, so it just
works in containers too.

> believe what you say and I trust your experience :) So could as well be
> that on such a "special" (or not so special) systems there should be a
> way to restrict it to privileged users only.

At this point RDMA is about as "special" as people running large
ZONE_MOVABLE systems, and the two are going to start colliding
heavily. The RDMA VFIO migration driver should be merged soon which
makes VMs using this stuff finally practical.

Jason
