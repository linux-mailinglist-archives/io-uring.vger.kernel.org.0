Return-Path: <io-uring+bounces-6728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 703A5A437CC
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F34F07A4DDF
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6052139C8;
	Tue, 25 Feb 2025 08:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCWfPCmN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3111C8607
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 08:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740472661; cv=none; b=JJtkk1aEIGnm7XC9n91BizZiiytO4nOdV6T+nPukuDYS7OBuWwfkKrp7heY5OFbloCiy5wJ7lMwc9ISTvMVcSlFPOJGdk82N9NMYnbmQNyjSGA5tTtlxE+7eTo2f24xNKgFeSA78z0blNgIfksXFSpX6lgtfIKXmrtMyYvonsBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740472661; c=relaxed/simple;
	bh=6F4YYXLZUwyXNPnGHw+FF3dVGBHe52pY87rmvu1Bm6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaetSFq8BcRDKZ9RomwkjXkr4xemQP9YhEgGfNJKdNrr1FSMYglEcluoV2ahh8tnPx+AnaEJnSFGDRC7nJDvtjigeysQB2ar1rSm4V7z1bO6jtyGC3YjF/UWxLGv5UvvMmOycOxq7hUS3FkCR9Yi++4FTErV7HxNgJSVaPnoTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iCWfPCmN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740472658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FdUebZZOtGzmcl1QLylvNFIYhCCJhFPOqqpv7jR86pI=;
	b=iCWfPCmNs1LjJxK19sra2hAGHvymH7n7WNcdsXfhF/hsEAyPgQBR03Mh3yg3mz2U8d5K87
	GRpkjcE+o1OeBl4oHE3Ox5cfm/CQevQNTuEU5wCDAbJWKNaJmsXGN/nld86COkhru6o8mj
	Rd4J049A0nowjALpzsuYWCOy90qRKec=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-Cm5ctpPLMC2H4Yt1-0Pciw-1; Tue,
 25 Feb 2025 03:37:34 -0500
X-MC-Unique: Cm5ctpPLMC2H4Yt1-0Pciw-1
X-Mimecast-MFC-AGG-ID: Cm5ctpPLMC2H4Yt1-0Pciw_1740472653
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9CBB18EB2C6;
	Tue, 25 Feb 2025 08:37:32 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFD5C1955BD4;
	Tue, 25 Feb 2025 08:37:26 +0000 (UTC)
Date: Tue, 25 Feb 2025 16:37:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 01/11] io_uring/rsrc: remove redundant check for valid
 imu
Message-ID: <Z72BQOvQKmuw1eLg@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-2-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Feb 24, 2025 at 01:31:06PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The only caller to io_buffer_unmap already checks if the node's buf is
> not null, so no need to check again.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


