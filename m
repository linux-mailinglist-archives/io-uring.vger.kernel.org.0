Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2871345C774
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 15:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355877AbhKXOgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 09:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355901AbhKXOgI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 09:36:08 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86B7C1A3AD8
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:23:55 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id b11so1720821qvm.7
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vR5X7aTiFOOVGN8Rdr9twInRzNQE68Jn7eaS79KF5JI=;
        b=Ql2jamGTDoo7tRUYmapHPNuQGI2EBH53GGT10ws9BRT9mp46w8Q3WwC3bQcPjeyJUb
         bDlBo8Chiuh50ahwDix4xn/QkQqNYaECP7iHe7aFuqQ+GnbXtLePsHEQYi8iJLbO8jqG
         NeYdwLTquLM5mylQwGgCeaeQkp0LBt1Yn1Rqo+zq6gwOGYUG9Po4+HaTCnO+dQNQOo9u
         /H7S4tZq/gdk39EiB3cmL6+u0dGvJcgyz0lJGS50HCetT00czUmh7PpLQWvPGx6Qxi6k
         OC/IM/Z8a6CY0jkeVQY6DjARa3DtW+KgCl9Ll6TBgitPiQ0pysSPg1B/wYFjftVk3MfZ
         N+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vR5X7aTiFOOVGN8Rdr9twInRzNQE68Jn7eaS79KF5JI=;
        b=gteC0LKln7AuPu4v2L+2bS0qgPy99shUruZnZJJKbriWn1zC5M3lkvcvIpdetsAymP
         TBtRpTEk85VXcllkqcNibs98oJtCMgiOIN8TETkWiLoFn84Zefw18DVgUPm2mbsnbzDe
         mcLQtNeKHtDLadFw29Vcow1LtpKu5Bi3k51v7CI/AkSHm5Y1a2qRBbF59hdT0ALyLbSi
         vPeY6BdBGXt885cJ2tLATQuXa2UMYn5rVplzZnLUXUCn1IjERQ8PrQa63ZsqKATqYX/M
         YdkSDoZ8Z4jnGBkm1dByIVhB0jCWxBBblySCmnxfvpprmLahe3rQmF6MzKzjK5IZvMM9
         AHxg==
X-Gm-Message-State: AOAM533BVBVxXn8cGGDzckNaAYm/DE7+dbQmt3XTGcUACgt2YeFhVWFd
        81yXVISZpTpfmLBkYJ8+Sa83DQ==
X-Google-Smtp-Source: ABdhPJwIkO/hSHdrvxMNPMQTiV33oMboBFQ2VKpVaquqdmUVNR+JyQZWlHq5jUxy9L7WR3iB7jccJg==
X-Received: by 2002:ad4:576a:: with SMTP id r10mr7232232qvx.5.1637760234949;
        Wed, 24 Nov 2021 05:23:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u7sm8522541qkp.17.2021.11.24.05.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 05:23:54 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpsFd-0011Ar-RE; Wed, 24 Nov 2021 09:23:53 -0400
Date:   Wed, 24 Nov 2021 09:23:53 -0400
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
Message-ID: <20211124132353.GG5112@ziepe.ca>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 24, 2021 at 09:57:32AM +0100, David Hildenbrand wrote:

> Unfortunately it will only be a band aid AFAIU. I can rewrite my
> reproducer fairly easily to pin the whole 2M range first, pin a second
> time only a single page, and then unpin the 2M range, resulting in the
> very same way to block THP. (I can block some THP less because I always
> need the possibility to memlock 2M first, though).

Oh!

The issue is GUP always pins an entire compound, no matter how little
the user requests.

However, when all the GUP callers do mlock accounting they have no
idea how much memory GUP actually pinned and only account mlock on 4K
chunks.

This is the bug your test is showing - using this accounting error the
user can significantly blow past their mlock limit by having GUP pin
2M chunks and then mlock accounting for only 4k chunks.

It is a super obnoxious bug to fix, but still just a bug and not some
inherent defect in FOLL_LONGTERM.

It also says the MLOCK_LIMIT really needs to always be > 1 THP
otherwise even a single 4K page may be unpinnable with correct
accounting.

Jason
