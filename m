Return-Path: <io-uring+bounces-7323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22CF2A76D43
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4644A7A492B
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 19:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9102721A440;
	Mon, 31 Mar 2025 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MQfBnO7T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55D6219A9E
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743448000; cv=none; b=QcQ8xAmBwD9vmPfoyTv1DYdaGU97rvviUNlDKX1elsqHLkje8PkgQ/oN2npn3yreCnausARROFCfxgs3NzJvevvaKB5KoL19+jbe8L2Mknzo1rXeMMxxsTL23pKLPF5HkqzP5ubbqRcQap9/z/w84WHEvIxUdlQFD+/5/SBaYwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743448000; c=relaxed/simple;
	bh=UEbD0SMbiHSpHz8lZM9ZTRtim8ChbPb3PzLcNMwA/Sw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oTX0KRusYLz0ZL7JRcKQbDnwS+z5splD8DCjD2E/I/R8C0qqNKA6AfGqTleS6BURubmmcckdCM9JB75VBcrqI77XvJVJ8Z9LLppyg+q/Em86QzkXJ7nHmkpjGiQdMTBZalX9psSAeHWtp7j9hf8KURmXMnzcWvL43vHLPajMvdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MQfBnO7T; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso39143985ab.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 12:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743447996; x=1744052796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4sY/4vlxdbQFYy6zbIfwtxO3ZsKAue0bG54epd6ILU=;
        b=MQfBnO7T3iUDYAx5dJr2k+uS06F/J4pYaSq/0kazPzvmI6aFtWXSCsqJQu1bsUhnJJ
         gvJGom3vg414eB8JcS57w5WM7smKprrg9i1fix4hyf/pk/xy+Ju5QfdMulqjlvA9adhP
         VVTLzw8+AVJn2bjOTEzW1zusVKFexTBjwyuLfR5gR00InbWR7I4oycHDvnHf9MrsL78i
         4d15OjszX4O4S6Jd9AEHXCRrpbAdTmqw5i9HBg0Ri/mwOy3m5euzix7M8YUs/NyLrUyP
         WZGymUxBW1wcA5Uk+aaebbvItimXx82a48HvgPwqmWFG8UbY9fhlFlJugPIOPQCk42sm
         zBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743447996; x=1744052796;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4sY/4vlxdbQFYy6zbIfwtxO3ZsKAue0bG54epd6ILU=;
        b=EIg4o8FzCQlk4PlgZq6pO+wipCMNgPNdCY+T7mdBBcLDYdubTUjFmYUF++qhGsZ0Eb
         SNKzU6IMoercJ2WLfgLFlvnxl52IO85R235jAbWQLjH/3KDA2ieVyBWLbnZcw4PTKvJ5
         W1ccclzoLNBuckolbE4NS0yoo1TGvnMtC/h8Gwrb2sIub975pe2xKO9iFoRaDKfVMWGZ
         4EDr8keqlaBf6HSiLcNLJmfH7i5eYnv9wI8tznUK67U9kNxUWXSCrR9saZdXLpwzb5ZC
         QUu73vNEnPAeNEi/iPfHVBWvcxAW5EdkO4Iy7vTXC37n/nysB/WhcePXbv+rzfoyIzSX
         P7Uw==
X-Gm-Message-State: AOJu0YybfeA6Z84B4F0Wi9vCbDBE4ZCOFzoGHRSNMyazL8WrAAHD7UgS
	PulZc7G/qIQBM2R1uPEK5aeqz4jToV8hU/nVeyzxcaJWT62wa0zDlNRLj4tIubpuhpczk8GQL/Y
	t
X-Gm-Gg: ASbGncuVRdyGlyendc8CavrDitTBMJJz5QavO/E1SynvQ8Y4AGfrfY6hjyM2AxrNxL1
	eN4Gk2YhunS2vwPGBv/gUX9dOd+ahugdTCDO6LtoepNMdfCz6zvwcxL5uxWk3amjERckNpNfBWq
	buyikivPE/AjaxYMxXFVEZtZ8hWCgaVy+2Wy0lxvGwqDiz4LERgaNcxRrIpCqOrRyPbVa1GzsKp
	ouvHoHg13GSTpZS9uKokpDtVlsLa1AjVrzuYes135DXiYWsAna81yfgZeKPcjJMxosBhiUQkKU1
	OKvoAnjWat+UkZnfZAclHPykFWxZWXvtKzLG
X-Google-Smtp-Source: AGHT+IFFAguwMdqPbkiPlokT6iOhMFlVoVOSD/+Nbb8oSL/raJxtNYIOlH9DU3DjQkY/SprzR2bKPQ==
X-Received: by 2002:a05:6e02:1a2f:b0:3d0:4e0c:2c96 with SMTP id e9e14a558f8ab-3d5e08e9923mr120193695ab.2.1743447996478;
        Mon, 31 Mar 2025 12:06:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46487193dsm1995145173.79.2025.03.31.12.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 12:06:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1743437358.git.asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/5] various net improvements
Message-Id: <174344799536.1769197.1301233276570112487.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 13:06:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 17:17:57 +0100, Pavel Begunkov wrote:
> Patch 1 prevents checking registered buffers against access_ok().
> Patches 4-5 simplify the use of req->buf_index, which now will
> store only selected buffer bid and not bounce back and forth
> between bgid and bid.
> 
> Pavel Begunkov (5):
>   io_uring/net: avoid import_ubuf for regvec send
>   io_uring/net: don't use io_do_buffer_select at prep
>   io_uring: set IMPORT_BUFFER in generic send setup
>   io_uring/kbuf: pass bgid to io_buffer_select()
>   io_uring: don't store bgid in req->buf_index
> 
> [...]

Applied, thanks!

[1/5] io_uring/net: avoid import_ubuf for regvec send
      commit: 81ed18015d65f111ddbc88599c48338a5e1927d0
[2/5] io_uring/net: don't use io_do_buffer_select at prep
      commit: 98920400c6417e7adfb4843d5799aa1262f81471
[3/5] io_uring: set IMPORT_BUFFER in generic send setup
      commit: 1e90d2ed901868924b04a1bf2621878ad8cbe172
[4/5] io_uring/kbuf: pass bgid to io_buffer_select()
      commit: bd0bb84751f2d4b119a689e5b46c733d9c72aa75
[5/5] io_uring: don't store bgid in req->buf_index
      commit: 0576f51ba44c65b072b6c216d250864beea2eb9b

Best regards,
-- 
Jens Axboe




