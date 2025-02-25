Return-Path: <io-uring+bounces-6764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FB7A44EDF
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 22:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 606047A15AB
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 21:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDD520E70C;
	Tue, 25 Feb 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m11Wp4DM"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A320C476;
	Tue, 25 Feb 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518961; cv=none; b=bXigZmtkfCG8lw8bhAOxLDkQKLyKyBHseDrEOOueu69XEbxRoICFEvpTW1GwgyRV/quZZqceg2QGhxWxVLi60KiQQ3zk9b6fM+AI7DMY6AxdNzhp3RDv16kqIKruZM/gTCtjrrNLv9nfYk3CisNVxB/Rt5NUTNv8ysuoQDq8y3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518961; c=relaxed/simple;
	bh=u/SAUmzyS2rFg21YRo0XOKpna2X+UiI1G4MhDNEbIZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XT6qUPuLJbOvG9pelzpSsaGs90zUefYQrMC2uru8rFM68vWNjcIxZutKTLCy6zJPfWwGpApqlgiU7U96MnTf//tfJ3QDabdxSva3nwBchs/nysWq0Ye0liLK9fpqnqvXJpO5o0THw83XL07g0FkeAiJWeRGo6AWd7UPJy751kUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m11Wp4DM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CE0C4CEDD;
	Tue, 25 Feb 2025 21:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740518961;
	bh=u/SAUmzyS2rFg21YRo0XOKpna2X+UiI1G4MhDNEbIZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m11Wp4DMUQ+GSNUeuHAYa2TAzseYGio4zNz7WxrpQUa0glqYll1wpS5w+3IQXDgvu
	 cLzOleNaJqZ5aVBhrZbWwZLwuVk6jMtAvAy3WoIqNwVix8AiX9biIN5KF5l1WzfNcO
	 2GKmaNMkjY4ewSsiwCVUIGOMkjV5bTZnDzbvYyWayxMyi2mDC3qJFwlX0Nop0e5eZQ
	 Z82ZJV8zJ18YDeraRGRzE2/JjhLQXs0sXnh0BS53eLuLJZqwgZQ8sZz0OWlpRRx6QT
	 VGwoDWVkaZyuW9VgPQGbeGWWy/nesZJS/3YTL76R8PYcOzrbDx4v0IAQSjxK2pvjdj
	 YBufiAocc+IHA==
Date: Tue, 25 Feb 2025 14:29:19 -0700
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ublk: complete command synchronously on error
Message-ID: <Z742L4k3yY1QB2CD@kbusch-mbp>
References: <20250225212456.2902549-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225212456.2902549-1-csander@purestorage.com>

On Tue, Feb 25, 2025 at 02:24:55PM -0700, Caleb Sander Mateos wrote:
> In case of an error, ublk's ->uring_cmd() functions currently return
> -EIOCBQUEUED and immediately call io_uring_cmd_done(). -EIOCBQUEUED and
> io_uring_cmd_done() are intended for asynchronous completions. For
> synchronous completions, the ->uring_cmd() function can just return the
> negative return code directly. This skips io_uring_cmd_del_cancelable(),
> and deferring the completion to task work. So return the error code
> directly from __ublk_ch_uring_cmd() and ublk_ctrl_uring_cmd().
> 
> Update ublk_ch_uring_cmd_cb(), which currently ignores the return value
> from __ublk_ch_uring_cmd(), to call io_uring_cmd_done() for synchronous
> completions.

Makes sense, and looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

