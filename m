Return-Path: <io-uring+bounces-1020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A2187DA7B
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 15:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0011C20B29
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 14:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BA4168BE;
	Sat, 16 Mar 2024 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U2/08xqq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB8318046
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710600140; cv=none; b=MeF86udUEW6rMEAatNZhWDPhzQM8bEz2VDyyQUmEzI+7eJtdTCWf1LBKBTSSBga9huqosE1LEFB2Y5deLuJxzmZh/w62JMPI432p5+Khe7xKBkTkRX3WrvdDBexdJ9O0AnmS7dESyMaXEAzfgiCJZG3MNMnuVGmNNi/mtunTdco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710600140; c=relaxed/simple;
	bh=9IKAL9O5Kzhj2bWwcxxcLVVHc+FpAsBJbr8QW4g4aUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L84bG6SF1w/u+5lHwZC0auLql7E/f/fEEcPUyFYdUN5o4y3T30OsDlyzEgBU3iKtW2GWhoTjIi+bEv/R1o2MijadR1Sd3aW2RXCcGngOJ3+Ca0WjnJfULmGhO8BN20zCp2xRDJFVj2F2ht/vTI51knFILscUaEn+YBgyt5KjYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U2/08xqq; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1def81ee762so2660395ad.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 07:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710600138; x=1711204938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=U2/08xqqzuf9n3embOU+7m6bSUmbdxQ6qEvOqfZMMhdeTxjDeVl6Szjzojequ+cO9x
         9wigpcN20Vi/tfnWesbfEZQJ3WywyyMOcYXwg/msPV2rJffuGDkitH8UL0ciad8WsRW0
         6pdBCi0DwQLK1lcxqu4/f8qIawR+gDKPILpkOM6m6w42Y0MdU1hWaSBxw1DcA5JHa39x
         mMO+2favcCGFFP250oHUUcrITvGR50sjI82kIfSk24wzkOLWABoyG7BiQFsV9jEi/pui
         A4r+KwZQTMUC77hIQexLVFIC2q+v3MyFFWJ5pvtVdbSdQWG3JXk6JTRTNvc2iuFNlNa/
         qlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710600138; x=1711204938;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=RURsYMz7n+A242OA8+ht6a1QvVZ4RCBKsKqUaUxi7DMKueWPazeNLZaKCAQE1JldDb
         d5yDqHbEpctrvsWVVF6z/Z7YZJdfAHJ2uo1MZMrmJRDXiTK/99AfNAdby07f7iCTflbw
         E7/inPPygjWlJJgyA1P5Skfxns022xTlmxxCkFhZJEoCkR0PirIz2j9VZu98i0P/FiPX
         B7LoJirTHWOyj8owUOgGF/2+gaeNCaOzZHxak67vmKsWw6mEYqvG+5tzcy4kYuMKIRLI
         teSrsQb13IKS9iLoJsPoKF9kD1d1O9ueJIPpPWcspG8670a2Q7nbFuAQtL3IUsHygB/T
         6KVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhyAWVzu86QoinvYjmQLZFmE0sAO6ALqwOxcfOzDBebpQfUUbc5y+UobHkrwwpsK8RUkycJOa8vuQlJGmVAQaSNSsgx/IvgfE=
X-Gm-Message-State: AOJu0YyjZeBzcQukOztapJ6GJ3ibN65zBCT/rtf8VSv7g5189B7lkxui
	BJC0AzSYPt3PlTc90VCPnjTDzwv/iJ+1tEFT97YFFyvBzgrBCO1y06528qAl6Z8=
X-Google-Smtp-Source: AGHT+IGRV2wpfsgw0/oWiKlOA5lxTdHAopriGaXb8z161t0SWeWao275fL5/kxza9A9ZbURzltxiGQ==
X-Received: by 2002:a17:903:186:b0:1dd:6f1a:2106 with SMTP id z6-20020a170903018600b001dd6f1a2106mr9296394plg.0.1710600138520;
        Sat, 16 Mar 2024 07:42:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902e74300b001dcc158df20sm1453789plf.97.2024.03.16.07.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 07:42:17 -0700 (PDT)
Message-ID: <8e639192-cb6b-40c3-9892-db0ac0cbae52@kernel.dk>
Date: Sat, 16 Mar 2024 08:42:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
To: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003e6b710613c738d4@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000003e6b710613c738d4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git io_uring-6.9

-- 
Jens Axboe


