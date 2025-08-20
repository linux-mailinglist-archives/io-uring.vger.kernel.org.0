Return-Path: <io-uring+bounces-9110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87203B2E4D0
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 482DF3B5953
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFB9277CB4;
	Wed, 20 Aug 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LZri2eju"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE1E2475E3
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714052; cv=none; b=D/JjZ6VoqHRb5YkdSD/UkCOamqOh67dF6oVzF/Z5sB7OD/DFN64/cPchDh9WBZ3e62VsJQy/qtxzsTRW7A+wo5X5lQ4eC+yamMMignd4alvpTgter0mCQdiXr/+LITE8l5uik35VRojpSiHcjRCqEL7fMbazNxnIoU5Sc6pMKuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714052; c=relaxed/simple;
	bh=zey4XONVvFxHjI0gtI5h05ycNT8ASKG6v843qt122Yg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gbDyfXFuLEVJCwatshO2TU1C4GfWSckZEV10JSTfjte315pHeJgMKAn7WklFR6d4v/Xc1ZacqQksEzKrowIAPFzwXZT8SRVHXAfgO3jilWn43UTpFvoI21YKUbPQIQhJt1UXdpUMC4EBWv/t77UEimTDByCimGnfuiCjfM7PTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LZri2eju; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e575ff1b80so620755ab.3
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714048; x=1756318848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=435nXqVjlL0JkQ0ZM5A+LE+59BKcMyUZeVZMZMkbCNY=;
        b=LZri2ejuSAuK4WckX/oM54WLzk/fFfRH4ytbPuNVUXzjaNk7LNZdbtmBore7YgAJGD
         ZPp2hpA0HUlIewKFJF5KSDqnbclB/or+TwI4IbVY5p4pgMN7Gv6Hn4Z7RMhkf7L2kXL+
         1XiVLGiwUcdJfJ/xDGxuekpfQUAl5P1WaWnDgOkwEfVIYxDZKCY0HZb0VDuoAYczOSqD
         Dc6Sy+5QLuHDuDczIVid3+wNOU844Kzku4PofSRqwwDW82cud+TqoKBFfK5WAmqPCvxp
         AzsB9lTU9txKiyQC/CK0hKBx3NDRqIx/YEEO80c0vul9k3p0s5OH17xvMkB1tyvM+9jx
         9F0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714048; x=1756318848;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=435nXqVjlL0JkQ0ZM5A+LE+59BKcMyUZeVZMZMkbCNY=;
        b=TFAhxiYlpBtXeCGPCKEVih8ffSYshYfmC+Vpv6BBy0E1ED+/PYuctwXnJdXAO4El3l
         sEK5wzvsr3mxQXeQ0shb97M4b7TJpl28pwCv6FL3cJN9yOwWEEZaXH+e1dFHuL6u8Wz4
         racBsjV0WBkLzEeHEa/l9Jx4p+j5niM2bAIf3HdgRa0QCUPo7DgfHStzUL5UrXu7/Z08
         msvfHr8xEOThZLc080UjafXhxStsnZMbcabTexRzG/wugR/eeAxQ6WK2bmWAqDnbWaGl
         2UkGX9qtHpiIi0jtsHGlnAGkxWrkxbAuCxDPKSsHyrOW6bwms/8FAWtvEgIPdziPVBjP
         mPsQ==
X-Gm-Message-State: AOJu0YwI/T9f8c4UTwV6CwFOtjyTdkgvEUSCmbqevrcxErprF2fhAhQs
	5FeThobFpqDT9AgE72LuuWrym/fhvXyZuLgc7P78D/7DxWXzn9Ah+BxY/Z20vg70A5fYs1UO20R
	lBzFF
X-Gm-Gg: ASbGncu42R8XlzOdil9y6X+zlOHyoGNnvr2K8kDpafY/rmIVOqsRM0wPthRp9SrFLbZ
	rSxNos+SFPJ++TBassmA9bc9YP/bJ1e6SR0dOddDP7PIACPsNyABajT39P3O/KwqE9WQCYxF5t3
	zc77sJJ4eUdpGg/wE5ngEqctIXoXCzhj5U2/n5WqDzIeUJW34THAG0iDPS1XvEa08nl8ybFXxyQ
	2ANPmLZI6+X85aWRyt7veLAyqe5C9t2jnShfccU/776TX792YbSQxfPLrfUVR+pS0KqG/OjGF9h
	1Vt0UNmrfaFFHclLXpHHyaYNlQTHJZooe3pI4bzUyO8Yj7B5f+mszL3twup1I6Yg+Mtb014V79z
	p7uBQFFexskQ58Q==
X-Google-Smtp-Source: AGHT+IHlFcN7T2Dv5Z37EjzNjRyYmq5iumqj0B7xHA2eBYzhQO6xxd8Hw8QD9qy3SXGT86k/JEAV0Q==
X-Received: by 2002:a05:6e02:1a48:b0:3e5:58d7:98f6 with SMTP id e9e14a558f8ab-3e67ca0c15amr67594835ab.14.1755714048093;
        Wed, 20 Aug 2025 11:20:48 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cd34sm50335665ab.20.2025.08.20.11.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:20:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Subject: Re: [zcrx-next 00/10] next zcrx cleanups
Message-Id: <175571404731.442349.1181916932270747722.b4-ty@kernel.dk>
Date: Wed, 20 Aug 2025 12:20:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Sun, 17 Aug 2025 23:43:26 +0100, Pavel Begunkov wrote:
> Flushing for review some of zcrx cleanups I had for a while now. This
> includes consolidating dma sync, optimising refilling, and using lock
> guards.
> 
> For a full branch with all relevant patches see
> https://github.com/isilence/linux.git zcrx/for-next
> 
> [...]

Applied, thanks!

[01/10] io_uring/zcrx: replace memchar_inv with is_zero
        commit: 4c7956ee3605011e3c868a76aa5f5b8808380f8e
[02/10] io_uring/zcrx: use page_pool_unref_and_test()
        commit: 32c02734932ac71eacdd0d799f136c0dcaf4a01c
[03/10] io_uring/zcrx: remove extra io_zcrx_drop_netdev
        commit: 9f3cfd0fbe4cd2a26e43f1dddefa26a62dceb929
[04/10] io_uring/zcrx: rename dma lock
        commit: 4857be683fe694be4367ae18873e8c18533cfbe0
[05/10] io_uring/zcrx: protect netdev with pp_lock
        commit: 4e913a5d41c112979d67d35ffbefb5bddd3ff3a7
[06/10] io_uring/zcrx: unify allocation dma sync
        commit: 5a3b2e8a4d0483073dda20c0b5fdf8f6545bb277
[07/10] io_uring/zcrx: reduce netmem scope in refill
        commit: a4bb98933134b5da7cefb20a668c22ea018921c5
[08/10] io_uring/zcrx: use guards for the refill lock
        commit: fdceaa88004a091461180045b084856aadfcce8d
[09/10] io_uring/zcrx: don't adjust free cache space
        commit: 5f55fe9517f23692f622eb24e7f4449fdc2a8359
[10/10] io_uring/zcrx: rely on cache size truncation on refill
        commit: 093964677b89452896b8566c47d9af8e0f8fd8df

Best regards,
-- 
Jens Axboe




