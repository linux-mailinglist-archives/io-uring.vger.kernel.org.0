Return-Path: <io-uring+bounces-6953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B978A4EF32
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 22:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49BF1172691
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 21:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD61260384;
	Tue,  4 Mar 2025 21:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dZSR7gXk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06E31FDA9D
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122694; cv=none; b=f1iSvsPS42RENLq57QmwvnjdWRPXVkFV4Etc0PgXqlg6Urb3P4igNYJFdLSuwnQPbILDjYchxvA9GxYPEzU1AQH+1SLLxAS2pbplzyTciLHk5XJ+Ikfn8mxEkN+/0gGzy5aVbvaM4yn7IzieIamdczTnNaEMaBh/VGfgKsoNzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122694; c=relaxed/simple;
	bh=0E3T5Hp+sMKQhmdLWvSGxflpCJKf0yCp4IKXvTlchuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQVhI1SKR4ZC9+ceDoNsZElfJXv8428sZzkuFgPMb2lx6l8nn5mibqRy/fiT6nW0H8wKwkxTMxAssRO1W4cZ8sDaKSYsjBfTRWMM27488QQCqF3/fKN0OFWsqPORf8LTInD+nVxjb8w7lBtOUdspH15CQQNymKxUkObbojd2nTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dZSR7gXk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2232aead377so120283755ad.0
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 13:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741122691; x=1741727491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5u9T8buzgB1g+ZB8WQvIpl66rBv5TutDiyFxRCUgI8=;
        b=dZSR7gXk6u+cXjL/+VDSQJ/3d3D1YhruJ+MjOdxLCY78uREgwD8ftmVXg4RZOAn9j1
         E22X97OiO5WPFTvxDqkTh29FipsFoiYyu+s7YivY7bXKM6ghRfqCbD2piUW7oLW2Y58O
         H7XHYX4L0LSoF2Vdx0s9cZzO6Dsy0zeg80gi777L1pmhgmgylxzl4dA54oS0AobCW8re
         sU74TNbJd3suUFhvURlpjCqgt+Hy5Mefo8lK4r8pG4iftRfXtqz+VbDhJGMzUqY6Rj1H
         FUMAkGulpM1bHHuUA8Fai4twX6zWmx4+jOSCsr/LrS4J4oMEYo+WhpK0JaRcCx+Czw1D
         zqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122691; x=1741727491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5u9T8buzgB1g+ZB8WQvIpl66rBv5TutDiyFxRCUgI8=;
        b=AgO7CNsWYAUdE/5iMfWO2i9P0MfBjzrUDmyTXXIQ+wSaeEKPpW5AmETZjmydNPdptJ
         1P+0H71gBdKcfJMqy/VYWOOLd2egYe4dW/gT1ktTZyLtv4f5O7Uzpbygxw9Unj3LShli
         8VTIzeIKTfR43tEoByASFjbZl1G2TFJOSNqJlcZ8usclEkONP2f/C6Hb7YVCd7t1lQ6y
         HJSDDyEPoeKFPBO1Y+AUCkPPplSHZShMlchMSHlI1zKbAE6lKJ2uzWxwpmJ5gnEKjd+2
         KgO+Qn/6sPh8JceDd1uj1BjSp8txNtGUFMHK7yQSNxRG5NA95Rzk59fk2c437vjZrhDE
         tVtA==
X-Forwarded-Encrypted: i=1; AJvYcCXDVo5iehX/vi31zTBZ/gSbXW113Bvq/X3PSSUf0pJl8a8agAoA2pOXtMnZBtJeOcIGXjNsP4Y0+w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4CZC89S3n7v9HMo0UpStgxsmOoCmUyrbEWKVqhyAChSqRFYc1
	T8s4gIT0o3k+FSDYl4axxFrFRucEgQJ7kmBSeir8aVqM906ohGysxAgQlDWgoxlrnKuc4Zfr7Mz
	E
X-Gm-Gg: ASbGnctKAGInkblekK8zcftaJioTP1OFeftLEglWJcy+UyNgJsMUl4iQCyk+Y437ZmC
	e8kZojOmxjIgG8YheOUB+jB6khKNs9ml/WVfW9CkL9wPGMngnApXy8AgSeXUuJgsv6m3FI4nBSU
	GGXzabs7IPpCdIVad/k/MgvlrF08+B+n0ojHBk3Kz4sb/rTrfILU3ia4pIasoBO/0+XOoU6ysam
	Nqr6Qp4uR0nS/IN9hM5RiuCLsXHTTfQuoBoN12ACqbbM/XJhijPS1o6irc7n/gheZOdpl7/27db
	1JBaUOarr103vronamJT+tSUA+xiSwsBTkhfm1yl5RcEzdvi1uqM+y5Wiw7nh+KH2O+Ffhy4Igy
	en+SAQ8tIsqR4YmoT7Hxj
X-Google-Smtp-Source: AGHT+IFYVR//RHCOvcKfA/QF6rtFm/idAwEGSxepnoQAdAXiRGfBac/SE2HTdXKT4z1YO6U91gNlbA==
X-Received: by 2002:a17:902:ec92:b0:220:d272:534d with SMTP id d9443c01a7336-223f1c81ee0mr11592985ad.22.1741122691015;
        Tue, 04 Mar 2025 13:11:31 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235053e41asm99610285ad.255.2025.03.04.13.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 13:11:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpZXz-00000008ttX-3vyR;
	Wed, 05 Mar 2025 08:11:27 +1100
Date: Wed, 5 Mar 2025 08:11:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8dsfxVqpv-kqeZy@dread.disaster.area>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>

On Tue, Mar 04, 2025 at 12:18:07PM +0000, Pavel Begunkov wrote:
> There are reports of high io_uring submission latency for ext4 and xfs,
> which is due to iomap not propagating nowait flag to the block layer
> resulting in waiting for IO during tag allocation.
> 
> Because of how errors are propagated back, we can't set REQ_NOWAIT
> for multi bio IO, in this case return -EAGAIN and let the caller to
> handle it, for example, it can reissue it from a blocking context.
> It's aligned with how raw bdev direct IO handles it.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> Reported-by: wu lei <uwydoc@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> v2:
> 	Fail multi-bio nowait submissions
> 
>  fs/iomap/direct-io.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b521eb15759e..07c336fdf4f0 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -363,9 +363,14 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  	 */
>  	if (need_zeroout ||
>  	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>  		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>  
> +		if (!is_sync_kiocb(dio->iocb) &&
> +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
> +			return -EAGAIN;
> +	}

How are we getting here with IOCB_NOWAIT IO? This is either
sub-block unaligned write IO, it is a write IO that requires
allocation (i.e. write beyond EOF), or we are doing a O_DSYNC write
on hardware that doesn't support REQ_FUA. 

The first 2 cases should have already been filtered out by the
filesystem before we ever get here. The latter doesn't require
multiple IOs in IO submission - the O_DSYNC IO submission (if any is
required) occurs from data IO completion context, and so it will not
block IO submission at all.

So what type of IO in what mapping condition is triggering the need
to return EAGAIN here?

> +
>  	/*
>  	 * The rules for polled IO completions follow the guidelines as the
>  	 * ones we set for inline and deferred completions. If none of those
> @@ -374,6 +379,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
>  		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>  
> +	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
> +
> +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
> +		/*
> +		 * This is nonblocking IO, and we might need to allocate
> +		 * multiple bios. In this case, as we cannot guarantee that
> +		 * one of the sub bios will not fail getting issued FOR NOWAIT
> +		 * and as error results are coalesced across all of them, ask
> +		 * for a retry of this from blocking context.
> +		 */
> +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
> +					  BIO_MAX_VECS)
> +			return -EAGAIN;
> +
> +		bio_opf |= REQ_NOWAIT;
> +	}

Ok, so this allows a max sized bio to be used. So, what, 1MB on 4kB
page size is the maximum IO size for IOCB_NOWAIT now? I bet that's
not documented anywhere....

Ah. This doesn't fix the problem at all.

Say, for exmaple, I have a hardware storage device with a max
hardware IO size of 128kB. This is from the workstation I'm typing
this email on:

$ cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
128
$  cat /sys/block/nvme0n1/queue/max_segments
33
$

We build a 1MB bio above, set REQ_NOWAIT, then:

submit_bio
  ....
  blk_mq_submit_bio
    __bio_split_to_limits(bio, &q->limits, &nr_segs);
      bio_split_rw()
        .....
        split:
	.....
        /*                                                                       
         * We can't sanely support splitting for a REQ_NOWAIT bio. End it        
         * with EAGAIN if splitting is required and return an error pointer.     
         */                                                                      
        if (bio->bi_opf & REQ_NOWAIT)                                            
                return -EAGAIN;                                                  


So, REQ_NOWAIT effectively limits bio submission to the maximum
single IO size of the underlying storage. So, we can't use
REQ_NOWAIT without actually looking at request queue limits before
we start building the IO - yuk.

REQ_NOWAIT still feels completely unusable to me....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

