Return-Path: <io-uring+bounces-2207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0BEC90812B
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 03:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CC892821E5
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 01:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA68A26AEC;
	Fri, 14 Jun 2024 01:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ngASyHv2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249B73211
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 01:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718330219; cv=none; b=WnFq3WpfWryzJ8Lj9mJJkK0kIC9fV5OtNzPhHqWRC6BB+Nw2ZMsln20umM655st6dK/kV+R87s9sZCgegqdlHhjWXCZscKu1AUW0C1qU62nnoQ6YuF/KMbmTrjd+6gOl6AR05FuKqUTycer8+v4q+z82mC1r5Olbn9gaf6IdeII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718330219; c=relaxed/simple;
	bh=vyOqg9db//0BT1sFIeTPiOlI0FScPbhfE9kHaAwECak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bipWs5mhQUa9ekt7daIjKrLrYaRiey2H3cpJni2OmrHY0CZC0LKKo8xydUdFb4x7oAfFxOJirq00aeyE/sknAILejo8e4Fe+CxfYRXNeDjLWnaqPJHd+1Xj+GTJQ5bTbNCDJSUExaUQbecU/rUhxmNHsjxgf9zhQcduKbn6kr4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ngASyHv2; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2c2c78f40acso305634a91.2
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 18:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718330216; x=1718935016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/cT5QY86RD4pMSybSC7ezIiLKHexGe78wlrIu7nM5I=;
        b=ngASyHv2k0Db0Cq2osrtVPvYZk0/CTFgqR3Al7qtLA6d8njdD3//ZI1cOCYOBHB22q
         QDLJurvT7lM59AQ9KTNBAC/fD3WqsZp7u6m1lY4VG15cpTv+q0KP00mVBwJf5VL0OBSy
         J++L1EE18DSptIJfxjsnom2R4LJCnLVz5UiVLuytNZ1nx7TN6yZ7jecs5vO50QGho1U+
         /UinVVmTH8fLaOh2SuaBH6UfUlFXvEHA61oBGL+VzOD8sVbzTVleokbA22z2cOh++KAG
         lYvyTdqGV2XFsaDViyAwNOe1xFJCQgzkY5/6o3c15UlPPYAWGM0zytIdDgvQYISqsNFQ
         Ds8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718330216; x=1718935016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/cT5QY86RD4pMSybSC7ezIiLKHexGe78wlrIu7nM5I=;
        b=NT3FxWO37t6npdzm06Oyz19sibiC34Fqt/1lhFLWl58GAMnA36e9863Kboto4TFucM
         ePDw2TGWReRLOV3UZZHgCMim7DlQpUN/agriVoXVACVG7DVO2HZpZKAwyNjxZuXlhmGO
         g8fWpzb5rdAwb3PfOnslP3MsCMX7YBQxbbtdnvADF5F3eNeraREHdQtpFRfDBaV1M2E4
         BCJzji4kqXmlYs0X3gp26UMIb8FocCcssRTmwq/TJ+JwMEa1Lyaz5wke5bAAlNaQD6Pn
         u0xClSBv5XQ/GKF7wi5dkcYmjT+B6FzlE22SccfdmPUICvN/bCETnZzu5Efs/Oc8ldNT
         fosw==
X-Forwarded-Encrypted: i=1; AJvYcCV31/CR7cyxxAp09fY3HG8zOyTM7Ln8NosZ369Rgk5nimzFP4jIfKmh1NG2O4lPVuazAw5iu/6OUzGwEgKhYWHCZU4IXHjp63U=
X-Gm-Message-State: AOJu0YxNnbesshEI1fCommjLs+39iloV0GNPeDKA9FzX+X/PgANMdCCZ
	twjB2ut+gzFoiG+cd/sQoivtO7zj7q0d9Byhg5FRYexzfNUKTdZVOF4OcdDxUX0=
X-Google-Smtp-Source: AGHT+IG01YkLWFpFb5K5FGuGR1Hct+TnKSUI8iy4lKTY3rTUKYG2lCSLI60kr07UAtfDFCyqy/+wfw==
X-Received: by 2002:a17:90a:578e:b0:2c4:cd15:3e4b with SMTP id 98e67ed59e1d1-2c4dc03a6a5mr1447650a91.4.1718330216343;
        Thu, 13 Jun 2024 18:56:56 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4dc5f7e0esm631767a91.48.2024.06.13.18.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 18:56:55 -0700 (PDT)
Message-ID: <fc8f4adb-feef-421b-995d-ae9ae059f4c5@kernel.dk>
Date: Thu, 13 Jun 2024 19:56:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow
 (3)
To: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003835b9061acfe0c4@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000003835b9061acfe0c4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


#syz test: git://git.kernel.dk/linux.git syz-test

-- 
Jens Axboe



