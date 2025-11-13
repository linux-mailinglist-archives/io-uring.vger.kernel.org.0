Return-Path: <io-uring+bounces-10612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E5503C59843
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 19:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 943FB34118E
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB5130EF72;
	Thu, 13 Nov 2025 18:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O9r/HWM9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04412DDA1
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059116; cv=none; b=Djfl4z1AU5R9hsU56r6yS7EERaoa4p2+O9ZPeD1y44TsJmTOw7lqAf0GvL+dECQs4vnk2Gy498PWYApoPOn+t5oSD3bTd2exk4AlmQvs9843x7nkZuP6VG1Ll2ckDoskqNrq4zvd43NJBqMQcjic2W78gjyjDgoPBfqe39/G5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059116; c=relaxed/simple;
	bh=kDlvCsYHY4PvuvHz4Fjw0LJZR1qUoiBBqE8f1OArKqo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=R/jnvZnFSE2ZXKugesKEe1hcLMMZ6fx9rLmwM025+Jhsq9PcfqajYTkKliut3+K2GDq6llUYDzsgjE7XvZg+FksEz7rUXDfmmdUfXLU8RC4BxoCumSmf62xves9/hnotE3Wlr89DprlSyabdkQIBDf29hbwNjIJTx9NTk9MDAfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O9r/HWM9; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4336f492d75so7250445ab.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763059113; x=1763663913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZ8asn9TjK0YeEsuLaSIUS5dAjmbIUfOXXzLmksA6k8=;
        b=O9r/HWM9LndA3mAiCnPSApeEIqrfrZz4BvzOxj/7uYcBKca2W0T9HDOZDdVgrmxIX1
         FHa8pceOfuEYrX7Vzm3Phz+4+uJs7IhVVpUqeaqBMT9WY9sS3U5N2yPOugg9CT/A0uk3
         q7h56zoqeEY11ATn+SmEVMlw3uqygEV+9pTtmjZuZOS2jPkyBaJQ0vLt2KLmFi0iJ4d/
         HkQtCJpjSHjsgqLSkI2Zv7//jiMg4x9weqkE+VDJJO0bCt5hl4Bb6SvxsZ90f3VfCzAG
         Dw5d3Hn7FmXt6GYjXLx6nhAFyURAp5lUvhEIUH5aMaMxqROtLNXpDBaSRNlTDYdriikt
         3JAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059113; x=1763663913;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iZ8asn9TjK0YeEsuLaSIUS5dAjmbIUfOXXzLmksA6k8=;
        b=FJ0M59m6+/zl+OayFF+/yXeZv1e4XYRIRdpPlr9vkdEhdB0SlKTdJm6peEmjkyuZxD
         cUvher9GclYIv5sl8vIn6PmYuHi2RfbSFgEyn/ECxAuV4d7qJ3Ij/1THp9JqhHIi54Ry
         pzVS9E5kajrlP8r9mo2qH/oFSp4KU+prLElpAXT/cyOEBYADnw2zozG1ONh0PsBgXJam
         W4cglU6ntQldjXyCdtRF68WMEFrxvUKeTtJOz33WLxbVIbviYHugI6VbwC0E7TmNfZER
         164dbwyQ55doAxCokljp5+eUKD6rjIjqPXqHcsiL438z1uWhxLSho1ivEL29KMWewG+q
         gXMw==
X-Gm-Message-State: AOJu0YwxhdamEhF3/U2o7tZz+Op5BfGkxMLQp+5Fh094DuiH9tsJILTa
	IRR4I1R0J0MMn4pXi0DacSRNkaL2yLj2hYwMOMp0OIu6DqxITbl9CdFVnBGgQ7CfQALpumjXeI3
	lAMiZ
X-Gm-Gg: ASbGncubSPO/YEuHh2EdJGl6kW50rrlJUowT1CIww7roPNo97Wdv0XtYQSwSQjyZ/lf
	AJrlRAnidODJdzlzjvLEpC8gq43IwdI7srCqPNK2YR0dObGsBjZxpRgk2A6ql9ybdnN6O9rDFHS
	F7K/DZwaEPcheE95xbkCWr1L6T3dehcjLOMg0lmWeWqbYQjfaOPpBwGWTSmvFe6rxTrIff63BVj
	++nfHtYOzqg7gW1a7k8ZzXFbHMoO8i3laLFmzUi3OZZvLZfv3rHEfG85/JrVbcttMDwbnXu9YKv
	kC1ydi27FyfKG/hdWuJi/Bz5AxNNGB9/7SFTrz4LIr23jpJeSnHp7ttRKo5mKgCa6V1Lb9KJ2wR
	nuOGkHxmw8F/x4hqdL6bc3EeF6m8zVkNeJgUV6GBE3ofLXo1+6JLiVDH8fQ/KiNvTp0g=
X-Google-Smtp-Source: AGHT+IGCjKM/6jCsPjIma3yFg9HI/bh4t6XuS3tXvIAYJC0incS19SSSBq9E0QD9vcVhxjpMbYUaLQ==
X-Received: by 2002:a05:6e02:214f:b0:433:305c:179d with SMTP id e9e14a558f8ab-4348c953130mr7549145ab.28.1763059112775;
        Thu, 13 Nov 2025 10:38:32 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd24d922sm955030173.10.2025.11.13.10.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 10:38:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Subject: Re: [PATCH 00/10] io_uring for-6.19 zcrx updates
Message-Id: <176305911172.263645.10047071731407422586.b4-ty@kernel.dk>
Date: Thu, 13 Nov 2025 11:38:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 13 Nov 2025 10:46:08 +0000, Pavel Begunkov wrote:
> Note: it depends on the 6.18-rc5 patch that removed sync refilling.
> 
> Zcrx updates for 6.19. It includes a bunch of small patches,
> IORING_REGISTER_ZCRX_CTRL and RQ flushing (Patches 4-5) and
> David's work on sharing zcrx b/w multiple io_uring instances.
> 
> David Wei (3):
>   io_uring/zcrx: move io_zcrx_scrub() and dependencies up
>   io_uring/zcrx: add io_fill_zcrx_offsets()
>   io_uring/zcrx: share an ifq between rings
> 
> [...]

Applied, thanks!

[01/10] io_uring/zcrx: convert to use netmem_desc
        commit: f0243d2b86b97a575a7a013370e934f70ee77dd3
[02/10] io_uring/zcrx: use folio_nr_pages() instead of shift operation
        commit: a0169c3a62875d1bafa0caffa42e1d1cf6aa40e6
[03/10] io_uring/zcrx: elide passing msg flags
        commit: 1b8b5d0316da7468ae4d40f6c2102d559d9e3ca2
[04/10] io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
        commit: d663976dad68de9b2e3df59cc31f0a24ee4c4511
[05/10] io_uring/zcrx: add sync refill queue flushing
        commit: 475eb39b00478b1898bc9080344dcd8e86c53c7a
[06/10] io_uring/zcrx: count zcrx users
        commit: 39c9676f789eb71ce1005a22eebe2be80a00de6a
[07/10] io_uring/zcrx: move io_zcrx_scrub() and dependencies up
        commit: 742cb2e14ecb059cd4a77b92aa4945c20f85d414
[08/10] io_uring/zcrx: export zcrx via a file
        commit: d7af80b213e5675664b14f12240cb282e81773d5
[09/10] io_uring/zcrx: add io_fill_zcrx_offsets()
        commit: 0926f94ab36a6d76d07fa8f0934e65f5f66647ec
[10/10] io_uring/zcrx: share an ifq between rings
        commit: 00d91481279fb2df8c46d19090578afd523ca630

Best regards,
-- 
Jens Axboe




