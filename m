Return-Path: <io-uring+bounces-6771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A53A45300
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 03:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D89173AAC
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 02:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D60218EB8;
	Wed, 26 Feb 2025 02:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrAioT0j"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC52218E8B;
	Wed, 26 Feb 2025 02:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536433; cv=none; b=DjIEpriSGsS1dcqOOU96h0yYBRLxIqHlPG5lcnzC58J1FWGa8yfqsWx1+KE5aKF4OrPI57OsM571U5ka2X6OyUiw0s00PO+JracJre/eXX+vqDfojUNgQqzBzYu8UfChP+DZ/HvUy1v8atsQW6+w5Xb5TO0id8bS0maOOJ+FT40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536433; c=relaxed/simple;
	bh=AUldDxyHFJa6nm4M3aR7zTN+tvmqS7lH5BoNHVLxpNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nD6jnheG4F9ZXLP09PJ/M8fi5jG/pPPVqcejUkSApqNkOt5gcCf8NzMSmRrJ2gmoqU/xWrXykFBhfFxPbEppxyksXKhUsYjacwtGc/zB8saRyz7z4ir6PCC2HVfLlufwSHdbXHg11gGOLrEC8qHz0erTORjTFRCn2EnljvGVo0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrAioT0j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021DC4CEDD;
	Wed, 26 Feb 2025 02:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740536432;
	bh=AUldDxyHFJa6nm4M3aR7zTN+tvmqS7lH5BoNHVLxpNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RrAioT0jWNAqCV0HrJvwNzIU1w3C/TaGLtGBDk7Be5bI292LUZdJ0rbbr71W7oJm9
	 +Zgi7wNogOpCQZhvwE3oJLy2ZciFQ3dvmGR2uUA/I2/DEGNXoxabCzCE5gNUnLRypQ
	 S78180zaf1VzFqMQzHjMeWK8w43Lcs4LW0uehv2bIivAU7kKIBzEJ4yMGjBtCyx7J4
	 FQN/4wW8BGXpDNv5Dbcli7gQZjgPEdcHnpWHacOt/t4JkaYix7T5df+qrgX8249kxp
	 EogfeUFtwHQxDcG/yKDWflx3F8FPLNnU4eDcOKC5k74e/YVBodsAhI2jT76L2P96Lo
	 dri1eEG5ASyHw==
Date: Tue, 25 Feb 2025 18:20:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
Message-ID: <20250226022032.GH6265@frogsfrogsfrogs>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <20250226015334.GF6265@frogsfrogsfrogs>
 <543f34a8-9dad-4f63-b847-38289395cbe2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543f34a8-9dad-4f63-b847-38289395cbe2@gmail.com>

On Wed, Feb 26, 2025 at 02:06:51AM +0000, Pavel Begunkov wrote:
> On 2/26/25 01:53, Darrick J. Wong wrote:
> > On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
> > > There are reports of high io_uring submission latency for ext4 and xfs,
> > > which is due to iomap not propagating nowait flag to the block layer
> > > resulting in waiting for IO during tag allocation.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> > > Reported-by: wu lei <uwydoc@gmail.com>
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >   fs/iomap/direct-io.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > index b521eb15759e..25c5e87dbd94 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
> > >   		WRITE_ONCE(iocb->private, bio);
> > >   	}
> > > +	if (iocb->ki_flags & IOCB_NOWAIT)
> > > +		bio->bi_opf |= REQ_NOWAIT;
> > 
> > Shouldn't this go in iomap_dio_bio_opflags?
> 
> It can, if that's the preference, but iomap_dio_zero() would need
> to have a separate check. It also affects 5.4, and I'm not sure
> which version would be easier to back port.

Yes, please don't go scattering the bi_opf setting code all around the
file.  Also, do you need to modify iomap_dio_zero?

--D

> -- 
> Pavel Begunkov
> 

