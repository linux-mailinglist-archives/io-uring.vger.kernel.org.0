Return-Path: <io-uring+bounces-4608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C35B89C41A0
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 16:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DC161F22230
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 15:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8247338F83;
	Mon, 11 Nov 2024 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K/Sn6P2m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087701E481
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731338029; cv=none; b=Nzi0E6HhiG9QNCPalIWaL/c1TH6cjU/svuyQBxTBu3XdTWweQHf0r79efdyuWDhdc2pgJMKTnyqRqUJL/8Ev6tpkVpxkTP5GI1R5FYCe6xR5aQ+N2rNmcuEJzvDQCwN/2llsa2h/YX5XRZUSGGJmi3r0bjRB72cPFB34rzsSm4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731338029; c=relaxed/simple;
	bh=CU9hEl7sfhN5wTRzCcr7KT+fx3UR6C6yIE7TLEMIUAQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AQe8S25U//LsxNf4kWcGV24LVniBRNkSKAIJiPof/qOoZkUc0Dgo5Arvh/SOFmpEWvVfkh28cSMhiveKnzo5WsSd68MuzqNcl++pl/5P4xHEE3jK+X4+Npa6FvAiYkiEvxY+7X/TnIQNDJnXIwnEBEQDUuzZ6OOYRbCu03SfQdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K/Sn6P2m; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5ebc27fdc30so2292062eaf.2
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 07:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731338026; x=1731942826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRd3PlTMOvgFhjZvjCP1kJw/zuaBej17UmSQbJlXUZ4=;
        b=K/Sn6P2m6hw/jHwqJUH1R3w/fn7SO/EM5CA4qM5SkcRq8zlKBRPjiCVKmVzXyccjQ+
         fAv6Cyjx1kzVoaEIOPU+zXvWIV/UqDniGWWxbVjFdSw/ADZrVloAZWXgJwdZrtt5h+ch
         dbnnGZL7PE9XLmdZQEdyj8pq5sYC7cf2jjvujpUe0GrZmn4AV+s/aOKtuZmeG+Ip1wEb
         Wyge3DqgUwkDGEjCqXx7ADOcD1Nj8ljjj5P9PHS7KMd7iw9PSmS+5ji7oxPHgCkmy8qe
         CzECMObkjUH2y6+3wlVL45AJDXmRpvQKoayHUNDD4ECcnzCME8JN3H0o1BmXc0xehuQ/
         iCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731338026; x=1731942826;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRd3PlTMOvgFhjZvjCP1kJw/zuaBej17UmSQbJlXUZ4=;
        b=QfEzjCAVC+RpOGVJVtaZbAD/bJF3PFEVkbE+Y7pLq+s2OP8OVKczQ/5BY6EEkvB/Hb
         l4x66LDnIriChemUFHpbw2DWzVYn0zmgK9ltE1MbHxUdeRoio3eHfN6nBNY8XlNj1+Nj
         x3SAQV7JNRum2nK1HzJMMEV//GkS1aVdtMU2b/gtrY/x1mT96rnEaTJ9XFjDTzb8xL11
         xT0gMoCk/Eal6R2XWXi1PcJzGrKrIbHHUsw0NDjF+yNlZ4ueOT9bOYG5lwWaLdpSjQkM
         4jm6903UNQB6ds3dBvKts8sV9BXvETfMSRWgiBeKxteDAjaLmkKz1dkZixW3E7Cz8lDI
         Puzw==
X-Gm-Message-State: AOJu0YxfC34DqYTj71c8idi9oqHfPoAnz8nrwdTr5U+DA4SYFQFe5zYD
	0EZIpbGg7xaqRdc7rNATXzyERsFcCohNcWCAcMir1L85E6+7YZY2lxksGkXYl4I=
X-Google-Smtp-Source: AGHT+IFpHBe3+IQQfoisPLMmDJgLqXJN9ryZsUW/xydadlPgWdSiBv25nqh35TFQtcY7Yv7/Ovjr5A==
X-Received: by 2002:a05:6820:983:b0:5ee:bb2:bdd4 with SMTP id 006d021491bc7-5ee57b96aadmr8631424eaf.1.1731338025979;
        Mon, 11 Nov 2024 07:13:45 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5ee4950f84fsm1946813eaf.16.2024.11.11.07.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 07:13:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
 Ming Lei <ming.lei@redhat.com>
Cc: Guangwu Zhang <guazhang@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20241111101318.1387557-1-ming.lei@redhat.com>
References: <20241111101318.1387557-1-ming.lei@redhat.com>
Subject: Re: [PATCH] io_uring/uring_cmd: fix buffer index retrieval
Message-Id: <173133802479.1860347.617719850207705664.b4-ty@kernel.dk>
Date: Mon, 11 Nov 2024 08:13:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 11 Nov 2024 18:13:18 +0800, Ming Lei wrote:
> Add back buffer index retrieval for IORING_URING_CMD_FIXED.
> 
> 

Applied, thanks!

[1/1] io_uring/uring_cmd: fix buffer index retrieval
      commit: a43e236fb9aef4528f2bd24095d1f348030f5d9d

Best regards,
-- 
Jens Axboe




