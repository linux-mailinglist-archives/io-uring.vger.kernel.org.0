Return-Path: <io-uring+bounces-8533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5ACAEE5DB
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DDE11881646
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351D51BC099;
	Mon, 30 Jun 2025 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O8hIvEvC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856A1624E9
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751304695; cv=none; b=DbKqRgToRFShtWFlXGEzgDFu/YnFuO/1fZclfX4dJhbS+M2JQiJPd0+uTwrLeIE2ylYPVWZ06gmZp9mF6VhdSm0r6Ghy4lb2981NPCJnI1BhLXUzl+fmpNcPlUmmI/iuNGFTmkkyiU7Hip5A+j9w16mNe3rTCazirONGniXJ7co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751304695; c=relaxed/simple;
	bh=trrGYUGu+0arXHH+/Ox5FSMQ1/7zFu7kgTK9e0QE6PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KE/g+Nz1gjkdC+vN9DB8W5ro4XsxGes7tvjvnKM0hpEae8Pl58/03lEi6fkvYhSRscd1Nobsvc/XL1V1GSn/hkMzdFNo0WUxJ5+2zIjumepZ9FMs4TQ/kCjiV4P106GSJZHCilVUE3vqlQCK4PaTwTACfJJBTFgl/E0UohPFSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O8hIvEvC; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-86d00726631so51476839f.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751304692; x=1751909492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dIrnptZQL1B6kJb0BBZjMTx/NoshIV0x5JEkUuDv0ws=;
        b=O8hIvEvCddn+1y+NMzt8rq3f8DB7CSnKyJYKQA0AQpsmUzl4KHaB5fX+QO2x5Y3PHn
         vTFghnm3+7jUdPZrTEaZSEbsJMz7W4LdefrlzPo6XJedjOflEwk8F0DACwzbqhN8Yxrs
         Kuv9IJ2FCPI2qaep6rpOpAyrVyvEtzeKTFa73gw0QcQ7sLPuuRmM+vWakg3f1ubuR5GB
         1Yiux8xt/2k7UMUrR0dIiuCJgApge46+SmpNMz2DIYGEUZOsuSP34KX5ehrJT6Ccw/HH
         OC5pBI4SDVRxo5GmxXTXHXYsfpvY+ZXbaJSEEFNJB+iAF3adDthDjMnM8biSspRo3/+P
         cKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751304692; x=1751909492;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIrnptZQL1B6kJb0BBZjMTx/NoshIV0x5JEkUuDv0ws=;
        b=u0jBXwnQdUsYOX+nNA8xyF9YImN/x9W/CrmZU9IJcdmO1NVP2klSOMIaLE3g1zYsJT
         V6sv79Vwpts2u38poluXUtUVWsm4Dl3RyoCMX1lWvIKWopFlpM9ZVwhOHkaC6s5n/2wy
         lFgXe73BlHZ6YmX76spp2WWGlvi7EkRBgIz+0A7CDAuYugj18OY6f01G8zR+JiCuNyol
         yzmuvUN8uubUSi2e+swefpRVX5lYG7nOAs63EZo5m/5MXFhZQwDPuuJQo10KHPpnofJt
         uXsoXRbyjnO6KPQuIA59BgwB/k3FB0xUGKX6aweIGn8RVoMaVuM/OQkcSRvedvvg14es
         k/bA==
X-Forwarded-Encrypted: i=1; AJvYcCUvmLeUhs8ERWDS0/6f14T7qEdBMMBGKjBWS0SSiJWDTrcP1eyPbldXRJnq1/2/sE0vgDKheo60pQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjH12Pu/BlG2RE52qPmK83iKOh47IH2o9XeKvjr9ksWvr6PwdD
	rPE88UpzzzFvZpEfbDk6qxH8wOOIYxb3l2E5IxZPNkO63rQNWyBnylVMC2tdRNbVmwRyeOFULDd
	W5B/T
X-Gm-Gg: ASbGnctiyBlyKte1cUN2QcDZM0WcVLagAflMH9Ho2NSVeNK4EX0ogBQpvRxf1nAByJx
	3tT/FvhDUknYLNLdPusspy47/5jZFYyEW67xPH8sRB2b2Jbfe1qpK70P9OSkm2VBX+5lo3EDe9k
	eoDVvkQoKt3i7BKtjfvjSVoMuUiz/VW5h6HAS3ax7DalK46cVJpVmqX8nEh9vTE8Jh5g7mkW+oW
	GIMI5oD6FBqMW5b5bakqG+o8q99MfW59OE/Wm2SZKZYyCTQ39CufYzqVZQQQwB20umm79z0xOvZ
	aTqLuAJaAqLD+6GwDbQAl9R/5zmas0TxY81TrJo3JN07Zw5XEl+nhDgm1ss=
X-Google-Smtp-Source: AGHT+IE25TB697X27/LTGQ3B/iZIuCFNFc4eNeNNShk+oBsa7v9ZCvoO1+gAzfAJmJUeEImCKOp33g==
X-Received: by 2002:a05:6602:4019:b0:873:1cc0:ae59 with SMTP id ca18e2360f4ac-876882b752dmr1505579139f.5.1751304691866;
        Mon, 30 Jun 2025 10:31:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204a8b6aasm2032121173.92.2025.06.30.10.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 10:31:31 -0700 (PDT)
Message-ID: <99fcc8c2-a721-406c-b420-decbd591d7ce@kernel.dk>
Date: Mon, 30 Jun 2025 11:31:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] zcrx huge pages support Vol 1
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>
References: <cover.1750171297.git.asml.silence@gmail.com>
 <34125872-bc2b-4b49-8331-d85587bfdb9c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34125872-bc2b-4b49-8331-d85587bfdb9c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/25 11:12 AM, Pavel Begunkov wrote:
> On 6/17/25 15:48, Pavel Begunkov wrote:
>> Deduplicate some umem vs dmabuf code by creating sg_table for umem areas,
>> and add huge page coalescing on top. It improves iommu mapping and
>> compacts the page array, but leaves optimising the NIC page sizes to
>> follow ups.
> 
> Any comments?

I'll take a closer look tomorrow, it's on the backlog after being
away for 10 days.

-- 
Jens Axboe


