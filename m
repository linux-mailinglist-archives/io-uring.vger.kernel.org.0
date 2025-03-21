Return-Path: <io-uring+bounces-7162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A66A6BDEB
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 16:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99E7217CC1E
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 15:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDD116FF37;
	Fri, 21 Mar 2025 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jMQU9IVw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E4D5CDF1
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742569424; cv=none; b=oQSsBN7KTkk4Ny6wpjro6y79zwqgJyy9dDDwx7Y66AD2mb9PGRs+3X6qTHsGAVK/jc/si53kd6HwJUTBwmmBios1iFSHb5TPWlvmdOTp1B1zqnryXoH58bRE0fDi7YiRnJ1hOOZanyTNe8h6pkZuRVQKECbge6ntsp8rZoia2Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742569424; c=relaxed/simple;
	bh=wIwPqNf+pRjt4uNSq9rwCPSa2+uz5oUQUwgWUwYYCKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPzu9zE1uYd2XVRccCNrN4fYFZpnv47O55qACT3kD50rfLnyVkfy2lKCvpUbYJHFUBUaon2CBBESbbDHZtjY3+xGcIXYcS32jMTDU343ZtO1LFZ354B5q4/TDa4CyWntHAYCAYqilM85O0yCwJoH2vaChoZh7LwdpZohkmEH14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jMQU9IVw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742569422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2A++F+sq/ZAlpvYLU8tCQWNm6rByPWWkgnWcUt5hC2w=;
	b=jMQU9IVwbQw40MtwLv7l6WUz7XqRCedWgD1hYwS1MX7aGf3Dvow21V9lgACQszKm1Ldx/6
	H39G0cx+GkBPWwXAFkdRnjdO7/wLmWgd7ErEyd0WIzZ90ucqQXhXDnaYcQfnGa4dldiUxV
	qQZPMebM9pW6/CbXpVbFRo/qUh0aZWs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-JL2PPU3ePL6JvgV0kDxejQ-1; Fri,
 21 Mar 2025 11:03:39 -0400
X-MC-Unique: JL2PPU3ePL6JvgV0kDxejQ-1
X-Mimecast-MFC-AGG-ID: JL2PPU3ePL6JvgV0kDxejQ_1742569418
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91FC118011C1;
	Fri, 21 Mar 2025 15:03:37 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 120C03001D16;
	Fri, 21 Mar 2025 15:03:33 +0000 (UTC)
Date: Fri, 21 Mar 2025 23:03:27 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [bug] kernel panic when running ublk selftest on next-20250321
Message-ID: <Z91_v1Ce2sCFBNSG@fedora>
References: <Z9140ceHEytSh-sz@fedora>
 <e2a4e9ac-f823-4068-918f-e4ab1180b308@gmail.com>
 <10a64355-92d5-4580-be6c-84da18af22ef@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10a64355-92d5-4580-be6c-84da18af22ef@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Mar 21, 2025 at 08:40:57AM -0600, Jens Axboe wrote:
> On 3/21/25 8:40 AM, Pavel Begunkov wrote:
> > On 3/21/25 14:33, Ming Lei wrote:
> >> Hello,
> >>
> >> When running ublk selftest on today's next tree, the following kernel
> >> panic is triggered immediately:
> > 
> > Jens already stumbled on that one, it's likely because the
> > cached structure is not zeroed on alloc. I believe the
> > troubled patch is removed from the tree for now.
> 
> Yep, ran into the same thing this morning, and yep the two last patches
> in that series got dropped until this is resolved. Ming, if you use my
> current for-next branch, it should all be good again.

Yeah, looks everything is good after reverting the following two patches:

Revert "io_uring/cmd: add iovec cache for commands"
Revert "io_uring/cmd: introduce io_uring_cmd_import_fixed_vec"

BTW I feel io_uring_cmd_import_fixed_vec is useful for using ublk
zc to write stacking target, plain readv/writev works just
fine without zc.




thanks,
Ming


