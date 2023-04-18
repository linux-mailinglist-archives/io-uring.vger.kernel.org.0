Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB386E6F3A
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjDRWNe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 18:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjDRWNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 18:13:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572E659E8
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 15:13:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a516fb6523so32188665ad.3
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 15:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681855983; x=1684447983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JpFm5m6tO5mx05kVIN/ttwb3Qau/R4UqBZIeKrztNYA=;
        b=FnQjklus3REFTnQ81KALNZESVQXH2keBj2dkRkYOlAz3Dgho0s+pjDXI5TzwS5e3G8
         3D1Csr1z7hqDvbVuINHJoxalmL3zzIL6c4crYXxGs0ENxn2GpS1xdGUfuHoevhI6OC49
         Jcq6yKYs3UojyLTG8FQxrmka1GRY9X8yQbsZVE30fb1EVeiiK7b+XxVjdBK4cUIJILhA
         u49PC1WOafr9HrwZ2veM/dFW3xOgn/zi8yCjfYGjk125kKAUxkTZ91ZG2h54mV+KMXOK
         bZ+AIQ7JhIswIsa+YYq+egllYyc24SiGUt4GrEU3hejwIYIrUjupm79+uXXRFA/qp0Bm
         NO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681855983; x=1684447983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpFm5m6tO5mx05kVIN/ttwb3Qau/R4UqBZIeKrztNYA=;
        b=JZzNk1KUl2cs0zJAtI646h3h7h8VikPuHe2+kSJqwcokQHkVu4OfNJzKOIXBbgeSaY
         sw/Crp7utpNzMryPzgs5NZHByRln9xuQ4RYeGZV6t+dbiRWafYgoIkKs34QA1W1+wfS4
         Wqff7r9F9zwZIX7TWEb15WpJ2kvoshqCLHMDKcJL4y5YHf4961/EKN3o2ci1RuFY/ZJ+
         8TB18U7fQF7a3GrndwRxSG7nG4fKJtsKsOjJua32smJ+zNheitHQdAjKD9ExUbhHPXvq
         ZXsP/HcvSLfdey46/+bWIS1qh9YzNYzVy1fNjjvXSQUkLm/uFvCGctJotQm2WQInGkn9
         itfw==
X-Gm-Message-State: AAQBX9c6ZtL1UIwtkqgBk9CZh6Vfar5HJXVWYY/4v1BwiNmkHJ4dcJAV
        I2kb7uk5B0coiYlUaLzOtm4AyQ==
X-Google-Smtp-Source: AKy350YhJ+naK8yn0hGO1Ed15RZSTssdd0aSp9Ef+Sl9MG9f2/gT4cORtcXENiAC0RpQlOhU4anHLg==
X-Received: by 2002:a17:903:2348:b0:1a5:2fbd:d094 with SMTP id c8-20020a170903234800b001a52fbdd094mr4139805plh.9.1681855982883;
        Tue, 18 Apr 2023 15:13:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902a60100b001a671a396efsm10093392plq.214.2023.04.18.15.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 15:13:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1potZM-0051YJ-3Z; Wed, 19 Apr 2023 08:13:00 +1000
Date:   Wed, 19 Apr 2023 08:13:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dharmendra Singh <dsingh@ddn.com>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Message-ID: <20230418221300.GT3223426@dread.disaster.area>
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org>
 <20230414153612.GB360881@frogsfrogsfrogs>
 <cfeade24-81fc-ab73-1fd9-89f12a402486@kernel.dk>
 <CAJfpegvv-SPJRjWrR_+JY-H=xmYq0pnTfAtj-N8kG7AnQvWd=w@mail.gmail.com>
 <e4855cfa-3683-f12c-e865-6e5c4d0e5602@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4855cfa-3683-f12c-e865-6e5c4d0e5602@ddn.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 18, 2023 at 12:55:40PM +0000, Bernd Schubert wrote:
> On 4/18/23 14:42, Miklos Szeredi wrote:
> > On Sat, 15 Apr 2023 at 15:15, Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> Yep, that is pretty much it. If all writes to that inode are serialized
> >> by a lock on the fs side, then we'll get a lot of contention on that
> >> mutex. And since, originally, nothing supported async writes, everything
> >> would get punted to the io-wq workers. io_uring added per-inode hashing
> >> for this, so that any punt to io-wq of a write would get serialized.
> >>
> >> IOW, it's an efficiency thing, not a correctness thing.
> > 
> > We could still get a performance regression if the majority of writes
> > still trigger the exclusive locking.  The questions are:
> > 
> >   - how often does that happen in real life?
> 
> Application depending? My personal opinion is that 
> applications/developers knowing about uring would also know that they 
> should set the right file size first. Like MPIIO is extending files 
> persistently and it is hard to fix with all these different MPI stacks 
> (I can try to notify mpich and mvapich developers). So best would be to 
> document it somewhere in the uring man page that parallel extending 
> files might have negative side effects?

There are relatively few applications running concurrent async
RWF_APPEND DIO writes. IIRC SycallaDB was the first we came across a
few years ago. Apps that use RWF_APPEND for individual DIOs expect
that it doesn't cause performance anomolies.

These days XFS will run concurrent append DIO writes and it doesn't
serialise RWF_APPEND IO against other RWF_APPEND IOs. Avoiding data
corruption due to racing append IOs doing file extension has been
delegated to the userspace application similar to how we delegate
the responsibility for avoiding data corruption due to overlapping
concurrent DIO to userspace.

> >   - how bad the performance regression would be?
> 
> I can give it a try with fio and fallocate=none over fuse during the 
> next days.

It depends on where the lock that triggers serialisation is, and how
bad the contention on it is. rwsems suck for write contention
because of the "spin on owner" "optimisations" for write locking and
long write holds that occur in the IO path. In general, it will be
no worse than using userspace threads to issue the exact same IO
pattern using concurrent sync IO.

> > Without first attempting to answer those questions, I'd be reluctant
> > to add  FMODE_DIO_PARALLEL_WRITE to fuse.

I'd tag it with this anyway - for the majority of apps that are
doing concurrent DIO within EOF, shared locking is big win. If
there's a corner case that apps trigger that is slow, deal with them
when they are reported....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
