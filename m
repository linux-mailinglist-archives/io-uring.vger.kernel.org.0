Return-Path: <io-uring+bounces-11231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B5FCD1888
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 20:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F72C30124D4
	for <lists+io-uring@lfdr.de>; Fri, 19 Dec 2025 19:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5834CA6F;
	Fri, 19 Dec 2025 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M32unRe5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966529E113
	for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 19:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766170956; cv=none; b=tm0xI88Sau4i5vXOY3eZBcc/NTv41jUC3zZsVzpXWE4RK7UmzaQkXYmtlpCsGO3ZJbyKaSF33dUU+EuKIO1kaOFG1me5FB8fvmDYMWaJaZ8FAsOnFK7d/foT0vKj7xgL6SCudHW/r4ZXHbHSPQLM7i18M4eoUUZIeNIJb0/O9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766170956; c=relaxed/simple;
	bh=5wMt2CG+Z+ii4XVh3y1doob6qBG9tQAKPZshXhT9lzo=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=aQomVQn7cMvxi/SyWAjKTROH4kodyN/XR2mG1Ls8e9UBCDYr17+iYCE4JkMK+U7rNsoWH4QloHwxv3uPAsp3/Ezd8RRB8+fA4od5WFlYSFo9TGtSdG2tuLWjtC/Ds9T261weDArZDCOC/agsiwINkDuUAnWnpYuamjeIJuiPsk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M32unRe5; arc=none smtp.client-ip=209.85.128.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-78fb9a67b06so7797007b3.1
        for <io-uring@vger.kernel.org>; Fri, 19 Dec 2025 11:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766170954; x=1766775754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7X6ScpTubi9V6KNGf+Mxp/fxYlQRd+flt+Jmf08SOs=;
        b=M32unRe5kAbiNvmWcseT7CiEv2bsHPTzrYFrWUVayJwCZ9yYiN3nb1oVrNRUM3pX9p
         wbekbSgfpTl+gbKAJNCeQOfCHuLQHHtqOsOTRUWQJ/1GMHMn9dOunbJR5NI+V2LGHggh
         8e+8bVRuJas1JA/hZUoi8nMVH37StiJVXfSvDVxTSTDpTyFTELNBuu3qHjwR46Aykulv
         GsyFMnW1e/lrRwbTHzQAdTbdk4orZlS7of5sxXDrK6c0whbd1rxQLkxzSQe7kLh7ALET
         10Rl7uNgeU1WsdSc3ZPxYbQwb33Q0hdue7eyfF0KzyQudbtyHgFH4033/MCX90ZYqQzd
         2REg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766170954; x=1766775754;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+7X6ScpTubi9V6KNGf+Mxp/fxYlQRd+flt+Jmf08SOs=;
        b=mRJV2YRRtP6JsmJBO+jSNSQPdTtRCcGZ6nEv7CY7vlfHiuJtRE6px7rqoBWvjuz2UT
         UJQyt/soBCHC/WT8vLNTixHs/esxclG7uVtvL3H7yDhprNARHKwHx+4hz0ID6Mx4Y1ge
         ZTViyp8evNAz5xB02RpCon92wtdsZoi57gYco14icjrGuFZ9BFyzwf2VaKjPK3fwkXsM
         toIKW4MpiY4IVpVwfiONBYFgEIQaNq8VvcVBYizkuQ6VrUb6Washzt68gSdbnPAJRmoD
         gDqLQiEA+vZZgPnKPObUvQV8aOlMPiG61TbC6aKEUCn+lZGt+m2R00v13r6GbFxCUyxV
         oGbg==
X-Gm-Message-State: AOJu0Yx/6gQr7WZux+uO0VxXVGm0opfcnYvQyxSPQwl1s//Mm+3SXvix
	/j9TkYTcOcW6h/6oxURu1YiODk4vxFO8gLdo5hyIoJ3OtNUvZHY/Igo2
X-Gm-Gg: AY/fxX52AroyobwkxxmZFpdjSyPnT5H2p5D8lwxoRez5rtRjd1xHcnZS4qs276bYNAn
	P9sbv+tTmu8nWYLUfS6uNmVrqbwpTRF5hQJGBiu0GODq7eiILlnNuPNRCmqaIqWISkF6CDY7cuS
	I/vD/mocGMsImUapn9lpz++3Nk/2BsM3c9OyvOvz+5sgY8zLU4y6UHt/LmRuUEC1ayiFceflSep
	vwv2sMUr5Tnf3eOuV4QjyRsqOJrVc3vacx7pcUI8OiNz5kpNO7lxlpT5dOL0WHS+1yVkbKHKXL9
	DuaQtwzZx0P90wtFr0rH65CXodTRsVhvr+KlKpDeRdluTvxnLZPEKWxRUkllqtzj8K2F74zDx82
	3PoHfxsvnOBZo1r3r9/R77cr/bTvanfSyBC13PAB+JTZwGgIP39qq3Q2ZDj4gu4DDtj86FcPNli
	Wpp8Bdetl7bbVimkHUF+b1+pZ3qe6hfkwXGEnzeojMRpw9rYXJCvxfEmCffIFAW2dhmXXpZ3UYg
	Uq9pQ==
X-Google-Smtp-Source: AGHT+IHQMi0rtWTe20QiMK70YtJOLFwClFCN26ZMDPjLIROVmTmp6qGUNhPVGFDejdQzPRmxA+UUaw==
X-Received: by 2002:a53:d204:0:b0:645:5540:2cd4 with SMTP id 956f58d0204a3-6466a8a517dmr2507235d50.6.1766170953745;
        Fri, 19 Dec 2025 11:02:33 -0800 (PST)
Received: from gmail.com (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 00721157ae682-78fb44f0e3csm12855847b3.28.2025.12.19.11.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:02:32 -0800 (PST)
Date: Fri, 19 Dec 2025 14:02:32 -0500
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, 
 netdev <netdev@vger.kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Willem de Bruijn <willemb@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, 
 Julian Orth <ju.orth@gmail.com>
Message-ID: <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
In-Reply-To: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
> incorrect, as ->msg_get_inq is just the caller asking for the remainder
> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
> original commit states that this is done to make sockets
> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
> cmsg headers internally at all, and it's actively wrong as this means
> that cmsg's are always posted if someone does recvmsg via io_uring.
> 
> Fix that up by only posting a cmsg if u->recvmsg_inq is set.
> 
> Additionally, mirror how TCP handles inquiry handling in that it should
> only be done for a successful return. This makes the logic for the two
> identical.
> 
> Cc: stable@vger.kernel.org
> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
> Reported-by: Julian Orth <ju.orth@gmail.com>
> Link: https://github.com/axboe/liburing/issues/1509
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> V2:
> - Unify logic with tcp
> - Squash the two patches into one
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 55cdebfa0da0..a7ca74653d94 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2904,6 +2904,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  	unsigned int last_len;
>  	struct unix_sock *u;
>  	int copied = 0;
> +	bool do_cmsg;
>  	int err = 0;
>  	long timeo;
>  	int target;
> @@ -2929,6 +2930,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  
>  	u = unix_sk(sk);
>  
> +	do_cmsg = READ_ONCE(u->recvmsg_inq);
> +	if (do_cmsg)
> +		msg->msg_get_inq = 1;

I would avoid overwriting user written fields if it's easy to do so.

In this case it probably is harmless. But we've learned the hard way
that applications can even get confused by recvmsg setting msg_flags.
I've seen multiple reports of applications failing to scrub that field
inbetween calls.

Also just more similar to tcp:

       do_cmsg = READ_ONCE(u->recvmsg_inq);
       if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {

>  redo:
>  	/* Lock the socket to prevent queue disordering
>  	 * while sleeps in memcpy_tomsg
> @@ -3088,10 +3092,11 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  	if (msg) {
>  		scm_recv_unix(sock, msg, &scm, flags);
>  
> -		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
> +		if (msg->msg_get_inq && (copied ?: err) >= 0) {
>  			msg->msg_inq = READ_ONCE(u->inq_len);
> -			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
> -				 sizeof(msg->msg_inq), &msg->msg_inq);
> +			if (do_cmsg)
> +				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
> +					 sizeof(msg->msg_inq), &msg->msg_inq);
>  		}
>  	} else {
>  		scm_destroy(&scm);
> -- 
> Jens Axboe
> 
> 



