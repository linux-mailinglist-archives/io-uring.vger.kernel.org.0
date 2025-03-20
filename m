Return-Path: <io-uring+bounces-7139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C30E2A69DC9
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 02:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7237A8A348C
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 01:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC181B85C5;
	Thu, 20 Mar 2025 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="abrR/Kbn"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886E770807
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 01:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742435659; cv=none; b=tTjjBhxBg0JaLNhq1oSjy0j/UUI6r45acvM2RaDY1/+xhNhazIXXn9IrukJVsEsv0wujGijZ9inV9NtoHv8PVNX04qMGc+HErb9iuunDo6BZBHbMwrq4b/nFHSFT8BHx7rb18sw9ZRmbbka4x6iK+WK1Lvfjc10xRD+4W3ODeX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742435659; c=relaxed/simple;
	bh=QGSaxFO0QMwdVEC/h8PanKsgUxKJlN2XevO7hBWd9NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cev+LHKwtplVBr7LxjVOrLzqSzXyeJB0DhHKP0xGq5FnY/H1UGAPB5PY8wsHAxYIP7n7U3SfbZl/24isWzdtckMNcTznYcryw5UuHI/LRvd6dni9iPbforZgJm2Yk+FN/VNgNa9jo++IrT6CA6EmJaO38PWuocYiD1Fv1clJ2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=abrR/Kbn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742435654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVhGKns/Mdbu0IrhF0QwPcQUJXq5WBpNvo7BxQCX6Sg=;
	b=abrR/Kbnl8yaqXnuyZxXavMTWXFbzM9TnwoNjdZgfm0FhJyRzWpKTs5HZUZfsGBfRDSQxJ
	OJ7RPOQiDYYv7jzuUzotatlJftj+53vUZPHSUjHoSwkGDWrQ2cKw682RRihP7jk0y3CDcU
	q7v55a0feoFAc2kzUmDqX4xy8qQZd68=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-taJf7LwEMxWKEcpite2SaA-1; Wed,
 19 Mar 2025 21:54:10 -0400
X-MC-Unique: taJf7LwEMxWKEcpite2SaA-1
X-Mimecast-MFC-AGG-ID: taJf7LwEMxWKEcpite2SaA_1742435649
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D15F19560AB;
	Thu, 20 Mar 2025 01:54:09 +0000 (UTC)
Received: from fedora (unknown [10.72.120.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB1693001D15;
	Thu, 20 Mar 2025 01:54:06 +0000 (UTC)
Date: Thu, 20 Mar 2025 09:54:00 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 0/2] liburing: test: replace ublk test with kernel
 selftests
Message-ID: <Z9t1OIWJyzJDCcCW@fedora>
References: <20250319092641.4017758-1-ming.lei@redhat.com>
 <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
 <5d5c5b74-2da6-4118-9559-4dee0e9d9a72@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5c5b74-2da6-4118-9559-4dee0e9d9a72@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Mar 19, 2025 at 07:51:02AM -0600, Jens Axboe wrote:
> On 3/19/25 7:47 AM, Jens Axboe wrote:
> > On 3/19/25 3:26 AM, Ming Lei wrote:
> >> Hi Jens,
> >>
> >> The 1st patch removes the liburing ublk test source, and the 2nd patch
> >> adds the test back with the kernel ublk selftest source.
> >>
> >> The original test case is covered, and io_uring kernel fixed buffer and
> >> ublk zero copy is covered too.
> >>
> >> Now the ublk source code is one generic ublk server implementation, and
> >> test code is shell script, this way is flexible & easy to add new tests.
> > 
> > Fails locally here, I think you'll need a few ifdefs for having a not
> > completely uptodate header:
> > 
> > ublk//kublk.c: In function ?cmd_dev_get_features?:
> > ublk//kublk.c:997:30: error: ?UBLK_F_USER_RECOVERY_FAIL_IO? undeclared (first use in this function); did you mean ?UBLK_F_USER_RECOVERY_REISSUE??
> >   997 |                 [const_ilog2(UBLK_F_USER_RECOVERY_FAIL_IO)] = "RECOVERY_FAIL_IO",
> >       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > With
> > 
> > #ifndef UBLK_F_USER_RECOVERY_FAIL_IO
> > #define UBLK_F_USER_RECOVERY_FAIL_IO   (1ULL << 9)
> > #endif
> > 
> > added it works as expected for me, but might not be a bad idea to
> > include a few more? Looks like there's a good spot for it in kublk.h
> > where there's already something for UBLK_U_IO_REGISTER_IO_BUF.
> > 
> > Outside of that, when running this in my usual vm testing, I see:
> > 
> > Running test ublk/test_stress_02.sh                                 modprobe: FATAL: Module ublk_drv not found in directory /lib/modules/6.14.0-rc7-00360-ge07e8363c5e8
> > 
> > as I have ublk built-in. The test still runs, but would be nice to
> > get rid of that complaint.
> 
> Oh, and looks like it should also skip the test if an argument is
> passed in. My usual setup has 4-5 devices/paths defined for
> testing, and tests that don't take a file argument should just
> skip.
> 
> Forgot to mention, that unifying the selftests and liburing test
> is a really good idea! Will make it easier to sync them up and
> get coverage both ways.

Yeah, the kernel selftest side can be thought as upstream, :-)

I just sent three ublk kernel selftest patches, which covers all
the above problems. With the three changes, only three lines of code
change on test_common.sh is needed for liburing test:

```
#liburing
UBLK_TEST_SHOW_RESULT=0
UBLK_SKIP_CODE=77
[ $# -ne 0 ] && exit "$UBLK_SKIP_CODE"
```

Thanks,
Ming


