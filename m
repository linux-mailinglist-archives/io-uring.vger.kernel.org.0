Return-Path: <io-uring+bounces-7109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C3DA66D13
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 09:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69752188B3A2
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531131DFE04;
	Tue, 18 Mar 2025 07:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="akwP3jJv"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19F9366;
	Tue, 18 Mar 2025 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742284640; cv=none; b=ZXsQFwg+ribz868YyhlU0nW3mg71dgwjwF6RQgErayccct6Hn0d85rjch+YeIBTkftmXxB+nZCYNuONZR5yuA5LRtWxmetL8Iqcbgd8BxVAamIyy+gwp5PzhQ5lWDujGCtbmDAW86H9RzaLUhnEL93VrjX74C/Ilgf9flIU+3iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742284640; c=relaxed/simple;
	bh=Iz4pqOI235ydHMfcg0FHxBlUlROBEcfWRt7n7cVLelM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvscSlFMVm8omzDqA1+LivnzHbcdEOFwoZIqmknd790EIfWfzrnPBup8qJhwhVJLXHjdbDi71l2ZfSqfPZy4764bGeP1wWFaX43oTgiewmtl/K1JOOa8TQ3ebNbQr5fvC8cmAfFW7DhYhDg2ITThNip7PY7WFQgYa+X5KimX69s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=akwP3jJv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tLs/bxImix0heMMO25L/sr+bZhE4jHdYqj5az0Wt+Ug=; b=akwP3jJvOF2A9MTOiAacMLR609
	oTvNtg30xrh+ZQiPr4PvY2Olryg/pl8i8C4KSgl9x0VCkLnd1mZpXKYC4WmhWuDRbRhhaJa66s8ol
	z1I34KSc29fMB52cwifBVW4OVbGochoGb7G1BkRrHIqs0enFBAONF/l8NddSZIb8tcKAMeTf2VjVE
	DbuXUVGjWkT7eDmOcxz26WO3CzFAaIwX5z1cL7leWyJfEygHnkCLd60ILMwpHd3EZndbTnXBGMxS/
	yoXojB6c3Go9T1ptR9VtUFcRzYmUOD1ty4FaL2Kxdk632IBO+3wPv/TzuSsNZC0hAHvet1do2MdoY
	nergSn3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tuRp7-000000053eT-0UoO;
	Tue, 18 Mar 2025 07:57:17 +0000
Date: Tue, 18 Mar 2025 00:57:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z9knXQixQhs90j5F@infradead.org>
References: <Z8eURG4AMbhornMf@dread.disaster.area>
 <81b037c8-8fea-2d4c-0baf-d9aa18835063@redhat.com>
 <Z8zbYOkwSaOJKD1z@fedora>
 <a8e5c76a-231f-07d1-a394-847de930f638@redhat.com>
 <Z8-ReyFRoTN4G7UU@dread.disaster.area>
 <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9j2RJBark15LQQ1@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> Yes, NOWAIT may then add an incremental performance improvement on
> top for optimal layout cases, but I'm still not yet convinced that
> it is a generally applicable loop device optimisation that everyone
> wants to always enable due to the potential for 100% NOWAIT
> submission failure on any given loop device.....

Yes, I think this is a really good first step:

1) switch loop to use a per-command work_item unconditionally, which also
   has the nice effect that it cleans up the horrible mess of the
   per-blkcg workers.  (note that this is what the nvmet file backend has
   always done with good result)
2) look into NOWAIT submission, especially for reads this should be
   a clear winner and probaby done unconditionally.  For writes it
   might be a bit of a tradeoff if we expect the writes to allocate
   a lot, so we might want some kind of tunable for it.


