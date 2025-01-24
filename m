Return-Path: <io-uring+bounces-6108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F6BA1AE21
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 02:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE8EF1888866
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 01:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96FF1EB3D;
	Fri, 24 Jan 2025 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="HP+Rd5bD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3652F3FD1
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 01:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737681331; cv=none; b=ZHYS/8nuDdHSEiEJBMI/+9Hdh07BnkZXC3ONCknBbsOsTz3A4gti8oc/vfrtsB9q1jydHP2ppympD7rMiqrA5TWJCj7vjZnI7jqSTjiEwI9QjhA9Oljd95q2DmJtM4AqrQIvDVwWzj5RrEZEf06gCL0W0vNp4Roa22ztSbl8cJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737681331; c=relaxed/simple;
	bh=iQLuJ+sh2K7XB8QPhptW2+F6gW765qZUSi8/grK128M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxtxIPmzZh/IwTBn2ehZ8W0nkuqujz8O/LhJ+Olg9r9HQ++8QBCxK5P9N4UvZmYgwpIM0XloFIuMtcPkk7c/eLiC5BgvIdpMU25xTtkFiKGDj9pJzqUG/qjJQFzEzfy2N0QCSYmyojWRZ0h2oTVyo3y2aZ31kSr438HATIGdwhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=HP+Rd5bD; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216728b1836so25504615ad.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 17:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737681329; x=1738286129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Av/+0MM92BL1s2WX1aeUOKVcbbZyC2hLnYOlQFA2af4=;
        b=HP+Rd5bD8ApXqffJ5cSvR1bC4/YGzA8OIPEQyGevzAZQ7UAQfKjlvWgH7JNX2TowRG
         fHwV5erUmQrialyO25HPr3uyg5mSb3BpL1bmzafTAIZkT/vieC14cLB70J9h5If7+i2d
         gRzss9XCIleyv6Mg6QXZT1B25yZi5Zui3gDviizYYP3SaeCvI3k64HjTAZ3oLgwHEVWK
         nwVsTa/0qgwC4b2by9dMlvmNbqkXUj2wdKws07VpuaqGZHx2wTOzmyHHVJheUJeGIqkf
         SVg/9yEkZLj+M3J7FfTijVZzD6Xh+mFURAB7Lm5QqzwNyyp+kt8xaOlh31kdvLUUkDUU
         KlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737681329; x=1738286129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Av/+0MM92BL1s2WX1aeUOKVcbbZyC2hLnYOlQFA2af4=;
        b=a2JLV8MAMhywvJRI8U8g4y90oXYjqIWSc7ONtdHZEry7i1ODnHCV71qUOECj95fCRs
         GVmuPrQaQRgoiQHtCHKe1jcB/xkVc1Fo34xxcBHOG/wPOchz6baV21XvSWfsDhonW82B
         +M968Ka0atlw7IGWnAGxstIirYCpGe/IvTKjXZkmWFOEykeTHdAl66CO0/vqsX/VaaW/
         +iHYHqSui6U+f82oXvcJyKUauxQtBp0XGp23o1qs7vzr10orypyee+SGhurk86A8wptE
         fDuTg/DP63S6pzp5uvXtthwMmkdv5hdYVCmTTvzSsYzc4mBKtKOcU1cTZ5AbPOrtMB3G
         zoHQ==
X-Gm-Message-State: AOJu0YwZkrHDPX2wIqa20C8gaDaTRA6ixxHCuii6zDQwx9WQNp6jqcci
	jwYJ+1b08VzkTsuD1YD/Ppx+At1y4R/u2rzuN619LlIoAkFho9375UULCoXDCkI=
X-Gm-Gg: ASbGncvfkPZDdpNP1mLsm/jaHHRt2lTi4ojjZtfA8KoJ+6V0ZbV5bSPtjP4tNqwYA7e
	R1owRtekH0zfn10JLb5eHUL7pTJfL3+IfMwKzbhkaxgJljpgacL0f9yX4++2K3JBCu0krICTFb0
	kxKRQOv09QtMyzoqkeX4xmvz5hY52TpERAGKSwf1OZ3kRmX4fbJpblo3YbaLNA097g9m0YFbPa4
	WEv4RX69uw928Y0ZeD+2PK/3sbPZQ6Eh7ibVle3zYC21xSRnap107a49avCt9l61+y6NmW5hOez
	mQ5UBC+9GmoZ9nHNiX7i7Nmuws7g/7UHJlYT4Wk=
X-Google-Smtp-Source: AGHT+IErmGGgLYvm+UUdZgAvdJORBDWDngVSbbTxrA2u9CB+6KfulQcSs3GPyYNMXXRZI8Rqqxs70w==
X-Received: by 2002:a17:903:11c3:b0:216:1cf8:8b8 with SMTP id d9443c01a7336-21c3555a778mr385401965ad.27.1737681329382;
        Thu, 23 Jan 2025 17:15:29 -0800 (PST)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea5546sm5405045ad.98.2025.01.23.17.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 17:15:28 -0800 (PST)
Date: Fri, 24 Jan 2025 10:15:18 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io-uring: futex: cache io_futex_data than kfree
Message-ID: <Z5LppkEQ9tGdfwrX@sidongui-MacBookPro.local>
References: <20250123105008.212752-1-sidong.yang@furiosa.ai>
 <a366bb4b-dd8c-486e-91b5-46dad940e603@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a366bb4b-dd8c-486e-91b5-46dad940e603@kernel.dk>

On Thu, Jan 23, 2025 at 06:36:06AM -0700, Jens Axboe wrote:

Hi, Jens.
Thanks for review!

> On 1/23/25 3:50 AM, Sidong Yang wrote:
> > If futex_wait_setup() fails in io_futex_wait(), Old code just releases
> > io_futex_data. This patch tries to cache io_futex_data before kfree.
> 
> It's not that the patch is incorrect, but:
> 
> 1) This is an error path, surely we do not care about caching in
>    that case. If it's often hit, then the application would be buggy.
> 
> 2) If you're going to add an io_free_ifd() helper, then at least use it
>    for the normal case too that still open-codes it.

Agreed, So this patch could be make it buggy. You can drop this patch. I'll
find another task to work on. 

Thanks,
Sidong
> 
> -- 
> Jens Axboe
> 

