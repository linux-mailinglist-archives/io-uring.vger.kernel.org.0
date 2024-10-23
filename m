Return-Path: <io-uring+bounces-3943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 476E69ACFAE
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34D4AB24E34
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3577A1BBBC9;
	Wed, 23 Oct 2024 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uDgN0nqN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DBD1C876D
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699007; cv=none; b=VI/8RJkVl38YNKvMjS2dditXMG8jqP+tb5ZQQjQ4MTv4UEN4qp25GbIc1mR8OS83KBSUJGvTMdkA+XlyH98UpdpqxuRpOmNTZYXreJ2fT3Q9Ogo42BC0Fan+iKxvaagjfA5qmXw+B7AxYhuORzcSsqeY6fSXQquR+EJXTzOJ0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699007; c=relaxed/simple;
	bh=G/Frb5EnHcxQ6A2Ep8584owEDqt4LIessBda2mZwihI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tf8Xh3T8k9xFvx4BZdvbi5rUe+uNVaNWldhkBBV6mvmPd2FqPotz+BlzgcZXQYpnekuniDusGFT8jjAMrVQyTz6hFSReJpyaTd727bzgZ9tnlJsc/ad3bUHy6ixTJtSYZHR97wSTpAByneNqthvM00gu+MO8sBHsG+iCDDxGfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uDgN0nqN; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83a9be2c0e6so288941439f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 08:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699001; x=1730303801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=51yJ647Sp7eNX3XD6u/PmoTvHQsW0wesPf0KA1recNE=;
        b=uDgN0nqNRz7lXVwXLP6Y7mRfE4q86oX91Y1hJU89V7wLVpIYaKxQbQ+xNKmIRmHmo6
         3dhW7TG8ajQmPKWs+q1Vhg1CVZNI0lYQFMWuRyBrAGNDoQqshBuWBEwCzEFRlNfC7re0
         zaZS1tGN2QK+MuMz7c8wWM18X589kdyLG7ppef2Ssah7TpGU5Rw41B81zDh6YMVlpv6q
         aqsMleO+Es38wrDIB1hZAh1rDVkUMyVLVo/Fqa/ghvVpT0FEkBkRmAVXYAWBfAR4vy1b
         U62Y1rY2i69E2183CHwaxmndzLGCQymxPRRV5At1vNHyjDcKkMZy91gLDn2I6JoeZMpp
         f5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699001; x=1730303801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=51yJ647Sp7eNX3XD6u/PmoTvHQsW0wesPf0KA1recNE=;
        b=PL87P5rnBbj5jdLeAhqIEIALHN5hcca1zEdBgJR3vo14WjJScRZUfh/mmteQgKoutC
         oU8YXw1f60VjgCLiXYF5oYat+LxSwNR40yjRUXlqicYUwS1HUAP24yP+8tewGzycv7AZ
         ch0HV7/hLUy1Ej6cBETMMK8exXeUwQYUA76ZNFWJrAQ4DXUJDkIqd3GJ7GenbJR2FIrM
         5bMZwgKw2qYpH28kJni1tGYgck05VrbFO4mKsQJ+S9sozVuxRjnwoln6e4QhxxY1N/VE
         khXVuwY1mgjDe80uW1l29drUnp0aOCXjApGjKEDRUxyH+HYUJmgMCtW8EsUFDOZlFosj
         eOxg==
X-Gm-Message-State: AOJu0YyHNTv9/NI6vVqp32TlSkgiHUI3BhH5lmuM7yS914PsqJAnHK5S
	bY2P42xNugmmawC0BCQVtk2aT3PgqkQ/yx5p6OkhZ88sviOIfRhD+Vy94BmGrutUU7N6RnX19X4
	S
X-Google-Smtp-Source: AGHT+IHGuaVhhK0y7MTRSISBsQIwMJzFC8AlGBBLA/XJm3pOQqToraR9eLO1EgMrbWMYHPVPKqLtRg==
X-Received: by 2002:a05:6602:3f81:b0:83a:d3cc:779a with SMTP id ca18e2360f4ac-83af61e9cfemr336240839f.11.1729699001528;
        Wed, 23 Oct 2024 08:56:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6091bfsm2131572173.97.2024.10.23.08.56.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 08:56:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Add support for registered waits
Date: Wed, 23 Oct 2024 09:54:31 -0600
Message-ID: <20241023155639.1124650-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

v2 of the registered wait support, avoiding needless copies for doing
high frequency waits. For v1, see the posting here:

https://lore.kernel.org/io-uring/20241022204708.1025470-1-axboe@kernel.dk/T/#m2d1eb2cc648b9f9c292fd75fc6bc2a8d71eadd49

As with v1, find the kernel repo here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-reg-wait

and the liburing side here:

https://git.kernel.dk/cgit/liburing/log/?h=reg-wait

 include/linux/io_uring_types.h |  10 ++++
 include/uapi/linux/io_uring.h  |  18 ++++++
 io_uring/io_uring.c            | 104 ++++++++++++++++++++++++++-------
 io_uring/register.c            |  79 +++++++++++++++++++++++++
 io_uring/register.h            |   1 +
 5 files changed, 190 insertions(+), 22 deletions(-)

Since v1:
- Add io_unregister_cqwait_reg() for ring exit cleanp
- Ensure some 32-bit archs work with uaccess
- Add separate index for checking validity of wait index
- Add various sanity checking for registration
- Account memory for cqwait region
- Expand the test cases in liburing quite a bit

-- 
Jens Axboe


