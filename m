Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D71299770
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 20:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJZTyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 15:54:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbgJZTyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 15:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603742055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+ygbaZYTXSBgEc08s3LTYIAJjy/tB9+jiaQvyHg/KA=;
        b=hpHspJvxv3sOU4JVhEP27IHkk6c+02+vI2zgYQhCHPeyYPjxWSuU86N2xKgCuWGDM2au97
        Gk0d5Rqf/o2EL8O70mj5w3ZRbw5r6VIfjFHUehrifkbbVs3wpS6k0qGH/Wt2+CM16vIVI3
        TpVBySLXxI5HVuiD+RcdUmuYLGhLXsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-fspvHgfcO5iTjScUXMHpuw-1; Mon, 26 Oct 2020 15:54:05 -0400
X-MC-Unique: fspvHgfcO5iTjScUXMHpuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C276409F;
        Mon, 26 Oct 2020 19:54:04 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6957210013C0;
        Mon, 26 Oct 2020 19:54:00 +0000 (UTC)
Date:   Mon, 26 Oct 2020 14:53:35 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        joseph.qi@linux.alibaba.com, xiaoguang.wang@linux.alibaba.com,
        haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [RFC 0/3] Add support of iopoll for dm device
Message-ID: <20201026185334.GA8463@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
 <20201021203906.GA10896@redhat.com>
 <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 22 2020 at  1:28am -0400,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> On 10/22/20 4:39 AM, Mike Snitzer wrote:
> 
> >What you've _done_ could serve as a stop-gap but I'd really rather we
> >get it properly designed from the start.
> 
> Indeed I totally agree with you that the design should be done
> nicely at the very beginning. And this
> 
> is indeed the purpose of this RFC patch.
> 
> 
> >>This patch set adds support of iopoll for dm device.
> >>
> >>This is only an RFC patch. I'm really looking forward getting your
> >>feedbacks on if you're interested in supporting iopoll for dm device,
> >>or if there's a better design to implement that.
> >>
> >>Thanks.
> >>
> >>
> >>[Purpose]
> >>IO polling is an important mode of io_uring. Currently only mq devices
> >>support iopoll. As for dm devices, only dm-multipath is request-base,
> >>while others are all bio-based and have no support for iopoll.
> >>Supporting iopoll for dm devices can be of great meaning when the
> >>device seen by application is dm device such as dm-linear/dm-stripe,
> >>in which case iopoll is not usable for io_uring.
> >I appreciate you taking the initiative on this; polling support is on my
> >TODO so your work serves as a nice reminder to pursue this more
> >urgently.
> 
> It's a good news that iopoll for DM is meaningful.
> 
> 
> >but we cannot avoid properly mapping a cookie to each
> >split bio.  Otherwise you resort to inefficiently polling everything.
> 
> Yes. At the very beginning  I tried to build the mapping a cookie to
> each bio, but I failed with several
> 
> blocking design issues. By the way maybe we could clarify these
> design issues here, if you'd like.

Biggest issue I'm seeing is that block core's bio-based IO submission
implementation really never seriously carried the blk_qc_t changes
through. The cookie return from __submit_bio is thrown away when
recursion occurs in __submit_bio_noacct -- last bio submission's cookie
is what is returned back to caller.  That cookie could be very far
removed from all the others returned earlier in the recursion.

Fixing this would require quite some design and cleanup.

> >Seems your attempt to have the cookie point to a dm_io object was likely
> >too coarse-grained (when bios are split they get their own dm_io on
> >recursive re-entry to DM core from ->submit_bio); but isn't having a
> >list of cookies still too imprecise for polling purposes?  You could
> >easily have a list that translates to many blk-mq queues.  Possibly
> >better than your current approach of polling everything -- but not
> >much.
> 
> To make the discussion more specific, assume that dm0 is mapped to
> dm1/2/3, while dm1 mapped to
> 
> nvme1, dm2 mapped to dm2, etc..
> 
>                     dm0
> 
> dm1             dm2            dm3
> 
> nvme1        nvme2        nvme3
> 
> 
> Then the returned cookie of dm0 could be pointer pointing to dm_io
> object of dm0.
> 
> struct dm_io {  // the returned cookie points to dm_io object
> 	...
> +	struct list_head cookies;
> };
> 
> struct dm_target_io {
> 	...
> 	/*
> 	 * The corresponding polling hw queue if submitted to mq device (such as nvme1/2/3),
> 	 * NULL if submitted to dm device (such as dm1/2/3)
> 	 */
> +	struct blk_mq_hw_ctx *hctx;
> +	struct list_head      node;  // add to @cookies list
> };
> 
> The @cookies list of dm_io object could maintain all dm_target_io objects
> of all **none-dm** devices, that is, all hw queues that we should poll on.
> 
> 
> returned  ->  @cookies list	
> cookie	      of dm_io object of dm0
> 		   |
> 		   +--> dm_target_io	 ->  dm_target_io     ->  dm_target_io
> 			object of nvme1      object of nvme2	  object of nvme3
> 
> When polling returned cookie of dm0, actually we're polling @cookies
> list. Once one of the dm_target_io
> 
> completed (e.g. nvme2), it should be removed from the @cookies
> list., and thus we should only focus on
> 
> hw queues that have not completed.

What you detailed there isn't properly modeling what it needs to.
A given dm_target_io could result in quite a few bios (e.g. for
dm-striped we clone each bio for each of N stripes).  So the fan-out,
especially if then stacked on N layers of stacked devices, to all the
various hctx at the lowest layers is like herding cats.

But the recursion in block core's submit_bio path makes that challenging
to say the least.  So much so that any solution related to enabling
proper bio-based IO polling is going to need a pretty significant
investment in fixing block core (storing __submit_bio()'s cookie during
recursion, possibly storing to driver provided memory location,
e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a DM
clone bio's per-bio-data).

SO __submit_bio_noacct would become:

   retp = &ret; 
   if (bio->submit_cookie)
          retp = bio->submit_cookie;
   *retp = __submit_bio(bio);

> >>[Design Notes]
> >>
> >>cookie
> >>------
> >>Let's start from cookie. Cookie is one important concept in iopoll. It
> >>is used to identify one specific request in one specific hardware queue.
> >>The concept of cookie is initially designed as a per-bio concept, and
> >>thus it doesn't work well when bio-split involved. When bio is split,
> >>the returned cookie is indeed the cookie of one of the split bio, and
> >>the following polling on this returned cookie can only guarantee the
> >>completion of this specific split bio, while the other split bios may
> >>be still uncompleted. Bio-split is also resolved for dm device, though
> >>in another form, in which case the original bio submitted to the dm
> >>device may be split into multiple bios submitted to the underlying
> >>devices.
> >>
> >>In previous discussion, Lei Ming has suggested that iopoll should be
> >>disabled for bio-split. This works for the normal bio-split (done in
> >>blk_mq_submit_bio->__blk_queue_split), while iopoll will never be
> >>usable for dm devices if this also applies for dm device.
> >>
> >>So come back to the design of the cookie for dm devices. At the very
> >>beginning I want to refactor the design of cookie, from 'unsigned int'
> >>type to the pointer type for dm device, so that cookie can point to
> >>something, e.g. a list containing all cookies of one original bio,
> >>something like this:
> >>
> >>struct dm_io { // the returned cookie points to dm_io
> >>	...
> >>	struct list_head cookies;
> >>};
> >>
> >>In this design, we can fetch all cookies of one original bio, but the
> >>implementation can be difficult and buggy. For example, the
> >>'struct dm_io' structure may be already freed when the returned cookie
> >>is used in blk_poll(). Then what if maintain a refcount in struct dm_io
> >>so that 'struct dm_io' structure can not be freed until blk_poll()
> >>called? Then the 'struct dm_io' structure will never be freed if the
> >>IO polling is not used at all.
> >I'd have to look closer at the race in the code you wrote (though you
> >didn't share it);
> 
> I worried that dm_target_io/dm_io objects could have been freed
> before/when we are polling on them,
> 
> and thus could cause use-after-free when accessing @cookies list in
> dm_target_io. It could happen
> 
> when there are multiple polling instance. io_uring has implemented
> per-instance polling thread. If
> 
> there are two bios submitted to dm0, please consider the following
> race sequence:

The lifetime of the bios should be fine given that the cloning nature of
DM requires that all clones complete before the origin may complete.

I think you probably just got caught out by the recursive nature of the bio
submission path -- makes creating a graph of submitted bios and their
associated per-bio-data and generated cookies a mess to track (again,
like herding cats).

Could also be you didn't quite understand the DM code's various
structures.

In any case, the block core changes needed to make bio-based IO polling
work is the main limiting factor right now.

Not sure it is worth the investment... but I could be persuaded to try
harder! ;)

But then once block core is fixed to allow this, we _still_ need to link
all the various 'struct dm_poll_data' structures to allow blk_poll()
to call DM specific method to walk all in the list to calling blk_poll()
for stored cookie and request_queue*, e.g.:

struct dm_poll_data {
       blk_qc_t cookie;
       struct request_queue *queue;
       struct list_head list;
};

Again, it is the recursive nature of submit_bio() that makes this
challenging.

Mike

