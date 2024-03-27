Return-Path: <io-uring+bounces-1266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4747788F01F
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 21:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F19B4295EE3
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EA9130AE8;
	Wed, 27 Mar 2024 20:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WdV7v24D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1F152DF0
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571511; cv=none; b=qFP5b6mRnzPEDkjFMK3YeovyMqIiKeco2Y+N9ot6cVB9DuaXcAGaQ4caEUQUughQvEayvb/lnkrBrZoDU5DVbxtyM2CtV2RS0KOqXv4udkTgK44EQmmv1rZpyROaSQXnBRS82Az3uQuDADpVIyHJQ7rsmBhLpjnp0vpn9SAF/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571511; c=relaxed/simple;
	bh=t9C9+riY1OxmsAmH5QBPtHJT8HnbNBNjvpO0E8IF0BE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+BxtZx3nKt7qUBcyG57CzO1N9CVxLjVWqhqdJQQMJ92OyAUOAdGFN8KhKhDoN5JonYqdXbdXAVwY5jOvx6w0US+Nq0sJatUFHrF+YFJIvp8QMrs1su7Se31w/gwvbrv/UugzZCeXALTaEbs4rVLdBuRgOaUCkH3KPt7GyyJ28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WdV7v24D; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e0ae065d24so2387985ad.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711571509; x=1712176309; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xsbDq/umAVs2THPOn+dgmzNcXWhcjS94eKkuWI7aCcw=;
        b=WdV7v24DFxW8nfNW5OWhAwfjj+i+ZVdBXd9AjRVX3+FR6PNQyPvX86pyquKqdmn6BS
         bfc15NGU+fFCY9xMyEo0TctEynV+f47N5thGqFoiVeZ9Leo0Hqd9BEL7Urs4kMSYNY+v
         uMYHsfFr6osUaF6beCF3AsA02QuXQ58hVSP4ADsOivo2jCCgU1tKef5h3bICgvuqLECd
         t75vl4QJfwrdmNsiMu8say58xXLMtyw0PuQAqFH6gvfQLrmN4cKCefKboz5ZDBLeM9Pe
         TEiwmjp1GzixsJWd7GzRU50cLPloHmf0kM1OBSEn37xY0s7glSCfe+zFvhF+Q0ziQCgW
         MaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711571509; x=1712176309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsbDq/umAVs2THPOn+dgmzNcXWhcjS94eKkuWI7aCcw=;
        b=JZXcT7MfkfmDIKFJZTwBtvLuELbPcLqMWbwm8zsy4cTgXQgdIf6bovWj9SlSEI3Ia+
         /67zb1qjK4baqI6GaZQEfEtEAiAqu6whtKR26Z8+tu4Dggyvm+r5vcimIGaPnOoQXlDi
         bVnHRzO7QjCM7uV3DUy+UuC6QsLVMD1hi+JxtZ8MEVscnccFIrwbdPW1YvgMQKi6QyCf
         5ixuvMM9f8bu/8Gssyk04wAYgOHQD44T4FQDE9cyFHjtGOPY14iQ6JMe5hwLfJaEnnlN
         F+LQiHu744QmMIDmp+x0YAhjOVmksHiO/SGW0SOTOJj0Trc5HRmxycVTc/NoMqF4BMDV
         gVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3kQ0KYmhxlIHTZid8iS0dRGYFHNdrqYxax8NWLDqF6VcMAlNG3FHHwOMjmwNn/b5RKxiJiGt2/rAZdEo6oqb8gBQlk4WTmUM=
X-Gm-Message-State: AOJu0YwLHpbDXdkOV5CSUvAPjW3M/Nb6U8G5cjNY0Hd2NddFLgFXSFbF
	Zi73QdApF4ZHqDlr0jA/voUs+MXiDKBHoK4xvhNkTfqj0FwCnh1m+wYiq+U0U2c=
X-Google-Smtp-Source: AGHT+IHM4Tr0BQ+ZyOuGEh7PBr8lX9a5mFa0hqjuG33bAQkeUreuKwQCfXdzVyFJvoKTjvvS6rj26w==
X-Received: by 2002:a17:903:8cd:b0:1df:fa1a:529f with SMTP id lk13-20020a17090308cd00b001dffa1a529fmr955250plb.24.1711571509203;
        Wed, 27 Mar 2024 13:31:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903120d00b001deed044b7dsm4122560plh.185.2024.03.27.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 13:31:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpZw1-00CItN-2k;
	Thu, 28 Mar 2024 07:31:45 +1100
Date: Thu, 28 Mar 2024 07:31:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v6 00/10] block atomic writes
Message-ID: <ZgSCMXKtcYWhxR7e@dread.disaster.area>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgOXb_oZjsUU12YL@casper.infradead.org>

On Wed, Mar 27, 2024 at 03:50:07AM +0000, Matthew Wilcox wrote:
> On Tue, Mar 26, 2024 at 01:38:03PM +0000, John Garry wrote:
> > The goal here is to provide an interface that allows applications use
> > application-specific block sizes larger than logical block size
> > reported by the storage device or larger than filesystem block size as
> > reported by stat().
> > 
> > With this new interface, application blocks will never be torn or
> > fractured when written. For a power fail, for each individual application
> > block, all or none of the data to be written. A racing atomic write and
> > read will mean that the read sees all the old data or all the new data,
> > but never a mix of old and new.
> > 
> > Three new fields are added to struct statx - atomic_write_unit_min,
> > atomic_write_unit_max, and atomic_write_segments_max. For each atomic
> > individual write, the total length of a write must be a between
> > atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
> > power-of-2. The write must also be at a natural offset in the file
> > wrt the write length. For pwritev2, iovcnt is limited by
> > atomic_write_segments_max.
> > 
> > There has been some discussion on supporting buffered IO and whether the
> > API is suitable, like:
> > https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/
> > 
> > Specifically the concern is that supporting a range of sizes of atomic IO
> > in the pagecache is complex to support. For this, my idea is that FSes can
> > fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
> > extent alignment size, which should be easier to support. We may need to
> > implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
> > have no proposed solution for atomic write buffered IO for bdev file
> > operations, but I know of no requirement for this.
> 
> The thing is that there's no requirement for an interface as complex as
> the one you're proposing here.  I've talked to a few database people
> and all they want is to increase the untorn write boundary from "one
> disc block" to one database block, typically 8kB or 16kB.
> 
> So they would be quite happy with a much simpler interface where they
> set the inode block size at inode creation time, and then all writes to
> that inode were guaranteed to be untorn.  This would also be simpler to
> implement for buffered writes.

You're conflating filesystem functionality that applications will use
with hardware and block-layer enablement that filesystems and
filesystem utilities need to configure the filesystem in ways that
allow users to make use of atomic write capability of the hardware.

The block layer functionality needs to export everything that the
hardware can do and filesystems will make use of. The actual
application usage and setup of atomic writes at the filesystem/page
cache layer is a separate problem.  i.e. The block layer interfaces
need only support direct IO and expose limits for issuing atomic
direct IO, and nothing more. All the more complex stuff to make it
"easy to use" is filesystem level functionality and completely
outside the scope of this patchset....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

