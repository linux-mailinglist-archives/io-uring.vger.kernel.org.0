Return-Path: <io-uring+bounces-6211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDBAA245C2
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2025 00:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 121A47A35A9
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 23:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC531B0424;
	Fri, 31 Jan 2025 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QTMfS+3K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FF199223
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738367817; cv=none; b=uT3W17FDhhezUVYBSTFqwlVKzyHJBZnmhlLs1tJ9RRWMHOz3Romq1Ecm9pRPdnK5mfeu29A690qMXCrri9DjX6snS/gF+Je+D4GRXGCxCI3eopmy172AaGw12VaM6J+KMdjFgl0H5iTZIrnwPo98A9tdkxaxx3koDC7zfgvxJrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738367817; c=relaxed/simple;
	bh=IsZ8I793kLinCNy2F/xXzLAg/3VL3sj5Yu+Q6yUlOVg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uDTyX147UuooFdfxtBzT35x+t4kZs+DLODyIsYZMZ6szSoymNmoWvy35ofcA6j+7D3ubHqbtgr8zFPMqFAgkY0H+5URIbqV8YKdcYxZEkBEtk7nJ2zfwbvcXqg3B1qmXYv9Yvzvx8T2X/iK1uJQxbsIw0Kvhfo2sl+kB1CWpoyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QTMfS+3K; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so78080939f.2
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 15:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738367814; x=1738972614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3afT6oe0pWBoHWgTuSrZfzBv4DSFLmps8ntMe4qSI8=;
        b=QTMfS+3KWs9hbn6j/7O1OvEKrMBUGdhYFddpJZruEVmy0wxqljnqyO0XOgi5t/bo37
         iRUqOaAL95hgJ6ouOn6WUX+ecSjHV4ipS4i7FrlN1YcAy5kFbbSWB9fUPdUAQs6RygjK
         6z8WkhQjGJoloMRR1XzbMX1VLgtVPHrRvvjvWFkUMiYB8iOZ4BBx/GmiDDqTJXqLOeCN
         6ZoDNoinxEFefNyGJM/IUzg4Av6UXD/TZ1U/e3rPCZg5cnhKQXYJ5+JPFwn55dgKDank
         4ujf+kLOc+HxleV6rY8SJRBATCmeam/r3g7hFB0XJoTEd8o7Zi0A4r5FGskPqViTLCou
         YsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738367814; x=1738972614;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3afT6oe0pWBoHWgTuSrZfzBv4DSFLmps8ntMe4qSI8=;
        b=sY3qKeMIOz/Y/oIdUIlHcwprF+f+UVpIhwL6eVpXSlKYQEdqvDub7xRWIHHy8HOcU4
         VzwO1h4uWlz+ZNqpXcuhvd4d36mO2TzZVFx1cO+RrsTcgbWLfLrX2+DwF9uzOnAqjTTr
         PyuARb9SpsRndys8EBL4ycLWbjl2RAK4XpSKBORZa1JZcNKLm4fxShbj3svJSsSipPkj
         bPsKE1U/SeLoy1zkGfup6WCHnp3HHh7kXXsb4F1kMRdvOiVLrtg0YHu9UuWY2UIb8amu
         g2ImpL8wsA3SIvjxqvfCNVULvun999zKgU+ICEkuHue6A+ilEd+X81wXWYObjKCALb7W
         WkSw==
X-Gm-Message-State: AOJu0Yxp5e7zrn1XPtq8FIPAnS237bm3cFN+668n4Q0XTqHRvIfGXArB
	DBsamGorhac/Jk5anp/7wmJonB2BD6qhJr/iYn3Zpyokyq7lZHLoQiMMA9lNy4sO/xBCPwhD0ot
	r
X-Gm-Gg: ASbGncs1yh7ONRjBFGt9Mu3pnBX4Wqc64orj1VX2z03kgTDe0grn7sgBpvImkAPg6n5
	Xzwm2qht+e4PKop5fVLj19JMz3vYp4pDkHp7MkDP6PFvx0XjrdwHAEdx+ICBZT5941wJVFxQ4F/
	Z5ifjWCzLCeugh8uaJ0JdZQ270BL0MOp2UNUIRFnh0R/W2l7sgppmRj7tW8hjm8LGGrRZj3YqrW
	YkU9Ua8tRhX0IA4Zsz76P2aDVSHplKqjUu/zAsCYwpYWaBJBheEFNowT1lwONlLDcNffCJNWgra
	6Tpuqjc=
X-Google-Smtp-Source: AGHT+IGuKiLkhttTrVffW7ptQo6Tk5hmb4m/1qOPxeZAkwhlacHr4FOkZpGZeEQs84BBATTB8jIbrw==
X-Received: by 2002:a05:6e02:1a88:b0:3ce:78e5:d36d with SMTP id e9e14a558f8ab-3cffe3d660emr111572805ab.12.1738367814228;
        Fri, 31 Jan 2025 15:56:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d00a506ec1sm10641775ab.24.2025.01.31.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 15:56:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <363ba90b83ff78eefdc88b60e1b2c4a39d182247.1738344646.git.asml.silence@gmail.com>
References: <363ba90b83ff78eefdc88b60e1b2c4a39d182247.1738344646.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: sanitise ring params earlier
Message-Id: <173836781320.549578.4470486333015276206.b4-ty@kernel.dk>
Date: Fri, 31 Jan 2025 16:56:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 31 Jan 2025 17:31:03 +0000, Pavel Begunkov wrote:
> Do all struct io_uring_params validation early on before allocating the
> context. That makes initialisation easier, especially by having fewer
> places where we need to care about partial de-initialisation.
> 
> 

Applied, thanks!

[1/1] io_uring: sanitise ring params earlier
      commit: aee81931e48b5d236600affba2e7a2a2dd2ac639

Best regards,
-- 
Jens Axboe




