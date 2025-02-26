Return-Path: <io-uring+bounces-6806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3EEA46994
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D37221885025
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201D723536F;
	Wed, 26 Feb 2025 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4OChAa4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75F235368;
	Wed, 26 Feb 2025 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593854; cv=none; b=NXUVqppLQkVIAJpBlB/O5x+URZ+kPbd3RY+By0SzYtqAjje96y16XitjqW7qtOPZ3a6LSaZtU/wIFQU4kc2UnFtQMdqx4LTamkE6GoSQHJhty6VvKPBk/75cFnSGjgmeGQ/6mWTK+XdpLNC5V7r5SiwaFz8mk2FhC10WwYB/kb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593854; c=relaxed/simple;
	bh=lHjb7cprCWmCiSQDWLFIs9PflfliVjGgCgC+q4i5VRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIsJBT1SNCYdoD+t9gAxznX2HngTdd3uQmmhj9nAVhlqNjTl2kxG6Ch9Lztm/EelO2xRlIXHs/P/xW1l914nCv5AeG769+mL/48a7dJtA//IsiUgICDwA17U0upTGB1t2q/kYgZqLWGlonfb8TOLuXP2L/rPjfxZ3bmymQF+emc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4OChAa4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3A2C4CED6;
	Wed, 26 Feb 2025 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740593853;
	bh=lHjb7cprCWmCiSQDWLFIs9PflfliVjGgCgC+q4i5VRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4OChAa47qOxVn4GDFrav27LqCAOEyAgXnEmUqqAi7smtqWzYs1zerN0diDGFYTnS
	 DfrfV7cgT7n1QgUavHmBtyid+1DGSSR2NxfswtTXyEs7Nuu3lTV7hZHd1QZTI7lisa
	 EPxPR1z4ZW4LuC9yM5MlGcNwNjhToNRjGIoJqqbGt7ekfqljtC+oJGMkXKKbvsUBpd
	 MUO5pHKJKfLNk3x6Dh3BXSdKhF1NbmmUzS7TYbJmAj0UilAkoPrjNLMKPlbNDDv27y
	 ogXuyp9Ic9ES4zBxb+hOZizKxsjsEROmxnD2pSM3OPQMVygShsfESk3LPTBChbK0Ye
	 KRWLZNTi7BwPQ==
Date: Wed, 26 Feb 2025 11:17:30 -0700
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCHv6 0/6] ublk zero copy support
Message-ID: <Z79auss5rprO8Dwp@kbusch-mbp>
References: <20250226181002.2574148-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226181002.2574148-1-kbusch@meta.com>

I duplicated the format-patch command into the same directory, so I
completely screwed up this patch thread. Please disregard this one, and
we'll start a new one. Sorry for the noise.

