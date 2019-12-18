Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B073124D7A
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 17:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLRQ0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 11:26:47 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40033 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfLRQ0r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 11:26:47 -0500
Received: by mail-qt1-f194.google.com with SMTP id e6so2400356qtq.7;
        Wed, 18 Dec 2019 08:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=loY/F+PAdaWyk5QCXx7slim0qkoGLO/F2UzLLFuV/S8=;
        b=jXpPL8O9lWnvDry1VId6njC4m+oHuFJmeOW4oEfScQEjZypo8J2BUnWkPSij3TllBd
         Hf4muyihJp/ZulUzJMbLRocwxopbhvEJli/je6KS/9cAY6KEUU1kXO/4PUO+wY8EO0YH
         3sNpqd9FBUr+po2/k1H2JW7I7yuAaGuW1IDF1G6ZgdByHMsT3K/qawXp4VABdNJp1VwU
         a+wFJyJTiYlfkydETqytgdO6fPP0TDBFBbYmeT1H3PanXgW3zImUgrfcS4bfJsJM4Bg7
         WVmzb49VcHmSHKpJ/Afi8VLv0j3+gMJoCAz46hOlzlxa/tc0ZVIa1d4xze1siNR79Qu+
         M3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=loY/F+PAdaWyk5QCXx7slim0qkoGLO/F2UzLLFuV/S8=;
        b=aoj7qfRyDI8jYAtxB2+5+5QNdokvjPVboVkX5w6eFNhf3epYD/djw/bWHnboLx7Mre
         ZOWDDOD+P2KKhOtTIEBkt0gFlgSA9iyYh6Cr9dEnQIGgazs7irSHuTREwFW0Yx0m7oqX
         Rhsew9WPr48irYxh7synxo55kE12Fa/MjTuocRe6Flpfu4hf/ehdpwp9rviloNdzpjYF
         YyCuBNQDxcZzBkmzPJe7nVlpSfjHsPM/YyYaQJiOsndsKigOyCrxjRHRYdClNsOzqUua
         OJhpG29V4k/Aiswc5TkdXK3Jg6Vr5ekdN3T+V8coS1xjNBavwaR+DAylsiAWCPWZaMz5
         i9qg==
X-Gm-Message-State: APjAAAV6i4ZCLTpoCurYq4FLTlwyMsqArCDs4Ol5SKB23clvKwuFn5Yd
        Pe8AvjpTBmWAE8A7/waTLUg=
X-Google-Smtp-Source: APXvYqyjBizT31CWo1zN1rt+wYHF7zdJBllA2wPgCG/GWexECdwT+Ndql0PFOHi0omJZn22lrS22SQ==
X-Received: by 2002:ac8:508:: with SMTP id u8mr2982792qtg.128.1576686406046;
        Wed, 18 Dec 2019 08:26:46 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:27e])
        by smtp.gmail.com with ESMTPSA id d25sm866478qtq.11.2019.12.18.08.26.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:26:45 -0800 (PST)
Date:   Wed, 18 Dec 2019 08:26:42 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] pcpu_ref: add percpu_ref_tryget_many()
Message-ID: <20191218162642.GC2914998@devbig004.ftw2.facebook.com>
References: <cover.1576621553.git.asml.silence@gmail.com>
 <c430d1a603f9ffe01661fc1b3bad6e3101a8b855.1576621553.git.asml.silence@gmail.com>
 <fe13d615-0fae-23e3-f133-49b727973d14@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe13d615-0fae-23e3-f133-49b727973d14@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(cc'ing Dennis and Christoph and quoting whole body)

Pavel, can you please cc percpu maintainers on related changes?

The patch looks fine to me.  Please feel free to add my acked-by.

On Tue, Dec 17, 2019 at 04:42:59PM -0700, Jens Axboe wrote:
> CC Tejun on this one. Looks fine to me, and matches the put path.
> 
> 
> On 12/17/19 3:28 PM, Pavel Begunkov wrote:
> > Add percpu_ref_tryget_many(), which works the same way as
> > percpu_ref_tryget(), but grabs specified number of refs.
> > 
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  include/linux/percpu-refcount.h | 24 ++++++++++++++++++++----
> >  1 file changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> > index 390031e816dc..19079b62ce31 100644
> > --- a/include/linux/percpu-refcount.h
> > +++ b/include/linux/percpu-refcount.h
> > @@ -210,15 +210,17 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
> >  }
> >  
> >  /**
> > - * percpu_ref_tryget - try to increment a percpu refcount
> > + * percpu_ref_tryget_many - try to increment a percpu refcount
> >   * @ref: percpu_ref to try-get
> > + * @nr: number of references to get
> >   *
> >   * Increment a percpu refcount unless its count already reached zero.
> >   * Returns %true on success; %false on failure.
> >   *
> >   * This function is safe to call as long as @ref is between init and exit.
> >   */
> > -static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > +static inline bool percpu_ref_tryget_many(struct percpu_ref *ref,
> > +					  unsigned long nr)
> >  {
> >  	unsigned long __percpu *percpu_count;
> >  	bool ret;
> > @@ -226,10 +228,10 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> >  	rcu_read_lock();
> >  
> >  	if (__ref_is_percpu(ref, &percpu_count)) {
> > -		this_cpu_inc(*percpu_count);
> > +		this_cpu_add(*percpu_count, nr);
> >  		ret = true;
> >  	} else {
> > -		ret = atomic_long_inc_not_zero(&ref->count);
> > +		ret = atomic_long_add_unless(&ref->count, nr, 0);
> >  	}
> >  
> >  	rcu_read_unlock();
> > @@ -237,6 +239,20 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> >  	return ret;
> >  }
> >  
> > +/**
> > + * percpu_ref_tryget - try to increment a percpu refcount
> > + * @ref: percpu_ref to try-get
> > + *
> > + * Increment a percpu refcount unless its count already reached zero.
> > + * Returns %true on success; %false on failure.
> > + *
> > + * This function is safe to call as long as @ref is between init and exit.
> > + */
> > +static inline bool percpu_ref_tryget(struct percpu_ref *ref)
> > +{
> > +	return percpu_ref_tryget_many(ref, 1);
> > +}
> > +
> >  /**
> >   * percpu_ref_tryget_live - try to increment a live percpu refcount
> >   * @ref: percpu_ref to try-get
> > 
> 
> 
> -- 
> Jens Axboe
> 

-- 
tejun
