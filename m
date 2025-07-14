Return-Path: <io-uring+bounces-8666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF178B04251
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 16:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D697AD076
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 14:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DECAB259CB6;
	Mon, 14 Jul 2025 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mVrlOjXV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C8B2571C2
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505051; cv=none; b=Ed3t7+V6VFbo4CQ/JYDtjJenn1mOz4EWE1HZ/OfO7xn9T+gJVwpLCR632SNrKfju3I8H4OCYW6q7PioO7M273ON1zyQBOkEsyV4Sb1kW+vwB91kLu8xZYa4FGnrAHOYUfRppQpWAJmzWp6nLaTkfOxh476PY8rOMTFAEeHRk6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505051; c=relaxed/simple;
	bh=RcLCw2KSg/C2K00AgN8/HAyfQ6GQ2jlRHp1fmbo/bVI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V2jwczH9sul9rpH/xLZBArduPg/qkfJVQfOUWZ0osnX4TO6Gojr1lps+ZUnn+2ziWr8+zhM7C1G+AL++JuUvpoI7qDNsqYiaWy03imL+wIHIW9jvjKZyLqUsAk8Q1bmmdUFlfbF/JKtY4K1KiUOnG/bmDkM6VOUyjaHgN2q6GJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mVrlOjXV; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3df303e45d3so13253045ab.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752505048; x=1753109848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNamMF1jbwq+qKDsNvXgwD8eSIO9oTkUumOCrjoC6Ko=;
        b=mVrlOjXVlzDJGOnCZvxg2ge1JQI/+FkRtc49Wh4RbdLVwbOVdWU2Z7WavqEn5TyvPo
         xCxm7Nu+kfiqth5YyhBDYZfq3XPlIEQjJ4zwUOQVKMrmofuEMZQaqAbAsRqQt+C8T77d
         P1OYQDoEpW1gggKt3N93ihnbxKH+I3n3EcNviz/qjvOphpfTRdhDEhqOwZJtI2G54w/5
         vHXbl3eJRGGHMceFs8VaqD6vlYqcjaXmN53TTa+n98oW/d4EggpEuoga1Ha3Bbbt9zoX
         W4AJgaz+ArnRTPndNHs79F32Lr8edJQfmK8kibTitarJ5Jz1ycrwNUPtHBlytKVoDjhS
         QwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505048; x=1753109848;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNamMF1jbwq+qKDsNvXgwD8eSIO9oTkUumOCrjoC6Ko=;
        b=a9VhZYxQzDZZ7RQyQ4dstgWT1M3lBtr0ToLPGUMoF1Sm/owHSFgJRn7t5z4WcIxNHY
         G4fZP+kROO4hcB7Wehy18RqqZELDW1VSse8Z+jo9SbCQFLkX4dF6JYmdVl5Poo1tWPCq
         jAl/s1L5mhK+w9cMV96iHF+KBDhMqwd1UgJifeX48DOl6SZOsLrAVxwrPUF1hGuVhC3X
         sPwTjsUifmDGOdfig+8P9FAF6rJX409GgXTCc92uFEl+cwdXcrToOVjCy5//qCHPg4So
         9+c5pukXylpD3OOU6xs39uEWIcUgOSpz+6AiqhgsLedQjw4vTUDSfB/DmeAs7kQxSx53
         H1ZQ==
X-Gm-Message-State: AOJu0YwepXtdHDpU2BxUqJ/91Nz1l5cbaT6DJlC2wDQ9g1TBGiG3UlTD
	9gHi1O/J0+1ZHCffiBd/n/cFgWn8oa24w2Zc7MW+X4vBUJrbQcJhAF9JtEBY12cQ3wH3S55LerR
	oaKRA
X-Gm-Gg: ASbGnctl1xVGEfZpmjk0efDr1pVE4sq0cD1kI65Z8J+iKvdFK0iQa7WzfVe/W4MFSMI
	ECFQ5GlQa911YRIXycW6kDA8rTlcMjCeuPkT5JWt2VDo8gmUDJ5B0dxGCIWBdk9hLhHLt77ZcU9
	C0ug2amoiGAfEeBBdHGFmEict3UAX9RQ42OuJIaMD5xq+mtj06AODUzLOgzaWcEZHFOzolYGY3o
	LKu896LRK2K4+YKeC+mNpmBw2DE4jZeg9tgiSF3aJ2VcReOdxIHLASlUcDbyDlYKEyoDB1rR7no
	v2ZgaJBx/ApVWMI0nPY7U/Rlc7loz5gYIG7WDVzDF7Wp1/Iqo4I77vXjV5XcvWQCeA/BBDmbFyC
	Pj/gszli/PFfLTA==
X-Google-Smtp-Source: AGHT+IGbvA8L+xK0vtTEnxWkzItbxycoMgKKDEgDKfXnctGqf83vqX/SbQIH8OdA1njI4f5cHjDRjA==
X-Received: by 2002:a05:6e02:2404:b0:3ce:4b12:fa17 with SMTP id e9e14a558f8ab-3e253326d46mr139379175ab.19.1752505047823;
        Mon, 14 Jul 2025 07:57:27 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b0e4e5sm2127497173.118.2025.07.14.07.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 07:57:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: dw@davidwei.uk
In-Reply-To: <be899f1afed32053eb2e2079d0da241514674aca.1752443579.git.asml.silence@gmail.com>
References: <be899f1afed32053eb2e2079d0da241514674aca.1752443579.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: disallow user selected dmabuf
 offset and size
Message-Id: <175250504719.127578.17592684126023227858.b4-ty@kernel.dk>
Date: Mon, 14 Jul 2025 08:57:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Mon, 14 Jul 2025 11:57:23 +0100, Pavel Begunkov wrote:
> zcrx shouldn't be so frivolous about cutting a dmabuf sgtable and taking
> a subrange into it, the dmabuf layer might be not expecting that. It
> shouldn't be a problem for now, but since the zcrx dmabuf support is new
> and there shouldn't be any real users, let's play safe and reject user
> provided ranges into dmabufs. Also, it shouldn't be needed as userspace
> should size them appropriately.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: disallow user selected dmabuf offset and size
      commit: 08ca1409c4fa37ec93de08b9963390ed68a5ae8c

Best regards,
-- 
Jens Axboe




