Return-Path: <io-uring+bounces-11161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7627BCC9E89
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 751C83016BAD
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 00:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB65F1F9F7A;
	Thu, 18 Dec 2025 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b="GmOmmj78"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D311C4A24
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766018283; cv=none; b=SGiDCFcAgRxCqICm6RIdL/f+K+9LQ3rcrwNoPBaRa7ODVS+CjzMHXcJBhtTFECAY0zCOAarMnQwfNGFYBmU/Nn8T/GyHqOu3ysS4Xop9ICObHumh/BvwNoHRC2SUXevwKdhtAn+j9P3KGIGcEBcjlLOnx09FXC6X2wrVrYwCBa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766018283; c=relaxed/simple;
	bh=vaQ4o9aWNGv6resPJtyvNjwkTbDcdE/6PspO8fWoKE8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlFPKqY4/5nI2g5NqWL0bZ+mz9v7qiqnKWxFwBMBH3q0CNWH1ScdD00bQ631dwqe5HFv5fC305mgSg6Eg2VcvuCAhjrUeXV0XnwRaMVCGUSx+DxMip9pI5847/Z/dquXWlUSNo06Euw8oJtKTcZEHUZRzhuyOefF7VTg77A49Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev; spf=pass smtp.mailfrom=veygax.dev; dkim=pass (2048-bit key) header.d=veygax.dev header.i=@veygax.dev header.b=GmOmmj78; arc=none smtp.client-ip=79.135.106.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=veygax.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=veygax.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=veygax.dev;
	s=protonmail; t=1766018272; x=1766277472;
	bh=vaQ4o9aWNGv6resPJtyvNjwkTbDcdE/6PspO8fWoKE8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=GmOmmj783mgiHbD7SyBA8UepN6VDfEvDJo7RrWLxKhqA7nE9i73HpmLob+oY5ELMC
	 gX07YZ+Y82tQ0ni9Di1XWzf17AFq5Rf6TN596jzW1vt2A++wWWcWdKZ67cNVzZ7lTD
	 UX1osd0ZxSZCmFkEnDoU9Jyuav8PjqMveYp/pXEU2zn4KVaZrStOJr8lRfBrXdSnXj
	 Qbt0+QskNoVgMywYO/ryeUBiFwLiIXS2xW5TfFLV7MAM54i3nryNw5IRLIGbx7XEqk
	 ssL9zXTxUqRu5DkQ47fHpbL5h+jdfs46/iyimvildZ0ilbgdruZJGuQaNSX9tDjMaF
	 R8HRfOUCvYLoQ==
Date: Thu, 18 Dec 2025 00:37:47 +0000
To: Ming Lei <ming.lei@redhat.com>
From: veygax <veyga@veygax.dev>
Cc: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Caleb Sander Mateos <csander@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
Message-ID: <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev>
In-Reply-To: <aUNLs5g3Qed4tuYs@fedora>
References: <20251217210316.188157-3-veyga@veygax.dev> <aUNLs5g3Qed4tuYs@fedora>
Feedback-ID: 160365411:user:proton
X-Pm-Message-ID: 596fc13347f487cc72429606b1495fdeeda19ddf
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18/12/2025 00:32, Ming Lei wrote:
> Can you share the test case so that we can understand why page isn't merg=
ed
> to last bvec? Maybe there is chance to improve block layer(bio add page
> related code)

Sure, this is how i triggered it:

#include <kunit/test.h>
#include <linux/io_uring.h>
#include <linux/io_uring_types.h>
#include <linux/io_uring/cmd.h>
#include <linux/blk-mq.h>
#include <linux/bio.h>
#include <linux/bvec.h>
#include <linux/mm.h>
#include <linux/slab.h>

#include "io_uring.h"
#include "rsrc.h"

static void dummy_release(void *priv)
{
}

static void io_buffer_register_bvec_overflow_test(struct kunit *test)
{
=09struct io_ring_ctx *ctx;
=09struct io_uring_cmd *cmd;
=09struct io_kiocb *req;
=09struct request *rq;
=09struct bio *bio;
=09struct page *page;
=09int i, ret;

=09/*
=09 * IO_CACHED_BVECS_SEGS is 32.
=09 * We want more than 32 bvecs to trigger overflow if allocation uses 32.
=09 */
=09int num_bvecs =3D 40;
=09
=09ctx =3D kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
=09KUNIT_ASSERT_NOT_NULL(test, ctx);
=09
=09/* Initialize caches so io_alloc_imu works and knows the size */
=09if (io_rsrc_cache_init(ctx))
=09=09kunit_skip(test, "failed to init rsrc cache");

=09/* Initialize buf_table so index check passes */
=09ret =3D io_rsrc_data_alloc(&ctx->buf_table, 1);
=09KUNIT_ASSERT_EQ(test, ret, 0);

=09req =3D kunit_kzalloc(test, sizeof(*req), GFP_KERNEL);
=09KUNIT_ASSERT_NOT_NULL(test, req);
=09req->ctx =3D ctx;
=09cmd =3D io_kiocb_to_cmd(req, struct io_uring_cmd);

=09rq =3D kunit_kzalloc(test, sizeof(*rq), GFP_KERNEL);
=09KUNIT_ASSERT_NOT_NULL(test, rq);
=09
=09/* Allocate bio with enough slots */
=09bio =3D bio_kmalloc(num_bvecs, GFP_KERNEL);
=09KUNIT_ASSERT_NOT_NULL(test, bio);
=09bio_init(bio, NULL, bio_inline_vecs(bio), num_bvecs, REQ_OP_WRITE);
=09rq->bio =3D bio;
=09
=09page =3D alloc_pages(GFP_KERNEL | __GFP_COMP | __GFP_ZERO, 6);
=09KUNIT_ASSERT_NOT_NULL(test, page);
=09
=09/*
=09 * Add pages to bio manually.
=09 * We use physically contiguous pages to trick blk_rq_nr_phys_segments
=09 * into returning 1 segment.
=09 * We use multiple bvec entries to trick the loop in
io_buffer_register_bvec
=09 * into writing out of bounds.
=09 */
=09for (i =3D 0; i < num_bvecs; i++) {
=09=09struct bio_vec *bv =3D &bio->bi_io_vec[i];
=09=09bv->bv_page =3D page + i;
=09=09bv->bv_len =3D PAGE_SIZE;
=09=09bv->bv_offset =3D 0;
=09=09bio->bi_vcnt++;
=09=09bio->bi_iter.bi_size +=3D PAGE_SIZE;
=09}
=09
=09/* Trigger */
=09ret =3D io_buffer_register_bvec(cmd, rq, dummy_release, 0, 0);
=09
=09/* this should not be reachable */
=09__free_pages(page, 6);
=09kfree(bio);
=09io_rsrc_data_free(ctx, &ctx->buf_table);
=09io_rsrc_cache_free(ctx);
}

static struct kunit_case io_uring_rsrc_test_cases[] =3D {
=09KUNIT_CASE(io_buffer_register_bvec_overflow_test),
=09{}
};

static struct kunit_suite io_uring_rsrc_test_suite =3D {
=09.name =3D "io_uring_rsrc_test",
=09.test_cases =3D io_uring_rsrc_test_cases,
};

kunit_test_suite(io_uring_rsrc_test_suite);
MODULE_LICENSE("GPL");


--=20
- Evan Lambert / veygax



