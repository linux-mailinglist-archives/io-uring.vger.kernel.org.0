Return-Path: <io-uring+bounces-10786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 241DDC84FC8
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 13:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C1AF134F453
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 12:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E41A2D8363;
	Tue, 25 Nov 2025 12:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nJ09j7ny"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F8318DB1E;
	Tue, 25 Nov 2025 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764074192; cv=none; b=PoXLU7d97+QejXSmmj0kVTbr2QZ4wPwphJf8Ji96MskGIkA8eQIIIQOCirC49iylt2HxWtVeIZGUbhZ+CwCkBLJ9LKVm4JYaXLOv6dYvLYyE/Zag6T6v39J9KmPkZ6H/x0HApBQ3kaYsYaXIjIchxQwycH32hP8NZxSP56+mPx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764074192; c=relaxed/simple;
	bh=7gLoF+A+jDDArR/hVGHdVTDI7TMiWOgOE+4BeLqXueo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIRHsoeXjIia/xYQiKjOAHLZ/8y7fXu8y4+4BkGYSjdIJ4j4n4IIIFaGRtAlrXtPncsx8bbZ14k0jjAzugTq5NZ+E8PSMBuXeZ7vh1IFDlY939afcjwIvupMX1XG6Sqx6+NcTkyPf1ZrswQxRmJpKbQDYZeY39JFFOU7F74sGZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nJ09j7ny; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xpjLh8Qb/oxGb6FZFlBQJFFoX8ai6q4B1YySZdjuixw=; b=nJ09j7nyXrP7hFm09Cv7Kendck
	wA12tqxol9GwhfiyeZxbHoN1htQRn0P2NiCVNwWUCvyBr3u+ydH9RI4aq6wMI0xP+ujXmoUygYW/A
	sUZC+PGpU4yxIczXIZAxGFVmshCkF7QRUkhekJNZi8oU7+xf/ycochzMQ+mBrMXcMylS3l6RRmUui
	u8XHxyBvEyckO5IzlbY16Y8r/GZmavkQVcQoZJ1vKgFBVrjoxrwLDbjyrMSEJUBseFA1GTvBKgupz
	2KSbEqI6GRvHVpbrvXdzskJHZLz+bOXOuYdJSX5KriTarQxrkK8lcItG2s36ia80tdEmwa0mhTchS
	gKx3BmdlQivZZB8kAqKcld/BGy1SDTQ1l1gfrORWxxeBJhMZJLrGoLRWPy0RPk5tMa5/DifZxX/A/
	wtvezD+MUmN1CdiCW0CVkEo4vzjXiLdi1zDbM/wezWl4xH60lGJ/pqzt0KgbU1RrYi9GSUPkaB/53
	kAmK+++u++jKQh3ZwtmeKbFN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNsHS-00Fa4I-2z;
	Tue, 25 Nov 2025 12:36:26 +0000
Message-ID: <dc97cb0e-628c-4a97-98ca-06ececf32e1e@samba.org>
Date: Tue, 25 Nov 2025 13:36:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] io_uring: Introduce getsockname io_uring cmd
To: Gabriel Krisman Bertazi <krisman@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Simon Horman <horms@kernel.org>
References: <20251125002345.2130897-1-krisman@suse.de>
 <20251125002345.2130897-4-krisman@suse.de>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251125002345.2130897-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Gabriel,

> +static int io_uring_cmd_getsockname(struct socket *sock,
> +				    struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	const struct io_uring_sqe *sqe = cmd->sqe;
> +	struct sockaddr __user *uaddr;
> +	unsigned int peer;
> +	int __user *ulen;
> +
> +	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
> +		return -EINVAL;
> +
> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ulen = u64_to_user_ptr(sqe->addr3);
> +	peer = READ_ONCE(sqe->optlen);
> +	if (peer > 1)
> +		return -EINVAL;
> +	return do_getsockname(sock, 0, uaddr, ulen);

I guess this should actually pass down 'peer' instead of '0'?

metze

