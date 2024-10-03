Return-Path: <io-uring+bounces-3402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D8598F9B1
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 00:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 539D11F23779
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 22:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0271CB53A;
	Thu,  3 Oct 2024 22:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mIs8mcBp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD531C9ED5
	for <io-uring@vger.kernel.org>; Thu,  3 Oct 2024 22:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727993702; cv=none; b=c5jbEGQ5cKQfNzN3O4tV0W5T5MZ99CQiY2B1XfL0ojRONAD3oSBXS7jADLOTeIL0E6pHAm3z8kYyfEdbeCjiyDUljjr+Ut+hGsHuUbqNq+uAWgscaKoCAqB7MIhmhsMFg5UIax7PGtbgao6vJGKoS0+Ndng6K+ZWKMRFJYe08Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727993702; c=relaxed/simple;
	bh=Wm+Wae3El+M2ZBDfmungAtoN4HD3tcZ2i9yMZb0+/KU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDzQUCZRCxiVRLXQFiS6Jet4Gc3HP3q3Nl6byta0u/VJJQarOK3FetLWSRjxFSPy0NPa69kfCvC4Xu9h/Sn/hLhfc5mmYPCOP8KViy6Iol5Ec08g9/p+/pJIiR+dESnPwl9WHIx9TtZwvRWGZvIz4tLx2xAV2s6YSbZusWHfP5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mIs8mcBp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20bcae5e482so14011465ad.0
        for <io-uring@vger.kernel.org>; Thu, 03 Oct 2024 15:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727993700; x=1728598500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aKcx4mSd/6y//cnPDUFf8gQTgd9+fKKEcuxJUXsGmAw=;
        b=mIs8mcBphetNFfGBEfNbGt5ObYLiOfju7CK1HKn14KeoEu1Y9attuasXJnUY/Lz404
         GvzGWQTqTxo3Mx8BSz/8mTLaSW6jCN2IvYBF4mZ6R9K6QSzKYwpVpFKYCgIN9lOZHvr0
         CgkMWBQyChgdJMQtqER9+ZGLunidUArn+Lmel6j02zh47zKccsihRxclOaYXsNJaQj12
         I2qDB8RCdO7yHCzc4jxIOTqFXcDmnNmtqJhxcrgbZSkppJoA/ygUGBe5SVTn9boL1sEZ
         AsYm5UNv9MYsZrf1SDBuFHTJkVfjtloSvmSgkzrsHlUK3xBUjxCNA/XrVF6toQsbVjG+
         72Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727993700; x=1728598500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aKcx4mSd/6y//cnPDUFf8gQTgd9+fKKEcuxJUXsGmAw=;
        b=bMVEWIzVsO4lC+Encs+q8/manxnxIuXD2FBYF/Bifwj2DCusWc0EFICy5JsE/RaRIX
         37ZMVO5Ai4JQLiKrOoWwGm/d0KFCCGNx3vgFBnf637/ajHwGYVi3CVk3GWdW2E98wpld
         VsP5RZgqBsL5FPMIWBhFW7bkRBvwhJHirjmkgRZzxGvm9ZKB/pgLywpLIUAEQcmT4sF+
         D/ORU0drDGQtoaBhHGp/KJ5Sz10zPlB02lDaTKwjdxvkk32DL92uA2dtUTP1ZSTaNJRM
         lnW6pubO/SCT9dkQ8s1uvgpnv892Fvci8NlyEBNYK817YmpNCGgelc+KHwmrV4+U2d9I
         ZjNg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ5nNvONQVIwucNG+M9IoM2Nr6VevJic/6HF+yaWTjIMxeQD/DyckyQiyF4d/wPHqEuxKh+ij5Vw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKnizRzBWuXpBh1YFFhfCm1b/blzMBXCT9ktp88GY41QtfFLfU
	0Iblyvz9gU20YPhTCBvv2/NQA9AMURqbkVCdCYqgr/gR/a5UT+feAbs/zEZ0o6s=
X-Google-Smtp-Source: AGHT+IEa8OibXU8u5AU9dURn3INaVlJRzRZ2R5VooIMzXfRbVR8kevOP6FlKzcqQxHqYef2QRhpO7w==
X-Received: by 2002:a17:90b:224e:b0:2e0:8719:5f00 with SMTP id 98e67ed59e1d1-2e1e62a93f6mr663348a91.22.1727993700011;
        Thu, 03 Oct 2024 15:15:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e8643534sm8913a91.50.2024.10.03.15.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 15:14:59 -0700 (PDT)
Message-ID: <c68fef87-288a-42c7-9185-8ac173962838@kernel.dk>
Date: Thu, 3 Oct 2024 16:14:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Christoph Hellwig <hch@lst.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 hare@suse.de, sagi@grimberg.me, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 bvanassche@acm.org, asml.silence@gmail.com, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
 vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
 <20241003125400.GB17031@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241003125400.GB17031@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 6:54 AM, Christoph Hellwig wrote:
> For file: yes.  The problem is when you have more files than buckets on
> the device or file systems.  Typical enterprise SSDs support somewhere
> between 8 and 16 write streams, and there typically is more data than
> that.  So trying to group it somehow is good idea as not all files can
> have their own bucket.
> 
> Allowing this inside a file like done in this patch set on the other
> hand is pretty crazy.

I do agree that per-file hints are not ideal. In the spirit of making
some progress, how about we just retain per-io hints initially? We can
certainly make that work over dio. Yes buffered IO won't work initially,
but at least we're getting somewhere.

-- 
Jens Axboe

