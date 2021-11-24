Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9227745B6FE
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 09:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbhKXJAs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 04:00:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234024AbhKXJAp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 04:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637744256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVGzFQPQlGn5U1mE3m4XSY5JB0lBn/n06rnEA04Gx5Y=;
        b=gp3NpgcF9BX569zdb3LR4wq6oIr8J6zj1IbfgRYKumbiprx0rFbld7PpvQ+Dq2/SxE1gm4
        bixEsHX8cRD1B5g7QWpxxYdiEvmdI9nAoLqTm5mZjEp99zMvZI0cLbiiSZSIzOtza4a8v/
        Tnse7MSPsVl5y1V4iJH0oAP2j2c1mlY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-t87G30AvN629Cphbeq_8sA-1; Wed, 24 Nov 2021 03:57:34 -0500
X-MC-Unique: t87G30AvN629Cphbeq_8sA-1
Received: by mail-wm1-f70.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so1036670wms.7
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 00:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TVGzFQPQlGn5U1mE3m4XSY5JB0lBn/n06rnEA04Gx5Y=;
        b=phU1dVb9frA3Nw/sCt++9E2MBJFBu/qXqF0xAzl8swZVHHdf6vP84+GpQqVWmVIwk/
         VXQl/3zZ0JGBSBwSTV/20jWbJVxnfa4ZXd2h/52USRCEcEVbSzIXwtajHHx/d+YCZMSM
         +G1ZrWaEqPZl4ENABodb2QipFJ19TLuy6xtB6wmAr1f2EZujGBR1s2ZvGfkwODJ1O60K
         m5KKLSclOcM3IZZXlvcPeOuBvAG18qOj1KfpDUaWVSahSs5FVvSaB7edB7UFcXaWDgWG
         DVkrCKCT+VexB2XoDowzCIK5tZLkOU3lP/dF9IA3+VrJhRP5tujR3nm8vsdRV5qWsOsV
         DAIA==
X-Gm-Message-State: AOAM531H40pxd0fODvz3fwM389Gi0laPkfrdlIHdcdIEH61DNBbpOuMh
        W7l5/kBDIQ7LMa3oesJdeZ1yu88Xhca8zzOB8ytsSFIoihlEsbLMXjqaS9sv91IbiPNQcAr0oKv
        ElbIuiIcCg0o4gNnDXig=
X-Received: by 2002:adf:ea0a:: with SMTP id q10mr16624868wrm.1.1637744253639;
        Wed, 24 Nov 2021 00:57:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyi+zQkpv4TT2GNLv4kRZkNnRXzh1SkmiJ1oViYiQs5PhmxYxCZmXd1XJr0v4EH3FZy65rjw==
X-Received: by 2002:adf:ea0a:: with SMTP id q10mr16624845wrm.1.1637744253433;
        Wed, 24 Nov 2021 00:57:33 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id u15sm4422950wmq.13.2021.11.24.00.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 00:57:32 -0800 (PST)
Message-ID: <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
Date:   Wed, 24 Nov 2021 09:57:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
References: <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <20211123132523.GA5112@ziepe.ca>
 <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
 <20211123140709.GB5112@ziepe.ca>
 <e4d7d211-5d62-df89-8f94-e49385286f1f@redhat.com>
 <20211123170056.GC5112@ziepe.ca>
 <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
 <20211123235953.GF5112@ziepe.ca>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211123235953.GF5112@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24.11.21 00:59, Jason Gunthorpe wrote:
> On Tue, Nov 23, 2021 at 11:04:04PM +0100, Vlastimil Babka wrote:
>> On 11/23/21 18:00, Jason Gunthorpe wrote:
>>>
>>>> believe what you say and I trust your experience :) So could as well be
>>>> that on such a "special" (or not so special) systems there should be a
>>>> way to restrict it to privileged users only.
>>>
>>> At this point RDMA is about as "special" as people running large
>>> ZONE_MOVABLE systems, and the two are going to start colliding
>>> heavily. The RDMA VFIO migration driver should be merged soon which
>>> makes VMs using this stuff finally practical.
>>
>> How does that work, I see the word migration, so does it cause pages to
> 
> Sorry I mean what is often called "VM live migration". Typically that
> cannot be done if a PCI device is assigned to the VM as suspending and
> the migrating a PCI device to another server is complicated. With
> forthcoming hardware mlx5 can do this and thus the entire RDMA stack
> becomes practically usable and performant within a VM.
> 
>> be migrated out of ZONE_MOVABLE before they are pinned?
> 
> GUP already does this automatically for FOLL_LONGTERM.
> 
>> Similarly for io-uring we could be migrating pages to be pinned so that
>> the end up consolidated close together, and prevent pathologic
>> situations like in David's reproducer. 
> 
> It is an interesting idea to have GUP do some kind of THP preserving
> migration.


Unfortunately it will only be a band aid AFAIU. I can rewrite my
reproducer fairly easily to pin the whole 2M range first, pin a second
time only a single page, and then unpin the 2M range, resulting in the
very same way to block THP. (I can block some THP less because I always
need the possibility to memlock 2M first, though).

-- 
Thanks,

David / dhildenb

