Return-Path: <io-uring+bounces-7212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80129A6CD87
	for <lists+io-uring@lfdr.de>; Sun, 23 Mar 2025 01:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EE933B872C
	for <lists+io-uring@lfdr.de>; Sun, 23 Mar 2025 00:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BE6EAF1;
	Sun, 23 Mar 2025 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2AcelDe"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CE5F9E6
	for <io-uring@vger.kernel.org>; Sun, 23 Mar 2025 00:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742688548; cv=none; b=O6PgsiplwR140HhllKBUjOr4Z3KHkMXxo15yNCH7TqH4xagn9uxOpikAef3Ibdnc3eQbCzHpfWBRIihtd5cQ8eG25NRntF95mjxG2Nz1glW0eJfc9as0CoBe7OBMzNXy3vQHJsbwcbgAVQtA+tGNEBE4lq2QlrmnTv55eIhjtoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742688548; c=relaxed/simple;
	bh=iA3LANBfe/25+OjPnqHHaTwxSZgKqeeO0WKfjF0j4ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfdBVFA4BFMm+C4wpqW4V9scY2+ziWUFJAk3JCanK+KQ2W9K3f9DDhRs/dBewOa1czpZQnmyWyyphyEuUev6ycEDwHFTtlr8erMgTtU+iWNYQFBjf35Co/Z/F9MD2rAE+xIhJr/r9BLIXTyocUPCA5Y8tUcRMMhwp3NCGDbfdK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T2AcelDe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742688545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8nPVE6JJGVs+O2T2rjh0oxg68BUQJVzPnfhuxGa/10=;
	b=T2AcelDelTh4fSvlPLDP77sXmXG5YUNN5lPqwwnGFdmduPwcjvbeb7PXor2NMu6D/VERz3
	iTizECF2HJfIIGs7aQOmeqIEsheoLZS/Fv8LEPZsqtjcmAxjnJWkfHfE64PsHUt8Z6/2Ar
	2u1+bx/gZGpVybTS7nwKmxJSwYhQWo0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339--LSodAFiNBql3q-IA1meRA-1; Sat,
 22 Mar 2025 20:08:41 -0400
X-MC-Unique: -LSodAFiNBql3q-IA1meRA-1
X-Mimecast-MFC-AGG-ID: -LSodAFiNBql3q-IA1meRA_1742688520
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 687B9180882E;
	Sun, 23 Mar 2025 00:08:40 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E31EA1800268;
	Sun, 23 Mar 2025 00:08:35 +0000 (UTC)
Date: Sun, 23 Mar 2025 08:08:29 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
Message-ID: <Z99Q_RQob_GBe8WO@fedora>
References: <20250322075625.414708-1-ming.lei@redhat.com>
 <CADUfDZp2TwVuLW+s+WEPOy=gHE8R7-JWEtxZhbmVeRy6CrGh6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZp2TwVuLW+s+WEPOy=gHE8R7-JWEtxZhbmVeRy6CrGh6g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Sat, Mar 22, 2025 at 11:10:23AM -0700, Caleb Sander Mateos wrote:
> On Sat, Mar 22, 2025 at 12:56 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > So far fixed kernel buffer is only used for FS read/write, in which
> > the remained bytes need to be zeroed in case of short read, otherwise
> > kernel data may be leaked to userspace.
> 
> I'm not sure I have all the background to understand whether kernel
> data can be leaked through ublk requests, but I share Pavel and
> Keith's questions about whether this scenario is even possible. If it
> is possible, I don't think this patch would cover all the affected
> cases:
> - Registered ublk buffers can be used with any io_uring operation, not
> just read/write. Wouldn't the same issue apply when using the ublk
> buffer with, say, a socket recv or an NVMe passthru operation?

IORING_RECVSEND_FIXED_BUF isn't handled for recv yet, so looks socket recv
isn't enabled...

> - Wouldn't the same issue apply if the ublk server completes a ublk
> read request without performing any I/O (zero-copy or not) to read
> data into its buffer?

Yes, it needs ublk zc server implementation to be trusted, and ublk zc
can't work in unprivileted mode.

For non-zc, no such risk because request buffer is filled with user data.

Thanks,
Ming


