Return-Path: <io-uring+bounces-1131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D5887F51A
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83A791C2154F
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 01:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646A61E504;
	Tue, 19 Mar 2024 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TOR41OeS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCC62818
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710812370; cv=none; b=Z8mBG+yesWytoj1PgHivTJOgOu3w23CPkdd2xx27B4Fz2wY019DGUbi3+QKjpNWHZctw20QgLup0slcmGbZJ7dWFOP9HxwEOyR9XdHGLyntur55PeL1PZrIxLtTg1N8IeDSHfNIXzEPzUGGAhpMsFoDsgChyKKlej6LlsTtdATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710812370; c=relaxed/simple;
	bh=FX/W9kYt4wpumeWeydhxdL7Tb+dKd7OUpz7y4q6Jp9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogKAFhGxVFaG7FsAzwZyOVJA7lxhPtMQCG/za4sHbtPeF2pFLDgfFxnXO0RVAaCcNBAWp/GbsGBwk/w1qRc8VJiTgMriS+x4HSXUp1/pagYlPdwPVssZEHg3PACmv3b/zyVEFVmc9dWCOOjJkCtfFWtAhTOcNY/SRUaDiFtJlxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TOR41OeS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710812367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lS+7tdhdSTksI9cD0YlCS1mg6Uvs8VEq9kD6hkroSaE=;
	b=TOR41OeSOkPa6s+FlCcGQMTKUAt7uynsddGL66XoX4Fg8RN6S9Ruenfob0WOW9TS6Lkb8r
	njQIy+z9NEwueUrsp4WT6MVTAYN2xoAcwoOSFQxggWAtGH56YSMkX1777JXzRcsxmJ6Z4s
	RIbc32qnErHG4gRI5RK/tClvY1yh/P4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-MPEBNVfiMaS9F0ZggbBAOQ-1; Mon, 18 Mar 2024 21:39:22 -0400
X-MC-Unique: MPEBNVfiMaS9F0ZggbBAOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40E32101A552;
	Tue, 19 Mar 2024 01:39:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AA6C1121306;
	Tue, 19 Mar 2024 01:39:18 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:39:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 04/13] io_uring/cmd: introduce io_uring_cmd_complete
Message-ID: <Zfjsv8MLQCZmVAwo@fedora>
References: <cover.1710799188.git.asml.silence@gmail.com>
 <82ff8a45f2c3eb5f3a04a33f0692e5e4a1320455.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82ff8a45f2c3eb5f3a04a33f0692e5e4a1320455.1710799188.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Mar 18, 2024 at 10:00:26PM +0000, Pavel Begunkov wrote:
> io_uring_cmd_complete() does exactly what io_uring_cmd_done() does, that
> is completing the request, but doesn't ask for issue_flags argument. We
> have a couple of users hardcoding some random issue_flags values in
> drivers, which they absolutely should not do. This function will be used
> to get rid of them. Also, add comments warning users that they're only
> allowed to pass issue_flags that were given from io_uring.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks
Ming


