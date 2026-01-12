Return-Path: <io-uring+bounces-11595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADB3D13BB7
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 923123001631
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB1A34677D;
	Mon, 12 Jan 2026 15:39:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B782C11D5
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768232349; cv=none; b=SaWlyoJcO5Nl3ZT258hVt3siKMeXe8LHPujlQPakkAJiD6PuG2BKdvXmlhHXaqYlPO7wiAnNGhqwUjAHlwm3/jyA3ooJkD7ZcJnkT+ZETHx4i7cVM3eI9XrndqQy7/EPPZDOd7WFWzbfDddk1mVWx+eUfMgQMh50ZsDnfPhmsQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768232349; c=relaxed/simple;
	bh=nhfZBz2uUzQw8bGz6vn7tkIOT0apBdE9OtHa5XlVKZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXwkp5aU+OFAfovQYpctvddVdd/LhCgZW4hZHMOUBtzTRLkk/j2+pC/PaSttgGe8p4b07IKBHVxAjuZ4mpsmRB50O2++ReeT/NpVH1ODXJZHNKbjV/nb8hSy2v6NoiGNBfHEmexmRfVIBsuU/iYCbyX2axv2O1uE77qwQtEFk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c7660192b0so4664397a34.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:39:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768232347; x=1768837147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gigvZ2VrmSTNeJi/Fi4/IFMqUG9ritue2SpsEwq/4Ts=;
        b=mJT0m+UvHXlHSp0R0pW6ysI25djK3UddurW1RY+q56Waob3vYF9cLYamR7AM/4glMM
         jkk18O+1bBkkf2XFdJ8iGvG7uGB6RLd8JRhF5HY7pxdUShHf7siNzG1Q3A0auS46A2q7
         YslOInKeCb3V9Wic1ss3Op0l85htKxAfE8bLA66zLbcRRqvA5//PONJ3D01imaNuFENR
         G/0/U3/ZyvLI7kGjPaH90pRhno8O8cpdwfzoCUgBIQnqKS2jRYrV3jdya0MkaZwiVIT3
         gdh1R0wCtwvE1ZgUugoIm9E4Km8FaH/Q6gncSS+T8Pxlu4erXZQl6BPRTSkDpLnoyP5u
         z6Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWOQVrzMDnwKIoJsQH+jaCFIQA0ma8kYiO0J9V29ox8+0z2XnZwEOOh5vrn5mrRsdzbyhVhPhZSDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkHiennoTaNExROU6NWAw6CiO5PmZmps1QaWRAYjd0QXCijoem
	RrD4Avf7hHUwUZygMZPuRqPm7XqrJY1mkDyFGGIK2fuZSgwSleuDZO2h
X-Gm-Gg: AY/fxX7EE4qFIG95crA+C0u9wGG1LarSJtqOJD+I15VZJ+g5PSkHEmmaKz0CB7OA8d3
	D1vR73X7TH275d4Tt3KlhC+vqoOJEbTWzfSI1RxFu/kvIxG7oCRY74i4WuGQ300acbBYOzWoroH
	aR4eVCOUSgvQxksAumEKHtdRWi7qOh9GAUfAxLxpt3lVm/WpO+jRahkZxDsw+kemj7MCfE2GLPH
	1jMvIFvAPInQ+VEd+rtLlp+b+tGOkCuCLSda5QX5rfQQNTCbdy8EnjSxF+oZ8+exVfb4xp8fT9y
	gHAOwOlVa8TgtT6sFFLyOMHVFhBUOJI1vwpaMmZ0Y+Z2CzSgLDJUCQ4SfupW6wtLqSE8O3cxF6c
	O3ZjCL1vD/J6AfPMzLQVgovcO9Jb4ffd2x9h0M5+FRcwS5edEWmi0rtu3KZVOkpvQqT2uemfC+B
	nQVg==
X-Google-Smtp-Source: AGHT+IFiaFVr+ZtjIqYaCtL5selHM8tYoPDzPTvwhg8z5eUMamiz8AVxaGa+wBGiRH/AluQXVNDXwg==
X-Received: by 2002:a05:6830:349a:b0:7c7:dc9:40a1 with SMTP id 46e09a7af769-7ce508a651cmr9761816a34.4.1768232347280;
        Mon, 12 Jan 2026 07:39:07 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47820f06sm13243576a34.11.2026.01.12.07.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:39:06 -0800 (PST)
Date: Mon, 12 Jan 2026 07:39:04 -0800
From: Breno Leitao <leitao@debian.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: Trim out unused includes
Message-ID: <peuwrn3dswaomm4aqglv2injqbvkmmzw7ost6js5pxvb3ahlu6@23z6cqmrvj5e>
References: <20260105230932.3805619-1-krisman@suse.de>
 <wuha2oln3kdumecdsmpttykdq2p5bwp6db3cfoyqoy5ftnedmg@ftlotbrnrev7>
 <87ldi25254.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldi25254.fsf@mailhost.krisman.be>

On Mon, Jan 12, 2026 at 09:36:23AM -0500, Gabriel Krisman Bertazi wrote:
> Breno Leitao <leitao@debian.org> writes:
> 
> > Do you have a tool to detect those unused header? I am curious how is
> > the process to discover unused headers in .c files.
> 
> No.  I noticed one that was obviously wrong and that caused me to
> manually walk over the rest that looked suspicious.  I probably missed
> some in the process.

That is fair, I do the same for my code as well.

Thanks
--breno

