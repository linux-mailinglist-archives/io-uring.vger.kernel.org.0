Return-Path: <io-uring+bounces-7227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F36A6ED5E
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 11:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA4F1890FE2
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 10:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A27815199A;
	Tue, 25 Mar 2025 10:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oRdac0lw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635851EA7F9
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 10:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742897732; cv=none; b=evRLdxqAkL3LAu+JHRLta0eLOfrs/SFUlOcDOv3vLE5LywIEv8o48sSo6Etfw3DSCY6FRhHkbR7GftKra+VkhHE6qOMKtc3sorqBrbdkxBNaibT0B1RQNEGRb2lI6tzb+fO4tLIxor/A9u3OgbzN2/5J1I4fHrdk06vNtWJ872Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742897732; c=relaxed/simple;
	bh=Ef4HGfhFH2O5B+2fOUPuazpKm+OfKzc+RqhjPOtADx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kID7xmfXTfwr/sep6bXj+ivDbxNPbDiQ5YTwmBVYrpVN0CS67Ls3u7Wk7snWrmT7sbPmP/1NIVuLv86L6MnPyspp6aawyo3eXbCBoiBNZuqH98X2NSA9SbNDCP/QZqkEvmIstaOgSJ+EJW2CyAAXYeXb37KJYmnn4LO3886JdW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oRdac0lw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22580c9ee0aso105741065ad.2
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 03:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1742897730; x=1743502530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOl85kkn8EDad0L2ymXY6WKpnUIUcFZbIKv6caJf9qs=;
        b=oRdac0lwMHoLY2V2nvORNbtoPjkNkOC6xmfpd+36Bpm5rWZ2prgOSvqfT8i760aIsn
         iNBVDR7PZpM7v8y0i727giaNmFjAyESgFHg8kNvjRmhDS059+9G0j2ZYP1ZxM8Iv6phP
         hSCoNoCilYwRth8A0PscgguLNER8o7CWJwX3TXJ2B3f7zd/UMw9vZQx72HiWKQ8dHAi5
         mzXWxuB9fZeVL910QIATuxOJjGqiwmw5qlEtTrW4FI772lo4e756ChV1DV+Un474r+pt
         xF/SMN6d3x2Xt8njzapFDI4O+x9VjBzvB9LhS1cZ/AZXj9wR84JiBGyOkOgiy1Xnjvpr
         ygIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742897730; x=1743502530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOl85kkn8EDad0L2ymXY6WKpnUIUcFZbIKv6caJf9qs=;
        b=Tx72+eLoarb/OYksJUXB8aOPcu8TbcN1HNEsVCD0jE+LSSid52AaitSJJF1Fkf8cnG
         /WHgysQBuN3fYqIWmRaGLR91C25E8FXHPct89KUzvh24jiMO3bReA/nbXWBtBg5Lee96
         jnJDU7aWSj413EPdPSX8Gpp+1ES2rqIJwPUd1JRye+J8HJMGHH+/UPNuCKF+p+8iyXwb
         +IsJpWNG+XJbySleNVeZ7V3BgziQRIwCeJlVYiK8PCU1zfCvKCD5/YASkdCqDZe9FzuI
         XD0gxZ7Mz2W0F1BsRv9wuJ+sUfFLhGs/1ikzkuv+4m+5iOyGMNY/MpoIXeP9lbA7a9J0
         cnsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE03qsqqBWgBKQsve5WFn/YSXxfQXoeX7aGhU/x0O0ZF1GcwJAZ9lN/w8Nk72J+24TQIOP+kA04g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZl76qvl2cKx7phpkjRlswh4tO/qfIfuTLFXkZmK9+YKNTTkqB
	+4pTq0Y9mgRcpr4CrnsM/yh42bSfXERKD9WvxBnf2mT+kTxA1dOcVDKL48Vq36k=
X-Gm-Gg: ASbGnctJ6MOdhGHrT+rh7b4rUUyuCPkhIJFy7g62ff1G3B1OoOeCfPwdnqAg1ryN2AU
	bthGF2oTghHZoU6hgpFF4QKICPIv4sYbIYlv6tX5j4kvrl23XYivz6zzK4TWJRW0jY/f8GrM+XJ
	kF3slSVyPUZMm817cutrn9xhfwnxENb4nNS/AKClUD4dTJ9UW4LHArxOnslawOhNGLVp4bTPwIr
	ub0X/5p9R+ja1OB/MKx9hMvLAQ4kq/ykveC6hMB2QIaHAJhyjal9rjmbZNkHDTBdHx54e8G1auU
	hTrjAgKlKS0qcCkYywcTkXDkXAzhrfxDSjhcY+QwmOWIgzLYZykU0uBbqlQA3tBEv6AVyrO/7Mw
	CcGtkrRzIYVWKwQq+zfJZ
X-Google-Smtp-Source: AGHT+IFYqGWlzR8VFFYDQinF38dCfjE8ZCvm9Px3j5zTOBDRVJpAJEvMsURXg6g0GEroKGOZlrSeAw==
X-Received: by 2002:a17:902:da82:b0:224:162:a3e0 with SMTP id d9443c01a7336-22780e2a37fmr236154395ad.49.1742897729510;
        Tue, 25 Mar 2025 03:15:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-36-239.pa.vic.optusnet.com.au. [49.186.36.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f397cesm85648665ad.52.2025.03.25.03.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:15:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tx1Je-0000000049n-0EgB;
	Tue, 25 Mar 2025 21:15:26 +1100
Date: Tue, 25 Mar 2025 21:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z-KCPvmBO3AeuiDf@dread.disaster.area>
References: <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org>
 <Z9vGxrPzJ6oswWrS@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9vGxrPzJ6oswWrS@fedora>

On Thu, Mar 20, 2025 at 03:41:58PM +0800, Ming Lei wrote:
> On Thu, Mar 20, 2025 at 12:08:19AM -0700, Christoph Hellwig wrote:
> > On Tue, Mar 18, 2025 at 05:34:28PM +0800, Ming Lei wrote:
> > > On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> > > > On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > > > > Yes, NOWAIT may then add an incremental performance improvement on
> > > > > top for optimal layout cases, but I'm still not yet convinced that
> > > > > it is a generally applicable loop device optimisation that everyone
> > > > > wants to always enable due to the potential for 100% NOWAIT
> > > > > submission failure on any given loop device.....
> > > 
> > > NOWAIT failure can be avoided actually:
> > > 
> > > https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/
> > 
> > That's a very complex set of heuristics which doesn't match up
> > with other uses of it.
> 
> I'd suggest you to point them out in the patch review.

Until you pointed them out here, I didn't know these patches
existed.

Please cc linux-fsdevel on any loop device changes you are
proposing, Ming. It is as much a filesystem driver as it is a block
device, and it changes need review from both sides of the fence.

> > > > Yes, I think this is a really good first step:
> > > > 
> > > > 1) switch loop to use a per-command work_item unconditionally, which also
> > > >    has the nice effect that it cleans up the horrible mess of the
> > > >    per-blkcg workers.  (note that this is what the nvmet file backend has
> > > 
> > > It could be worse to take per-command work, because IO handling crosses
> > > all system wq worker contexts.
> > 
> > So do other workloads with pretty good success.
> > 
> > > 
> > > >    always done with good result)
> > > 
> > > per-command work does burn lots of CPU unnecessarily, it isn't good for
> > > use case of container
> > 
> > That does not match my observations in say nvmet.  But if you have
> > numbers please share them.
> 
> Please see the result I posted:
> 
> https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/

You are arguing in circles about how we need to optimise for static
file layouts.

Please listen to the filesystem people when they tell you that
static file layouts are a -secondary- optimisation target for loop
devices.

The primary optimisation target is the modification that makes all
types of IO perform better in production, not just the one use case
that overwrite-specific IO benchmarks exercise.

If you want me to test your changes, I have a very loop device heavy
workload here - it currently creates about 300 *sparse* loop devices
totalling about 1.2TB of capacity, then does all sorts of IO to them
through both the loop devices themselves and filesystems created on
top of the loop devices. It typically generates 4-5GB/s of IO
through the loop devices to the backing filesystem and it's physical
storage.

Speeding up or slowing down IO submission through the loop devices
has direct impact on the speed of the workload. Using buffered IO
through the loop device right now is about 25% faster than using
aio+dio for the loop because there is some amount of re-read and
re-write in the filesystem IO patterns. That said, AIO+DIO should be
much faster than it is, hence my interest in making all the AIO+DIO
IO submission independent of potential blocking operations.

Hence if you have patch sets that improve loop device performance,
then you need to make sure filesystem people like myself see those
patch series so they can be tested and reviewed in a timely manner.
That means you need to cc loop device patches to linux-fsdevel....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

