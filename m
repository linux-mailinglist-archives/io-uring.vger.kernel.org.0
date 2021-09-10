Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4F40717C
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhIJSvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 14:51:55 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:43840 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhIJSvz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 14:51:55 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOlbn-002y3l-6h; Fri, 10 Sep 2021 18:50:43 +0000
Date:   Fri, 10 Sep 2021 18:50:43 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] iov_iter: add helper to save iov_iter state
Message-ID: <YTupAx9W2RcLJHGk@zeniv-ca.linux.org.uk>
References: <20210910182536.685100-1-axboe@kernel.dk>
 <20210910182536.685100-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910182536.685100-2-axboe@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 10, 2021 at 12:25:34PM -0600, Jens Axboe wrote:
> +void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state,
> +		      ssize_t did_bytes)
> +{
> +	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
> +			 !iov_iter_is_kvec(i))
> +		return;
> +	i->iov_offset = state->iov_offset;
> +	i->count = state->count;
> +	/*
> +	 * For the *vec iters, nr_segs + iov is constant - if we increment
> +	 * the vec, then we also decrement the nr_segs count. Hence we don't
> +	 * need to track both of these, just one is enough and we can deduct
> +	 * the other from that. ITER_{BVEC,IOVEC,KVEC} all have their pointers
> +	 * unionized, so we don't need to handle them individually.
> +	 */
> +	i->iov -= state->nr_segs - i->nr_segs;
> +	i->nr_segs = state->nr_segs;
> +}

No.  You can have iovec and kvec handled jointly (struct iovec and struct kvec
always have the same size).  You can *not* do that to bvec - check sizeof of
struct bio_vec and struct iovec on 32bit targets.
