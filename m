Return-Path: <io-uring+bounces-8485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBD8AE871C
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 16:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5103189326D
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 14:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0DE1D5165;
	Wed, 25 Jun 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2LJqB9Az"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB29F1D6193
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750863161; cv=none; b=pRJIgWuoU5ghSG5kRc3YZOASSZFenj6kqDVcqGt2WbH51vuu6bKJ6w/CsLdod2iz8lDa8y3OmmdA3OkR50Tw9eAyhZ8SPn61cFnpdTTlv5TBsZUk8IU8s+MqGUa9A/FrL+C6wLk+Fevb7qbsl2qKOjgBtVxzjAEFHFY8r9ybuPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750863161; c=relaxed/simple;
	bh=blqNeUBeq4tjvuy/9Ly0dt0wfjN65t72jilSiX/+g7U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IVSJAfzZOvP2h7CshKgvr5wu1i1l8JAKDMSI5PXoFasAQ3CaUPbQ3kFJOhJfrJTmm9hRV9dKobhjzlbViCoKd535f8BTMq2bCYQE5BW5KmQsQbeq2qeuKaf2iPlt0i7JQ604sBjrxfUbtF8Pe3+Ao5z5zjTBnCqyGjxbEadTXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2LJqB9Az; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b1fd59851baso4666733a12.0
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750863157; x=1751467957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wz1Ak0wbeYwkM41lDzZf9Pz6IYC6aH7Ol1qRTwbIEuM=;
        b=2LJqB9AzZ/XP6a6SKHG3xY37oXE3RqXGG3LcZhJij6/Co6eFDabh/uXgLX8/9TWcC6
         Af0N4vTCc3YK1w1bHfG3NcA6cKhJGAzSiI3upkLqc1/X4zvCkLyitbeSBTl+hRDr7ifk
         jVtGrvO9grwELQsDwN19/LHdl70au5fcTVNwJW7TuANpqAGWi67bPoXFI1Ar1ImmxUoX
         ZiTIAeX7xyOBnYpJ7N1ly5Vq2h6/uh/VObTdvRcYbfahpm6c3rjYYcvNKDP4G+C4Hki/
         W9n5EgCR7ymNVFKz26fLeVR5YT340D9kW41vU+fbbhyuCL7YuydTrndVqJyR32gdhgwN
         Trbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750863157; x=1751467957;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wz1Ak0wbeYwkM41lDzZf9Pz6IYC6aH7Ol1qRTwbIEuM=;
        b=pINzUafHyRzdwmrEP4G1946phHmH5O7GG/pYB+Hxwg3gaTS6YfX+x4r68QZ0KbS+jV
         FvPrWBPzAYWiK4VdNBKXqfwEsFf58/2tpbtxfJGEjT1nuGP67A7XjlRMbujzy+WCf+ND
         0juZ2h1myut1gpXe5ZLb1nBJGJrMh+6i6bSCcjk8gQbmUxxV0kI60IgIpNAj98VWxOKV
         eyFRsuwatKwIzIw+XLNvVAcKXtYoFcndXnytPHVRAbCvkIzgaPXxWkVWMldl30J1KySX
         W85kIOkba8J2RhwRfpq+XiIFeNrB476ltP93T/ryGQCSfwul7YeI2/ALWSvTwYxBg4sB
         hAqA==
X-Gm-Message-State: AOJu0YwNBfgsN+21Fcys+NLyUW3ii5iUzIw+YqPUVmPBD2FcVGg/+5CK
	uplwF8CQnTPN+ho4TG1h1agxKnlyPCxZbXdci0B/zWF6g8hM1D9q2PUo3g7rnAfBOKRzTsTaNg0
	BV4sb
X-Gm-Gg: ASbGncvvhqaYdMo39Kr29rbYv5E19HJQ50os659jmy1NRnuYTtwpOhqJ99PLBrVmIcY
	xEqSEssSya80VHBy/ReZpI0FhRWqZ2tW/0vjv8j3shKKb6H2stvlnaljhn7Ui0xJk3UxFIYcJWX
	5EAZs3G+DGE1nS2OcNddV3Yc6Uu8kOtdZQZBj5zZKwmJVvQokLTL39gyX6gFtjbaVRtBBD8Ssyd
	FYr1i4xuYRJkKfoHcCDXJm3ahrsNjOqa0Ep5kNcqCiZwCiCCKFA/OL+6wuJCMkPtMwE+Qtm48ud
	MQP7UyK5/VnAtEKSIxel63PV0IwnNC0TMHBJSEOeqmu9EoX3nMoLqg==
X-Google-Smtp-Source: AGHT+IH1ttY22NoB2TLT5LMAa1LZM20YfAQYpf+mdNR1+XahCsy7uPx4SRjp6id1ToSCVSVCJE/K2w==
X-Received: by 2002:a17:902:dac4:b0:234:bfcb:5bfa with SMTP id d9443c01a7336-23823fc4f7cmr57992235ad.15.1750863156996;
        Wed, 25 Jun 2025 07:52:36 -0700 (PDT)
Received: from [127.0.0.1] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d867f5cfsm133029065ad.181.2025.06.25.07.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 07:52:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 asml.silence@gmail.com
In-Reply-To: <20250625102703.68336-1-superman.xpt@gmail.com>
References: <20250625102703.68336-1-superman.xpt@gmail.com>
Subject: Re: [PATCH] io_uring: fix resource leak in io_import_dmabuf()
Message-Id: <175086315592.128628.9014300764157579909.b4-ty@kernel.dk>
Date: Wed, 25 Jun 2025 08:52:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 25 Jun 2025 03:27:03 -0700, Penglei Jiang wrote:
> Replace the return statement with setting ret = -EINVAL and jumping to
> the err label to ensure resources are released via io_release_dmabuf.
> 
> 

Applied, thanks!

[1/1] io_uring: fix resource leak in io_import_dmabuf()
      commit: 7cac633a42a7b3c8146eb1db76fb80dc652998de

Best regards,
-- 
Jens Axboe




