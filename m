Return-Path: <io-uring+bounces-7056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C24A5D607
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 07:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FDFC3B78F1
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 06:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48871E47C2;
	Wed, 12 Mar 2025 06:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OPTnXOxt"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638761D86F2;
	Wed, 12 Mar 2025 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741760649; cv=none; b=OK0H1OkXU7f81OpbfvYem7oMXEnrX1ZRtRnxpdQApzjikBX1alOSzntuNZ9IsnW1T87lgVBDPNABpJKyC0ONHYWRf26DOHJ59se2zOqqhM0hB1C5WLCrinJrSVuaF8iCvzD1MfCaS7pA5HXVo/P6tQ/cnLai6f6udPwuf24NQgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741760649; c=relaxed/simple;
	bh=v0gdL/3I1B1zmaBLpSypGmJbmVvLAJ0k7+jEv5AuK60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyeKYLRDCIUVFkAVtRWeWEYst5lB4RUe0+IgIE3dKpNUXhoghFcWRw3DEIcdyHn3+kZlT//YG42khu1jXSuzJ8L/yGzFGIqwwlDqQuFvZfFAUMZVdUiLFNopp8QWcSPYnLVhCoG5fiRehvkJC0wfpsJlyIgzgnaOEknuQQTvdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OPTnXOxt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0AMBUI0pkHIlozu33qNSwEjssVugwAFn0k7gmS65+Tk=; b=OPTnXOxttEqQHGWdfiMgFAY85n
	IRX7WnBXAE/qlCH81CoW4+g7FDPqsU210mPTFYyOY+ZLyosen4fBL0ilYF5wwH1hdJrrR7W+kcmHP
	YmLPyS69h/2PoXfbzgQcYu7mhum1G/VbJ36GgBMebOpMk84ygJSnNauWXRFCiX7ucqg4iB3jPkYtA
	5f4tyNmSeUIv5fiFUlg9SSxiLTIXX7CFaocl025VUTcyVnV+LGrSoArbd1j9zwM0adlqfdaGxqNUl
	tzgR+Zr1dzfXJN8/YbFjC3iBY34RpjZJbiL4dEq6vEUFflQJ1C+cMVLE70HtPW4Ag3b9fCF9qDVTh
	+KQiZI0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFVe-00000007aIv-2N0P;
	Wed, 12 Mar 2025 06:24:06 +0000
Date: Tue, 11 Mar 2025 23:24:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Ming Lei <ming.lei@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9Eohuavq6847KOt@infradead.org>
References: <8adb8df2-0c75-592d-bc3e-5609bb8de8d8@redhat.com>
 <Z8Zh5T9ZtPOQlDzX@dread.disaster.area>
 <1fde6ab6-bfba-3dc4-d7fb-67074036deb0@redhat.com>
 <Z8eURG4AMbhornMf@dread.disaster.area>
 <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9DymjGRW3mTPJTt@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 12, 2025 at 01:34:02PM +1100, Dave Chinner wrote:
> Wrong.
> 
> Speculative non-blocking IO like NOWAIT is the wrong optimisation to
> make for workloads that are very likely to block in the IO path. It
> just adds overhead without adding any improvement in performance.

Note that I suspect that most or at least many loop workloads are
read-heavy.  And at least for reads NOWAIT makes perfect sense.

> Getting rid of the serialised IO submission problems that the loop
> device current has will benefit *all* workloads that use the loop
> device, not just those that are fully allocated. Yes, it won't quite
> show the same performance as NOWAIT in that case, but it still
> should give 90-95% of native performance for the static file case.
> And it should also improve all the other cases, too, because now
> they will only serialise when the backing file needs IO operations to
> serialise (i.e. during allocation).

And I agree that this should be a first step.

> *cough*

The whole ublk-zoned is a bit of a bullshit thing where Ming wrote
up something that barely works to block inclusion of the zloop driver
we really need for zoned xfs testing.  Please don't take it serious.


