Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A45345C796
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 15:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357033AbhKXOkm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 09:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347894AbhKXOkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 09:40:39 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BEDC2035B4
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:48:14 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id 132so2795724qkj.11
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zOXzKhqaRx2erCZtsz+9xALkHd9hNx/cLSQi9Yty6Mg=;
        b=mqWQPtKzwOR1nkPAD7jr3kr0122cp3KDzbkHN+B+BxUbqGHwEj/KwFx+nzOZg5/uMv
         yIUSS+MqQcFr+VNaaOdQL2d54qPlp7/uaU1vDWm0bWF/WUjZxiC0fvnyOfXDQtl5pj2C
         yfEPRxdcQqW0bzw/xo4luil1ejPlXbTZKMrVa3O9+CFypBK9Vxa2Fb/Wi+5LRCM/2Ej+
         KnIDGXrj+FdBk+m0nclivosH7G9FNhn/mQQycUFZZyEdlBbOlaakTvIJcZrMjFupixhJ
         0E9iiTnkyJ7//qXBW+4wpIgh/iwCuzV8L27KLQvBSD4qycVQcE7fubpABBHpq7dcXbai
         5nxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zOXzKhqaRx2erCZtsz+9xALkHd9hNx/cLSQi9Yty6Mg=;
        b=RxK2t9uVyzmEtA89t+UmS1VRLXkLokV86RH89UxOjNU16YA38BLFtFZ0/N0tBvSx+d
         xXhKkVNCrh3uJLqLdQyS9C8BFnZtkqBzSYhW0t4e3p00OdWdRPH/TAhJcItbP2T+4zIA
         K1OQgiYuk9hd7PVZ/v4m9ajdBqWMiLjbpIYTdBsBymlwmeqP0/cr7F5Ijxmu/EUZgMfG
         GbJHHIDZ8kEkwWlfL2n38mY2+e3tEaESY9sZZKi+3fdIVDBkTL2Us1kJojvZ6puV1zwA
         Lx14Vbw0b90ZFYvxra+ko9jT861xP3GH5zWy6SyTS0R/xdCedXxNb0u8EXQswN2DC7Z3
         Y4iw==
X-Gm-Message-State: AOAM532L7dMH0EcHwheovyaYsymViE969AuntasqnUxsH/3BarhBk+h2
        rBUI0+uceED6+A8XVT0lv88ZCA==
X-Google-Smtp-Source: ABdhPJzQ5AOoy19Xqda8lOZ1Zk6QX+7bxb6Q0xD34+IJfiCzMeF/udwWMkqUf3c7/DV2nUZ9JOgtyg==
X-Received: by 2002:a05:620a:22f5:: with SMTP id p21mr6352722qki.498.1637761693453;
        Wed, 24 Nov 2021 05:48:13 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id o126sm7924464qke.11.2021.11.24.05.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 05:48:12 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpsdA-0011Y1-BA; Wed, 24 Nov 2021 09:48:12 -0400
Date:   Wed, 24 Nov 2021 09:48:12 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211124134812.GI5112@ziepe.ca>
References: <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
 <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
 <20211124132842.GH5112@ziepe.ca>
 <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eab5aeba-e064-9f3e-fbc3-f73cd299de83@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 24, 2021 at 02:29:38PM +0100, David Hildenbrand wrote:
> On 24.11.21 14:28, Jason Gunthorpe wrote:
> > On Wed, Nov 24, 2021 at 02:25:09PM +0100, David Hildenbrand wrote:
> >> On 24.11.21 14:23, Jason Gunthorpe wrote:
> >>> On Wed, Nov 24, 2021 at 09:57:32AM +0100, David Hildenbrand wrote:
> >>>
> >>>> Unfortunately it will only be a band aid AFAIU. I can rewrite my
> >>>> reproducer fairly easily to pin the whole 2M range first, pin a second
> >>>> time only a single page, and then unpin the 2M range, resulting in the
> >>>> very same way to block THP. (I can block some THP less because I always
> >>>> need the possibility to memlock 2M first, though).
> >>>
> >>> Oh!
> >>>
> >>> The issue is GUP always pins an entire compound, no matter how little
> >>> the user requests.
> >>
> >> That's a different issue. I make sure to split the compound page before
> >> pinning anything :)
> > 
> > ?? Where is that done in GUP?
> 
> It's done in my reproducer manually.

Aren't there many ways for hostile unpriv userspace to cause memory
fragmentation? You are picking on pinning here, but any approach that
forces the kernel to make a kalloc on a THP subpage would do just as
well.

Arguably if we want to point to an issue here it is in MADV_FREE/etc
that is the direct culprit in allowing userspace to break up THPs and
then trigger fragmentation.

If the objective is to prevent DOS of THP then MADV_FREE should
conserve the THP and migrate the subpages to non-THP
memory.

FOLL_LONGTERM is not the issue here.

Jason
