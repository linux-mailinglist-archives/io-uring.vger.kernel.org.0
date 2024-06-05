Return-Path: <io-uring+bounces-2105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C37148FC66C
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 10:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 787951F25C65
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 08:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87EB4963B;
	Wed,  5 Jun 2024 08:30:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AF71946B4;
	Wed,  5 Jun 2024 08:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717576227; cv=none; b=t6wWVya1JEShTjge7o2XFYsudJ9SXvx8xckc7wLWPwgGzfkSNsmo+oeqeZK4V5aikmJN1hW/jzLReWH/ssidAqa+89Bt8Hbw5PuIjOvwCx9zGC0rxSchBaykGypf8v4zziDkyAGlMCHuz3jqavMC7D5Gx9J1SPHDAWbd3INmVtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717576227; c=relaxed/simple;
	bh=QiPbZSdhRecF2+ZyIUNG4i2QcCo6rBlgAq1wpeS0raE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0V+ArZMCKqG3EMg3ogavYP2bTwLtUV/nP86wT726Bxynrfla5aMPzpsCQR3XRRNFficGzQE5VSg2G43mwIYgkufSs6yjfykwTpNTqMtztvGPlI+5KJsSmO7PdqMQqp6AKD8hVQgqdEwYpOVtq8Bno+Smq2Eg8cOQjXIrcENmg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFC20227A87; Wed,  5 Jun 2024 10:30:16 +0200 (CEST)
Date: Wed, 5 Jun 2024 10:30:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org,
	Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v7 2/9] fs: Initial atomic write support
Message-ID: <20240605083015.GA20984@lst.de>
References: <20240602140912.970947-1-john.g.garry@oracle.com> <20240602140912.970947-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602140912.970947-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Highlevel question:  in a lot of the discussions we've used the
term "untorn writes" instead, which feels better than atomic to
me as atomic is a highly overloaded term.  Should we switch the
naming to that?

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0283cf366c2a..6cb67882bcfd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -45,6 +45,7 @@
>  #include <linux/slab.h>
>  #include <linux/maple_tree.h>
>  #include <linux/rw_hint.h>
> +#include <linux/uio.h>

fs.h is included almost everywhere, so if we can avoid pulling in
even more dependencies that would be great.

It seems like it is pulled in just for this helper:

> +static inline
> +bool generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)
> +{
> +	size_t len = iov_iter_count(iter);
> +
> +	if (!iter_is_ubuf(iter))
> +		return false;
> +
> +	if (!is_power_of_2(len))
> +		return false;
> +
> +	if (!IS_ALIGNED(pos, len))
> +		return false;
> +
> +	return true;
> +}

should that just go to uio.h instead, or move out of line?

Also the return type formatting is wrong, the two normal styles are
either:

static inline bool generic_atomic_write_valid(loff_t pos,
		struct iov_iter *iter)

or:

static inline bool
generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)

(and while I'm at nitpicking, passing the pos before the iter
feels weird)

Last but not least: if READ/WRITE is passed to kiocb_set_rw_flags,
it should probably set IOCB_WRITE as well?  That might be a worthwile
prep patch on it's own.

