Return-Path: <io-uring+bounces-8640-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E301B00AF6
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 20:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E61A156499A
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 18:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC672FC3AA;
	Thu, 10 Jul 2025 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jFuefslD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D70F23506E
	for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752170519; cv=none; b=euUUc+fsJAUtUkh/jNMoOGi6ye6cF5QTVFQAqFnDEGH/SVxlHTHH5+CWPO4gHYHux/vQwybSakJar85fpnp6QY0Aeumakq8plUysj0vHTWWBQvvz+nsJkJzSxX0fmRV0haCmObhF5eeQyukBRC9jYH+xROV4fd+Agm992sVQAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752170519; c=relaxed/simple;
	bh=L5IkKlOj3J4XNHtFh8P5zmvhaqsB1+fRpTkoOEh9Oew=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=C407QDStXcvfymByBX7eo0o95CX2DlY8iEIfTGR4uUl15aHL0yTijC2+XHJQkjfITEObIYswdypitRn8EFhkSnYu8lEMRQjy7S/glXMCvLjnL3UWlhr514KPCmb8D0fHH5JMGzxhmOb3RgpHU+9J4tqDC0JNI79ok/qwdDxIthY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jFuefslD; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3de2b02c69eso7176465ab.1
        for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 11:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752170515; x=1752775315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0gJmPHmpJWqH0mqoGuNdr93R3misLm5TaevNQ3bEZao=;
        b=jFuefslDhErnmDbVhv1nMLTDYOYNWs96jsi8KUcCFTFrSi1fHoiVaGRcXodOmyAstv
         FMBza0ZbcVhnKOMvvmaIWLweGFLZmzRKn5AICELla8MkrvLX+6UXz0X8jakBGvt+k0S8
         gJl7RKiw9TrfEepjCQ2LjXPffHrdZHF6yniFumppjXoYH3Rn7iR9DbYZIDb8dydSAdW4
         Mh6yb25Y88GErGCgFZ0KXXLOOWzEuVWHVIOlbpVo0CudR1mcHBufWa5uIPWJDoKLvfSu
         r1KJUYm/Z5RaVd56Sg9tHL7cItaER3K2EzC0y9MBbYBA5dsBIRxv926l6EyccqeliZD8
         bSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752170515; x=1752775315;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0gJmPHmpJWqH0mqoGuNdr93R3misLm5TaevNQ3bEZao=;
        b=cn3H6xO6aQsmy4ewnN3aIpN74K4+vK68uQcm7Fyuyq0V6cu8Itm0OEyekrncUclXFu
         c1eee8pEsFzY6oCbI40VQ6ckmkt2rxgqPvnvhHM1tbETOnJQxWNBKmqM/pKCSnyF5sL+
         AyhrM/qNjQJwisPLU0GVSpFNT2UrB8HcfpABtH9ogDlxF8FRv6XsxUrSBOx9r8sGTY0W
         0Tq/aHrlbsRMd8oRzAGG34uykR+wFn5y5yn5UfczP9OUGU7gnBnphzFCQWOeJpKGZ6mK
         /Q9jGbTR8yJp6bDwnI5Y3V8+DEc+oH5WCMx4SCBPMeR9ZU+hDxOxZq2WH0CLaNdjdSUu
         UwfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZZSKPGPlLCcvIPBkkbwxgqTsHu2/45BKrg9Gn4kVaUu8/7aep7Nka71qSomL4h14vT54WHmMz4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZDrGJQ6wm8F3EHV0XPDaniZhmhAYUMGKQ4WLg2QL6eE415xgI
	9cMvRLQHa2aP01Rv9q/J/3D2lwgaotGSBSVJQyRheju/yB5hkTQcXqZdYKUcIvGB1wSBF/u1NwT
	a9Lap
X-Gm-Gg: ASbGncu505sMyaB0pvH3DV0nyta+15oQSdhyDBp2Y583g8qNSCDrJqoYddU3V35qN7w
	kvPFbcoS2Bl9+GP9W1Dn7mv3VL4tETO863QXVplbfXkomhLeVm6nDuRyyHHQ66DcTY9ohWiCJ6T
	ULD2mYXxq7EgkW6V7H9Iyye4oR8pkqPJDNx4okPO7MJxEHaNXkw1i/Uv64kiFwOtIOlbf8nHD8f
	Z50dK31yy7Pfs4L1i5iq10CRCjbLQDYSdajPLvj/hPefv+mZcrXPIt21l15L7WT35fu2J73a9xA
	x7WVPODXjKbmz9oS56PKEY53JNs1p5FVtaCNn6GYalbwpn5DhJSB2Yq7F9g=
X-Google-Smtp-Source: AGHT+IGoVnph16PY4CbMSMKUkPDzfgnKRaza6M6yhcl2rhW6kjzGYnA+ONxH4Ld7nu8Dhyjq47z5HQ==
X-Received: by 2002:a05:6e02:b4a:b0:3de:287b:c445 with SMTP id e9e14a558f8ab-3e25318ec6amr5108425ab.0.1752170515179;
        Thu, 10 Jul 2025 11:01:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611c645sm6406375ab.12.2025.07.10.11.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 11:01:54 -0700 (PDT)
Message-ID: <bf1b2aa4-9ce3-4ad5-b0d1-fa379b96c9a3@kernel.dk>
Date: Thu, 10 Jul 2025 12:01:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in vfs_coredump
To: syzbot <syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com>
Cc: anna-maria@linutronix.de, frederic@kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 tglx@linutronix.de
References: <f368bd06-73b4-47bb-acf1-b8eba2cfe669@kernel.dk>
 <6866e5f3.050a0220.37fcff.0006.GAE@google.com>
Content-Language: en-US
In-Reply-To: <6866e5f3.050a0220.37fcff.0006.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

-- 
Jens Axboe


