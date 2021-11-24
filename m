Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631B045C79C
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349456AbhKXOlN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 09:41:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53938 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345299AbhKXOlE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 09:41:04 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 188741FD2F;
        Wed, 24 Nov 2021 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637764673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g89M6e4bZVmCAGamFZFhx+PTBdJYL4rU4pHyE6Arzw4=;
        b=EyZrDNrfpR7D5fH5oI12w5LWSmiNa4aXC3QlPr7YAZyqG3LiF9AbI/17RNZ9LptDFlpdQT
        AeibRGRQWbMy5hMySB6lMYUNWVKB6tUK+n+6fj87rZQtM0EMZaINBpn9Y3XuJIPmV5ipjg
        rawBAvdahJ9WTtg2kyAOVc38Yob+r44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637764673;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g89M6e4bZVmCAGamFZFhx+PTBdJYL4rU4pHyE6Arzw4=;
        b=kbd0ArkzFfW6iG8MSbD41gl/ohcBQzmXdtXUYxxIgWwqASW/a40zXPP3GJWa+EXdwrDk1Y
        iur/avAO8UavRwCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E08D113F19;
        Wed, 24 Nov 2021 14:37:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id A4LcNUBOnmEjagAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 24 Nov 2021 14:37:52 +0000
Message-ID: <b513d058-0721-cdcd-c146-de104db8af3a@suse.cz>
Date:   Wed, 24 Nov 2021 15:37:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
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
 <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <2adca04f-92e1-5f99-6094-5fac66a22a77@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 09:57, David Hildenbrand wrote:
> On 24.11.21 00:59, Jason Gunthorpe wrote:
>>> Similarly for io-uring we could be migrating pages to be pinned so that
>>> the end up consolidated close together, and prevent pathologic
>>> situations like in David's reproducer. 
>> 
>> It is an interesting idea to have GUP do some kind of THP preserving
>> migration.
> 
> 
> Unfortunately it will only be a band aid AFAIU. I can rewrite my
> reproducer fairly easily to pin the whole 2M range first, pin a second
> time only a single page, and then unpin the 2M range, resulting in the
> very same way to block THP. (I can block some THP less because I always
> need the possibility to memlock 2M first, though).

Hm I see, then we could also condsider making it possible to migrate the
pinned pages - of course io-uring would have to be cooperative here,
similarly to anything that supports PageMovable. Mlocked pages can also be
migrated (I think there's some sysctl to prevent that, if the guarantee of
not even a minor pagefault is considered more important).
