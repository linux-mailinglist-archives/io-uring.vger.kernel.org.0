Return-Path: <io-uring+bounces-8388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D082ADCCCC
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 15:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AD6B189E553
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 13:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE15226D18;
	Tue, 17 Jun 2025 13:06:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA352E7171
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165576; cv=none; b=g9HhfcL2sbpACoS06VBpTMPSWKudB9/oED96AHjblSXKl25QIwqStbiQzumvmuPdCG4q0jQgnwTZVp+WVpYRkU5YY2FJJ1p5p3Sy80ZWRpNU+PCGEk1TQkffTslcFeYqKv1f6jYgQsyveGAh94Ppist1VIonukgYhs9A3UMK4+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165576; c=relaxed/simple;
	bh=W51mU7qZLodURk2i5xa8G6m3EieBsoHBQDnhnGOYS4I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bWePPr/QIWexKvpBpBtWByiFfDTrAX7RCoQIkOOUoQUOiPCAYQS0RjM7CnbHCL0+eYj0aCSpTIxT36dI9jvWSr3gLcG0c33c9d11+cE2cRkwnGyC4t9kUdi0lXZKtUjn0H1jYcAaNoQ219eEz69/Za5UvJHJ6acQRtOSYYIrbBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddb4dcebfaso137735215ab.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 06:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750165574; x=1750770374;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Vs/ukJhTRWhCFXvyAhwm/6YRQW9BrrKpMErIgv7ibU=;
        b=a9ZFiAgWXQYf7SvqQaeH0+qeEhSbriGKKB/YqxKcnhNZfYK0mJoDlaxgpEUrtNEBBQ
         kEdwwCZr06SIGDtd62y+KRgYRZ0yLOf5uKPkSWht554LAcobXfkfv6XYGlEIMJXrs2sc
         xjKPLyvUJbw98KSnKuuPPCVp9sKjIQ7htqKmaPwIbxffmRDZLzLWt2BDMa+r+rXo8+Hv
         WYS/21CNvRmqnW9dvzDDuUcQ5dlJUtZlfLp/B0ufGcIj0DYIARZBQnNF+zUOTcfiwber
         Cov7FDuKJHOaVjrizGPFzwzdvH4TUJ6H1iWoCzs8GhR7zwxjGbm+dUY7zhTGOh22a74r
         j0XA==
X-Forwarded-Encrypted: i=1; AJvYcCUkSezE6q6fnmrzHMZrWebTEgUPHzmWGOO/XW0gGWo8Fk8dAaI2asa5e5L7oUVFk1D4KGhrLKOvDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsNRWLOuu1I/2YZ4zKxAYPbzaSFqmLhDBNCHWeWZWUQSwFACWB
	Cwz2DvsSrsv5+YxopIkG+5QuxwXOIJuDXvM9pK/gnLVLvSmr+aN03I9X2Aq1W5fPB0M8vn5CjaZ
	6SALaXScCJ8x5tFYxVL1htsODKoEDqFZDbwDE+RAVfpoJSNpM9uDatcIJKa8=
X-Google-Smtp-Source: AGHT+IFj7r4b3ezOHm5uSZPtYPrSf3hNmwPZVWzh99U5SDKlROXmXAFNqNFTxggq1yGcXHwUS/AJNvAJP3tl8V8ge9S6Ue8lj8lo
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174e:b0:3dd:920f:d28e with SMTP id
 e9e14a558f8ab-3de07cb6664mr136490605ab.13.1750165561815; Tue, 17 Jun 2025
 06:06:01 -0700 (PDT)
Date: Tue, 17 Jun 2025 06:06:01 -0700
In-Reply-To: <c655293b-b2da-497b-98a6-05399fd120f8@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68516839.a70a0220.395abc.021b.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING: ODEBUG bug in io_sq_offload_create
From: syzbot <syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	superman.xpt@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com
Tested-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com

Tested on:

commit:         100934ee Merge branch 'io_uring-6.16' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1284c370580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4130f4d8a06c3e71
dashboard link: https://syzkaller.appspot.com/bug?extid=763e12bbf004fb1062e4
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

