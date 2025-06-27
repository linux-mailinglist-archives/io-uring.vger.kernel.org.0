Return-Path: <io-uring+bounces-8513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DBDAEBE39
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 19:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FB181C477FC
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11672EAB8D;
	Fri, 27 Jun 2025 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bgs+tf7e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071AF2EAB8B
	for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751044068; cv=none; b=cSo6dwQHq2Z0Jpk+1Om39AwtHB2Wk60/C2oTcplEu22rXC3+pAsC7j0lopi7KTDe6PpccQymdk6eleu0gVLRAqeFqfkDrVeo5fMv2mK1eoLoPrj9SdI3ZoyvqsHXCwqqBsFqoH53PjEKQaFBbIGgXLB5Nrsla9Rf7+aDa0wAjVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751044068; c=relaxed/simple;
	bh=9R4KX5LVzQeRCDAlhZSrpejItAz4c788fhDtn97W/Jk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=V/oPrmLCyIFQmhfbcgSuJpmyJIKZu0l+9TQajISorrp2llrDeN1kxTZIyqTP3DVvrFeiWAtz9Z9oTrG/0P0+5G2hTgrjjwnB2WG1ULlVOPaTyn8AawiX2mdG5XAJaXoMmnrd6MRBrr0ZHFTAGUWNwgEVO5VvTumjkJLAgOgITtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bgs+tf7e; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74ad4533ac5so2980918b3a.0
        for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751044065; x=1751648865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DKFOh5pgpozqfr41pG09hBVywmt+Jc1GMULv0a7/G90=;
        b=Bgs+tf7ea2qxgqilFNS/K0ayKjFN8OGZZDqULQzdthDetTSHTar1KYGEwOHTnCPay4
         lgcnKEbyTHufgGjcN72V0Sd0oBvNI4dzX1tLvFOE0htHr+W3ElfLIn7N8/K0XNwL8i6L
         0TgkVqqLmu266FsqXvYbVfGVtRkB1hjieaQyBcfFot6WdHPNDcbNg4xNSliDTElpaWeL
         tUNZiY0NSy2QVwjSJetUyz+LVIF5ZfCJ2IWLUe97u1w63bwJAzG/whPERzFL8IPlEtsK
         Whpft4JXHAGQrjQBsn2HSvfQTfo0zfRfG1I5tUGmPLaBUKFZU0kAwDqJPfzQeWogoYJJ
         RWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751044065; x=1751648865;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKFOh5pgpozqfr41pG09hBVywmt+Jc1GMULv0a7/G90=;
        b=pnQ7kxnreX6BDtBC3ZAki0iN27N78Rc6cm0/t9QfQ/mkqQPdv7Dc2P+aL34X0PNzHN
         3z6oHNq9YUM/Y8Fbf8kKjJzqphOcVhd7A6BKBhqrQAUT10moSxgr7pDjsvZiHe+JIEXw
         +FHmesb/01zZnD9SxB8cp9ZC34n4wMRgb4ZBD7+WGK8SmuhhiB/0l1jc0Ls8FonwangK
         3DZGWSDCOAL6tmoB1fc5q6ZBtItW+D/z+CsRGtRl976HPy7oKBp1tZ8JLVQFCw1ALxx/
         qywHqz94RmAj7JluiYh+oNTIZ2hMWUbzOhVpSVP9qwi9Ny4qdrGRl32mpHpzxz64oWfL
         TIkA==
X-Gm-Message-State: AOJu0YxsuMcLvBcFaJf+lyOFxoJHBsaKYzHzA2QVFN6KuksHVdfiMTdJ
	rhN8yIVf63fF9qOZvRs0EU7Keb/1ry/v/jZzSm1Awe2mEHgMFOTu8jWmlIRH6cGF/v1D5s0Qlnn
	slVJp
X-Gm-Gg: ASbGncs7S2Q6H5ZZpWnne2NZ3NWbivYl8fpbrxnIgwISJ8XqRl3XFaHD++AACZ/vsbX
	2wVqmTeINAbRqATP9F/IjAkKtO3dcTQUs5Db45TjeIcFb+450Pxoigd/KNmZ1lCr7zc0n0uJMhJ
	hhQELL83PAsWzNU8tr0kj2GrShY3Vqx8Pe/TMk5HePx4xXap+vOhVr7fc4JK5tjwKnM48KJOQws
	vXNMQd/mBG/CjZ5R4KDX3PxUIiQnYVypj4rygFoO5SL3Z5JZb69ZsV5fygN1a0Kp8N2LYdoW0iW
	BHkzjC4jTVDAQ4IsNutIFfFW9pr8Ou7T+htcAzDBU346aeEC6tdBtoToTA==
X-Google-Smtp-Source: AGHT+IET2xadnrSWzVc7LaA0b9mLXiuRsIEBEia6Q6+WKlU0qLyZik+nq6ExFBljf8KkZYW+Nvol5g==
X-Received: by 2002:a17:903:19cb:b0:231:c89f:4e94 with SMTP id d9443c01a7336-2390a54135bmr119273235ad.21.1751044065091;
        Fri, 27 Jun 2025 10:07:45 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c14e2236sm2621251a91.26.2025.06.27.10.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 10:07:44 -0700 (PDT)
Message-ID: <a3e2d283-37cd-4c96-ab0b-dfd1c50aae61@kernel.dk>
Date: Fri, 27 Jun 2025 11:07:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/25 9:01 AM, Jens Axboe wrote:
> 
> On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
>> Vadim Fedorenko suggested to add an alternative API for receiving
>> tx timestamps through io_uring. The series introduces io_uring socket
>> cmd for fetching tx timestamps, which is a polled multishot request,
>> i.e. internally polling the socket for POLLERR and posts timestamps
>> when they're arrives. For the API description see Patch 5.
>>
>> It reuses existing timestamp infra and takes them from the socket's
>> error queue. For networking people the important parts are Patch 1,
>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>
>> [...]
> 
> Applied, thanks!
> 
> [2/5] io_uring/poll: introduce io_arm_apoll()
>       commit: 162151889267089bb920609830c35f9272087c3f
> [3/5] io_uring/cmd: allow multishot polled commands
>       commit: b95575495948a81ac9b0110aa721ea061dd850d9
> [4/5] io_uring: add mshot helper for posting CQE32
>       commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
> [5/5] io_uring/netcmd: add tx timestamping cmd support
>       commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a

Pavel, can you send in the liburing PR for these, please?

-- 
Jens Axboe

