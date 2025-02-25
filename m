Return-Path: <io-uring+bounces-6733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E88A43869
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57DBA188A66E
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C86263C77;
	Tue, 25 Feb 2025 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/rkIfpK"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BDB263C65
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 08:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473771; cv=none; b=tcf3N+jvH8fC2dBqfY6FUOvgDtSZViXtRu0qGiNDfIaw11BLMfzUUxy7Da5Z+dqxhelbBWdDQlLfeEkbkys0SWWCQcNUOUTL434QNYNaEzy3rsujoT8oZYdnLUkY2pnjsgNlnAD3MFJYXH8VGg0F3Y4++x7gjnzkvm5X60uwQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473771; c=relaxed/simple;
	bh=NPKL41k5BNMZlbjYP8haqkRZom0Tuw2ud89Cd4ecX+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsiNMlIdDIAkrfnzBuzayMK7BNS/ui7YCY6+OU7r/vh5MvQ6nhw1TttNOnPcgLAUDZfWdIL1bWpNSKUxFj6C3uSD+oEM/Ve6ZCILJoYB6pGNDwUjFAxtVq8Kkppr2uxJvog496Hl+CtZ00J8SRFu8uBwNGbotO31ImDr+kNiK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/rkIfpK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740473768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FpV0Gb9w1szOvUDIfK5T9ecv7mT6drF4hLfD7prsLgw=;
	b=Z/rkIfpKAlNG0NL4EwAVQ0Bz+SikLmmW/YRET+5B/J1OnZh731S9nnafH4Fb8cqVIptLlS
	mLnb4QDYSW31K9dMGkiLcJAmilgsZoHDDNTsrtLaZpxwBjZ+y4ecEe+cFkaUALWe5+vqFy
	Z7xHNmeQQs7GQii2oYc0oTO9Hnk7r4I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-1roj5FpZOWOR89E_UDD_Bg-1; Tue,
 25 Feb 2025 03:56:04 -0500
X-MC-Unique: 1roj5FpZOWOR89E_UDD_Bg-1
X-Mimecast-MFC-AGG-ID: 1roj5FpZOWOR89E_UDD_Bg_1740473763
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C63C18D95E0;
	Tue, 25 Feb 2025 08:56:03 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E03E41800358;
	Tue, 25 Feb 2025 08:55:57 +0000 (UTC)
Date: Tue, 25 Feb 2025 16:55:50 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 05/11] io_uring: combine buffer lookup and import
Message-ID: <Z72FloDakU1EJPCZ@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-6-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-6-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Feb 24, 2025 at 01:31:10PM -0800, Keith Busch wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Registered buffer are currently imported in two steps, first we lookup
> a rsrc node and then use it to set up the iterator. The first part is
> usually done at the prep stage, and import happens whenever it's needed.
> As we want to defer binding to a node so that it works with linked
> requests, combine both steps into a single helper.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


