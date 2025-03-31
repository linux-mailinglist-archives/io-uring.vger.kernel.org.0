Return-Path: <io-uring+bounces-7310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B3CA76692
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 15:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D50C8188A15E
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 13:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4777621128A;
	Mon, 31 Mar 2025 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="154LKYkQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770B81DF73C
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743426483; cv=none; b=evWD1i1FMY7mg9jJsAZNwwr/BrkbW6gKVLSOGOkvB1lne8jvpMOVmV33IyK+VPYe/3/lVqnladYA+2FC5ecMBsj/q4fOi7/xCVc7bGJr8cc+DTeqQdNrVjqmIWy4HaD/itrbGmf3KEJonWtClB3FBy3v0E4KSItxg3u6KDip3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743426483; c=relaxed/simple;
	bh=4X75mbk54VV0TkAAHiRmAwRd2m4n61JDwE5wUsPrasA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uIMrJC20/b/9iugQ0v56qRUOmtco/YlM/Gfs9wk679wEwTpp13N2BtV6PXOimrQ7alRPc9bUyBk3RNFMN3w2VbGpyxBiwxrCxRGKh0Hk5X6QWJcWgyDuUzlmY3hRil2rkPZ9QDOMHzaZltBbdztcJ1xVpGGsbbbZcsxk4yPdMVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=154LKYkQ; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-85db3475637so160157339f.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743426480; x=1744031280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Q6Bf+HgLw11AS6FVCF2n09YsY5+X2qkU1mdVvx3LOw=;
        b=154LKYkQ5TmJ3wki6VnP4pA7dAmEnkGOOjOqQwEE+AgSjbhN67Vh01FSlCMzn00aXP
         IbaB2csQbzxUQI2SAaEX71Iiim+kfSBQqayQiUrNC1CBJCkNZ3C2T8CSlufyZr9iSttF
         /oOR74wiTftMDbbS/hbvkBjguwwCPzAo0UPstDs2LgyCGhPKe5KGGeaRmbKRtM6HPKHH
         gaJ3wHgBNGH/ZMOtx5lqXOukVoTgR9MV+JLwqx4UbpggZXrIUgb8mG/WeGQC/UKkaao9
         e8uNfMKex9GAkzbiBlt57k2fvcMqRdUEbQ2akQDNJBY74MyxhI6TaQk/1dXNaLQQgsAt
         vuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743426480; x=1744031280;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Q6Bf+HgLw11AS6FVCF2n09YsY5+X2qkU1mdVvx3LOw=;
        b=pBiiElBeKD6iix8FdrCWY6AVaRl/efWZAKBW0EvC6yj5HLbDnqbsaPzCamLNNeaFJS
         4rjfBl7O68aQptHQej7aVjbfQwxG5ZMd3lE8Ri0eBP1e/oJxKXDPAyVXTepdAljlCV/C
         gg0W+ezcXZSErs4stolyhlFKY0GJcAlVkyYFT9XUFfJrfo4ssjWYMVTBwBU5V4BDFRyu
         kp4gle24NVU4Ahr+1yNUcvF5+BnpwNlCitmdIWHTmaNirfMM7WNWVHt7N2OKuUwk1quw
         yptSGdWlpBeBW+SpbNR/5VVWibJ68k2DFGUD7C63XkZJ97s4dv+hPK+W5YQ4AJAJSmR1
         Et9Q==
X-Gm-Message-State: AOJu0YyxjXK1JW8AJ2JKB/AZBKC3CQk+WkxxW4C1i/UyvYufGT4HhuGM
	Sz4FlvS0oxYKo2N6W2T3/3P7BTrL7q7+vwFEsWEqS+Z6eupnU6LPLUR2kkDAzAmuOtNqiWfqWFj
	O
X-Gm-Gg: ASbGncvQPJ/RZm17iSXUz/BY9aLYjckOA+5I0AAchTYSDtMIXZD6B+Rt5SSqWW3jMcX
	duQ4d5mrTjqFu3ZXAXZmx1PuacabhAm7LxyfEzRSChpaqcB34g5UC8IHgy/AcGjBC1iUaoqA/qn
	saarrt0zanKbOa8pHaGjl1SkzOY+Xn7ByGXFjfZieXaK0FsK1KWhJROI0gHnZCRcL8odDx+qYIA
	6jzBAET4RdKRLDGDt9XPDPNb3jp/XXBzg5sogWeAVVe3leY/bFyYJZrt/c7q7VMEeQGQA3zOomn
	O/9QF6hc7o8DuRX5mKj1+eN5tFMYL4N2seDO
X-Google-Smtp-Source: AGHT+IES7uBVXuArD3SC16igLZYF9TtB1IGP+j1fcS6MQ5eK6nZkLHvzzY4BPV2KTl+tFnrtlUezbw==
X-Received: by 2002:a92:6812:0:b0:3d1:84ad:165e with SMTP id e9e14a558f8ab-3d5d6cfd612mr89142425ab.7.1743426480061;
        Mon, 31 Mar 2025 06:08:00 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f46470f1aesm1822197173.13.2025.03.31.06.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 06:07:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9877577b83c25dd78224a8274f799187e7ec7639.1743407551.git.asml.silence@gmail.com>
References: <9877577b83c25dd78224a8274f799187e7ec7639.1743407551.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: add req flag invariant build assertion
Message-Id: <174342647930.1704853.5173183893176857379.b4-ty@kernel.dk>
Date: Mon, 31 Mar 2025 07:07:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 31 Mar 2025 08:54:00 +0100, Pavel Begunkov wrote:
> We're caching some of file related request flags in a tricky way, put
> a build check to make sure flags don't get reshuffled.
> 
> 

Applied, thanks!

[1/1] io_uring: add req flag invariant build assertion
      commit: 697b2876ac037545ba2761e2ffe9a5c2af6424e6

Best regards,
-- 
Jens Axboe




