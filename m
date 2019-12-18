Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04945124FA8
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLRRuA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:50:00 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43258 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfLRRuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:50:00 -0500
Received: by mail-qv1-f65.google.com with SMTP id p2so1080764qvo.10;
        Wed, 18 Dec 2019 09:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bkxxp1rgGZsMi0NBLL8JuXUKKC5LRx/hd2DVjblWzgc=;
        b=TU0XVaEpIs/GjxeH1dF86z3PeNTSPSZyAJNbGnaH8tQEp8VPZiITQBJEHXuHXrnQF1
         EOhqNTbzproyoqByhpcaZ8NNVUJ8+/ZonlD+eKCMERxprFMFccW0yw0+LdcUrNv2L1Gz
         Ec+JR1kRNafHPIOSTMMvy8KBW9fUe699+e341DU2WWZm7rMbiFX+g2r/Fkw+X5Gf/4yp
         UHPcLciMR9nZK097xVQhweG/s+L8ih7AZzYgdJT5NYESsSir3bU2+QbURpH4YzsVsCOz
         SPoIApuBNOk5jatwCbUGcTBs40uPMKEB6GXA/NWg6OkBJWBVrvo16RZh9vQqMw6t0y/b
         w2EQ==
X-Gm-Message-State: APjAAAVutKaBiMDcLhvYpSbPRuI5utRn77eBH9HXKtRYCzpljzA7queN
        fikcGEsHB04UrKDDvUv+Cyg=
X-Google-Smtp-Source: APXvYqzZkCIlw8mS4PB6shog2RyDWP/FSX8GmuWCRnfXI97kScRmVOVM8J/Jpy0gNQztjLQYF1rl/Q==
X-Received: by 2002:a05:6214:190e:: with SMTP id er14mr3622997qvb.28.1576691399151;
        Wed, 18 Dec 2019 09:49:59 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:480::8849])
        by smtp.gmail.com with ESMTPSA id 3sm937429qte.59.2019.12.18.09.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:49:58 -0800 (PST)
Date:   Wed, 18 Dec 2019 11:49:55 -0600
From:   Dennis Zhou <dennis@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] pcpu_ref: add percpu_ref_tryget_many()
Message-ID: <20191218174955.GA14991@dennisz-mbp.dhcp.thefacebook.com>
References: <cover.1576621553.git.asml.silence@gmail.com>
 <c430d1a603f9ffe01661fc1b3bad6e3101a8b855.1576621553.git.asml.silence@gmail.com>
 <fe13d615-0fae-23e3-f133-49b727973d14@kernel.dk>
 <20191218162642.GC2914998@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218162642.GC2914998@devbig004.ftw2.facebook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 18, 2019 at 08:26:42AM -0800, Tejun Heo wrote:
> (cc'ing Dennis and Christoph and quoting whole body)
> 
> Pavel, can you please cc percpu maintainers on related changes?
> 
> The patch looks fine to me.  Please feel free to add my acked-by.
> 
> On Tue, Dec 17, 2019 at 04:42:59PM -0700, Jens Axboe wrote:
> > CC Tejun on this one. Looks fine to me, and matches the put path.
> > 
> > 
> > On 12/17/19 3:28 PM, Pavel Begunkov wrote:
> > > Add percpu_ref_tryget_many(), which works the same way as
> > > percpu_ref_tryget(), but grabs specified number of refs.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >  include/linux/percpu-refcount.h | 24 ++++++++++++++++++++----
> > >  1 file changed, 20 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> > > index 390031e816dc..19079b62ce31 100644
> > > --- a/include/linux/percpu-refcount.h
> > > +++ b/include/linux/percpu-refcount.h
> > > @@ -210,15 +210,17 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
> > >  }
> > >  
> > >  /**
> > > - * percpu_ref_tryget - try to increment a percpu refcount
> > > + * percpu_ref_tryget_many - try to increment a percpu refcount
> > >   * @ref: percpu_ref to try-get
> > > + * @nr: number of references to get
> > >   *
> > >   * Increment a percpu refcount unless its count already reached zero.
> > >   * Returns %true on success; %false on failure.

Minor nit: would be nice to change this so the two don't have identical
comments. (eg: Increment a percpu refcount by @nr unless...)
> > >   *
> > >   * This function is safe to call as long as @ref is between init and exit.
> > >   */
> > > -static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > > +static inline bool percpu_ref_tryget_many(struct percpu_ref *ref,
> > > +					  unsigned long nr)
> > >  {
> > >  	unsigned long __percpu *percpu_count;
> > >  	bool ret;
> > > @@ -226,10 +228,10 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > >  	rcu_read_lock();
> > >  
> > >  	if (__ref_is_percpu(ref, &percpu_count)) {
> > > -		this_cpu_inc(*percpu_count);
> > > +		this_cpu_add(*percpu_count, nr);
> > >  		ret = true;
> > >  	} else {
> > > -		ret = atomic_long_inc_not_zero(&ref->count);
> > > +		ret = atomic_long_add_unless(&ref->count, nr, 0);
> > >  	}
> > >  
> > >  	rcu_read_unlock();
> > > @@ -237,6 +239,20 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > >  	return ret;
> > >  }
> > >  
> > > +/**
> > > + * percpu_ref_tryget - try to increment a percpu refcount
> > > + * @ref: percpu_ref to try-get
> > > + *
> > > + * Increment a percpu refcount unless its count already reached zero.
> > > + * Returns %true on success; %false on failure.
> > > + *
> > > + * This function is safe to call as long as @ref is between init and exit.
> > > + */
> > > +static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > > +{
> > > +	return percpu_ref_tryget_many(ref, 1);
> > > +}
> > > +
> > >  /**
> > >   * percpu_ref_tryget_live - try to increment a live percpu refcount
> > >   * @ref: percpu_ref to try-get
> > > 
> > 
> > 
> > -- 
> > Jens Axboe
> > 
> 
> -- 
> tejun

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis
