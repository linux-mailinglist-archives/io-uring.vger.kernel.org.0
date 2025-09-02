Return-Path: <io-uring+bounces-9541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D4AB40C65
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 19:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 887007A679A
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 17:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C199D306D35;
	Tue,  2 Sep 2025 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1V5wIzU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F832F761;
	Tue,  2 Sep 2025 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756835231; cv=none; b=RFOzqb0jMSTvSV2YPegKg7iqWd6BFhxrx33a9sos+LBYMtlndpLjrQZlWx1uP0+RSwgBqiD/dN674fw78Lo+SN+wBDHIrOdc6kZlEeapGn1CZ5Rz0ZPvYSHP+zwjTuUArWKx08FvYv7mfFpnVB66uZ1QymhAWQ25H5n5g8XAvRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756835231; c=relaxed/simple;
	bh=nnhqZx29yhrl488m9IBdA4tgoUHb7PNLnLdLoyJ2Pfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlnP5nh4VE+Y4IwS9aIMCV4mUN+Jcey610oTPbyYmAwCzWiUMHJ2B6CJTwlQEkTWPoqJqssmZs1xWjtF5N4Xr80SNfUlnAtODmeDD0xrxd8FxcQG9nW5c2t1WIICQ5hbhSKzGJjmbfZfjdI1yH5grJx2c03q1tggUk8LKHaGtCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1V5wIzU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3F0C4CEED;
	Tue,  2 Sep 2025 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756835229;
	bh=nnhqZx29yhrl488m9IBdA4tgoUHb7PNLnLdLoyJ2Pfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N1V5wIzUiDhYRtEJnDXHzT/oytUu+kI4XZvO5Af62veEeWVBaXWlkaSWFzw9+bMlr
	 cTe2/k5XJZN9fFT6FgdKNPvLlWC7ci3S7tAi0pQRCw1iTsSUjF6kE8UJZsWI2G5IsI
	 AxlFJnrrdT+e+WypE3CkCu4oktRBaUpK3PjwM0INV7HJHDuYfbBZdeDxbDV/rrEIX/
	 56BQHMnqI1ergAwEWnWu/GUuqwaqkSBaXhP39boZ1i2qskdc/7Dh6PtMvQpO+eaG2t
	 +jAHxjVu+ACXBInEX5d9kTuQwSK3wTgtDnD9N5AhZQsEjYXtGNYA+IMj9oR9AIdK//
	 hJylOxAfL5m/A==
Date: Tue, 2 Sep 2025 11:46:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
Message-ID: <aLctkaladNC2QfWY@kbusch-mbp>
References: <20250902160657.1726828-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902160657.1726828-1-csander@purestorage.com>

On Tue, Sep 02, 2025 at 10:06:56AM -0600, Caleb Sander Mateos wrote:
> Introduce a function pointer type alias io_uring_cmd_tw_t for the
> uring_cmd task work callback. This avoids repeating the signature in
> several places. Also name both arguments to the callback to clarify what
> they represent.

Looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>

