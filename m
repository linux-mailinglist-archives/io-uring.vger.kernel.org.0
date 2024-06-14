Return-Path: <io-uring+bounces-2205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6B190809C
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 03:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79EB11F22DD6
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 01:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7801822D4;
	Fri, 14 Jun 2024 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Gw0dP4l8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1523201
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718328518; cv=none; b=ubm5DlwJCQiHS33AhO0y2JQqaJDEc/t13KOlBO3UN/1ThN/3DZWrY/EWJGByQp9gxZ/rUOmTko89xGYm12Q4RL0fnokxoJSgZ404dz5WIAJYETaKdX39XJgewPSkhRC7KVyG5/Tw78ENslGHofWfuPQgnncvBvIUn0Bli6TUCLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718328518; c=relaxed/simple;
	bh=kAy4QYm4P0wejOln0sjgpR597XHtlPQRJDoOhOcNk64=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B0DDR96sUvtmmldkoJ1yDtVgJsm1IO1WtP1b2KkTjC+f8IJwStNRdaijSrU0+GlHvKRyZayn5YqC6JKBTjdr4Zgiaw+2JQFMKNbl4ZWa5R9J77EKkRLysEVwbbDlNH4Lr/k94g6BW37uC5HF5KtC7UyIzNMB362rPujRya4GkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Gw0dP4l8; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b3364995b4so133301eaf.0
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 18:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718328514; x=1718933314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GIqw+lIrHlNp3Ja2na639L/jDhTu14FRyvhFXlStmiI=;
        b=Gw0dP4l8Nl0v/byNuQc38V7cIRCu8YPPR5D4nWR8VvySOBEP7UvcOtg2EHEHz+wG4a
         0D1HGnhuHnKEMBpMl02oP/NJ9Z3wDSq7oI4jPHQb2kF5lpvuYZ2qzEOWIro2GzGZdOes
         t4EsKzmpYoims1KFRPSQ3N5gZoiGsNN3whEeQtJwwEhdU5xOeqSvJlimPGawPQmg60QJ
         BpnZ3PI8skB9NhhXvDg+ETaFKe0G3KEfUwK+VoXkNzdLQ76IWg4VooAwfPwxMwZoD80Q
         qB1FACa1KBAYKXWhnlEplQ0LaZ9cLuH5hhzg8UvyyVy2Ex9PNqKyKNqT03mZNeIsZmSp
         Ibuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718328514; x=1718933314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIqw+lIrHlNp3Ja2na639L/jDhTu14FRyvhFXlStmiI=;
        b=gJUWUtHYTNwZ1lJhwAQ6OoFY79whP3DDnOA3D1L6zZcydyVkGO7ljE9PHB9xoKoE8S
         x6Ou/D/mmtS7Rm5hTzd8dQxAxU4XhUE4W+znQdjAm6kUbIVDOSAX6wpmMnN+7bwtgy7Z
         8d2JCW9LVuYEx1w5CiaU5EAlzuROfEqwAoZE5D7NrHWz3EJkFp1nzbdYJWbmF6vWvOmW
         VSSIks7MBZMS0FYfx3zx1m2EOTzem+WYRFssAY9kn/9kIQNKuQVNq2vYJqoflMPez+v0
         SzDafTZJ05Rd40/7J64XBNEHDH8N5h3kwOaH88AT6omY8Fg3cM3VlKzY/1++drKwMa87
         XA/g==
X-Forwarded-Encrypted: i=1; AJvYcCV6d+JhTlaW+9aAEMmbm6bhucaQuzsfWNCQZFYZeLfKem55RuN1ln56r40RN8nVLRBOIIYu5zxHxLj2g0oUUVdstcSRUfyRDs8=
X-Gm-Message-State: AOJu0Yw8TLbuNDxd6YgkT/ZPSzYE4Id3gG3RumS+2F1IWb8ZbmVK+G+S
	H+HSad2FA3T4dKbVzIT2nd23ZnpARZ1fM5zz6uyf4L5hHqj1Zk138A/UYnxddHVRw7P2747dMLL
	2
X-Google-Smtp-Source: AGHT+IHITEitzqsXprJFx4xSbyaEdkdTYCpN+vhffQWMpryu+R9ms/e5ru7TNT6qkEzhsp5v+kbFgQ==
X-Received: by 2002:a05:6a20:1584:b0:1af:cefe:dba3 with SMTP id adf61e73a8af0-1bae7b3d2c7mr1832253637.0.1718328493877;
        Thu, 13 Jun 2024 18:28:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f8575b119bsm20082135ad.27.2024.06.13.18.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 18:28:13 -0700 (PDT)
Message-ID: <6d0ab5f4-45d5-4e16-bd4d-ae14e29d5f32@kernel.dk>
Date: Thu, 13 Jun 2024 19:28:11 -0600
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
References: <000000000000852fce061acaa456@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000852fce061acaa456@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/13/24 1:38 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12980e41980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
> dashboard link: https://syzkaller.appspot.com/bug?extid=e6616d0dc8ded5dc56d6
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13526ca2980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144e5256980000

#syz test: git://git.kernel.dk/linux.git io_uring-6.10

-- 
Jens Axboe



