Return-Path: <io-uring+bounces-7150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78863A6A89A
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 15:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E704C1B66460
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 14:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E91D2253F3;
	Thu, 20 Mar 2025 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wiq4onaB"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCB32253FB;
	Thu, 20 Mar 2025 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480552; cv=none; b=bU5GbN1mnoWVkyAo4XfrzTlhmAjKhNOuz6fvzG4qLr1oGIvUUI4to7ttFVLuV8O3bk8SsVtZEwKXNp6ZVuuuVO8gCLtBGwVRzq5BHF1mwRYtfZxi5MHDv66gJ1kpZnNFjVUPAPZshqZVeI5nYbjbQMalcAZKeO1OJ8QMqVDUHEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480552; c=relaxed/simple;
	bh=IdkMRHnUO/qRTR7NCURnpDcjkokfTVGPb8CQ59hfS1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhcb665vLW+oVrQAu1bo+CSy3uFS+JIWKRntvhzxE4nlfJM0N+8EZFPLcBbSguXnbdwDqCpb5uVn04IuSaO4BfJER6QNu+dpwvh3b/8FXIhIgdMKtJfS4iJrvWSqREhltuNRb91zEeWT2ebQmqSLhH414fvpLim/Qn4U0pGISiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wiq4onaB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ApHStimX9vO8afb2pgoWPG9MHpxSpNGMq6vSzrYXkvI=; b=wiq4onaB4pn4qb8/QHx7rQEypz
	8PHj4dZ8NSoiLbKm3J9mnqcx6PMKNx3+n56JfJd3wCQ+Kiu9oeejOF1f1wLCWfPV5rP6QnHbbN8uu
	39PcbICrh7bu6fiLIXGKFEaHhRMg4rcQEYSzzgl6QPMSCUPWbPRscflI974xy7lSIHQT8y+cIT82q
	2XOrCB9xiaVqWfAtEf6Odgw28DIJTHICshE/HiNkOyEcVoKy50wCYSOSKM+DyShbucyfFPKYiOl0l
	KG5UpaZTaPeou4/paqNoK5/ZEfoS7XBCw6Dvgs0F1rj/C6+IBbp9U0oTThO6S9oO5yZzoJUf7JUR6
	pcwlJNCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tvGmx-0000000CN6x-07LL;
	Thu, 20 Mar 2025 14:22:27 +0000
Date: Thu, 20 Mar 2025 07:22:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9wko1GfrScgv4Ev@infradead.org>
References: <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org>
 <Z9vGxrPzJ6oswWrS@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9vGxrPzJ6oswWrS@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 20, 2025 at 03:41:58PM +0800, Ming Lei wrote:
> > That does not match my observations in say nvmet.  But if you have
> > numbers please share them.
> 
> Please see the result I posted:
> 
> https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/

That shows it improves numbers and not that it doens't.


