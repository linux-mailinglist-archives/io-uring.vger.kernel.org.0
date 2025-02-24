Return-Path: <io-uring+bounces-6675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 548E7A42354
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 15:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85472189B7C4
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA0718892D;
	Mon, 24 Feb 2025 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CZkL9ICs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D39414A627
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407747; cv=none; b=cl6+ASKcIvYlJsKP6r9b72GDCF2LDzzdHKugv9HsmH9wdFpEXbl1Feh5iQ7DY4j7RGOkm8/dOFJRLorY/STP6Dxmd7ZZ+moBoNSoeXrwLFgC8Bo8ZmbZbvYkckx7+4HmQy6DqxwmDgea6TS9hyr17yWP8ggop7WrqeEHfyqYiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407747; c=relaxed/simple;
	bh=cRpmTSzHUv8GWFOC6l7b7OZL/GW7j96VrCdFlOeR4yk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=URwrA7QnRmglhBSIVBLX07YKftm4Cj5OUBHdmctyFdJGIr8m/vn19VbD3nj8CSBVloGgByTnzpLeNYVYBSxVjUmnaL4XkA74uIzcmHsrqu0Ve/N30/BvbDgdU+QzkWDSZ+fXf4AIpWlZTd9NWnuwwqUHzqMMJtrfy3dvdDhc6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CZkL9ICs; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-855a8275758so116491339f.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 06:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740407742; x=1741012542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QF6IEiWwKBwtoFhDm1n/kU/NRjbqtNHB67mDn+284o=;
        b=CZkL9ICssj1QuyJ3NSBj3ypJXrubJyjybDHX6xglYozewqfIkSsBEtlN9FLY1zI4Hx
         qt/JdVQb8PA8vujADml51uJ9K8KTS28MF4le9tODUak0l55qKHKIvsiFSJltutdUY4C+
         vQ1UfjGs+5lmygmd/D4RRef+VYADjNZ0/xCYRTZnv6mJMzDguC5fKlEllWihQAr37nL9
         2zHgzICuIUVokNoh4ku03gAA6Nb898WZxkf2tH1yeJcPrw8XxWdlepaY/NTzIYiNwYv4
         lIwGuyWHNhT71jiTEyWBLa6Oqhf659iMxjO1u6oewSS0xNKZbMhm8IDOaVSCaBoVzBWt
         eixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740407742; x=1741012542;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QF6IEiWwKBwtoFhDm1n/kU/NRjbqtNHB67mDn+284o=;
        b=shrVi2LiHLOnsJOH8bn9+hvoyPuqU6hUjf6yBfO95PImPSkzT2gSQXEaqqQMRJly8N
         d/tqBiRsIgjAXSgNOXHF6wVYplIF0biF2xdaik1YbbdH/32E8p4uGBTz7cRzZMJczHLz
         kBBc273BHZ8Qv8f2LK4x5r9w36Bagr8BzLuEQfbSr8YqfeWiSCqzNVb2S4IM+AscxC7c
         V1iOXkV99mlqv6z0Pdj9/uamkt+a8jESYaaabzNmmjP3tfvzBsQW1xQlXhxGshWVpr1C
         2GuCKiyYGQtt5EtT/1dukMjdbfyhMRp3zh2TO0rVANs4vEU0CHprm0ZMKZigsaK+hiNg
         NCDw==
X-Gm-Message-State: AOJu0Yy0JvVZblU8pIawXf/VEdwQ63FHBgwlBfaxYWlM+i3a1qXNwEh/
	59qdtfUoiJRTz8aw901iKrct0AtnX7ez6hSH3XXT7pLEgu1oUPl0cR6qY0Rai/c=
X-Gm-Gg: ASbGncvD4UXU/5ifHs/L/AU6J7mS6W45F/LuJmrU+mYJ6hdkcAJK/9FKKVPXBk0FPde
	zvjllkI+qpb8xXX3R5SZvxyz1gMrxi3y1851BCME+LlvQ+OZHJffd6WWVzwepTgEyPp3+d+x+Pk
	lXYDODaGw93N0AQL0rPmLAfTjLO30SX5Ys1B8J1AQmE9HBz4Bkm7WNPgUDX7OCjKRv2dsjCOknF
	0vweoArOnAHnK9OgrtrEEQd5/NdvSmq0sa/uSnpUdieU4p/wZQAIeEX10TJO9y+IVlaLVXqCMYO
	dpZHlgfUkUIfOIryBA==
X-Google-Smtp-Source: AGHT+IEeudc0WIuFHw5ejAHuJk7R7cceyrHA3oUkuzH9WLpPLdOdUBIkhC0WBANTKa9EEicjpkxs7w==
X-Received: by 2002:a92:c26c:0:b0:3d0:4700:db0f with SMTP id e9e14a558f8ab-3d2cae875cemr151171915ab.12.1740407741955;
        Mon, 24 Feb 2025 06:35:41 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2b2fb94d7sm27876985ab.36.2025.02.24.06.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 06:35:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>
In-Reply-To: <20250224041319.2389785-1-dw@davidwei.uk>
References: <20250224041319.2389785-1-dw@davidwei.uk>
Subject: Re: [PATCH v3 0/2] io_uring/zcrx: recvzc read limit
Message-Id: <174040774071.1976134.14229369640864774353.b4-ty@kernel.dk>
Date: Mon, 24 Feb 2025 07:35:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Sun, 23 Feb 2025 20:13:17 -0800, David Wei wrote:
> Currently multishot recvzc requests have no read limit and will remain
> active so as long as the socket remains open. But, there are sometimes a
> need to do a fixed length read e.g. peeking at some data in the socket.
> 
> Add a length limit to recvzc requests `len`. A value of 0 means no limit
> which is the previous behaviour. A positive value N specifies how many
> bytes to read from the socket.
> 
> [...]

Applied, thanks!

[1/2] io_uring/zcrx: add a read limit to recvzc requests
      commit: 9a53ea6aa5c87fe4c49297158e7982dbe4f96227
[2/2] io_uring/zcrx: add selftest case for recvzc with read limit
      commit: f4b4948fb824a9fbaff906d96f6d575305842efc

Best regards,
-- 
Jens Axboe




