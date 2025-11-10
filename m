Return-Path: <io-uring+bounces-10507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F0831C496C1
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:35:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 482904EDA7D
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2771B2F5A02;
	Mon, 10 Nov 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mGgvZe7H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF7A32C94C
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810469; cv=none; b=GbTVzUTrNIHr/PnIuWZVQ1MnxFnC2mHQfA/y1q/lm8kzCPL20bwvfkyXYGPQLJWVVXQsAXla3Brf0uuw6eiwkGshqqjmfGCo9hW+IyTghAFDp6tQpPgsJVY35tG8aUQE4Qp6I8wSTGh3bvjMBmpqEF+spqeRO8VC28yZwbHZztk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810469; c=relaxed/simple;
	bh=szXidnfSHp/ow84h94BRGf8QEsQDbBaKUG46IDLxhUs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=Gek5LjKBKzAGl+2F2sKZCxfkE3PiBz9v5wVCCfG2Z61qISoJ1ubs2iZCfa5Vs2mzpw1fQNDzaAF/9BvTsKHZ/4uKFj5SMBAg7pa6kIF+l6rsh9ItFYY00mKR4U6p2+dN3KLFXhOZT3yRj3LxTr5bOC8hOwUyXIS9Xv1T52cmz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mGgvZe7H; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-940d9772e28so125996139f.2
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762810465; x=1763415265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=szXidnfSHp/ow84h94BRGf8QEsQDbBaKUG46IDLxhUs=;
        b=mGgvZe7HV5wPQgQ20lPLVdR7VFp9qYlH4aDQrkoYE4RDBDymV9iO90rFGrQaCqtx9G
         dFdKivTcYRIU5+wXUJSokiHdoVU2Yb81wVSN1tAI3eohfcMnBpjuxKVUerNhYFkaEQKK
         zUzUJC36jEj96dwh5vsnC7SaIDr/tfQWH5W0ORTWtcV1h+ClhITLS481pynB5ut3Ju5E
         PgIiRriFIXF/Nkfg+LwOQ1bU0BO+t18Pb50mWXuJbE8oYr2Rh51Ta/btJJY2E3bT5X3g
         teAcfONbq/P+NBFLq1nFQmrvlmVrFAmTC52ui9Ni3PwzI0qNDHLbT1epQxZ+O4c1POHZ
         T8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762810465; x=1763415265;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=szXidnfSHp/ow84h94BRGf8QEsQDbBaKUG46IDLxhUs=;
        b=NrZKbuwPqRd/kC4hYa/sWi04LMxMPplC9rjxFIZRFUXDY6Uk12SVplnEwgFPCyl7eH
         Pw1zJa5bfXoELfvX7J3ZSDUN6HeybbnsGnJ+7zEPjSfhfCZ0ou/cSowZB0potFmzcXQD
         G5D+cVgFOUocxKW5Z3kvxllSWEZ9AkWwj4i4EQDlMBB/TDgG2hYB/IXwtafMaKar7gwN
         pdtfURogzJney+b+drco3PwAZW/vTFazDim7Eggq06o7uWHX5HQUCDaiIGYvmJl+545h
         aaCowF/LSityn1YQIMBgIdSDTRIYIorBDtx//QzcLy0RYMX9UzjaTNG0DGwmQKZuXzp2
         d5uA==
X-Forwarded-Encrypted: i=1; AJvYcCWGgx8iJNk9pkM404+Rxt2KMrUEhFDpBUbeGhJQZTuQMUm2/5NNeiBfCZEg66SQX3Y8lAkF2QMcJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4VSnAkM4TJnOF3axki9lEyAjJBdEUtkqFXEkFbXM0qA696Ijb
	AYyDGEuRKFLSn8lDychRQqpSyqvIHtAVseCV8XyvUVyFQQZhluOYSj9ptJhhCtRjxno=
X-Gm-Gg: ASbGncsnROwj/fj9gVeZRcm5iJdz7JdLmKiXxcGPNqpBGw32YKEv7sA9vFF3S3/MA4y
	hrog1OSiN9v/j+buU+t3vcqWeDUzqhci9pnh1p/ADjZobtOFniSuGZ3T/G6/nZKZesH1QoFQ5i/
	o4V39K6hyIuLX2o4KfcuBXVawamnXfb2+08t92hnGPW8LPHSG1WC5woHZhnICwxcXg7MRM5CmJJ
	N9/Hhth9nfP2Lw0ZKZ2RYfBahIY1SoCSSt/nDjxYVmsTUbPpskZUhzZ1vcuPPzSTSKI5Cg5egH4
	RMroVC3XGOkyFUEGzNzfAm74Ft3Zdei2Ky568ZRtqQJXo7fyewju7wTM/5ul2CWPCMX4DXZDjWw
	Ee9Eq+zkrhWHVFz0DVjC4uEHtZahrlqRPSc7mIJK03X7qJjKebpwfYgeb75QeeVuQMdCT4Z8zaB
	lwcXH+Q4A=
X-Google-Smtp-Source: AGHT+IE0TV2i9Xac0yWSg0XTjz2YaCL69PoVAkX/+DCduYMIl8DU/riyRFfLs42dKGATdWiTSQDxvg==
X-Received: by 2002:a92:d28c:0:b0:433:6fe2:6b00 with SMTP id e9e14a558f8ab-4336fe26c15mr86442765ab.5.1762810464979;
        Mon, 10 Nov 2025 13:34:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43375501326sm28907245ab.5.2025.11.10.13.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 13:34:23 -0800 (PST)
Message-ID: <d9753537-b2d6-450e-bd7f-7bd86dfbb7fe@kernel.dk>
Date: Mon, 10 Nov 2025 14:34:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (2)
To: syzbot <syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69122a59.a70a0220.22f260.00fd.GAE@google.com>
 <bb64cc89-194f-4626-a048-0692239f65dd@kernel.dk>
 <dc9790ff-70de-470a-b4a1-d85dc5b1cb23@kernel.dk>
Content-Language: en-US
In-Reply-To: <dc9790ff-70de-470a-b4a1-d85dc5b1cb23@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git io_uring-6.18

--
Jens Axboe


