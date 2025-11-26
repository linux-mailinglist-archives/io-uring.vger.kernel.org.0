Return-Path: <io-uring+bounces-10817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A07EEC8BEC4
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 21:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419443A68B2
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 20:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202A523D290;
	Wed, 26 Nov 2025 20:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZIxNoXkS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20151221FDE
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190499; cv=none; b=BBarwTeywtzVtd5u3cBkmqlMrv5n6hCkQ04PF/g8hd/o4U0azYiKaahm17+eQi8SsyYb5rIW/kpTe3YOU38SQXi9NVpmQ0J3348wMbSX/QQZmMU3hlzhYSa0jD6kYQ2dSyI2hGiziMcfB9ndVz4eo+uJ/KO4JhczqeiJiDAOAAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190499; c=relaxed/simple;
	bh=AGPNz5MgNdMTSp1hoWWkqOJQvju7a2H/lsI9Hxrnh7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y9o3Ib4aIyY4H8U+tWRJJrcg1jogV8i8KooFV4xT78WtifqDUvFPYFhOcmK5GBKMCWuyfj9+69IHM8AZi9SU9oULULuJimLMS8V1qZCF879wdZuj8IFc7nzBa7NoG8cPgtFfGpYylad/etti6s4/bZKajyG6XZSgVB2XrnBqoDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZIxNoXkS; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-433100c59dcso1078675ab.0
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 12:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764190495; x=1764795295; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a0R+Ta8UaLoKZdQRPPL5x09dwWCalk2iJ5M0hXSo+F0=;
        b=ZIxNoXkSKCqJwtbM3dg27LCzJgL6s1Xzrx9eRAuNqH4zku5CXw8UCy6+96LKmeLyFe
         nbou45kG5XhsgivS7JCgBdtzau4PHQCWA1PE6b4njrkgeAaEOLzybzoIuMBKWrEXTxbO
         ivTjtqj8Rv0l/1C8YMuesUpA3nS/MlSFydtWSPbE1fgigIhCBjW/tSjiZR4MNgehqanP
         2DxQBx9Cv8HZuWYmk9OqffJNBmSrlvfMQD5dcJaOH0CYHOIOE2ioA6QIWWJsXxsby1Gu
         sxPyajSy6GiuTXIUVIGVndVctTMfPsTJxsZJ6yDDXUQatKd7HLUwZFcntn9CB68Jhahm
         fYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764190495; x=1764795295;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0R+Ta8UaLoKZdQRPPL5x09dwWCalk2iJ5M0hXSo+F0=;
        b=hqM1KTcVkY8ucUqkQurgaU/v6Hp8ufgX6wOnlDyIh9/Ub3w2uqcOPk86cdJBixNH7/
         EpWwzMB4Pup5CvQb9BZQDyz2jvDks5YvDZPAgWBIo8NJvG6KgAlC78KH+B0B6l3yy6s+
         o9mA7gE6TwqDTF644ykclWxxPwzFuB0IJHZH1Dyy+sq/0ZIv2RYqjnCzflv2iQp7z7fq
         6PHhk5nvTMMnuPn+C0DkC/Gn/MP5w/CZ2GLX17WKjZ97Fi2PsJ7sJhjuavRfLo+jdXWh
         9TvgPtgE8HcGTIcehqt2JN+UL70fEi9XzqqqMVTGN6Y0ZyQ5yGjnnCfqGig6M1KZy6Eg
         iclw==
X-Gm-Message-State: AOJu0YxvO1C/k4UXxNtDXDYioMV4OPYg0gq0I/7+EXwybUaw/7AeW8Gz
	rK4IXFcEXQDqjsHi09sJzbR4VZkyJ4vj8DDHdX4Ab+SqO2yWect6dUtQK6ZXJk8kcq0=
X-Gm-Gg: ASbGnctSEm7/R3k2PpgIK7lsvK7KNAYbfvMTC7sp/mWPMyxQs+Ie7ioSVqSFI1JDQ0K
	/190sQbs8p6b6XMDK7vrlLlEFd/CJawoyQD7fkV7cJFYd/KAT8TGYnF3y+Qimcxa8sEFRLAymW4
	eg6avmJQr6jGXQyQcHcgUMr9AjXAcNnslFl+Z/RNtwTGTK08X6TjUCwQFS4QpcMPlYXBaGnWyiQ
	40xm9Q8YLfNGq0iczAdavFjzhutMa498VS7/sNkfR2g04xSPmq4qybpoJ9DTdEa4lkTo8vkUrez
	4EQs+25RDOsHWPhZ05fVP5NFVx/KOa5mK1aFDzxbryR9etyKyDjntMpgKztOcpOR4WRG+O2x27Y
	TvQUiqZvwyOhqbdwyYCyNlzgI4wAJHrodcR+rpWbmppY74wL2x25tJQDQR2Zxn/HCHgKYUWwM8t
	jfOmKk2HpH3/uw0ju7
X-Google-Smtp-Source: AGHT+IENddzYRW8gA65vAtMzzayUBi5ksUaLTeP4ttAqGuu83YSfPNiwCFuxY79wPBMtXp6SFV5pqA==
X-Received: by 2002:a05:6e02:148f:b0:433:70b6:e500 with SMTP id e9e14a558f8ab-435dd09d3efmr62400195ab.18.1764190495089;
        Wed, 26 Nov 2025 12:54:55 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90db927sm88564495ab.27.2025.11.26.12.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 12:54:54 -0800 (PST)
Message-ID: <8846b174-66df-4a0e-ac83-7a9f86df2bea@kernel.dk>
Date: Wed, 26 Nov 2025 13:54:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 4/4] man/io_uring_prep_getsockname.3: Add man
 page
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
References: <20251125212715.2679630-1-krisman@suse.de>
 <20251125212715.2679630-5-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251125212715.2679630-5-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> ---
>  man/io_uring_prep_getsockname.3 | 76 +++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 man/io_uring_prep_getsockname.3
> 
> diff --git a/man/io_uring_prep_getsockname.3 b/man/io_uring_prep_getsockname.3
> new file mode 100644
> index 00000000..71e65f1d
> --- /dev/null
> +++ b/man/io_uring_prep_getsockname.3
> @@ -0,0 +1,76 @@
> +.\" Copyright (C) 2024 SUSE LLC.
> +.\"
> +.\" SPDX-License-Identifier: LGPL-2.0-or-later
> +.\"
> +.TH io_uring_prep_getsockname 3 "Oct 23, 2025" "liburing-2.11" "liburing Manual"

Should be 2.13 at this point, as that will be the next release.

> +.SH NAME
> +io_uring_prep_getsockname \- prepare a getsockname or getpeername request
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/socket.h>
> +.B #include <liburing.h>
> +.PP
> +.BI "void io_uring_prep_getsockname(struct io_uring_sqe *" sqe ","
> +.BI "                          int " sockfd ","
> +.BI "                          struct sockaddr *" sockaddr ","
> +.BI "                          socklen_t *" sockaddr_len ","
> +.BI "                          int " peer ");"

Line up the arguments with the first one.

> +.fi
> +.SH DESCRIPTION
> +The
> +.BR io_uring_prep_getsockname (3)
> +function prepares a getsockname/getpeername request.
> +The submission queue entry
> +.I sqe
> +is setup to fetch the locally bound address or peer address of the socket
> +file descriptor pointed by
> +.IR sockfd.

Space after sockfd and before '.'.

> +The parameter
> +.IR sockaddr
> +points to a region of size
> +.IR sockaddr_len
> +where the output is written.
> +.IR sockaddr_len
> +is modified by the kernel to indicate how many bytes were written.
> +The output address is the locally bound address if
> +.IR peer
> +is set to 0

Probably

is set to
.B 0
or the peer address if

> +or the peer address if
> +.IR peer
> +is set to 1.
> +
> +This function prepares an async
> +.BR getsockname (2)
> +or
> +.BR getpeername (2)
> +request. See those man pages for details.
> +
> +.SH RETURN VALUE
> +None
> +.SH ERRORS
> +The CQE
> +.I res
> +field will contain the result of the operation. See the related man page for
> +details on possible values. Note that where synchronous system calls will return
> +.B -1
> +on failure and set
> +.I errno
> +to the actual error value, io_uring never uses
> +.IR errno .
> +Instead it returns the negated
> +.I errno
> +directly in the CQE
> +.I res
> +field.
> +.BR
> +Differently from the equivalent system calls, if the user attempts to
> +use this operation on a non-socket file descriptor, the CQE error result
> +is
> +.IR ENOTSUP
> +instead of
> +.IR ENOSOCK.

cqe->res is always negative, so it'd be -ENOTSUP.

Other than these nits, looks good! Thanks for writing it.

-- 
Jens Axboe

