Return-Path: <io-uring+bounces-5647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6173C9FF946
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 13:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D0AC3A120D
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 12:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A447192B62;
	Thu,  2 Jan 2025 12:15:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAE71AA791
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735820105; cv=none; b=tGSpQwifqML6TS2vG4t3FUIhBbGgbSLtH0vYcuoO6MDK/f62N0XhtzX6B2RaCChnj1PQfvTN06HeG4WXjWsUKAdS14pddTvvTSj374Gb7Vht8wCxM8acBvK/B1TfmPqNdijGEZJ/H1mAGEwDt6Fth3M9dxEZRq0wBtk+R+ez5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735820105; c=relaxed/simple;
	bh=C54pwfuEx7CSMPHpbYxBPrjO+xocElt5qFrT0JyWZdM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MCwqRmZ12GT7dPluLqXhD/MRkn2GEP+HIGAm1FiRuULXxv32wCEa+1D5c6/DJt3pzSYLHCvAXeFZ8MrkP6y5kdpyzE5dpBfeeTHO6+HwyfIbMSlALsJZxFcpiKdXHuG/CnKHG/lgZQRANl1Czm4/7ABtZV8WOz3NuSkDQ9IjSBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a812f562bbso241522215ab.1
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 04:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735820103; x=1736424903;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5BADL3FQIi6j8hDt22luWH9Cz2dG2Si6xImp0h98Uo=;
        b=N3Th9ohTr+M0fS6N1PegI+BjTJcwRkImuWVmbLXFlx/q4RtnlW4Mz/p/I0vh5Ro9c9
         uhyzFNWXqlcj1qRRB3eRvZTxasG48HV9cU5EaGhylh8h1h78L/BIsVSDPXjFlMELyWIJ
         k/32J3UhIrmceKfEl0aP9dHh4Ot6HZ2JwPYSIp/lk8kQXJK9VcvkcVdM/m8Nikuq/Y63
         Ny8TB75zYmOomfJ1jpmkWnxxfbSNrNGc0HH5KpBp6aHD4z9EOnO6ltuEZSPYGd2nz8zw
         J2oNIgOelkqoIXjQDD+hAD4kL/xfdCr74QGRHETrnQM5VJD41z0oAZOWroedsDpgcer2
         rAHw==
X-Forwarded-Encrypted: i=1; AJvYcCXYZZ6hveREm1levA5pgSb1rcSQ4pIktbBODkuHN0awVQYkNjE/J5nj966vKKEBovecXyPE1N8SkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp8Kw6hqQRzHTT/tZpbQ44sa7vtE8TMqHaXxlYFNOjt0LXsJ/z
	pPDRR+O7HtJuyctjozuZuxxmPoPD8rcwWnZomoOSXbEpNBtqbQdCsVFr8/RJItMIIBQ23ld3So8
	c9S8fZd7541NSYjAoGQCFHcxrh01v021CalZRPuPYrQi+DAQl7vtHC0U=
X-Google-Smtp-Source: AGHT+IEwWMEMVl1DAt3Rpw7MNelzWofqL7AXxOU2IUua+0OLmcJWpYccYw8WduDUeKpM4YUw+Zdd8VE5w0y929gRrqstq1C9qOgQ
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c8:b0:3a7:d84c:f2b0 with SMTP id
 e9e14a558f8ab-3c2d277f25cmr459566485ab.8.1735820102866; Thu, 02 Jan 2025
 04:15:02 -0800 (PST)
Date: Thu, 02 Jan 2025 04:15:02 -0800
In-Reply-To: <0000000000006d4e02061b6cbf22@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67768346.050a0220.3a8527.0039.GAE@google.com>
Subject: Re: [syzbot] [kernel] WARNING: locking bug in sched_core_balance
From: syzbot <syzbot+14641d8d78cc029add8a@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de, 
	daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, hpa@zytor.com, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, mairacanal@riseup.net, 
	mcanal@igalia.com, mingo@redhat.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot has bisected this issue to:

commit 7908632f2927b65f7486ae6b67c24071666ba43f
Author: Ma=C3=ADra Canal <mcanal@igalia.com>
Date:   Thu Sep 14 10:19:02 2023 +0000

    Revert "drm/vkms: Fix race-condition between the hrtimer and the atomic=
 commit"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D111018b05800=
00
start commit:   ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g.=
.
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D131018b05800=
00
console output: https://syzkaller.appspot.com/x/log.txt?x=3D151018b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1c541fa8af5c9cc=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3D14641d8d78cc029ad=
d8a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D127f381858000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D172306c4580000

Reported-by: syzbot+14641d8d78cc029add8a@syzkaller.appspotmail.com
Fixes: 7908632f2927 ("Revert "drm/vkms: Fix race-condition between the hrti=
mer and the atomic commit"")

For information about bisection process see: https://goo.gl/tpsmEJ#bisectio=
n

