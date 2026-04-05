Return-Path: <io-uring+bounces-12963-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLW7NNZ/0mnJYQcAu9opvQ
	(envelope-from <io-uring+bounces-12963-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 17:29:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F2739EDB0
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 17:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B626D300CC18
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2026 15:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B6A30B53C;
	Sun,  5 Apr 2026 15:29:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609523E356
	for <io-uring@vger.kernel.org>; Sun,  5 Apr 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775402944; cv=none; b=XdOfx043Nbe/9UTKQOgmRaqNn3X5rPSMZn6XAnExmraOkNOoklQZSTXwG270ikuRh5opfGWtsJC9dpBtlYhTifCm8z+uhdKwTLfgq7u5Rwg50+lNidBz+0i/iASl0UMviPrCMJGvXfpkxoZQBrLGrCbJ837RH00W4KXCw4Gnbw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775402944; c=relaxed/simple;
	bh=4aDIZUqxHItXAtGi1Aa/XG7rjZF6G8S+tJ7Igh9TbWw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Vyiim+Js8bVBhS8+e72lD6nUZBLVwJ1hXgPhQIef5jYd5AfERSqARBRrsyqR+WXnxwrdo61Kpz6gA29JHQvW6Ktw5/L3O2C3W4mq4ZRJkQ4f9dDCSq3vSu5GAQmYkTcGj3eiSrO5fZmKoeqqfQcB1yN7O/V22Kry8GiXv8Dc4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6853c243911so953241eaf.0
        for <io-uring@vger.kernel.org>; Sun, 05 Apr 2026 08:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775402942; x=1776007742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8PHno0iOgkaqtt6EqJZlq1pZK3qQiYd1wPQGdgQgIo=;
        b=nMcATAgLgbQUdbDLkr2d8Rj9mji8+hViEvBIs5c9iiuszBKzScrWHl1e6xMFHR29Gc
         pB8mDx6yM4WGfZYJRZ1Hph/AXy444VHm74vC+kuanDqYakIZWjd69P2DyMMXVAJQG4TJ
         GO1tGF5tDN+40c9h4TFq0fzCyp3cArRd22RSQUXnNuEyeI1lwsdCdXgHRAL+HNr+vzuY
         Q5TK8iNazUOMMz56Bq2J4jEXmub03WfGArkQTkxeT17TvM3DPfsNV0CHKsfdpUUbw6Jd
         enbVAomsg8YlmsTW1GZfycKKAwOT1JtrKQd0vmwEt4UhbLRRa8t0++NtVJF5JPqC1HWY
         Jf9w==
X-Gm-Message-State: AOJu0YwIrLlUFoj5jswxtWEBJ/NsbdtVuyR+k0xMdpt2yiOzEyvBRESJ
	lNw5RsMOihwHTm48Lfk5N06P/Z8Hi07nUdGNIevm9c+T4J1Ceg2k7j+VpXcZ4pWu5veshDKmNA0
	P7iMyeLvNzYdFRPOm3wOzdMQrCY9BFUuAWc8BYtMRbEbuO8TO/2XS7vGtN/g=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1903:b0:67e:3480:bf1b with SMTP id
 006d021491bc7-6821fb6048dmr4527342eaf.38.1775402941976; Sun, 05 Apr 2026
 08:29:01 -0700 (PDT)
Date: Sun, 05 Apr 2026 08:29:01 -0700
In-Reply-To: <adJ7TbpTohmN-Ufa@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d27fbd.050a0220.2dbe29.0029.GAE@google.com>
Subject: Re: [syzbot] [kernel] WARNING in __secure_computing
From: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org, 
	luto@amacapital.net, oleg@redhat.com, syzkaller-bugs@googlegroups.com, 
	wad@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=4f34697150c7a709];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12963-lists,io-uring=lfdr.de,0a4c46806941297fecb9];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.953];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,syzkaller.appspot.com:url,appspotmail.com:email]
X-Rspamd-Queue-Id: 05F2739EDB0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com

Tested on:

commit:         3aae9383 Merge tag 'input-for-v7.0-rc6' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11dc21ca580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f34697150c7a709
dashboard link: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=141275da580000

Note: testing is done by a robot and is best-effort only.

