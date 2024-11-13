Return-Path: <io-uring+bounces-4668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAE19C7EF3
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 00:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E4FAB23E6A
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 23:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F38118C907;
	Wed, 13 Nov 2024 23:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kYJ/tV+b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D8118C01F
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 23:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731541876; cv=none; b=Im0nn98YnG6RlsFJADIroxnQ5ZXda83jfzE0R33LnC4ZRChDume2582Jdip4ESud8UiwqQpLr9hGBd/mTNpByuY508r+WedhCYljUoUWIUZc1qvbmO5ckZQtrA0Q9jqZ/KQCD5ibWjwoTlSyhJS17ZyCncjH37PGbB/vp4a6BIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731541876; c=relaxed/simple;
	bh=iqbHEEkvtBJUUD2xvY1+B9NYMn7DnHXcWD0gw8D90/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIfmpSw18sKTuyJq8zwcOveiQOI7RwIpytYZba8qfwu2XlGC+VQp4uCydlG50q7q59TdfuvOfUR1rsGU6gEzr9+f+UCGSQVuh/QvryQvaWE21tXXE5zxkp6kG8etscKt4Wy0MOTu5AkMRR5W6ELXmYrqhhpT13DaXNlhs1u1KN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kYJ/tV+b; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7e6d04f74faso1023873a12.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 15:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731541874; x=1732146674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dR6gxZVOVPj2t9+Oku6JJyuYiTaMGP57Slvmc9QYLdI=;
        b=kYJ/tV+bLpzvktreUGRYY8zED3aHQaYpWC7s6NK93e7ztXAoWJsGc1+qdS69GX8noX
         TE4xWrzeA3IdxxbZR2FEyY0wkpG9Q51FnUwHHO/Q0MsGzdG+9jPY9MzXGGTVFIJ5xGlV
         DDHo7vtiNYFsCXz6h9QoygWHddJnb5MeikoqaeR4J4fceKWpxU5f+WbqDVAbjaE1+fga
         9aswDDxDcu64TvrBkH72g6hltrzjZe2dovW1mhKDQa6zjn+l3YeYddhY0Nmej7itdWhY
         8mvKzX2+GrwoZ3cJWOckFXkdMUHXcvJ+2+mEm9BFEN2fFXSO+/OwDBf/GjgUPrVA9kFG
         ajXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731541874; x=1732146674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dR6gxZVOVPj2t9+Oku6JJyuYiTaMGP57Slvmc9QYLdI=;
        b=FRaLWy72nRaPEVVyZv/peJ5QL4EaNnjaeSpsmWyPo2xlOtAE9kaOmr51XB7x6groBN
         6s0E9WsKcAYpdwrwvuFQYI4se5TwsXH9rWwGVja/zXnUfRX//5eJOZwMvq7JyT2cDl7I
         Mp9XJ/6l+7rRujeJiajRa31avXbXfTUcx36PKswn93SFLQ6jc3HteSLSEQjffVj1tJuH
         LpBNpT+00DxthH7eZS/oq6t3IMFYSiwPCHy9JggHvAxpUSkcNeWyvwaJqA8HjrzJfEw2
         yt2pPI7vic7tYEms1AjNX1up4b4TWh/iRWbA6REIdimjGMHZm3WexbcFo6u2d5BpOemU
         IFfw==
X-Forwarded-Encrypted: i=1; AJvYcCXx84xgHl30F00TspUT0Hk27baVLENzyErUUaPYwekKQ3Gocc8wwu4IeQi1DcA4RL1EuKUKKxWY1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YybXocCiJxFDdS+P760LvsPd99JjyyyQXzgRKVXtahLrFftmOYs
	ONPhKllQZhoveOBxg9cp+qDn/5BzdffcwAuwBq2z3n350IqfQYdV5yoZ6gqB0LY=
X-Google-Smtp-Source: AGHT+IGnJMdOUCMCs6jEMGK8slkeJs2lCzIM0b+P01P83BSSB16iV+QAJQtoT6rroZ1RFQlD0VyEEQ==
X-Received: by 2002:a17:90b:1f89:b0:2e2:ada8:2986 with SMTP id 98e67ed59e1d1-2e9fe6640c3mr1819128a91.16.1731541873837;
        Wed, 13 Nov 2024 15:51:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea02481b8dsm134060a91.9.2024.11.13.15.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 15:51:13 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tBN8f-00EIWG-34;
	Thu, 14 Nov 2024 10:51:09 +1100
Date: Thu, 14 Nov 2024 10:51:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Pierre Labat <plabat@micron.com>, Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [EXT] Re: [PATCHv11 0/9] write hints with nvme fdp and scsi
 streams
Message-ID: <ZzU7bZokkTN2s8qr@dread.disaster.area>
References: <20241108193629.3817619-1-kbusch@meta.com>
 <CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
 <20241111102914.GA27870@lst.de>
 <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
 <20241112133439.GA4164@lst.de>
 <ZzNlaXZTn3Pjiofn@kbusch-mbp.dhcp.thefacebook.com>
 <DS0PR08MB854131CDA4CDDF2451CEB71DAB592@DS0PR08MB8541.namprd08.prod.outlook.com>
 <20241113044736.GA20212@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113044736.GA20212@lst.de>

On Wed, Nov 13, 2024 at 05:47:36AM +0100, Christoph Hellwig wrote:
> On Tue, Nov 12, 2024 at 06:18:21PM +0000, Pierre Labat wrote:
> > About 2)
> > Provide a simple way to the user to decide which layer generate write hints.
> > As an example, as some of you pointed out, what if the filesystem wants to generate write hints to optimize its [own] data handling by the storage, and at the same time the application using the FS understand the storage and also wants to optimize using write hints.
> > Both use cases are legit, I think.
> > To handle that in a simple way, why not have a filesystem mount parameter enabling/disabling the use of write hints by the FS?
> 
> The file system is, and always has been, the entity in charge of
> resource allocation of the underlying device.  Bypassing it will get
> you in trouble, and a simple mount option isn't really changing that
> (it's also not exactly a scalable interface).
> 
> If an application wants to micro-manage placement decisions it should not
> use a file system, or at least not a normal one with Posix semantics.
> That being said we'd demonstrated that applications using proper grouping
> of data by file and the simple temperature hints can get very good result
> from file systems that can interpret them, without a lot of work in the
> file system.  I suspect for most applications that actually want files
> that is actually going to give better results than trying to do the
> micro-management that tries to bypass the file system.

This.

The most important thing that filesystems do behind the scenes is
manage -data locality-. XFS has thousands of lines of code to manage
and control data locality - the allocation policy API itself has a
*dozens* control parameters. We have 2 separate allocation
architectures (one btree based, one bitmap based) and multiple
locality policy algorithms. These juggled physical alignment, size
granularity, size limits, data type being allocated for, desired
locality targets, different search algorithms (e.g. first fit, best
fit, exact fit by size or location, etc), multiple fallback
strategies when the initial target cannot be met, etc.

Allocation policy management is the core of every block based
filesystem that has ever been written.

Specifically to this "stream hint" discussion: go look at the XFS
filestreams allocator.

SGI wrote an entirely new allocator for XFS whose only purpose in
life is to automatically separate individual streams of user data
into physically separate regions of LBA space.

This was written to optimise realtime ingest and playback of
multiple uncompressed 4k and 8k video data streams from big
isochronous SAN storage arrays back in ~2005.  Each stream could be
up to 1.2GB/s of data. If the data for each IO was not exactly
placed in alignment with the storage array stripe cache granularity
(2MB, IIRC), then a cache miss would occur and the IO latency would
be too high and frames of data would be missed/dropped.

IOWs, we have an allocator in XFS that specifically designed to
separate indepedent streams of data to independent regions of the
filesystem LBA space to effcient support data IO rates in the order
of tens of GB/s.

What are we talking about now? Storage hardware that might be able
to do 10-15GB/s of IO that needs stream separation for efficient
management of the internal storage resources.

The fact we have previously solved this class of stream separation
problem at the filesystem level *without needing a user-controlled
API at all* is probably the most relevant fact missing from this
discussion.

As to the concern about stream/temp/hint translation consistency
across different hardware: the filesystem is the perfect place to
provide this abstraction to users. The block device can expose what
it supports, the user API can be fixed, and the filesystem can
provide the mapping between the two that won't change for the life
of the filesystem...

Long story short: Christoph is right.

The OS hints/streams API needs to be aligned to the capabilities
that filesystems already provide *as a primary design goal*. What
the new hardware might support is a secondary concern. i.e. hardware
driven software design is almost always a mistake: define the user
API and abstractions first, then the OS can reduce it sanely down to
what the specific hardware present is capable of supporting.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

