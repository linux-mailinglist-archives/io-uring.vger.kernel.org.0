Return-Path: <io-uring+bounces-3661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEFDF99D1E1
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DBC285A50
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 15:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0301CC893;
	Mon, 14 Oct 2024 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tU33M0Ra"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99051AD9C3
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 15:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919038; cv=none; b=qcor89IHd/kmKwuRSFOTXGeLSc4viURChI3IqmxCpX40GcSZTnhSqWHOrsXI1twHb7sZM9fE9ogoexCVILWVAclSookC93JEcw/XgycowFzHYXRUCYOkeduIp8xY+6rPsiogyM5mDIwmBZsa5JwRSwEn8EeL3KMOCRwilLhGcdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919038; c=relaxed/simple;
	bh=qZjZkJC8TvuLicHKx/g9ilkvy1AyBGceBizbkfzAbO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ji9paFJccTAKSyYr5/bJd3eM/q0vyhppFrRDRhyiaQVaT6zJxRfcNxs05V+Y0rj/isMlFuzrOD+aEysXxInRS1Usa5ktFjJxMpvhTvkRQMU3Uoi1Rass9RILHUeSUIX/J3XY+Y7pgefRKUv/m1JHcRifJPJSYvGJ1EtWQF4hRSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tU33M0Ra; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3bd664ebaso5046185ab.2
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 08:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728919035; x=1729523835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1f6tWVkVeZpuD6W55vu43bMEka9Bgfs26D5vnHOkHNk=;
        b=tU33M0Rahq/DFoQ8n35d3IL/6Y99T6eYx0Bf27IqHZR6BWtkWyd7NS6+uul80JaDjj
         02QjP/izz1S7iySm0Ypi6rUb5wvjNgVnWchI7Qq43wGXyAE+5Qxc16YawmaQadlPYqTD
         eZaRPeKtuXEmSySL3MoCYVQ90xm0xhCqQB1cio6a4QyueTGnKkBIIjdo2rsLq1nLeRJB
         OwCUY/PF75NuK3niHI9riTJ2wpqk3QNqje9RMBQEDWl41T4pNsaXqx1b1ALFseJZvo+b
         D7V2pwcs3MRBxawWOYAmmK0IxvML24ztVlrhmNGHIU9WpexAc4UowY5a1OmW56p9bBuQ
         UqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728919035; x=1729523835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1f6tWVkVeZpuD6W55vu43bMEka9Bgfs26D5vnHOkHNk=;
        b=uhfAFGE3xEysJvr6lyoiIaKNd9XAcoolcqu0qZkQ76lfDumqi5SHhJbgy4q4t12dFj
         2mVnhCg5uahLzheXJ2TNoGZa0suV5BY/D4sIXa+2NGNZuct0Dpm6LK2WfB5AzKkTmQAu
         BL/oJc9bWPS/BlowuS3r/7j2PPAYWO5XKJsCAz4Kzs8I6dybect5Cul4DO514xP+YulV
         zcsULbo/8e2ePUk2VwceosH6R7Wx62/QRH9GdtuHdydSfwMe/j3h2RXoGzZl6i0FVb6J
         LiOxgUnSM7hfo2izegjftfXZ+gNFr+B/VsrHrLeH8LHbgaDDIf46gcgQCRrVnCXM2Ji1
         2lOg==
X-Forwarded-Encrypted: i=1; AJvYcCXGgVlsEDbG5IMSgswyJv+MqSIoeZs1XLijH9sDJsdHCGeEX+ohbf3rLmkOmrP/sQOstlUhhXvgWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEzqdfI6nLyUBazpc00L4hokr+Fr+kZgCDD5I9kVtWwcnWhDXq
	v864wSjkeachx5A7U7t5wdsxdQzJ83HhDg1e+fkFDMUFn8Lwi+gyi1L9WHFIqIA=
X-Google-Smtp-Source: AGHT+IFxU+6iK4vm/BjVbsnxaxXdxk8G3H1g9vd9g5QB1bRM6/lXrHOk9SFlCvgoUX4Lt8bWzNOpnA==
X-Received: by 2002:a05:6e02:2192:b0:3a0:7687:8c2d with SMTP id e9e14a558f8ab-3a3b6019b61mr78076955ab.26.1728919034952;
        Mon, 14 Oct 2024 08:17:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afde8cb4sm56162565ab.76.2024.10.14.08.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 08:17:14 -0700 (PDT)
Message-ID: <a9fcd235-18b5-4b17-bd4f-75dc2d228e17@kernel.dk>
Date: Mon, 14 Oct 2024 09:17:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
To: Ming Lei <ming.lei@redhat.com>,
 Hamza Mahfooz <someguy@effective-light.com>, Christoph Hellwig <hch@lst.de>,
 Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 linux-raid@vger.kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <ZwxzdWmYcBK27mUs@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZwxzdWmYcBK27mUs@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/24 7:27 PM, Ming Lei wrote:
> Hello Guys,
> 
> I got more and more reports on DMA debug warning "cacheline tracking EEXIST,
> overlapping mappings aren't supported" in storage related tests:

This is easily triggerable with dio and reusing a buffer. But it looks
like this will only trigger if CONFIG_DMA_API_DEBUG is set, so should
not be a prod issue? If so, I'd say that debug printk should be killed.

Maybe turn it into a pr_warn_once() or something?

-- 
Jens Axboe


