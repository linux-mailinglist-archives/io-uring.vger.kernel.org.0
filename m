Return-Path: <io-uring+bounces-1024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 090C387DAA7
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 905CA1F22ACF
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1F84C9F;
	Sat, 16 Mar 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rqokYOD2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FA41B977
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710604910; cv=none; b=jSxt0a7kruUaUAieSaSJFEhsljg4+s8K50X6wSNfN6+8GSjaOQgIeEj7zAYDLEijxPA86yFxDXW7V5isEwubWn2dxQ/RYuk0ze/AbamUn1F2uoEl5H+gLtBjsWCxonBhl+zK1a+tLE7CLofcMru6j8kOshowIkceP2Fv1f2njgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710604910; c=relaxed/simple;
	bh=9IKAL9O5Kzhj2bWwcxxcLVVHc+FpAsBJbr8QW4g4aUo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=IrunxgIucKl8t5kxO69L33KSRE4Nb7OiQJeiexarLkxDNvAgkZTQoV/sJ1g+2UrrjBdxRPu8erv99S93XD3mscIMrtF6ih/+W8eNoNw3mRBo01UkhF3rh0zddmi0kILQA0nlu6prLOxxBK1EoqD3ARIp+ppctHWlAqvwbaSbK18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rqokYOD2; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29d51cdde7eso967379a91.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710604907; x=1711209707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=rqokYOD20SWW9DsrtWYX8cNrw9Ft8I6aeqi3rku7zUhQgGpamhNggIIsJEao7Dm5u1
         OeOoQ0OcLnxlwE5A+0bSUyg3VGiivqKdNQS5ILvS/ipsGSCibnZJ+99jxhYNmhJdAbYy
         MEZqh7Ct2W79lhYAqrWg1Szv7gBeuNO6yofKmvLZB7cisEbHz94sPMmBayvS0KOpQvPU
         cgvcpk85sq4ruEdKohSyOul6zmQk3kiNEm49BqxYw7VuDLeX9kjfhy7jfkLVqNPIiWNr
         1I7ilkJxUvafIU5hRbftiXTlOt8nuqypE0s8i0u06N0q/Xm6/X+YRdg3Us3aroKN0Al4
         6htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710604907; x=1711209707;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=sawE1qicGJlRdfjeDkcNpGe60H7xIuj2u2QpIyvB1xfcB23rkLRfCJh8Ze5qj2byzb
         DzGZhLZ/P4gjAXRu5kn3iUlAsPyBO0jNomjFKj3YghFjBbmBSPGi+qwxp0wjdrsyAAel
         +udvcntDtp5bkvN18DBypywIs2E1Ah3a+eyWYOlDbW5lFH88c1jGk6Qur7U/AkusdVwP
         s3LrzyNqKgJNGjvKJX5ieyazreQXbhaen/8SMo9vdrFDnXr/cJs83trs/zK6Yt8hPcWy
         nqXmk2mYDOAJjl0NL0DvyzyV506uhRTcVS4fJPHtvFywVgtHpU7wSynWsI2E9rnF0xP8
         QbkA==
X-Forwarded-Encrypted: i=1; AJvYcCWffq8lpvVEhpwA7Kg6kiKlpEL+RbywfZ4uzRgN37+J/jY7kKNlaBZzA/I9P4zbV40AlPi0OPT65RmCEDzKZpMKZ7Bc/xvlXlU=
X-Gm-Message-State: AOJu0Yyz1zYp+JjPbussiNJ+EBbm7vcrqxCVPBjSqkapKWde7GZtLJTN
	UTgDzb07FUcKPBjlto49nfk3+9fzx2dz1ut+QcVmsIp7baka7E6O+mWBDqI+XSE=
X-Google-Smtp-Source: AGHT+IHbsvfRDn3Snkti4bsuArFO3vZ6YfBD6Q0keG24YamFPMh7ZdVPis43WzMxcUmxzytcdOUM+g==
X-Received: by 2002:a05:6a00:9382:b0:6e7:1881:b243 with SMTP id ka2-20020a056a00938200b006e71881b243mr752842pfb.0.1710604907256;
        Sat, 16 Mar 2024 09:01:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c11-20020a62e80b000000b006e6aee6807dsm5093899pfi.22.2024.03.16.09.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:01:46 -0700 (PDT)
Message-ID: <6e00b097-99db-44dc-a87b-08925c1f044d@kernel.dk>
Date: Sat, 16 Mar 2024 10:01:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000024b0820613ba8647@google.com>
 <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
In-Reply-To: <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git io_uring-6.9

-- 
Jens Axboe



