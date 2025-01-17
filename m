Return-Path: <io-uring+bounces-5991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C015FA15978
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 23:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 123837A1B3C
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 22:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52D81A83E0;
	Fri, 17 Jan 2025 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JN/dubEd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88EB67F;
	Fri, 17 Jan 2025 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737152162; cv=none; b=IgDbMuOeZ/VctfJlWso4pZVKTCKQ3VbYPSTz4bbVYKwO4ocYPSXcKcpJtSHtIFSWfh9QGbCYqY9mo8QJSw6IisrhcQRQMkemP1omLITfb7MMavm+jaeWsVIyHSJyhPgbPnLceZ+CZg3l9IfKAtOVKiIOxx1VsSUTfPjJyBuai2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737152162; c=relaxed/simple;
	bh=vMMd8j1/7YQWhC0o2ydR2eQ0FbzcWZc2rYD7B9o8gOA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oj/LsMYZeP0cjNkW0sBb50i+9cPMl2zANq9XxK2Ytdw+pypZm+Pc0900a1tw9riR1V1B/apGMo5h26CRreyZTBa1z5JpVFWdx927JkudGgrAAlUTPK5kb7npOknLXeRtFS0M8N84Ph5x7c/O10f3ReiGu+v/G3UpRgJ4o7jyz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JN/dubEd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F10C4CEDD;
	Fri, 17 Jan 2025 22:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737152162;
	bh=vMMd8j1/7YQWhC0o2ydR2eQ0FbzcWZc2rYD7B9o8gOA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JN/dubEd7T1pOZuXD/nBaXouzKXbW/9prg8zRv7RfQMxdsJVZ5BVAjuxRSiiiYLr5
	 f9JG3ZHvRBo8L44HXUYDzgB7SYHlmA4aIcyYPVPWw/I7eqIWKy8lt3svfuhfAdW0Qa
	 0SLcSvEG9r0p6mb6Ve2Jt+8/BtHGS+S6T9HxinjR+mrNpdMWsslSnZGvkvCiF+crDP
	 gjQqqsDSXATbFkkEEoocvKC0ZbFEkHgs0EBckGuDbdJTDFTdxCe/Y4x/zqeOO1ICRA
	 l9wm2tTnAsLDLvQNBdOBiaxgfV+5iHd5cJRN2w1/33Jntn5lIJ9O//02fcoPUzeM5k
	 CvGMnZPM0RkrA==
Date: Fri, 17 Jan 2025 14:16:00 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jesper Dangaard
 Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <stfomichev@gmail.com>, Joe
 Damato <jdamato@fastly.com>, Pedro Tammela <pctammela@mojatatu.com>, David
 Wei <dw@davidwei.uk>
Subject: Re: [PATCH net-next v12 00/10] io_uring zero copy rx
Message-ID: <20250117141600.61db4893@kernel.org>
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 16:11:38 +0000 Pavel Begunkov wrote:
> This patchset contains net/ patches needed by a new io_uring request
> implementing zero copy rx into userspace pages, eliminating a kernel
> to user copy.
> 
> We configure a page pool that a driver uses to fill a hw rx queue to
> hand out user pages instead of kernel pages. Any data that ends up
> hitting this hw rx queue will thus be dma'd into userspace memory
> directly, without needing to be bounced through kernel memory. 'Reading'
> data out of a socket instead becomes a _notification_ mechanism, where
> the kernel tells userspace where the data is. The overall approach is
> similar to the devmem TCP proposal.

The YNL codegen is not clean on this series, so CI didn't run 
the selftests. Plus we need to resolve the issue of calling 
the ops on a dead netdev.


diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 684090732068..6c6ee183802d 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -87,7 +87,6 @@ enum {
 };
 
 enum {
-
 	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
 	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
 };
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 684090732068..6c6ee183802d 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -87,7 +87,6 @@ enum {
 };
 
 enum {
-
 	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
 	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
 };
-- 
pw-bot: cr

