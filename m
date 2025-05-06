Return-Path: <io-uring+bounces-7860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF94AAC6E3
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E5C51C01105
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 13:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483B628153C;
	Tue,  6 May 2025 13:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P96rtaq8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8E91F5849
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746539314; cv=none; b=jPKMKS6NGSXSD3+2iF++DahCXoNfWyWBIkDP9ndB2zlbKtF2dnFijsvbE0Zfn0asRQItmG0W3nocPRwyRi6rIV+EzUwMzJ6OK+N8qP2z66KLmHciURHRZ1MWQE8+v81R3whXU0DW/cVcHXPlzGys1ydgs9He4R1y3E8kSiwuQVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746539314; c=relaxed/simple;
	bh=F33ltflILZaO4kCD4Wzy/q5GHLExZInJUrC5PJN1Ay0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PESZpK40yfIOoSEP0Sha4VNdjejJCKFqWRA7Yz0VUYcF2QCGe3sJnKC3cO67ZY9xz6Xt7OtOFINSd3qjZUPlxJ/civ1RWjh0080o6+eR7GHvvYVzwMzJZ828ZSiw+5e43QYCF0+JToz/HvTms5Ky2Rk2zir4ehfCUNHH+7WoJHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P96rtaq8; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d96d16b375so29768365ab.1
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746539311; x=1747144111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwZo3vS66EatPpWKcNBFiFt6i1hah0QeRGJTjdHslY4=;
        b=P96rtaq88ORNphdm2vWWhyTv8bMCBisrYNjIbntDbADaTpPHYLHpZEFp0yvLP8RtDt
         PVTB758FVLVu6ye/AWZLdrd9m9MuXDGao8jd+i1Qy/+gV5J3Ubz5Zat6yqOEBu2OzWYS
         gRc0lv8uZNcAbMFj72wiSVIynB7rPdAjvOub6uYdJedvv7zKHHcpNlSFCVhsgLgN0e3a
         cTYi511qb59Ew8asTiX6N0o1RnyEogS74Y1bhnrWSHRIawgC8GuVkST5T2ijkbTAMmBe
         eDKbA5eTlNGiJtjHE4kuATSlD9X0c/gkQ9WrHhibj8mO1GFMbA+ABKSDepfBcDXpqHGt
         oarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746539311; x=1747144111;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwZo3vS66EatPpWKcNBFiFt6i1hah0QeRGJTjdHslY4=;
        b=GkaiLiNQVakXufPzrmyA3yWiRCDwdN/PWgU+Q+Dwvr/PLvGgB2FlwQNOw6jQf+eP3J
         FE3aMtcgKK3sXMxQSkhlf565s9y2nqXNxMtRTf/K0vTWWy3ngIzScmK7RRLXstfsY08T
         oWSrXjlPn2RwSl7K6Qe+3yQME7fydLQVSDK7WBBQ9s4aO3Hv1C5jesFxNMr2OkOpEi1n
         sU+Wb+jL1Yihrht86wDTJCXnEU8YsNYyXbDU1HNjwsS6cFYfi9TmT6+yb97YZJDg1kCG
         AP//d9wsYUJj4aymLA65HJ8plWOEoUpRjDGg7ozyShcKsFTxEDC/BsOMpf3NVWbZnyxZ
         ynWA==
X-Gm-Message-State: AOJu0YziYZ0/L69Za6t3RjAQftM1Tqu5+2lB9cnCiIHtJmiVd4vTYJpO
	MVFJrWb/Mn6XAOkW40inEDLSvVNdUqFZVnSSQXivfVfdfOmSUx3WWw1GEEI6HL0=
X-Gm-Gg: ASbGnctJynE8Ol3gdPWKxAEPAkMuleJponSf6IcxVwwf0EcyiqzmrQB1Ty8hxcqUNjq
	IyZk8xbUJgt8zb9+10qq3bputQ0R1HoI44+XmUuJ3DBdddmGy16HXZUEmLVXLTaW2Z/5VLYIwLd
	Y85TqvJzNHTPprzxPIbpe1nRotOtuYeEdhGGuV/ugFVmTgM8zZPkuo8wgwVkP5mHtUzBl0kD8tz
	V1Kah5lJfNYn55/66XvH8gw6+o5sW19sVv63jLqy0l7w9vqPJ81hZ/dJuJDGMndntFeTmv9QjTk
	WcODRZaz8zMOTDbBGFRcJdR7AGq79Cw=
X-Google-Smtp-Source: AGHT+IG7WE7HRobsTLuIHeNzb6EgLlDBqw2C/DFW2yv8E33HAfisJnBRcMgTyQ4uXgsmnCPMeMlQDQ==
X-Received: by 2002:a05:6e02:1fe6:b0:3d4:6ff4:261e with SMTP id e9e14a558f8ab-3da6cd50eb1mr34812345ab.0.1746539311539;
        Tue, 06 May 2025 06:48:31 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f58be3sm25930915ab.58.2025.05.06.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 06:48:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com, 
 Kanchan Joshi <joshi.k@samsung.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
References: <CGME20250506122633epcas5p21d2c989313f38dea82162fff7b9856e7@epcas5p2.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com>
Subject: Re: [PATCH v16 00/11] Block write streams with nvme fdp
Message-Id: <174653931017.1466231.2831663960512265480.b4-ty@kernel.dk>
Date: Tue, 06 May 2025 07:48:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Tue, 06 May 2025 17:47:21 +0530, Kanchan Joshi wrote:
> The series enables FDP support for block IO.
> The patches
> - Add ki_write_stream in kiocb (patch 1), and bi_write_stream in bio (patch 2).
> - Introduce two new queue limits - max_write_streams and
>   write_stream_granularity (patch 3, 4)
> - Pass write stream (either from kiocb, or from inode write hints)
>   for block device (patch 5)
> - Per I/O write stream interface in io_uring (patch 6)
> - Register nvme fdp via write stream queue limits (patch 10, 11)
> 
> [...]

Applied, thanks!

[01/11] fs: add a write stream field to the kiocb
        commit: 732f25a2895a8c1c54fb56544f0b1e23770ef4d7
[02/11] block: add a bi_write_stream field
        commit: 5006f85ea23ea0bda9a8e31fdda126f4fca48f20
[03/11] block: introduce max_write_streams queue limit
        commit: d2f526ba27d29c442542f7c5df0a86ef0b576716
[04/11] block: introduce a write_stream_granularity queue limit
        commit: c23acfac10786ac5062a0615e23e68b913ac8da0
[05/11] block: expose write streams for block device nodes
        commit: c27683da6406031d47a65b344d04a40736490d95
[06/11] io_uring: enable per-io write streams
        commit: 02040353f4fedb823f011f27962325f328d0689f
[07/11] nvme: add a nvme_get_log_lsi helper
        commit: d4f8359eaecf0f8b0a9f631e6652b60ae61f3016
[08/11] nvme: pass a void pointer to nvme_get/set_features for the result
        commit: 7a044d34b1e21fc4e04d4e48dae1dc3795621570
[09/11] nvme: add FDP definitions
        commit: ee203d3d86113559b77b1723e0d10909ebbd66ad
[10/11] nvme: register fdp parameters with the block layer
        commit: 30b5f20bb2ddab013035399e5c7e6577da49320a
[11/11] nvme: use fdp streams if write stream is provided
        commit: 38e8397dde6338c76593ddb17ccf3118fc3f5203

Best regards,
-- 
Jens Axboe




