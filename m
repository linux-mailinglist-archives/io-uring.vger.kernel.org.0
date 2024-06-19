Return-Path: <io-uring+bounces-2279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D250B90F174
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79421C24723
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 14:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630AB1D54A;
	Wed, 19 Jun 2024 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HyN3ktYQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7620A44384
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809098; cv=none; b=KVR+vpxoFZ8BirNddX3ZLntNxYLwJuP5JETofp/f1m5hOv3X4BLcNQszf9Is4BDySEVES6y/bJjgssTztbmQwYRW6u05SmlkwDm8pEbMeIoU7Gy7btfi6QqAPT25e6bsSu+VRG20k5gPZ62tLu+LWYs+1aCEQuAgd1axfbAb/DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809098; c=relaxed/simple;
	bh=OX8lR6qShMs2zkuNrbmeXTt10gFo5rOMoOLChuGAQ8E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hc0hzGihJ4MfpVWGykL8qG3hpC/NGkgSN17iiJYELHhwAkwLHJx7WTQxOGO07cr0A7GlZ1YfML6B6bNWX2bY51LcDUdY8VeJv1AfqUZYOnjxqJ6Ti3PYsQkKcPPh7WeTtit6gUTlXdHh0tRY41Y5shI6Uu///JAsgrbvHBlaYxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HyN3ktYQ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-705c59564eeso159964b3a.2
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 07:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718809096; x=1719413896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63ET/u788SxiYcq58GwYhQoasKgFJGJSjrxpdXdnsOk=;
        b=HyN3ktYQSeDDtCqD77pYcv7zD/oXUYWAwqUGU5WAmK1no5Yj3T+LPNsAk+LhNQTns/
         xyZbqGdVMeDX7hc5k0vLJmqKG5w6qOfscxAig1U6u6/4aW5chmrHyKbiyV8cGVS1hxTQ
         qJY1EUbUj18k0cDK9nRHlxtpsoIHhczq3UBxZGfPdSqMadxzcjbAtUh2yd0XXNAg2Vxt
         mXblXKN8cE1PeA0j4V6wXI94g1O2PGKieszZo0jrpWgeU0dF/ywxt8JnDpJHK9IkeL5J
         4GSkrpr8qv/wakLWAB0UhHao3sV1KqIA5WURLtHOTd4THIwbzMVLuGv3iY+a5BMEjfRs
         kjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718809096; x=1719413896;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=63ET/u788SxiYcq58GwYhQoasKgFJGJSjrxpdXdnsOk=;
        b=mw0SVGn/3bjZnT20P7JVXfdPvWC9XayrSVCOs8GDNd3Jq97zXz+qryeA5VPhBzXoPF
         TchFFBCuvU9d41IET26MxcI3hlBt54MezYFSqMJW+62bTda8nms6WU340HV1ICeT5ThR
         m9UnV0eo5V2T3gqEwU2BuPFMM3F3A/FcXJ49we1YotpJSr3SwkOHKjV+dCz9KnXvrili
         hRNXd+eWtxRzF4D+mIbtfZLMbdUmilTGwaFQFoYSC2aN3GmPYvteuoXFwFMqmnbT4LtO
         9iGxKIfhfUJ6aFdnilOpWCqB2CqQ4Ts+XAe9l0wcfBV50ZmWC1ThBkZLLtmUnxNw9xB9
         Q/2g==
X-Gm-Message-State: AOJu0YydD0bx/JcTOnWI7yIk+i/25C9ftHokbYHwyKuH1KweVPytzj3D
	bbillEaFKz9lGdNn/wCP757rC24odIu9e3z62N5MkGFmZc9/ODjggizQSaIbLz8iTW36oe6QM1k
	q
X-Google-Smtp-Source: AGHT+IEBj6N7cHkleJ6M3chrsU4xU426LefpuqERAsuiTqU8GfgZEeQ+3xLXdiehdtXNj/aJ3n79Fw==
X-Received: by 2002:a05:6a00:8801:b0:705:d60f:e64e with SMTP id d2e1a72fcca58-70629c14ef9mr2748113b3a.1.1718809095628;
        Wed, 19 Jun 2024 07:58:15 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc96aee8sm10751386b3a.73.2024.06.19.07.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 07:58:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240619020620.5301-1-krisman@suse.de>
References: <20240619020620.5301-1-krisman@suse.de>
Subject: Re: (subset) [PATCH 0/3] io_uring op probing fixes
Message-Id: <171880909453.117549.10527997917872313744.b4-ty@kernel.dk>
Date: Wed, 19 Jun 2024 08:58:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Tue, 18 Jun 2024 22:06:17 -0400, Gabriel Krisman Bertazi wrote:
> I didn't know this interface existed until today, when I started looking
> at creating exactly this feature.  My goal is to know which operation
> supports which modes (registered buffers, bundled writes, iopoll).  Now
> that I know it exists, I might just expose the extra information through
> io_uring_probe_op->flags, instead of adding a new operation. What do you
> think?
> 
> [...]

Applied, thanks!

[1/3] io_uring: Fix probe of disabled operations
      commit: 3e05b222382ec67dce7358d50b6006e91d028d8b
[2/3] io_uring: Allocate only necessary memory in io_probe
      commit: 6bc9199d0c84f5cd72922223231c7708698059a2

Best regards,
-- 
Jens Axboe




