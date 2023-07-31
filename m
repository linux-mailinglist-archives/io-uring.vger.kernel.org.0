Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B978B7689B8
	for <lists+io-uring@lfdr.de>; Mon, 31 Jul 2023 03:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjGaB6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Jul 2023 21:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjGaB6z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Jul 2023 21:58:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30181E7F
        for <io-uring@vger.kernel.org>; Sun, 30 Jul 2023 18:58:54 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686ed1d2594so3912398b3a.2
        for <io-uring@vger.kernel.org>; Sun, 30 Jul 2023 18:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690768733; x=1691373533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=99gy8sGpZTQCEv176AofQrJz9GsO2HjG+St+pJozUFU=;
        b=dikEai/RNimmtDooNZ4k7RikFuIO26TWVfYSNC2sa8voYglrnfcabQIV74qAzBXABH
         e5zMxrWhw6v3mptVgH3N0XaPyw9dFYZQLw4woI3LAbdRPESkS/2Mbhh4Jp243NYmGtfn
         0kqLeLVMq7WTDK7ydweT7H5BOuV6kZOD72K8N/Eiw+jcn9KTXCN2MiqWjcSeeJxAHVDZ
         I0HTBmdDRtSRwId21wU38ZduEF8mY1SpIgvrx5gsXGpMtRFJv1c7Cs8BXApUg5EyspDa
         /tN4HbbwzF0S73fqVyp1NqbqbtXkDNgrhlKKzWB6hSxC+H3sjEV4iVFqU3ZL2mRzyHF2
         Wtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690768733; x=1691373533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99gy8sGpZTQCEv176AofQrJz9GsO2HjG+St+pJozUFU=;
        b=jlth4R13lZUXvZJqs7OjsLHu4PSInZG5QpPKxRgavNRlWfhQziWwhs12tAgIqIsspf
         KuRdi1RYC8ZElC4Sfy4vtM5jlNcVeeVwudtjkSG+3kpnuxSeNVoliyk1BYCKNO8FJsjt
         +o1PCeUXPczIOraxWjRS2Bbc8biYQ2wCP83m+arADyZIatnQx2UX7IEEzeF0AHodS5qP
         vcbQvhpxOUNTzYTVSVgr7eKHiV0T+RH5alDciJHpsrrUb2Yc21+oKyTsfOLzTUYKBJ7h
         uKWpkpJf24CRh5X9GCtkQMN7e819ToCzSskcK60FNk9KVSFFM0Hb0jw+P5xwAoX1wN+s
         vWSA==
X-Gm-Message-State: ABy/qLbQ4nO70bHBvosnjTZKEfhXPOIh/KdveSyqk+ZY1V5fjXY5iJN1
        pyv241jAppBCqCM35osUNeWl9A==
X-Google-Smtp-Source: APBJJlG+oh7wCOzT+xAzPY8A8sHHwSz2Lghhaxk/ElNs0E/iFpdepMPPotj93v202H6GwemypZYxuA==
X-Received: by 2002:a05:6a00:1687:b0:682:4ef7:9b0b with SMTP id k7-20020a056a00168700b006824ef79b0bmr11697967pfc.0.1690768733631;
        Sun, 30 Jul 2023 18:58:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id y16-20020aa78550000000b0066a6059d399sm6485332pfn.116.2023.07.30.18.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jul 2023 18:58:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qQIBO-00CYrw-1f;
        Mon, 31 Jul 2023 11:58:50 +1000
Date:   Mon, 31 Jul 2023 11:58:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, Hao Xu <hao.xu@linux.dev>,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        josef@toxicpanda.com
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <ZMcVWj9GfcHol3xG@dread.disaster.area>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
 <20230727-westen-geldnot-63435c2f65ad@brauner>
 <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
 <20230727-daran-abtun-4bc755f668ad@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727-daran-abtun-4bc755f668ad@brauner>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 27, 2023 at 06:28:52PM +0200, Christian Brauner wrote:
> On Thu, Jul 27, 2023 at 05:17:30PM +0100, Pavel Begunkov wrote:
> > On 7/27/23 16:52, Christian Brauner wrote:
> > > On Thu, Jul 27, 2023 at 04:12:12PM +0100, Pavel Begunkov wrote:
> > > It would also solve it for writes which is what my kiocb_modified()
> > > comment was about. So right now you have:
> > 
> > Great, I assumed there are stricter requirements for mtime not
> > transiently failing.
> 
> But I mean then wouldn't this already be a problem today?
> kiocb_modified() can error out with EAGAIN today:
> 
>           ret = inode_needs_update_time(inode, &now);
>           if (ret <= 0)
>                   return ret;
>           if (flags & IOCB_NOWAIT)
>                   return -EAGAIN;
> 
>           return __file_update_time(file, &now, ret);
> 
> the thing is that it doesn't matter for ->write_iter() - for xfs at
> least - because xfs does it as part of preparatory checks before
> actually doing any real work. The problem happens when you do actual
> work and afterwards call kiocb_modified(). That's why I think (2) is
> preferable.

This has nothing to do with what "XFS does". It's actually an
IOCB_NOWAIT API design constraint.

That is, IOCB_NOWAIT means "complete the whole operation without
blocking or return -EAGAIN having done nothing".  If we have to do
something that might block (like a timestamp update) then we need to
punt the entire operation before anything has been modified.  This
requires all the "do we need to modify this" checks to be done up
front before we start modifying anything.

So while it looks like this might be "an XFS thing", that's because
XFS tends to be the first filesystem that most io_uring NOWAIT
functionality is implemented on. IOWs, what you see is XFS is doing
things the way IOCB_NOWAIT requires to be done. i.e. it's a
demonstration of how nonblocking filesystem modification operations
need to be run, not an "XFS thing"...

> > > I would prefer 2) which seems cleaner to me. But I might miss why this
> > > won't work. So input needed/wanted.
> > 
> > Maybe I didn't fully grasp the (2) idea
> > 
> > 2.1: all read_iter, write_iter, etc. callbacks should do file_accessed()
> > before doing IO, which sounds like a good option if everyone agrees with
> > that. Taking a look at direct block io, it's already like this.
> 
> Yes, that's what I'm talking about. I'm asking whether that's ok for xfs
> maintainers basically. i_op->write_iter() already works like that since
> the dawn of time but i_op->read_iter doesn't and I'm proposing to make
> it work like that and wondering if there's any issues I'm unaware of.

XFS already calls file_accessed() in the DIO read path before the
read gets issued. I don't see any problem with lifting it to before
the copy-out loop in filemap_read() because it is run regardless of
whether any data is read or any error occurred.  Hence it just
doesn't look like it matters if it is run before or after the
copy-out loop to me....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
