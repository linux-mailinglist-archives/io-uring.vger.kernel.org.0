Return-Path: <io-uring+bounces-11345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B76CEBD5E
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 12:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDF82302016D
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 11:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF941230BCC;
	Wed, 31 Dec 2025 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O7bmHOfo"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDC233D9C
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767178962; cv=none; b=oUSVXuBXAIcEZyWx32fvi4q9GGYTrlTeWK06T/p+30v3IUKVCa4v7tDq6/C2IbEcBgH6QS0gtms/Fk7d1A0niLKyi0qAowemm0RasEPflZWCMFZjZz0JbpATkuXZIY8mwX1N9XqzjGtYp1mJe+q5glPZ7C2JL4WU+LPwMxZ2k9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767178962; c=relaxed/simple;
	bh=pZdk6JKNKt2GjJz5MMPvEGftM6pUiE/zOE1K/JTe5d8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwYIDksUksxUTGPoyQQjTXQh/ijLwaipjgL0C90eMbaWdOosWrEQYr4VbAb0EVmo9pRIU6bKlizRlqj7eHIfzeLeKY/bn7ioan9EvQH44TgL9XkhEceidJoA9YR7RjCaP5XjFM9WwgQVxvPrFRmt7ju59kQkssD8WggVT13Buc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O7bmHOfo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767178959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SnURq+FB1fjCXRQW5ZE1rMfkvLYTJ3UZen2mW5o/OM=;
	b=O7bmHOfoUHZQgzIZ89UHQ1lDsPAkVPyIQu2ySPZFylDLrqzRp0fsLOLyzGO8f8p7gdK+QT
	AVc6uIvP4HThRaKi7TJtmZkzmq7p/I0DzkBQciTrgsVj3FetvjLzdSFnxfHyDF7g7DCqAG
	68uO0dlNFbNpa0h3TOCYxEyTp/0QesQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-6dafXmEEPPK3WtATJKdUqg-1; Wed,
 31 Dec 2025 06:02:37 -0500
X-MC-Unique: 6dafXmEEPPK3WtATJKdUqg-1
X-Mimecast-MFC-AGG-ID: 6dafXmEEPPK3WtATJKdUqg_1767178956
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87FB51956088;
	Wed, 31 Dec 2025 11:02:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.125])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4696730002C9;
	Wed, 31 Dec 2025 11:02:14 +0000 (UTC)
Date: Wed, 31 Dec 2025 19:02:09 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 4/5] io_uring: bpf: add buffer support for IORING_OP_BPF
Message-ID: <aVUCsQ2fuOP_hfPF@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-5-ming.lei@redhat.com>
 <CADUfDZqUbJz_05m63-p4Q7XpsM1V6f4oGMCaKmPcE_wzNJvNqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqUbJz_05m63-p4Q7XpsM1V6f4oGMCaKmPcE_wzNJvNqA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Dec 30, 2025 at 08:42:11PM -0500, Caleb Sander Mateos wrote:
> On Tue, Nov 4, 2025 at 8:22 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add support for passing 0-2 buffers to BPF operations through
> > IORING_OP_BPF. Buffer types are encoded in sqe->bpf_op_flags
> > using dedicated 3-bit fields for each buffer.
> 
> I agree the 2 buffer limit seems a bit restrictive, and it would make
> more sense to expose kfuncs to import plain and fixed buffers. Then
> the BPF program could decide what buffers to import based on the SQE,
> BPF maps, etc. This would be analogous to how uring_cmd
> implementations import buffers.

Yes, this way is too restrictive.

I think there are at least two approaches:

- define public buffer descriptor, which can describe plain, fixed, vector,
fixed vector buffer, ...

- user can pass this buffer descriptor array from sqe->addr & sqe->len (buf descriptor
  need to be defined in UAPI)

OR

- user can pass this buffer array from arena map (buf descriptor is just
API between bpf prog and userspace)

The former could be better, because `buf descriptor` is part of UAPI, and
user still can choose to use bpf map to pass buffer. But defining 'buf
descriptor' may take a while...

The latter way could be easier to start...

> 
> >
> > Buffer 1 can be:
> > - None (no buffer)
> > - Plain user buffer (addr=sqe->addr, len=sqe->len)
> > - Fixed/registered buffer (index=sqe->buf_index, offset=sqe->addr,
> 
> Should this say "addr=" instead of "offset="? It's passed as buf_addr
> to io_bpf_import_buffer(), so it's an absolute userspace address. The
> offset into the fixed buffer depends on the starting address of the
> fixed buffer.

For user fixed buffer, offset is the buff addr.

For kernel fixed buffer, it is offset.


Thanks, 
Ming


