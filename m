Return-Path: <io-uring+bounces-13567-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIVaGt7YGmqE9QgAu9opvQ
	(envelope-from <io-uring+bounces-13567-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 14:32:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F1B60CD27
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 14:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C68B0301E124
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 12:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F2C39478D;
	Sat, 30 May 2026 12:32:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFCE42AA9
	for <io-uring@vger.kernel.org>; Sat, 30 May 2026 12:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780144347; cv=none; b=WTM0CoahsO+smPKXchayP+kU7tcXVAf1HatKttNagRLBnltb45MvimBuwOI5z1IlIGFwj9MNEgPiiftkfrwPgiFcGkMqRahGn68xImEVlFedb71eqSn+V19FLNvL+JVtpyjlDDc1FqLD+HZTqFdHMZM9t/MVk7E9+JgRz/Wztho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780144347; c=relaxed/simple;
	bh=UGB8WIQqhDxMU8hMv/36JO6vRRRpvfi7QXwU7SiqTAk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sSVlcOPrfVvuVrlTlMPDVx7CooJWLZEOMwiX7zhMFpazH26SO+SMC87FNRp3D4U2gKS18mHHjyHe5HDjtfqkpkWre8s3c9cZvb+GCYBVcZsXZfvz2MlF3yqHPe9jlD67AuZ9FcGwYLB467LpFSVEhqCW4ew4ZtEYgMMcRM03gf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e5fc2c387eso10257017a34.2
        for <io-uring@vger.kernel.org>; Sat, 30 May 2026 05:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780144345; x=1780749145;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uVxsvNR/2TJFUeVP7FZ7Sz+N3/ktCN6tH86lXf694gs=;
        b=RNw5aEfaVNdJbZySIkFR1E6ZS4K/Y1tIy4OhwLSus6XBFQ1row2oJ4GEHEIzQ3ScHx
         WwgJCHN116LyMwebTn/LtOOHsRbrdkxJh+2mtUV71IX+CYxyxb5+7eHXnM44XWfiMMRx
         GFaKfDM+wjcBTXAaRznDcWtYIXvNWwx/6lOGjtuFaglTLTSnwLvEJsBqQ79oKY+PATic
         PWRgC8nbdym2EZQ3XcDtz2glPVPPSZWiJJgJZKJvDCHdIfFJzWb9q0IARQvIWXkj09uY
         NvNC3J0ezJ1FxVwkSoxY022WUttXJ0jLwWCsrt8GCbVk3awZJfeHGCIo9RjtnZxu0Stn
         BB8g==
X-Gm-Message-State: AOJu0YwjkDGZlu2N/+iFJ4Epxv6FaKrSoioBk5I/u1+MtzwWJhgfKUoY
	bQFgFVEfQSZC/5aa3rP/7gk0InzvEcNrELLY/fi5lyTiJe9gBu7/LiNZDXUxOd8hs+A4vc1j0dU
	q7Z8431e8D5utk7kGBmbfjyuEDGvF8SNS0NgWVlohfd/l28zKpCxy966gkPk=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e848:0:b0:69d:f0c2:73f6 with SMTP id
 006d021491bc7-69e104767e6mr1570779eaf.16.1780144345529; Sat, 30 May 2026
 05:32:25 -0700 (PDT)
Date: Sat, 30 May 2026 05:32:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1ad8d9.fd5edf16.2e7427.0005.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (May 2026)
From: syzbot <syzbot+listd8d9c619f07870f053cf@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-13567-lists,io-uring=lfdr.de,listd8d9c619f07870f053cf];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,googlegroups.com:email,goo.gl:url]
X-Rspamd-Queue-Id: 09F1B60CD27
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 2 new issues were detected and 0 were fixed.
In total, 3 issues are still open and 137 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 6770    No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 2       Yes   INFO: task hung in io_sq_thread_park (4)
                  https://syzkaller.appspot.com/bug?extid=4be91bcb08eab9a156da
<3> 2       No    WARNING in io_wq_put_and_exit (2)
                  https://syzkaller.appspot.com/bug?extid=b0d54b9e81de55179e47

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

