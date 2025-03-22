Return-Path: <io-uring+bounces-7194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA857A6C8DA
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 10:42:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A394636B9
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 09:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5A91EFF85;
	Sat, 22 Mar 2025 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bq0WEWY1"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A18A1EBFE2
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742636550; cv=none; b=MvC/G/g9vU61/iIlKCimB81JdwPQ+AD8kURx29HSYHShbHNT+2vh1RTkx5f8M8XpRRq9oviOicwF4aW52piD34syfus8x7ZjOJxvWSh1ITAhY/zZS7WUDwvgTHmidkll4Ji1xWZ0ir+EjzUb+k1M1+OsIS03u/w3rbhD1/yK6s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742636550; c=relaxed/simple;
	bh=nvQ9tPLrRSXIM+10AemHsXcSf7ifGhZzqtdFrruZXlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmzs7fRUEQ6VL9GORzni5RAmdWmA1DNJ+9Z1stnaNQRW63nmaaN79XQGaT13ktsSPyPNOd0xN4BV5wrN6JyHbNQIu+LE/setw5HFiN6KOi94dcuWxgdrk91/up2OgTX0YIOmoz+fErdzF+7h8BMg913+4w6OCY0wnbkrhebsCbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bq0WEWY1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742636547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMaX8bUezeBQP1VAg4uk80uWFS5hWFj4E09SSplPiv0=;
	b=Bq0WEWY1YoAFBjYyEXcK6zxtlIRPwEtPBNbtZ+JtmNP0bsr5zvqZbGBrdI7guiOnPt2qsu
	+Z8J/PXX+WOXzpdUyF7Jcv9OP3UnzupLynC4joxC9B1J3Bh5YEA3e+/UxxnhfRN9sUpEiZ
	h6u+uUuPgeFDhIZyni6JpXhNJza5r5E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-ot8t2G2zMReIOa3EmMnEMw-1; Sat,
 22 Mar 2025 05:42:22 -0400
X-MC-Unique: ot8t2G2zMReIOa3EmMnEMw-1
X-Mimecast-MFC-AGG-ID: ot8t2G2zMReIOa3EmMnEMw_1742636541
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC7501933B48;
	Sat, 22 Mar 2025 09:42:21 +0000 (UTC)
Received: from fedora (unknown [10.72.120.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD581180A803;
	Sat, 22 Mar 2025 09:42:18 +0000 (UTC)
Date: Sat, 22 Mar 2025 17:42:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 0/2] cmd infra for caching iovec/bvec
Message-ID: <Z96F9J5gixbb52E-@fedora>
References: <cover.1742579999.git.asml.silence@gmail.com>
 <0c6e6b27-05db-4709-be80-52d0f877d2ce@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c6e6b27-05db-4709-be80-52d0f877d2ce@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Fri, Mar 21, 2025 at 01:13:23PM -0600, Jens Axboe wrote:
> On 3/21/25 12:04 PM, Pavel Begunkov wrote:
> > Add infrastructure that is going to be used by commands for importing
> > vectored registered buffers. It can also be reused later for iovec
> > caching.
> > 
> > v2: clear the vec on first ->async_data allocation
> >     fix a memory leak
> > 
> > Pavel Begunkov (2):
> >   io_uring/cmd: add iovec cache for commands
> >   io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
> > 
> >  include/linux/io_uring/cmd.h | 13 ++++++++++++
> >  io_uring/io_uring.c          |  5 +++--
> >  io_uring/opdef.c             |  1 +
> >  io_uring/uring_cmd.c         | 39 +++++++++++++++++++++++++++++++++++-
> >  io_uring/uring_cmd.h         | 11 ++++++++++
> >  5 files changed, 66 insertions(+), 3 deletions(-)
> 
> This version works for me - adding in Ming, so he can test and
> verify as well.

With the two patches, all ublk selftest can run to pass, and kernel doesn't
panic any more.

BTW, I meant vectored fix kernel buffer support for FS read/write, which
looks not supported yet.

And it can be useful in the following case:

https://lore.kernel.org/linux-block/20250322093218.431419-9-ming.lei@redhat.com/T/#u


Thanks,
Ming


