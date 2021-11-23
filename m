Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761BD45AED5
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 23:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbhKWWIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 17:08:11 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34030 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239030AbhKWWIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 17:08:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D9D42218EF;
        Tue, 23 Nov 2021 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637705100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dei+76XU0vXn64vupOE9tVZC/VdvbBWJIZHcNjPkBQY=;
        b=XDpIRqPjJnI2Muw4SRGLLb2ino0hU/9+YjM77u7D4J5vbmv5SCXUJf7AAE7HamjRv4vRpu
        1Q3E0mM7AYyu9GuuQpKOcfy9vcj95Tt1N12I4VlCPQRRKVNEIZujQQZCmE4h4z4ZDvwPxn
        ZjLR55lEMGEGcGDpENBFCL9eYg7jF1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637705100;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dei+76XU0vXn64vupOE9tVZC/VdvbBWJIZHcNjPkBQY=;
        b=s7BpvJPogmBBM2B6QkJt4q4GhnXnKCAh40sDHC44tlNSONf8ki14mpBa+el5l7a6XO5qPp
        fQpOSoRsik9eCWBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0DC213E78;
        Tue, 23 Nov 2021 22:05:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Skn6JYxlnWHcXgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 23 Nov 2021 22:05:00 +0000
Message-ID: <dd92a69a-6d09-93a1-4f50-5020f5cc59d0@suse.cz>
Date:   Tue, 23 Nov 2021 23:04:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        David Hildenbrand <david@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
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
 <20211123170056.GC5112@ziepe.ca>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211123170056.GC5112@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/23/21 18:00, Jason Gunthorpe wrote:
> 
>> believe what you say and I trust your experience :) So could as well be
>> that on such a "special" (or not so special) systems there should be a
>> way to restrict it to privileged users only.
> 
> At this point RDMA is about as "special" as people running large
> ZONE_MOVABLE systems, and the two are going to start colliding
> heavily. The RDMA VFIO migration driver should be merged soon which
> makes VMs using this stuff finally practical.

How does that work, I see the word migration, so does it cause pages to
be migrated out of ZONE_MOVABLE before they are pinned?
Similarly for io-uring we could be migrating pages to be pinned so that
the end up consolidated close together, and prevent pathologic
situations like in David's reproducer. IIRC that was a idea to do for
long-term pins in general.

> Jason
> 

