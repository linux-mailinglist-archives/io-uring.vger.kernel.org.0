Return-Path: <io-uring+bounces-1553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EC68A541E
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 16:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B656A282FFF
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27BC757EA;
	Mon, 15 Apr 2024 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pTCvqqa1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1FF82D83
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191476; cv=none; b=qbW2xCeq638/Vd3F2WtI+1JK9NLhL3EQ3CatGzyaJiRhvdZpDo4SmlVUopHIGejwdrXAZnnu2MQG+4SSFmhROXlYi0d3EFffbt6d6fhjuX5jkygxCxEpBn3YxThV+ZV73eZ4ki0pRkTHqouGEQBeEjYovmYvNiJV27EEO9F/fSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191476; c=relaxed/simple;
	bh=HqcXRnFyce4t6qwtROljrSsa/5ZmP0WlXQyFVrryB3A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LPhwoNEh4wp+8oxe1VH2zC6d/6fg0fLjXUhcyHhJDhcRV6C9LvD3g+PKVespQzEm0EL/XpT6rIMne0JGAVg9G0dg3ZI90JcJGLqDQHUOdy6xTTbMATmvQg8CO6YyNdSXEUAhGwtAW2MASUVQK/LbE6oEIhqP3aGyTT4R9yOpkP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pTCvqqa1; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7d6112ba6baso52021339f.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 07:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713191474; x=1713796274; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OnyTUnI7yjOjaMRaS9jTa0qNIFpYhtFJ/FJeohWZYZ8=;
        b=pTCvqqa1YGZFhKo4ZTRdU8zW5RCFBoqBKmnvgh4cnWy331LViylg21Hl2KvPV1yTls
         l4bnb345PFdQqO60qjRHMw4Lg5gZeI4GkrDM/yewXNtzmI5Iqdkw6AguiUvKCbZ2lB57
         zXi9Hnm1+SmWPx5wLUOYO7CS4WjJBat3nY+UdRPbkgoKL/8WpR+wvOVoX3e5evJ2bY0e
         Rl5WHizsqKC4UNEOynZNUe/+EuVY8MLoa9M5EN2/QA2eVaevC3HtdezEjFNneEFSFlt4
         R8V5xgwWWnpgv9xoucMln38BWHQq8Wz5l3z6VGpjKoCEgW3mdlYkjktrT7L1yJKHozyO
         pquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713191474; x=1713796274;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OnyTUnI7yjOjaMRaS9jTa0qNIFpYhtFJ/FJeohWZYZ8=;
        b=coKL4XgvP7DZ3WbuOmrgvZcTQnGYhsTF31voldKv3pCngNOSJjqXMQ58fJWEl0gnKh
         f1sovUCvENnP/UUyJq62N+lEusUlFK8iiFMNPPFRnVS639LsC9rB7ioRCzk1DYk0uU0T
         hf4fHaVxPtotc7vFryvdbYPt2fp4YRzLO01gl2kGIeQt0l/shbrZs0KC+eWrti0vmUH3
         yAKNpnFxsU+6MU0etmLujuC5A/9nqOX6A0x3WRaaLzkcvaJqA1nQU8dv4/mCjSkAFH3N
         lYLvi3w9v9VpRWm/27Mg7pd2ETIm4e1yjRTtF/Yz9vjLwDRsNvkemv9JkmYps+hSVbEL
         Iv2A==
X-Forwarded-Encrypted: i=1; AJvYcCUbmMDBPoCC2S7gcSuJhV3B83ChPGSJarQg+c7EAMpdqxgb4aGPCgDn/PSQUpM+4AJDFfKNeNGqDl2dsRR/4TYlHXH4osz9FB4=
X-Gm-Message-State: AOJu0YwLMF20PPMCwTdHouCY8bbYcHBAGEAD2qPm1NZStb1Igoe0X0rM
	zR3hgyqZQAQ2BcEuCC4z2JmgyRxbynDY75U4jp2U33cJKFwsLyBLM0Skvdlq3zA=
X-Google-Smtp-Source: AGHT+IGxjV6l3osWhSBMqMq8bHa6oq22HWgvV00Vl7O88jIAahhIDnE/sRlw5ymP4XlITqHuj3e8aw==
X-Received: by 2002:a92:c14d:0:b0:36a:3ee8:b9f0 with SMTP id b13-20020a92c14d000000b0036a3ee8b9f0mr8165771ilh.0.1713191474351;
        Mon, 15 Apr 2024 07:31:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j10-20020a056e02218a00b0036577f79570sm2634837ila.54.2024.04.15.07.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 07:31:13 -0700 (PDT)
Message-ID: <a81c7a79-44ce-44fb-8b33-4753d491bcec@kernel.dk>
Date: Mon, 15 Apr 2024 08:31:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [fs?] [io-uring?] general protection fault in
 __ep_remove
To: syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, io-uring@vger.kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000002d631f0615918f1e@google.com>
Content-Language: en-US
In-Reply-To: <0000000000002d631f0615918f1e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This isn't related to io_uring at all, not sure why syzbot has this idea
that anything that involves task_work is iouring.

#syz set subsystems: fs

-- 
Jens Axboe


