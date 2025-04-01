Return-Path: <io-uring+bounces-7357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F321A78310
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 22:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92EE43A5AD9
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 20:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2872036FA;
	Tue,  1 Apr 2025 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="da3J4u5G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D592320E703
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 20:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537688; cv=none; b=icMQyJ9SvMD4PxDUHLJj5J0ILKDvTo9u6gHfTOchexAZtf4ZOAej5v2tz3ERvTrZC8DFfFwKNVX2HvXE4pHGoIAhPcHK00m4FyIm1nJv1vosFA6UqL7utKfPVyVZ0YBu6abjk9geZ6ETwSNEui9rRNbf97uzrDLhUyao0rAc5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537688; c=relaxed/simple;
	bh=In1rgmFBQqKxM1mgtiPiCz8kBa9TjDo7+F2LTZABJm4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rqD4Mo3gJwWtQ61rtGpv+USyHg0xbOLwDu4MrXpqBFDQQnVrabV4hQVwTuawJOSDDBZkDINfM0HbMEdtW0G16HcYconbXSnmKzfktl6rbd3hQMsTRF7eQ/gaO6n9IPl8SI5eUk4H3GRCwCK/Nw7gwGcvi02c65Dmh+leEkuHTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=da3J4u5G; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d434c84b7eso46479785ab.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 13:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743537684; x=1744142484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMwxThd281wiK0Jlxdgoo8MpXrx3+u68HuvM9q2BSFQ=;
        b=da3J4u5GtlFmE9I8S7+zWLOpMP2CW2B+9K4J5gSOI3uslMPHlicErGvRJWPuV/P7gH
         Ze57RPagPihqPvGQtH61ikvRxtSEP0hmGRXSymZbpNBYbCZMj+n3MhMdOamzmzg5XTM3
         IhZI0F6x8gOaqkJv5TteAbtCjbb2NfosLyusHNbpc+/4Sl0AVvanl9PRLcM2lRAWO+rc
         iEFUozDmdHgDRPTVnsqnEp11eCKyMimS8iZtNwi4rYTjjftAWae1zg+gv5NDlcP+bH3d
         uHpk2r41vs2SG1ALZE2VDs22WQ04QeUbP4ahoUGVan8YqW/uDb3c8AZCJnXTkQUda90j
         z34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743537684; x=1744142484;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMwxThd281wiK0Jlxdgoo8MpXrx3+u68HuvM9q2BSFQ=;
        b=ReMWmjaq0q9PsAB6v2uRgaNUprzeF8y9TRWq/4Te9QD9k464INd59Vv75n/wklNE2h
         r/BO7iKWajgFbL4EwtiwDgCWvp+yLnS0Ob0hqCfwUXSBA1T5aUUtkh5oRLprvLmxj4hX
         mB7qQmTQb4Nl6R31nSYgHIKTD/o09r135gKPLkdrh/hLgIFNM7DRZ6g08mqk3kImazRE
         6Iw6TKeRGO8if4bwKrs9F7XZOEX6rrmqlBvD6MCDepcYRGnGD8DaSBaP3A523T2uVfFZ
         1yS6L/UIx4ZzC2c97//GyLbonjKx6rw8FbVEGIWfzLP/Md+MtyRCwb9Ujs35q1t+o7Sz
         WKoQ==
X-Gm-Message-State: AOJu0YxUPpyXXArHCo03pO/QmRc034gM4gPkq7S7ME3PRkTna2G7C8vv
	kvUFCv2xAtvL8xRKd9we0/M2CoFKqwNEKp3gUtvTyqLJcI+E4lJlHQgdcTGIGtg=
X-Gm-Gg: ASbGncsUAte/iF89GaWKdoFS1Ku24LVs0S7abLFT4KtM/rtT7CmBocN86oqXDGeYAQ+
	qfUqMn3Fp42csU+oPxeoPvd0/FqfetQ9R9VDx+0vqN0dTuP6p7l2Kvp0tuXRdHbHqGRRZo4qZrC
	1awVQOnWbiSNm7aLcFBv5AxuBBFqdM2pV6MP6WZlwRXWq1sKmrKPez044Np8fUZhH8ymI7QfA5X
	6ZsSaAwEtc7sb7uwDWuQAiZPxvOVXTnPaXA8mPKLGHocwvtY/v5BFR9R6HbQuIYeMqMTpkT18Gx
	cJiW3syoBJs/55LBd6P/uZkYrl2xYckE2SGJ
X-Google-Smtp-Source: AGHT+IEXiAzlVFQpFCjHtiCVeEhiTiCprlSg63SPPerwYHnEWE9fs96wCbltrXk72katz/DjJYW2Fw==
X-Received: by 2002:a05:6e02:988:b0:3d6:d147:81c9 with SMTP id e9e14a558f8ab-3d6d1478328mr24175235ab.12.1743537683818;
        Tue, 01 Apr 2025 13:01:23 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d59cf415sm28969925ab.0.2025.04.01.13.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 13:01:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250401195355.1613813-1-dw@davidwei.uk>
References: <20250401195355.1613813-1-dw@davidwei.uk>
Subject: Re: [PATCH v2] io_uring/zcrx: return early from io_zcrx_recv_skb
 if readlen is 0
Message-Id: <174353768310.1901497.13958732292797416142.b4-ty@kernel.dk>
Date: Tue, 01 Apr 2025 14:01:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 01 Apr 2025 12:53:55 -0700, David Wei wrote:
> When readlen is set for a recvzc request, tcp_read_sock() will call
> io_zcrx_recv_skb() one final time with len == desc->count == 0. This is
> caused by the !desc->count check happening too late. The offset + 1 !=
> skb->len happens earlier and causes the while loop to continue.
> 
> Fix this in io_zcrx_recv_skb() instead of tcp_read_sock(). Return early
> if len is 0 i.e. the read is done.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: return early from io_zcrx_recv_skb if readlen is 0
      commit: fcfd94d6967a98e88b834c9fd81e73c5f04d83dc

Best regards,
-- 
Jens Axboe




