Return-Path: <io-uring+bounces-12959-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KmpIAsj0WlQFwcAu9opvQ
	(envelope-from <io-uring+bounces-12959-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 16:41:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 308B339B650
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 16:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D618300EA8D
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2026 14:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F2C277029;
	Sat,  4 Apr 2026 14:41:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172E624DCF6
	for <io-uring@vger.kernel.org>; Sat,  4 Apr 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775313664; cv=none; b=CF3xUAYm2xB8hOS5NUr0XXPDLjTP9Dq3o18QTbSDzDjM0KDsTUBelCqh8qGR6yaJVK/BDiYb3z+NamdVEAxjXRTHMksjybVMPIsPc4BXVLfZQaB1sACZsmB1KGJtOm/HOHPy+0gAoZldRHOl8iZhi1HpSnTA2P4RaWAiLai68Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775313664; c=relaxed/simple;
	bh=bgcbMdOUdu5hHg7h4+rAhEVLmfxXa+LxiMbebV83lyM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AiXqaqPtZHdPn5IyLSlv+o+8KG9NclaNPZ1dZyB64Qnvy2zqLxrwCA4UOYYjJRFSXbpFAfysvgNdUmGkgOeeD99wechl1yUf0/LFSTECMESvu1m26+PYwzg7uvCWDwa4n54qqWiAl3H/vnKemDb19+fZ0ehFOlL7oltKt3S3/fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67de56b5bd4so6901864eaf.0
        for <io-uring@vger.kernel.org>; Sat, 04 Apr 2026 07:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775313662; x=1775918462;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxrciHkEdkaV7RgU9C22Sni6CICu/d90UIod8Cbe3mw=;
        b=gvGul8sLZqGnlnkAmrJeNo5rroCPI4HxJi+rbwtHkcQFu7ytCyv6VFGzaiRqt7Vehx
         hqeT28qDmOGokiefSj3L/QWA0akef8NBmyIs6aXOh6adrWVpdNRGHTHvAGv5AwovFL7a
         6eGy/7QOj4H3EMSF+qQm8sCr4TJMA8ENHxbiNK+uuy0HUBIu9fPy6Fhz3Hf2Opc2BomT
         RC/OQpjLL3jE2sYKcOt1cfJTJ3Gg//+Y9SM+rZU+/01KAX7OVnsenRsMbQEPBOXxlG+/
         cZR2JMzNS4ShdOuO5k/FRDyF6nPLn1VLdnG59WIOdXWYzpbv7PYS5o+vOQDmek1SMQFr
         Hl0g==
X-Gm-Message-State: AOJu0YzvEfNAbvkUiJWvpKfXN1vgzY66Fjr/Kr/kZTynzE/Ak1/1D40o
	oOGXlklNSGve6cA0TBbyudzg9NNAnY2fm1FDVo5oa+WnH5gM7aldRH1kIncaCu/G1xIicPLwc7S
	Ppjb8cIKgZ0vyJX0Kwu1r7BQBuXSuMjALvSxEyyyjRLAj18MydSAfeMHoAcg=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:339c:20b0:67e:160c:36a1 with SMTP id
 006d021491bc7-6821f487d86mr2365901eaf.31.1775313661990; Sat, 04 Apr 2026
 07:41:01 -0700 (PDT)
Date: Sat, 04 Apr 2026 07:41:01 -0700
In-Reply-To: <adEeFek83DrfiJOa@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d122fd.050a0220.2dbe29.001c.GAE@google.com>
Subject: Re: [syzbot] [kernel] WARNING in __secure_computing
From: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
To: io-uring@vger.kernel.org, kees@kernel.org, kusaram@devineni.in, 
	linux-kernel@vger.kernel.org, luto@amacapital.net, oleg@redhat.com, 
	syzkaller-bugs@googlegroups.com, wad@chromium.org
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
	TAGGED_FROM(0.00)[bounces-12959-lists,io-uring=lfdr.de,0a4c46806941297fecb9];
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
	NEURAL_HAM(-0.00)[-0.940];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,appspotmail.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 308B339B650
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com

Tested on:

commit:         7ca6d1cf Merge tag 'powerpc-7.0-4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106df3d6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f34697150c7a709
dashboard link: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12f9946a580000

Note: testing is done by a robot and is best-effort only.

