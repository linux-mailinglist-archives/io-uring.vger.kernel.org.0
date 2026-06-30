Return-Path: <io-uring+bounces-13862-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id kx9cOuQnRGoIpwoAu9opvQ
	(envelope-from <io-uring+bounces-13862-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 22:32:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53ACB6E7D90
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 22:32:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13862-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13862-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C9E263036FA5
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 20:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C82147A0C2;
	Tue, 30 Jun 2026 20:32:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E342F47B405
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 20:32:19 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782851543; cv=none; b=G8w6pAVmiVFaXAJhbTicoRuhYH8844NzgoZtlkkhos4Nyv1sfcW0GvKg9IIgVrQO3prakC1Wg4O3Uc8xjkl5dtaSQisZHA+u5TEqyioFsBk6XPiFFxvseL0gnNRJIfMAmzWgHNsWkHzgA83Yps/vWgUL7dc+joINyJrCkLZF+JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782851543; c=relaxed/simple;
	bh=Por6JUDatWoljlLCZXhbY9Vuk/1EULi4lBmb2iaG//k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mqwJBRaroSOrma5QrkL5e2LnBzXlBYp+zdEiONXrQXKmhcgZatO50u5zUu+Dee8Xn77sX0z/hcMMH1+1XdQGJeFBhDGazNoFuo9Ox27q8ifbG9/184gOhcM25fIxZ0vZmoQyLlIHAZ0XbfY6mcG9bybJz465Okdtc516bvIENZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-486cc29e03bso5778633b6e.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 13:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782851539; x=1783456339;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R9yWDw5UuiZjz9O2wAidBA1VxJP9sItAMgR3gZ5kgUQ=;
        b=nURXQNjrez/3rXUPZSO2g8fevGNPp5mAgXSCPvp88YJv7xXKVO0gMVeDylZ8maTDoC
         g5ode4Td5q0aF7RWJYOAnu9gb5jSpX8D16kkSXvBluDSHnHOnRWcpPKQqHdF67s4J15C
         aJuPqqyguxLJAi7BubdpZeQDzOK6UVJ1LO3gmnD1HtAHKs+bxjH/sT9X/ZVCWxpjQwCS
         xt1UqcK+hKu0hOvGdV+8SLDrTtool/juwGfoo88d+ckNZQ2aArrYf+7LR//5JGfZuR4l
         HIzbuVsX6bFxol1PBeNxZYOSgXS5CzTQx5C9pVRbM+RVnPq+OpWgkTXAmw/SdFUHsQsf
         WGXg==
X-Gm-Message-State: AOJu0YwcJrlxBFKSZraVjlmoZUgaTi0IRiHGUBPLIKq743agwbKVOH4n
	XeHmBrwqy8LZ4QCbP3azBheYQPc7t3LUaQcgq1c9ts9ocXeWN6MUl9leA+3k8DTa3vlI02p69rJ
	+vFn17MpnB8zJKd5vXaax5cQTlTTacCSz4lP+9u5odwC8/x55CXvFX3eLeUY=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:191c:b0:490:5ba4:18a3 with SMTP id
 5614622812f47-495fd63e495mr1264613b6e.30.1782851539069; Tue, 30 Jun 2026
 13:32:19 -0700 (PDT)
Date: Tue, 30 Jun 2026 13:32:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4427d3.b42ede87.8e801.000a.GAE@google.com>
Subject: [syzbot] Monthly io-uring report (Jun 2026)
From: syzbot <syzbot+list3549891640e0eb618a36@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13862-lists,io-uring=lfdr.de,list3549891640e0eb618a36];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:syzkaller-bugs@googlegroups.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goo.gl:url,googlegroups.com:email,vger.kernel.org:from_smtp,syzkaller.appspot.com:url,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,syzkaller.appspotmail.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 53ACB6E7D90

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 0 new issues were detected and 2 were fixed.
In total, 3 issues are still open and 139 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 7630    No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<2> 12      No    WARNING in io_wq_put_and_exit (2)
                  https://syzkaller.appspot.com/bug?extid=b0d54b9e81de55179e47
<3> 2       Yes   INFO: task hung in io_sq_thread_park (4)
                  https://syzkaller.appspot.com/bug?extid=4be91bcb08eab9a156da

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

