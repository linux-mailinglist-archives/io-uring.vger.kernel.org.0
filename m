Return-Path: <io-uring+bounces-7261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0579EA7310A
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 12:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B421D3BAB37
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 11:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA89D13C682;
	Thu, 27 Mar 2025 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yVngxeV8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142B91F94A
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743076133; cv=none; b=rx87XIQowykocgi8MtKbE+zeaV877GfM29zaLFPyobh+QwRkxOeV7j9RQ1E4LAr8J+IlGmPGSY313KjbHJvPDEJWVmegSSSYNAZLeDwLp9WZGC37rHBak+AlkXiHBgiJFpv36qdMem/F/LraNbcQA2x1OQyZVzHxgIon+Wkm3eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743076133; c=relaxed/simple;
	bh=iEExlA8IoiRjMbovyzSLU6vbyrJLYW+bd9khXhaNEZo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FZfnpRJdm9Ruh1KHbTAWzUlspuiePJ+gLgoM4gHGL0jqB6g14MD8eW6r6UgIvR6+FHqmke/81cnGpsqncARTn/Wxpcp6XXbfVYEdeEqRuMQdQQJjPJusojrgPFxNq1qjSpicYpLMM6pAS4MX2t7Bj4XrZ1bQvc3yhG09HEg1hzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yVngxeV8; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6e8fce04655so7624976d6.3
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 04:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743076131; x=1743680931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LxzMIuNE2ovRgx3pA/yxyTsFHV56Kf8/VRvSlUKKO4=;
        b=yVngxeV8f+wtD767dbQTPU7HEiBwiNSHF43UV1DhZE+9U/+aaObFCEYuJLHcw+TZjy
         BCwlmEeBn6uOTqrURvVXK63fas/E716KM5e96BqdRdtcsfBg+3NFW43Q/yjlOEVtHT23
         Mru6xsInTfQlTrLyH9V8Vt2mIn4YakoEFaj4hib2AwubTviluslbZNOk8poBa7pLoohX
         3B0sy+k+yoQo6WzZokT+14/V1NgrfNvynT78Ucqs4WxFokjO0f5z8oGouTJ162LK0W2+
         Diualyt+7lYMpb6UaQhzSOz5W9VmUbDZ4TCoeVULF7YwRIEJpIWz7kaa/n1UoaNDi/ah
         m3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743076131; x=1743680931;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/LxzMIuNE2ovRgx3pA/yxyTsFHV56Kf8/VRvSlUKKO4=;
        b=bU6PrcDBNlWCIjsiEBM7IieISEwHXw4+DpXnaWjLwbIp5Zl3SI+NcjZIKFlTa5NhNL
         mPPa3SEG7OamZhcCqXDfOv4L+F3kPNptVTPMK5UYJyI83jnIKWcflg9A+ab7WOSXmbvh
         gF0KZkvE8P0dApS2BhePtA+8gAB+vBomHFqI5YMuRO5Rgdyj9SX+1T/xX7SrL8qC5Qgn
         KeMa7D0a7bvhttHPMl9Wel2KTteCuDVRKHJqMBv/Uswf8EdZRgi/EWZbubuk2CRu2ET8
         Z0th9DvGQyFyOwpa8bhatHUXBRIXdXTtUljfEjXTJ8W0apauOcBpAsCvw3f0GXwy5tGh
         B/3w==
X-Gm-Message-State: AOJu0YxBNwgjueaQX68SzwddsGtkLV9eZsZcqEIKLns4pl2n5PzL5Zws
	CL5Bfu4DrpV+wbrNLbBr0+LBka1SeBNV/OVY3K9ZKotEYM19VErRVxWxbodQ/QYe8qy+KxzosBT
	3jA8=
X-Gm-Gg: ASbGncv2Wr8PAlEnC0/1/gtJGS8TSUoYOaQc1HiUyOZ3BT0RF9QaB5lAJjcZaDyGyjh
	17BguGvmDDlyhqFXe8AJ9sJIH+ptm4qKMKImA7AyHv3hB4FWh8cSfHziHL/tyL7F7A7CLc3j6Iv
	FGr+DiPHwxv9rOKoqWffidv7qfFMLJKsbo/erTYw8v3gmdUo8srvs2Tv4kJkehVlM5ANmSEZlKe
	u6whG6V/K+xDeFP9Pzh/bxhv8iXwWX3jkJ+ehiVcDHVo9ssH+HdTEmn+98wp5xMASWRPoWAJc8e
	yxxXUUGqhA/wwwUzQOfgmb4POI4I95RIxTv2
X-Google-Smtp-Source: AGHT+IH1SvMlN+GlmF95zXLQr27WIeEZes04BTIuIwbUAvUXk1ezKPAXEY45nNDHm7BdWiFeN5haVg==
X-Received: by 2002:a05:6214:2585:b0:6d8:8a8f:75b0 with SMTP id 6a1803df08f44-6ed238a87b0mr47407626d6.14.1743076130294;
        Thu, 27 Mar 2025 04:48:50 -0700 (PDT)
Received: from [127.0.0.1] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef0ed72sm79136926d6.18.2025.03.27.04.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 04:48:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8b611dbb54d1cd47a88681f5d38c84d0c02bc563.1743067183.git.asml.silence@gmail.com>
References: <8b611dbb54d1cd47a88681f5d38c84d0c02bc563.1743067183.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring/net: fix io_req_post_cqe abuse by send
 bundle
Message-Id: <174307612952.1380678.428097978851703746.b4-ty@kernel.dk>
Date: Thu, 27 Mar 2025 05:48:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 27 Mar 2025 09:57:27 +0000, Pavel Begunkov wrote:
> [  114.987980][ T5313] WARNING: CPU: 6 PID: 5313 at io_uring/io_uring.c:872 io_req_post_cqe+0x12e/0x4f0
> [  114.991597][ T5313] RIP: 0010:io_req_post_cqe+0x12e/0x4f0
> [  115.001880][ T5313] Call Trace:
> [  115.002222][ T5313]  <TASK>
> [  115.007813][ T5313]  io_send+0x4fe/0x10f0
> [  115.009317][ T5313]  io_issue_sqe+0x1a6/0x1740
> [  115.012094][ T5313]  io_wq_submit_work+0x38b/0xed0
> [  115.013223][ T5313]  io_worker_handle_work+0x62a/0x1600
> [  115.013876][ T5313]  io_wq_worker+0x34f/0xdf0
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix io_req_post_cqe abuse by send bundle
      commit: 6889ae1b4df1579bcdffef023e2ea9a982565dff

Best regards,
-- 
Jens Axboe




