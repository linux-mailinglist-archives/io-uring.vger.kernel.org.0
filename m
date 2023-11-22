Return-Path: <io-uring+bounces-124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CB67F3ACE
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 01:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8F5A1F22C93
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 00:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F088F17CD;
	Wed, 22 Nov 2023 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8DwdIbL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2785D5C
	for <io-uring@vger.kernel.org>; Tue, 21 Nov 2023 16:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700613843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8EYyCryX7PBKswSadGF3aphue0eBdpRNIdFAo5BTQRU=;
	b=J8DwdIbLemRJVRG+G2vC9TooBPOY4IbK+Z0PTyKRPrG+wfQPOuiju5lQ4EPKfgGYRFEuE6
	ENy+Yd+OQFAVFeOmEfMtl5EElA8ZWgK9Hs65uTlBLCtFfp/bFcGUgGxXzZQ3fG9dlBxNyB
	f1eTOiYntCu2o36TwfTDCjA1A5M2n74=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-Y5BE8AH3Ofu_IuaI0chxBA-1; Tue,
 21 Nov 2023 19:43:59 -0500
X-MC-Unique: Y5BE8AH3Ofu_IuaI0chxBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3B4B1C05191;
	Wed, 22 Nov 2023 00:43:58 +0000 (UTC)
Received: from fedora (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EBA31C060AE;
	Wed, 22 Nov 2023 00:43:52 +0000 (UTC)
Date: Wed, 22 Nov 2023 08:43:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, joshi.k@samsung.com,
	martin.petersen@oracle.com, ming.lei@redhat.com
Subject: Re: [PATCHv3 1/5] bvec: introduce multi-page bvec iterating
Message-ID: <ZV1OxMPsJYq7Tyaw@fedora>
References: <20231120224058.2750705-1-kbusch@meta.com>
 <20231120224058.2750705-2-kbusch@meta.com>
 <ZVxsLYj9oH+j3RQ8@fedora>
 <ZVzRmQ66yRDJWMiZ@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVzRmQ66yRDJWMiZ@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, Nov 21, 2023 at 08:49:45AM -0700, Keith Busch wrote:
> On Tue, Nov 21, 2023 at 04:37:01PM +0800, Ming Lei wrote:
> > On Mon, Nov 20, 2023 at 02:40:54PM -0800, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > Some bio_vec iterators can handle physically contiguous memory and have
> > > no need to split bvec consideration on page boundaries.
> > 
> > Then I am wondering why this helper is needed, and you can use each bvec
> > directly, which is supposed to be physically contiguous.
> 
> It's just a helper function to iterate a generic bvec.

I just look into patch 3 about the use, seems what you need is for_each_bvec_all(),
which is safe & efficient to use when freeing the host data(bio or bip), but can't
be used in split bio/bip, in which the generic iterator is needed.

And you can open-code it in bio_integrity_unmap_user():

for (i = 0; i < bip->bip_vcnt; i++) {
	struct bio_vec *v = &bip->bip_vec[i];

	...
}

Thanks,
Ming


