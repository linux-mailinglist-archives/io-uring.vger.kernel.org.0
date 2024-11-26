Return-Path: <io-uring+bounces-5049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F3E9D9333
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 09:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 846F5B2196B
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 08:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C751865E3;
	Tue, 26 Nov 2024 08:21:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890A513CF82
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732609265; cv=none; b=cHTergDSo8ek2IaNFm0BnFC27VVg5KuJTdf0G4kyzZx/WcuvaPDhvk0m/lnv9i6j8bqiiSlP6O6pqQoYzcyWZ3p7LccRr/ncpDzNxdPvwCARVO9oyZvdab1hJ4fipyqRyV8GMmqqjt6i7S9UzuKpZILDZloF4g5o7W+1FeQy9Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732609265; c=relaxed/simple;
	bh=h9nxMfZoyZaKDKdbndcWcPk8FhPa2LWsvLlV1sQAuzE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KQn41R6ld1ZOfAz8+PKE6VE3n1RA8inmrdxlNUb4/wOGc0ISD7c/O/CUHW7W/N0Bya0rN2icWbRE+k01RsRXDitH8tHX4Q/8SRO08QfAo84uqd2UpxTaYGXflaFDg7UfUZaoeuJxQb/tX/v/DITnWl4GaNbPnQJbwuhfWgonWRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-841843a9970so216643539f.3
        for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 00:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732609263; x=1733214063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5+ka/LQkUtx8jqUI9tIQHYyI9Y3XI1v2clXWRUx1l4=;
        b=JW7rwe/+TekpFT2OwP0PL9Sc93Jwpq4uR6AxEBx/L37E8QUwc5XMcCYO1t6ts2r0Kf
         UI8H+1Mdj1rH0NRzAqEsiG6wnUi9PkmhUZkLn0KUrVCQXvi53+vh4xbaeB0CTtqWWOMy
         P9EIesQDhqnKR6gvx+XbRduk5ZGxv3eYeeXZyalb2Et3ICW2p3DHsh1D2rxoUfVWYXFA
         RDCtqHD2TRCmPe8zK/tYD1szsyMG/oAhVoq9+r/Dq7AHdtoHaTONByU8B/g3UrEwbg/a
         Hn0qFtXT98jZE59I0bDV5BML3iBj6QcjI0OriuTDpZtqHH9n6XSLfKRp3TMRSTeKoj/E
         oW8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5FpYMq/ewAeMS9oaf7ghab8movnvd4bque+UT7Wsh6tUsp1s2SQt52q0lQV+/E5dapPhHBad2fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1mCIWgcJNSS1zYoKMLTQeIVMJxZDsdI7lixp/EJz6uc3ZSS1Z
	fJeWB2d5/Ap8wBI+vVebLXDpP+94Gk2lAMlGlkpBYEAjkNglutS7trWV3QVZniyQL6y18ZDtZsS
	hWapV6YwebPEYfR5cFIGb2sutqQ102vD8RwielDou/IB269XksE0RcfI=
X-Google-Smtp-Source: AGHT+IFwXL3nob77/IIe9In4L7I/CoaFe/f9qVhfnO9G/KT25rpwIjIeOzOQaytVB9bG1dp+fBiIOw82HsNZhZhKXDTsj0eolgY1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a62:b0:3a7:6f1c:a084 with SMTP id
 e9e14a558f8ab-3a79afec520mr192599725ab.23.1732609262857; Tue, 26 Nov 2024
 00:21:02 -0800 (PST)
Date: Tue, 26 Nov 2024 00:21:02 -0800
In-Reply-To: <1806e4a5-7e78-4264-87af-2468289e34af@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674584ee.050a0220.1286eb.0013.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in io_pin_pages
From: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Tested-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com

Tested on:

commit:         1b7520dd io_uring: check for overflows in io_pin_pages
git tree:       https://github.com/isilence/linux.git syz/sanitise-cqsq
console output: https://syzkaller.appspot.com/x/log.txt?x=17b85ff7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f0635751ca15fb7a
dashboard link: https://syzkaller.appspot.com/bug?extid=2159cbb522b02847c053
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

