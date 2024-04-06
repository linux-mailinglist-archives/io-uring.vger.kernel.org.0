Return-Path: <io-uring+bounces-1425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0A689AA82
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 13:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89CD01F21B05
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 11:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3F924219;
	Sat,  6 Apr 2024 11:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Rrsz1hBG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27762C182;
	Sat,  6 Apr 2024 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712401942; cv=none; b=mc9NpyT9QhklRg4h8yR4d1Ylc5P+AZCRZzkU7Gd9vQSwmrTYR7a88mHlEN+nyl9TiniF3X0hQQQLEhN91OO3cY9VTovWxMfj1SVqbSDqfrgHrF3v9rqzD3T6aCjlKoH+BBDqUb2zU6l41DrbwHpjIvm6NH8B9f7scYdJM0DkYDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712401942; c=relaxed/simple;
	bh=/Na42PaebErLTeUeIhSCBAG010sjkEo4nu6zNSWufjo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=gM2st2gEK8thPn0c9hl1RfK8A+c7fq3ODiOUTlBP7M0L6nb9FyD1oyzy4yAenJ02ymotllXK1Gi9UNY3MB97amYNtsVc6Uosr2FO1gQNb/FA44P9jS0jplTBHGK75MlHg/z0TuuKUaqUbHl0IFEs4TOCevNzLOLhn3QzC6u9CJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Rrsz1hBG; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from mail.ispras.ru (unknown [83.149.199.84])
	by mail.ispras.ru (Postfix) with ESMTPSA id D3F2740762DC;
	Sat,  6 Apr 2024 11:12:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru D3F2740762DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1712401935;
	bh=6wci41eDzOFmYi6xp+siMj+Kcr1MZCDRbXEFul7wU0M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rrsz1hBGN6GVTvOyUZEqiDZDuxT3KigQLq8ra24Nv9F7SGP9jGQ8Sj/75ohJ2bg0T
	 AUS60CW5/zFjLtKEbGmCvkG82SGWh7MLvYOR6fokRnu6GcgxCm4lRYJYteG7/7Hk2X
	 xcJpCGtDXp07N9xgUexQmCqcEpWSOCaBIbxJKdoM=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 06 Apr 2024 14:12:15 +0300
From: Alexey Izbyshev <izbyshev@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Olivier Langlois
 <olivier@trillion01.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: Fix io_cqring_wait() not restoring sigmask on
 get_timespec64() failure
In-Reply-To: <b2e8a3e7-a181-42cd-8963-e407a0aa46c6@kernel.dk>
References: <20240405125551.237142-1-izbyshev@ispras.ru>
 <b2e8a3e7-a181-42cd-8963-e407a0aa46c6@kernel.dk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <cefb820ec1805169d18b3109c47408f5@ispras.ru>
X-Sender: izbyshev@ispras.ru
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2024-04-06 05:06, Jens Axboe wrote:
> On 4/5/24 6:55 AM, Alexey Izbyshev wrote:
>> This bug was introduced in commit 950e79dd7313 ("io_uring: minor
>> io_cqring_wait() optimization"), which was made in preparation for
>> adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
>> got reverted in cb3182167325 ("Revert "io_uring: Add support for
>> napi_busy_poll""), so simply undo the former as well.
> 
> Thanks - ironically I had to hand apply this one, as some of the
> commits you mention above are not in the base you used for the
> patch...

I used v6.8 as the base, and all three commits mentioned above are 
there. However, the patch indeed doesn't apply to the current tip 
because of post-v6.8 changes, sorry for that!

Thanks,
Alexey

