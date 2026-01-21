Return-Path: <io-uring+bounces-11869-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMYyAuRLcWkahAAAu9opvQ
	(envelope-from <io-uring+bounces-11869-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:57:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A42015E62E
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 87EFD84877C
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 21:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2FF43D511;
	Wed, 21 Jan 2026 21:43:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E77843DA33
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769031787; cv=none; b=LKODAx6nkg8O6IJbvp6UJpBoJ69RE49lAyo9ud/0h/qRKCpDKUY9AcwR+gKnwRagqfLAPvni4TFkaciyfF6HZnP7ZbqYJWq1e0KHUmGoxRwzSOkmgBUYycoDssqvSKEg+B98mbQTUmaiRsK4tWQyXMGrFr8jQrcLCIxp1yRvzhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769031787; c=relaxed/simple;
	bh=F5PxrIWbIHpf38O/f8WPJT4JxOW/zOtVbWCEdWppOAI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=lI/yLGfAkpeCAi5Q23eQTOy4N694oMaEnljuSv7I304vNhNsNfrRiTOWNZUYU9o0pDlGYLd8Kx5H1D1DQl3AIVAV7Xw/oKvEEXWr54gqpE7a7MmK/Yk3aUrSCSK/M1dKCp74lna8/SKYRg5HPPOXT3TNV+BSfCTK7lxjniMDRog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4044d3ff45eso891698fac.2
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 13:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769031784; x=1769636584;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OugRbdbUljgzBO/ODeM85s12fiPbU6nju7QnqiWhvS4=;
        b=s8hzn/0ibt3AvalbfV2UsWFPwKj2bwV/8ZLp5aqDw0mRotIP29dMx3knGcbq0s2U7W
         +tP1wQ6D5eQFQjyF6XWcg5mWTkqm4gUoJ79CjJ0YnE5TfMzw7adJ1e3Ipm5trldgaOBu
         eY0/3r4hFKqQcpSXsj+U0Ms8pO7D+cylkaiHWBTcIAcxj36FTIGCGQzNDKFLUzHy986T
         TxylsEhHr5/9m6dKUn2AwN9OjPek35/IQ47kn47pVcFQyg/QshGJq9bFZHdINSGRHmFj
         dgm0w42SPQr6MS2iaeK58mS9/ERftroNqj/OqlPrl6nAGNORjYC6FhVUekIftpQZ9uXT
         kXIg==
X-Forwarded-Encrypted: i=1; AJvYcCUlN1oQKFeB8Ru4O4KPkm8kg5xHZ+I4tgEWgmfD/ZPE+kGRq8aVOsGjltZ1NF/3oure4KCm1kYvhw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzWlbpXnKuBLamD5cD9mSgTXbG19Y+cahWV9M+Ly8xXnPpdLIv
	Rfpj6czxdz5RKXqsNmEo4mNckNUfHnAEJNzensTGlrkVGJQNmeqFtBHTLlhCuYhu42Fp3n+hn0Y
	645CobsfDcqUUw1DyFfSrYHm26qNzVKWXYaFCctgJJdsCthlu5et6GklkF+4=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4de4:b0:65f:1296:76a6 with SMTP id
 006d021491bc7-661188d6296mr7166679eaf.12.1769031784350; Wed, 21 Jan 2026
 13:43:04 -0800 (PST)
Date: Wed, 21 Jan 2026 13:43:04 -0800
In-Reply-To: <7c397414-ca45-4fca-acb6-15556974da6b@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69714868.a00a0220.3ad28e.9c53.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-11869-lists,io-uring=lfdr.de,4eb282331cab6d5b6588];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: A42015E62E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/syztest: failed to run ["git" "checkout" "FETCH_HEAD" "--force"]: exit status 128


Tested on:

commit:         [unknown 
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
compiler:       

Note: no patches were applied.

