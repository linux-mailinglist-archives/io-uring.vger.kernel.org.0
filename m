Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5596736393F
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 04:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhDSCE0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Apr 2021 22:04:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232288AbhDSCEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Apr 2021 22:04:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618797836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y/DQcesXXNGI82SX8ndVgTAKV7N+8tegDuzwUqjcVZc=;
        b=XxnQOLOQX9cDWDTmJXuLbm8QczCWaKtV5dBs9766zmC1MqUNKXSfOSHL1rbQqzLPycxtjp
        npZWhvNwpiO+F9swE9Tc0w3oKH9ZKbiX/CCqT2P3xNFBoYo+mc4tjDG7fgq+GJFA1OpSFP
        79MqWm7DrmP6p9/weFKJAup4/8shaFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-RHCE9CRpPGmfa2ZH4t9Hrg-1; Sun, 18 Apr 2021 22:03:54 -0400
X-MC-Unique: RHCE9CRpPGmfa2ZH4t9Hrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFCDA501F5;
        Mon, 19 Apr 2021 02:03:52 +0000 (UTC)
Received: from T590 (ovpn-12-222.pek2.redhat.com [10.72.12.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0217A5B4B5;
        Mon, 19 Apr 2021 02:03:45 +0000 (UTC)
Date:   Mon, 19 Apr 2021 10:03:43 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Joakim Hassila <joj@mac.com>
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
Message-ID: <YHzk/1eID0WCrLUe@T590>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
 <YHkWdgLKBrH51GA7@google.com>
 <10b84fd7-4c40-3fe6-6993-061b524b1487@gmail.com>
 <YHmavyeoB6gQDuX2@T590>
 <YHmhD5wnVLceYyM7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHmhD5wnVLceYyM7@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 16, 2021 at 02:37:03PM +0000, Dennis Zhou wrote:
> On Fri, Apr 16, 2021 at 10:10:07PM +0800, Ming Lei wrote:
> > On Fri, Apr 16, 2021 at 02:16:41PM +0100, Pavel Begunkov wrote:
> > > On 16/04/2021 05:45, Dennis Zhou wrote:
> > > > Hello,
> > > > 
> > > > On Fri, Apr 16, 2021 at 01:22:51AM +0100, Pavel Begunkov wrote:
> > > >> Add percpu_ref_atomic_count(), which returns number of references of a
> > > >> percpu_ref switched prior into atomic mode, so the caller is responsible
> > > >> to make sure it's in the right mode.
> > > >>
> > > >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > >> ---
> > > >>  include/linux/percpu-refcount.h |  1 +
> > > >>  lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
> > > >>  2 files changed, 27 insertions(+)
> > > >>
> > > >> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> > > >> index 16c35a728b4c..0ff40e79efa2 100644
> > > >> --- a/include/linux/percpu-refcount.h
> > > >> +++ b/include/linux/percpu-refcount.h
> > > >> @@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> > > >>  void percpu_ref_resurrect(struct percpu_ref *ref);
> > > >>  void percpu_ref_reinit(struct percpu_ref *ref);
> > > >>  bool percpu_ref_is_zero(struct percpu_ref *ref);
> > > >> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref);
> > > >>  
> > > >>  /**
> > > >>   * percpu_ref_kill - drop the initial ref
> > > >> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> > > >> index a1071cdefb5a..56286995e2b8 100644
> > > >> --- a/lib/percpu-refcount.c
> > > >> +++ b/lib/percpu-refcount.c
> > > >> @@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
> > > >>  }
> > > >>  EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
> > > >>  
> > > >> +/**
> > > >> + * percpu_ref_atomic_count - returns number of left references
> > > >> + * @ref: percpu_ref to test
> > > >> + *
> > > >> + * This function is safe to call as long as @ref is switch into atomic mode,
> > > >> + * and is between init and exit.
> > > >> + */
> > > >> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref)
> > > >> +{
> > > >> +	unsigned long __percpu *percpu_count;
> > > >> +	unsigned long count, flags;
> > > >> +
> > > >> +	if (WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count)))
> > > >> +		return -1UL;
> > > >> +
> > > >> +	/* protect us from being destroyed */
> > > >> +	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
> > > >> +	if (ref->data)
> > > >> +		count = atomic_long_read(&ref->data->count);
> > > >> +	else
> > > >> +		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;
> > > > 
> > > > Sorry I missed Jens' patch before and also the update to percpu_ref.
> > > > However, I feel like I'm missing something. This isn't entirely related
> > > > to your patch, but I'm not following why percpu_count_ptr stores the
> > > > excess count of an exited percpu_ref and doesn't warn when it's not
> > > > zero. It seems like this should be an error if it's not 0?
> > > > 
> > > > Granted we have made some contract with the user to do the right thing,
> > > > but say someone does mess up, we don't indicate to them hey this ref is
> > > > actually dead and if they're waiting for it to go to 0, it never will.
> > > 
> > > fwiw, I copied is_zero, but skimming through the code don't immediately
> > > see myself why it is so...
> > > 
> > > Cc Ming, he split out some parts of it to dynamic allocation not too
> > > long ago, maybe he knows the trick.
> > 
> > I remembered that percpu_ref_is_zero() can be called even after percpu_ref_exit()
> > returns, and looks percpu_ref_is_zero() isn't classified into 'active use'.
> > 
> 
> Looking at the commit prior, it seems like percpu_ref_is_zero() was
> subject to the usual init and exit lifetime. I guess I'm just not
> convinced it should ever be > 0. I'll think about it a little longer and
> might fix it.

There may not be > 0 at that time, but it was allowed for
percpu_ref_is_zero() to read un-initialized refcount, and there was
such kernel oops report:

https://lore.kernel.org/lkml/165db20c-bfc5-fca8-1ecf-45d85ea5d9e2@kernel.dk/#r




Thanks, 
Ming

