Return-Path: <io-uring+bounces-120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E41EF7F279C
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 09:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D8921C218A4
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 08:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCEE1DFED;
	Tue, 21 Nov 2023 08:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1eNeAXh"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C2910E
	for <io-uring@vger.kernel.org>; Tue, 21 Nov 2023 00:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700555837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSnMEYxpnW5oiEx9Wxa+pu1+pouT4rSIR9cZCOvF7D0=;
	b=J1eNeAXhnNGCyVK38bdofRwNen0s+liacKCgkTJb8hxNSmUsS8HTEe4SrxwiCzxMuKO/Yl
	kCUX9F4G/5HqfJLv7xZP4+NXQTDO61NYBWSjHJG7ggC6CDVdYR0EsgiO/t6D7Wc8aowZl/
	IwyqThvTQWd476lUUUmveaAUmQs66jc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-bNWAcLLAM92l4peDpphzPA-1; Tue,
 21 Nov 2023 03:37:13 -0500
X-MC-Unique: bNWAcLLAM92l4peDpphzPA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D00FE3816B46;
	Tue, 21 Nov 2023 08:37:11 +0000 (UTC)
Received: from fedora (unknown [10.72.120.14])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 524BD492BFA;
	Tue, 21 Nov 2023 08:37:05 +0000 (UTC)
Date: Tue, 21 Nov 2023 16:37:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	Keith Busch <kbusch@kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCHv3 1/5] bvec: introduce multi-page bvec iterating
Message-ID: <ZVxsLYj9oH+j3RQ8@fedora>
References: <20231120224058.2750705-1-kbusch@meta.com>
 <20231120224058.2750705-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120224058.2750705-2-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Mon, Nov 20, 2023 at 02:40:54PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Some bio_vec iterators can handle physically contiguous memory and have
> no need to split bvec consideration on page boundaries.

Then I am wondering why this helper is needed, and you can use each bvec
directly, which is supposed to be physically contiguous.

> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/bvec.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 555aae5448ae4..9364c258513e0 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -184,6 +184,12 @@ static inline void bvec_iter_advance_single(const struct bio_vec *bv,
>  		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
>  	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
>  
> +#define for_each_mp_bvec(bvl, bio_vec, iter, start)			\
> +	for (iter = (start);						\
> +	     (iter).bi_size &&						\
> +		((bvl = mp_bvec_iter_bvec((bio_vec), (iter))), 1);	\
> +	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
> +

We already have bio_for_each_bvec() to iterate over (multipage)bvecs
from bio.


Thanks,
Ming


