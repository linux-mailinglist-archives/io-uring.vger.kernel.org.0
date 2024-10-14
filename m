Return-Path: <io-uring+bounces-3644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A81A999BDE1
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 04:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA9581C219D1
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 02:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8803F9C5;
	Mon, 14 Oct 2024 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZ2mlaGi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1723B796
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 02:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728873880; cv=none; b=B9tc8HfNOLonlmnm/AL0KousGkwLCTPtw6T9RrcvPssFMWD5ngjjBjXZNCVSISjD4wRuDg3SyGvIkdqLYXWVLbhNhuJKWg/gryrj72lUuSulFhY7CbwN5HuTsHDrvsdlIvngS4LT45gIT8DUS3+oVGh4ADYn3c7M2hMSN7idJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728873880; c=relaxed/simple;
	bh=5M9BK6zPVytn4LljMUGQG2p6/qfsNceXvdK6vMwUwxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQNArOLw9NvwlOqLxxElluvj2rtTSNttPXfgxNVyUjShzn+I5G1IM3oPEMTKtody+KX9tVW+o/28XYSFE+eY7w625kUGe/4S4xdRLWXe9uyb91dvBjIo2673JLubDtCLNsLgPxfMbNu/Lo1FxGqqGYdSMoN0LaeGTdIlXpTGTK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZ2mlaGi; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71e4fa3ea7cso1196931b3a.0
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 19:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728873879; x=1729478679; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hPwVv90uGWt3h6k3tmqM1+CQEt54Hatv7w1zN0FJgbU=;
        b=JZ2mlaGipEi3DJl4m7UZ4GtE5MM0prYcxQnUtbcBCHb2GUUHV81ghdDDnJj3Lr+HFT
         fZCIFelrkcTtORgBhpgZ9YK+QhJ2PKyf/LUv0RDTg4lZEfwK09TRKMg3tl/DlvqmXFQu
         ft+rTXU197cykZBlaJ5e7YY+W5uip623Gz2Dxh49bFXRp9i5Yvasph8+HiFOH2cw0841
         PxbGBzf+rcpChQ+HNfxwRY1XYzi+9zua0aoJ8TkbVWlam+GX0sGKEiQvtmRfnoN6TnPD
         O0Gg9lzMQsIoAJPC/nlMfb64hVhOGBYpQf2/ywD7Z/HtjufbN7xk56+Pw3CngZu+WSLU
         0O+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728873879; x=1729478679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPwVv90uGWt3h6k3tmqM1+CQEt54Hatv7w1zN0FJgbU=;
        b=jHEwFr3fkGaHxFr4xp6qdG+6S232fgP4LSHBtAiTWGKRwoGpM9lyGeaii2TiT/zQaV
         zoUdALCsZAi9xKjZrtq8PV1HmazqNyItZ38symVnLyrXkUY8JxCvbwCX+cTlRUYZDGba
         OXeyGnlZ2kQFNhMMBaD8/AW7gb8H9Dkh02PuTjaFt+hLDy47NJTFBMmsFsenSoqn94Q7
         qpRc3Ko2MqvOPC74AZNnQY7uRVyZyI9Qy+IjrQcp4InciY42aBhMb6T4A5OpYb5b0X8c
         DqplniwV4WZhxpyj9cx/JkiYevtv7Tb//0JPTy4eraD/UKefRQM6vDDH8cHQkJFuAxNO
         ECPA==
X-Forwarded-Encrypted: i=1; AJvYcCWj2z9CQDaCN8OnYnqtorNfBQvpprkGGvgRwAKOvcGOyeJjn167XOYKDzWcCwO0koJttY1y58hyRw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2BUsrUPDyLxsXD+1tPybjajFjSOg+AZxq5fHKsCsQowyXulhP
	mYrIp2vlyPDdECQW6Ow0qi3sM8HvHGCtzI4HibE/0pTSO/kEH+Af
X-Google-Smtp-Source: AGHT+IHP5SpStNU76M/8/JYntWwbPBpZpsP28ec15xtGHkUzsKasla5nOllRrzOiWle7UuFB7asO/w==
X-Received: by 2002:aa7:8892:0:b0:71e:13ac:d835 with SMTP id d2e1a72fcca58-71e4c15182dmr11027206b3a.11.1728873878683;
        Sun, 13 Oct 2024 19:44:38 -0700 (PDT)
Received: from fedora ([2001:250:3c1e:503:ffff:ffff:ffaa:4903])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea706393d7sm2702168a12.51.2024.10.13.19.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 19:44:38 -0700 (PDT)
Date: Mon, 14 Oct 2024 10:44:33 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: Large CQE for fuse headers
Message-ID: <ZwyFke6PayyOznP_@fedora>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk>
 <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>

On Sun, Oct 13, 2024 at 11:20:53PM +0200, Bernd Schubert wrote:
> 
> 
> On 10/12/24 16:38, Jens Axboe wrote:
> > On 10/11/24 7:55 PM, Ming Lei wrote:
> >> On Fri, Oct 11, 2024 at 4:56?AM Bernd Schubert
> >> <bernd.schubert@fastmail.fm> wrote:
> >>>
> >>> Hello,
> >>>
> >>> as discussed during LPC, we would like to have large CQE sizes, at least
> >>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
> >>>
> >>> Pavel said that this should be ok, but it would be better to have the CQE
> >>> size as function argument.
> >>> Could you give me some hints how this should look like and especially how
> >>> we are going to communicate the CQE size to the kernel? I guess just adding
> >>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
> >>>
> >>> I'm basically through with other changes Miklos had been asking for and
> >>> moving fuse headers into the CQE is next.
> >>
> >> Big CQE may not be efficient,  there are copy from kernel to CQE and
> >> from CQE to userspace. And not flexible, it is one ring-wide property,
> >> if it is big,
> >> any CQE from this ring has to be big.
> > 
> > There isn't really a copy - the kernel fills it in, generally the
> > application itself, just in the kernel, and then the application can
> > read it on that side. It's the same memory, and it'll also generally be
> > cache hot when the applicatio reaps it. Unless a lot of time has passed,
> > obviously.
> > 
> > That said, yeah bigger sqe/cqe is less ideal than smaller ones,
> > obviously. Currently you can fit 4 normal cqes in a cache line, or a
> > single sqe. Making either of them bigger will obviously bloat that.
> > 
> >> If you are saying uring_cmd,  another way is to mapped one area for
> >> this purpose, the fuse driver can write fuse headers to this indexed
> >> mmap buffer, and userspace read it, which is just efficient, without
> >> io_uring core changes. ublk uses this way to fill IO request header.
> >> But it requires each command to have a unique tag.
> > 
> > That may indeed be a decent idea for this too. You don't even need fancy
> > tagging, you can just use the cqe index for your tag too, as it should
> > not be bigger than the the cq ring space. Then you can get away with
> > just using normal cqe sizes, and just have a shared region between the
> > two where data gets written by the uring_cmd completion, and the app can
> > access it directly from userspace.
> 
> Would be good if Miklos could chime in here, adding back mmap for headers
> wouldn't be difficult, but would add back more fuse-uring startup and
> tear-down code.
> 
> From performance point of view, I don't know anything about CPU cache
> prefetching, but shouldn't the cpu cache logic be able to easily prefetch 
> larger linear io-uring rings into 2nd/3rd level caches? And if if the
> fuse header is in a separated buffer, it can't auto prefetch that
> without additional instructions? I.e. how would the cpu cache logic
> auto know about these additional memory areas?

It also depends on how fuse user code consumes the big CQE payload, if
fuse header needs to keep in memory a bit long, you may have to copy it
somewhere for post-processing since io_uring(kernel) needs CQE to be
returned back asap.


Thanks,
Ming

