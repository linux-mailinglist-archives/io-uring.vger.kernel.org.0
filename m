Return-Path: <io-uring+bounces-995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E62187D6CF
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F4EA1C20DC1
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFFB54745;
	Fri, 15 Mar 2024 22:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sgp0m+Up"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B5D59B7E
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 22:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543206; cv=none; b=DZkX2vJYM1wVtPQ+zkXmp5cfcdW62bkLMUnKEU/lSF0IqQFNupl5FuRlgjdKLAtYOQ4MIiQ8S3pFViIJ0UetpowQ17L4IiIHc8uIAO5WhFyjrML2VKvobjKMkvf4Pg3ixWON3QIY3cuPox/CZwg5BZnoGl43gfEWTi5cDIehzFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543206; c=relaxed/simple;
	bh=OhKXmEvCuNMp78h7m7P2eZbVI9KaRlMXI8Yj8Jr/S+o=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cTGRVX6A7hPlYGmlJZg9Mr0KcUuJ6nJNFOzVzjrrkWN9gaLt77MBjVaNWDkjB7FWqgypDxI5T0hu3izAgBPsarsU3teYRKT3NG9bXFxMbZtUqaPv65Nhb/h8BkA8f56vyBOM7HfIi5YI3ESdtcJzrv2zR416vPuP5MHY5BLsAww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sgp0m+Up; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dee5daedf6so3712205ad.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 15:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710543204; x=1711148004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2uv4TVffDbCbzIUKrjtlEkxvow0hHJ8CgLY7cGMMEr4=;
        b=sgp0m+Up/w3jdaK2HMOTCFxtVR21y3xzvb0vyd0Xvbd1Dc3ajJA9oKh1xgwzr+DyMX
         v7Sq2YRsp+0MfpFHbeXLh4qaQ4f+rj+WJQCFJ2aAnn2+wMy0nOeToiHS+GyRG7q2G6vy
         NGVKRu/sJ8LOZc05logX8UzL3KI079joXFiLUUwYovS9dMVcjc2sXveizRKd8Snqt1W/
         9Xf4CpNvADjBOsUWMal62CQVgywB1FaQuK2MYpkyZl95IyZvVXoU1QUrOH5hqNhsB6eU
         uPLsJCpOHTe6d5mF/hud0I0o0vCiJO8EJQHBeBuYHExQsZrRZC8sBs9nXlZjDtgKAEek
         /2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543204; x=1711148004;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2uv4TVffDbCbzIUKrjtlEkxvow0hHJ8CgLY7cGMMEr4=;
        b=ErP7fBZiudVuG9DOSOR/Evf37HNP7Mcw9uSIWHsmA4i4SF7RpRtTRi8akoQ5whGQFL
         XAlq0HeRMTgzsOac+OD6YgmLeqJ8iDlZne8i0o9pVl+FvU6liJMdNwZMjM7BuipuE7z0
         EAe6BvcrSMGzyIOxWSeO+qwR3tyHR+Zr86dxiDfQc663wj2wHyCrH3OCWxhDJlcq7UKJ
         vm0mvKLMNWBoDDDwIyB4uZfwF5xaeZKHdXtkq84q6gdMxYGPBPYMYqbrohy/L7sCX44H
         UELylhqfJEEo5JK0E2aXVW+d7IsW3I4N5yzyxbibic9Zs3NVGIQrWUymF+sBwoPi3cC8
         N9IA==
X-Gm-Message-State: AOJu0Yx6UsM7rpkDpjaknEFQgnnE0sAUvrNzyohqBtUFxhcwBjmrxoLM
	j4lSuVs0epuIjxzQiVrxObWTQSH/E8AqOdh9Czbguigl97l6DWqlELmQb44q5eo=
X-Google-Smtp-Source: AGHT+IEVfDQ6nesELzZ2Rx9niPqKM0k7f5uCCaTbgDCFWXXTZ52b6Mm9CRMIyWtL3FiWpdQbCh4SaA==
X-Received: by 2002:a17:903:18a:b0:1dd:dab5:ce0d with SMTP id z10-20020a170903018a00b001dddab5ce0dmr6871876plg.2.1710543204453;
        Fri, 15 Mar 2024 15:53:24 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b001ddde0fc02csm4443948plg.129.2024.03.15.15.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 15:53:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1710538932.git.asml.silence@gmail.com>
References: <cover.1710538932.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/3] follow up cleanups
Message-Id: <171054320296.386037.8520409847690155029.b4-ty@kernel.dk>
Date: Fri, 15 Mar 2024 16:53:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 15 Mar 2024 21:45:59 +0000, Pavel Begunkov wrote:
> Random follow up cleanups. Patches 1-2 refactor io_req_complete_post(),
> which became quite a monster over time.
> 
> Pavel Begunkov (3):
>   io_uring: remove current check from complete_post
>   io_uring: refactor io_req_complete_post()
>   io_uring: clean up io_lockdep_assert_cq_locked
> 
> [...]

Applied, thanks!

[1/3] io_uring: remove current check from complete_post
      commit: ed245fa7d84f30810edf4d351ec4c483387651c3
[2/3] io_uring: refactor io_req_complete_post()
      commit: 4d441260e353cb41c718a7f638158af996dcc5db
[3/3] io_uring: clean up io_lockdep_assert_cq_locked
      commit: 1fffb93f8e102b109b351c1917af81e3ce4c65db

Best regards,
-- 
Jens Axboe




