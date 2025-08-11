Return-Path: <io-uring+bounces-8936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE87B2156B
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 21:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B44622EB0
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 19:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7347B2D63EF;
	Mon, 11 Aug 2025 19:36:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947622DF86
	for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754940983; cv=none; b=HQALmZCCkMzmOrH9eC97cWT6gDWyoe2bvVLrD0Ra8yBHv4So6i48sFlQ4kplgNntGCKJXDhoKlyxaDHC6Gq75xRpBba2B80sQj7F9s9ZYtMZX8JCA/alEmD8bukUxnyxYcodqHmioBEJuoMNxW4+tZefMe1U5w+t4JrFkV+ndEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754940983; c=relaxed/simple;
	bh=1TLvhGrEqksH/UsYpqq4yDhYrl1D1YIi1hWb/jIBItA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=mwjP6IJwiWWHjZf4v27T7c0/ZxKLFj+aP2L6/vrTxt9bLmf962UdSokx9ZKgHE04IAjFvGvXrxM3tA5Pus2KRfOqzTO7e+5IfdhYt5mlUUtnpTwBKlKl4lssI7JLacna+zsDIiAVJ0Ylsp8ksPcAUtAjB66zQ9X4Nxj4WktdlKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8649be94fa1so1262650939f.0
        for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 12:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754940981; x=1755545781;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gwj8H++rTYzvGmBnPIFeuu7bmVUxwOSowdnBwzyw9w4=;
        b=EnGizNrgezUZInl5hI7yVP7faahWVlunfkzdK8VUG3XnDM73MZhqJUaeCJfzNc8+Ay
         83RIb/1MFyNaVHihmK7b93Pj5XqgzhzElmJT/ULWk9QdqkTD6EWtnK8ExKuA3KI2yMux
         ZGel2X1rERArfmMwVBlf8LSjEIdL0BcpmEtWZwmG6c2yCPHh6Tf9QS5JGyGDhO70jZ04
         pTDFaXAa87Zk3ipBbuLlEa1a4JbNnTRB8EfOSw9LzvHDj6jGdJGFS2Ec6dqT2ixH/16p
         uoDIOzOP1n+xoteE65cIAODYb6/DpdztRMdylqeRuOAboMlWlOn52uxtmNLLW2HrGu4q
         z3Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWMfGvYUvTWIbc59P0/eTRkbzqYv8yn0Usb3u7/O59NL+wAYidGYAYFylWYVUBG03dbebDXtTNahQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwU1KnKG90rjZw3fkeq5vau3lxwGhSS2iBSI0BvVuOrbqHq3IV
	GRN/kXpPAsmdFnEQBRbbq0Oi3+E9cHWEn0wnqp6y9oBknB88zGE7j+NZdAjHeNkXfSgEkfEg6n+
	tiz5b2jcxhGFx0UqdEu/QX9OgSVMJ3p6jnIVWKaXc5cryKn5nc0l6uFfML7o=
X-Google-Smtp-Source: AGHT+IF2rNoHzYu1qOPjSM4Zo17v2AtJ2LE8d2Y7jKsSO5Ahs9hXZcL0HWIjS1oOtG9ys/aoivl8Zd0UAR1r4M/S6QazhswzMm6u
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29cf:b0:881:6d77:6d81 with SMTP id
 ca18e2360f4ac-8841be902fbmr169955139f.8.1754940981224; Mon, 11 Aug 2025
 12:36:21 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:36:21 -0700
In-Reply-To: <8cdcb529-54a9-427f-afd6-108207bbbe0e@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689a4635.050a0220.7f033.0101.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in vmap_small_pages_range_noflush
From: syzbot <syzbot+7f04e5b3fea8b6c33d39@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz dup "[syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush"

can't find the dup bug

>
> This is the same issue reported last week, a fix already went into the
> current upstream tree (and is in 6.17-rc1).
>
> -- 
> Jens Axboe
>

