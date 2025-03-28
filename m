Return-Path: <io-uring+bounces-7282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1292BA7504D
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 19:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCA6C3B0F99
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 18:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6290214A0BC;
	Fri, 28 Mar 2025 18:22:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939F31D0F5A
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743186159; cv=none; b=fiFtjayJVIoUa4658JTeo36fZn7cOzil/6OzVUc+qM4dyEY1Y1asVcNpm6olux4HPJ5nuRcQ4hHEeP4K88fJiDtKMadDEjYcQ+IROXEp/xPUHCT2zmp6o1B9m69+B1UYSIRfglhyIqhii55lKjkD0JIzHdk3D4vNqu2OMAPxUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743186159; c=relaxed/simple;
	bh=umoLx2OefEvO+v+1BsDGyf245MaqTeb3ZUVREKp+49c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekntJx6gLA79p8/jY0HZ0/ifnS33tO4EoKY6JcvC+ozR5cXqJgO+In4UtvZgJVLRBf50CvVaaEQJ2AASYSS0rC9qNFPedJCPRkv8EW625LUSoXAxRM2hQl+D/8ej3kejTATcWfRCvGYgnAm3WNG14GpJBhV1e4u5Z1gaj9cT0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac3b12e8518so465892066b.0
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 11:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743186156; x=1743790956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnV3XnXz/dVnM2otTiGPnhvLO5rrNiJLIZkuT1Bp6wc=;
        b=nC2b28I6qWk0ShV+ial8Otsc3gcZI/SOfduk+IuJcBX3XbFy1b54b0ba1SDLXyN1rS
         XeRjVTzvSpkpW30wCodv2HGPWfshXEZvk4hO7+YRiO2dON5/pJlDQ0Y0cqpC/Mqh6Wkh
         /z90nG+RqvEqj9PDS+1Hudb2zSXaLt26pqm3Ecn5h4WS2etiXl9m79UbDSKCGtIdSlcX
         RL4pn8yBC2aCnVYwAMkRhPwoVukZ6mFCvTp2vlN/lUyig7HFCNw9be7hXB6RBQKbhDOg
         SeS6VtqHrcLooXbB47PnpI5YXXEbR7qXScl6G1ORsoU7U1gFaPElOFEMFA+b1zds0Iuw
         V5Sw==
X-Forwarded-Encrypted: i=1; AJvYcCVILCizXBhyxwYW3H7vU8tzbLoy4xXL5AXxG9j00xm316IymuILOXSJ5NQ22/cGsX0ljBUlc64eug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz99Vgs/YedaMqmsQ4UOgTlTzEyhf3pR4T01iXeCgVHMKrNCWWe
	R2UVWor8ZNLlzwrRo3ZdkpcpuMiDr39fYEL2FDRBx0IewkwrEWds
X-Gm-Gg: ASbGncuBXxp9wuTOxxe7voF8PJtDc70hrcxc7F0jY9SLOTpjknEW0bnaTTsoJ2p54by
	lhrDvklCH9hb1CUk7vz1NfpGSwu1sSbNA8EgZHChY0uPie1RsEqSYNH2iZmUgOgiEI3kd1GkCeO
	oGIlRvuKOzRv0KJngkVayXMHm+Jwn7E4CIHASYXIS3U4PhACxQ/nriUe8wjt11FBhd4cUGlk/Ok
	WNnxtOtJBKbUuY8hmXbXuJ1FDd39uuPQ06hGt0Jt28gJMNkeWMfUlSoFfFYTDeQhrF4Z7CACisj
	E0V6WXS5P6K0cuek/8K6Lj9v/q/2cfXGTwE=
X-Google-Smtp-Source: AGHT+IHcon+CSmKs6ruuei0mwvya87xEqdlDKzqxKV+OsZBfX+nyZLoCWipPGBCMp5ZZ3IQD7YZVVA==
X-Received: by 2002:a17:907:7285:b0:ac2:723a:670f with SMTP id a640c23a62f3a-ac738a4f70amr14782366b.24.1743186155633;
        Fri, 28 Mar 2025 11:22:35 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:8::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac719621718sm198986366b.102.2025.03.28.11.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 11:22:35 -0700 (PDT)
Date: Fri, 28 Mar 2025 11:22:33 -0700
From: Breno Leitao <leitao@debian.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
	io-uring <io-uring@vger.kernel.org>
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
Message-ID: <20250328-monumental-taupe-malamute-d1c54b@leitao>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
 <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
 <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
 <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>

Hello Pavel,

On Fri, Mar 28, 2025 at 05:21:06PM +0000, Pavel Begunkov wrote:
> On 3/28/25 17:18, Pavel Begunkov wrote:
> > On 3/28/25 16:34, Jens Axboe wrote:
> > > On 3/28/25 9:02 AM, Pavel Begunkov wrote:
> > > > On 3/28/25 14:30, Jens Axboe wrote:
> > > > > On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
> > I remember Breno looking at several different options.
> > 
> > Breno, can you remind me, why can't we convert ->getsockopt to
> > take a normal kernel ptr for length while passing a user ptr
> > for value as before?
> 
> Similar to this:
> 
> getsockopt_syscall(void __user *len_uptr) {
> 	int klen;
> 
> 	copy_from_user(&klen, len_uptr);
> 	->getsockopt(&klen);
> 	copy_to_user(len_uptr, &klen);
> }

We have a few limitations if I remember correct:

getsockopt() callback expects __user pointers:

	int             (*getsockopt)(struct socket *sock, int level,
			int optname, char __user *optval, int __user *optlen);


So, you cannot copy the memory content and call ->getsockopt() with
kernel memory.

A solution was to use sockptr, as done by setsockopt(), but, that was
discouraged.

Another important thing, some getsockopt() callback changes the pointer,
so, doing copy_to_user() directly in the getsocktopt callback, which
would break your approach above.

I understand that the next steps here are:

 1) Make getsockopt() operate with either userspace or kernel buffer.
    a) This buffer needs will be written and read on both side. I.e, you
    pass data in the buffer from userspace to kernel space, and kernel
    will overwrite that buffer in kernelspace.

    In other words, this is a read-write buffer (which is not something
    we have in iovec IIRC).

 2) Call the same callbacks from io_uring subsystem using kernel memory

 3) Regular syscalls will continue to user userspace memory.


