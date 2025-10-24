Return-Path: <io-uring+bounces-10203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E4BC07BE3
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 20:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EC6A19A6CB5
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF99E342CA4;
	Fri, 24 Oct 2025 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vDhsWDM7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0A62264BB
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330454; cv=none; b=cAWvD35ca64UIE4uULLcExV0GKoVV2u1cQnlj0OCSwkd8nPRpK4mRC5Sk9VLkD1HiC/lY9iYLe9fkObAdqJ/dQtHafbLvSy8+3Je0eQQ4URfvAC3+rKHokHjaEH0mkHO28ZF74jRteBwBImSNsay/r72Qx+PlieqKJ4o8AAt8P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330454; c=relaxed/simple;
	bh=x6sSvRR9ZYZDp8UXpG3nJnXTyObAs9DczGgYZmqcu7A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tdxAJwLPfUcbxmH0pBKpiRXXYp17Q07IWsLkM5e7BCILmmdw5n7FVfjO0x5yWzXuO936/8dsBRs/paS+IwJpYWQlMNOdw6k90gFtf0mbtQOtduom5WD6t8i3iEAc3arIVyHdagZ4wYDDvLl0cWx2Q36j+fmvE3AzNcXdgTJUats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vDhsWDM7; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-940d327df21so118225339f.1
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 11:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761330449; x=1761935249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5d6n6hraahHhGLalIv/rzLTEwy8inKIScQ2TyOZjbOk=;
        b=vDhsWDM7eRS0QZOmVbaMpjEvcrPUYm8BXSGYwb050bgBZjbABcFoVZSHu45Irv6nHd
         uT4LGF+GopoZo5GWFUKgeCxHZzs65tPn/oeeqtEDogtd6SVMMvkq9pgxKiDbbXXRNhad
         n1ziUh2o6PmqSPs0NBmSrfIepCmsJWk+N+5oEm2RmNNkOD5YtRx1i3qU7edQWxQx1n9D
         jzfLtZYM98RoHHPZrpQPutV4dJFjXbSJcZM81XYJKVHYclGLxLp8PekUnYzcrEfnRTeo
         IohTftdJBFpYgb+k63J5oDqNnHJ+kZf1SmFsr7pDW94eK3NWNIh40A9t4nCSvcli0Qxp
         NWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761330449; x=1761935249;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5d6n6hraahHhGLalIv/rzLTEwy8inKIScQ2TyOZjbOk=;
        b=JnLPnqIO/dPmc3wncdbNDCuk9xLWx3tEsJs2bOqXsXdkTAPW/Od34gaLe4GOqI8afy
         ahDCPexQc0HBr7YcY4obV5V/fIemeeyth2AJKPaMEBG5c7LhJMkqcy2ugbhDSccKrf3+
         6sWDfeTrhDV6rHCJPeLkmwwxnh6iFQyKy3/Ka+SAtdbS7eLlDTYH26HzkJaxf1Jhnz/c
         wVNIGrkmQz5bSDhjg7vE5IEEJIPb3oh8/ZkWhksUR4UieojYsUinZJ3+++joeAbEhJ82
         QnW+vdyc3+GGOgp5I/4nBQu5tO5+NH632WO/3yMR28zdb6Z4heIQzuQnNx/aka1jd8WD
         dQTA==
X-Gm-Message-State: AOJu0YylbluVYuvIisyjWir3DnMZfrEFQSjSAdBRjTcdy0atGg/yw46Z
	hCO/OPrG1QKAIaS2+hYSHW3+4EJyIg3RqS+nY0IsscSFnIkiPDFm9bvgF2ay20lwaF34FegxkDg
	dKni1lYE=
X-Gm-Gg: ASbGncs7qNP1WRNF+SfkP2Gts96u8O6M77kgUZfNZqge1a3Ve9awJw1dK/j6YWKsU3p
	ihfezQRomzqq93Og7giyWPthgGlWsbhMuDk5ppHfGlvqVe4wS0P5NSUdS25xBHntzFwzgeX0TIs
	gdZ4YCZkE6ai2q46b9YmOKkHqSXB415C4KZNmf4QnqNBNBXmDUb+thOlwndhjGUvJ2pVEADw/99
	6dLvl97e6zuRkaESNoVWM74Xrxu/GrUm24Q7KvGrpHe0E2srA4hVKBuSckHF+gtd54qdlk0mMCR
	wUJcVlKB0EeCCfbMyy+zl3OQE73BBOr51E/0OPDLasWpHkj6jj1h14KDJoZ+wNYK2DY8MgjYj9b
	Et5iiD/I5rBECkXgSG6Vw0Wd2X7IMRYPVDzDh/r3YPuxpCib8h81J19aR7FkbcEkY7tcX
X-Google-Smtp-Source: AGHT+IHkXSfVLP6qZaXdw38wFffbhbDeIA0lhGkRMt892FgzszlM6q5rHaABXiUOrHO9ShHq4IYkwQ==
X-Received: by 2002:a05:6602:1509:b0:93e:802d:2e5a with SMTP id ca18e2360f4ac-93e802d3366mr4208808739f.6.1761330448972;
        Fri, 24 Oct 2025 11:27:28 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94102dac199sm197202439f.9.2025.10.24.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 11:27:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20251024161636.3544162-1-csander@purestorage.com>
References: <20251024161636.3544162-1-csander@purestorage.com>
Subject: Re: [PATCH liburing] test: remove t_sqe_prep_cmd()
Message-Id: <176133044754.97108.7370712935523897769.b4-ty@kernel.dk>
Date: Fri, 24 Oct 2025 12:27:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 24 Oct 2025 10:16:36 -0600, Caleb Sander Mateos wrote:
> t_sqe_prep_cmd() does the same thing as the recently added liburing
> function io_uring_prep_uring_cmd(). Switch to io_uring_prep_uring_cmd()
> to provide coverage of the real library function.
> 
> 

Applied, thanks!

[1/1] test: remove t_sqe_prep_cmd()
      commit: 4235cf5db414884887e4b5599311c59c31d71085

Best regards,
-- 
Jens Axboe




