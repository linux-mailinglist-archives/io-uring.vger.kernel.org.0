Return-Path: <io-uring+bounces-8607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6851AFB3A9
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 14:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 260983B85A1
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 12:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4890929ACEA;
	Mon,  7 Jul 2025 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DKBWh0hU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683DE28FFE6
	for <io-uring@vger.kernel.org>; Mon,  7 Jul 2025 12:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892856; cv=none; b=E9xlFLrKF4BzUIGKLjjE0oL7mkq+oJrtzVtvlMcK6kWJTR5Ae6w0qsk7JzcjjEWEJwbMyYgqA9R7ifYZGspni6zl2CzXTKWvZj5BLtLk8VzQaGj/QxSzLuFTEgCYhH/AQMNGsjIV74k0Xyl6IQZRI9pXUE2JPtPRDGytudo4D6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892856; c=relaxed/simple;
	bh=zU5ICYxdOhqEQI0YzmOnIIls7EKKnOVi9Zt+4LYhXdk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mPQJF21cuwauzmG2RWeqVSoHteHIlmdvh5U02Wwv2bhURcwNZyFOD6rgt8OHaKxEeD3qSoW1OmhBK5Krqp2f8Yn/vUoX2P3x2XCd2ik3Hf6WDB+fVWqT/KrfXhPoHzr1r0miSHH6Hjc2i5wCWFc4tzgZyec2UoPzRc4soaCQlDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DKBWh0hU; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3df30d542caso14690365ab.1
        for <io-uring@vger.kernel.org>; Mon, 07 Jul 2025 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751892850; x=1752497650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPhUmF9Q+Kv6AqcYA8nIbGuanQg4FsiLgdHt7YXmsfg=;
        b=DKBWh0hUpEKfHR4pViCWoDYtwtJj/tPyrFIdkv4hQ61TAvL+JgWrWo6QrDo2Vv39jF
         zVNZHOZRhtzrXk5J2YyeNnVLVewKUV5sKVp7uovYzaG/vGonYuUUbT1PEvJ8D5YLU03O
         7VDv0N6vYu2KuVb5R3eylCQzWqK/3aRLXwu6twediAE1pNBW1onPwHz8yqyO67nDznAX
         pIo+ZBTnFR94iNvFnA6ek2RV8Kta2E0qMSqwv6IGPHQrDEWj04wbWqVtb8is3iE6TMYE
         peaJCXuSemHN3P1c9pjtT1bSSfwfdC+MD9DxIWhirxIZ9m8UUyfQldFd1U8LZTjAD6Jg
         cr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751892850; x=1752497650;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPhUmF9Q+Kv6AqcYA8nIbGuanQg4FsiLgdHt7YXmsfg=;
        b=AYlg2SxQC1iIxslml8LBnNtRSTl9PBbC6DJCyffR1peNsd1exq0AmBO1e52/YW9MOY
         DJ/xjCQNaeQBMyhDLubnkMDegFv6UAXBd9Pj4nwr6y6F1MYhLsGaP21wLwcl+iVGA+vn
         57U/PxCNuqzT8k4iX8aI4TyTyVzXorXP0i3qfv+cGd8zRR77bXbgWeCe+NOPSlyDpuhO
         KUi3dUknhNwMDqtJaRg1a+kqRAHiasIwmk9JueaxPrp/4wXQK8QwI5ESnXxOge1Wijv9
         yIeyj+dGGRParASWyW9IFGSK7yuBEL9/sm2uGnMtgSj2QKS9GYkodNTjwAdipbjjKP8G
         wJ9w==
X-Gm-Message-State: AOJu0YyNhstYFMjdvrPFRxvye0qBHW0d422wffl3cd1H1S+vvhVQ66P7
	EUQOnDlkB2WPRuQaiiJ6XS8MIhOgDQpKlM21vd9aqMYOIpDAeF9ZX9wRQprm2M3U1Z1bC147K8E
	Zxquz
X-Gm-Gg: ASbGncu1yBNhVUefLXJgP04+78lkMyd8ZFqCeKauIJqAQso8PXj7Asf/0H+krhxqZUs
	t1utiCibNY2I5Mljw+nL2kxx9S/VrwjjQBUghshT9FYHt59K8r60jwEAQLpgGcyLyyy+2woGOY/
	1s5oWtnXp34iG42QVxM/oZtPR4MCqvdtq+IXiKjyBVfDaoW04KpDbg5geQFzqb2kDP9oUGNA3bk
	B2UFEq9ehsxWCG7slxQLwp6yOd5wes2/ZpGoO8MqIcjLa2v7+f9bnsn/lX4855i0f9Rm4Sxr5qP
	PhVd1BOvS2YAHY3HHc8LDwCePxcrtbThJ2vdNv3ol+u3HfDkvKaBmQ==
X-Google-Smtp-Source: AGHT+IGL9UxdmYsE4nm1AopWGCo+Ral1ohw+sAh6LoY4x30qkq102l7udq2d38VtrR0hyiHkproxCA==
X-Received: by 2002:a05:6e02:380d:b0:3df:2f47:dc21 with SMTP id e9e14a558f8ab-3e137204107mr113838465ab.22.1751892850073;
        Mon, 07 Jul 2025 05:54:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0f9b8daecsm25445965ab.20.2025.07.07.05.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 05:54:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <b9e6d919d2964bc48ddbf8eb52fc9f5d118e9bc1.1751878185.git.asml.silence@gmail.com>
References: <b9e6d919d2964bc48ddbf8eb52fc9f5d118e9bc1.1751878185.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix pp destruction warnings
Message-Id: <175189284920.872716.1677022799006887221.b4-ty@kernel.dk>
Date: Mon, 07 Jul 2025 06:54:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Mon, 07 Jul 2025 09:52:33 +0100, Pavel Begunkov wrote:
> With multiple page pools and in some other cases we can have allocated
> niovs on page pool destruction. Remove a misplaced warning checking that
> all niovs are returned to zcrx on io_pp_zc_destroy(). It was reported
> before but apparently got lost.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix pp destruction warnings
      commit: 203817de269539c062724d97dfa5af3cdf77a3ec

Best regards,
-- 
Jens Axboe




