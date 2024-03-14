Return-Path: <io-uring+bounces-942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D62B87C0B4
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 16:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05291C20F6D
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 15:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB04C73173;
	Thu, 14 Mar 2024 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="tB6Zfcby"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4517971B51;
	Thu, 14 Mar 2024 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710431720; cv=none; b=J56XYMa0aQE2QONp7cSas5JtVnMVLl6K99+ApAeq/03yK5gB7HeIc+T+yBDGw6udxOuyGb9lBYuTeYV8vbJ/w/RG3pEDiwimu/MO/BelykbErr6a3IgvRCv2od2SVjXh12jqrArWnjpjmI0b0LMIJzBzegtXG+/A4VilZ3C2BeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710431720; c=relaxed/simple;
	bh=MFV31aSnWDbF3dhvEx83NnYWqwWHNAiaFqx73jZqldY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhBFhwaS5Vf7wJvMACaasCwhXQkXtEkYpiE6xj+Rmt36px/GDJ7bGvGZD8Lg8xvyv49zHLBwIljH/wzTZm7OevTZ3y2c6NMDIVdcLjsSdpFSxakiWZZcnd4hdrhRG+lU0C01OlpZp/Gn/2zgXPPaKgl+Tvn8bnlOXf1yXlVtZ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=tB6Zfcby; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost (unknown [46.242.8.170])
	by mail.ispras.ru (Postfix) with ESMTPSA id 3FA3F40769D7;
	Thu, 14 Mar 2024 15:55:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3FA3F40769D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1710431708;
	bh=Y8/0hqrVxFQTEZ0jmU+lA12CNpebBoKMmCpYIktEhvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tB6ZfcbyRL+Ck+4f5rYjjXdBNU5RA3AgUHOlbTWh06BMz6NubFGXSbXf9CpVAyQbi
	 ueFfSiawWqFsBd2HphfGLsouVJMgv9E0vNzAdwYqLTyRcj2c2Bn9ZX2yliV+Kfvnn+
	 /WVXEZTA7+vrpKx0+BIWyxHE9CMvPJhIZe8mvjIo=
Date: Thu, 14 Mar 2024 18:55:08 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, 
	lvc-project@linuxtesting.org, Nikita Zhandarovich <n.zhandarovich@fintech.ru>, 
	Roman Belyaev <belyaevrd@yandex.ru>
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Message-ID: <e7cbf950-c732-4eb3-a91f-8f09249e4f72-pchelkin@ispras.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
 <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
 <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
 <fb57be64-4da6-418b-9369-eae0db42a570@kernel.dk>
 <085beb85-d1a4-4cb0-969b-e0f895a95738@kernel.dk>
 <a8c81d35-e6ac-420c-9ffa-24dd9e009e29-pchelkin@ispras.ru>
 <3f17f1d9-9029-4d03-9b0a-9c500cce54e9@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f17f1d9-9029-4d03-9b0a-9c500cce54e9@kernel.dk>

On 24/03/13 06:40PM, Jens Axboe wrote:
> Hi,
> 
> OK, here they are. Two patches attached for every stable kernel, that
> gets rid of the remnants of the SCM related code:
> 
> 5.4
> 5.10 and 5.15 (same patches)
> 6.1
> 6.6
> 6.7
> 
> Would appreciate if Fedor and Pavel could give them a once over, but I
> think they are all fine. It's just deleting the code...

Thank you, Jens!

FWIW, I think it's all good and it eliminates the reported problem
obviously. Compiled and tested the repro with my kernel config.

Just a minor notice - stable rules declare two common ways for upstream
patch mentioning in backports [1]. And the first one starts from
lowercase. No big deal here definitely but maybe somebody has some
handling of these two variants - by regexps or similar, I actually don't
know. But I see in the git history that Greg also applies the variant
you've used.

[1]: https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3

--
Fedor

