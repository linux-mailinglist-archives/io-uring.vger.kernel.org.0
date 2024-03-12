Return-Path: <io-uring+bounces-896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A3987973A
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 16:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 288961C21AFC
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A837B3EF;
	Tue, 12 Mar 2024 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="HA+Qbrc8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B222D6997A;
	Tue, 12 Mar 2024 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256484; cv=none; b=twvP7hZ/V1PqZ+qEfLN7khUQ6ZTcRMyTmTin6+yOTyXdsyaiBY1qUCTMLqSIQR06Myv/DgdLaTysLTtRnpYNy+umSFYpr59+ggz0mGX/Atn3J/mYu77Uy8fr0YV1tTg5GRekrpb8HHyLqo0+VhyhOO/KvPOcuxNF2UXY8fQTyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256484; c=relaxed/simple;
	bh=vO1UqO6McqxCN2tA+vaXaH1GgUv/t4jNkyN9AlqCpME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/qHJGZmV/aE+5NCmgli5D7FhxisvOij4Ihkrqsr6TruWBNmtUoEFD4f5hKfhtiG1IJqnTuozpnQPXk2h1a5iUuiChTZQ7d3aRbrCp019RHkLnAbrgapMD7ecPW9/d4Tt9e+IzgGQe2ay2c6JHJaWqCpcpZF9xd6wbgI6veuEc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=HA+Qbrc8; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost (unknown [46.242.8.170])
	by mail.ispras.ru (Postfix) with ESMTPSA id 3684440AC4FD;
	Tue, 12 Mar 2024 15:14:39 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3684440AC4FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1710256479;
	bh=/8irDg37OEF4CUrANR31ozt46LmJy7/pzEj+6BqzVfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HA+Qbrc8RUBZjtO0qOieLKzQ8VaAUA1PaHmxNXnk+qDBU439oKFTUupfy2FcxWnYq
	 8iyDvECOIuHf1VanJuiFJCEBdn2VBC8b7juRTIvb3W7SHzuiX0TNkU4zv4zBUefmef
	 /KNm+kRxdwvmJR0fvLTV+M6uAFDDNI23YSs9igEI=
Date: Tue, 12 Mar 2024 18:14:38 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, 
	lvc-project@linuxtesting.org, Nikita Zhandarovich <n.zhandarovich@fintech.ru>, 
	Roman Belyaev <belyaevrd@yandex.ru>
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Message-ID: <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
 <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>

On 24/03/12 08:34AM, Jens Axboe wrote:
> On 3/12/24 8:23 AM, Fedor Pchelkin wrote:

[...]

> > I feel io_uring-SCM related code should be dropped entirely from the
> > stable branches as the backports already differ greatly between versions
> > and some parts are still kept, some have been dropped in a non-consistent
> > order. Though this might contradict with stable kernel rules or be
> > inappropriate for some other reason.
> 
> Looks fine to me, and I agree, it makes much more sense to drop it all
> from 5.10/5.15-stable as well to keep them in sync with upstream. And I
> think this is fine for stable, dropping code is always a good thing.
> 

Alright, got it. So that would require dropping it from all of the
supported 5.4, 6.1, 6.6, 6.7, too.

Would it be okay if I'll send this as a series?

--
Fedor

