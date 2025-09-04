Return-Path: <io-uring+bounces-9576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 524F2B44A57
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 01:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEA64A01FA9
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 23:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CEF2F619B;
	Thu,  4 Sep 2025 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OZbge5R+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC7E2F6565
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 23:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757027932; cv=none; b=sNXz8aiCx47y5zxyuG8aoG92Fba1XdUMhBH2tXgnTjNIoSRvotJqZtafh7o4Ctmqouwu4hSyhaG6UebybVut64nyEKhFqAapOG4wxZF/toXay6RvOS3z8F7kgpeVHVB+fQv0gkDcE9/Nz3afnzymUApKo2ytQukLo1hJa73v03A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757027932; c=relaxed/simple;
	bh=khPKfwkL8jwgF03lcfW4AnZd4LSQzunHyzh8gOCnrFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gdzS9vQIbD6XpZKQsVHMQC4DWJKxG6ji/cOLg9PgLKsRpFRhDceXBou84Y5jDr1mjO/qlreUvJczF8mpkE3y64L9pxaKWK6enWawFvTwrufhP5lutTUdFwVsmJPrG4Z52OB9ESTXiacIjoVXgO8ndKUcXfSXp3LtLMJcyPPNg3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OZbge5R+; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-72267c05050so15548847b3.3
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757027928; x=1757632728; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pUUIF338HkUQ3bBfDAjTwfW1LnwUNwCLhnsG11SRTe8=;
        b=OZbge5R+TF2SmXPYSyW3vDMOafFbUGg2roq0sSehbTSkFBSsjrSALU8iA7W8fImQ9i
         5+48cbBe5JmWk+xH0xheSScjOkwWycdS+nXmlJRRz3FcLI7J0G91OGSgx2vS//RpR2+f
         MgEsIjXoPb5ngjnzIleu5JEDDVXeGSgo1wPIdAC+G3JATmBApIV6D/uAhO1Qp3S47DKl
         bLNbUe2YECzKPXJ2wI209hXZ6D8UbYvO7ISIIdnhlO2ROddU0VAfIt9QfFt/zt45Qmpu
         93RR+BOT2leTBZCVy/zcuPSDGRKkH3QzPUJlnEx1436/5vQC8NluIeOfLxo5x0tl8u2n
         rwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757027928; x=1757632728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUUIF338HkUQ3bBfDAjTwfW1LnwUNwCLhnsG11SRTe8=;
        b=oTiFCPGMYUm4ExBjp0ksZhBAXIc8v5LxxIgzb/eudlaopy8A+IJaOIplWChjxXH5nl
         4XghM+yvQP8+nIWjJe+bT8cFTQWjLWDi4K9SiK2tOvuCq4D6ilq2NvUSorvnjV3xICXD
         AddHd1yHWzAGda/yk3SNvmsK4XcWzdWHpPObfo1zylG+XeU0/Bb+G8+ux/gIwzISUI9v
         2fCQlehuGz3pBg3RYCAFhSgnPOq/qao27DidVWBVsKGjbzemHwLKhaBrypX7ynV9okAG
         54rvsw5tCj8QGQNx0Q7kZXgjbI0J2SZwDXKVBhWoHNNs032eh3bhNdFxqjtMuVcrWyOl
         qJxg==
X-Forwarded-Encrypted: i=1; AJvYcCVu7yLyl1kE7l5zcD6XVtqAQ+Fc622GKrTia/BuWaLA3Jdrp+6ZTUZ/GokHztdHqqECKPdEIoXoqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLTvGNPU5NsT8la9mGaorNZ5jy0wDhd5yhXmlM2V7yGsp89TZ9
	oNm4KesL0ONcTGhoFiCf1nvvM9fM9WpS9664cUjQW7IWdRgKEUQU8JOnU64poeqwhQE=
X-Gm-Gg: ASbGncveor1DW1S9bWnxpq25az2/4MbxeHZbSnnmox/bWDbOKnIPRT2skQdG6ipBtNf
	i4SsIBDYuhG7Rakmi08LA1tl9dpy3hjne3CoCz19gXcD9onOti/dXuVrAa+gHj+yRTUS1aMuLZs
	CjFxdiG2mkaZvNPTpqRww+IHN3vwXqsvsEOl8imzevzI+UGxv6+Z2IWMgeGC7dBoNegB2lwa0jE
	1IQq2meblZfCO393eJhsuIP6qnY8rkwihYLdVjeUMNYRGD/x/AeQJTp/TRlqdVFPNghhuSDKjrn
	TuoXDGYGUAG23RHRKMwxaXQIVZODR9ANqSG4sLhME7ibXQfv0RwIJBaWOTc1+yS+axvXQ+lkM2X
	so5+2niGNPpyPl6Laug==
X-Google-Smtp-Source: AGHT+IGulzpcyXdUj+05OBh9jel6OhdB+LzJj0TU3mQUGlvJdwN00n3yLtqIr7KfbHpfRWnFA6FbKQ==
X-Received: by 2002:a05:690c:34c1:b0:722:68b6:4f17 with SMTP id 00721157ae682-722763357ddmr205447137b3.6.1757027928508;
        Thu, 04 Sep 2025 16:18:48 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8501f54sm24998367b3.39.2025.09.04.16.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 16:18:47 -0700 (PDT)
Message-ID: <c40b5b7a-3a9b-4c52-bd74-02f3c3b56c87@kernel.dk>
Date: Thu, 4 Sep 2025 17:18:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_check_coalesce_buffer
To: syzbot <syzbot+3c84158e2daa468b2a3c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68b9d130.a00a0220.eb3d.0008.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68b9d130.a00a0220.eb3d.0008.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz dup: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register

-- 
Jens Axboe


