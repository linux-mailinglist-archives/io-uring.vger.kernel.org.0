Return-Path: <io-uring+bounces-4326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A3C9B97C6
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45B0B28168B
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAC41A0BE7;
	Fri,  1 Nov 2024 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FuxBna4B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB867602D
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486398; cv=none; b=spgns5EdekeugFjnFQ8/rOFe/vEKxtXc2h4WF8guY7JvvrZC/JAtfA8JVa6GE9ElQ3IK3d8QALFaxhyjjUK9ngEAtCTmNUCb4pHAfCi/kCVWSiRrCpi7ppmNN3HXlq9VuIGBkdi37FEy7dyPkcGI1dWl+zE3K+IcCIBcw591rTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486398; c=relaxed/simple;
	bh=gLFicVklt80PjJRUup7NzZ3RMY+vDlNQeAPiRz/+8DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T28k6GfiEyqEFA+PIk9x0GMCDGdkUn33fh7LXOT2M7eNfyy98Oj4nmrtLU3MSeIZI1PyU5hxws4C4r/OIJBhkFBZXTvfRXsX5/lT/Dn4GGob2Pm1C7YJ8mnZe5oQrs1VwjA5uEryh4iTYvEdUpLYEbo3og95b5BZhkmWu5p0aV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FuxBna4B; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2e8c8915eso1706774a91.3
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730486395; x=1731091195; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sv2NPZj9ucZ/NSKlLvd5WhO3WhafG+dboWd3jlYO78g=;
        b=FuxBna4B057ASPGwRpNoxVnOT+liXvwENGsZP7rj7Sdr17htr6Hda/EDVWM952ygQ6
         g0WOKiM+/eJeuUQBPSpgtSTFPLENBhopFqYH2ufe72gH8LPfmx7eKtjcRieojonRgVzv
         13E/KXiXf8jQDi08U/DI2sebFuo1uUvPIeN8pizGITn2vr2jP5KDw9V+cjPHJcOZftxl
         9k0sL86itPH/4EePJwJnN1t8JGzhoD23xegHOL2dzFr8/+znz4T6f6vB5ZdKTy41ruF0
         YIju4eQdkMXbbe3QMv9EH6d23/bmtZXTF+OLE4x9x53jlXpJlCFjZJnpe/0r0qOM5YCs
         fQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486395; x=1731091195;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sv2NPZj9ucZ/NSKlLvd5WhO3WhafG+dboWd3jlYO78g=;
        b=XNqX5G26Rc8dyUxfTuElY/H5dPYLlVL/SIOnvgeoMh4dYD3zg5i9kr3260obuzRpAB
         kOBbT6VLsI/xW6N71mq4VdVlMcY8/omwZ4BwnuAe0STJFxAFjFU2zXijL5UDqoUjenBR
         Fer0D1rQzLWVeCRa13Tz37lS87cfGUKPQuaqqL4N8S8ZvvEngoGKIJeKxEtCDg8oqJTj
         8shy9x5dIKUL0LA+6uLaQJ9kubdSDRJeUejRIL5zd4x3docGrTcOQSatzl6Z3W5Vi+Gi
         K5ZR51v+7m/+YZMVarDXc2a0eT9R0pYBQJUSoSOXbJj9nqzh+m+f5CswdIRF32ejUcLr
         URHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4rW/KJzZj2SEiSVxfu++1ePgiyi4aSl2ECD6Va8qLqTGisQeqEITv3DAO3Zm4HkUwbXo68ybQUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YycoxRFNhJPytoNgs043FLUbqcLKduglwnplT+KJYMbqIHJh/I3
	LyXcFroYTqCBU/qJDMnpilGcO6HP7cEQx+lHFKQVezPreMOr1bT5Zr9rWq6eZbg=
X-Google-Smtp-Source: AGHT+IHyHmDaBiU0gczCLybLVKw7JNUuwsQogB3UD8nqD/VkAZDEOR6GontfpKYBmoSqcnv0vsxgvg==
X-Received: by 2002:a17:90b:2e4d:b0:2e5:e269:1b5a with SMTP id 98e67ed59e1d1-2e94c54a67emr5395853a91.41.1730486395259;
        Fri, 01 Nov 2024 11:39:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93dac02b8sm3045545a91.28.2024.11.01.11.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 11:39:54 -0700 (PDT)
Message-ID: <4a7fe7a1-02d9-4488-8aef-b4c3851224ed@kernel.dk>
Date: Fri, 1 Nov 2024 12:39:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (2)
To: syzbot <syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67251dc5.050a0220.529b6.015d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67251dc5.050a0220.529b6.015d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 12:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f9f24ca362a4 Add linux-next specific files for 20241031
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=162bc6f7980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=328572ed4d152be9
> dashboard link: https://syzkaller.appspot.com/bug?extid=6cb1e1ecb22a749ef8e8
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f92630580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126b655f980000

Ah forgot fdinfo for the sparse buffers...

#syz test: git://git.kernel.dk/linux for-6.13/io_uring

-- 
Jens Axboe


