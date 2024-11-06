Return-Path: <io-uring+bounces-4506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4A99BF142
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 16:10:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 609FAB21D7C
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752112036E5;
	Wed,  6 Nov 2024 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AUsmYz5g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F14202F7E
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730905783; cv=none; b=N0gEG7pvCzb07AAlzufb6Wmwxa01C399iWYCUrW5reQNsv2ldlIicmUF3IJD8dIzqqihqPkhyJzyBjD6MxLEqBjUUFEXSFAysEI/KnQ6P86qr7XBWtlJqr8eqVHPOcc9K+HGwewRk82108n5lJvVjrOIyaPAovAu/nRl3vFy92A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730905783; c=relaxed/simple;
	bh=sLdziH7VLKuYFs0BxDGmGSuJ1+KnmOcE0gdI9erRvD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HhBXTbxY/emBWCymPCiHTgrYpABnWnPtGcFS2c5oLftp2soprKfr5fXS2k5/vtelCzNrh8FMejtRj63NMwsWQ81+vxgu5FGAMSE1BRg7SkDoh9YYxagSHISZh+1IYvKw9HPlzxOeqcWckBWZu4CuXWd09kDs8cigMUERr6Qb+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AUsmYz5g; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ab00438acso31255339f.0
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 07:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730905780; x=1731510580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MB6dy9f4iloJbuf+L8j6Iwo+3Dp5qIO03mMuPA+UgZc=;
        b=AUsmYz5gQAs9DW0MPNXNMuPedhhJA+Tgq2l70ylu+riZiiNELpR+X3SMxRX7YEyJGm
         R9ViEDXttqxzDoTbq5IampEPSeRznGTvDq2/4bw5oei5P5ZPc0QJBeP9aKwdaTez99qx
         IvBgswLehbCV/GGSdju8jJ8r6KxfOU6HFZWikKyvdu7uiX4kj1y6KCHMuz6qe4zqnd0O
         83rEQxNy/zPHlFbbnJ/7tOJzRmTU1SfuIcL9pPnCNFjngQCgtIvsNZiLv5JaHjBg2Qtc
         hRc89vqqQk7sqtbIVjh5xW29Tl3n3GSVp68ad2PdzQchJdFNa+7I0K7p9YGuOn/Y9msy
         3iVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730905780; x=1731510580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MB6dy9f4iloJbuf+L8j6Iwo+3Dp5qIO03mMuPA+UgZc=;
        b=Sp/zqaPbE8gLy+sucqHAFUOs/5ICsoXOJpclsezfbW1PCleksVufKeS4mDMowBrLy+
         40Ls5C5/+FmJahCNAfbp73tBkmC8WIWwDC5aSjffX/6VkkPTE1tKhwL5iI80DZ7K5S8E
         JGlMGb7jcwBIAu/oPzDOqqvtdaYXf90MTW2qHWFboPhNYxQCWbIKGCq1HZ//wUanrDRv
         f+JS1TL4T4MMxXDQExxY/4HAoT/tEC58DfnMrzX6BAsnDdSRTVt6W3QEPToRp8YRJVXy
         2F8eoK+TPG4RnoqkHR0CYQi54SNSLZwJL7+yy3C4KSsvfLhEPAKUrOryDvO99gMymafg
         cz1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgIsflDP4y51wRyAxb2naQi6kQIG8uiHSn+4TX5hhRyC9RLePsnZTWkuos2X6dIALpWDdFB/Ulxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjBW88XoCjMP8xFyMu9pczpQDJE1+fiFP3SR5b9d4oSsIOgaM8
	qmsB1yDVaHI41e7QMqKboTWjuow8ICR+sWPxfwc49S1HrLaDzKh2W2jYpUhLJY4=
X-Google-Smtp-Source: AGHT+IHNF4fZbP1O0JrbqUXWdd6P+EXdiDJ2Zfsv66EJemIJ+3mmU2QqMdOQlqVLwq+s2qOziq8xpQ==
X-Received: by 2002:a6b:c40b:0:b0:835:3dfc:5ba5 with SMTP id ca18e2360f4ac-83de6ce8089mr239339539f.5.1730905779632;
        Wed, 06 Nov 2024 07:09:39 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de04887f94sm2878584173.31.2024.11.06.07.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 07:09:39 -0800 (PST)
Message-ID: <44abdb96-3210-45d2-b673-ec2eb309bac2@kernel.dk>
Date: Wed, 6 Nov 2024 08:09:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 3/7] io_uring: shrink io_mapped_buf
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-4-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241106122659.730712-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 5:26 AM, Ming Lei wrote:
> `struct io_mapped_buf` will be extended to cover kernel buffer which
> may be in fast IO path, and `struct io_mapped_buf` needs to be per-IO.
> 
> So shrink sizeof(struct io_mapped_buf) by the following ways:
> 
> - folio_shift is < 64, so 6bits are enough to hold it, the remained bits
>   can be used for the coming kernel buffer
> 
> - define `acct_pages` as 'unsigned int', which is big enough for
>   accounting pages in the buffer
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/rsrc.c | 2 ++
>  io_uring/rsrc.h | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 9b8827c72230..16f5abe03d10 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -685,6 +685,8 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
>  		return false;
>  
>  	data->folio_shift = folio_shift(folio);
> +	WARN_ON_ONCE(data->folio_shift >= 64);

Since folio_shift is 6 bits, how can that be try?

I think you'd want:

	WARN_ON_ONCE(folio_shift(folio) >= 64);

instead.

And agree that acct_pages doesn't need to be an unsigned long.

-- 
Jens Axboe

