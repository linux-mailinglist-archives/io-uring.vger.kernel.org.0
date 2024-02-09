Return-Path: <io-uring+bounces-590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F34684FC55
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 19:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B25AFB23937
	for <lists+io-uring@lfdr.de>; Fri,  9 Feb 2024 18:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B00762E0;
	Fri,  9 Feb 2024 18:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJGS9TxL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED18364D6;
	Fri,  9 Feb 2024 18:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707504668; cv=none; b=LZauFwPTDWhVA0MCUMdegcewIZ8Oh2iZujL9KrZd2nHo0YrZGg4zUS/DOoOgbj0vEdCdTzoMM2ZKbjeI/L9/0ud6H9APHJITVOnZXTvK9wKugLQrrOkVk52I6tGZpUHvqA2MAZHZljrAtWfPYSTIghlKxSqtV70vFaxSNgb/k+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707504668; c=relaxed/simple;
	bh=tBn03PxZ0VGomJg6uNhQ4qVbd52Mg9nYOlClhGTKTUk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7cgtGNqovm8tFKWOCG6OZvwC10ivrE+oL6vd1Ku/OIVvwoSPXIoNQPquB1zggwWtN7k60EyH2ezC3k8gO4iOi+K2n0hOIxtHYetkHa7Yh3eVK/7XPP1cj4PKbDjlBGBvvOIqrD0Hm7T5lhcKlzjzAaQK97ttA5XS1BpjlN0pB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJGS9TxL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5659EC433F1;
	Fri,  9 Feb 2024 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707504666;
	bh=tBn03PxZ0VGomJg6uNhQ4qVbd52Mg9nYOlClhGTKTUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mJGS9TxLrSkx4lNRMLcgJZCCaOrFz/6UEMkPXCwPSDHKe2Sb9GHCDdwMQ2rxilvMr
	 z2IpaxjYzqAcfJ1FuMITvX5ZaWaCpUtYDvB3DPgh1lfGJGYaI/xWsi9PUp+FFIT5er
	 K9tG2fJ4sCJzt0fCU8w+VFBx4BKtaeXasmRNkvbKum1Kng7/zKr+suU70occGvv9ZF
	 iybk36zxq+nqpUUfi8L4gHoVFRaLHOn//CTTUTzHkXOylGhrFpZbfUYpFIw2XPboW0
	 caTsFbp31IA1xO2MGY9XmI8NFUE/mfql+uIkFk6kQ/rTemeXFDYPu9Wgnw7uF7S0u3
	 qxANZrf1rSUjg==
Date: Fri, 9 Feb 2024 10:51:05 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCHSET v16 0/7] io_uring: add napi busy polling support
Message-ID: <20240209105105.114364e7@kernel.org>
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
References: <20240206163422.646218-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Feb 2024 09:30:02 -0700 Jens Axboe wrote:
> I finally got around to testing this patchset in its current form, and
> results look fine to me. It Works. Using the basic ping/pong test that's
> part of the liburing addition, without enabling NAPI I get:

Pushed the first two to

git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git for-io_uring-add-napi-busy-polling-support

