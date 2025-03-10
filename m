Return-Path: <io-uring+bounces-7039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5188A595DD
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 14:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30711188F077
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 13:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849EC22A4C9;
	Mon, 10 Mar 2025 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rCitbJGg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DD4229B05
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612496; cv=none; b=odNsqJgFram9c3oqVRZ09OGp7gzlRvK0ZKcIrVwQXRxrRjBeUmkgWDewiNyg6x5mGlOloljhy5wjwpldqScUNmj0a+Qzv2/eivEDuhvuz4dcYmh325k1eH5ST+EtOIbEc1gBGeRqPSzGaPhwL4vkoMntoMMHlBJmRA/rVi2bb/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612496; c=relaxed/simple;
	bh=fooMtxfyccEHO15rz8es/XL68NtyCKVmEQ4L9wW29Ck=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aqvrMNgrhe4KydXUXW9WbFjAub7LCSXa9FQfM9BZea7fByqh6dgx97cjrvVjEhnDw1R8WVUXxQvBcxTOPtg8F9hnpx8GXuLSv3/KTkv9EeWh9qQkU1Oudss4Wm17DU2k8jqSiwJZJ3JUqI1k0C7l2MfoG2FkW7mRV4jK+qIYvU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rCitbJGg; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85b3f92c8f8so132949139f.1
        for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741612492; x=1742217292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NO9hQweuzrvSPhvqIU1hZAB23VpztZVUn30/KYSpnuw=;
        b=rCitbJGgi4tmNMWlUsHDdiSSSdE/3YnQrjFlvbuIscKB0H+JtagmdhsLvyCUNNayHR
         kvp46n9O7oZh1qlt/UGWrG0DR56mFtKfgI2SlCLD4qevjVKt0JzJNnyO21Fcwntw+CuS
         pp/W9f9/6JkahD39P4th8AuDMmI+An18JZYQXvGwm8PUSMUXmyZYjvob3k/RwyVYZBOw
         Oa9JW+ECvy/fDrn2jjD/EOVC+1uMfZfHuaNmu0o4yFEUPqMAgdBLFr5n0nIQs+2JRnDZ
         cAqOXdTpxqiuRTYpBc02Ce9YR872mPlxprh6XyNu8LmCu/OzPLp+QLM0LrRr0J4te5Rl
         qkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741612492; x=1742217292;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NO9hQweuzrvSPhvqIU1hZAB23VpztZVUn30/KYSpnuw=;
        b=F23bP9PDT2o2Q6rKdLiU3HRbK70zKNfnV6kgSIWL2/YjoFq1UNqG/7oLC0g563iLAb
         WhbasUYYZKh/n/giUzqLd/Bc5LMdm2ZY1CztGesmQo6GtVUV1EqjLGf9nBdn0GSEnXOG
         oxvtvM4cdxaw0YJZQxucJOhUBQ+bu+TtXsdVONi+d5GYA9w1E896OlTiWSWWQyCxOr/H
         z23GR4vs3Qu1GqNlwnPHYyhqRVCtoj6LLMAzPpCXVv2obhkpnKYFV/nhXOddqBxfo0x6
         79MxRgaot9WDGsL4QYGCnCC3l7VCpU6RPB3lL7okmxyfahBmPmC2mjNDwniSZR8FbzR4
         LWbg==
X-Gm-Message-State: AOJu0Yw3/NnomM+Bu2LwK8TMZWAO8CDt4Fh8FwBLGZwd5woLTGW+3+k8
	NfSnEKt3sIypYDfBuKXBHfCQhT6x30lOY2Do6UsgzW52Cdcm/C5xqlPt+BpDDmo=
X-Gm-Gg: ASbGncuNJ9cBhUujbBDxXdRJRiMJu83tV7CbUA0GsOJ0wJBQWe5dLOkJScLyGrPgZbw
	0WpwuR7W9x4C0bCwDXtDW+/lHAd3sWt9i5PZW2GyLm/EvCMbcIZQyiOhzygbmXHEEYtfMxn2Ozc
	fK7pf7rbLZir7wxJS7McZJi2zcF9jIce7Zh4JAaRMCWLG+rOp6l1BHxldlKVUbnv8aXUrkbao6R
	fMc5be8wepiw/WycdPZgSGAnf0pnc4bAvHK29sb7PxTMyXS8jQq7dOZh0HMD0XHcFdDB/9ocpm8
	b9r/DuaSgY7DT84336CTSB/wCdYirKy3DP4=
X-Google-Smtp-Source: AGHT+IF1Bm3K8cxNDklInRvyVnbbQtuzULJq/lseaPDlMJ4OJYVt/mKgclFRWsgQwk+3IBH33SK7Pg==
X-Received: by 2002:a6b:5a0d:0:b0:85b:3449:faa2 with SMTP id ca18e2360f4ac-85b3449fe0dmr755717639f.9.1741612491867;
        Mon, 10 Mar 2025 06:14:51 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b80032bb8sm6452139f.12.2025.03.10.06.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 06:14:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1741453534.git.asml.silence@gmail.com>
References: <cover.1741453534.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] improve multishot error codes
Message-Id: <174161249059.148284.11393421808958696583.b4-ty@kernel.dk>
Date: Mon, 10 Mar 2025 07:14:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 08 Mar 2025 17:19:31 +0000, Pavel Begunkov wrote:
> Unify error codes between normal execution path and multishot. It's
> a dependency for other work, but it should stand well as independent
> cleanups.
> 
> Pavel Begunkov (2):
>   io_uring: return -EAGAIN to continue multishot
>   io_uring: unify STOP_MULTISHOT with IOU_OK
> 
> [...]

Applied, thanks!

[1/2] io_uring: return -EAGAIN to continue multishot
      commit: 7a9dcb05f5501b07a2ef7d0ef743f4f17e9f3055
[2/2] io_uring: unify STOP_MULTISHOT with IOU_OK
      commit: 5027d02452c982bdc7b36205c66466ebd7e6ee17

Best regards,
-- 
Jens Axboe




