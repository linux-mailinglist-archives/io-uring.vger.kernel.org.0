Return-Path: <io-uring+bounces-7386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15211A7B488
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 02:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99598188E3C2
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 00:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6108218EFD4;
	Fri,  4 Apr 2025 00:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QbbsgCBP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0DC182BC
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 00:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743726225; cv=none; b=jWmD1AyWu8AHL8b/P6jFv6o+eRDPtrPiV+iMesb12Enov/ULqPnsk5hB0HA6emkqWXOn6N25fle94FIJ8+lNYGcHXH6BPBkCAiNfpgGOgwZzdD1OGoHrmxcocqu/WoL8o2EWzNvrxyIblL7nm9UViGswKYgellk2HwjWCKJtyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743726225; c=relaxed/simple;
	bh=CDqw9+yFfLVTJ86Y3VsW0/1OCUe1T3Pt5VlMUVXgpOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0NkQ9VNDsUv9LOdeZp8wXAPlc+HkdQfnrqCMODQBONMdSmiTvvcARg0msOili2O82KNnmPqPflOuAz6TE4/JKJKBdF1/pMf2wv/5+7lakh7ziGycqvz6Of6RpTX/3xfTVwoLeVOK6imNcpnqRKbk20m/nexcSr0h3Jye6VJVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QbbsgCBP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743726221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dCuw6/ch7yhJydjtC2hfsCaVMfm5kf34efage96n8Ow=;
	b=QbbsgCBPlSJhc5umh5qhRzDC5pu3566J+AAhQdt02xr4TvOcSWYFJ7+GuANgQuT6Rvaoz6
	1jpnsWfs2oO974sfM7y2oieCavCLWKge0FZMfsrUfr0YfZCSRr1gUkDuE4yjsSe1w553aU
	fHkURsJ5mM4t+GNpwuMTWXohl0Lzi4E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-Tv7ymy9hOHenTsVjNl7Ryg-1; Thu,
 03 Apr 2025 20:23:37 -0400
X-MC-Unique: Tv7ymy9hOHenTsVjNl7Ryg-1
X-Mimecast-MFC-AGG-ID: Tv7ymy9hOHenTsVjNl7Ryg_1743726216
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F8001955BC9;
	Fri,  4 Apr 2025 00:23:36 +0000 (UTC)
Received: from fedora (unknown [10.72.120.26])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D65A180176A;
	Fri,  4 Apr 2025 00:23:31 +0000 (UTC)
Date: Fri, 4 Apr 2025 08:23:25 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Uday Shankar <ushankar@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH 4/4] selftests: ublk: enable zero copy for stripe target
Message-ID: <Z-8mfVD81ZUZ6FEO@fedora>
References: <20250325135155.935398-1-ming.lei@redhat.com>
 <20250325135155.935398-5-ming.lei@redhat.com>
 <Z+8O4Hro3QeNenjE@dev-ushankar.dev.purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z+8O4Hro3QeNenjE@dev-ushankar.dev.purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Apr 03, 2025 at 04:42:40PM -0600, Uday Shankar wrote:
> On Tue, Mar 25, 2025 at 09:51:53PM +0800, Ming Lei wrote:
> > Use io_uring vectored fixed kernel buffer for handling stripe IO.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  tools/testing/selftests/ublk/Makefile |  1 +
> >  tools/testing/selftests/ublk/stripe.c | 69 ++++++++++++++++++++-------
> >  2 files changed, 53 insertions(+), 17 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
> > index d98680d64a2f..c7781efea0f3 100644
> > --- a/tools/testing/selftests/ublk/Makefile
> > +++ b/tools/testing/selftests/ublk/Makefile
> > @@ -17,6 +17,7 @@ TEST_PROGS += test_loop_05.sh
> >  TEST_PROGS += test_stripe_01.sh
> >  TEST_PROGS += test_stripe_02.sh
> >  TEST_PROGS += test_stripe_03.sh
> > +TEST_PROGS += test_stripe_04.sh
> 
> This patch is missing the new file test_stripe_04.sh, causing ublk
> selftests to be broken on block/for-next. Can you fix?

The fix is posted out:

https://lore.kernel.org/linux-block/20250404001849.1443064-1-ming.lei@redhat.com/

Thanks for the report and sorry for the trouble.



Thanks,
Ming


