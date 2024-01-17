Return-Path: <io-uring+bounces-417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B145B830A2D
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 16:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B5412878BC
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 15:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9330121A15;
	Wed, 17 Jan 2024 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PXMNMvtd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAAD219F6
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507169; cv=none; b=mILNuYDH2cOay+IUdXxvWvoxGBcyZXxHFw/yq5ecHN799xKPeITlWaAZ5ZrpTbvdiafhRwoLNgJYxIpMF0wHa3HPzEQi6ElPUDa/+gQqNG8otGgR7pSGs/+zJm9jji6SMEaZDZ/Th0sxSLdf1dXguwG7KGTXjs36jT+7zXvNy9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507169; c=relaxed/simple;
	bh=yCIwf7rqcYLIOnH6sMk2OWF/gsteZnoPhG10pLyxVNw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:References:X-PGP-KeyID:X-PGP-CertKey:Date:In-Reply-To:
	 Message-ID:User-Agent:MIME-Version:Content-Type:X-Scanned-By; b=cJa8wrCJK/Ht8RzxAWRuivH4HidVMfYYGNLakriN7vTQHCjeK8PTR1bK2EFCPJDOpVotA8qPisMpP+qjsMyWWOUDCRLmZoriilmT9Yquvj/wFgbOO7Ygbbw6XCZgAW6ish75SuEK/bY2Tn3HhF0c58c2uYyGvn46qIFp1i6nQAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PXMNMvtd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705507167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J718rWlPoSlKYXo4J6dvs2QTMSWdmESww/NvAo5k754=;
	b=PXMNMvtdfywn2PkWTE47oqf+5EP3zoWA3+z5z+TRUByr+77VX0fjXPx11xbxehAwHUkYCB
	0tDAnTgGN5jdngtMSy82iMPlC+LeLotl3AgMEDpJzJBi+BC/Mgj3WgWg9ch3/LNG1HkOPJ
	36I+v6TOTUhG+OQgaswX4Fms0FBQBOs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-ui-YTE9VNla8jdizu7V6zg-1; Wed,
 17 Jan 2024 10:59:14 -0500
X-MC-Unique: ui-YTE9VNla8jdizu7V6zg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC8FE3C44D21;
	Wed, 17 Jan 2024 15:59:13 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.9.125])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 811A340C6EB9;
	Wed, 17 Jan 2024 15:59:13 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/register: guard compat syscall with CONFIG_COMPAT
References: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 17 Jan 2024 10:59:13 -0500
In-Reply-To: <80eceef8-b2d7-47e8-9ef9-7264249dedbb@kernel.dk> (Jens Axboe's
	message of "Wed, 17 Jan 2024 07:51:07 -0700")
Message-ID: <x49il3suf1q.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Hi, Jens,

Jens Axboe <axboe@kernel.dk> writes:

> Add compat.h include to avoid a potential build issue:
>
> io_uring/register.c:281:6: error: call to undeclared function 'in_compat_syscall'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>
> if (in_compat_syscall()) {
>     ^
> 1 warning generated.
> io_uring/register.c:282:9: error: call to undeclared function 'compat_get_bitmap'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
> ret = compat_get_bitmap(cpumask_bits(new_mask),
>       ^
>
> Fixes: c43203154d8a ("io_uring/register: move io_uring_register(2) related code to register.c")
> Reported-by: Manu Bretelle <chantra@meta.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 708dd1d89add..5e62c1208996 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/nospec.h>
> +#include <linux/compat.h>
>  #include <linux/io_uring.h>
>  #include <linux/io_uring_types.h>

This makes sense to me, but I wasn't able to reproduce that build error
after disabling CONFIG_COMPAT.

> @@ -278,13 +279,14 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
>  	if (len > cpumask_size())
>  		len = cpumask_size();
>  
> -	if (in_compat_syscall()) {
> +#ifdef CONFIG_COMPAT
> +	if (in_compat_syscall())

I don't think this is needed.

linux/compat.h:
...
#else /* !CONFIG_COMPAT */

#define is_compat_task() (0)
/* Ensure no one redefines in_compat_syscall() under !CONFIG_COMPAT */
#define in_compat_syscall in_compat_syscall
static inline bool in_compat_syscall(void) { return false; }

Isn't the code fine as-is?

-Jeff

>  		ret = compat_get_bitmap(cpumask_bits(new_mask),
>  					(const compat_ulong_t __user *)arg,
>  					len * 8 /* CHAR_BIT */);
> -	} else {
> +	else
> +#endif
>  		ret = copy_from_user(new_mask, arg, len);
> -	}
>  
>  	if (ret) {
>  		free_cpumask_var(new_mask);


