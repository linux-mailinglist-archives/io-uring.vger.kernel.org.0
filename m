Return-Path: <io-uring+bounces-5797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B745A08EA2
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 11:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A8543A9D74
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 10:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BED207656;
	Fri, 10 Jan 2025 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEDp7c71"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040041F8F08;
	Fri, 10 Jan 2025 10:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506593; cv=none; b=OEdV/+owLeSNmLVsJ3QHurnMBUXsGQTnaSDb2DdGrOg1NebaHA5fFE7DB9OHs429HqZhQf9rbpecKyBQBnYwQaLTfx+2AGX0fhpMJyq6+wR6pHwHyX/Y2F+JrRJYWOxIa+641ek0clmSN+wE4fDm/DtPImtz2NvvXkxS7nExrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506593; c=relaxed/simple;
	bh=nWe4tgkC5qGXTMJClC08HcpEepa8GsmA1+p1gbVHz6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPXJUWK2oTL6lsBCmIKxYqVjVCOkPmHd8aHCthnOAB3y+KiJc1pcSeArlcTym6ewicjNNv+HZpJEKAJqwa/EIEk9otCGldzs3iiIxbW2P79RqZLS3HdKL8iuAQKxj3/KLwHbmOWA/uUnsIesjlTNmyjzuTcidhncFXuhCp0yIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEDp7c71; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE21C4CED6;
	Fri, 10 Jan 2025 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506592;
	bh=nWe4tgkC5qGXTMJClC08HcpEepa8GsmA1+p1gbVHz6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GEDp7c71v5tspOridq4B8NRV6EyvBjsk32pq1lQRD4f5pzz5J+IMscvG7ATPX9vff
	 iwJQSCpxNp0wyvyGpE3OHgTwjFyNG3F06xkrhPyrdwFjJXm5XWr0LDxks9qO0z/qPM
	 59lvf1QlqS2r5pvXlA1z8ceCgl687VEDMmM2ugMvBB76ncbo5UR9GgxjO2Hysdp/FE
	 XLChy3bD//daQpRi2GOt3dgK8KNkPExvOKJsF+wrt044HJ8BmlRQ8dfUA35aYCKjlH
	 M2vLZbgCO8LTo43pzrY96KBYXSQtw5VWJOoQWu9pI7bb4h2RGy3XEHqadhRbHYdRkW
	 vtHhOlNteJybA==
Date: Fri, 10 Jan 2025 11:56:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, 
	Manfred Spraul <manfred@colorfullife.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] poll_wait: add mb() to fix theoretical race between
 waitqueue_active() and .poll()
Message-ID: <20250110-ratsam-bahnfahren-3bac59730ea6@brauner>
References: <20250107162649.GA18886@redhat.com>
 <CAHk-=wgvpziaLOTNV9cbitHXf7Lz0ZAW+gstacZqJqRqR8h66A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgvpziaLOTNV9cbitHXf7Lz0ZAW+gstacZqJqRqR8h66A@mail.gmail.com>

On Tue, Jan 07, 2025 at 09:38:36AM -0800, Linus Torvalds wrote:
> On Tue, 7 Jan 2025 at 08:27, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I misread fs/eventpoll.c, it has the same problem. And more __pollwait()-like
> > functions, for example p9_pollwait(). So 1/5 adds mb() into poll_wait(), not
> > into __pollwait().
> 
> Ack on all five patches, looks sane to me.
> 
> Christian, I'm assuming this goes through your tree? If not, holler,
> and I can take it directly.

Yes, on it. Sorry, this took a bit. I'm trying to work downwards through
all the mail.

