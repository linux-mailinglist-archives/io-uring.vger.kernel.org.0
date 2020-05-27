Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9F1E491E
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 18:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbgE0QDZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389334AbgE0QDY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 12:03:24 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFECC03E97D
        for <io-uring@vger.kernel.org>; Wed, 27 May 2020 09:03:24 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id r16so2573275qvm.6
        for <io-uring@vger.kernel.org>; Wed, 27 May 2020 09:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S4XAF2qs5g4AY/r0EWrS8+9mLHbgcJOtXMG15PYfY1M=;
        b=FAkcrvKPhwXHPzhdsTR4NIhbFqwfLMvAV5bGTRBFGbczDHZC/aQDPVNA9PY7cGrlvI
         OAU7sMfEHvFrbqT7CvtkuJGTkLTQG5KPLvLc06tbn9wyvDUbjiyyqowgDNO9WndwvoJj
         X2dl1qZDNUOZqVESipiKNZd2Z60Nw52ZyxG0kUa5w+Kb9fsoxQn99KBAnvXQXuidqHXF
         g8B5P2fMOTarggI1cwoQW6OJquoa9Iej9VuFDR2ehmtvCwzE99l5fAoHQpqyCpeiAEEr
         Af1ivrgSbwVp3LHhcKFdtzo1qHJKVNeAaLsKpBMc9QZNWJkGiTDvSPU22BKqJthweSfF
         Xblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S4XAF2qs5g4AY/r0EWrS8+9mLHbgcJOtXMG15PYfY1M=;
        b=kKJ+9aAKH219uintEdeDwy55mn+QcWh8hkWLut90UpOjAbCYmOHfouHlWtO1tnSc0W
         /DT50lq0155T6QjA9BVN2C7GPZogEfTkmbv9yLCOvy0NGWNWU6+QULnFTof9Rn48n7Iz
         lz1Rq7ps+NFL58A7h4XK25L4bAcbSPWMuXFBexgS6IKvR2yqNEOxSBRkyBK3gbzWfP6r
         23j/JrVCrv6FdkuYoFLPoHszS6kiWSzfBfC6LcLbvKbwKEgGjzaZyQ3QL8yUeus2cR3x
         DfPBFJBIfTcowq+KNjgAngDTQ52TzCH7jY24EC42JlVz3CuUS3ya3K94Cx79pn5RszJ9
         e/kg==
X-Gm-Message-State: AOAM532JSohquefwp+mj4UNgfRXiw46GFbbDusT0ggtJsh7lV1ae4y28
        oRDEh/14kQOuuPiBtA+Rn+i13w==
X-Google-Smtp-Source: ABdhPJyGGNRt6GbiZDvAAJR7JhnDFJNuzQwWePJEhdbGDeVQFHSsv2y//UkvfCBcqxVwmEGqiS8tHA==
X-Received: by 2002:a0c:f486:: with SMTP id i6mr24701658qvm.190.1590595402656;
        Wed, 27 May 2020 09:03:22 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2535])
        by smtp.gmail.com with ESMTPSA id g66sm2485148qkb.122.2020.05.27.09.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:03:22 -0700 (PDT)
Date:   Wed, 27 May 2020 12:02:57 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 04/12] mm: add support for async page locking
Message-ID: <20200527160257.GB42293@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-5-axboe@kernel.dk>
 <20200526215925.GC6781@cmpxchg.org>
 <152529a5-adb4-fd7b-52ac-967500c011c9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152529a5-adb4-fd7b-52ac-967500c011c9@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 04:01:07PM -0600, Jens Axboe wrote:
> On 5/26/20 3:59 PM, Johannes Weiner wrote:
> > On Tue, May 26, 2020 at 01:51:15PM -0600, Jens Axboe wrote:
> >> Normally waiting for a page to become unlocked, or locking the page,
> >> requires waiting for IO to complete. Add support for lock_page_async()
> >> and wait_on_page_locked_async(), which are callback based instead. This
> > 
> > wait_on_page_locked_async() is actually in the next patch, requiring
> > some back and forth to review. I wonder if this and the next patch
> > could be merged to have the new API and callers introduced together?
> 
> I'm fine with that, if that is preferable. Don't feel strongly about
> that at all, just tried to do it as piecemeal as possible to make
> it easier to review.

Not worth sending a new iteration over, IMO.
