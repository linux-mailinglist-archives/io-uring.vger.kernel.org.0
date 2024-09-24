Return-Path: <io-uring+bounces-3287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5977C9844F2
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 13:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A09F1C22A3C
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BE21A7257;
	Tue, 24 Sep 2024 11:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y7bxKniK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386EF1A7252
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 11:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177881; cv=none; b=TjVL0CRcVaPQh43N4e0745v9dtI/VJLj4O8zolNOuFHU2WgO8mZTbio8vkdBMSdpltI94mjbX0slM12Q6mVUzm/sYu06XDrLTIukgkrISdWcornRwqR3v6Mtap9PONPEToBBdFxZkZ2R6Kx68pQ41a+UP5DvoN98P5HQRZQ2m8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177881; c=relaxed/simple;
	bh=p0BdZAZh1ZxjNZymKWKLfbu3HHT15r/YJntFkUJ/mJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T/lKiKzGizKYz8pWjCyliX95KofZoCZfr+2vdGh+GMLFlnULTUwJ7kZfl8CvxBTBIDgeS1YjtXmfw1wjdytmdraIvQXWu9tKf41WCLQjMAa7FMVrH8fy4Eh9jfuu0xKxv/nLKfbq43mJnSjftUwMb46nMU7/MfR+8FKVCCO4nsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y7bxKniK; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6d6a3ab427aso40075327b3.2
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 04:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727177879; x=1727782679; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zibiU5NcjA/42kDb+GdOf+oExsB2oKos9l/xA59FG+c=;
        b=y7bxKniKY86y9PZuE6yQEkskNbx8nfWZ2NE/oxrJgZqg+RL71Xeq+cnRA43X49s/cp
         cUbUPc2pN2V3UKg6FiDL3tDdBfLt9jB9r3tn/oFHr/5C4k5PcHIOsprtrRa/Tfyi04dc
         Z4AyQs7kv5lBC7zY5cq+/U4CxgYLsccwsApl60wzTOjfKSp4domyR5MgR7g8H0pXG/2q
         KoTcq/BgvARjjMy7tL7HG9C2eXtNlZFK7lwiDJmeC77jC3IdEvOx1/ZwAF/AUXaIeKlS
         lmo91TBPx3oy/MuoiFsZ4ztom1oewLyQv8AoKEgHivKrv17Bjjk22eMd9Newrm22oXk7
         ASOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727177879; x=1727782679;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zibiU5NcjA/42kDb+GdOf+oExsB2oKos9l/xA59FG+c=;
        b=AdDpz4HTA7V2+hh19crFCJRIfJ5nJLzGlE5dDRCkJu33sh+4uWrrO2g3qpS9zJIOyO
         HDLQuirs48y7vOw8e1EMHxJjcvLcbXImpfTZifbxOESXQ6qMNqZxDg0oOEpICn2GE4Qv
         xxQ5+bUiEbeWiWLss29KUTiQ6PV8Gu3on1gkG6DHebKZoMLaFyUKbjA6mzrpwQqMgYuG
         rPa8EEoL9P62jq6tWP68h4JfrP5OjylXSH06hBzgDDioadxU0rkbDeLW+CvI1RxSFbbZ
         HgrBysqH/QDTL2ryMqDObOoPK2XatLGaoQv5rcC3iG89BasNHK2itwDytg/db9d5STZf
         Wa3A==
X-Forwarded-Encrypted: i=1; AJvYcCVYzqJIys5G4vUFoQOAIw/z5Rin6J+yyKqg4CxhW/UpTYcZsAwCg2J3xFhYw3OfM42vVG7UYER/KQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKah8VrTwEGaEnJnnZk9WwhASUhI3Z5F/5GWW1FMIo4MYzKoiG
	GmUz0bD/J1cQcXpe19GYLLKZt5M3PPa3w41Gr8OnSlxN3uxbJaANA1pCoc5SwfBQyws5EtgjmW4
	6IS+LZA==
X-Google-Smtp-Source: AGHT+IFwnf64MjHXe48n9DmAsLZlpXhJrVcdnslHAZm20aRIy+bhv3thVqdhppairRNPU4E0vI3utg==
X-Received: by 2002:a05:690c:4243:b0:6dc:d556:aef7 with SMTP id 00721157ae682-6dff2b1b2b8mr84275797b3.41.1727177879192;
        Tue, 24 Sep 2024 04:37:59 -0700 (PDT)
Received: from ?IPV6:2600:381:1d13:f852:a731:c08e:e897:179a? ([2600:381:1d13:f852:a731:c08e:e897:179a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e20d27d2d2sm2104957b3.117.2024.09.24.04.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 04:37:58 -0700 (PDT)
Message-ID: <b0140219-56f8-427d-9ca1-d3eee127a5e4@kernel.dk>
Date: Tue, 24 Sep 2024 05:37:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_sq_offload_create
To: syzbot <syzbot+71b95eda637a2088bd6b@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66ed6edc.050a0220.2abe4d.0014.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <66ed6edc.050a0220.2abe4d.0014.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is a dupe of something that was already supported and fixed, it's
been sent to Linus 2 days ago:

#syz fix: io_uring/sqpoll: retain test for whether the CPU is valid

-- 
Jens Axboe

