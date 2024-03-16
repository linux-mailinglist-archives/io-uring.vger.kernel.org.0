Return-Path: <io-uring+bounces-1004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F176987D7F3
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 03:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29FD71C21188
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 02:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F054217E9;
	Sat, 16 Mar 2024 02:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="feNZUlco"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E805A1849
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 02:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710554650; cv=none; b=hA0N4YFoTrOtVfdK0J+/iPccJ687ycVbNFwkZqq9NtfULNgDwzstxaThjxwpnHoVUzkhDO6anhZlypnb3N663DCO5vpbOUVuk14go2UzgTuJ5g0ktMC6avIcbYTxXrpZR2o5rmspHmgB1aZpz26BldkAeQLnES/9tSVuugtdik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710554650; c=relaxed/simple;
	bh=wclcn6aCrptudrO4+gQSFMYr+ZIgYiH2sU7xpE1DSRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5eZhBoFK/voo/QMw9Uhc8thucgTE0ezaFfLJ+9ASkJt43uN+52gz16DpXLbo6SX4I+kX9FzAt7CqZlNfcxji0hnL4y8FSiaU/Z9FRGT29D6eTSZ6Fr5GiiAGsl+UOxGkxn5lCudCwMy86Hv+IRM35q+n4ZiBIDlV3Y3ASIrlz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=feNZUlco; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710554647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u2or2hyp0Hal6BLdCahDbwD45I7L+n8jhCzFPZ29+2U=;
	b=feNZUlcogecwifwsZJmOkvuahKNYeX2FKa168fHYB43CAmvX0HeviOjxtOe2tC1z9YiMwK
	FnjyfayNDtsUpnWTuE+FOsRCX7LustRd7xx3oglOMP5yu0kws6qYfnncxzHdhqRiJVQsYw
	9EBfRzfFNNQKpEKbAc5N3XMRtdUz8JE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-1XXAYskpMY2sgURoimacDg-1; Fri,
 15 Mar 2024 22:04:03 -0400
X-MC-Unique: 1XXAYskpMY2sgURoimacDg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 615933802AE0;
	Sat, 16 Mar 2024 02:04:03 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56CE3492BC6;
	Sat, 16 Mar 2024 02:03:59 +0000 (UTC)
Date: Sat, 16 Mar 2024 10:03:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfT+CDCl+07rlRIp@fedora>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> 
> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> > Patch 1 is a fix.
> > 
> > Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> > misundertsandings of the flags and of the tw state. It'd be great to have
> > even without even w/o the rest.
> > 
> > 8-11 mandate ctx locking for task_work and finally removes the CQE
> > caches, instead we post directly into the CQ. Note that the cache is
> > used by multishot auxiliary completions.
> > 
> > [...]
> 
> Applied, thanks!

Hi Jens and Pavel,

Looks this patch causes hang when running './check ublk/002' in blktests.

Steps:

1) cargo install rublk

2) cd blktests

3) ./check ublk/002



Thanks,
Ming


