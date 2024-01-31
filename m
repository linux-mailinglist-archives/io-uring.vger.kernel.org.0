Return-Path: <io-uring+bounces-510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0171C84483C
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 20:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34A361C22071
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 19:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC3237143;
	Wed, 31 Jan 2024 19:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C8+YQzec"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5563AC26
	for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706730414; cv=none; b=Xuf0oB+OG2CqCYXPGeay1fAojP8U3R0N9ah58Df0wp8XBohqhqFVH0heHi+Vv+xD4g9q5Pm6XvS3iNd8ys91oZbPX33tQbtUR7FQSy1fcEhs9x7EtTrUf65G9/a5CNK8BZAPrjPcIIID0na05WUCeDbvW12Z25vFbCcJwMEKBho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706730414; c=relaxed/simple;
	bh=M141oo9hRnHrU6TG73oYICcbWrNb3/J38sZ/32Sgnvc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=H+T5ruvr+G1mnRzKM1w+z81yabAdG4Knyzfe+bgig38GCYRUeKhsIBwvaCE89Ol4dpA1+JbmyNbCiTmkg5jS6XSs0C/yp0dXAKhakudH6JUqn1NxDArzeJDRJLqoUaFNwMNRoylXZ/iyfZD7xPse2khheTCEIPvGdzvJcs5AVk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C8+YQzec; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so2348639f.0
        for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 11:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706730410; x=1707335210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs3doZuugp2yYJlUnQaAdpr4DVZQd4LDsAo1EdFgAak=;
        b=C8+YQzecNxnNf7iTqxuTFJrmZpT7iNNnXPVcMhmhqEiLMpHhfFjUYzrHrTIka7jznn
         ahzfbqdQEkn+hP2xFm+CDZqCtj/w0lbd5FTcXFBsLWAsUN3h3R+tbmCWUg5Hlz846W7N
         Qi+oRho+kRfN0Nd64E2Eedw+u61qxQ1aJ2JsUAyGny49Vro7yCHb5DLHodwMnmtB2GdG
         Ic8EFbA7r20Uf43ug0BxgBig4zrTK44nMpkx7n1HT7nOr1twqTxQDZKzOXaclWIvfPmw
         /V7t/Xcq3QRQLBFBszpONJZ4RORO0imJkPKv6EdmpPYPFm3Zyv/XST3r1LSIZ6V8+8cc
         qcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706730410; x=1707335210;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bs3doZuugp2yYJlUnQaAdpr4DVZQd4LDsAo1EdFgAak=;
        b=nRM4Hik4QqlTtFsxNp6SLEhjnxH1NsyMB4AxZzhAsCfNlICc4dsSD2YgiLnM8vOWQ4
         nDubZedCg9BV9PETGxI+3+7WzOdOkllznRiZvJtL2El7nWIEvb834sl4ixLtN6JoH/pI
         FSGdrMgP5vLSyWTtg/qDaE6GCsE5jJSIzvscWyqv5SXnAvX4Tde0Gmgx03NV3kMZMcx4
         Jm3/VSN3BmAwlpRzVLx8FosxhWwjoimDL7XS3+vAHmX4Udpz+EJzWPZReA8IXeLupiPD
         AUOlbqB3roR/W1e+F4JJYjAXYANv6ZDiUzpERKvjmv/J9gvmokjwWAKlvS26bX4TS3G2
         LSiA==
X-Gm-Message-State: AOJu0Yxy5t8wO7YiFCw+ZlUf+rP/9PXEwgE4NCsoo9XXjymb7jfTVuIl
	gbGVPpAuSSkGNSIFNN168WnYKKN8eELQRLmfvcymHKEpsaeOBEzoQDC42HQVXQWGtuqfRliSCkU
	4eAo=
X-Google-Smtp-Source: AGHT+IEWhbbJS00ewEQtLyEIjD1sBvQNwOlgH5wx8GG/8GXWyL49CJSgfVqkRBu67+UhsgfJV7hZTA==
X-Received: by 2002:a05:6e02:1d09:b0:363:853b:9e6b with SMTP id i9-20020a056e021d0900b00363853b9e6bmr684772ila.0.1706730410059;
        Wed, 31 Jan 2024 11:46:50 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g15-20020a056e021e0f00b0036392b9a35csm1036432ila.30.2024.01.31.11.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 11:46:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240131193750.3440432-1-dw@davidwei.uk>
References: <20240131193750.3440432-1-dw@davidwei.uk>
Subject: Re: [PATCH v1] Add compatibility check for idtype_t
Message-Id: <170673040948.3654946.6149234940803453466.b4-ty@kernel.dk>
Date: Wed, 31 Jan 2024 12:46:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 31 Jan 2024 11:37:50 -0800, David Wei wrote:
> io_uring_prep_waitid() requires idtype_t, which is not always defined on
> all platforms.
> 
> Add a check for the presence of idtype_t during configure, and if not
> found then add a definition in compat.h.
> 
> 
> [...]

Applied, thanks!

[1/1] Add compatibility check for idtype_t
      commit: b3addd05c912661b3a872382887a886d35ece536

Best regards,
-- 
Jens Axboe




