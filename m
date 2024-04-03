Return-Path: <io-uring+bounces-1386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 370138978C4
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 21:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6E7F28B224
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34DF1D54B;
	Wed,  3 Apr 2024 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+yePXXw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657B839E1
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 19:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171063; cv=none; b=s1qUmrZOR5+RcNU0zkyPrSbf+xLxURYQTCU91hJ9QLGUXVvVWffHQ1cROocZfDYvibC7TTXIgcCa2xaXqGZEzy3IKOi4naTzwlhJFTWktwwu0G3jQm5sk1w6/O/gA7Ctjqv1RhQPPzM3mdJzmpHD1EBRb5Rd3PmChq+iJV8h/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171063; c=relaxed/simple;
	bh=C2/9RYNrbsh6s9i3hBqXY3zHS5yqKVHhpnjqVZMph9Q=;
	h=From:To:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Cj2lraunj2kGtjt4smlbGnkM/8WChDdrYBofhX4vBhbCzrwZzpqFp4VDOH7utFHGEKBtuhbgn/iPEr570XAFIOBA9FkTGdtenq434RzM51ewlXjm07X8ANBS807KjPQaV8rnlNPnayOfAkBIQ40ke0Y+ycCCEhcWB6VtM7DFYRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+yePXXw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712171061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HKUFJu2te9udaixDtns0olo8J+/sYkP5CLHchsIpPM0=;
	b=T+yePXXwVxLCrWepm/D3Fw2IkFiDp0VVnyJlb1C+ys5SfHVXxxG8ALKz1eshjFcbqd6OVG
	KRf2rT/Bfo9WP/+huRoSBlHjtbNIjsBZy7WxH47JDjyiumaDs/dWH9Ec/9lZNkuJAWinRe
	9oDTw2/el5sL2mzgsNbod0ythACj04U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-zvA7R_NTP-6w7RciBlZTAQ-1; Wed,
 03 Apr 2024 15:04:19 -0400
X-MC-Unique: zvA7R_NTP-6w7RciBlZTAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E33E938049F3
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 19:04:18 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.34.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C36502166B32
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 19:04:18 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] man: fix IORING_REGISTER_RING_FDS documentation
References: <x49o7aqs2sp.fsf@segfault.usersys.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 03 Apr 2024 15:04:18 -0400
In-Reply-To: <x49o7aqs2sp.fsf@segfault.usersys.redhat.com> (Jeff Moyer's
	message of "Wed, 03 Apr 2024 14:45:42 -0400")
Message-ID: <x49jzles1xp.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

It turns out unregister has the same bug.  I'll send a v2.

-Jeff

Jeff Moyer <jmoyer@redhat.com> writes:

> The documentation for the 'arg' parameter is incorrect.  Fix it.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
> index fbfae2a..09823bd 100644
> --- a/man/io_uring_register.2
> +++ b/man/io_uring_register.2
> @@ -528,8 +528,8 @@ of the ring file descriptor itself. This reduces the overhead of the
>  system call.
>  
>  .I arg
> -must be set to an unsigned int pointer to an array of type
> -.I struct io_uring_rsrc_register
> +must be set to a pointer to an array of type
> +.I struct io_uring_rsrc_update
>  of
>  .I nr_args
>  number of entries. The


