Return-Path: <io-uring+bounces-12112-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLweLZxIimm+JAAAu9opvQ
	(envelope-from <io-uring+bounces-12112-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 21:50:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4F611495D
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 21:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 12240300D347
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 20:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDD033A6FB;
	Mon,  9 Feb 2026 20:50:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427DA333426
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670204; cv=none; b=TnBDUdf4b/w9sHiM8hD/fxJVpaDL3qhldPSJiwXrZUfrpW/Hrj1TSem2Q1YOW6m3M3oKNkiLqZmHY9922nSMzU74tYk4QgpjgU6rKeBNxf5FKWvU9i8VMwj4qXd+2O4e0cAFj3cPeuqwnoxMwuMfNKUPsoObWU+Ms15+8FFNW00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670204; c=relaxed/simple;
	bh=nYakJEkqnodvpY7ze+n1lf/N1ISCqnfJ3zQ6Q5A/J3Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cCyfhiMjTr9MeyuVg9YrbUboVZjU0CS6HadcOTjsYmYaep6hms8EzbIBUF0lvDdMHa5Xr9hMPcqrj+fi25ZJItXmX4HsTxaOIvE8xcNcYnjbcEXUcF+yCmMeCO6Di2GuUhM5FB52AaAbinXY5V3qWQCG0vz88mbfQ0NJc8ZOsjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7cfd12d8245so9104451a34.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 12:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770670202; x=1771275002;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v9ZXkYD37uRxTxUdPapHpEoQXRtO5EYvbOzRwBsHBhs=;
        b=mBImTquD5SdiMqb03t/xFB5I4ioiFPCKGduU8Ns9mgiHFShUp65QTcIu7PjYeEPAtL
         /blFK/ib8qd524K3UHA1rDmqbPjETtS66RZcqrpVx3ZMfHExcJFtK3D8eFzEb5PVYKwE
         +0vJuR06FOJqrdVqE+4tihMasbYqqSi8ojkOmv+2QVTjED8fCgxlo9RTR+XbzaRxrz+1
         8MojTqqc9HpbbMG1Wi8E0PpQdU/fVjqpiyggX5hJqcNr3WrlnlyhHmaOxqdeX7xUH5Uk
         zdXmNJeWIxEFXCexmu99qiQ+k+6WCqH0I45I/irPzW/SnrsxySqjkL5e6zrSg2b17h8O
         JS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8SPWvEkp0zf9qpBO5gyG9WofGFLk9rE1ImRgyfoCVHFjAmunG+XEG4uTRGGqHbJJm3UcCJqVJbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnFhm6T0MuUumRikxI+ey/n+7K5ABrfGFOXJbnWCk1jUsZByFq
	0BcLbYPudANcAALMfjxzw5ErQG06DCs5V+C9pKC/5JTqR/srApdtRC/0sPYddqrZupu1nVkYug9
	0OgnUU/VqoWCFkp5DNoGyT2ihVtcfUAR2OyyJYNhY0x6/tMatsJJQHkgu1ik=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4ded:b0:672:afe2:4b7e with SMTP id
 006d021491bc7-672aff19c38mr335833eaf.19.1770670202305; Mon, 09 Feb 2026
 12:50:02 -0800 (PST)
Date: Mon, 09 Feb 2026 12:50:02 -0800
In-Reply-To: <23112bc4-a498-4089-a225-1440c2151ce2@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698a487a.050a0220.3b3015.0080.GAE@google.com>
Subject: Re: [syzbot] [media] BUG: corrupted list in io_poll_remove_entries
From: syzbot <syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, mchehab@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,syzkaller.appspot.com:url,appspotmail.com:email];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12112-lists,io-uring=lfdr.de,ab12f0c08dd7ab8d057c];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 5B4F611495D
X-Rspamd-Action: no action

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
Tested-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com

Tested on:

commit:         05f7e89a Linux 6.19
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15956a52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17da94aa580000

Note: testing is done by a robot and is best-effort only.

