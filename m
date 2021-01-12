Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FC42F353D
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 17:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392838AbhALQO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 11:14:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392988AbhALQO6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 11:14:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610468010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8VVj8uzJVAS58/MOCpmwRppKoO4gg0ZHwIr6CwsWf4=;
        b=OMwtnL15WJ/09USbqSzfK0xnLepvuwwIVA21GzaC/13eo/mKiA5oYV+B+CNzUf2rzFGOOv
        U+qOjc/9++YBufn/mugfDjFHL/RYZcXsTM0M87W1wh11agUcZkqRYfRRG2LPNusODyOmDk
        kefhz1bdB5GxEo2RKWZ3xbtLtZjb+Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-zZBIayBsO3aXkOA6UvE3NQ-1; Tue, 12 Jan 2021 11:13:27 -0500
X-MC-Unique: zZBIayBsO3aXkOA6UvE3NQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9AE918C8C03;
        Tue, 12 Jan 2021 16:13:25 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDEF66F969;
        Tue, 12 Jan 2021 16:13:21 +0000 (UTC)
Date:   Tue, 12 Jan 2021 11:13:21 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 6/7] block: track cookies of split bios for bio-based
 device
Message-ID: <20210112161320.GA13931@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-7-jefflexu@linux.alibaba.com>
 <20210107221825.GF21239@redhat.com>
 <97ec2025-4937-b476-4f15-446cc304e799@linux.alibaba.com>
 <20210108172635.GA29915@redhat.com>
 <16ba3a63-86f5-1acd-c129-767540186689@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16ba3a63-86f5-1acd-c129-767540186689@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 12 2021 at 12:46am -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 1/9/21 1:26 AM, Mike Snitzer wrote:
> > On Thu, Jan 07 2021 at 10:08pm -0500,
> > JeffleXu <jefflexu@linux.alibaba.com> wrote:
> > 
> >> Thanks for reviewing.
> >>
> >>
> >> On 1/8/21 6:18 AM, Mike Snitzer wrote:
> >>> On Wed, Dec 23 2020 at  6:26am -0500,
> >>> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >>>
> >>>> This is actuaaly the core when supporting iopoll for bio-based device.
> >>>>
> >>>> A list is maintained in the top bio (the original bio submitted to dm
> >>>> device), which is used to maintain all valid cookies of split bios. The
> >>>> IO polling routine will actually iterate this list and poll on
> >>>> corresponding hardware queues of the underlying mq devices.
> >>>>
> >>>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> >>>
> >>> Like I said in response to patch 4 in this series: please fold patch 4
> >>> into this patch and _really_ improve this patch header.
> >>>
> >>> In particular, the (ab)use of bio_inc_remaining() needs be documented in
> >>> this patch header very well.
> >>>
> >>> But its use could easily be why you're seeing a performance hit (coupled
> >>> with the extra spinlock locking and list management used).  Just added
> >>> latency and contention across CPUs.
> >>
> >> Indeed bio_inc_remaining() is abused here and the code seems quite hacky
> >> here.
> >>
> >> Actually I'm regarding implementing the split bio tracking mechanism in
> >> a recursive way you had ever suggested. That is, the split bios could be
> >> maintained in an array, which is allocated with 'struct dm_io'. This way
> >> the overhead of spinlock protecting the &root->bi_plist may be omitted
> >> here. Also the lifetime management may be simplified somehow. But the
> >> block core needs to fetch the per-bio private data now, just like what
> >> you had ever suggested before.
> >>
> >> How do you think, Mike?
> > 
> > Yes, using per-bio-data is a requirement (we cannot bloat 'struct bio').
> 
> Agreed. Then MD will need some refactor to support IO polling, if
> possible, since just like I mentioned in patch 0 before, MD doesn't
> allocate extra clone bio, and just re-uses the original bio structure.
> 
> 
> > 
> > As for using an array, how would you index the array?  
> 
> The 'array' here is not an array of 'struct blk_mq_hw_ctx *' maintained
> in struct dm_table as you mentioned. Actually what I mean is to maintain
> an array of struct dm_poll_data (or something like that, e.g. just
> struct blk_mq_hw_ctx *) in per-bio private data. The size of the array
> just equals the number of the target devices.
> 
> For example, for the following device stack,
> 
> >>
> >> Suppose we have the following device stack hierarchy, that is, dm0 is
> >> stacked on dm1, while dm1 is stacked on nvme0 and nvme1.
> >>
> >>     dm0
> >>     dm1
> >> nvme0  nvme1
> >>
> >>
> >> Then the bio graph is like:
> >>
> >>
> >>                                    +------------+
> >>                                    |bio0(to dm0)|
> >>                                    +------------+
> >>                                          ^
> >>                                          | orig_bio
> >>                                    +--------------------+
> >>                                    |struct dm_io A      |
> >> +--------------------+ bi_private  ----------------------
> >> |bio3(to dm1)        |------------>|bio1(to dm1)        |
> >> +--------------------+             +--------------------+
> >>         ^                                ^
> >>         | ->orig_bio                     | ->orig_bio
> >> +--------------------+             +--------------------+
> >> |struct dm_io        |             |struct dm_io B      |
> >> ----------------------             ----------------------
> >> |bio2(to nvme0)      |             |bio4(to nvme1)      |
> >> +--------------------+             +--------------------+
> >>
> 
> An array of struct blk_mq_hw_ctx * is maintained in struct dm_io B.
> 
> 
> struct blk_mq_hw_ctx * hctxs[2];
> 
> The array size is two since dm1 maps to two target devices (i.e. nvme0
> and nvme1). Then hctxs[0] points to the hw queue of nvme0, while
> hctxs[1] points to the hw queue of nvme1.

Both nvme0 and nvme1 may have multiple hctxs.  Not sure why you're
thinking there is just one per device?

> 
> 
> This mechanism supports arbitrary device stacking. Similarly, an array
> of struct blk_mq_hw_ctx * is maintained in struct dm_io A. The array
> size is one since dm0 only maps to one target device (i.e. dm1). In this
> case, hctx[0] points to the struct dm_io of the next level, i.e. struct
> dm_io B.
> 
> 
> But I'm afraid the implementation of this style may be more complex.

We are running the risk of talking in circles about this design...


> >> struct node {
> >>     struct blk_mq_hw_ctx *hctx;
> >>     blk_qc_t cookie;
> >> };
> > 
> > Needs a better name, think I had 'struct dm_poll_data'
> 
> Sure, the name here is just for example.
> 
> 
> >  
> >> Actually currently the tracking objects are all allocated with 'struct
> >> bio', then the lifetime management of the tracking objects is actually
> >> equivalent to lifetime management of bio. Since the returned cookie is
> >> actually a pointer to the bio, the refcount of this bio must be
> >> incremented, since we release a reference to this bio through the
> >> returned cookie, in which case the abuse of the refcount trick seems
> >> unavoidable? Unless we allocate the tracking object individually, then
> >> the returned cookie is actually pointing to the tracking object, and the
> >> refcount is individually maintained for the tracking object.
> > 
> > The refcounting and lifetime of the per-bio-data should all work as is.
> > Would hope you can avoid extra bio_inc_remaining().. that infratsructure
> > is way too tightly coupled to bio_chain()'ing, etc.
> > 
> > The challenge you have is the array that would point at these various
> > per-bio-data needs to be rooted somewhere (you put it in the topmost
> > original bio with the current patchset).  But why not manage that as
> > part of 'struct mapped_device'?  It'd need proper management at DM table
> > reload boundaries and such but it seems like the most logical place to
> > put the array.  But again, this array needs to be dynamic.. so thinking
> > further, maybe a better model would be to have a fixed array in 'struct
> > dm_table' for each hctx associated with a blk_mq _data_ device directly
> > used/managed by that dm_table?
> 
> It seems that you are referring 'array' here as an array of 'struct
> blk_mq_hw_ctx *'? Such as
> 
> struct dm_table {
>     ...
>     struct blk_mq_hw_ctx *hctxs[];
> };
> 
> Certainly with this we can replace the original 'struct blk_mq_hw_ctx *'
> pointer in 'struct dm_poll_data' with the index into this array, such as
> 
> struct dm_poll_data {
>      int hctx_index; /* index into dm_table->hctxs[] */
>      blk_qc_t cookie;
> };

You seized on my mentioning blk-mq's array of hctx too literally.  I was
illustrating that blk-mq's cookie is converted to an index into that
array.

But for this DM bio-polling application we'd need to map the blk-mq
returned cookie to a request_queue.  Hence the original 2 members of
dm_poll_data needing to be 'struct request_queue *' and blk_qc_t.

> But I'm doubted if this makes much sense. The core difficulty here is
> maintaining a list (or dynamic sized array) to track all split bios.
> With the array of 'struct blk_mq_hw_ctx *' maintained in struct
> dm_table, we still need some **per-bio** structure (e.g., &bio->bi_plist
> in current patch set) to track these split bios.

One primary goal of all of this design is to achieve bio-polling cleanly
(without extra locking, without block core data structure bloat, etc).
I know you share that goal.  But we need to nail down the core data
structures and what needs tracking at scale and then associate them with
DM's associated objects with consideration for object lifetime.

My suggestion was to anchor your core data structures (e.g. 'struct
dm_poll_data' array, etc) to 'struct dm_table'.  I suggested that
because the dm_table is what dm_get_device()s each underlying _data_
device (a subset of all devices in a dm_table, as iterated through
.iterate_devices).  But a DM 'struct mapped_device' has 2 potential
dm_tables, active and inactive slots, that would imply some complexity
in handing off any outstanding bio's associated 'struct dm_poll_data'
array on DM table reload.

Anyway, you seem to be gravitating to a more simplistic approach of a
single array of 'struct dm_poll_data' for each DM device (regardless of
how arbitrarily deep that DM device stack is, the topmost DM device
would accumulate the list of 'struct dm_poll_data'?).

I'm now questioning the need for any high-level data structure to track
all N of the 'struct dm_poll_data' that may result from a given bio (as
it is split to multiple blk-mq hctxs across multiple blk-mq devices).
Each 'struct dm_poll_data', that will be returned to block core and
stored in struct kiocb's ki_cookie, would have an object lifetime that
matches the original DM bio clone's per-bio-data that the 'struct
dm_poll_data' was part of; then we just need to cast that ki_cookie's
blk_qc_t as 'struct dm_poll_data' and call blk_poll().

The hardest part is to ensure that all the disparate 'struct
dm_poll_data' (and associated clone bios) aren't free'd until the
_original_ bio completes.  That would create quite some back-pressure
with more potential to exhaust system resources -- because then the
cataylst for dropping reference counts on these clone bios would then
need to be tied to the blk_bio_poll() interface... which feels "wrong"
(e.g. it ushers in the (ab)use of bio_inc_remaining you had in your most
recent patchset).

All said, maybe post a v2 that takes the incremental steps of:
1) using DM per-bio-data for 'struct dm_poll_data'
2) simplify blk_bio_poll() to call into DM to translate provided
   blk_qc_t (from struct kiocb's ki_cookie) to request_queue and
   blk_qc_t.
   - this eliminates any need for extra list processing
3) keep your (ab)use of bio_inc_remaining() to allow for exploring this

?

Thanks,
Mike

