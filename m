Return-Path: <io-uring+bounces-814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 738CF86E67D
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 17:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1693A28ADF8
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 16:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8E3C8D2;
	Fri,  1 Mar 2024 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CnHPZZ4P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45EC46A4
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312185; cv=none; b=Sg/ciTWzj16g3RcKI1EnWMedmP7V+kO5+8sKjwfg8TKGaaqYA+SzWRfMC8oID5p5iuIN1rlBRAWGga9HZ67osShRje1BBUnhGV0oNb2+jrT1RacQOvB16coXcUMpTQ89W0bXwFnmkVQNsBtkB5KR114Ja5tUYjXNhmWkQPOj1ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312185; c=relaxed/simple;
	bh=/cFMkXs1YLuLcWkvfAIme/Dxe5G3rypX0cn7ux3WWHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TuzGVdUV0b/mn+rjVp7en2U++Q597xDGYogbKEUwQIBULSVwH3m/MrmyyHbq3MnbieI0HDUIq/GoZkfRTPPK8/91eD4sYj2Xdsy4TYXHD8vD3laYlauoK1vbnPDXlvVDo9QvBzGjEHjDJQLwSzjiO9VIMM+zYJkN1K/Xs7d2kNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CnHPZZ4P; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33e2268ed96so324377f8f.3
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 08:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709312182; x=1709916982; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3VqmontYstpREaYRLuFgnoF0ld9uXpBQEwscACOSmI=;
        b=CnHPZZ4P3NldBSArxCs6//bWsWyy5eLw5uTEyPHwG3nZUFdVT8yBGw4D1/Jv6jFq6R
         3W0JL2D1cPLDlSpSwNsSL1f15VWA2DXcjzHEgX258hV6J5CC2MceoAhPzEV4kzHvCQ5c
         GavLKzD8MfzVhilAdVmgq2KMZlfalDRNX4c5yAnB7jJ4Y+cNBMZ5TnOCKuXIBF0u9G2/
         r8h1rNrTgIGFc1S8Kh3IE8lV4fIvZgTxdlbhaMM02B3Y7+Tkl3noGaDYbNBMMJNqIlRh
         fkUJYhPnDNIQXZTiJjOoAPdVCFCyeldxiznoJ/LGYGpEO7dN+8amUaF8OYM0bIrztmjG
         CbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709312182; x=1709916982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3VqmontYstpREaYRLuFgnoF0ld9uXpBQEwscACOSmI=;
        b=rBOuJvxXvDI4WysyBhYu4fLOA6dTLI0I8BSoTmM1P9qbpzDiX12+kh6CHzRAOS2kjq
         0SWEoWN5wR9ZWbtcc72Wk6z7/uvfFic0EwS7W8YheO4ivhpgW2bz6ZQIZHi3zZnhQUXf
         kcT2vaQ3wbgxhgoOvIcdsrW2R5YOvM3ZaF8ohKuAi+VbcghczZg04407XOetrhyvGUFB
         qOtEIBSTTcyErrAEu9vepjZpYd9EjLpRLJLEMGKw7YFE5vp86/eoeqV50xWbD2dK7bY7
         A6jLZ5TY4k5RcZEFtujJcmKRHfqGrl1yDHx41fPN8wZHlf/Qlz+odnTpy17n0W2AEgKP
         Iy7g==
X-Forwarded-Encrypted: i=1; AJvYcCXltt/Zvw/VdZeg8w3HMMSrMHlgUxaTm7vKZEB4qNJRIn7ks5XjGEy7o/1n9p9rsK22UmRs4x3MF3uTL24FVjHmLAZVnXstDqc=
X-Gm-Message-State: AOJu0Yx5xk4eYdeOX6VAZUUUL7E7ZjH/tFZMAhI9m22O5HR7QheOElv/
	ZhPhlKuwVM5VGsCmirY+rK3LCTSQi3AOWtYzyMTQjWRJQSZR2DiPQRD6LhTZ8SI=
X-Google-Smtp-Source: AGHT+IGgN8ojolxlaeOgWQJDi81cvaJNFC52G5ZvMJnSJLlTJJuzLntA1bBA/gTcgOaSnW1MlBUEnQ==
X-Received: by 2002:adf:e9c1:0:b0:33d:3fed:39f3 with SMTP id l1-20020adfe9c1000000b0033d3fed39f3mr1816627wrn.52.1709312181785;
        Fri, 01 Mar 2024 08:56:21 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id u14-20020a056000038e00b0033e10b7a1bdsm4823816wrf.32.2024.03.01.08.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 08:56:21 -0800 (PST)
Date: Fri, 1 Mar 2024 19:56:12 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/net: remove unnecessary check
Message-ID: <da610465-d1ee-42b2-9f8d-099ed3c39e51@moroto.mountain>
References: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
 <3d17a814-2300-4902-8b2c-2a73c0e9bfc4@moroto.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d17a814-2300-4902-8b2c-2a73c0e9bfc4@moroto.mountain>

On Fri, Mar 01, 2024 at 06:29:52PM +0300, Dan Carpenter wrote:
> "namelen" is type size_t so it can't be negative.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---

Jens applied Muhammad's patch so this part isn't required any more (and
would introduce a bug if it were).

regards,
dan carpenter


