Return-Path: <io-uring+bounces-9557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B75EFB42D76
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 01:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CC72178FC2
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 23:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00562E9EB2;
	Wed,  3 Sep 2025 23:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NWncxyKv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803C52C21C7
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942579; cv=none; b=KiiDvY04Pqv4bTTBKxGK0Qn9KUGjlYoScxxZZxQ89CytrjoRsL6+HlvyOUgvROKQc9J8ikt24n16gjpplX5vs9Yf6KfsUsJ/9O1BnMd+P+GONGVHhRdJVopZ3HlIiXg9l9ydB+K80aAHlnXNc5KfWt56lSkqroFPrbdEoqkAvlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942579; c=relaxed/simple;
	bh=gAF0GiYG38lA1kzBT/F4AXVuSYamIxae9UhNShfBNRw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jxT6pNdKnNS+2BcHhDqHxG293M+MEPgJ3hv3kcr46lq1O+7wPnP6kKkUryaybaOTXGuoqmFFUiHmdHkrdOADdO7ZBgyuS704h16JiXFXVCo1skni6fBp3wZrtW0K8tZfx35kZrAOzwPl5FTHOBShblt4niDC54Kw5NltJwAuAFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NWncxyKv; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3f663c571ffso3716075ab.1
        for <io-uring@vger.kernel.org>; Wed, 03 Sep 2025 16:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756942577; x=1757547377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3JW0RPEGedvDyMhg18Ej09/52eO1GVo+v4uJsO42ag=;
        b=NWncxyKveoabsn3z+9DLuwrMusOrfI76y8WSYFEYpYI3WMqh4ZvgO5Hz8Ud4ACZBiD
         LSkT6PUccFmLu3Hso3u4DSImRAfllLsRcbV7RbCmYN77j5GWq8cPvfCkH5u6ifjwxvd4
         NJ9vpRJWcF4irps3uj1D8Yiid4f5Zds51i/zAcE4yf+c6AyCJaxVymSi9Y3x0YmCGg5x
         eTZ2V1vki/796HYiwQ/47x+0Ae7LzNcFKIybO/e9g3MW8xJifi0R4vmjDkZnTtaKiM2y
         vTNtwDaAIIhF27mQk8REIrUdPp2wZburjhcqHaKvpD+90iwAKn3Ma5tIjIDjx5p+bsUX
         3AxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942577; x=1757547377;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3JW0RPEGedvDyMhg18Ej09/52eO1GVo+v4uJsO42ag=;
        b=C6ucSyxUTJaN+Xy0WSX1AfRwfbHWdjkZ3f9IHysowGhP7dwcFoKl7fsnxfphvE+4XH
         fe568Mpb+wM8UH+ZgoutP5Sn1M9ctMq4ydCdwBn3xkhFpfKMWnkQlLBj/RYFrY7WIJbR
         Vool86HjYz4jL+JuSwzLi5izlEJNAH/4BK2UNnh1SgAgaS21MWHQudMLnSDYgK+D4kq8
         hAXkRLxf4jM/g7S9QSSSyLYQHjyPRjkSSutWC8mwUhZ8rLiOCi7RXFN+bpsdFkvNzc+o
         6TWrPy03OhRWYA8bLg1dAhh75CuPIUPnOZvjxLiLlSCMPFUWynT/nQTI3P1GdiIpj8Iy
         W5Ww==
X-Gm-Message-State: AOJu0YzbPMI8bSwh53D+XVFi14iwQBLYyWItJHFsb3ye736dCU0iFOiJ
	xivlgY5yC8/RZ6qdl5MQ6itGBr0//cLG6XJZ8yp4udvj5w70Lsh5nQgbiFGyUYgywxEGXYO/t9a
	8/RY3
X-Gm-Gg: ASbGncsapqVQom6QipNnnbNfEan4gdXkeDEdip3JPG3rjGI8VjFqaSd0cNe1zHNH36o
	ntsWTYYNTQ5VLsPCPXK4PJz0GiELUXF05uTaimwEbkXpMFbMeK5oJb83QFJAp3ZDb3uHyEkgYw8
	CDKfyl+oeibKODIuthMmWR3gIDTtsoUkm9yOIETnuOJsRLUyTplioNS13iIh34alHaxfdk53152
	PtIovvClOZRJZpxzog8HkgJSEc/NOOaisp6xCu4PXzJYXhxtnYzpjIzzMf3H5ljgP9brr1f51Cr
	NNcu4b27YPMuiViRJm2Fo/MML9k+tKGR7z/yK+FCTHFz0D06HcIbzuS6Jiflwp0yBgM/zzhMC8Y
	WZiWLa8hROFsmxUGbj11nc86RrThQBYjMOBaE
X-Google-Smtp-Source: AGHT+IFLC+slb7ygMZMPUf1vPhWF5HAfFWl/vv7bO8M+ywB4h5W/s7tkIfjyPaDbgoWO4qBqUg8Zyw==
X-Received: by 2002:a05:6e02:16ca:b0:3f3:2812:417e with SMTP id e9e14a558f8ab-3f400674082mr291578545ab.14.1756942577647;
        Wed, 03 Sep 2025 16:36:17 -0700 (PDT)
Received: from [127.0.0.1] ([70.88.81.106])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f65d1ef2c7sm18736855ab.5.2025.09.03.16.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 16:36:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250902013328.1517686-1-csander@purestorage.com>
References: <20250902013328.1517686-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/cmd: remove unused io_uring_cmd_iopoll_done()
Message-Id: <175694257558.217330.1674546709065281273.b4-ty@kernel.dk>
Date: Wed, 03 Sep 2025 17:36:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 01 Sep 2025 19:33:27 -0600, Caleb Sander Mateos wrote:
> io_uring_cmd_iopoll_done()'s only caller was removed in commit
> 9ce6c9875f3e ("nvme: always punt polled uring_cmd end_io work to
> task_work"). So remove the unused function too.
> 
> 

Applied, thanks!

[1/1] io_uring/cmd: remove unused io_uring_cmd_iopoll_done()
      commit: 9f8608fce90fbcd2a98ceefad0bc762423927629

Best regards,
-- 
Jens Axboe




