Return-Path: <io-uring+bounces-2332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 063759167B0
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 14:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A393B1F26D00
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 12:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931C815A878;
	Tue, 25 Jun 2024 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="OxfDRdTt"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7B158D76;
	Tue, 25 Jun 2024 12:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719318217; cv=none; b=BRLiFeS0BSca0lanl+UfZKp2VyB2hQOf03jky2/O4FAVDOInwVoKjzdUM0oiMraFbMxjtGUnwRjcrRAqDBUz36WiztKAMay7c1F7OOS0GigLUvhxLLL3vvXdtVydyWsg7VhzSOABYP5ocbh2xWyvHNsc3onLIL3s+q6hWPQY+jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719318217; c=relaxed/simple;
	bh=8G8rOqFEpTOWrGC/84IZXZF/+QeS8+01Qq0V6M4Dras=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NDCPW6/Sl7fh/qY5RUBaxQWmQ524vFpzgXp0yimWs8VBBd01YlhGydCpe1cUgS5V4dJ+GfLDN2ctFfDQtyrJUa49owrzzviUP8JNySzWRVloh2b301DUGh7Td9WifTBN+5ZXKVl50nP4GezAVGGL9nidRF/YfZZf3jOTeD41bTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=OxfDRdTt; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719318214;
	bh=8G8rOqFEpTOWrGC/84IZXZF/+QeS8+01Qq0V6M4Dras=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=OxfDRdTtecikmsPsWfXCYLRQ9iSKyWcq/XKgF9gmudd5/GRigrvrre9ch2020xtzk
	 JSpF0BYOJ0mW5o+TUoxtOSMtRlHKA6Wn91C3JHwBuIvp0zJKlinNXh6qXQo0ax5WQ4
	 a707tVqxklWs8u3uLP0n+bfpRXjCzXyariTpVmPU=
Received: from [IPv6:240e:456:1030:206f:f170:d271:6bac:49d] (unknown [IPv6:240e:456:1030:206f:f170:d271:6bac:49d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id D13801A3FCE;
	Tue, 25 Jun 2024 08:23:16 -0400 (EDT)
Message-ID: <19ec107368c8c8dd4e627b404106c30b73132cb0.camel@xry111.site>
Subject: Re: [PATCH 1/2] vfs: add CLASS fd_raw
From: Xi Ruoyao <xry111@xry111.site>
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Tue, 25 Jun 2024 20:22:53 +0800
In-Reply-To: <20240625110029.606032-2-mjguzik@gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-2-mjguzik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-06-25 at 13:00 +0200, Mateusz Guzik wrote:
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
> =C2=A0include/linux/file.h | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 169692cb1906..45d0f4800abd 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -84,6 +84,7 @@ static inline void fdput_pos(struct fd f)
> =C2=A0}
> =C2=A0
> =C2=A0DEFINE_CLASS(fd, struct fd, fdput(_T), fdget(fd), int fd)
> +DEFINE_CLASS(fd_raw, struct fd, fdput(_T), fdget_raw(fd), int fd)
> =C2=A0
> =C2=A0extern int f_dupfd(unsigned int from, struct file *file, unsigned f=
lags);
> =C2=A0extern int replace_fd(unsigned fd, struct file *file, unsigned flag=
s);

FWIW this change is already in the mainline kernel as
a0fde7ed05ff020c3e7f410d73ce4f3a72b262d6.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

