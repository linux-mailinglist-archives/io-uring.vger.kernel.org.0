Return-Path: <io-uring+bounces-12775-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPi/IYzMvmlccwMAu9opvQ
	(envelope-from <io-uring+bounces-12775-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 17:51:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD9E2E6667
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 17:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 625D53011F25
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 16:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EEB31E82F;
	Sat, 21 Mar 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVfORZGT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1267331F98B
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774111854; cv=none; b=sWz6iwJttftCs1ogWI8ErcImbFM6eYXXtzkk1TkZgFr6upNtAyejFifZrAWj/A2QH2fV2s683ppaEC4Qz2CfBtu58iUWGHo3KpvB6wAxZGJozgRO39Fcgjom2nf5PYyALvW1Xk8CK/4J/2oKwIuUyagugoZLHCrRo//pFcAZu54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774111854; c=relaxed/simple;
	bh=bW1SVNN9ra8I1UbLqVf9egan5qMt4o2z8PFl7Xij1M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuBxnpWDOjHy9LZt+JYKmVYLDqXSXZkdNlfotcPLAMAbUp6oeTqGUkOm6DSQtMgg8NcEbiuNtyEFR+rVB0ewv20TloAdzy1GoqrAHt4C9aOsur8+vD4nPS2PzGIb9onwnXyhZxe5/2jm3dxLJ+1QxEMQXDOHN4RuZv/wqVW1lYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVfORZGT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774111849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6wm5UyedUGW6vze23LcftP+9pVX1ApSc+3EXqxSGoB4=;
	b=UVfORZGT9fCtPksQYtf6Mh99VK+i7k32yPbr/6c8gY5TZyPuMGe7iCliVNPL4Qv3JpBjBD
	EtX3rUtGTYHZOPeaBWbhBBru2ZRC++5/N0qy3EyXREXE9UqEYfxiW68fwo63qQHVPr/xn4
	M+xNlLvrWpaUDykwdDLSvBIy2IFUnE8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-LFEkwMMMM8S6Gc9sCXDX-A-1; Sat,
 21 Mar 2026 12:50:44 -0400
X-MC-Unique: LFEkwMMMM8S6Gc9sCXDX-A-1
X-Mimecast-MFC-AGG-ID: LFEkwMMMM8S6Gc9sCXDX-A_1774111843
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67543195608C;
	Sat, 21 Mar 2026 16:50:42 +0000 (UTC)
Received: from fedora (unknown [10.72.116.20])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9503F1955F21;
	Sat, 21 Mar 2026 16:50:38 +0000 (UTC)
Date: Sun, 22 Mar 2026 00:50:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH V2 08/13] io_uring: bpf: add uring_bpf_memcpy() kfunc
Message-ID: <ab7MWbG6SGbLyWGX@fedora>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
 <20260106101126.4064990-9-ming.lei@redhat.com>
 <CADUfDZqaM2cNn=QJzY1G912F5mX+Uhz5wTV4r3wvhAg-qhoBFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqaM2cNn=QJzY1G912F5mX+Uhz5wTV4r3wvhAg-qhoBFQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12775-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,samba.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0CD9E2E6667
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 13, 2026 at 10:18:53PM -0700, Caleb Sander Mateos wrote:
> On Tue, Jan 6, 2026 at 2:12 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > Add uring_bpf_memcpy() kfunc that copies data between io_uring BPF
> > buffers. This kfunc supports all 5 buffer types defined in
> > io_bpf_buf_desc:
> >
> > - IO_BPF_BUF_USER: plain userspace buffer
> > - IO_BPF_BUF_FIXED: fixed buffer (absolute address within buffer)
> > - IO_BPF_BUF_VEC: vectored userspace buffer (iovec array)
> > - IO_BPF_BUF_KFIXED: kernel fixed buffer (offset-based addressing)
> > - IO_BPF_BUF_KVEC: kernel vectored buffer
> >
> > Add helper functions for buffer import:
> > - io_bpf_import_fixed_buf(): handles FIXED/KFIXED types with proper
> >   node reference counting
> > - io_bpf_import_kvec_buf(): handles KVEC using __io_prep_reg_iovec()
> >   and __io_import_reg_vec()
> > - io_bpf_import_buffer(): unified dispatcher for all buffer types
> > - io_bpf_copy_iters(): page-based copy between iov_iters
> >
> > The kfunc properly manages buffer node references and submit lock
> > for registered buffer access.
> 
> Ming,
> 
> Thank you for working on this patch series and sorry I didn't have a
> chance to take a look at this revision earlier.
> 
> My main reservation with this approach is that a dedicated kfunc is
> needed for each data manipulation operation an io_uring BPF program
> conceivably wants to perform. Even for the initial RAID parity
> calculation use case, I imagine we'd need a different kfunc for each
> RAID stripe data width and parity width combination. Other data
> operations added in the future would also need new kfuncs to support
> them.
> struct io_bpf_buf_desc is certainly more flexible than the approach in
> v1, but I worry that fully consuming the iterator in a single kfunc
> call prevents composing data operations during a single pass over the
> buffer. For example, if the input data needs to be encrypted and then
> parity needs to be generated over the encrypted data, calling an
> encryption kfunc and a parity generation kfunc in sequence would
> perform two passes over the data. To do it in a single pass, you'd
> need something like an "encrypt_and_gen_parity()" kfunc, which seems
> very niche.

parity buffer should be owned by ublk server.

So here you want to calculate parity over encrypted registered buffer
in one pass.

Technically it should be doable, however it depends if the in-kernel
encryption lib supports it, or it may be too slow.

> The hope was that io_uring BPF programs would provide a generic
> approach to registered buffer data manipulation, but the dependency on
> a large set of kfuncs seems a significant hurdle. I suspect a fully
> generic approach would require essentially reproducing the struct
> iov_iter abstraction in kfunc form.

bpf iterator might be the solution, but looks one limit is that it is hard
or not possible to produce one writeable buffer from bpf_iter_next() kfunc,
so one encrypt kfunc is still needed. If the encrypt lib supports to generate
parity data in one pass, the kfunc may support it, however, I feel it might
be hard.

Also I guess one extra pass for calculating parity shouldn't be too bad,
and here one extra decrypt kfunc is enough, and calculating & storing parity
can be done directly because the parity buffer is not registered.


Thanks,
Ming


