Return-Path: <io-uring+bounces-809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 360B386E44C
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 16:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 824ACB2365F
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 15:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31BB6EB4E;
	Fri,  1 Mar 2024 15:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rf9/NDu0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178CB67E77
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306928; cv=none; b=cBxmrjMrskEtGAY5jeFQzitwRvrZ+h/DP/Ncnwhd2LYwjsBUUjvGrXNgTl6KbYh/OdTO8E20SlyV2Wb+4lE6mibyRZo7aBkIb/UJhDFnV4U8jvnE31mSZfHpkNZSV/6KamgYeIO+q0SVn7O4JKTzZ1IKr7CpuhjK3peS6GcvTVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306928; c=relaxed/simple;
	bh=V79S0AcqOHxYCtN03M3/RNtHhAC92r+ITa1cgvX9Hk0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tTMNJd2y+P404HEwfGmpWbqk3HGbkesECrWV1G/clsj5pE9o4c6aB5Exh/25lNripjnO+qYIQRljCuFUaV8jm3EH69ZI2HXfwiUqQgPsDZ1V0RvIZA/u+r+eY3YgLkh1GpR8TGBehcXw/b+Bnnmx1Omv/CoC3JEieok/RRxVHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rf9/NDu0; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51322d27fd2so2398242e87.2
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 07:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709306925; x=1709911725; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNTA2Vl3+hBLcp2L5qFBQu/x5GLlzDoP1qQamQQoMng=;
        b=Rf9/NDu0CxKM2foXY/U8BUASTwSof0VcJGZM//gJye9CZEfGm3LEK2vshzBmcqHAQG
         HI8VG+csv+XhDjX2hJmk5cy10sEoSo+M421we4HJbYtAAM7MGOBd5DEuJ6mAygMcYgQ3
         rzkYpIJM/3Fma+WuSkH30V1VMGCS2e+RIQeJYjYc61QpSmlzvvkKkj13nBBWl2EtVM1y
         E42Rah/IU8IIjlfPNyWjnx0u4wI36iAPYIB+tiTZ5a1qa3Kq20C+48zHdCgMkwXexnXQ
         6sUt4h4X3sN9MNyKsJk/wnMPCEmSxUKxpMXkENGDDwgVsCaLU2Gi2eisvZYfRqROtFyu
         JRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709306925; x=1709911725;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rNTA2Vl3+hBLcp2L5qFBQu/x5GLlzDoP1qQamQQoMng=;
        b=kbEVRKE1sFaiu3+dav4xIH37bLpC8yklhe7qjKvGSxfEf6ZZeNzSqVmGgppZtpNXYj
         qG9Eq/0zoE4/Opne7OeIcWs1nQ2iioeKlz3vtBCpBb1yAXhjcLAymcqWa/jxUdxmM9P7
         s+7thlv38pt0YZp2QuCHeDz0hH04V++iSvUZ0od2mG/piSvS+idmxrlyagB/RCfJvW1b
         5LrdS8yDwX0rQSB862djHlNIoyXNAwsua3Vv6g5gqZJUSBogW6ItnvARxr5oCxvbs/4q
         KrA2ZKhXfl52rKQffIfnLdgQ8BDT0/KeGqqUxksv8VWNkUcvH3kcP6aQUvQa5HfQ9Rer
         U86Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5NGIdmy27ESKn96SILAyhLnnGsw9GK6E/gzUu1poGDpTr+ncthxZBJq34OAjCFwPn/isl2RYXELWyr1tzCgHx8E1syZ3KexQ=
X-Gm-Message-State: AOJu0YygsmR3g8ly43ANgwR9neQazwvNl5V1Yf+ZiIsUi9bPYyb3xDYP
	/3VJzxcryWgvWZfc+TQqlHoaLO7bjnQ2ccsiRZyb/YbX8RCkriE4q5U/67NqQys=
X-Google-Smtp-Source: AGHT+IFHZBuwnnBlvXg14wNKZlr1xSKzvhRDYI2NQdhhnY/vnXCfkaEB3OLwoodCwFXee+uc2BdxYg==
X-Received: by 2002:a05:6512:311c:b0:512:ec53:5915 with SMTP id n28-20020a056512311c00b00512ec535915mr1334997lfb.15.1709306925008;
        Fri, 01 Mar 2024 07:28:45 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id p7-20020a05600c358700b00412b6fbb9b5sm7674242wmq.8.2024.03.01.07.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:28:44 -0800 (PST)
Date: Fri, 1 Mar 2024 18:28:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dylan Yudaken <dylany@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] io_uring/net: fix bug in io_recvmsg_mshot_prep()
Message-ID: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The casting is problematic and could introduce an integer underflow
issue.

Dan Carpenter (2):
  io_uring/net: fix overflow check in io_recvmsg_mshot_prep()
  io_uring/net: remove unnecesary check

 io_uring/net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.43.0


