Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129AE691697
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 03:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBJCQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 21:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjBJCQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 21:16:12 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BF56F8C4
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 18:16:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so4147072pjb.5
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 18:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmdsJe5VjS6cGWRPCrFBEnJ1Stz+m8nOHf+xEJbc8Ro=;
        b=J8IifK/DvnXJNvhWBvQbcKdHIoBmbbPZ9GmygmQqrNwBSb1pD/HNZOZeiWQSwCoPci
         NP3OTrWJb/g+vFhmEllum5yKYw4HmSuTpSf7i55JPj2Otjj8Ztgyi8fAQxheouAVG5gr
         feUmWCgQKTCr0LdxXWejJcCO5GBTd8ROY77qtZY0Fa02CnRZBNcoPEAQeGO7e2TtM9Yj
         8HlgeD73o8w0RL3OTbBGYNgFkV2ABhQP1834I5JNDAQmI5VJyB6at/AfhIBmtmrZ5zt7
         LFe2GAliMmn6fR9D5GkGQJU5ayikMCd3K9h34G22YIj2ial/gBGc15dVfeAuO9Woi5dM
         NBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmdsJe5VjS6cGWRPCrFBEnJ1Stz+m8nOHf+xEJbc8Ro=;
        b=HSUus7bHb0fKCgZzAQZhKdzwnhc+VxCB7S7Dw4DEBkOYhAiIAD3azGE70r1asb8MiJ
         Bo57tGuqC1cGEJulpScA4JsNxu748fVkGcginRz9igncVjhClADnBmbmO3r3F22SDaCa
         sRuNf8Oaw4lCLzD+5msRG+HuytWrUk80oCt5taiudEE115wnUL7Ah+M0Dw7vD65GU+ln
         6us7IFFOsPL2CJeaT/HzGU93gci77NQNHcTDlFb7PACaOSrUjfev3+/KxmebF8EmPTjl
         vpAa06qYXFY2+TSHrSTyQfX1vubNlrMJ84XW4P3vGHnACN0Y3WZKOTjtqlZi11VgIbb9
         vRXw==
X-Gm-Message-State: AO0yUKVj9lPWa+w1tcCdRytY1BtJYRyw6HnFxtxxZWYwuQkEx3dD7w8C
        /xM/tcNf2FYfKlQgasHVCLLNuw==
X-Google-Smtp-Source: AK7set/5M4194uBmFaxqcnUSG3dAq8TXSG1+LxNlv7e9evS+gIEFmcux2K3a5fEecC8rDIi5Jlct7Q==
X-Received: by 2002:a17:902:6b81:b0:199:bcb:3dae with SMTP id p1-20020a1709026b8100b001990bcb3daemr10334823plk.56.1675995366933;
        Thu, 09 Feb 2023 18:16:06 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902eb4500b00199080af237sm2197368pli.115.2023.02.09.18.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:16:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQIxH-00DSdE-UH; Fri, 10 Feb 2023 13:16:03 +1100
Date:   Fri, 10 Feb 2023 13:16:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <20230210021603.GA2825702@dread.disaster.area>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 09, 2023 at 08:41:02AM -0800, Linus Torvalds wrote:
> Adding Jens, because he's one of the main splice people. You do seem
> to be stepping on his work ;)
> 
> Jens, see
> 
>   https://lore.kernel.org/lkml/0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org
> 
> On Thu, Feb 9, 2023 at 5:56 AM Stefan Metzmacher <metze@samba.org> wrote:
> >
> > So we have two cases:
> >
> > 1. network -> socket -> splice -> pipe -> splice -> file -> storage
> >
> > 2. storage -> file -> splice -> pipe -> splice -> socket -> network
> >
> > With 1. I guess everything can work reliable [..]
> >
> > But with 2. there's a problem, as the pages from the file,
> > which are spliced into the pipe are still shared without
> > copy on write with the file(system).
> 
> Well, honestly, that's really the whole point of splice. It was
> designed to be a way to share the storage data without having to go
> through a copy.
> 
> > I'm wondering if there's a possible way out of this, maybe triggered by a new
> > flag passed to splice.
> 
> Not really.
> 
> So basically, you cannot do "copy on write" on a page cache page,
> because that breaks sharing.
> 
> You *want* the sharing to break, but that's because you're violating
> what splice() was for, but think about all the cases where somebody is
> just using mmap() and expects to see the file changes.
> 
> You also aren't thinking of the case where the page is already mapped
> writably, and user processes may be changing the data at any time.
> 
> > I looked through the code and noticed the existence of IOMAP_F_SHARED.
> 
> Yeah, no. That's a hacky filesystem thing. It's not even a flag in
> anything core like 'struct page', it's just entirely internal to the
> filesystem itself.

It's the mechanism that the filesystem uses to tell the generic
write IO path that the filesystem needs to allocate a new COW extent
in the backing store because it can't write to the original extent.
i.e. it's not allowed to overwrite in place.

It's no different to the VM_SHARED flag in the vma so the generic
page fault path knows if it has to allocate a new COW page to take
place on a write fault because it can't write to the original page.
i.e. it's not allowed to overwrite in place.

So by the same measure, VM_SHARED is a "hacky mm thing". It's not
even a flag in anything core like 'struct page', it's just entirely
internal to the mm subsystem itself.

COW is COW is COW no matter which layer implements. :/

> > Is there any other way we could archive something like this?
> 
> I suspect you simply want to copy it at splice time, rather than push
> the page itself into the pipe as we do in copy_page_to_iter_pipe().
> 
> Because the whole point of zero-copy really is that zero copy. And the
> whole point of splice() was to *not* complicate the rest of the system
> over-much, while allowing special cases.
> 
> Linux is not the heap of bad ideas that is Hurd that does various
> versioning etc, and that made copy-on-write a first-class citizen
> because it uses the concept of "immutable mapped data" for reads and
> writes.
> 
> Now, I do see a couple of possible alternatives to "just create a stable copy".
> 
> For example, we very much have the notion of "confirm buffer data
> before copying". It's used for things like "I started the IO on the
> page, but the IO failed with an error, so even though I gave you a
> splice buffer, it turns out you can't use it".
> 
> And I do wonder if we could introduce a notion of "optimistic splice",
> where the splice works exactly the way it does now (you get a page
> reference), but the "confirm" phase could check whether something has
> changed in that mapping (using the file versioning or whatever - I'm
> hand-waving) and simply fail the confirm.
> 
> That would mean that the "splice to socket" part would fail in your
> chain, and you'd have to re-try it. But then the onus would be on
> *you* as a splicer, not on the rest of the system to fix up your
> special case.
> 
> That idea sounds fairly far out there, and complicated and maybe not
> usable. So I'm just throwing it out as a "let's try to think of
> alternative solutions".

Oh, that's sounds like an exact analogy to the new IOMAP_F_STALE
flag and the validity cookie we have in the iomap write path code.
The iomap contains cached, unserialised information, and the
filesystem side mapping it is derived from can change asynchronously
(e.g. by IO completion doing unwritten extent conversion). Hence the
cached iomap can become stale, and that's a data corruption vector.

The validity cookie is created when the iomap is built, and it is
passed to a filesystem callback when a folio is locked for copy-in.
This allows the IO path to detect that the filesystem side extent
map has changed during the write() operations before we modify the
contents of the folio. It is done under the locked folio so that the
validation is atomic w.r.t. the modification to the folio contents
we are about to perform.

On detection of a cookie mismatch, the write operation then sets the
IOMAP_F_STALE flag, backs out of the write to that page and ends the
write to the iomap. The iomap infrastructure then remaps the file
range from the offset of the folio at which the iomap change was
detected.  The write the proceeds with the new, up to date iomap....

We have had a similar "is the cached iomap still valid?" mechanism
on the writeback side of the page cache for years. The details are
slightly different, though I plan to move that code to use the same
IOMAP_F_STALE infrastructure in the near future because it
simplifies the writeback context wrapper shenanigans an awful lot.
And it helps make it explicit that iomaps are cached/shadowed
state, not the canonical source of reality.

Applying the same principle it to multiply referenced cached page
contents will be more complex. I suspect we might be able to
leverage inode->i_version or ctime as the "data changed" cookie as
they are both supposed to change on every explicit user data
modification made to an inode. However, I think most of the
complexity would be in requiring spliced pages to travel in some
kind of container that holds the necessary verification
information....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
