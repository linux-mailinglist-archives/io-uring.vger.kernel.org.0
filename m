Return-Path: <io-uring+bounces-2570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2FC93B22C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 15:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20CC51F254AE
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441741581F8;
	Wed, 24 Jul 2024 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f0WoN32e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F2A158DA3
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829512; cv=none; b=X7o2FTAA7CeKRZAnY8Uh6hJbTQPTGEp4E6gUxiiWo6hvccyrwTzhcbVx9uGuydecICx1s1GD0LbxG3ChhTaqhoQ5h5zqt1uZaoK99yu5+A/vgFgyzsmOvT9vZ02ZUVzpVDbmzdrkDpF02sNOCR76ID1mFfOOEEv+Ca/ItchTkvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829512; c=relaxed/simple;
	bh=opjUQFSYrTHATwgtzdgoQIVPkFd3d1MaRcnVO06LS4E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Pt8mAjJ+we4niymrJ75ZwVLKl6JVTuzfkvsibCeNAQITp8PtYVQUrncHTgbFLHt6uGuvicNss0RsNNSbLg92+Uduv6mQ2byL18HcYBnmixiFyq03W40js8lb48FZJ2cy31h6152E2duj6qWCHk9NfwEGxkYJecTOztBe/P2lrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f0WoN32e; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5d411d41017so490115eaf.0
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 06:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721829508; x=1722434308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yoh1TYhDM/RWcmwksHB5LWn2xq6jGH1sIPMW5iXBwcg=;
        b=f0WoN32eW1NhgUwXcN1G/XdeTx0NOkpc8D+7/xyDeO4cgp9G5EqYumFT+X2S5Ozm+E
         iWF3dDQdJKoFHGY0XU51suwcGdv9iy/d+P7+ZP9hQK0EzpYqtMUmXBHgRz0CcAsoT3nI
         hvb8xbZJBw+Sa+iReF2zMGNYepTE3BblIkOV7pedPpsIv/xDX/pBHgoP+BIl6AlKXrHE
         KOdurb+A9knS0ilmekTlE41yg98YgOVzt4vEux0PLb9GTX/DeMXm4XUQsaEMbT1rdPr9
         CxTaZ0yfZA8PiUw1kPAm/3Rxl88wXI4J6d0AyWVOrFktMtPNZd2V6tuvnO0Yswih5lAU
         31FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721829508; x=1722434308;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoh1TYhDM/RWcmwksHB5LWn2xq6jGH1sIPMW5iXBwcg=;
        b=JXiIgvprvkg+LDD2m14Kej3sP5tMNxGhUPPE2KfcN7mRiWRxTXdkwlU30S2k+IE0SO
         q/13dI2A2/XEA7QgHaq7TGm52k+oDMEaqMM44wIsdGny3LzE9ThJlHcHUvMv7PYUqnIp
         pdtTdLb8mqlPKZTEIj3PEjyCm+c6K3A7ifmDOv5Vawpg8Gn3oAneMX8ehxlLuEeVjUjH
         zaBcB6gGvEWrqO67o9ULs08a5Efald/yezhxuI3++kNuxWMMwsJHjejFJIm5P5ymZany
         8yKFSQ57S7pz1grJqnQ21vgycr3IxnhR0JY4lsf09BbQY8XzDyZSERTJd0qyY9W2jB1V
         TADA==
X-Gm-Message-State: AOJu0YzD1k4fG8zgJtEgDXA4GcYYFXDNWyfe5XXOD5DiGvZfDDNkfTJr
	VnZr0ZBZTLsj4t92aGy9L83OKQaniXEZsn1j9BXuKpKUupjbAmKA8EXNox1Onu3O7kSCslmqI3F
	HExo=
X-Google-Smtp-Source: AGHT+IETm3GJO7Ie4oYb3bDe9UDe95uoAUZaAVo0X0c9cfeWA8O7kX5phoMHAU2oN/EtI/0NS/kBlw==
X-Received: by 2002:a4a:d757:0:b0:5cd:8f2:5c8d with SMTP id 006d021491bc7-5d564f545demr7710410eaf.2.1721829508065;
        Wed, 24 Jul 2024 06:58:28 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d59ec2be86sm356361eaf.0.2024.07.24.06.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 06:58:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2a0a9eec0e5b7a69e63b705eb9fe3757f1bbd7d7.1721790601.git.asml.silence@gmail.com>
References: <2a0a9eec0e5b7a69e63b705eb9fe3757f1bbd7d7.1721790601.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] test/io-cancel: expand print messages
Message-Id: <172182950673.4497.13040104134614388901.b4-ty@kernel.dk>
Date: Wed, 24 Jul 2024 07:58:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Wed, 24 Jul 2024 12:10:35 +0100, Pavel Begunkov wrote:
> Add at least some explanation on what it's printing.
> 
> 

Applied, thanks!

[1/1] test/io-cancel: expand print messages
      commit: 6bf99f89d07f818101cc9305cb40c8c53d828a88

Best regards,
-- 
Jens Axboe




