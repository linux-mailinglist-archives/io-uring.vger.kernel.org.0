Return-Path: <io-uring+bounces-6851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7166BA49303
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 09:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09769161E83
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 08:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314A31D63CF;
	Fri, 28 Feb 2025 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lr/ZVSJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DC1A8F8A
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 08:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740730274; cv=none; b=i/GwfLPFRwW4xhsONC9hFwUd+n23Yxlzc8AuFzTnXqxxynlXncvRJeHsgcmYrs+X9lwtu1RNtu4OwJnYwjfaDut7RDbGkktMxDEopVPfyEFervXjm7AlsVnoC0P08/FuvqQP7GUPCmTnQZHZ7ZrX33ofDckd4AcUx3zKxn1qkSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740730274; c=relaxed/simple;
	bh=BMB/Hdli/hpV54E+IrYEmKYG596SW/4RRLWDvGtQ5tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIcOAO4EshPQVlEAvQqkBXMPsbHsHdREyCs2DFYp1xj1IVh+LGlZnSavQGQHhqz7bH936YGUDCT9bYzEtpU728p/fmYGnWDPseYYUJObqecOTneoVEDJ9CooQU1ZMW1xAw7yECnnEDMo36IgO+NE1gxmTWWZlUTgYsN5neo1iAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lr/ZVSJJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740730271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6bYndnnhsKipQ6hxTRPQ/mbEwD8lnDV7Rugy7tX+s/I=;
	b=Lr/ZVSJJEDlgJjUY0mXUARQFyC61cJfIx3ru9rsW3yNlk+nd0FTCfIFI4qHtkpzAxiMCCR
	fKd71/6hXs88ewJWYZpjctmLOQG+NsXNis6ljVH+wW0tGRS7+iXFIxwhaeLZMbMaDud4MS
	lxA1wDU2UdzN1Vncnc3ncluFpFrTBKA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-LWpd0YdXOKGwfvZYcMN0PQ-1; Fri,
 28 Feb 2025 03:11:09 -0500
X-MC-Unique: LWpd0YdXOKGwfvZYcMN0PQ-1
X-Mimecast-MFC-AGG-ID: LWpd0YdXOKGwfvZYcMN0PQ_1740730268
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96A9B1800879;
	Fri, 28 Feb 2025 08:11:07 +0000 (UTC)
Received: from fedora (unknown [10.72.120.18])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F343E19560AB;
	Fri, 28 Feb 2025 08:11:00 +0000 (UTC)
Date: Fri, 28 Feb 2025 16:10:54 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 1/6] io_uring/rw: move buffer_select outside generic
 prep
Message-ID: <Z8FvjnXq3RpX4eZ3@fedora>
References: <20250227223916.143006-1-kbusch@meta.com>
 <20250227223916.143006-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227223916.143006-2-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Feb 27, 2025 at 02:39:11PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Cleans up the generic rw prep to not require the do_import flag. Use a
> different prep function for callers that might need buffer select.
> 
> Based-on-a-patch-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---

Reviewed-by: Ming Lei <ming.lei@redhat.com>

thanks,
Ming


