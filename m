Return-Path: <io-uring+bounces-8167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB4CAC9573
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058CB500FD0
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076332475D0;
	Fri, 30 May 2025 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+7bwGQy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75E62441AA
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748628259; cv=none; b=Flsl8zSNeyQPpcdYrWnhl/rViW5pMd87AwcaUdiVgoUM4TKMVUHWGSDd7iq253t59Ib6J/FF9paJL1yzBtDu9SGi7EwG+ww3iRjVVRAujdKvc97ATzUjZ5HBR4RmWfvrHdybzPTwLZ7SkvJ5GTcBgwu3R/7ro13H8bjgiEm9gMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748628259; c=relaxed/simple;
	bh=aQfj4Lr/SQzdm1svA0VC4cv9L8YVp3nVdwH7B8RSLyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqiWt4eU3XigrkvyAsjpbDPm8Ae9t436q6bSVnhEHLgvq/eB6w1LjP/hOm8DOWEArgPyUR0Sojs0exjqGEyQ4OXRkJJ5P46wAnjxtSk7cBi0jaSxy61uzfuR7KQJXO+ZY2AnODMt+M6lEI/oHmZppDCTdppSSsF6lkajc5YKR0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+7bwGQy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D4C4CEE9;
	Fri, 30 May 2025 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748628258;
	bh=aQfj4Lr/SQzdm1svA0VC4cv9L8YVp3nVdwH7B8RSLyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+7bwGQyua2BF4HT5GdZXQXGBM31pUzSd3ghnUjsddCNXHDowEPqlqpyyPwwz50aO
	 4u9rarbUANde0iM65hxWaOne6bPTBZeTcQVvgSSrWdZlswTNQ5sAhVykVkLHWyEcVt
	 eS6P5rSkZyyRWgWF4SaA/7ohVj7zotTo7aN7FjodrHdxVDs9is9fbgSm1ByrZf4mEl
	 xVeLZ10qMHFQZAbZ67CgQT83KM7Iy90PYGdowpolLrEZ4ib2docMzMQINpe6lrjWpQ
	 tdrvBXrBEY8y0tej+ZXykQI3XFuwca7Ax5g9m2fCoFQVQpTh8qCcVtpchpHp+96Ycr
	 x0UmDiY7Y0gOA==
Date: Fri, 30 May 2025 12:04:16 -0600
From: Keith Busch <kbusch@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
Message-ID: <aDnzIKDV3-CZHEC0@kbusch-mbp>
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>

On Fri, May 30, 2025 at 01:51:58PM +0100, Pavel Begunkov wrote:
> +++ b/io_uring/mock_file.h
> @@ -0,0 +1,22 @@
> +#ifndef IOU_MOCK_H
> +#define IOU_MOCK_H
> +
> +#include <linux/types.h>
> +
> +struct io_uring_mock_probe {
> +	__u64		features;
> +	__u64		__resv[9];
> +};
> +
> +struct io_uring_mock_create {
> +	__u32		out_fd;
> +	__u32		flags;
> +	__u64		__resv[15];
> +};
> +
> +enum {
> +	IORING_MOCK_MGR_CMD_PROBE,
> +	IORING_MOCK_MGR_CMD_CREATE,
> +};
> +
> +#endif

Shouldn't this go in a linux/uapi header instead?

