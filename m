Return-Path: <io-uring+bounces-3186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C35977A41
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 09:48:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DCF71C2538E
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 07:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4A61BB6A0;
	Fri, 13 Sep 2024 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="24jJLMzh"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFB24C96;
	Fri, 13 Sep 2024 07:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726213524; cv=none; b=H3l/KAnpVCdJDpICYo9QGo7dB/FfjePWnDtgm4t/pZG1kRxveGYdTAI0gjX0t8lQ70gc6QbdkKuJ9L6VURvjxCg3q83kQPF6WlLR466ghP7d1F4hHluFpSP9hSaLcaq3WRrKHA8c+x7n9qziDxTZpSzO8XlNt28SR7l82pnOl5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726213524; c=relaxed/simple;
	bh=oAL4XSiPCdCxsFRJpP40OPeCmZ3h+2yPthNLW4wasU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gz8P3VsEw43NbKOytQQ1cqTbAJIlZa2hpYOpqZtckhi2IQW12fueBs5wTG3f1LwifG6WSD11Xp5X4RGwHhXiI27C0PEp6YI7Kk/fagk9ysiwbGTFoUU5YRfYshViTsVJPAWzQLvDdWw5/2SlUSUadmfqYGCH0pi71U29HtaRxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=24jJLMzh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oAL4XSiPCdCxsFRJpP40OPeCmZ3h+2yPthNLW4wasU8=; b=24jJLMzhlw7fsF4lRmyyaKTDTx
	C6S+XfsZYT/9OiZCMj8PFnItGB1ZdWZtMRkqOkkDzJ87CeF59ewfAChpYpskYBGDDGOEMHHwdg9tX
	W23GLz2Ba604H3O9k1YeJl4nkog9PnISEKvDbuGdcI6+L/iyaLv8TDiqxbwS9pJAqGzd6MqFKD93N
	Krb27Y6ZMgEjUdDhQt6cbusxaFJjJjGT4WXzhkY+knKTNqvqyM/3cwvVvagwKhHy/DWSv89rUxowX
	jlKo5qk5Nyxahny3AF0eTdjQmd2HBpInxzHoYsmfURSuOYpCuA9LLpsUzqvF6gUZRbAB7H2w+FqXT
	bixtb8qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sp0zR-0000000FD7N-1nHB;
	Fri, 13 Sep 2024 07:45:13 +0000
Date: Fri, 13 Sep 2024 00:45:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Conrad Meyer <conradmeyer@meta.com>
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
Message-ID: <ZuPtiR9HEP9wMoIG@infradead.org>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
 <ZuK1OlmycUeN3S7d@infradead.org>
 <707bc959-53f0-45c9-9898-59b0ccbf216a@gmail.com>
 <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a79cd5-2534-4614-bead-e77a087fefb2@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 12, 2024 at 10:32:21AM -0600, Jens Axboe wrote:
> How about we just drop 6-8 for now, and just focus on getting the actual
> main discard operation in? That's (by far) the most important anyway,
> and we can always add the write-zeroes bit later.

Sounds fine to me.


