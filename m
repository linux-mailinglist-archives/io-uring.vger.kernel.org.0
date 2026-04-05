Return-Path: <io-uring+bounces-12961-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDtZDkl00mkVYAcAu9opvQ
	(envelope-from <io-uring+bounces-12961-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 16:40:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5FA39EBA9
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 16:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8095D30068E1
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2026 14:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388AD175A6D;
	Sun,  5 Apr 2026 14:40:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA710785
	for <io-uring@vger.kernel.org>; Sun,  5 Apr 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775400004; cv=none; b=pSnXCyHvSHmIvDyrKgoYaYN4K8LYs7AoVZ3UtHRPNW0eAkbCiK23jBYochKiT5PeREqyWk7owxqJjUxqSWZwUif/AaL4AK29CBG0CWVGEDdXHwfKtq7mCTddhNncKhQXcTIjC20ogJtDzW3E0HbJB3VAYzZmvvY/s6Rt2hOfOXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775400004; c=relaxed/simple;
	bh=Dp+U/BX70RO1GnMoAGUOMFN7iZm3SwHBwA+CNjvgUgg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hOUpghser6MitlRTNQGt4eUJ9DCojzpT5cNzwDVKuAxCtb15QUfff2QqFZl5dP9saR8YtWICxexswLPL3aoYeuymX09YSz5jVyDlYPRnKSmYm0k+xwUE2LiIUbijOubkBtIA2a5G2OUPq0XtXPsPuDn9dHdh/tQVYO1YcbvhBcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d7fd0be5e3so10952516a34.0
        for <io-uring@vger.kernel.org>; Sun, 05 Apr 2026 07:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775400002; x=1776004802;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lIXsp01juiLmL40bgsl0v/xfwwEC9/+U07XDNxruko=;
        b=GbXrXKuu1C3Pi9rdNSR3KNcv1dE9k7tzrHJ4qiOVm5vYQsljVZ7s1TQ6RE9as0Ov3r
         VG8WQp3r6rWMdKgaj84cF+SIO+4C5QvRkr3XVrDTpNOBH9oJV6FlR+wbtvhX54pKhsaS
         LiYP11PvwCiH7qO8gUWW5eUFm0uyMRzV4WjxSLKL8oUfhU/MuAaTUxx+LWp8gK3qaFBa
         g97VRJWR/VAm83Kf8Se4TTdERQLuOw80ixjkL5jynlaa8l4qcfLtKOVL88W3E0NfgiPT
         eUj0nSXlWLNWNXhhRw4Ga3OJgmWs9tx+kE/qakrQRmZ0AzTY/d8x0M3SLKc3Et4yAnkM
         lFbQ==
X-Gm-Message-State: AOJu0YyD7iMVMjzmJbMJjyPmSQBVjAOjWN2e+BCqlmCGN81QyYdavZtP
	fXGt8UEa/bDNtogHn+9Gln65/Wgq5OuyaJ3ia3EnM/onc/IaSnEmC2+WFXu4K6Dob3B7z+G/ZMj
	9y7bH3yTFBSFYpfNFHXT26d1KQwC0hyq1UQvC/KQaNwy3Gf7i3HK2ufQzH34=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3095:b0:67e:3d3e:db54 with SMTP id
 006d021491bc7-680f43ec3f6mr6434415eaf.0.1775400001808; Sun, 05 Apr 2026
 07:40:01 -0700 (PDT)
Date: Sun, 05 Apr 2026 07:40:01 -0700
In-Reply-To: <adJvw9gEC9D1Gxtq@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d27441.050a0220.2dbe29.0028.GAE@google.com>
Subject: Re: [syzbot] [kernel] WARNING in __secure_computing
From: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org, 
	luto@amacapital.net, oleg@redhat.com, syzkaller-bugs@googlegroups.com, 
	wad@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [3.94 / 15.00];
	RECEIVED_BLOCKLISTDE(3.00)[209.85.210.70:received];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=4f34697150c7a709];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12961-lists,io-uring=lfdr.de,0a4c46806941297fecb9];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.926];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	R_SPF_ALLOW(0.00)[+ip4:172.105.105.114:c];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8F5FA39EBA9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
lost connection to test machine



Tested on:

commit:         3aae9383 Merge tag 'input-for-v7.0-rc6' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a6cdda580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f34697150c7a709
dashboard link: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1246cdda580000


