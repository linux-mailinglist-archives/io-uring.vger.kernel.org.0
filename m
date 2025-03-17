Return-Path: <io-uring+bounces-7090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74604A651F0
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 14:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A94E3A6D5F
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 13:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC222405E0;
	Mon, 17 Mar 2025 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="fKVBbdN3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7871723F397
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219832; cv=none; b=i5TN6WvEBBbBK15oS4DH5U/+81m0Mfktesl2sKCeuKmmO1jvlP22E8I6LzB3aox8x3Ddd2dLwKpKtJc9UxhU1DR1eK2lAd2wSe0FN9b78qlgmfRnIi4a466fHEw+iuKZPXb2jjoWDfijv5ABR0H5QlOpAtqjUkEY11hOLzpktNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219832; c=relaxed/simple;
	bh=0/JBhcmr6RbYakMo+6DE8lgQPZhpL+1uoSnywA7R3cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufWZoYtjo4OKmqM2Y55CywYv7bjhrADWpIBIZ1fTzk1m2EJ6pPEq2S0AiC5+EjQuflkKc5K1jJjc3ZZkvoEud/Rbazcs/wN47y6WvNhJd7JIYhzVajiacOFYwKfZrOSA/uDR1UwnjjMLWyhENTzwy8lpF/xnN2vL887Gn6OJPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=fKVBbdN3; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-85da539030eso148763839f.1
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 06:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742219828; x=1742824628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SfYp7nbKw8yT4ZK7FK7ta60vIOnSkRlh8C+eZnMPUg=;
        b=fKVBbdN3cuvigvxP1zYXuYCTGnjRCfwERQAlbtT98ZJ5J6PyZREdmEyxSpEHH8Dax8
         X/8gP/b6PUUEwKERr4juhINSNzHD769FfL2VkgbuF7rtNRAkyUdYk+hA8uE5EXEuZFQB
         +AUz2C4EADEiv9NUAJQusO638Qbc1adxh0BHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742219828; x=1742824628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SfYp7nbKw8yT4ZK7FK7ta60vIOnSkRlh8C+eZnMPUg=;
        b=eG3hk3+HGz11kzFu7pBBxOJMhGnUlzIh/wN9kUvWvc/lMRDl0J7s2Hl5ZqbXeAjiL2
         KEZ6p9NDTbtkVb0lPna5h5ywdBf8RAnjJ79QST5czhJr5SmVJwI0wqrOMOCj+OuhhJ2y
         9y5107LEy4ffnTcsa/PYoN24mMyPeTxQX6oRC7YtWATDUirt15J/degj8jL/X2IfATKR
         BFYc7x3hxiWf8Poka/3Ci36Z47EoT/IeplzDDfBU+xkPeyp1U+zaQouUaZGeB1avS9SW
         bjEOzpZD5A5CjtVvoyFHHrnBUgEqJLgd8Tq2l9X6j/B3pzVUOOCxENgJNLE4FyB0jRQ1
         0Y8g==
X-Forwarded-Encrypted: i=1; AJvYcCXPMZhLVbdDpnK1U/kWxbUV0V67NLMGPQm7CDNi6Mt32HqBZQimP9oo/dM3K/4ynuzEW5B4Y8W+8w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8FPeW/fnu5ewIN9KGg9GXLEK5qJHWAWM/XdOfVYVy5lAiamDc
	aNJGhlJyKbAoGBa74amPVm2hT38YXiihiGWuKDGFwkYVx3Vrh9NsjFHnaMylhZVm8UVvxhYrajp
	D
X-Gm-Gg: ASbGncs86g9pG1lu71C2HSu7Y7vWPyDvVqlzs8HeVCT3Dgf9Z0xoZQ1teabngnecJcZ
	/NSMWAPWcvY+pFgL0hWJ4VPn85HnKqz8FnaID+PsK1g3PaNHNYF5X/9xjAPY1IRkd5/q+2LQAGP
	YzSveNT0rrhGG65+6yVEBIJggYDq7i60OifTREmnKW6b3CKJx1WLA/IBMGtX4bM9fRo14fC3Lbi
	MgXdhlqlk3JV2kIr8AhpfQEJJA9nZHNu68XkqvfulCcX7xqQ86TL5sfd7NhQISn5EC7UeXabfLx
	lf/wgcV6nSKygXenSE6snfXovFQqo1O0D85GmjJ40fv0JAmXemmska9iptWwC0Itho8fGj/8Lqa
	T
X-Google-Smtp-Source: AGHT+IHVUTBLBxTZC8HdLXhH7rWvOJoPaV2M14f1jVdqw63OUcUgLVqKDEC+//Li+SKHHS24f1zgCQ==
X-Received: by 2002:a5e:df42:0:b0:85b:3ae9:da01 with SMTP id ca18e2360f4ac-85db85a4420mr1487523439f.4.1742219828514;
        Mon, 17 Mar 2025 06:57:08 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb30dsm2273057173.90.2025.03.17.06.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 06:57:08 -0700 (PDT)
Date: Mon, 17 Mar 2025 22:56:48 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Mark Harmstone <maharmstone@meta.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/3] introduce io_uring_cmd_import_fixed_vec
Message-ID: <Z9gqILpSLiHJXDGK@sidongui-MacBookPro.local>
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
 <3c8fbd0d-b361-4da5-86e5-9ee3b909382b@gmail.com>
 <785d1da7-cf19-4f7b-a356-853e35992f82@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <785d1da7-cf19-4f7b-a356-853e35992f82@meta.com>

On Mon, Mar 17, 2025 at 10:32:02AM +0000, Mark Harmstone wrote:
> On 16/3/25 07:22, Pavel Begunkov wrote:
> > > 
> > On 3/15/25 17:23, Sidong Yang wrote:
> >> This patche series introduce io_uring_cmd_import_vec. With this function,
> >> Multiple fixed buffer could be used in uring cmd. It's vectored version
> >> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> >> for new api for encoded read/write in btrfs by using uring cmd.
> >>
> >> There was approximately 10 percent of performance improvements through 
> >> benchmark.
> >> The benchmark code is in
> >> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> >> ./main -l
> >> Elapsed time: 0.598997 seconds
> >> ./main -l -f
> >> Elapsed time: 0.540332 seconds
> > 
> > It's probably precise, but it's usually hard to judge about
> > performance from such short runs. Mark, do we have some benchmark
> > for the io_uring cmd?
> 
> Unfortunately not. My plan was to plug it in to btrfs-receive and to use 
> that as a benchmark, but it turned out that the limiting factor there 
> was the dentry locking.
> 
> Sidong, Pavel is right - your figures would be more useful if you ran it 
> 1,000 times or so.

Yes, it would be useful for large number of repetitions.

Thanks,
Sidong

> 
> Mark

