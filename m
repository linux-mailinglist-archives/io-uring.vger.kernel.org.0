Return-Path: <io-uring+bounces-2262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB8090E0FE
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 02:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9353BB223AE
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 00:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084794687;
	Wed, 19 Jun 2024 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TA+1th5z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C41878;
	Wed, 19 Jun 2024 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718758204; cv=none; b=Y6rIJg9T5ugVWrotYgHolMGJfnjxiE5JaluQXxXzCBoErjz4zx7d22wIcLZqCVBN+Fa3Y7ciM66o2IWAke84CwCeLzvNhnZTNU4qJa6y+SAl10j8KBmJ3VRw68LypDcYxMbSmrFYKna/Ed8REBn7yqi4In5toDGCtkzi+FPLsvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718758204; c=relaxed/simple;
	bh=tS6WpNmx5Yabcca1dkxBkzvGAfraxWu/5VnJVbfu/Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+eqmEl76DTyLZKoTHtBHmyeYcEKue1xccXKFx6wlF7vrKuAfr+oUOZfbd/7WfsHdrm+MEDLKfswMdblXupZPO8LmL9lURswxspV86wk1v5BTZwvwU3KetgnzTHR+xN9tBnklRgeLAsg+BsGCOdkreXY2KvCItovK+xk4Dz/GrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TA+1th5z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E97C3277B;
	Wed, 19 Jun 2024 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718758204;
	bh=tS6WpNmx5Yabcca1dkxBkzvGAfraxWu/5VnJVbfu/Pk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TA+1th5zFapfiL9qquymA+0ZrsbDiUJVJSu0Ea7ny7MQro1xpMWbiSW8IXqNh6gAF
	 MyKGXFOLG6TITH28378d0QJ2tb9Z4QN712dCkW4N8jM38YueoJEMRIVGYwVzmjlsKe
	 Y7TGQ9tQyRTkUINVLEq/3FpXHwCvGW7ERbNnTXQV3+VUJH82DlOP5FUlkSa31LJ+RT
	 rThwaUCG1KsX5Yup35QLfpQ+sFZXa18u8c3+tXeDbM04qfQDo3dTaWQT869A9BMVMy
	 6ech8d7r6HlV9xSQ/Ov+bMBhtpyd8nPHy1eL11gO/P34X8K80+GfuBDegB6W9G+y+k
	 3ljrje795CnHg==
Date: Tue, 18 Jun 2024 17:50:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] net: Split a __sys_listen helper for io_uring
Message-ID: <20240618175003.77cd1f38@kernel.org>
In-Reply-To: <20240614163047.31581-2-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
	<20240614163047.31581-2-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 12:30:45 -0400 Gabriel Krisman Bertazi wrote:
> io_uring holds a reference to the file and maintains a sockaddr_storage
> address.  Similarly to what was done to __sys_connect_file, split an
> internal helper for __sys_listen in preparation to support an
> io_uring listen command.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Acked-by: Jakub Kicinski <kuba@kernel.org>

