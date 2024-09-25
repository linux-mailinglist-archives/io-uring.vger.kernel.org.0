Return-Path: <io-uring+bounces-3298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A53D09852B9
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 08:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D542A1C22763
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 06:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF782AE6C;
	Wed, 25 Sep 2024 06:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TAtvOmmF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCAD14E2CD
	for <io-uring@vger.kernel.org>; Wed, 25 Sep 2024 06:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727244069; cv=none; b=KmkGu/jTmPt+nKclKPDZPXS9lBcH3xbeqDXNfukyWlTJ6G3hwerNv6AyAe1f6c5ZLQHecsp+IunCz9G99MXBAGLzaxZ980GAd3gTsxrJb9hbuQS+8Yd5QmpA+FtFWzlKd4zZ2nLvDt/zljtvgyEXzbiv4MtIctGVkluqGZiD6SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727244069; c=relaxed/simple;
	bh=LWwfTLGgsAaqaffWWmZAwmcBBki1MJezhqYcpwgfKE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2XXrEyFJwkM5YbB/PRYil4HO95hbIgSDBsny25+HdJUJbhFNH7VbbZ0tunXvr+UsJKgb8bogSFxAxkXbCYoa11S50eI0q36Mq5NmrOvbpO0Wv/qMbn5A+GJZ4XDxHiZNcVfNA+cA4mKlyKh7HXJiwtAC4pUi0jYCAgyuPJyGZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TAtvOmmF; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-374bd0da617so4487842f8f.3
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 23:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727244063; x=1727848863; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lDIjHlwQvn0FXZAsTPQMYoaFJJr2KcEtONsfmP4GO8E=;
        b=TAtvOmmFHnbtP6ZSFe2Q5/4kqZ7s8GZ1hwy0e9UVfwicUvweOxKC98fM4MEkyMfA/s
         OaYlgLoUyNJ2d0/IXmqCr5TVIQ7CL+hTxOziv0IbSQrFf2CCr1tdop6AXAAOhJElNkxI
         flYo2VwFcSHfP7tJDPkBOfmmqzUh/bkRKPKTYyPiiSUZEtaQqN78SmTxj83UrzoEJ9w6
         NMte2MOREbKqk8OkxVzkagyAa+1Uaw1vISH//o7J4RgtucqGedXO+LIAPIEgQrbKqU5+
         qatXvvAFQbRl6AXVWUq2NpH29lFW/bvHXljC+2P37th2tPkRwLLGKE18EritjuxYaG+S
         gRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727244063; x=1727848863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDIjHlwQvn0FXZAsTPQMYoaFJJr2KcEtONsfmP4GO8E=;
        b=u+eS62DdUt9bHoKAOzQ7QT4BWOgdvULNg1dNe+Vg3llMHQ/ZWinqyKZE5q5Ki1CQ5M
         KNNGWuMcxqgf3VdCH6eC3xQWWvhwZ7N07lLB2cJAQCySb7+lIZnjLeOVgS5IW92zPRt1
         0+uiepzpyXryEvvnwaeDmFZjuBcu2aFxopPxfYfNskcyDoJeQTVDz2iYb76qT4eahKLH
         BOSW7m7MyfwpOY27tpCVZDA0RPqLmHq69B9li7D085AyzV0rysWDQX4W+3bK8Bw+UXNo
         rArazv6jnj8TWbFqHzmrZL74FWEwZS7dsIatwnJBtVmagY4DU7AbTi+vt8AbHnr79UNU
         M7Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUcu2dLwUGGao7J294ETw3scTPUeKH3zZpjQtWmIxQlSy9rDvmYl1jttFaQxc48jjIW1zCS38fktw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZRcWpgj0KIhm3njShAv54e3NhGtkimjPFYfChl93NIygIX0XA
	aXuK2PflL8UuqJ3arcRiavSHUp9t1kE15bSe4QvoKBi12MgVBzfwH3BZF/8XjiktRSlSSMDi21e
	FMU0m1w==
X-Google-Smtp-Source: AGHT+IHZwuigQLC9/i5kjyUilLTmxOseUudei026p8CeWIB4nZ1LOhmcx8Tv0ht7FBFnyE9PwNTDmQ==
X-Received: by 2002:a5d:64e5:0:b0:371:8dcc:7f9e with SMTP id ffacd0b85a97d-37cc246b10amr1266080f8f.2.1727244063406;
        Tue, 24 Sep 2024 23:01:03 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc32b70fsm3037184f8f.117.2024.09.24.23.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 23:01:02 -0700 (PDT)
Message-ID: <d3d2c19d-d6a3-4876-87f0-d5709ee1e4b2@kernel.dk>
Date: Wed, 25 Sep 2024 00:01:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] struct filename, io_uring and audit troubles
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20240922004901.GA3413968@ZenIV> <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV> <20240924214046.GG3550746@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240924214046.GG3550746@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/24/24 3:40 PM, Al Viro wrote:
> On Mon, Sep 23, 2024 at 09:36:59PM +0100, Al Viro wrote:
> 
>> 	* go through the VFS side of things and make sure we have a consistent
>> set of helpers that would take struct filename * - *not* the ad-hoc mix we
>> have right now, when that's basically driven by io_uring borging them in
>> one by one - or duplicates them without bothering to share helpers.
>> E.g. mkdirat(2) does getname() and passes it to do_mkdirat(), which
>> consumes the sucker; so does mknodat(2), but do_mknodat() is static.  OTOH,
>> path_setxattr() does setxattr_copy(), then retry_estale loop with
>> user_path_at() + mnt_want_write() + do_setxattr() + mnt_drop_write() + path_put()
>> as a body, while on io_uring side we have retry_estale loop with filename_lookup() +
>> (io_uring helper that does mnt_want_write() + do_setxattr() + mnt_drop_write()) +
>> path_put().
>> 	Sure, that user_path_at() call is getname() + filename_lookup() + putname(),
>> so they are equivalent, but keeping that shite in sync is going to be trouble.
> 
> BTW, re mess around xattr:
> static int __io_getxattr_prep(struct io_kiocb *req,
>                               const struct io_uring_sqe *sqe)
> {
> ...
>         ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> 	ix->ctx.size = READ_ONCE(sqe->len);
> ...
>         ret = strncpy_from_user(ix->ctx.kname->name, name,
> 				sizeof(ix->ctx.kname->name));
> 
> }
> 
> int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
> {
> ...
>         ret = do_getxattr(file_mnt_idmap(req->file),
> 			req->file->f_path.dentry,
> 			&ix->ctx);
> ...
> }
> 
> ssize_t
> do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
>         struct xattr_ctx *ctx)
> {
> ...
>         if (error > 0) {
> 		if (ctx->size && copy_to_user(ctx->value, ctx->kvalue, error))
> ...
> }
> 
> and we have
> struct xattr_ctx {
>         /* Value of attribute */
> 	union {
> 		const void __user *cvalue;
> 		void __user *value;
> 	};
> 	...
> }
> 
> Undefined behaviour aside, there's something odd going on here:
> why do we bother with copy-in in ->prep() when we do copy-out in
> ->issue() anyway?  ->issue() does run with initiator's ->mm in use,
> right?
> 
> IOW, what's the io_uring policy on what gets copied in ->prep() vs.
> in ->issue()?

The normal policy is that anything that is read-only should remain
stable after ->prep() has been called, so that ->issue() can use it.
That means the application can keep it on-stack as long as it's valid
until io_uring_submit() returns. For structs/buffers that are copied to
after IO, those the application obviously need to keep around until they
see a completion for that request. So yes, for the xattr cases where the
struct is copied to at completion time, those do not need to be stable
after ->prep(), could be handled purely on the ->issue() side.

-- 
Jens Axboe

