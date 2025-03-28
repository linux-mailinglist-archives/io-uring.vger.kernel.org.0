Return-Path: <io-uring+bounces-7266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66289A74BCD
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 14:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCC2A3B9A3F
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 13:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A345518DB1D;
	Fri, 28 Mar 2025 13:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OARwIn2y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B03317A311
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743169585; cv=none; b=BXRzv2hZFqZ5DqCcVEikfAExzI92yDsF8Fh086cW1nsopwcsyTmW1kobAs0eBDqUp/lyfp06tb4XZcqJ7+SbDiJLGzHdBcq17252+Ng1CxfK4whBOnfLUbYPkRCGNiUfsPr6/emPkbpGsWIDVj81sDTWpZaXOhvB4AokjKkVyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743169585; c=relaxed/simple;
	bh=Ftr7mO8UR7aWANOxKLRqVNlsbs1UR7umUL8JqTQoLPs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Rb22Bp1W+HXKuVY1fFnxvDMGBv8xmRia5DDAhoCZmnqxGDORJWJYEkuVhpoSHgLvXLYjA2lmXLINV4Uqb36zhLajf4h1BT03KTOPXbzW84f1g54jPBuWWUX+OsmVHw6pJOXE0XReeltlWfjVCVDeSaZj/uG1fgmKAeIXAm/txiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OARwIn2y; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d43bb5727fso6148135ab.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 06:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743169581; x=1743774381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ql2QHEq30UpEFsbg66M0WVMzEva5UR/RgYsaQbxO5N0=;
        b=OARwIn2ymZRbhHeMngik508ym9hOsNvyuRmvWr7rzRmtKWavyPBNAP4rcXF5BXHvtr
         als5B6IxUQVv0WKJO+1vyTG6f+X9DV/yOyuFDuyeCeNljeyN/I+eZ47HtvsJdUsxb9Rk
         B/ZCgtBvwDL21f2GxRObxKvUbahJZ9e7vHf13AUqQ0Nh1/LIifEuXJ/6aQgTmVkjLGxb
         RdouaE9CE5gvkUtHWDTuxtOn+SagOgwuvYakO8NwlZz3ygTtOfEtZgiOzoqwOpvvRuZ3
         GFmyIjHiS/T9MrrmhGQmnQI8CagRc2b7/sAGf6+2CfNt0NUcNAzqwQBZeyO9EnS0ku3k
         K2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743169581; x=1743774381;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ql2QHEq30UpEFsbg66M0WVMzEva5UR/RgYsaQbxO5N0=;
        b=uOdFn/INkl2UzswelS/vdgT5VmS9WvMjnwwg/yP0gZVQ8Q8H5O7y+apG6KnyuWKwIO
         iuEuLNHi2AM/ky3GbmZPcd4IIspT1sAQT/VsOjBgxBZIa9Rlm5hz813jWmAlb+qGpAYW
         MO83gRPoBmXOzF48oVFysBDIMxiEQQxh9+YKqynIeOf9MWSQWN5FuRNGZWEIB2sKTieP
         GkDeJAiQeiuofW0ymU58ZutRjNlHunOdP3VjS8rvX/VbMaehEz5q+z67rlxIga6EZ4fL
         5E+Cb7nQQhVfQbjh3sljJzoVpG4VAlaIBAusE71Ji0ZoH4IMpU/CJfbnHUQ9hNjDzJWY
         r5wg==
X-Gm-Message-State: AOJu0Yzqn7Vof49ZomF1DPZ9XfrA+E84td+FdHVSJ5urZYD4jxLHRcBe
	qRuylD19LZVmXfQkrCveZ1XNAddoQc7ftyLE638b2Pf2hltsEH6TR+ugbatTqVca72W1kiJ739T
	8
X-Gm-Gg: ASbGncuI13ZLd3Kd4gExk7SMXAO+o6xg2ahY2USqFpHSlfvs4R1QRVQluU8LNz4Yo5A
	HFoOD6D/vWrf4/CMsw/HQRDzNq3B6tGksmlVq653R6H8LtSJeHAI8CJ3xqMT2SiB4Ln7Tavv7BX
	omoDCQ7AUOQXzY+GuVXHlT3cz23eSP7+TAHgEnd/JQjv2rjRrtfdKakwM4ueT5stMdMjEvwqKtG
	iGnDfuGyTNn6nPjvXITiLjaPmmQ27wBVZYlESCN0nIqPL4zH+Am1mo3pKlHVQnnFxDfCw0+RnO3
	ah1UOoduXM24SD8r9Iz6WekEVqNXG5SWj4bxv1RqaYu8KQ==
X-Google-Smtp-Source: AGHT+IGGOYnN8jEBDQyNbmglhtUbgtcHikdoBwQKUlBohEur95EJSEDlizbJ4HvMWNvRHxL0RLcLZw==
X-Received: by 2002:a05:6e02:1c06:b0:3d4:414c:6073 with SMTP id e9e14a558f8ab-3d5ccdc9f87mr86815325ab.8.1743169580645;
        Fri, 28 Mar 2025 06:46:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d5d5a7443dsm4857565ab.40.2025.03.28.06.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 06:46:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4f00f67ca6ac8e8ed62343ae92b5816b1e0c9c4b.1743086313.git.asml.silence@gmail.com>
References: <4f00f67ca6ac8e8ed62343ae92b5816b1e0c9c4b.1743086313.git.asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/net: account memory for zc sendmsg
Message-Id: <174316957938.1443489.393813702831076241.b4-ty@kernel.dk>
Date: Fri, 28 Mar 2025 07:46:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 27 Mar 2025 15:02:20 +0000, Pavel Begunkov wrote:
> Account pinned pages for IORING_OP_SENDMSG_ZC, just as we for
> IORING_OP_SEND_ZC and net/ does for MSG_ZEROCOPY.
> 
> 

Applied, thanks!

[1/1] io_uring/net: account memory for zc sendmsg
      commit: f20cf4ffec98663bfa0fa234a82dfd8fd92de9e0

Best regards,
-- 
Jens Axboe




