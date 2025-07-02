Return-Path: <io-uring+bounces-8595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A946AF6624
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BC3F4A7668
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DD425EF8B;
	Wed,  2 Jul 2025 23:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wZbaDdct"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A49238150
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498355; cv=none; b=Rrt3vMjs422/0BP+D5tTzodvCEscdpnROl0zNsn6oN5ejGJcDUyPK327p5kKSGOWB6zEEeY6YsHRk7QcQCi8GIhxs/cCHR0Xf7BL8pdxiFHca2Y+vVDqYuav+TkBhRpTt2eys/tXkbILvALjC7J5wZf+Smj8jHwrVFy3N15i5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498355; c=relaxed/simple;
	bh=BW8QxzewbB0kqS6VqMI0cjuZ5VkUROmU2Ldyb/IPfhU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DWRoVEbHv6mHP+4TEIlI/dZV4sG3NJB+CRlJco9pDZnZvL+Rmwl+pjR0xNi3n1wQGwumNgPDOmTsekua8yaf0ktV8tY+m3tsscAFZ1qKk5Gj/VPDDRIoIBnqVeEEfWVY72s4ji7/qthk5aR5KAUUqJraZjuyIPsUSYgu+FN8ka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wZbaDdct; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3de18fde9cfso27745795ab.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751498352; x=1752103152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uoer7gAYMywC1eAGD5TlSBzePPql1dNucfA0H3oYYO4=;
        b=wZbaDdctRMJvJgK5DqyOL2H2Wt5jrkG+hL3MRcKn3AfHUeoRBDhC8xvSzRRMczHqTP
         irwQ1p1HEFLtkXJ75cCmraUT6cNRSRLBs6jZC1Io4Iw1dkao+G7WgX19kIgJXY7z1IBX
         28cD8F1T0qlITIcHLkpTDLtokPyW5SLNlZIy9FDkjZk1bc0g1Ut20MM2iwwVGehpWhyX
         hDl4MoQFomefot8GS3mWIZjO8OZdlKYsgKHN5uVIwb2BoHBAm8mPVNLtIlIJeXGrkY/4
         2FWTP5esBP1BcwJ75obLnWTLdt6TzhVMUiaKW/UqOamCM2UsVj1/35UGY01Nwlsys+54
         g9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498352; x=1752103152;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uoer7gAYMywC1eAGD5TlSBzePPql1dNucfA0H3oYYO4=;
        b=uB0fjpuMwIm1orIh6oImhN5WGqWLy6MTD1yf8NIHe5zLcLBK5PGe/ejvOL+f9rDVjo
         832B3gVDt0lW/oxpwtSwIloLfRUvbMD4MRCAtJPpuglOh11OOg4FATRuZ6ig3qV5X3bi
         wfhtFaQoL3O9GsHgOh1zO+NONTjDtxsy5KlOaplnE8qeNHczW05SbKxqs+d0rtRPhRR3
         k0Vg0U87eRJKEOGww+a1x3/j73O/N7sGzHXdKz7uv4p8mZ0RkpAsd+eXKrLlIPsRDbEr
         wgltLA3prHbgAZ9YEjgO460Oq2e2r1n4Lawlcz2oiHmYNP0ecbUb4uQCiqnzoserDRSR
         S4WQ==
X-Gm-Message-State: AOJu0Yw9w3rTPCe02aYiU0WJd8s4eUwAly9mKYxbDiquI2rMKYrxVbpE
	nt4+mv6lTwmQgpkTKAZYwYT/g3/fMzLumHLR6OZmYYh7+fQcBWjRZCg4vEOOJGL5Vl7wNoGUArW
	G3+KX
X-Gm-Gg: ASbGncs+0s/THH4o/fACHmWrLQt2fIojX0GihFoHfwcAgu+Bnr1mZkVaPyoIyqqaaSz
	sFmW3mRXUkzYchTAae7jwOU7BT6obl57kanDQ3NLBkkvfgUNGX0qhjEK5BMonA+/96LYtyBk//Z
	JuVMjW8vI3oPZxUeC3c990pAH/lyZuJdpLqewhoq6VeS3ijRoFpsFh8hllFdlSiu8mP9+NYaD0c
	n4lGo95Mzebfi3dtmgfwIihxuPbmhNlOPAFA3IWqh6sWMS/Nn/SK4gJU7NdSddUID+c7OsOWvdg
	GHZb9mylhsMsDd8LkgrN5Kr0jxZzhsUcj5ZDQaIHQzS59OYaIG5oPg==
X-Google-Smtp-Source: AGHT+IEdYk1s/Q/ocqN3MzDBUZqiBcXYYymI8xHbwDRWzvxCEQEzAAL6sIJ3dKQx0AfHDJuMJ/hKzg==
X-Received: by 2002:a05:6e02:2284:b0:3df:52fc:42ea with SMTP id e9e14a558f8ab-3e0549c63dfmr50294485ab.13.1751498352242;
        Wed, 02 Jul 2025 16:19:12 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df4a09165dsm38313005ab.43.2025.07.02.16.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 16:19:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <47c666c4ee1df2018863af3a2028af18feef11ed.1751412511.git.asml.silence@gmail.com>
References: <47c666c4ee1df2018863af3a2028af18feef11ed.1751412511.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: don't use int for ABI
Message-Id: <175149835049.467027.11061748733650171792.b4-ty@kernel.dk>
Date: Wed, 02 Jul 2025 17:19:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 02 Jul 2025 21:31:54 +0100, Pavel Begunkov wrote:
> __kernel_rwf_t is defined as int, the actual size of which is
> implementation defined. It won't go well if some compiler / archs
> ever defines it as i64, so replace it with __u32, hoping that
> there is no one using i16 for it.
> 
> 

Applied, thanks!

[1/1] io_uring: don't use int for ABI
      commit: cf73d9970ea4f8cace5d8f02d2565a2723003112

Best regards,
-- 
Jens Axboe




