Return-Path: <io-uring+bounces-7537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E49BAA9310A
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 06:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10F264661E2
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 04:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C601D5170;
	Fri, 18 Apr 2025 04:00:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7439E262A6
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 04:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744948814; cv=none; b=nsDInzhLW57Ysxko2L9MyrZd5Pvq8qIhuVt9928qj6XHe7rP2qyM+LQE8rV1VLejRLcmldGmsIkrfAKh3jPc56FrO0F9CKgW0w3GMqUZ8BOiGXY7Fu2/sK3FJMm6+058R3mBsjYZ403ull/ShEU5CbC93Gzd6bVWmKfk0KIOnk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744948814; c=relaxed/simple;
	bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qsJHzBK1Tn08gpWSmv/8WDLTsea+PEPWTFwvlBWVDloWGMfW0W7T02rzpwgPdHpSfF6jkxroBrwDRea+xMHLT0syp3WaczoLm9jl9oBgpROl1CWOcTTKvBUPsbt1BPdCEANp6QFhMbGdaHqw0E0PYatKQfnyMezImGwnwWkmStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d43541a706so16049255ab.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 21:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744948812; x=1745553612;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
        b=YkzUo0fN1p9fguZpU6xQH+y0Ub8Vxi29dHNEqNXhfd/Y5v+TvdLchxnaFHkf2Fa2g3
         pTQi8t8Gl7sl7C6HeUX5BeHK2AxCNG7BFerM1CBC/+by82XaGZHg/DJcCHp1n1H+IsPx
         9/dSliWFx8KtGIWmPQzdEGb1c69CZEasHmCH7LxqfZtEi8owzLfl4dBernHBTtYzAHU8
         7Y597Jbce2ajBXjMR+ipBCxs/XIZJ7VfTbYY/1+b2+GJl1axcs3BNdY8AUZqn2rspN5v
         M4i8QErUxl1vR8xoAPNIUBqYzM4EZRUk8XiR/nq58LNbaYIhHrlIA8FUEZD3L83v3RML
         dNNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwsbZucvuAZzUr433yYqR9Ee3b+HE0XSapLkqculjjMvBenBwphxew9NtppQsNQMnoC/e+i6kbbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj3jmQY6dZvbr1Net90oCGZ2KCOgoGoqhj6u14uHoHkx0Q4Mdm
	xx/qGQQeNuIwzmTLrHKw7W8SGvEHH5lKF0TyKwJreWjEt9v4RqXZRWvGaOg002WeM4CdOeFBHA3
	+2IRi6k8WQMYo3G9LwOHzNp9DVf2A058v2/MRCte9HsTDR9bg2aC1M3E=
X-Google-Smtp-Source: AGHT+IEzUru6ibkgeGNXC8u7yW1ax0zndzgxv9QzoghfRsQZA4cfh1MH5s837125qe7BlITDquQbMeDZXaakdd4myRs206UoVCWu
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1565:b0:3d1:97dc:2f93 with SMTP id
 e9e14a558f8ab-3d88ee51213mr15844865ab.20.1744948812603; Thu, 17 Apr 2025
 21:00:12 -0700 (PDT)
Date: Thu, 17 Apr 2025 21:00:12 -0700
In-Reply-To: <676879e9.050a0220.226966.0031.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6801ce4c.050a0220.5cdb3.0016.GAE@google.com>
Subject: Re: [moderation] KCSAN: data-race in io_sq_thread / io_sq_thread_stop
From: syzbot <syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lizetao1@huawei.com, minhquangbui99@gmail.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Auto-closing this bug as obsolete.
Crashes did not happen for a while, no reproducer and no activity.

