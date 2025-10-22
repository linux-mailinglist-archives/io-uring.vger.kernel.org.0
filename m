Return-Path: <io-uring+bounces-10118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B117BFD7A3
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 346F7568E31
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C18B35B152;
	Wed, 22 Oct 2025 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RBdBgzab"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AB8270578
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152258; cv=none; b=nWXUPz+LIIx7xONZYTiAFdWmXd5eUg8DhkI3E5XCi+ZfGmimmHW4rdLRR7KcBxO3bDmx8mezl/B7+yLoIaNBSIr/pLoZ2XRMsp1vSGg1LtdQQkt5vXff+quEoEwDIz4+XKEwpeCa8hQsl2BmtAA+FZfkzsBPaD7Tn2LfyVazvF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152258; c=relaxed/simple;
	bh=hz2KqnJT/1JP4zm0gBrv2S99SgX5tWoir1yn4WqaUY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QyUumdHy+j6EgWbiSq+wSKXYkwNNDRXAdrKi25JbyiU0eK7ko3rfJk/bP1FqurBa++ymfNjUtQInnX49pU/eVZ+fRKTXYDUHEd09GD1azGjDecPVrQKFcVkmNinYMTp1Cyam8H5mABqJMV0/eCM1lisEOeaUihV7YM68t2+45dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RBdBgzab; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-9379a062ca8so305684939f.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 09:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761152256; x=1761757056; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3SNWmBNYycnFMnZ9ltyZrYni0qC8gln3cSgfx8uUxIo=;
        b=RBdBgzaba/H3vvg61IDR+bL6p8XgsWvnauSJdWYXg+TgeoVklLReuiCo2YcQqMjXNK
         kAG+HL1Dpe+2PiDhySuVlCOtqymIgZFwBYX6pTQyFY0PXXebEZedliKOrZiAFot955iJ
         wGlZXE3W6GjOSu0RUKhyWIQVZMbTP1SoWAszIwQuKJ322aaBYsZz3TNbPWFH4D0iPvzb
         R/ly/Ez89OI4kd9yG88p40OT+MHHd/h7yKjFHj/swBJ65+JZNopO62v5jeZz+lEgn7aZ
         P7eE5pSoki0Uhn278MlKL0WQ70Eu0uH74uaBoYA2Eyov7PH8aAAZv7fW1wPjz4PK6TKB
         pWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152256; x=1761757056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SNWmBNYycnFMnZ9ltyZrYni0qC8gln3cSgfx8uUxIo=;
        b=hYhAEfX2r80iffDxg4+/Tg1cnUDmgtQzgG5OseDqYdyPJP7rwLHXWpjScntiRSwm+c
         MyA9vZFqkUfEVq3lCQd3oyIvOQH4v0A4MeTh2xR+ukMhbkLw6apC8ywA23bW0UaNjOsM
         ke6B35CBoNgw9UfmdDmsuMqzh2V5urvkWEj1+LsiVc3iqCdEt1K8sdhs42ix4rn5Vxim
         C9DFFTsSU3k9YO2SGPc+PMb97UYDURZaw6TJOXEl0FfNglFaZLJrUuBNLqFT8qY/k107
         FSutRkUlrQhUnTD5Xph7buE0dQ7fOR22gK/miSkXv9xMuA1NoNoXr+S6zxrfCT9Ywdaw
         CoEg==
X-Forwarded-Encrypted: i=1; AJvYcCUie17P7DiU/ZH7rVNnsmNx6d65cPcYEC5pLIWvJMkA8mvBIrj/baXsQFF50KeL6X33ZKe8S0CQUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYMevA7fTI9UijQ984A8EXo+zttRRCVFpX/pLw5xtT/QnUWqhK
	nF9/DQ6I+xjQ7UB8DkeqS2LecmVVM3rIcAxAyXjUNpcTQC0JqmLTGNApLy1SKoyxi54g34dKiqt
	hCqGX554=
X-Gm-Gg: ASbGncvEKt4OQHU8SrKtGToHIpQpFuIUNf6f7vqdJvTGXqUZ7L4Cgyc40xqsY3yxKHF
	uPPBSart/XWnM0KPVPRAZuglYKIil99gepiA1EWJDwV2DDyaZmPV+07L5goQhDB1t9W6Fhdi783
	wcvoCcxLwoRzvBQPUBRMQP2JYMCJKuwGNJ9yVCpf3gLW/42cipI/1DTJKWTDhjKTWQc81Wk1vgF
	LCcFj5bIA/Et1VBcaqNQT0vq6GkejwWNxgL8rW4VhdmfoyCP34J4jtCRBcjQAz+0GIG2sL7hCu2
	DIe53xkNLu96YROXGM/OsWl5tI8thphzlzszcTZ60I/DRKFt16j2gOO/FmLAXSVF0qrrYNUDIu+
	rf/Mtyjag2cbAq6m7WZN44WKC8BQCjnm4KtjI3ooVn4XOWdgtuFrX/c8RxfeML/1kYfe8vVAI
X-Google-Smtp-Source: AGHT+IGPKlNGjUd+/kFqtPdz++PqNdakIcxbRREmNQI9XmJnEqFPibBabXY2XO9gisYboHJmL2raag==
X-Received: by 2002:a05:6602:6409:b0:901:3363:e663 with SMTP id ca18e2360f4ac-93e76451522mr3282152639f.13.1761152255605;
        Wed, 22 Oct 2025 09:57:35 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866ca57bsm533243639f.14.2025.10.22.09.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 09:57:34 -0700 (PDT)
Message-ID: <daa4b583-b978-4e08-89eb-3ccc316f7ad0@kernel.dk>
Date: Wed, 22 Oct 2025 10:57:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (3)
To: syzbot <syzbot+ea6ffa4864ebe64e7a04@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68f90cc1.a70a0220.3bf6c6.0020.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68f90cc1.a70a0220.3bf6c6.0020.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Bad commit, fixed up in current tree:

#syz invalid
-- 
Jens Axboe


