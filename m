Return-Path: <io-uring+bounces-2718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2448E94F65A
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3DCD1F22A2A
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33A31898EE;
	Mon, 12 Aug 2024 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ymtry8ML"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4571898F3
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486316; cv=none; b=FieP6mQMv4K29qOK4POPLTUXLFtko23S8lzYaHvsWOiTbe1ck/dTegKvuMFLic6pILN5gOjquG1w3P9WnqLn7BjIME9e99kKY4fIdBztKGIAXPNJupuBMsK0Poi11lEgOIE7wdWajoP/Mu0DVxL09KRPgQ7zdMJu7/odmQlPcDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486316; c=relaxed/simple;
	bh=5ZCThyT/V2zQyBOZRnpwkot2kKGH8SViKQcyBndxv/w=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gdhJcD3aLbA1GHz1L9ujEV0EFbONE26O3y3ueZ/+8laRPmzLAU9lG4eTZTdzvVsgzrXEv8soSrHufqMSVoXh5QofWWRSJPmkUjsCbLk8wmZ3WyDHIF22Lt2Taur/6qNSNATcZBbCGRRkuGvo9yvdL6f1Ln+RMEAglt9H4fT/NaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ymtry8ML; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc57d0f15aso3150125ad.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723486314; x=1724091114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tcTa1mrPnywyPOfK5QPSGwd34TR0/aPaXoSbboakBxk=;
        b=ymtry8MLeQ7Dzw4uPACA5u9KyKe4W4mldya47otWHpo4EUFT2DU2/E/DS1d18/RSp9
         i+ksotyFo7erWGd/ZwHehx6a2OBxXMlNv0i9pUAm18ufUBvwDdj0h2YWyfAl0tgIbmU9
         jdRov0vOhipcWvSHgS/VCq26slOaw3vDGRRA3aCkqaFDLErJxCOxt4XPL6ZYkWgXHjkf
         LfX1JekOhUdRIsaf3CsGWHTbOMIQSf6Dcvukysh4ztbuT2CXKol32R/ol1HzYbhV8hhh
         i1rbwwdYmZ+1jPSelbL8Oys9Ttq/pSAuEEkBafhzLSf+4nD7wnOruLTLPNjecFVipXGJ
         qdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723486314; x=1724091114;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tcTa1mrPnywyPOfK5QPSGwd34TR0/aPaXoSbboakBxk=;
        b=h1n/6DoAJigDLXiFnr4G7qmbY1bQWazn/9uDs1nkvyHqqYazlJvUq7p6A7csrcN7Mp
         PxMMNnjDoBqnQd50E8/7L3dLiFB6b1WiVSscQdcHMUjPMlCFbcGnQf91Fw6mAmkVaUn6
         VKa3bjJZ1z/h5J/NCpXZXTxkRVmO76Nrvh21HC/CKg69TkPf+YyKv8fBRgcgtFoReI5d
         npeIWvcr47jmv5dmGoknG3rQ5sO35wE5oUIbFQkCBlcRgqAC+2bl/f+ZCEwDwbVEELVO
         wkLfel6GhPfE4RX1NYkmUnVD4tgGoWz9gyOq59f7QDWfFoKgi1OyT0WchX7NF9+g1uat
         YIKw==
X-Forwarded-Encrypted: i=1; AJvYcCXKW9NSA3b2dnklJdRjR79ATgt6BCbbzTkUOcYUll+b/6UmBi7yfJEaePwA+v78yq8fjHsPIrBVoF6FTCtSJRA8HdYOMpTWiTc=
X-Gm-Message-State: AOJu0Yzu9Po3ksMhOYy1qet7J/h0nfx6/bOxl8+5xH7pq9nDo5yTIwVA
	wE0jAdYWYFkkt0//NgrL2CZY2HduCZy9TU7vDGCOfrvBI6u+scCsDeN8lk6K76NNpNyoYNvITWx
	k
X-Google-Smtp-Source: AGHT+IH/1vimRacwBvEEMLqg/Wwr5hlNdGO34Ws3uawwgLKzHvmRKrE3r5gX1cZ6TyWMqnEGgfH+wg==
X-Received: by 2002:a17:902:d2c8:b0:1f7:2576:7f88 with SMTP id d9443c01a7336-201ca1ae37bmr7579985ad.6.1723486314608;
        Mon, 12 Aug 2024 11:11:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb7edde2sm40974055ad.3.2024.08.12.11.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 11:11:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
Message-Id: <172348631298.98360.14994353963638923642.b4-ty@kernel.dk>
Date: Mon, 12 Aug 2024 12:11:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Sun, 11 Aug 2024 20:34:46 -0400, Olivier Langlois wrote:
> io_napi_entry() has 2 calling sites. One of them is unlikely to find an
> entry and if it does, the timeout should arguable not be updated.
> 
> The other io_napi_entry() calling site is overwriting the update made
> by io_napi_entry() so the io_napi_entry() timeout value update has no or
> little value and therefore is removed.
> 
> [...]

Applied, thanks!

[1/1] io_uring/napi: remove duplicate io_napi_entry timeout assignation
      commit: 48cc7ecd3a68e0fbfa281ef1ed6f6b6cb7638390

Best regards,
-- 
Jens Axboe




