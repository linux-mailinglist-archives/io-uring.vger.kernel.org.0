Return-Path: <io-uring+bounces-2639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E792C945E62
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 15:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 919EB1F21DB4
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 13:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE7114B09F;
	Fri,  2 Aug 2024 13:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qdHjzmjc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02FF1DAC5F
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604269; cv=none; b=rXa+rFOBqXtVYt9amh3DqK0gng85QXRjmo2WTR92R4DcLVrg0e2eccqvq/0lXpc5hAZQ6PaD4Ax0KRUJhHHHGScxcxFBIk5reAnKBplNv259+3i39/qov+e2PrxvbHhz84h9PJnjVUdxGGSOCKHfWOrObTNRoMrU0DWJFDOjgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604269; c=relaxed/simple;
	bh=tVETiVasDjYpS8N/SVkdhjdCwUG3eUfGmFoD305zYpE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jFSQ8puq9uApzQt8SnUEQ/u/tzC7bWsvlYiyoa3pyzk0aA0W/ELc3bmTiG/eVn9nZ3jFu6LLk/deG+mSJGtpgydcq8b+G8pJnwHjyubWBxSC2KlJNQ5F9gU+4arp/3gnNKG31NQyVXt3lfaCHLgogSm44uIEbtCdilO0HXAkn/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qdHjzmjc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fc53171e56so5024135ad.3
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 06:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722604264; x=1723209064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODlMq6gIe4TJP3VbkLtmVxzJieArDDhLmCbdJiIjaw8=;
        b=qdHjzmjcMU+0aI+lFG6I58QchrH69ttzSKOnzrfOPksKEXXMFyEmYN+JdEjzKhpUlc
         ZfhKyBusyy3BVY5/oUQZgN4kFUpe0BtJAXTNEOGabi5f84Zr46SlNLJbZaERuY9xsGnM
         Q1hovJ9cHk7sUQPxWsAxY8DqSkOY2ux4SvlvqFr6doHrv3ld0EdPxu83fb7X4coOO1sv
         cE9h0GoeCLa0NQhhzhQs8VtTixGVIS/d/RZHdwybOAzwKpQF+4J+o+VBBQPfNWmSubWI
         3cZVTuA82qrPhF4oSr0Dyc2MiwBhzEpmmT2GvjXaKGFjtZnp44gcQAQayl9Q1ZU94I2x
         BqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722604264; x=1723209064;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODlMq6gIe4TJP3VbkLtmVxzJieArDDhLmCbdJiIjaw8=;
        b=PGEJU5S0W5ImYYbSmV5RATo8HvEppJRB1FysEznzXcF54TBWW6M5JuWu07YnHEbYPh
         UokjHlz8chXtf5sTKqd9VFB5ABBswn5+SBzuLSwSODIzkyIevM44a5C5Wn1/aEf20Sug
         vuyRD6DPpA+ZGiIUk2ezqBg5flY1AkFLBJkH10Z+BtWivdOSJZD+S29nEX/AjVz+KCTu
         s+IbY2ka5sGrSlpbmg9fYMMgl9UdoJkbEcCVKj2a7Y3q4H5xsdBEogO7+5w7GYF0RnRI
         WuJr7cO4B/HKTjf1Mak4VVWPr10eOka45TgIitXdbA+LG+BTks+q4XgA9XERjxfaUlkl
         oVbw==
X-Gm-Message-State: AOJu0YxMN4WHiDdcWxy7/PJOA5WxJW34MvwBl5fLrG+myUcIjDbg4zz7
	8LssZbhnlofAOiY5zUvEuseo29R+ldCjSrRQn0f6jAgj/8jz/C3B/J7nGoGTuVU=
X-Google-Smtp-Source: AGHT+IEbKCPqmYQXlu7bVHg/2kwkdH8pR2D88LDxtNmS5ZRC2Dit4Xs0HqxhHAX2IfHZ/qPG7AH+XQ==
X-Received: by 2002:a17:902:d502:b0:1fc:5cc8:bb1b with SMTP id d9443c01a7336-1ff57422457mr26193685ad.7.1722604264451;
        Fri, 02 Aug 2024 06:11:04 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5916eaffsm16611305ad.194.2024.08.02.06.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 06:11:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Chenliang Li <cliang01.li@samsung.com>
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com, 
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
In-Reply-To: <20240731090133.4106-1-cliang01.li@samsung.com>
References: <CGME20240731090139epcas5p32e2fdac7e795a139ff9565d151dd2160@epcas5p3.samsung.com>
 <20240731090133.4106-1-cliang01.li@samsung.com>
Subject: Re: [PATCH v8 0/2] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Message-Id: <172260426305.62322.9668566634481802792.b4-ty@kernel.dk>
Date: Fri, 02 Aug 2024 07:11:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Wed, 31 Jul 2024 17:01:31 +0800, Chenliang Li wrote:
> Registered buffers are stored and processed in the form of bvec array,
> each bvec element typically points to a PAGE_SIZE page but can also work
> with hugepages. Specifically, a buffer consisting of a hugepage is
> coalesced to use only one hugepage bvec entry during registration.
> This coalescing feature helps to save both the space and DMA-mapping time.
> 
> However, currently the coalescing feature doesn't work for multi-hugepage
> buffers. For a buffer with several 2M hugepages, we still split it into
> thousands of 4K page bvec entries while in fact, we can just use a
> handful of hugepage bvecs.
> 
> [...]

Applied, thanks!

[1/2] io_uring/rsrc: store folio shift and mask into imu
      commit: cbca98cb933728bb5eee39ba6bfe184932931e3d
[2/2] io_uring/rsrc: enable multi-hugepage buffer coalescing
      commit: 04eedfc93ea1121bb6b00f27b14c58973f7de1c9

Best regards,
-- 
Jens Axboe




