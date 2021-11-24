Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5545C77C
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351030AbhKXOhL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 09:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356387AbhKXOhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 09:37:07 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9823C0FD23E
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:28:43 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id i9so2780703qki.3
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 05:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WyqwKxdhohLsMuEIkCIlIATDPwH2TE1WlLTF/w/br8k=;
        b=GY9jyrWtFmcfvg6YIZNtW3Ix56uPG0xBVjVBcS/e4b+IChdZQLov+cmAbydRjXM3yK
         dHqLCM4rjxEAvDa+geMY6fxngSihcj9pL3VNCzuR1hT2jWo5QsWYH9RlQrq2L4nnidQh
         XOxKUJHwJcXJbqOHxX+l82Y2bfwOjGCrUMU1BOEJ2KfwQAZTFwflMfFjmrSyvviuzm8Q
         xUsy2MvOhJP30pa+dsEHvTeYDv5XDY39bOfetq9mDFqGd/vTEEynw9MabZ2vI0zwMFRj
         Hc3Z61Jzb66T2sLxHgq8fcJUihzG27C2dDAa/isljx+kSgCfURy3AiR0rbrqrhGC8DyQ
         TOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WyqwKxdhohLsMuEIkCIlIATDPwH2TE1WlLTF/w/br8k=;
        b=a8ZtfNneuonVCTailqY4SO4NyrPhA+EVeZRD2MVh67ooLQ+vLvSHvN0EvYVj1CHh3S
         Svq2fjN9DUICQhMpfZFbJK69w75u0arViu4XcaxuzECsGFlmjBePtBLCSgl0p28L5dg/
         pRNbiiUdXDUCoLAOKtkzW3ZopnCt/YL11Ivnn9APm2WEYyDEZ8SSVyjdROH/zwR9hMZK
         HDquAUpi+ezTE3UhS7DXrTLBSxjqMDrSgwSfV1t5nrtbretqLhXUlxYIpYvvFT3GoejM
         7zQaFH1efR3dBPvo8TDe+BsQ9d3z17jqHLVlfb5OQv7fPb3BApQE8XYBd7ZUM86CGorv
         veRA==
X-Gm-Message-State: AOAM5339hV0nIRlYJhwgnFWZ0XQS5UBv/Zy9irKRouurmuUhVs4bC3zI
        MQR2I077EKBcYR/Mr3BnqKGSJQ==
X-Google-Smtp-Source: ABdhPJzGbKoVCbaPnqn5zJtUXwEpBDGfjaVJvcoC28XnE+g7caK/5ACu2Wb/+0Qf51NE8Rb35L0EjA==
X-Received: by 2002:a05:620a:2ef:: with SMTP id a15mr5877836qko.95.1637760522983;
        Wed, 24 Nov 2021 05:28:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u11sm7819305qko.33.2021.11.24.05.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 05:28:42 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpsKI-0011GP-1M; Wed, 24 Nov 2021 09:28:42 -0400
Date:   Wed, 24 Nov 2021 09:28:42 -0400
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
Message-ID: <20211124132842.GH5112@ziepe.ca>
References: <20211123132523.GA5112@ziepe.ca>
 <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
 <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
 <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
 <20211124132353.GG5112@ziepe.ca>
 <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca0229e-e53e-bceb-e215-327b6401f256@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 24, 2021 at 02:25:09PM +0100, David Hildenbrand wrote:
> On 24.11.21 14:23, Jason Gunthorpe wrote:
> > On Wed, Nov 24, 2021 at 09:57:32AM +0100, David Hildenbrand wrote:
> > 
> >> Unfortunately it will only be a band aid AFAIU. I can rewrite my
> >> reproducer fairly easily to pin the whole 2M range first, pin a second
> >> time only a single page, and then unpin the 2M range, resulting in the
> >> very same way to block THP. (I can block some THP less because I always
> >> need the possibility to memlock 2M first, though).
> > 
> > Oh!
> > 
> > The issue is GUP always pins an entire compound, no matter how little
> > the user requests.
> 
> That's a different issue. I make sure to split the compound page before
> pinning anything :)

?? Where is that done in GUP?

Jason
