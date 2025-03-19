Return-Path: <io-uring+bounces-7130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F32A69349
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 16:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F2947AF1DB
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 15:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727DC1CAA7D;
	Wed, 19 Mar 2025 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F7oM9l28"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A551BD9C6
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742397995; cv=none; b=luTI2qZDVFbFHOafLfvujung90DYha5ZvGMRW6eCUdKA0wn712qD3aZ+2/gBEBKTDDc8ikT+zeP9EKh8UVZKrVjHCMetCae8YLtxnf21f8ZMsZ+C4dSwbsDeQt/8KklvSwtvIho9yDAsTumYDcTI94LzJLdM38/KzBjz4qzR+PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742397995; c=relaxed/simple;
	bh=b6OGf6ty07rhqd72Rca7OnvW4KUA/qKgWWNZmFcHBF8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cds2R3LfqzC2LqVxl1wVuy6dCAcoEIticoQCYHWobhm4J275QaTrZcNSn5KrMpvLVmZYpqY8DiigDcDhGNSSWwAHd8cB/fIxzaO9NDjh1dTKHU8xv2BjWh/PmdmRUIyXeMbf88xBUgoDb1uW72/SAxR/NT89/4lvf6gzMAuDorg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F7oM9l28; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d589227978so2231685ab.1
        for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 08:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742397991; x=1743002791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6s7stxj6j02Q9GM2Q+eifwtx2fkSLIEYuHEkF4Kxt0=;
        b=F7oM9l28PN32B/udFja7KBDY4deoNldFRvcNzN0nXA3ZGQoxW0WkOhvOrTLQIjTFhX
         kcFOX961epeGJdJkW5dWlUTNJ4OzONPClAtI/eHUNcuxbH8DkvMLjreaWfb5AhDYqEjG
         uhChtoWVGJfyjm/3GqRBa4jwhXjT5dSn7OPM4mtNaGPqjRM3/x/B/fs9eTkLA2nPDhii
         qAkKO+wy70ZPomeK6H0s8yes4HIAXlmEO9L/egyP4o3lkqkLJw/Vm3LMxc6F3F/emHPr
         gJEeiaiDsZ2bgFy72rj9gMyx8rimUaLRWHufduSKMPvKa6hSaHXO51F1LxKdaJPM62Lt
         Q8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742397991; x=1743002791;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6s7stxj6j02Q9GM2Q+eifwtx2fkSLIEYuHEkF4Kxt0=;
        b=pY2m/aBGBYynVYrRCUGI8G+gB4UxAOSlMnDOdD1tPPY5dSqBSJv042FX4dYFv95jZw
         ArFXEsrcfwar4LFR8dXW8pU/Eq+60lTccAE/sUe9cPZN8iWV8r91Do5+l5AMlP1XT41e
         5/5GuqZq4YZhbJShMFpRiRJpKcL8sxb3bvPtmjHEEwnXbn6QE2yyvvEJp3C8pEecr43d
         E49Ksmr12p+v4lAyaS1xRyjN+LnASYcVH+JVabWJOeoDeap4fVP/DtwJQ9yhbERXT5gk
         ZJt717qNoAfk4YDZ2/4nXtrmzEI+lBk0WX+r3knUSHC9wei++qo5yuza6kZ8UkcEr3MD
         W2gg==
X-Forwarded-Encrypted: i=1; AJvYcCUcMRhZB95iiutcBcOIdvn43BPYLaZunCIzrVuQo9TC8FDqajXqCX39uS7E0YKxuLhWOAzSjBtpFg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yws+umFrqfGPdVdrVoLUEMlomX2U3Xj/LGQOxbvKh5w4Dwndg09
	g+7w2ETYInf3p9JUmO3+jMQtCrkxdYteER302a0I6uIphM6UG61jsfkHdF0WNvJa7l4zcTG6PpY
	c
X-Gm-Gg: ASbGncsrrr0BKyLHkaF9lsp4oWB0553lAmW2KS43OFgyMyADweLfPLb2yVgqvXCTsLs
	O/NF8X+KdCHBpPn9hncvNbEYLuPh3G3E4qANuFt5ZL5uct9zF993jzfNDvmp6szkgU2IznMhg+1
	cpfXw44XVJmR1jqnB8JD1eJWTJhcNMPFHE1HuoxPE4Nw/nSur0YqCTU9iM/EV0q5KynfR72TvvS
	Box4yLFqDKSzvIrqn/CP3Ww7JZfHSSG5WGKrk1GOa/Qtf/7TWUtrCMSx73kfI/DiN50w2B4m1n9
	qrP2+vy7NHaajsesBbv+AnN8ytf3dRy8800=
X-Google-Smtp-Source: AGHT+IEPszl/ebd/oSF2Uq2+SIS8aH9d2S8RxCBgdwIWLD2tLo1SckfHzcpZd8Mmqb1Lnvr1oYw0lQ==
X-Received: by 2002:a05:6e02:c6d:b0:3d3:d08d:d526 with SMTP id e9e14a558f8ab-3d57c4448b1mr60362905ab.11.1742397990791;
        Wed, 19 Mar 2025 08:26:30 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a83850esm38761295ab.64.2025.03.19.08.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 08:26:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Sidong Yang <sidong.yang@furiosa.ai>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org
In-Reply-To: <20250319061251.21452-1-sidong.yang@furiosa.ai>
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
Message-Id: <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
Date: Wed, 19 Mar 2025 09:26:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
> This patche series introduce io_uring_cmd_import_vec. With this function,
> Multiple fixed buffer could be used in uring cmd. It's vectored version
> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> for new api for encoded read/write in btrfs by using uring cmd.
> 
> There was approximately 10 percent of performance improvements through benchmark.
> The benchmark code is in
> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
> 
> [...]

Applied, thanks!

[1/5] io_uring: rename the data cmd cache
      commit: 575e7b0629d4bd485517c40ff20676180476f5f9
[2/5] io_uring/cmd: don't expose entire cmd async data
      commit: 5f14404bfa245a156915ee44c827edc56655b067
[3/5] io_uring/cmd: add iovec cache for commands
      commit: fe549edab6c3b7995b58450e31232566b383a249
[4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
      commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d

Best regards,
-- 
Jens Axboe




