Return-Path: <io-uring+bounces-2717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E190E94F659
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1CF1F2283F
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06AF189913;
	Mon, 12 Aug 2024 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gY/BUMTp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964BC1898EE
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486315; cv=none; b=P1Trcu20mjKqD+dCMb4r/BLuIRP4YBz2Z6m5xkc92CiYb1TqwFXXtjyVxezxiKknpnm8qJMj3bGOhGPTp4XtDDhejtWsyDFAvpj0DVe3R08btVK698ZSW8N1WedeCYSeoIdv97e4RuRfBPYleNq8gE4gFBL+H9yCL/AlO2K7QJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486315; c=relaxed/simple;
	bh=IzWh2G45AexR8bUronDRNg/2yogt4YadYdBIcyMoNjg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Yj3hNHlfZDM8Xvfw4VmKZ8rARaWW4iHLDyhB28ezaYloVAEle3r59oylpxlq1vBKfV8/HQ+1eD1x4dn7NWhY6YrmVi9sfIDrFxsfqGdkIsmMD+AIrdxYJt7FbFOYqB4dFTwpPrJA4vh/kIr7phjJetHt1CYcrMtqaxHvK6WTiS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gY/BUMTp; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc53171e56so2792135ad.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723486313; x=1724091113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hA6dIKAT7DgoB7YVCrj2GWPCstRTzrvBddYWS2ab3hQ=;
        b=gY/BUMTpefyIEzbLy5/JmA1vvjYUEQbAzxasilD37aBjZrWFcvA3tcrtxv9qk7H4Ta
         A7dL1/JsWFQiqC5WYZKORgjSIHN1QRc0CNOsnYb3DHD9n+j8ZeFiupbbIF8se+gl6qWx
         wgtC8Vd5coqZgI4YhYdDbdZISeSlEcACTMY2ZNewmtcAU52PzFoOql6d7RBI6bgxjc5z
         1ZGNSKfv/I613c3F9cUprNrNXhJ7e67nDjZuflVywynnV0grkHjCfV1kQN2Hr+AO1z6F
         Tga8p0r9tJJfa6mXOXDq4F/btO11JGYXPg3z0T+47wRw/KpIw9s+wXFVSXctmWCHbnv8
         q5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723486313; x=1724091113;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hA6dIKAT7DgoB7YVCrj2GWPCstRTzrvBddYWS2ab3hQ=;
        b=UUMrE+BVZjRFqmgTz+pLgcMoQXnETru+OfNjQ76Df02o6PbLkv11iOF0kovcGi+CuP
         9juLAVVhgWcpWaqdOaZQPuk6A0t1JqS3ky8mjJ/SioijtvzO+DZu9eWKvBEWxvaokPyB
         puQxDopz6jAvB3OC5zo0DyW1Pqrx+JoaTx9Az9KgA630LiwcI48d6XiF168ulD2MXDMy
         sK4u/X9gwFzEgXm9Ze0vwJny3KpXgoXwflKKljtuPyUJjfCYfEZVsbdH1tvvebdWzOxz
         R8v5AhbzFOdhRRMnov6+exmzFZJds+ByCDBUc8sENLy8kefvltj2iJud9aKCeOd6MAVN
         1nbw==
X-Forwarded-Encrypted: i=1; AJvYcCU6BCAc7eLa22GdrNZ3jxiTzc2BOvAY1aJlv2n37V0z5vh8r4Daie62wf9pFA3WGVwSdzUfGrwXXqfhFfkC+Cdxp4XPNkynOPQ=
X-Gm-Message-State: AOJu0YxUTKORyv1t2qGIpqJG3z9O8Tj0YSg+TJhndz17J1KsEycNAevN
	wSWVq77QDTh98PQFh1krYKJ5w3Xo0cbs0w7qrxUCF94saeMo7k8HLvMbKm4JGwE=
X-Google-Smtp-Source: AGHT+IEpMbiFzjqdTA7yf4vOor7Cp/v0GeWQg7+1yFKEorpFQVNb/K/bVp/u9gvgJIkBV9ZMgb5Vhw==
X-Received: by 2002:a17:902:ec85:b0:1fc:6028:b028 with SMTP id d9443c01a7336-201ca1c5c1emr7554025ad.9.1723486312812;
        Mon, 12 Aug 2024 11:11:52 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb7edde2sm40974055ad.3.2024.08.12.11.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 11:11:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <bd989ccef5fda14f5fd9888faf4fefcf66bd0369.1723400131.git.olivier@trillion01.com>
References: <bd989ccef5fda14f5fd9888faf4fefcf66bd0369.1723400131.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring/napi: check napi_enabled in io_napi_add()
 before proceeding
Message-Id: <172348631193.98360.1176837340978077570.b4-ty@kernel.dk>
Date: Mon, 12 Aug 2024 12:11:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Sun, 11 Aug 2024 14:07:11 -0400, Olivier Langlois wrote:
> doing so avoids the overhead of adding napi ids to all the rings that do
> not enable napi.
> 
> if no id is added to napi_list because napi is disabled,
> __io_napi_busy_loop() will not be called.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/napi: check napi_enabled in io_napi_add() before proceeding
      commit: 84f2eecf95018386c145ada19bb45b03bdb80d9e

Best regards,
-- 
Jens Axboe




