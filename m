Return-Path: <io-uring+bounces-7390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B27A7B6AF
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 05:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9923C173C2B
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 03:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C172433A8;
	Fri,  4 Apr 2025 03:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SG23wHfY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2232E62D1
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743738412; cv=none; b=DmIqpx65BMM1j79AA+AAwv2V89lym/OehbDZ/nncVDBeTgXqum1qg9XrvLtlukyD6lJzlfq3KSyOwsrV6rAsLI+PAN2VvosM//cm4EGuufTX5z6POFuHTv4XwUvZswcCimdgOVLDJ92Ykj06iwXoP6T6f2gWgRL7tJZTDVITSkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743738412; c=relaxed/simple;
	bh=w5X/jaCe7ri912P/vMX809Gcd7JQm/JDs2LvPBbruIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCK+nwFXgFXGj/aAA8sKtgJxhV5yFE1ii4N+39HEfcT0pf6G16+6tHo/HW+TQVmHDHCaqoBymdUf3TSGZe7tPCpjkWE1n2kVLcIRuOXuJzF4h9T3YiCfT83ON4ttPEtwqsok+c0adF9VvLlu0yIyXWsho/+l424zOAln4eRkRFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SG23wHfY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743738407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=INWHs+Or4iog6uMxjsayHfcr6SLEGcZ61h3hQKkUjH0=;
	b=SG23wHfY/ENoL4qzAz5tAadDgHLARnyUTi3OLlnnztoXavQcl3wDFMFnCewm6hm4st8Iax
	3wjeJ1+kvJ4m3JPv8a9hX/HuaMkrz/ZS45lYKtjNJBnxT+u6oemoMio2TY3OC+cs64XQxy
	IoC2gS0/T7zSLglGxtAeRhAT2+ictGU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-6qCXVuV1Ne2_QFsdJINZ2Q-1; Thu,
 03 Apr 2025 23:46:40 -0400
X-MC-Unique: 6qCXVuV1Ne2_QFsdJINZ2Q-1
X-Mimecast-MFC-AGG-ID: 6qCXVuV1Ne2_QFsdJINZ2Q_1743738395
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 278A819560BC;
	Fri,  4 Apr 2025 03:46:35 +0000 (UTC)
Received: from fedora (unknown [10.72.120.26])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AC0F3000706;
	Fri,  4 Apr 2025 03:46:29 +0000 (UTC)
Date: Fri, 4 Apr 2025 11:46:23 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>
Subject: Re: [PATCH] selftests: ublk: fix test_stripe_04
Message-ID: <Z-9WD-sqnPEzUqyh@fedora>
References: <20250404001849.1443064-1-ming.lei@redhat.com>
 <174373319721.1127267.3756134797323684566.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174373319721.1127267.3756134797323684566.b4-ty@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Apr 03, 2025 at 08:19:57PM -0600, Jens Axboe wrote:
> 
> On Fri, 04 Apr 2025 08:18:49 +0800, Ming Lei wrote:
> > Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
> > added test entry of test_stripe_04, but forgot to add the test script.
> > 
> > So fix the test by adding the script file.
> > 
> > 
> 
> Applied, thanks!
> 
> [1/1] selftests: ublk: fix test_stripe_04
>       (no commit info)

Hi Jens,

Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
is in io_uring-6.15, so this patch should be merged to io_uring-6.15 instead
of block-6.15.


Thanks, 
Ming


