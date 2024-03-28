Return-Path: <io-uring+bounces-1287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2CB890025
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 14:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E496B227F2
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 13:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6B27F489;
	Thu, 28 Mar 2024 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="st3H7Oma"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92138060C
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711632228; cv=none; b=sqEQqVbkc/iCdIp4t6sqSZaF8mg1lZ/ByKF5ZfazGRPmqEh71JrnBtZA0v1IwfjhBxm1UvYqk101EkHvdE0ctaz6Rw6ga5bHYtLTyHKicpapwor6TJd58w6oYp327CsyIVChS/V/zgC9ARiCy2oSFxm+o7820JWE5U/uX9Lp1pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711632228; c=relaxed/simple;
	bh=Axn1SnWVil0DhZGeF7iaqHDK2ckJRuooRgFwY86RwBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLokCQXisN3ce+gqUHBR0HO51ud3o/57/lrvOnIvYM0irFoZJ8iVbXIP4XE0AcsIkjl4s/jcpEsXl9sJrlbIyuR9qN5GMZpowKvVgbPTClyZII+5qdhWA6pZP9yPi+xFT19r61qW8IvR9Y8LkNTQRKismfZNCuwgKjZukD7dfV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=st3H7Oma; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-789e209544eso46024485a.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 06:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1711632224; x=1712237024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0JHtTgIoQqVySocD18a8ZqvaeDDjY/Uc2SBX3I9qts=;
        b=st3H7OmaB7zte4Gx6oarwmhCCbczCT+b6AUiNjRUaOhcP3/9N7qr1JXYpqYpJg0dVK
         nPgGV+G7MweymGS4vKzywF+l6fZgXVEmhMpQK8FXtailE+FJvnewlPY7/ItM6+z3hDIh
         JY65PG90S5nX4LM553t2zMfGR90DIEmG86YfHicbqYB2Sfmad1is1lYzSh9xqn4H4zmu
         SdT1dG1Ug5HsapJBWTfC7gqTHGR4yz6FyR3sZRXd3lhZj0SxwOWh/i9HpRNjmfLkU9C0
         KLS6J0WOfUdtv8WwlzQNQ4+R7XJc5A1258Z11iJcjdLgT2RHcnzDpoHydt02SLgxi6Un
         15Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711632224; x=1712237024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0JHtTgIoQqVySocD18a8ZqvaeDDjY/Uc2SBX3I9qts=;
        b=olsg1ryh4dm2u8zvaFgw5GDgf6b9y5snVjge8hSoH1AlQVm6LMVUmoMFoDO9CZr32z
         ZVK5joMDC1TsAVwoN956uYVaSGQ5zr7rRsjwChNuYClP2W9fVlhF95czGU1naNhcv7NJ
         UaHQ3vM1kBbaV2R4mnz9f+EfyG9VA8+2jn3RJJ2bibl5eJxpTJigvEhpNkXZ+GTlOt+x
         bShf6ExOqStvpPeT44tfydVh8g2npVQl3btkP3TlMCiRUQ4pGErB73svZ8RpSXQuIHQp
         3iPd4Uedcb7SAGeF5bexHiUnQghEbeiH1Emjha26rb6O2xop71Vml77n/lbz76SyzFOg
         iMqA==
X-Gm-Message-State: AOJu0YxLcGC7oll4b8ipWnkB6CkfO0lEGql5lsZ9J3Vd+cdxT8HjcXKL
	XhJaujdFimmNt+xo9qPJJN/7VEP4OA2aro2JbFCclrCqUhc9IombDhXMEH30vLE=
X-Google-Smtp-Source: AGHT+IH1ALbdkJo9lUPlx93PH4GSAzfXeoIV2DX1G4oBPdBB9Cfgn4R6wRyZKhGrWqFbndQqCiddLQ==
X-Received: by 2002:a05:620a:b52:b0:78a:5d8:9875 with SMTP id x18-20020a05620a0b5200b0078a05d89875mr2496580qkg.28.1711632224390;
        Thu, 28 Mar 2024 06:23:44 -0700 (PDT)
Received: from localhost ([2620:10d:c091:400::5:bb1f])
        by smtp.gmail.com with ESMTPSA id p11-20020a05620a056b00b0078a210372fasm517006qkp.86.2024.03.28.06.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 06:23:43 -0700 (PDT)
Date: Thu, 28 Mar 2024 09:23:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 01/10] mm: add nommu variant of vm_insert_pages()
Message-ID: <20240328132308.GA240869@cmpxchg.org>
References: <20240327191933.607220-1-axboe@kernel.dk>
 <20240327191933.607220-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327191933.607220-2-axboe@kernel.dk>

On Wed, Mar 27, 2024 at 01:13:36PM -0600, Jens Axboe wrote:
> An identical one exists for vm_insert_page(), add one for
> vm_insert_pages() to avoid needing to check for CONFIG_MMU in code using
> it.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

