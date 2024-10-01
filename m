Return-Path: <io-uring+bounces-3344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3FD98B837
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 11:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C941C22D8A
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 09:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571BF19D884;
	Tue,  1 Oct 2024 09:20:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEE115B54C;
	Tue,  1 Oct 2024 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727774456; cv=none; b=rfSMvUmI0nfZiYxM1aOBVFAg3EiQnEfIuud+wt3PEQL2Y8AiPI83zPVTPrmW8Cnwa8EGgebiqfi7Ij0mkhyxrUmfGJDYwWqh56lkbqzyqDqEWZjwrRkrJ2Uoh1GPrr93vsViJ5KtiQBn1LQkSRy+MauwHCPCA9yICfoTHrziCAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727774456; c=relaxed/simple;
	bh=9BM+uzAwiW8lwTOB+YBTzCF3B3mbYwaS7AeG9dF4LA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1YWpAi6W06zi4FfzLI4SCk2k2lBV2aCxnImTJ5f8Ur0w0bAtPgpw3cjyPQhz/NcLI5QFVgWK3giWrXpGpd5YzZ/nH+wMYprqzasGw7QTmXY5QtsV0emCcNJDMd+wP0e0sft26oGiYLru+RQWxAtK0vzvYPUAA7mWpH71+TSnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 59398227A87; Tue,  1 Oct 2024 11:20:48 +0200 (CEST)
Date: Tue, 1 Oct 2024 11:20:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241001092047.GA23730@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Any reason you completely ignored my feedback on the last version
and did not even answer?

That's not a very productive way to work.


