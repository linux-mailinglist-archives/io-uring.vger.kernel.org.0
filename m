Return-Path: <io-uring+bounces-9844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F281EB899A9
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 15:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3189D1C8863A
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8330623ABBF;
	Fri, 19 Sep 2025 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kV+aHvhY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35C73126A2
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 13:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287225; cv=none; b=Rsw08SrBHG1k1JiCIsf4qZhZS0gl6UMblTe3cQHWKAK6x+i8Gx94DTibb+H2+JbmT3g2ryK20r69n3fsI77csaX1ispe8BY50YX4Jzu7HTv5VEU6XKt/tMlbZeI/Ycrd3srW/38ePYc0kSu+zubnchknWp0+WVEMkFga6Y9zNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287225; c=relaxed/simple;
	bh=ezUkGzSripbCXkMklfBDg0odBezZeSr/j6f6zuoBN38=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I++iG3tkquP3YjX7TDLpk9QlMUSS6oCcWoGzPUlsmB+AecLMR6+vEsgMVONPgYtZkyFZGdQQK+3zkwPvyO6WrE2ReC/Ys8cTP1XKTKAEGB5dd5WfPBSimOSlVPgOhQUcg2SHjrJeGSOhwO5tEo1K1gNRMuyBPeoq946bg8Q1yVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kV+aHvhY; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-40809f7ffc7so10912285ab.3
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 06:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758287221; x=1758892021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1XG1GhfcZ1p3AiaeAwqKcUahksnu0cOh+eN3hYuHdU=;
        b=kV+aHvhYnH3VXKc03kuicKYKubnyl6wG9T/QmnDEKW8QS2NAMGM7VRkILqCqhZXbje
         bCTFkofnvbVt1DCVomy89KurSSw9S5rlrTV1dorxKXyodJykn5nNamhTszQg+tBg6SlE
         72YpEXsdYQ+qkLI/cqJ22M2K1Q7C7WW9kQJHazS5wZbFM9ILS+1/tX1hRAwdRUskf+jB
         EAo2e/x8dOPYxd8k6k7YPGRsIptxaePjxq28zvdonB9rYr5CfYd9+8SP5TeA9hGvfTxM
         Yna2fwM+Qusofx18UIpcyhvIe2V3N1haK8saJ9LMrY6FLNb3mf5nadjpG0CKax1Sw7IX
         7nJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287221; x=1758892021;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1XG1GhfcZ1p3AiaeAwqKcUahksnu0cOh+eN3hYuHdU=;
        b=rs/C7N5NYCe+FL8sF7y8t0r0tyBX4bxzhub41+LBCWB4BF2LidOnJsgRUKlKqcGbo6
         emudBMUS/lny16bK4BB7guv2wfWjeShP28llRFHTdZjSxOuz05gzHd3bzzc4Uhqgqp2C
         hm2KllZDenoacUZJUKnSE34xy6lVaLAF6+GeFALjl3qJvHQLv+ezbDHeRqWIgZz/Hrqq
         rHoIHCRq2BqSMv9isYCqZ5eSvUB15s99eG+L/xbrxAt0zXIzWzKv9etUwk6XgzNmjWgM
         I9pE3EleMijbUs5EWVmaRj+PajWIMOIwbwZiarprDCNW/fLSzvzDTfPWxVToK3YBDsC2
         lg7g==
X-Gm-Message-State: AOJu0Yzx5XQhqnlBJRLdASuSDDufBgzS2LjOnE5bSuHumRQxgMwwuhiS
	6lCtRZ4iBXouYIyhk1TgZkaKFD8Nx7ZG6Yo5pRRrRd+c1flRAJgrNhX65RvL7S1ltPm1ubqG0+F
	+gO5+RXY=
X-Gm-Gg: ASbGncsaTp7xwtPdEgzZOjaUhYLrvjp1Er8ywHrd2hyvOSwVr4J36HiCNzq+nOVPqoS
	WIi/cyeFAFEcb9IWZ32KEmiNe4it64SaO2qk4exbeM4M1A303zRldu8dEHL40DguStqCo3wHHS3
	ZFImLYgUwTo26Ei3zD/l3hg+2/VPriV3prmd8WI5uWkpwvFSNcv7yRfypXExuAu7GEg5N+MpmDJ
	HtQD9bzu6O7IKDnE0kfHKkattSjRoX5APPiGwhJU/DOsvZYzmuzhGfctyA1wO0Cts5w66txkkyC
	GhGLdMACtsTPpbFhTqmEokHZj5ce1XYukhSL7ngWmAo+dCSbaxQL3JFwGiYOBuArIYzzqcVSlz9
	hPSw1CNs16QBIuMUWpt/hbcdr
X-Google-Smtp-Source: AGHT+IH74r0h6JDg3snvxUQ2rFZjPgd0f/AYZKblP78baNz20GUME6MKlB0jBjdgQTH01h/mJsbcFw==
X-Received: by 2002:a05:6e02:17cf:b0:415:2b3d:651a with SMTP id e9e14a558f8ab-424818f925amr44798525ab.7.1758287220650;
        Fri, 19 Sep 2025 06:07:00 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244a682a59sm21582855ab.16.2025.09.19.06.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 06:07:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1758278680.git.asml.silence@gmail.com>
References: <cover.1758278680.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] query infinite loop prevention
Message-Id: <175828721983.844104.12045181166094956070.b4-ty@kernel.dk>
Date: Fri, 19 Sep 2025 07:06:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Fri, 19 Sep 2025 12:11:55 +0100, Pavel Begunkov wrote:
> Allow users to kill the task while it's processing io_uring
> queries, it specifically targets cases where the chain contains
> a cycle that leads to an infinite loop. Also, limit the maximum
> number of queries per call.
> 
> Pavel Begunkov (2):
>   io_uring/query: prevent infinite loops
>   io_uring/query: cap number of queries
> 
> [...]

Applied, thanks!

[1/2] io_uring/query: prevent infinite loops
      commit: 2408d1783204920880f929a7a3087c76f5a59c13
[2/2] io_uring/query: cap number of queries
      commit: 7ea24326e72dad7cd326bedd8442c162ae23df9d

Best regards,
-- 
Jens Axboe




