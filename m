Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE57D362269
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 16:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhDPOhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 10:37:32 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:44753 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhDPOha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 10:37:30 -0400
Received: by mail-io1-f51.google.com with SMTP id p8so6508771iol.11
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 07:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H1203LGBnNoQUgSTH270NERX3TgfkDF0UOee0S+U85I=;
        b=S/bliwRTcFxFvr6Z2TdkcJ4lcETNUfSxubsM4TOTkVo1DDjXkEVbTUD6EBU4ZoL/tM
         QXihs8lBioejDEGbwf+OpSG8ukZeU3QNPEmkjUKubINCs+oFtaE5F2arpKpRocMLbTPe
         68yn+8uSyYN9YkMJwHHZvLKBY1FPDXSOhlagJPcX4kAJ2zvUg1NpCEGNNdM5/Fvv4pra
         yt3y4KQ92Sjx+6FK0CuENZ1t7ABcgv03rF1A7uA3eAIs5HA0Wf4sdDuSArf3VNdXpaWo
         lRERZ6YFIpainPfR+4ovx4JSoQRM4tBdaEyXJh2eXcZNm/ixuvDcXkS5J+DY/kEbaqMu
         pdVQ==
X-Gm-Message-State: AOAM533ZpYWs9sWwi2FlI3aPoM7l57FMUaZH1Tki/on1z4aeqiWKD50P
        f2UHWVhO9UNKSpIXkBcnW9I=
X-Google-Smtp-Source: ABdhPJyYPz+IvB9jeTcHsXXFIyEuLc5LQTx2qPvQdxeFLs9xFWEOdTpLvo81wG1BFJCailJG+LEg9Q==
X-Received: by 2002:a5d:850c:: with SMTP id q12mr3747836ion.13.1618583825520;
        Fri, 16 Apr 2021 07:37:05 -0700 (PDT)
Received: from google.com (243.199.238.35.bc.googleusercontent.com. [35.238.199.243])
        by smtp.gmail.com with ESMTPSA id h30sm2800394ila.15.2021.04.16.07.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 07:37:04 -0700 (PDT)
Date:   Fri, 16 Apr 2021 14:37:03 +0000
From:   Dennis Zhou <dennis@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Joakim Hassila <joj@mac.com>
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
Message-ID: <YHmhD5wnVLceYyM7@google.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
 <YHkWdgLKBrH51GA7@google.com>
 <10b84fd7-4c40-3fe6-6993-061b524b1487@gmail.com>
 <YHmavyeoB6gQDuX2@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHmavyeoB6gQDuX2@T590>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 16, 2021 at 10:10:07PM +0800, Ming Lei wrote:
> On Fri, Apr 16, 2021 at 02:16:41PM +0100, Pavel Begunkov wrote:
> > On 16/04/2021 05:45, Dennis Zhou wrote:
> > > Hello,
> > > 
> > > On Fri, Apr 16, 2021 at 01:22:51AM +0100, Pavel Begunkov wrote:
> > >> Add percpu_ref_atomic_count(), which returns number of references of a
> > >> percpu_ref switched prior into atomic mode, so the caller is responsible
> > >> to make sure it's in the right mode.
> > >>
> > >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > >> ---
> > >>  include/linux/percpu-refcount.h |  1 +
> > >>  lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
> > >>  2 files changed, 27 insertions(+)
> > >>
> > >> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> > >> index 16c35a728b4c..0ff40e79efa2 100644
> > >> --- a/include/linux/percpu-refcount.h
> > >> +++ b/include/linux/percpu-refcount.h
> > >> @@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> > >>  void percpu_ref_resurrect(struct percpu_ref *ref);
> > >>  void percpu_ref_reinit(struct percpu_ref *ref);
> > >>  bool percpu_ref_is_zero(struct percpu_ref *ref);
> > >> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref);
> > >>  
> > >>  /**
> > >>   * percpu_ref_kill - drop the initial ref
> > >> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> > >> index a1071cdefb5a..56286995e2b8 100644
> > >> --- a/lib/percpu-refcount.c
> > >> +++ b/lib/percpu-refcount.c
> > >> @@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
> > >>  
> > >> +/**
> > >> + * percpu_ref_atomic_count - returns number of left references
> > >> + * @ref: percpu_ref to test
> > >> + *
> > >> + * This function is safe to call as long as @ref is switch into atomic mode,
> > >> + * and is between init and exit.
> > >> + */
> > >> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref)
> > >> +{
> > >> +	unsigned long __percpu *percpu_count;
> > >> +	unsigned long count, flags;
> > >> +
> > >> +	if (WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count)))
> > >> +		return -1UL;
> > >> +
> > >> +	/* protect us from being destroyed */
> > >> +	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
> > >> +	if (ref->data)
> > >> +		count = atomic_long_read(&ref->data->count);
> > >> +	else
> > >> +		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;
> > > 
> > > Sorry I missed Jens' patch before and also the update to percpu_ref.
> > > However, I feel like I'm missing something. This isn't entirely related
> > > to your patch, but I'm not following why percpu_count_ptr stores the
> > > excess count of an exited percpu_ref and doesn't warn when it's not
> > > zero. It seems like this should be an error if it's not 0?
> > > 
> > > Granted we have made some contract with the user to do the right thing,
> > > but say someone does mess up, we don't indicate to them hey this ref is
> > > actually dead and if they're waiting for it to go to 0, it never will.
> > 
> > fwiw, I copied is_zero, but skimming through the code don't immediately
> > see myself why it is so...
> > 
> > Cc Ming, he split out some parts of it to dynamic allocation not too
> > long ago, maybe he knows the trick.
> 
> I remembered that percpu_ref_is_zero() can be called even after percpu_ref_exit()
> returns, and looks percpu_ref_is_zero() isn't classified into 'active use'.
> 

Looking at the commit prior, it seems like percpu_ref_is_zero() was
subject to the usual init and exit lifetime. I guess I'm just not
convinced it should ever be > 0. I'll think about it a little longer and
might fix it.

Thanks,
Dennis
