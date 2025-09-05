Return-Path: <io-uring+bounces-9587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A0FB45391
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DC49162C2D
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 09:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF0427AC3D;
	Fri,  5 Sep 2025 09:41:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBFE27C17F
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 09:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757065265; cv=none; b=baWMw28IbOCzO243IquWqPstzFPzBrnQDd+R7dDG6liD+KbsAPzAdirNCtMZ4f0n0wr/tCXvph3Es+Jr0o0A9Q5TuQJg5U64rQ+0KoiAx6cKAxHDbH6RgW2eGdQiDUzH69bO7GDd4V9QZbdSpnbyTX8O2CAb4oncZkMJTwwCqXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757065265; c=relaxed/simple;
	bh=zY3iPCrHKjavbVIMB6JWljwaLMmTnlvXQG8FRJBM1pw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iO7pCTtCbc8VruoHuygam3/kbyUN/VHJHgwlOYSzLooTL88V4zEqtfsyrBF8Ult5lco8w5C0S4tQcesFlOd7+VXKVRZp3wqBpwOAXVgwksT2wxEtxbhqXJIarvcHE17SSbN13b13pOyoLwbw5jLpgbMjdvklXsM1zYuszAhrvIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8877131dec5so14164339f.2
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 02:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757065263; x=1757670063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jcO9YHpqobesarBM3yKY5yBwnh+DabzfkdcwLv1S+YM=;
        b=e1MTaCKQAEQEVyjcSZOOTEbPPmdlj0+lFNLeCcRuUFuoKja1JPnpreA6qZ/SWuCwr0
         gnugW4nd6dz6VQirYI0mJNN3Oi1mhvxRb91Q0ljELlnBbFeVgCNmC53Khmhar9K5ZYDu
         QNMvQELr0C2zs9lgS3Y1cA5DaleluRKmWJ/roEAwLKae9XrL+vxuUb5HqLXC/GSH28kY
         +eHMhyVMJjzgK+40Qta4OfnFgAUcaMjQulach7phCzux2xJB9Ihb2y8bDIW89XdG+85p
         d6Qr6YQ3lSEd7vPzRai8MTMekodZ+4ck02iKsM59g+SIiUdhtMOWxzS9WV++Hb/GJizv
         T77w==
X-Forwarded-Encrypted: i=1; AJvYcCWlWSmfewhJZMR00WUPYDbaG9SwXvLGSz+mKHf9z27BOxAS6j/IIhpZboDlmHuxL0BqxgYz5HRJJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzutzQDtHapR+oJCoohdm+7ih1klS3RBbbqssiJHl8KpuXprWRW
	ZqmrCWxjQ6ieR8Dt4fASLHZnPMJyVaF+V2gW9K/NWXLgnwyOe8rdbrHzlu0csnFZHSqVqu1KN8R
	hnyMrOoskAhdBbSUrQK/LWZUwWC4dIIalVM9RSRwDFZxO9pk5zQA4L8qwrLg=
X-Google-Smtp-Source: AGHT+IHBN4mhIWYJqdlTPOYVgJ1hmlil3M4t2rTTnp8qFHKFxHD6XafcxWiVyjvT1/R8uTkZuE6jg+80noBzTXVCSqKMb8s1XeeT
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cce:b0:887:3ae9:c3d9 with SMTP id
 ca18e2360f4ac-8873ae9c618mr2474046039f.2.1757065263535; Fri, 05 Sep 2025
 02:41:03 -0700 (PDT)
Date: Fri, 05 Sep 2025 02:41:03 -0700
In-Reply-To: <cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bab02f.050a0220.192772.0189.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register
From: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file mm/gup.c
patch: **** unexpected end of file in patch



Tested on:

commit:         be5d4872 Add linux-next specific files for 20250905
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1127e962580000


