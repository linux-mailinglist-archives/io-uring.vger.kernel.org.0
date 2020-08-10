Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE6241382
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 01:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHJXDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 19:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgHJXDa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 19:03:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1E6C061787
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 16:03:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so5884061plt.3
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 16:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RhGl5aAnfF/BQXqz/MC7L9FOMBP1d+PqSfo/ugCUrnc=;
        b=vKzfUH8mbF/lhof7jqzTDAHUZg2nS8pYqAocFG+3PGEPxsrMyQYSoVhkjSrt63Ugjo
         3mzhxjfv0Rm3DVkE8BiamPLYiwqpUOsYeZkY+W+EBp4KRiexXmERkpUFMbn8jYE0sTdS
         MfhvSYIPzaWdV3C6E21CsVDz4rpJUdIyB59cAWL4/98gJwUeSSTTogyyEyOXh1GMQjBG
         S9CsrDhpAKnCcV74+chwfTO+BQuJKcw6pHsIrC8zvHCx/9B67dL1n2ObhQ/wUIhmx9O9
         FNmsUCkH5l+VeKFlR2BJPOGxAs5ErebttAMIucVy2/QjIQtbUPDd/nM3NzduIKcWMGXH
         Z0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RhGl5aAnfF/BQXqz/MC7L9FOMBP1d+PqSfo/ugCUrnc=;
        b=tKwH9FthlxiRZMsjPZVBznrmOfZrUE26l+AupRLUKoC1Ahj6XKgfcygvTS4gV3Aofp
         p7WNQiqYt/3Zg45jqvsG+5DpPm+Jr5s2ckGt5KrXvvxqRPHvWNMtRHaavmufvENNlyLH
         xjMKvW9UdypY2UPEndmNuAc0N0STCJr8qvSODL6ki4Dzg/Ooh7YKu2ZS4y+f5044L0Dk
         2ts+KwAESpYhC+QvST5FBFBANsuW+OM+cpFPCzcaruNQ/04dPmUkWszm8l/L6H8M5Mgd
         VK9A3pYtub0JPHIx/xr/BK4i55TsHLw52KTfpJVnKhLH7r82nSSuHbil8AlK3PJkZrVk
         ra6Q==
X-Gm-Message-State: AOAM532m7vH6CF1pGbnx9uuH5lzuhGqzw9Z9+/MP3gN68oMeTXhK4Vlw
        EY5nsDFAhd4rlW0JDROnb5WGdA==
X-Google-Smtp-Source: ABdhPJxaG+83Ln1EMRF7FhBciv88ind8OKJkJj4KMWNkMA4RDPdpHXJzQxhM3X6nIafRMxmlUU1yFQ==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr26879095plr.27.1597100609171;
        Mon, 10 Aug 2020 16:03:29 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z25sm23545541pfg.150.2020.08.10.16.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:03:28 -0700 (PDT)
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
 <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
 <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
 <20200624164127.GP21350@casper.infradead.org>
 <8835b6f2-b3c5-c9a0-2119-1fb161cf87dd@kernel.dk>
 <20200810225601.GE2079@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf2384d3-8707-3a83-a667-8a0024867cdb@kernel.dk>
Date:   Mon, 10 Aug 2020 17:03:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810225601.GE2079@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 4:56 PM, Dave Chinner wrote:
> On Wed, Jun 24, 2020 at 10:44:21AM -0600, Jens Axboe wrote:
>> On 6/24/20 10:41 AM, Matthew Wilcox wrote:
>>> On Wed, Jun 24, 2020 at 09:35:19AM -0600, Jens Axboe wrote:
>>>> On 6/24/20 9:00 AM, Jens Axboe wrote:
>>>>> On 6/23/20 7:46 PM, Matthew Wilcox wrote:
>>>>>> I'd be quite happy to add a gfp_t to struct readahead_control.
>>>>>> The other thing I've been looking into for other reasons is adding
>>>>>> a memalloc_nowait_{save,restore}, which would avoid passing down
>>>>>> the gfp_t.
>>>>>
>>>>> That was my first thought, having the memalloc_foo_save/restore for
>>>>> this. I don't think adding a gfp_t to readahead_control is going
>>>>> to be super useful, seems like the kind of thing that should be
>>>>> non-blocking by default.
>>>>
>>>> We're already doing memalloc_nofs_save/restore in
>>>> page_cache_readahead_unbounded(), so I think all we need is to just do a
>>>> noio dance in generic_file_buffered_read() and that should be enough.
>>>
>>> I think we can still sleep though, right?  I was thinking more
>>> like this:
>>>
>>> http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
>>
>> Yeah, that's probably better. How do we want to handle this? I've already
>> got the other bits queued up. I can either add them to the series, or
>> pull a branch that'll go into Linus as well.
> 
> Jens, Willy,
> 
> Now that this patch has been merged and IOCB_NOWAIT semantics ifor
> buffered reads are broken in Linus' tree, what's the plan to get
> this regression fixed before 5.9 releases?

Not sure where Willy's work went on this topic, but it is on my radar. But
I think we can do something truly simple now that we have IOCB_NOIO:


diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd7ec3eaeed0..f1cca4bfdd7b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3293,7 +3293,7 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 	if (flags & RWF_NOWAIT) {
 		if (!(ki->ki_filp->f_mode & FMODE_NOWAIT))
 			return -EOPNOTSUPP;
-		kiocb_flags |= IOCB_NOWAIT;
+		kiocb_flags |= IOCB_NOWAIT | IOCB_NOIO;
 	}
 	if (flags & RWF_HIPRI)
 		kiocb_flags |= IOCB_HIPRI;

-- 
Jens Axboe

