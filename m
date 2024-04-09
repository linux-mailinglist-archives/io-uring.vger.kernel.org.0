Return-Path: <io-uring+bounces-1470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2029089D149
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 05:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D73DB286E23
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 03:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9370454BFD;
	Tue,  9 Apr 2024 03:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NN1YyfRr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214854BEF
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 03:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634351; cv=none; b=VD9xSLdotcuEdTt8N2Yq3gFpEOUCt1mnEKo3DzV61QLW5/C6kHrzuRVyI95MHl/jrizgfeg3Jd+z2ItEBQjT1jaDy80JuZNzDNFzgEWGQViVULuYC65j8iFYe6s1z1j9300MmO1iM6CzGs32JmRErGUx3dmrZ3GUdPiUy91DrBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634351; c=relaxed/simple;
	bh=1NxODQkY+Gv9H3Xy0rp/6meGZ3S9tLqs81CNn39f8O8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dMoJXC8ZSgpjgXAvFaT8zVuZKNsHTGxRAnjuYCMH/lE37PaBcHBMEbUM3qWldWuoui3TCXCYz6BGdfiseZ6bagSqKEf3HvacjBDkqqevuvANTWBwLTvC3obKmFcpxLYNrkhMtiHnUQ2mrqBR8ippm72prXd+WD/QhADaA6UU9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NN1YyfRr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ecf1d22d78so767659b3a.0
        for <io-uring@vger.kernel.org>; Mon, 08 Apr 2024 20:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712634346; x=1713239146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZHGGsoE1i+pQeakhOl9HR1IhFbrKzDbcOA6vTVDcrg=;
        b=NN1YyfRr2lSbYWL5sZxnU4+O+iiSsLzL3J8JvqXFS9w95XNBmPFXrpylUIuKEVqF2u
         JIKZ/MpSLy52MQEkvy9DFn2WhvNnJQlDxtfNnSwMHuaBokdSqkUM2htWgX/alUzpIwHU
         1KXRdS6zW2axqotuGMKanphGJGfjsq7yscHRJ89eDGHNshVWLSInnVFtXRlFnOJxq1A5
         RUJcOVjGJuR1gpa8O+/k6UPCGbkxwMesv+3v7FsF+3OqFJKhYZWgCEpaBhNtQfTpNYnx
         HnJk+UzLTBJ1MFvgIwQMxgHsQTKKOpfcYLveTZ0iMpkolQPKHsaPyuERZei/OMKX7BfK
         I5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712634346; x=1713239146;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZHGGsoE1i+pQeakhOl9HR1IhFbrKzDbcOA6vTVDcrg=;
        b=kn6MWaBh+OhI60hY0zugRDx5a0GxQyfWyyXtBoDdUjbPLtBv7HPH/WuuM0+xPe5ELe
         n3E81A/Ed4tQMCrHBTndUcY4uPCD1kjuB11qP03kYFj7XIJRVIaGY7ST9UaD4a4TkOn0
         EN50ImhzAW+jcMI0x9PMB8MVMwmqiA7Vbr1vPaB1vXC9JVdVTrOkn56mHQexs517NhZw
         MqcG9Ny5ZC48cTMN4Eu50OAP/ouVmWDxFsZYhHpTQjW+TPH7xmIBGkLRST3F0DqUb1cp
         mBtKpH2jmus+35zf+IxkRGDAIvbv8YrzmtdJcrYQKSTZELTrQh3+tzoLvyq2c1R162qi
         tIrg==
X-Gm-Message-State: AOJu0YydfYz1YMZQKKTDPwSYY1Ol/m7k2ymTmGvSezDg1LlqxJJ93DZt
	7VhkkVfOTVZY67jlaCuAdGoLRVnp0YiYGd+qkS1bm4ZZ+O0N4ojKnwL4fLWZ8sI=
X-Google-Smtp-Source: AGHT+IGy06SIzrCZIqLMHaNfF8UPTKSI68YT6utmb02yc+KZmHVnytHQNsRH5P9cPGvEdddFk3pt9w==
X-Received: by 2002:a05:6a00:8602:b0:6ea:6f18:887a with SMTP id hg2-20020a056a00860200b006ea6f18887amr11071508pfb.1.1712634346602;
        Mon, 08 Apr 2024 20:45:46 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v12-20020aa799cc000000b006ecff8dd3f3sm7131664pfi.74.2024.04.08.20.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 20:45:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1712594147.git.asml.silence@gmail.com>
References: <cover.1712594147.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/3] improve sendzc tests
Message-Id: <171263433514.2851061.5891322468318359362.b4-ty@kernel.dk>
Date: Mon, 08 Apr 2024 21:45:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 08 Apr 2024 17:38:09 +0100, Pavel Begunkov wrote:
> There is enough of special handling for DEFER_TASKRUN, so we want
> to test sendzc with DEFER_TASKRUN as well. Apart from that, probe
> zc support at the beginning and do some more cleanups.
> 
> v2: don't forget IORING_SETUP_SINGLE_ISSUER for DEFER_TASKRUN
> 
> Pavel Begunkov (3):
>   test: handle test_send_faults()'s cases one by one
>   test/sendzc: improve zc support probing
>   io_uring/sendzc: add DEFER_TASKRUN testing
> 
> [...]

Applied, thanks!

[1/3] test: handle test_send_faults()'s cases one by one
      commit: a305179d22f982f08a38162c13fe1f6fc8e99ab3
[2/3] test/sendzc: improve zc support probing
      commit: c3db7e08833abc293c50b75b14e617be5e5592e4
[3/3] io_uring/sendzc: add DEFER_TASKRUN testing
      commit: ef3cae5022b717ebc495e39df902d85b83f402f5

Best regards,
-- 
Jens Axboe




