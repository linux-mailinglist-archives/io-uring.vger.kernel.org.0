Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F230B207791
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404608AbgFXPfY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 11:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404607AbgFXPfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 11:35:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C34C061795
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2020 08:35:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u8so1306673pje.4
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2020 08:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vLSu1kPuflATDhPDFU0nGgb8Mr/kuY3eeM+ALkjRaYY=;
        b=ZZswuMvynQximHdf+KSEM0t3wzEPu7urY3l2JX5ijwjRih7+H/wKSV/rUMlNY5ZUMl
         25xI374TL2HxqYZyoimohd7tO0xiyZFGKp4rYs0lBfm7WSw3C11TJbIO61Me/n0Ar/3v
         4cEjPauSagWqc2zs/dpCX4xogE0Ed9GOvsIyjJYvnpDaXL9IA/0mWgnyT/bfa4aO63+p
         Oag4/gwlrSuH19xiDUa3tUzTxAQaB185nS559lWoP5U7tG8p7tsy7ItuEbJ/3vvn1QN2
         baxOvqFZsdMRVKH8WouCAt5mMrKHIpPiJYtLU3NS4JEJYR19Cnc/kDU+dz+B9E9U+S1Y
         +T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vLSu1kPuflATDhPDFU0nGgb8Mr/kuY3eeM+ALkjRaYY=;
        b=EJxIy5bhcsUwOE6SOmUXtXm0lGMIfNSAfLk5I5mjMneEOGDOmlvvKmrja/aPzMmhxn
         xlSnnFL34h2HEpr+TL+o7QrCaOlQPJRcYhjwuQu6gg7/oA+hL7zy//VK2GQXhoQIxPKV
         +QklQC4X7NXvlW+1+Lcs3BgU3AwEc+hiNi8VhCt8v374g7BiGBT/pfO8/F861OK7PRUl
         /Hye3ITqKE0bB3DyehG3l8fP+QKoyXxvoLKc1Czwjq+oD4iLv+oZVWzgJKRt0TmZieEN
         +2lEO2vfzUVwsPUPe62e/g0i4IU06kr4mNadqd8Kxp1+2EGBomEkbO0hmZq0Kv7vQlCG
         7HKg==
X-Gm-Message-State: AOAM5323cDmcnkQLqVkdLa814gqNaQ+6bawHJ1lCOqKfzV8cMb9XSNsh
        s7W5rfGMIsdBVm8LPFC0Ljc9UQ==
X-Google-Smtp-Source: ABdhPJwW9B9ytkWVj20h9xxTTNI+Cy6YtKsqac7xXDLeFWj/S+Wtf5uJHdWPpxPzv5wWVSxNilo2jg==
X-Received: by 2002:a17:902:d68d:: with SMTP id v13mr1288772ply.10.1593012921553;
        Wed, 24 Jun 2020 08:35:21 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j70sm1221283pfd.208.2020.06.24.08.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 08:35:20 -0700 (PDT)
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
From:   Jens Axboe <axboe@kernel.dk>
To:     Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
 <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
Message-ID: <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
Date:   Wed, 24 Jun 2020 09:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/20 9:00 AM, Jens Axboe wrote:
> On 6/23/20 7:46 PM, Matthew Wilcox wrote:
>> On Wed, Jun 24, 2020 at 11:02:53AM +1000, Dave Chinner wrote:
>>> On Thu, Jun 18, 2020 at 08:43:45AM -0600, Jens Axboe wrote:
>>>> The read-ahead shouldn't block, so allow it to be done even if
>>>> IOCB_NOWAIT is set in the kiocb.
>>>
>>> Doesn't think break preadv2(RWF_NOWAIT) semantics for on buffered
>>> reads? i.e. this can now block on memory allocation for the page
>>> cache, which is something RWF_NOWAIT IO should not do....
>>
>> Yes.  This eventually ends up in page_cache_readahead_unbounded()
>> which gets its gfp flags from readahead_gfp_mask(mapping).
>>
>> I'd be quite happy to add a gfp_t to struct readahead_control.
>> The other thing I've been looking into for other reasons is adding
>> a memalloc_nowait_{save,restore}, which would avoid passing down
>> the gfp_t.
> 
> That was my first thought, having the memalloc_foo_save/restore for
> this. I don't think adding a gfp_t to readahead_control is going
> to be super useful, seems like the kind of thing that should be
> non-blocking by default.

We're already doing memalloc_nofs_save/restore in
page_cache_readahead_unbounded(), so I think all we need is to just do a
noio dance in generic_file_buffered_read() and that should be enough.

diff --git a/mm/filemap.c b/mm/filemap.c
index a5b1fa8f7ce4..c29d4b310ed6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -41,6 +41,7 @@
 #include <linux/delayacct.h>
 #include <linux/psi.h>
 #include <linux/ramfs.h>
+#include <linux/sched/mm.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -2011,6 +2012,7 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
 	struct file_ra_state *ra = &filp->f_ra;
+	const bool nowait = (iocb->ki_flags & IOCB_NOWAIT) != 0;
 	loff_t *ppos = &iocb->ki_pos;
 	pgoff_t index;
 	pgoff_t last_index;
@@ -2044,9 +2046,15 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 		page = find_get_page(mapping, index);
 		if (!page) {
+			unsigned int flags;
+
+			if (nowait)
+				flags = memalloc_noio_save();
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
+			if (nowait)
+				memalloc_noio_restore(flags);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
@@ -2070,7 +2078,7 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 				error = wait_on_page_locked_async(page,
 								iocb->ki_waitq);
 			} else {
-				if (iocb->ki_flags & IOCB_NOWAIT) {
+				if (nowait) {
 					put_page(page);
 					goto would_block;
 				}
@@ -2185,7 +2193,7 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 		}
 
 readpage:
-		if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (nowait) {
 			unlock_page(page);
 			put_page(page);
 			goto would_block;

-- 
Jens Axboe

