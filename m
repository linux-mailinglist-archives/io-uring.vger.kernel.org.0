Return-Path: <io-uring+bounces-10180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0759C040CE
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 03:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7893B67F7
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 01:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F551C3C18;
	Fri, 24 Oct 2025 01:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F/d3TKAT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0138A1B85F8
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 01:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761270833; cv=none; b=oRxRMWCm8T7oYXHW2bFlFcNWQaGHFy6x9NWqimeSD1tJNv422IaxfDJM1VeA1PHmqCkEpWAo6eyxlQWH7V+rpTGuSDxzC05e/H/Xbg6m9ikTiU3EHIcdBqeN7avidOaVVNa5TURG/Nwqj46ocYNoZ/EJgSaEA+gvSQ42dlcdrSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761270833; c=relaxed/simple;
	bh=pG12fnPFVtOxeb7IxAMESfP8LT/cTjZFiCfx7wFgRJE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gEselbs+z+OmbAzHDkfb0lm6zI4WSVsFcyst/6PCcUkbYhj1c/is1JBI1sAr3DQEHWPLFTEnYwA2FzK/W+y4pCXwiS7frFGwjQkCSn8sPDcFASY2A1lQ/Sp6rcfb4hFiTijnzFROjAVR+2/OAkZJd60YTMiYGbTIcHVpn8FWPgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F/d3TKAT; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-88703c873d5so56359039f.3
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 18:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761270829; x=1761875629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pygDfrkaLzHxx3dX61woHTntyFFOYXY7PmH2lDVKrA=;
        b=F/d3TKAT2r+fXJ60CSQ8r7drocK3IRFoczoyl8LhJ2MdsKYQ9Nz+uP4rRBw5LSNIbB
         X3EF2ASnouIb4tTsiMQe7MEN6UTe7M8InmxQYxXCjOlYpJOFlDi7q7ArwrpUlsW3snvc
         icHTfkHHqp0pTxTsaEAuUIHXD/mfno2jSBs5vJRVOyrZ1aMWvoqhfDl2iK/SbpeQlV5V
         ByjYTrqMMpitfi6BkuTqIUzZDOuXXJmNPosUt0HHMf2LUjCkkyhV/FIIhPlEA5pZTSdY
         juxQPkwkQBGLR2P/L2MOmu54KPF5XIE0BcecvjY3d4QROlSQmddkdsZ9qGIk9LxLuaDp
         THBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761270829; x=1761875629;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pygDfrkaLzHxx3dX61woHTntyFFOYXY7PmH2lDVKrA=;
        b=B4Vd96YM5+X1URTrFHYb8615U1nxwUuDIEHtIN5tVOEq0BEpoBpjfarwkC4p9QShWF
         +9+CN1zTUYLizVbXJ1BTjbSebVV70CkT4gAB/j5dvBeFMnkk5ACTnIc30YytxAmpCtzU
         K+8q7mmj1nrJxgiuKwd12IJT9GJzox7KXKGoumYaQHZlg2X2lcYOMCrzLQcv+aWGvxii
         U6V1kf6d+QRwypvcsxdPA1V6R+afBmwIlVRr0Kt0cjpURvEKRWdSsm2H6rNYeqhG5nzQ
         m+Yw8eePa/DpJrd+mDGlrPRgPuvd7N5Cl7RoluCFZQJZXz2YeLDc8Nn4feUHOsODpNSt
         moOQ==
X-Gm-Message-State: AOJu0YzQ+n04DyJ2iFUT7/Bsf7NQE45WLYdSDzjWNOtIFHkLWuWlJk+b
	rdfjg8P2X3OVYAMUm3avAkAsEnmGrfE/8KA++tV4jG4pm8XhtkSBw/F/HEjeMyvtf+IlRMj/0wa
	OYn+cGVQ=
X-Gm-Gg: ASbGncukaCUxl6hSOZtaKASS+EpppUtmg/pysqkLE61/YLqTkDWWPYqYzgzatOl98Qi
	wVxkuokvH0YaRPxDMIcZv8CB6f3Jcm++LT6EWMM747fOYljNzOHBRH835rg2oFVV3BrSHuD3yZW
	b9eCV4KC80q+5MymhS54z9BrbLN/zQYkT2AmM2/mAmj1DCdTcJYKf4FXZNGVvp3ikJAQXj+5ehC
	yZZHKUZsrE3tKSoK/g1IuEjU92zwJLhDCL5Dx3IL7pLNLmlP3vGLPUghvxXlGZ1dys5JYwtgSH0
	jOR0R7ncJZTf38L4O+OSE/fRez8t8JrNbPoNA/kzFk77azkqmwWXu5+CsbVj04ZejHcidxTnECE
	xaljvKexBvjXNuobjNPOEc3TPvbKWlFFwpkLplVWbFS+WmrqRuN+H1JOyFt2hCF7wGDbVGXJ8aX
	6P2O0=
X-Google-Smtp-Source: AGHT+IEaXFc9QSCveOn5SJUMJmgWcfBmOP9kNuEVQK9BsOHXt/DISw1OAx0GFY7jZZpIBcYxv1wUtQ==
X-Received: by 2002:a05:6e02:1d9d:b0:42e:7ab6:ec89 with SMTP id e9e14a558f8ab-430c52d7823mr360222215ab.32.1761270829110;
        Thu, 23 Oct 2025 18:53:49 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5abb7fdb0a0sm1561648173.31.2025.10.23.18.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 18:53:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
In-Reply-To: <20251024013459.2591830-1-ming.lei@redhat.com>
References: <20251024013459.2591830-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2] io_uring: fix buffer auto-commit for multishot
 uring_cmd
Message-Id: <176127082821.7812.5952214714775561667.b4-ty@kernel.dk>
Date: Thu, 23 Oct 2025 19:53:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 24 Oct 2025 09:34:59 +0800, Ming Lei wrote:
> Commit 620a50c92700 ("io_uring: uring_cmd: add multishot support") added
> multishot uring_cmd support with explicit buffer upfront commit via
> io_uring_mshot_cmd_post_cqe(). However, the buffer selection path in
> io_ring_buffer_select() was auto-committing buffers for non-pollable files,
> which conflicts with uring_cmd's explicit upfront commit model.
> 
> This way consumes the whole selected buffer immediately, and causes
> failure on the following buffer selection.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix buffer auto-commit for multishot uring_cmd
      (no commit info)

Best regards,
-- 
Jens Axboe




