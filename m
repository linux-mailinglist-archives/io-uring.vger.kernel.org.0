Return-Path: <io-uring+bounces-4615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 581809C4B4A
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 01:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 105CD1F22730
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 00:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E552010F6;
	Tue, 12 Nov 2024 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UsNi4nRD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013031F80CC
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731372815; cv=none; b=Y4SE3VEqlUZcPAmm+owJByTHZocfzAta5yzrJTygS4gN9gAxiq5y+2ni9IAkLHRvRfnRxYbduxyJG7hr23iIB2QG0NMlxnifW+56Nusxv/RJy2TVd4ieMSG5ulmD6e9zQ5yMCqw7TiDI0S992A8/2C4Cvx+guhoFKUqTNsjCNBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731372815; c=relaxed/simple;
	bh=WREVsz149TaIOToPHodBMsxdX7uGJ61iPEBX92q1dNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1OIVvuNw18KF207EX1RqvC0vToItm0vlCzB6pg8moEMCMGg3XZJBdbULvJKkUgKLn8vXbdvOSB8oUI3i2QBRXh0EZiO0S+Sx9WITNQLpIO1rXfLLKvHdwVWEzL/Ih2M04m06g/4wU94094uGy9IeD00TEEmjVK7NxK+MBEKJ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UsNi4nRD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731372812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4XMq8gzT79OjCT69f87BgesFZNQjW/MqhG3S2Jzkuu0=;
	b=UsNi4nRDI5R0uzEA2j+QP1xXyN5Oek2oIrA7elAraBOCCydOshrOQtd/p5Inbrky/5wq1T
	PT0+0vlc5tmUeo2Z2nDuaCbt7vIbFqul4pbihiaoqm9cGGzHueO/1Lrh4vIlNx081aA5ql
	+bJiLmrFxhvmJna/1ZSKaoWsTkZX+Xw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-jjmjPUILNP6E7fzNju_-dQ-1; Mon,
 11 Nov 2024 19:53:29 -0500
X-MC-Unique: jjmjPUILNP6E7fzNju_-dQ-1
X-Mimecast-MFC-AGG-ID: jjmjPUILNP6E7fzNju_-dQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D0971955F41;
	Tue, 12 Nov 2024 00:53:28 +0000 (UTC)
Received: from fedora (unknown [10.72.116.64])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB63C1956086;
	Tue, 12 Nov 2024 00:53:23 +0000 (UTC)
Date: Tue, 12 Nov 2024 08:53:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>
Subject: Re: (subset) [PATCH V10 0/12] io_uring: support group buffer & ublk
 zc
Message-ID: <ZzKm_lN_1U_u6St7@fedora>
References: <20241107110149.890530-1-ming.lei@redhat.com>
 <173101830487.993487.13218873496602462534.b4-ty@kernel.dk>
 <b0004544-91f7-47b8-a8d6-da7c6e925883@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0004544-91f7-47b8-a8d6-da7c6e925883@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Nov 07, 2024 at 03:25:59PM -0700, Jens Axboe wrote:
> On 11/7/24 3:25 PM, Jens Axboe wrote:
> > 
> > On Thu, 07 Nov 2024 19:01:33 +0800, Ming Lei wrote:
> >> Patch 1~3 cleans rsrc code.
> >>
> >> Patch 4~9 prepares for supporting kernel buffer.
> >>
> >> The 10th patch supports group buffer, so far only kernel buffer is
> >> supported, but it is pretty easy to extend for userspace group buffer.
> >>
> >> [...]
> > 
> > Applied, thanks!
> > 
> > [01/12] io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
> >         commit: 0d98c509086837a8cf5a32f82f2a58f39a539192
> > [02/12] io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
> >         commit: 4f219fcce5e4366cc121fc98270beb1fbbb3df2b
> > [03/12] io_uring/rsrc: add & apply io_req_assign_buf_node()
> >         commit: 039c878db7add23c1c9ea18424c442cce76670f9
> 
> Applied the first three as they stand alone quite nicely. I did ponder
> on patch 1 to skip the make eg io_alloc_file_tables() not take both
> the ctx and &ctx->file_table, but we may as well keep it symmetric.
> 
> I'll take a look at the rest of the series tomorrow.

Hi Jens,

Any comment on the rest of the series?


thanks,
Ming


