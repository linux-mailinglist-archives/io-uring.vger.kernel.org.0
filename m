Return-Path: <io-uring+bounces-6917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B2BA4CD27
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 22:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5EB23AC18A
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 21:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B264214A91;
	Mon,  3 Mar 2025 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="R1QpYJXw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="6B/eGm7E"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AC1E9B3D
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741035833; cv=none; b=OkSZIz+7HQZ7dLW3LIWph863t2qTt3aowXanVYBjXPSss2DC9H7lWKq60rBXQdkh/YeycSq0vOMVqim/GnmhgwNyiNXNcpKjJakj70cjAjuiBYybtpoUyWr0YRNjHKwwVbR44HOLv+9a3KOH/8TPsoU9J5RxjiuwW9wTKlCLxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741035833; c=relaxed/simple;
	bh=ASABhKAEL6ksuleta1d78UAHaWpw89wqwUQ8CB/EAxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1SLlqebrwopNIph8GDcdzS9kIqRp6B6wFDAiiEMeucXnC8n79oYAlu1AickKeDx65cYa3S4hx2uMX9ZNLnZa8S97xo9EhMgl+u6np4YU/HEr5n0I+6gxTQT7b8kCwrIH4ei0KplbXuuU5SIr2JnULU5sAhsG/NJ4YyE1KnSSLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de; spf=pass smtp.mailfrom=anarazel.de; dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b=R1QpYJXw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=6B/eGm7E; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anarazel.de
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 71388254018B;
	Mon,  3 Mar 2025 16:03:50 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 03 Mar 2025 16:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1741035830; x=1741122230; bh=/ww3u6U3ZO
	goAIaYqWY7G1eGE8BbQAOMle3lhpWWcZs=; b=R1QpYJXwRjX3ePpVpLY6lkAfiy
	UbT6QssUMgNzHAc5QK3I7YuIGTqfEdwarJMRwEefYkX4vBIBI8vFptUSEY9PhOkg
	KmoHWz0oY6WoKYSfu9Rmz/LhCApxHNPwUSTD6QUwsZqM8jjRI/ZTQCkHwbHYQY6W
	RJnPFEGxPfHhS8DcA8Ehz8KJLeStQ0/5iJueubW9JULahZLuhQFpYkTZyZGkTfQ0
	JXejI3H+3xvLhUNlTvFbUBQmqcvm+Y/av7/FfrmAbHfJkZ6urZvavS3cEjZ9yAnf
	6eQF747wTzxBwd3VkA1ZzD5iTaQape031slQc2JTC9OJ4Ofe85ySRX4ZXI+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1741035830; x=1741122230; bh=/ww3u6U3ZOgoAIaYqWY7G1eGE8BbQAOMle3
	lhpWWcZs=; b=6B/eGm7ELYSJZrHGdVYPAlpElUD4ZG66neS5jw1gCYmWYCMoJTH
	l4LC+85NLD+c6yR0ma2XJEc2IfPGW96NXqkfadU/pYi23qTZm6sCLEDjMVELqjUx
	WDM2dJZZCE53w+JfSPzBkdCNbIzCVdXjKCcQUV4N1avcpq4zzJ5eRUuNxFk+0CY2
	mSFUdgN3LXrUnzUd7UqlT5s/YE/1cdXstu4V7RphQFLLCwQAepXpemJYl/X1YtvE
	7B3qrjyIG3uKoepAjt4cPMlKknaq/zEkd2HKGe3U8noMIxIjYX1XV134xA7+0h/q
	o/9+e/gPxyHsnUQT/ltgYVE3LYw5QZgaTzw==
X-ME-Sender: <xms:NhnGZwvAPxHi4ZMfV6hkGBHudafqeZ4kOYhXIY67TSN73eJsACwZnw>
    <xme:NhnGZ9fCyHqZLsRP54Tp5CUOnlIAvEQBc2XJJnW_Q8tuV3iyxhWTBCRuPkY8x3Xeu
    4RCpEjGvLKNEXP1pA>
X-ME-Received: <xmr:NhnGZ7x3HK7oRtuBPpUi5o9pxEUVfnyVJEKO5jS4hwrnVNty7XPY2lHzk451xpppgpxfHaBbJtXPGyDK0uexcmNBdAEtygvzF4Ww4PKrBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddutddtudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhf
    fvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpeetnhgurhgvshcuhfhrvghu
    nhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtthgvrhhnpe
    effffgledvffegtdevlefgtdeggffhvdekgfegteeiveejkeetudelveejhfeugeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvsh
    esrghnrghrrgiivghlrdguvgdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:NhnGZzNP5WOzbAfCWGqD7dRhwSvqhHsb8sISNg-7k49hyp4OxywTBA>
    <xmx:NhnGZw9PEgef-gAJhO3sYjKRpzzPz9z6lbq9noTNmqGXBnpXRmfg2g>
    <xmx:NhnGZ7W_jdoAk-y2AG5aXvyRi9Il9ZuRqNmm0Jk3Bw8-PqKj04yNew>
    <xmx:NhnGZ5fPEIz5ulb8jiaps2cQdcPDggy8waNRhz4cutPXpKaqwQUOiA>
    <xmx:NhnGZyKPbMOV8VcaHX-tj2ySP0CMycgUJ4NfCZ6UiEM5mrrCW_lTe6hH>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Mar 2025 16:03:50 -0500 (EST)
Date: Mon, 3 Mar 2025 16:03:49 -0500
From: Andres Freund <andres@anarazel.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
Message-ID: <lscml6pt36b2nebr7mjt5z76mtj2bctr5jxjv7qc2x4cq4ggyv@x35mco47jda6>
References: <cover.1741014186.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>

Hi,

On 2025-03-03 15:50:55 +0000, Pavel Begunkov wrote:
> Add registered buffer support for vectored io_uring operations. That
> allows to pass an iovec, all entries of which must belong to and
> point into the same registered buffer specified by sqe->buf_index.

This is very much appreciated!


> The series covers zerocopy sendmsg and reads / writes. Reads and
> writes are implemented as new opcodes, while zerocopy sendmsg
> reuses IORING_RECVSEND_FIXED_BUF for the api.
> 
> Results are aligned to what one would expect from registered buffers:
> 
> t/io_uring + nullblk, single segment 16K:
>   34 -> 46 GiB/s

FWIW, I'd expect bigger wins with real IO when using 1GB huge pages. I
encountered when there were a lot of reads from a large nvme raid into a small
set of shared huge pages (database buffer pool), by many proceses
concurrently. The constant pinning/unpinning of the relevant folio caused a
lot of contention.

Unfortunately switching to registered buffers would, until now, have required
using non-vectored IO, which causes significant performance regressions in
other cases...

Greetings,

Andres Freund

