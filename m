Return-Path: <io-uring+bounces-6410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12899A3490E
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B4331891AC4
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E2C1FF7AD;
	Thu, 13 Feb 2025 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxjdnT+X"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F141C863C
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739462796; cv=none; b=tjHdZ3NO+IkYH440ffMQnow2VB39LJk1UtHvjq1yu/e98rnmZtbg/Xz661juZMi0G8ikU+WdV4lcRdAC96sgN6PGeoDAzJ3AWebHUgvQOCk/zMFiHdYp8HhwbJ8SNwRmifOkZ2m91jt3YeVskOnmrVntyaxwZtnFA2lAS3fsGvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739462796; c=relaxed/simple;
	bh=l0dW3gyRladylDpy6bWvalAkVoUz5w+ir1COiRApjQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRNg/URSImFBEM9uyoLeSdJG32Nla0+8plON9ZLeNmJ09Pm//ralvUQbKOD0EvzjA38z+eZK9yLdcGpGvrl+kbZpCI0pOin/2Nl166kQc45R2YrdsvA/1zE3ScFzmNMhhTceyvgqwJMPxfb7+QXbMWWRrr5c5GqOnidZztObKmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxjdnT+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC49C4CEEA;
	Thu, 13 Feb 2025 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739462796;
	bh=l0dW3gyRladylDpy6bWvalAkVoUz5w+ir1COiRApjQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YxjdnT+XipfSrICApBqjJf+NLeyMYaI8SFukHeYEpgJkOowuoCiJfLyrLgBR7EJcj
	 nD509MBej3c6kXcwwmtG2gXzEqbZ8vJMLwhoeojlXfMqOG73oyGoS1E+IplSWsfmFI
	 LH06682fepuAaYntkL9hxl/iMpkvqHsnaPwITs+W849J+6jvdCwf9H6UMBCS1c7Azj
	 qsN4ie5vghzep1Fg0FDKqlORDWG6f69/rTQvNqkjmel4EqHhkO5N/n9Uaj8XBC7HOq
	 Wsj7zqLy8K60fpIHhTTmJ+lUUZtU4TPHKwQmQpNhnAxgEOER8NL7r7Fq0XDi7pta8R
	 CS6VY6xIuK0SA==
Date: Thu, 13 Feb 2025 09:06:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: lizetao <lizetao1@huawei.com>
Cc: Keith Busch <kbusch@meta.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
Message-ID: <Z64YiTHfvA-_NCsl@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <83fd69a8aa77450093acb1ada05c188f@huawei.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83fd69a8aa77450093acb1ada05c188f@huawei.com>

On Thu, Feb 13, 2025 at 03:12:43PM +0000, lizetao wrote:
> I tested this patch set. When I use null as the device, the test results are like your v1.
> When the bs is 4k, there is a slight improvement; when the bs is 64k, there is a significant improvement.
> However, when I used loop as the device, I found that there was no improvement, whether using 4k or 64k. As follow:
> 
>   ublk add -t loop -f ./ublk-loop.img 
>   ublk add -t loop -f ./ublk-loop-zerocopy.img
> 
>   fio -filename=/dev/ublkb0 -direct=1 -rw=read -iodepth=1 -ioengine=io_uring -bs=128k -size=5G
>     read: IOPS=2015, BW=126MiB/s (132MB/s)(1260MiB/10005msec)
> 
>   fio -filename=/dev/ublkb1 -direct=1 -rw=read -iodepth=1 -ioengine=io_uring -bs=128k -size=5G
>     read: IOPS=1998, BW=125MiB/s (131MB/s)(1250MiB/10005msec)
> 
> 
> So, this patch set is optimized for null type devices? Or if I've missed any key information, please let me know.

What do you get if if you run your fio job directly on your
ublk-loop.img file?

Throughput should improve until you've saturated the backend device.
Once you hit that point, the primary benefit of zero-copy come from
decreased memory and CPU utilizations.

