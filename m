Return-Path: <io-uring+bounces-1479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B64A489E4B8
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 23:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45E71C219C9
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 21:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF86D158867;
	Tue,  9 Apr 2024 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H0jSPY0+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6A158861
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712696460; cv=none; b=H11nsjb2ucCWvaiTu00w91CAuEcH3eeaYmI307Cz87lQRX4PSGiKz+BwogIxJusqTVYrjC/56SA26lH97maQiuRDEI87eM4paAbArYkf8SAlB4bYE5hu5WnlFGocFZU+YzqSszfoJzkv2Pid7ltTCiBlPNfP0RGzLXcMk13SZYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712696460; c=relaxed/simple;
	bh=J7gEFSpd+xG+9HejwQ/BPJlt4C3SJ2TatoExwP6kk1Q=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mFQYOzGuEtLOZLN8wQqpefSBWJ+TyffH1HWKcN7cFG0nJGBdPdIZ6oa1pZ9tnfx9WAtuqjTGYPF8mE396xwDMbfw/xpctr3XheWdVtw2VQ5W5HmCZLKIZ+QR5KbASAIFYJpoxBMa1roOiAGp2u+7lnd8f07KxJvs4slEkzwYBcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H0jSPY0+; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ecfea4f01cso1040455b3a.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712696458; x=1713301258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+4zutS5Klg2tVROhwEX7Rc+t0eCuM5dhw7blaN/R7I=;
        b=H0jSPY0+0/8EVZkC08HGWqb46eF//jDAXEr3c9Fu1+EUouIR5KaBRur/pxVjmkQnVS
         RU1ilFPc2QXwIeNWu0ZZQFMJzHqYLcJhlpKSU7cHZKSGJXQDJUUcu3qsdL1x8ATv9ctp
         ghz/yhW6wwsxqhXvA9QUcw7mYMwteNLEF0ixRShv9HuGdFsz9xYzVMxenbNPR4QD/+ke
         ieHyVKbf6mJ5dqjQLEPd4tSIDb7IcrVC/xYc2f6eOpmysvrWDRJO2ef/u1ate66bDWeC
         9kRuyvXylhJje7Wf3ZfE4jmg1584jWmGUJXoGkYfzuu2fVlvJWf4RnJfA8FvnVYAOIiw
         g9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712696458; x=1713301258;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+4zutS5Klg2tVROhwEX7Rc+t0eCuM5dhw7blaN/R7I=;
        b=woJ1zQe7Qtoi2LRhxZZCGBiZH+P7k+LMZ9ymJCYtZF4HcG1U3YX4F8iZYLj7Dlx+xc
         zphkuYFzjlHtUoc+M/hYYWrcxn+q5//MzYrQFnzQnuYIl/fpddIJ7lVgzbx96jnJ02fm
         lx5a/Y2nUnnAXfSCvBPodHqei6PodxKtHzRJVa9sBF8jDUoA15upeFQfWZba4Td3SVDp
         6I+oA9EWQXCvU20cBpPCfV+YDFBZRN9RTUUO3Qc9W4eY25OAK0OH7cqvFQTDW2rTTIYc
         9M62VbbwEoX53CPjQZGgEYWJ9OpzSHmR07cs+5bmRm85BSHPuLQ9uI/EYGt8sNL0uMpO
         e1TQ==
X-Gm-Message-State: AOJu0YwHHr1o4n5Zjat16aOimUjPBZp5V+ajbCFOosD6R7X8BdnPLfqX
	wbCzWBNhiTmfuy0G4cfybqrBdByJ/546OVandjzAWFm4BXvIewrccFYZ8IdUdKc=
X-Google-Smtp-Source: AGHT+IE/7fyRILH+KXbXVVz08Za3cGbqkPbgdEmxwbh54UQIsT4JmUy0XShbpBDwwd5s6BQC4MQ1cw==
X-Received: by 2002:a05:6a21:7889:b0:1a7:9c23:770c with SMTP id bf9-20020a056a21788900b001a79c23770cmr1073939pzc.2.1712696458133;
        Tue, 09 Apr 2024 14:00:58 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e11-20020aa7980b000000b006ece5ad143esm8780219pfl.127.2024.04.09.14.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 14:00:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>
In-Reply-To: <20240409173531.846714-1-haiyue.wang@intel.com>
References: <20240409173531.846714-1-haiyue.wang@intel.com>
Subject: Re: [PATCH v1] io-uring: correct typo in comment for
 IOU_F_TWQ_LAZY_WAKE
Message-Id: <171269645723.133225.9447895812584739003.b4-ty@kernel.dk>
Date: Tue, 09 Apr 2024 15:00:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Wed, 10 Apr 2024 01:35:28 +0800, Haiyue Wang wrote:
> The 'r' key is near to 't' key, that makes 'with' to be 'wirh' ? :)
> 
> 

Applied, thanks!

[1/1] io-uring: correct typo in comment for IOU_F_TWQ_LAZY_WAKE
      commit: ff81dade48608363136d52bb2493a6df76458b28

Best regards,
-- 
Jens Axboe




