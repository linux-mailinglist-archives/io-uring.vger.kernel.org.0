Return-Path: <io-uring+bounces-9824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBBFB5A0AE
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 20:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D88357AEF8D
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 18:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2632D73AE;
	Tue, 16 Sep 2025 18:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0SZdHot0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CC914E2E2
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758047860; cv=none; b=BCriZ3xyLWwbBX8gSQrZIQ/GWDGJtVollEjrj5Q5qyWVfWu/13U/cYlKXpqr1i1DtGdSEseWgZx2a+6nzXs4E/ou6pR/s9WQas3dqCYoxwTaSASQmHmXkH+qkpgh54NGyvPpjFVaArND5bC3vraywYj1YxzqxHXCu4BqajJJ9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758047860; c=relaxed/simple;
	bh=rN/jo/5sC5E4maX3WWr2oW11NMAVvjpBx15n5Ts+Yz8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=S6rbGialliMPiZBTA5GtIm0IVYFNf+0TNyQKzgC9SqmALKEf1zvX0OEt/xTLtjMWlPI0WTRLLoL7jb5mKpaoTiQiuyryY0l04Rz2zrHIRRIws7FgSiTQfnGL5td9UcsCX/j6Ni7sv7xNwsNoh5jdDVkPBAfPBQC8eGYSQtNCya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0SZdHot0; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-89336854730so93032839f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 11:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758047858; x=1758652658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0SXbkcQGPwwHkITWoViQ+ET3skRPP4oXVS8ZcpgxqM=;
        b=0SZdHot0HLf7wwZv79yYDTWxxgXsIGvAyeUsnv7Fs0nb5Yjsqyl/YobSkH3by3rOxf
         /sIfg3p0aWJw25Bt6yGTSZZ9T2Tzyp3HH60S2IyLEiRrVsKnxd3sa3AQsLPeo8lJZg66
         6jyN3K/T4g9f4+ll4lG6ZR6oJVuxY3IYJftGegQt2cMDYXDHCjZ08zwqa537ElHNBuTW
         So3ED0iTimGq+NlCwhZOGAkTbDK0SfyO2MqMZmT26AxwAGBwdhE8/4jkpY09Fc+19dU3
         tLhXhq+OVCPWiS+JeASkOwjWG/WzcOdWOcigsg2zrkuu0rMzSp6ErsusssijIyF4uqGi
         7KJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758047858; x=1758652658;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z0SXbkcQGPwwHkITWoViQ+ET3skRPP4oXVS8ZcpgxqM=;
        b=io0gEC3NIUJqS4KYvc5zu2cj1IUtiNqFATwmZlGmHcX40rRfH6MBG+vOVkD0SIiIZp
         PpJgHB77SoVfu/p+5VWnpJTb3wHFomQXVE+vfrClkFi3MQQLqTsGJCH9QbxhUOeB2fmq
         A5c+x3q64ROP7CX0QJsef5k66xFoqxv2mC88LwcIGDwIxB224gq3AiIPadbjGy1rmysk
         EHcGUyWm4Lxu3sFLeDit/aF1bTnMZvkQmNhNcnzQO1G0S2bvBoWCRyIJ8P/QRCto3i9q
         DZqU+dztSO3krJbR1fCMhmb4e8cfDHcqNXfAFZ6M1KmmhkHucGttxsOz7pzEQUUkuNhg
         oahg==
X-Gm-Message-State: AOJu0YxCuJt8hJyjuQZyAEe7c3wTb7XwfAXZll4bUrclyWs0suT1cno2
	en8kHRV2nxwX3gQKDFu3C0dfVJPLKkXR6iSfMn1pEti/rFy0om0HJknSoeJHINuwYne3hFyzgBz
	wmFG7
X-Gm-Gg: ASbGnctAsf7DBYQhIEa3MBdWEKbGI2Qy7mIR2X3cOPY+Hr9xFe3sa+3ayBXAdOniIT5
	YOK/LbizYuGQUQpaOKHIbRiVGmKsXHQ7P1P1z3YwVa371609B21oER5RclwnH1iN/Li7APytzGq
	H0uVPrpVUCHNnBGz3xMD/pAIFF+7wtgfsU+vl+xNYR62IwA3n6OPFWK0pO2+/5zrQXzIReWf1ku
	cA+pT2+fAW+kmZ82bdKwfVdwfuvAelcQqGGIZy+vSKyrMuawQWpRcOnS3WNTaZ+hGdLKAv4nvPw
	hzAPGy7CZ1xBJuhvZXbxaoi8X+2NrFe9HXgENWkFebJLiYipzFhXkVc9CbG1sOQvRn0ZwceBm1O
	6ADZC6DhbUtP1pQ==
X-Google-Smtp-Source: AGHT+IGJRlPq2xs2KrnSiyYADlgw7DCrjgkZgehz/9Vy/rlLFJSiUpO9LvRKxJQ3oGCOynZcYXo3rw==
X-Received: by 2002:a05:6e02:3801:b0:424:596:a474 with SMTP id e9e14a558f8ab-4240596a636mr73116055ab.16.1758047858032;
        Tue, 16 Sep 2025 11:37:38 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-511f2efcd0csm6121195173.5.2025.09.16.11.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 11:37:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring for-6.18 00/20] zcrx for-6.18 updates
Message-Id: <175804785727.344121.4196119067317346525.b4-ty@kernel.dk>
Date: Tue, 16 Sep 2025 12:37:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Tue, 16 Sep 2025 15:27:43 +0100, Pavel Begunkov wrote:
> A bunch of assorted zcrx patches for 6.18, which includes
> - Improve refill entry alignment for better caching (Patch 1)
> - Various cleanups, especially around deduplicating normal memory vs
>   dmabuf setup.
> - Generalisation of the niov size (Patch 12). It's still hard coded to
>   PAGE_SIZE on init, but will let the user to specify the rx buffer
>   length on setup.
> - Syscall / synchronous bufer return (Patch 19). It'll be used as a
>   slow fallback path for returning buffers when the refill queue is
>   full. Useful for tolerating slight queue size misconfiguration or
>   with inconsistent load.
> - Accounting more memory to cgroups (Patch 20)
> - Additional independent cleanups that will also be useful for
>   mutli-area support.
> 
> [...]

Applied, thanks!

[01/20] io_uring/zcrx: improve rqe cache alignment
        commit: 9eb3c571787d1ef7e2c3393c153b1a6b103a26e3
[02/20] io_uring/zcrx: replace memchar_inv with is_zero
        commit: bdc0d478a1632a72afa6d359d7fdd49dd08c0b25
[03/20] io_uring/zcrx: use page_pool_unref_and_test()
        commit: d5e31db9a950f1edfa20a59e7105e9cc78135493
[04/20] io_uring/zcrx: remove extra io_zcrx_drop_netdev
        commit: c49606fc4be78da6c7a7c623566f6cf7663ba740
[05/20] io_uring/zcrx: don't pass slot to io_zcrx_create_area
        commit: d425f13146af0ef10b8f1dc7cc9fd700ce7c759e
[06/20] io_uring/zcrx: move area reg checks into io_import_area
        commit: 01464ea405e13789bf4f14c7d4e9fa97f0885d46
[07/20] io_uring/zcrx: check all niovs filled with dma addresses
        commit: d7ae46b454eb05e3df0d46c2ac9c61416a4d9057
[08/20] io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
        commit: 02bb047b5f42ed30ca97010069cb36cd3afb74e1
[09/20] io_uring/zcrx: deduplicate area mapping
        commit: 439a98b972fbb1991819b5367f482cd4161ba39c
[10/20] io_uring/zcrx: remove dmabuf_offset
        commit: 6c185117291a85937fa67d402efc4f11b2891c6a
[11/20] io_uring/zcrx: set sgt for umem area
        commit: 5d93f7bade0b1eb60d0f395ad72b35581d28a896
[12/20] io_uring/zcrx: make niov size variable
        commit: d8d135dfe3e8e306d9edfcccf28dbe75c6a85567
[13/20] io_uring/zcrx: rename dma lock
        commit: 4f602f3112c8271e32bea358dd2a8005d32a5bd5
[14/20] io_uring/zcrx: protect netdev with pp_lock
        commit: 20dda449c0b6297ed7c13a23a1207ed072655bff
[15/20] io_uring/zcrx: reduce netmem scope in refill
        commit: 73fa880effc5644aaf746596acb1b1efa44606df
[16/20] io_uring/zcrx: use guards for the refill lock
        commit: c95257f336556de05f26dc88a890fb2a59364939
[17/20] io_uring/zcrx: don't adjust free cache space
        commit: 5a8b6e7c1d7b5863faaf392eafa089bd599a8973
[18/20] io_uring/zcrx: introduce io_parse_rqe()
        commit: 8fd08d8dda3c6c4e9f0b73acdcf8a1cf391b0c8f
[19/20] io_uring/zcrx: allow synchronous buffer return
        commit: 705d2ac7b2044f1ca05ba6033183151a04dbff4d
[20/20] io_uring/zcrx: account niov arrays to cgroup
        commit: 31bf77dcc3810e08bcc7d15470e92cdfffb7f7f1

Best regards,
-- 
Jens Axboe




