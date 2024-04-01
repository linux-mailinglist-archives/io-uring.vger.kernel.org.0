Return-Path: <io-uring+bounces-1344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2358937BE
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 05:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FBFA1F21407
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 03:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDEC610E;
	Mon,  1 Apr 2024 03:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lq6Z0jMS"
X-Original-To: io-uring@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25561443D
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 03:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711941735; cv=none; b=aPHEMTeiX8Yr2Mneqbhm2afBT8X+p6UoX2ndZCnMwrbAjJEVM+AKf2sptsjaaz2c2/Cp3PZsiybg1Qm3EO0pYsI8GsQUIQiFTreznkJ05MSU+bnlwpQfkNo+u8tPzC1I4JuCxp9m33VcuMk8wL4Sjlgp98zQq4ZzOeVMc1jIBVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711941735; c=relaxed/simple;
	bh=bFZG8fdwOXmY5gp/Ygvlq6Ww6X3u42PHaZcD+BB2dRk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Vcuae4oW1mirm2nXYDSsQ7MStJGaWwikgi/oFcjDn9POS+FSIk0Nj6RUPIqKeGf8w32v0tPJQLD3lYW5e924YVOwl+XzxZD8VKxacin0xF/iAjk5KOJfdk+n37iVHn0K/s7dUs8hujf1118hdAYI/++RWkFiSilr4DFSAaKPPcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lq6Z0jMS; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711941730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFZG8fdwOXmY5gp/Ygvlq6Ww6X3u42PHaZcD+BB2dRk=;
	b=Lq6Z0jMSLgfpkaXPiKGWrriY+Gir/Xdh6UbGT4GOVc3DljvxjojyAz/WMXSFeg72CkUJox
	Ryhzo98vQSuKrUnjbCYI1z1BXBJSyb0ixueDHg/Sbn+FM9pMnRQJEeyycz/xoIV6NoULX4
	xon7jCh0byFYcLVQ0RihpPUJD9jS87E=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH 1/7] memory: Remove the now superfluous sentinel element
 from ctl_table array
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-1-47c1463b3af2@samsung.com>
Date: Mon, 1 Apr 2024 11:21:25 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <naoya.horiguchi@nec.com>,
 John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Kees Cook <keescook@chromium.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Atish Patra <atishp@atishpatra.org>,
 Anup Patel <anup@brainfault.org>,
 Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Luis Chamberlain <mcgrof@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org,
 keyrings@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 io-uring@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8E19B519-9035-42E0-92DC-7C21471543D8@linux.dev>
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
 <20240328-jag-sysctl_remset_misc-v1-1-47c1463b3af2@samsung.com>
To: j.granados@samsung.com
X-Migadu-Flow: FLOW_OUT



> On Mar 28, 2024, at 23:57, Joel Granados via B4 Relay =
<devnull+j.granados.samsung.com@kernel.org> wrote:
>=20
> From: Joel Granados <j.granados@samsung.com>
>=20
> This commit comes at the tail end of a greater effort to remove the
> empty elements at the end of the ctl_table arrays (sentinels) which =
will
> reduce the overall build time size of the kernel and run time memory
> bloat by ~64 bytes per sentinel (further information Link :
> =
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)
>=20
> Remove sentinel from all files under mm/ that register a sysctl table.
>=20
> Signed-off-by: Joel Granados <j.granados@samsung.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

THanks.


