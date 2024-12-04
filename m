Return-Path: <io-uring+bounces-5209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 404F59E41CA
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDED1163D64
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D8D1A8F67;
	Wed,  4 Dec 2024 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZKxUaxLc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620391A8F64
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332067; cv=none; b=tqLjSahpia3iYlTXuU+pG/zw6tXvm81/FzRyFNQ24NomaG1bxZnT9954aeybGJwG3GFy2ToMHBRMsl3V44jW9lxBbu5/NCt4cADV6eMbQ+3CNpfjDcGE3xjyMpBYEObhITmciAesgOJtTlIv/QEfXOkz7SSmHgNdRlAjr+8VrPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332067; c=relaxed/simple;
	bh=5gCPZVrrifqnSFAQWHbs+OifVGQuIbzw/66LkaDUaWg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=O4UCuVNGwYuvlFkEZgozf9t2inPrU11lkZVDyAHB8+MaFuA4tq8DsTvWVbBa5H3f14ZvlIXXlokb80cTQvf5IRsHDP3sof7kp3r0kpJxepzghZX7RABIFhD+UsS85/1hXAl7lh8ozhn6x256OCKUI+D9LAOWGzFyYgEB/YFAHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZKxUaxLc; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-215bb7bb9f9so21222835ad.2
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733332065; x=1733936865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nili2EeXhBBnCR9E7SrWkjme6AdYdFkZANnDcpM0kP4=;
        b=ZKxUaxLcWN7eCkXKCmy4YzLKJ/ULa+lNpDMxoStVairfiIesM0k51wCtNS1ZC/Q98e
         m0edDM+rp4b4mGTF/WMmoEJDpOIJAySG6fOUChnt5Bp4y4i6jDwPR+RTt0prZh531MFM
         QM6FAXUfqAjAfQKzZWrcFTNL0UjBcTClMp38NXkhtRssZBKaeefyzuDhgvTL+M6C4lUV
         5ME+RNIyvPBQNbqJtXDqt7IIzf+/Qfxqutk1MKbGMh2OVXfo+k0zUW9DFKpT5TkpeJMi
         MTVy+XklX4JGEqkckApvuQa/iQCgeZIo+FyrfL2U+KnN9mEXTe5mkvjFxQCaiMaWxAHO
         nzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332065; x=1733936865;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nili2EeXhBBnCR9E7SrWkjme6AdYdFkZANnDcpM0kP4=;
        b=J98g9KRAvYmcBsnGK/FOBbNWUA1XV1/HobznaX7lB4iGFn94V1pwrqDbsZcm6R2eIF
         PVXu6KEMKYPnf5gz+lSghZJrOA85b9ERpGUZXOEkepJwjtdMMUIS2PTBAfqLAXzUxidJ
         +fMy98SJdAYZQmbbSENlDDOifN9142dweVZG5IdjJo98ZARpirsfgJwRPIbGHQP1xUFX
         hTgu3jRCVUORvM5buJEz2ynuTfZDLIS1I/5Bwg2If72UkcLzXHuN0kOv9+cKYQQQx0Qp
         gxThW5K3TiOD+NjW2YNZ0KZ27vNvIUIa4DqFE5n5z73r0u0nUSCfSar5JCI9eyOz2g9b
         Tong==
X-Forwarded-Encrypted: i=1; AJvYcCXlsRKhQLfo5ZQ4kPijAkTIjCH2WyXQZCd0g1mpmldqbMaE8m4snGjQZWBcCNLJ65Gm467ecBjcfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIEUn2WGJsiwyDK9BHk5BeROCubaDsJ3j0r8vu0C65Os60/4I1
	gva4H9YzJsg9QLti7R/J9Ct+Hpe9cyd/6HEdu63h/2LKgfZkAe6UDARqzT7HC1A=
X-Gm-Gg: ASbGnctpqt9TS3c0iN9L5P5O1nlYqZdMmsNUITSCZmpdVBs4FJaPzFOU5ZhiusGAoDI
	JfrUf60Nmh8zNzH5UPgDSIDB7IGhs/UEKWm2+JZRdGaxDcfsQpBMNWM7bbOELmc2dbWOiB/y647
	+fpmwq93XA9GY/3o61z40tPghmC1WBNTGkd8ypEBkufWvoYcVnE4r2Vz7LG8ndeiNPAGgwkeQiu
	sOkxKCFs66+mdXZvNcENDxqiJOqsTzRf5EdWii7RW9kdJ4LORz/0LOc9Q==
X-Google-Smtp-Source: AGHT+IF32nHEnke/iHlli75h4pEZRfldBD3CafEcKSm22g4yIOJgDo86HfqDrWjiytqDSkug/TuvvQ==
X-Received: by 2002:a17:902:cf0f:b0:20c:af5c:fc90 with SMTP id d9443c01a7336-215d00d0769mr66857345ad.49.1733332064725;
        Wed, 04 Dec 2024 09:07:44 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215650b3cc1sm76772355ad.0.2024.12.04.09.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 09:07:44 -0800 (PST)
Message-ID: <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk>
Date: Wed, 4 Dec 2024 10:07:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_sqe_buffer_register
To: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
 <67272d83.050a0220.35b515.0198.GAE@google.com>
Content-Language: en-US
In-Reply-To: <67272d83.050a0220.35b515.0198.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz fix: io_uring/rsrc: get rid of the empty node and dummy_ubuf

-- 
Jens Axboe


