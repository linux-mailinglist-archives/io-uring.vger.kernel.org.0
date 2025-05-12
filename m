Return-Path: <io-uring+bounces-7955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8027AB3B7D
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 16:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C84D117EEAF
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 14:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1496D22A808;
	Mon, 12 May 2025 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B+YT/aqC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24022A7E7
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061870; cv=none; b=GXCyrYhNOTmU33CGd/8CUMTMd2a4bD28QoaHLnmVddPC7Ic4J26K4PREeCcTXaC1GGE9ox4o0h14b1NC+9MmqClNRBVXB+h4lk72R/ODvxoh18PtylcC5RK9+xc4dqrT+OH8aLWajg4BYGS/bAqWBCJf4FBuv3f63RlLBVQTADQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061870; c=relaxed/simple;
	bh=MkXTb/ouK8ImRYD7V2/UgcaAK97B5qaOZF8+u14ugQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mm2l/9KMsMsid1JCdweslCdWQjUZ0Yjmbs5RSD8EZYPk6NOqNxMsUnVWhnu0EAXTMG/siekv68/VTmHllZhkf8ZPQigC9WuSvBmWOygHzAAdqV99OiNxvxTaXmHTeqaJNnzbcXxC+8h9y6eu4uXoAB1fLeV1vP7g+EjelJYuoGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B+YT/aqC; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-861b1f04b99so119313039f.0
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 07:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747061865; x=1747666665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=B+YT/aqCYsLYx1r/Bw1xeoc2oGzx5ufO0Vq2OVpZjTaNJhWW+QW03mL1qZLuHjYZrr
         4sQPRBtTQQICLdJzdqmXlVCzfeNn+AlB2wAsMNOMKRt9+u9CXHLZQIZfgR8ahIMUYxdF
         Ye08tCxJclTqVVGFo8l270oM6z5cihRtAVqmL4NHfRq3tQ1695eQ6m0KlbMiqqtffgdP
         JpaDyCh28P3cWBT+IjkfHPrJThvUJBKkqBVHw4HEG3zNiBPtAiiJSj3IqJTDtkdISWxz
         EpQFqqID3YRgIoZezIQG3c7hZxkt3cquptr1+zivHRLEehCaf3BvMw+9awIgdqO5QctV
         6MQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747061865; x=1747666665;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/4wk+jR1ilnOhlUaGH75lGZX0qYzLDVs/Vv8i0phPI=;
        b=KKMB89d3l3Gub6dTWFY4XLq+fkIuHFfBrBUwaDA+SurhpZK9CDRSMij5eycZkYmN/H
         ql1q3/GlLrQ3Cg+8XuLtd4HpJz2xVznE50hqmtJ3D4H72rLg0Gay2ugqHWHzHMzIMMQR
         LapgBEvU+q/hPLKL7UIhI6f4cQfxr0/+iusqRDXrdpVL+i71JFbrjzIpz+b2ygp0xLqA
         hmJUAsGp4755HU5gJbkhGGDImKejmQFvd8djEgNRmopdLr7vNuI/XAWxsB4WUMM75dRT
         K4vzdyjnHUfh0cvT5db61PzdjuH8y87Qnf+NYHu7s+avNf140fAkHV5PtkiUlwXs1d6x
         CeUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWj/Oxvq7yEonTCABw///Uj9Gd+SrrxSWaG6q0tJLz0PmmkoMGrVas/UMRFuj27RGtCgBR4yzAdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxumBljZ//HZnhLDgYwnVMSCS0YOZlz+cIUyaMC77AGU0ZrxF5f
	PnzqFX1Qz4x4XOeC+VNmEWc0wXlVnt9z0SpytGOSxs126m3zJ7XPm4wSJ+jhOPDcmtNbXlzMiBL
	O
X-Gm-Gg: ASbGncuuODMmL5uGstxk/3Zq5UQWIDg0Vu/rabCSSZNQDPMdL/v4QFr6vH1v/mASdfX
	xSkWvVFIwIxEpcMn3d1X0DxTyVPzfepX1uAyWPGD+ZO948Tp0ZInq8kXXglSQ9LJLmN1dLE2tEh
	gXQs9CjpqxI75ZUzpev5ANfEmdk8hhjKBWHw7bcodBuCjHiZxhm5wy1y9L1Fx3CS083lsGIB7Qj
	VcPsk2vDyRJeoR9wZQRXkpzfVNRD9pZ5tr+telqh90fICthVEFwwhRzL31CjeJEIumOVqAlgz71
	O74QLTVHLeP6bjpBJiEbU9Tk9V91ryuAqVzsfxiEHdIxv3A=
X-Google-Smtp-Source: AGHT+IEYhP4Dhkh7U8xot/WMbpJ8LnG6/51cqUzpePkiQEExDmXuRz8k3Yvl7IIjamdoaxz92kOu/w==
X-Received: by 2002:a05:6e02:2489:b0:3d9:36a8:3da0 with SMTP id e9e14a558f8ab-3da7e1e2459mr154041565ab.2.1747061865256;
        Mon, 12 May 2025 07:57:45 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa224d8beesm1679209173.30.2025.05.12.07.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 07:57:44 -0700 (PDT)
Message-ID: <89a530de-83a9-498c-bc8b-844ed0d183a7@kernel.dk>
Date: Mon, 12 May 2025 08:57:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <681fed0a.050a0220.f2294.001c.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git syztest

-- 
Jens Axboe

