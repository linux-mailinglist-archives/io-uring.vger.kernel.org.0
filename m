Return-Path: <io-uring+bounces-3015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E87EF96A186
	for <lists+io-uring@lfdr.de>; Tue,  3 Sep 2024 17:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 946051F2139B
	for <lists+io-uring@lfdr.de>; Tue,  3 Sep 2024 15:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5392AF16;
	Tue,  3 Sep 2024 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yUX4JI9H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C36A2AE66
	for <io-uring@vger.kernel.org>; Tue,  3 Sep 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725375762; cv=none; b=DT0++nyeO56KvUUeYIKR8E5bDk56RI4zdHSZTPPS+nsQgYmakE/iztg/6GRhis1vdUe/Kl2rEzlVAzbouvTBmiY/EI0lAdPpPc0O1n7e2qhmyIzIS1xENRbk7Ce9znISD2x6WDZmyiuzse67KfJ+BK8MnuIJut/PZwtzVrw6ECk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725375762; c=relaxed/simple;
	bh=omMDup3PBO5orDoiJavz767NR7oHdaG9Lsw6DGUH5uM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lfb+ufXQhxUk5ZSodhCXaqAE42MPAggnbIWxuV4DMCqKIxpmfD8D4KBVkOJgkj+9GbYq8PZFPWf6w6Rwkz/qbr3i/ilXTp+jWUcx22r26KsXm7cwTZuDHs5+fPHNntt8ycMmmleLY7D3XhPBUgnl7FjrkEP3+9a4mtkYJCpROSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yUX4JI9H; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7142e002aceso4206232b3a.2
        for <io-uring@vger.kernel.org>; Tue, 03 Sep 2024 08:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725375758; x=1725980558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCZGcO42skDt614yX2QBp8nx/s4XYxsCh+oEZZdlKS8=;
        b=yUX4JI9HjV4Ml+jCeFhnZlRfKZmEINqjaJ77ueM7n4TmgQDsdao4IuiZg3B++F2Jbg
         AKKjQYg3MaHXcDZd2Yf6bAWEQFVFUjv5H2duluBzbew+khQgGJwpy97f91BqyKEAV2ek
         76+XML+bliMh9JmfWi3Pk2d4100gNeeqqeBuMDRZ9EUfvGv5P1xAo7tVzdz+J1I7Hbzz
         LhhLgdryzL3leqBPXG+gp/7ZOVBS9PcEZe82xroO5s7I4+uPEWFORv1XjSh6Lu5VJu6g
         ZNU8n2EoL4XA+F/TSUE2PCE4KsNWfKJIGFqCwPs/iDBNcSYI81rEkVFjs+/D561YzbXh
         v/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725375758; x=1725980558;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCZGcO42skDt614yX2QBp8nx/s4XYxsCh+oEZZdlKS8=;
        b=uA/Dp4fthb6dj21lDANVWyMsIYsSWvGs8Vrf0Je95BbJ5sD4iB/JLcK5de6JyAqG2C
         RBGRzZgtNmg2yRD0eLlgvmf6rmyPauyLYRXmh26A/uuQE2lIzD9pW6AY2I2+9h9DHyjD
         egVP3WjWvUeC5AsBr/PVhL/whRJw9c87o9WCFkcvQGfs0vkMhNycXb8JYHgUcpttHfmw
         nqh64X4CgEf8zaki+duoCUemrZLo3IfJWS/k6t26gd44j7tlFUOui3mW0vdA2va7F9o2
         kNmkQuHO/ZdStFpWYFnKNKFIXAaTBq3azY9rXBvyutohaDEWmHdtzoisX3QBUqt5D8Dr
         Qs2A==
X-Gm-Message-State: AOJu0YxBewAv6EnQr3mSTJVT7s2USDy9NLX9O31jDbj5qDGEw5WdXZ0n
	UOxU0g/PEpOVSdAOJYz2NcymzxeL6EQ0OF/0H4hPsfisMRq/CG8jZrRlb4ZD7aOFF59IIUeyuDf
	S
X-Google-Smtp-Source: AGHT+IHAaFRYWvvB9QhLDyGbo7smWQRFzqm1NwxoN6cot/gv+3B3/2TxEE6iTQloXAJtVERdkU8ReQ==
X-Received: by 2002:a05:6a20:e687:b0:1c4:ae14:4e3d with SMTP id adf61e73a8af0-1cece4fcfe8mr11381832637.13.1725375758277;
        Tue, 03 Sep 2024 08:02:38 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e55a455esm8601316b3a.54.2024.09.03.08.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 08:02:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7c342889eb41c5f5385699dfc8e33b4d51902382.1725370415.git.asml.silence@gmail.com>
References: <7c342889eb41c5f5385699dfc8e33b4d51902382.1725370415.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] test/sendzc: test copy reporting
Message-Id: <172537575714.15340.1495883654014756941.b4-ty@kernel.dk>
Date: Tue, 03 Sep 2024 09:02:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 03 Sep 2024 14:34:19 +0100, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] test/sendzc: test copy reporting
      commit: 37db22e27cde474c46120b59d04060dd630cff25

Best regards,
-- 
Jens Axboe




