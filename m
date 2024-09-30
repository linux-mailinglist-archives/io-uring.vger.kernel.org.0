Return-Path: <io-uring+bounces-3322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B8298A6FB
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97E401F23662
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 14:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFDF1917D2;
	Mon, 30 Sep 2024 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b0fe+nNQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7718E758
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727706517; cv=none; b=s4emw2hIsoEvo7fiV/V6iJkSLxysyxR1vj0X3qcLl2z1+zxvTJkIEVMmuxkfcCDWeOZkApJDP1yKbhp3zLU5xauOYbz2rcey9oyJT1/Y1/rxvmBNn2xYbyCuon3iCwYwW/gzrXOOlbdWLXCHv/07R5acrTdXVoJ24eVMJzSFkWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727706517; c=relaxed/simple;
	bh=bBVSiJX25m+WPlZvfuHL5ROgTzF6c2wBzusl+2CGUOc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z2anqhv5HPUXpJklotRN4fku07TGWK29KRFf9S7xlgvypBBH+Wn+2SbxBrKLvw82hGZO4enaMulXbA7YKF6S5EvhH9bgTTH0E2MhCxlyfwvF/DEwY37XUo/owYljGu+2rBpcyY+3C3sabaT5CRW9T1weXLnBzxGnfDn6n6DJm/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b0fe+nNQ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8323b555ae2so217661739f.2
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 07:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727706514; x=1728311314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqGV2Lo5/s0rcnoZDRPEDnfm90Ew2ZxNitl1vue4MYU=;
        b=b0fe+nNQJZLuFB5jLZpErU+XumSkknLDgq2clL3Vl6F7j5SFTi2pS0Vw7QtUJoXu5M
         0lLxpBIPg7zmZZ0hOhS6ZnpD0aJ5FjHj4QKawuBd3KnINTPx0zwOv7A2Jsgeu46Mvbch
         rBY8qeVgleHozyczdoc4Q6VcYtI8fX5qYnEuymBf3OAhsgbiTQh8U4+ymf14xyXZmEp2
         jTdDzuOUD/7GnJRGz4jELjW3p+0xtLdz4Y1sCeDYdnNJHG2BW33rIy5+tl8sT+24QGnW
         CSkgPPuWTlpoq5qbmULUehzSxD1QU1LhD8w0ys2+QLKngccnrxPsLuW//O5gDlzrN5Hr
         gcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727706514; x=1728311314;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqGV2Lo5/s0rcnoZDRPEDnfm90Ew2ZxNitl1vue4MYU=;
        b=UiJt7JuIHRPnGbtiJw0C3Y2ONgKEQOZLdR53KsTB7i8aStPnzkKBXpIHFbHpbbmbWw
         UKtWz29pzIOQk/iOPbLTEqpO6QlUfzrK2Mox1t72I8+oL1tPJQ1D+AUEBRbis7c1RtyR
         GLW90OZVHXgq1hHcZQjL5lwP7u40TerG7LuCo6aaTTkDT17KxWtwILIYyJzF78fJsVxk
         SBFlAIQNAzvpl8OImDJJmZ4AoydHGkWxKr/Chz6YEV4RQdV1SooMMfuFjjE295v3HoGb
         W+8A3jqX8x/A1rlknR96j6n1GerdKqtEVUKB1d7QSNDkYQRynnwYS/vYDI5QjpUs21eh
         U+4A==
X-Gm-Message-State: AOJu0YzuqzU116MVMp1kr2SN/VUeSIQW0f3U+n3GF1f+PZi4LPkVc14I
	ZUomdSxvuHvx/MxcjdXBZ6t+khoyZ0HELjuKlccctsK62rg6sGuMo6PSWcfsBpE=
X-Google-Smtp-Source: AGHT+IGZi5cKd7y/sm2iFlSzObB11MvRsnsp4Bw4+PlgR+68Ha0iEB/Bac4amEV7I4hrgkBplyMUgQ==
X-Received: by 2002:a05:6602:14c6:b0:82d:d07:daaa with SMTP id ca18e2360f4ac-834931d40abmr957727439f.4.1727706513738;
        Mon, 30 Sep 2024 07:28:33 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d8888d9dc3sm2124611173.150.2024.09.30.07.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 07:28:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240924115932.116167-1-axboe@kernel.dk>
References: <20240924115932.116167-1-axboe@kernel.dk>
Subject: Re: [PATCHSET v2 0/2] Add support for sending sync MSG_RING
Message-Id: <172770651308.9692.15486643196195243301.b4-ty@kernel.dk>
Date: Mon, 30 Sep 2024 08:28:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2-dev-648c7


On Tue, 24 Sep 2024 05:57:29 -0600, Jens Axboe wrote:
> Over the last 6 months, several people have asked for if it's possible
> to send a MSG_RING request to a ring without having a source ring to do
> it from. The answer is no, as you'd need a source ring to submit such a
> request in the first place. However, we can easily support this use case
> of allowing someone to send a message to a ring that their own, without
> needing to setup a source ring just for that alone.
> 
> [...]

Applied, thanks!

[1/2] io_uring/msg_ring: refactor a few helper functions
      commit: 6516c5008c88eda9137f0985f419e40d3fc7cee1
[2/2] io_uring/msg_ring: add support for sending a sync message
      commit: d1e55003c13ca95878afe380ad3da89d37d63b1e

Best regards,
-- 
Jens Axboe




