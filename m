Return-Path: <io-uring+bounces-900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8278F879BB0
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 19:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B41D21C2306B
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 18:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6971428E9;
	Tue, 12 Mar 2024 18:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="SSss0uhJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B7C14535E;
	Tue, 12 Mar 2024 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710268688; cv=none; b=SOkFnTuMHnz82BJD3zIlelwbbXKmIUVVRn+XX4x/lk0q9GGh2pQqPOrQVoUesUbjeZEL3aT+mif6KjattlJhyurLEOkRnHQ0SqynStfPkXeD3XEIuSnkYrZm0aF76tjeQ0VeUq82sFk3UiamS7A+R09nIj5XURf1Vb/wgqCrZ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710268688; c=relaxed/simple;
	bh=KBeNabMPyHZTzPFwHRuKA/oMBkMVrKwDeLe1Oa3s8AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgfzHNiVtbpQKd1Y5keIhOlr6SI6XIJEdWotQpW8YJC/fwsUTQ7D1/gdYsSXGqzfaJChUZahX+F19CV+hE/6Ge/nghVDJmQlpyaYdJhipS6qO3UWsM3Q+gOv0xJGJOOEAxI9IKbFd3CejGF8/SZTWRji8iq2gxuxl5mdpKLwnKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=SSss0uhJ; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost (unknown [10.10.165.10])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7F4AF40AC4FF;
	Tue, 12 Mar 2024 18:38:02 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7F4AF40AC4FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1710268682;
	bh=L9dzc+wGc4r7hud1ML6f1cQ5Otk2+AYhLY1+PNPRrw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSss0uhJu0QRrKAmX2o8P4uMjMC7LUrMbVuiWtXTum3vdp5J/D8y+s/nCVNJp1lZu
	 6lAaNOqkjRptT6ID+BJ/AJRE07D0DYW3JXv10cZxt30Z+qlsregCeFSToYnqbmMEh3
	 AxwNoxPWgp5ixLhYCrP8lF3Fgms59WvPHmdY3I8U=
Date: Tue, 12 Mar 2024 21:38:02 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>, 
	lvc-project@linuxtesting.org, Nikita Zhandarovich <n.zhandarovich@fintech.ru>, 
	Roman Belyaev <belyaevrd@yandex.ru>
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Message-ID: <a8c81d35-e6ac-420c-9ffa-24dd9e009e29-pchelkin@ispras.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
 <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
 <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
 <fb57be64-4da6-418b-9369-eae0db42a570@kernel.dk>
 <085beb85-d1a4-4cb0-969b-e0f895a95738@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <085beb85-d1a4-4cb0-969b-e0f895a95738@kernel.dk>

On 24/03/12 11:54AM, Jens Axboe wrote:
> On 3/12/24 9:21 AM, Jens Axboe wrote:
> > On 3/12/24 9:14 AM, Fedor Pchelkin wrote:
> >> On 24/03/12 08:34AM, Jens Axboe wrote:
> >>> On 3/12/24 8:23 AM, Fedor Pchelkin wrote:
> >>
> >> [...]
> >>
> >>>> I feel io_uring-SCM related code should be dropped entirely from the
> >>>> stable branches as the backports already differ greatly between versions
> >>>> and some parts are still kept, some have been dropped in a non-consistent
> >>>> order. Though this might contradict with stable kernel rules or be
> >>>> inappropriate for some other reason.
> >>>
> >>> Looks fine to me, and I agree, it makes much more sense to drop it all
> >>> from 5.10/5.15-stable as well to keep them in sync with upstream. And I
> >>> think this is fine for stable, dropping code is always a good thing.
> >>>
> >>
> >> Alright, got it. So that would require dropping it from all of the
> >> supported 5.4, 6.1, 6.6, 6.7, too.
> >>
> >> Would it be okay if I'll send this as a series?
> > 
> > Yeah I think so, keeping the code more in sync is always a good thing
> > when it comes to stable. Just make sure you mark the backport commits
> > with the appropriate upstream shas. Thanks!
> 
> I'll just do these backports myself, thanks for bringing it up.

Great, thanks!

--
Fedor

