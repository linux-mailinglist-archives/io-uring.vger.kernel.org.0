Return-Path: <io-uring+bounces-6894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99937A4A812
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 791D3177E71
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C2A1B424F;
	Sat,  1 Mar 2025 02:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="So5E9MlT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8391B5EB5
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795825; cv=none; b=rD0/e2CpLtlKJkiamgIwcuhxrEvd67XemZyrq/bUaHJAsvIhmXonk3nplw1OPTF5zM6sMp0DoaJ0fWAWght2ykBPvr0ylYCCSmpbkCDs7SxX1WeU5aDIEDHwR8wuNe+RiDZ/8wMIl7lrCbnTcKjBEkMCvlF1ZRb+tHmm7Ef8HDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795825; c=relaxed/simple;
	bh=xY/UISVIf1atfvS7OMuZEMjN7lkQ/iikiRcjhdY1uUg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fjqQBmSwXU4N2czjyrEqbwfeACUVqZ6dK8uGzDGC/mb0p33wic0ZSjuuGP9lhKovBH+VNVBQ9VwDVC0vNofFCOyFg/xfmyMQpnKaGh9wF2eM5U77sPD9++IDkcbmRmGRPmG+KC/UHgo5z+XBpD9f28Jvc4EUoN+/ACaiEKsTsTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=So5E9MlT; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6f7031ea11cso28214577b3.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795822; x=1741400622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfDYi42gjS+u1iz1GYPicfPXnoYEpE1W6/kuhPU/S5Q=;
        b=So5E9MlTlRzDmw0c+Z4XM5pR02TWjJnGjE8CZXyLYRLmebSsbsoyvn3pKFKGmET1kR
         sALd7G0wtFM8fLOSwdwrksR/jGxMCtqIqkmKIqhP+PNsGMpu3pkK/niTppJhl+cRT/Pp
         uxtSFNS53wGjqbOzPSZ+sKJ3SyyXqjxhIsDwcVhAMoXJlVY5OLg3NKQc4wWderLrfUA2
         HI/u+NGSLEFmcW+Ur2yC7SdbTzaC0+WEik9f3xYNNJO9geDlSuhYOsN4EEwVZynCHLJm
         Gis1J7py7xM9Jm7KBQ80IDMawiTPMGGFgocDebvZg4nCE+Z0jdWWkbbkpzdm+rs5BQWp
         38xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795822; x=1741400622;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VfDYi42gjS+u1iz1GYPicfPXnoYEpE1W6/kuhPU/S5Q=;
        b=dwWLXaaqTTtkrfjmiGc6n+r05dQHBPDU1WW/fHvgs/XEiZAqWY6CTB8nr6Hauriqgq
         oskdX5c4tzKBtTc1bA4DMCkb5U4fD6FWnHYVDb5Ss7P9w8ypK9B+20FF7zXlvi/bHFiT
         79krru+RrUAlChfONO5kZGc/lXn0X0v52XC9Z7a7SgVIYoXfnENCNTjCxSfs2lAKiYsI
         KMl5gkW/gOghUn2wONzcY5A9+R8vLfWDHqzwAzgTl+doJ/QsfBpH+HtUWvgvrN0Ktu7/
         yS53GJWwRgb5SaspvLvDerHeWtpYdcLuE/961JELcqWAxl0bYcjQ5bV/Casx0Rq9EixD
         blOw==
X-Gm-Message-State: AOJu0YwscSsbanjEhgXDZ9mMfwrsFWJzM9iCyGDZvSMFGL8gC4fXw7FG
	3u8/900GhkLyxxcwEymKBqfGjYOlEoVvQRdYKJL0lrxhHEBO9uDFT8BjEd/dP0ZtUdGVxRsQqve
	d
X-Gm-Gg: ASbGncvziBYAG8oYfdGdlkvYH9TmBUQNf7wmJDM18HMIbNCqLzh3l3vI4dTYntUcjCB
	RfD2qVydrBP6oHqhKwXavQGJeb4+/rT4UiVuoZ5fu2NhxERNNKD1laKdEspfP7dy8b6IsnPmU2H
	U3kEtFtDLuMZTwDFptVJ25GbfbYqo5cFQ1xD24/VjPJjFcSwhJeiwG0omskUzonKVLZxdPmvYXO
	sc6rA2eE8aR5JxAUJ1mtTqrNpUKou7pDtq2c4X5APBMgBKdo+tAqYJC96ioByRsUxKAHHW0KMDz
	Phl+vk7kj/cOeKSdaUA4jSo4fMds0zFy9+NkPwA=
X-Google-Smtp-Source: AGHT+IEBXBECUiYtnJB7xtAXg6I/62QADZwXGKn1Rg9EBrqtWsNXbyRRrltHVGhBDMtUTvfcTG7yjw==
X-Received: by 2002:a05:690c:4b8c:b0:6fd:47b7:9730 with SMTP id 00721157ae682-6fd49fb60a6mr78166737b3.12.1740795822147;
        Fri, 28 Feb 2025 18:23:42 -0800 (PST)
Received: from [127.0.0.1] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd3cb7e02dsm10175307b3.84.2025.02.28.18.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:23:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250301001610.678223-1-csander@purestorage.com>
References: <20250301001610.678223-1-csander@purestorage.com>
Subject: Re: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in
 header file
Message-Id: <174079582102.2596794.10638072394312089078.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 17:16:07 -0700, Caleb Sander Mateos wrote:
> Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
> other files.
> 
> 

Applied, thanks!

[1/2] io_uring/rsrc: declare io_find_buf_node() in header file
      commit: 98ddbefafecf270d51902cabfe289df10a702cef
[2/2] io_uring/nop: use io_find_buf_node()
      commit: 15d86dd9019c7a97bd8c5b6880870b97e7cc74ea

Best regards,
-- 
Jens Axboe




