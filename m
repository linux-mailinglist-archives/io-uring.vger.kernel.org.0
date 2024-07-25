Return-Path: <io-uring+bounces-2583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E2F93C67F
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 17:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260711C21B9A
	for <lists+io-uring@lfdr.de>; Thu, 25 Jul 2024 15:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255FA19CCEB;
	Thu, 25 Jul 2024 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YdpecnYi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527D1D545
	for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721921641; cv=none; b=YmnGeKN5pVt85OafXh+N8gPbG+jxQ0PVpqbPbn5ACC5FH5siwwFFeTBdSmIpKIT6oLsQTNlPxLCQS35XUiei71sQZ6KeBXx+uCeTnak2/cgl63lMZDeBkiqJ7negy+p1j47ZF8/C8RElJFU3vw2hRm3+yOEjm9/1UCVp82Cr+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721921641; c=relaxed/simple;
	bh=hcAwhUvz7Q1/dKBeCm7fGrp1f/oik+mo9ajeMqX75l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iDgxHkrHh79wjfIyASeHz48opyRWu4NLzmUEPPnAOj1/oxOavdt6YsxvJdxIG34iWt+uadTLh4MbpnuISWwmN3xWSZAXLRYjJNaZ9eyI7U32TTTeyrIPypS+lw40U/JkSfWVf2wSROsDmzmd8XAjgL2jcABF9zJOi1kVUDmFCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YdpecnYi; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc4c33e746so856405ad.2
        for <io-uring@vger.kernel.org>; Thu, 25 Jul 2024 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721921638; x=1722526438; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g53O1snI4oPFwCnbuNKYfO5V/N74kXxNW+Iv3dJPjrc=;
        b=YdpecnYiEy84VUoCWsyB/i/ioMQ6mIhEAKGQJYgH9JCFX9VEso4lSKXRSCVQJLh6o0
         lUHb1VhukNwhYAZ+t70oTeoUPG74nPiydOGwZ6EfkYnfSYLpZD0uqdcaYoLnHcHxKYge
         zX/578jCiOaOlXUZTgBgFDhTcnXCfmw5AhZpgn4nKHDgk+xxtaDb63z5VH7izpVB8qbU
         tU8ofttDDlFPCKtSRSHZ0YU8YKgKH0DfuQ7K3vWjATgRRWe9sZcT/uCDYwsaWSSlFkJr
         akEVoilPXrjjOOqj0tqHG9qNVZhqbUy/69FHFqUEpQiQ2yRiDPF44zp5TSGCU3PfRBGp
         zfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721921638; x=1722526438;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g53O1snI4oPFwCnbuNKYfO5V/N74kXxNW+Iv3dJPjrc=;
        b=ft4RLdQfhytZ8MXh44PWPf/Hf86TFw1pTK0OC97OAKB0e9F/hMUgxTPMNkdl4qJgPR
         7qSK/GWE6Koqe6GZrVBVlIlJpg5aaQ55wmo7yc2BRks6v9JP7ueHaiBT0DCewmxM/8gC
         OmhoimKU8J/icY7yORYYN+uMaDHv3wRz9ZPwvnU14Je96SWAHWBcAMtBuhYjfGOsLNQh
         dxY9ysYqt8A1uRm1zoAcYDY+0nllKvoAIjvKI2yUo5Gl/TPtYsVWg1YwsQm+Am8UFmKF
         Rlz+RWxpU9Ko9XdfY7oaZj4HtFhxZdK0OjR8YUGTNaUjEzYyAqi79lANjqwVQbWnuCd3
         q6Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXqRtHMJ5+ai+acE3yD2crc9Yv1ixzfmlIQ3MGNUBzne0t9NQTTV/2so0noID3t79P4qRTKK/xdiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YydCOLJ4dpOnhmT3dh+TmHzicxUM7KIE4zjanBUX+TZNPbQoOF8
	k9gdTOOIPd+PfeYFyNLwXqHGPLtG/re+39ieTRODKBDZNwYyp3ywtSySYLCbKU4=
X-Google-Smtp-Source: AGHT+IEynBpKdaXa6q3tBg0iKHDslLDr5qjduvk2y2DBCWfufQXNXfHFcrhbIA8/bZdL6S308/W2HA==
X-Received: by 2002:a17:90b:f81:b0:2cd:1e0d:a4c8 with SMTP id 98e67ed59e1d1-2cf262e02f8mr1998913a91.3.1721921638031;
        Thu, 25 Jul 2024 08:33:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb74e8769sm3717131a91.42.2024.07.25.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 08:33:57 -0700 (PDT)
Message-ID: <5cc61aa9-0088-4bf6-8fd8-a47de626a805@kernel.dk>
Date: Thu, 25 Jul 2024 09:33:56 -0600
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

#syz fix: io_uring/net: assign kmsg inq/flags before buffer selection

-- 
Jens Axboe



