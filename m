Return-Path: <io-uring+bounces-2577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A1893B852
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 23:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F8DAB2277A
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 21:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C6F13A894;
	Wed, 24 Jul 2024 21:03:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A313A25D
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721854985; cv=none; b=EM8NTefQgV3uyR/z/FLnncBi2rJD0yCagxjI6lOo8o4oq45XXD/iNjdvROlNSyaW93TvN1gUu38SCWV3Evdeyi/83UA5NQc34sv6fdiN7CIk90n39OcP4ljNeYx5CIIBpjvkGYnP8bn9gFbd3YySCDsvEq39y0xV6jQxVQ5ohq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721854985; c=relaxed/simple;
	bh=dxxEFPKUPQ/vbMzaN94MYYum6W5jb5eGh5SM4Odiu5M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ao14vm+oMqrokCGNJHzhrN/y0S/Ph46BJNDQ4juWgot/oq7r8wBHrOefI/41vWXtL3gQOQqe4eKXkInpMFP2qkpmh4Qw318iU36B3qtMLMyL7LMVaSTwsCky5HfEpzcnOMe+z0W/NC+c2CcRT+syZeo81PMilpJ6GgW0ZAyn2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-802d5953345so30641639f.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 14:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721854983; x=1722459783;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgzWfHxyU9SajBvvdTvJiZtUURmcx2um5Z9HsNcKvsw=;
        b=IVU6y377sG5eebQT+hJuN+ND+b2jBJGVPlwymjRnuHuWmUTF0QRe+pEzJ94kEUT9hw
         WgvSubWPnR56O9urCjPwAbV94J1PjjIcA1G5IhAPJrQyHVIn5kOdZxWhIW/IshVV2Ryd
         d3i8dFRFRCtuleUlWjM2iNObFqM8fpzRAkQlUH7AoFK7vuxkBYIA6mbze6/jhkcW01Fu
         Wct/s9YEC/JhXx2GwTw10wjtT+mGK2+GKQAdEgZTzgA/R+YZB4OioXqE9+An1rL7K4BE
         eH2aTSCTmiRgh/9bcjOINjx1RdKZP6FXC7BbPwfkd1fSmktJN5jfF4WI7WTxQfRPr0yS
         B6kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9IjtJIHLBV+9QzS/zjIqH6/mmoI2skoJN/qbqbvfzC9nat1ZVzBlJUr/eJWyNzvIdMWtjGsvzqzeFzBkU24eRy1rdKL3+ENY=
X-Gm-Message-State: AOJu0YwVu31rwFCD/N7VHyKKhIeyFG5hmPMXBBgCtK45t1T2Yozquv9X
	w/9p+TTvalS8drZuif/+02y85u6YA+OMh/2PfCBvUzkt5T9aBdJJsXiEoffnSVv+3Ctl1IZguja
	Sixky9I/TnSDAhNfJA53BgwU78dNSwqEjvlbL9ktnIBHy5wd9enMpCfA=
X-Google-Smtp-Source: AGHT+IG7ke0zyo3YDdsAQ/FJW9lT2WkYC2NwIM8te9K7a5gw62GWLOVL34BncEktMDG8ImfaCVs5qV595/3tyTwQjPE2nQhid+bW
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8328:b0:4c2:9924:c81e with SMTP id
 8926c6da1cb9f-4c29b6e5a6fmr27071173.0.1721854983463; Wed, 24 Jul 2024
 14:03:03 -0700 (PDT)
Date: Wed, 24 Jul 2024 14:03:03 -0700
In-Reply-To: <64844b2a-d4aa-4b1f-8954-049850e38c1e@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4fe65061e049a02@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_task_work_add_remote
From: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com
Tested-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com

Tested on:

commit:         c33ffdb7 Merge tag 'phy-for-6.11' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d29bb5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f26f43c6f7db5ad2
dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=120b7dad980000

Note: testing is done by a robot and is best-effort only.

