Return-Path: <io-uring+bounces-10878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91FA4C99431
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D84C23A4F16
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE3B27FD5A;
	Mon,  1 Dec 2025 21:52:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14B9285C8C
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625924; cv=none; b=lWIa+qOwUa2/aIsRkAo7hottqhvuORuPdDquet2W5TYCx7ujyRtEIrXW5SlD3Q91o5tyLH3ojDgHLGe50LtcqbVDjqRVWeyuSBHPW+txlTfl6+F0NTd25BlcTTl3ytu6Z+JwdzRg9R3MLxdBoHSwCR2lMhqgRwsPdMuFA+CZjG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625924; c=relaxed/simple;
	bh=3f4AyJHulRcbd5TpNsiBrGtHrn8QS5K1o1hOe/u7+9s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sQoNo68sl+fbF4OPlbAIrg1x5eAmOjPttzw7josEi8zowl+wv4O1OFk/lEwY53rLsgcvslDO7qBB4Jfo1ONyHOEnxCjyaLmsPS8jaVgn3I4/9JJLP2KUwJ1XKwiV3hZhG12KoOMhi7AeVK1NjL53mjPyQgaKE+qGLQOz767jxa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4501fcc3affso931922b6e.2
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764625922; x=1765230722;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcSKYgik2OqAnEpuDeBm062yv3CZ5RikZNcjDzv4+SA=;
        b=gs54b/xG8bu3Iqll7W7PZjgL98fILA0EJJP6+vLFgVML0mBO1IQRBuS86b1Wkapo4+
         CZmZba+OKU5mWpuczWRyXwAmLl5/ti+1xYu8OgM3udfEvM6x779n0OnQkrF0Mi3d3mrR
         r6CGhcH+Ph/0PQWyXrdZ4qg9bwonYcl8bmMyX4J45mKZp1/I+58WfIj+Do3y1xPhQqGy
         cDgXVW6C0lHUw1dYLHqP+/16mRm/UcsG/7rja465KzcKSpm+HqWgCp/iS4881mp1i0A1
         hYX/F5jhSj2Jy5wpHOGyw+mWAszJ0q9yAdcPtjbC3jg5lkuu2EcyX5XPs/LJi5Absio3
         0nFw==
X-Forwarded-Encrypted: i=1; AJvYcCUH9IL8aGdqFlS7ZNh+MWOMi+/olQ5zhdTCtfUPLt7U24JuAlKrHZPv4hOg3MGMrJTLqsGZH5e62Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyScc4UkWRl6gjyHOxlfxwv2bvAy/7OEi4Tss9sATr7tYpdat7c
	Zu4OMQYMImmLL7DgkXCResVQdby515jFFY1EIzuy9YDSHndoJsnfZxzlo6Suu7GlqZrQf7uY69J
	TRQW5bBjD7EtYEXCuZM7+LI8JpCsaSmaGTgZs+mHU7i3+eDVr30vvT6lu80Q=
X-Google-Smtp-Source: AGHT+IEt+XxxIAlgiBMMCxlQ4WjPbvNXP5dvEvslxwgs/LoL2am4w24IdRhgPfjs9CIoneHfS7eyGgRljRYri2jLejCMOQsXYEFR
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1a8:b0:450:d504:9295 with SMTP id
 5614622812f47-45115aa8159mr14453357b6e.44.1764625921976; Mon, 01 Dec 2025
 13:52:01 -0800 (PST)
Date: Mon, 01 Dec 2025 13:52:01 -0800
In-Reply-To: <f2fe83bd-79bd-40ea-a156-6a20ff24997f@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692e0e01.a70a0220.2ea503.00bd.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
From: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com

Tested on:

commit:         7d0a66e4 Linux 6.18
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11128512580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f30cc590c4f6da44
dashboard link: https://syzkaller.appspot.com/bug?extid=641eec6b7af1f62f2b99
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13d09112580000

Note: testing is done by a robot and is best-effort only.

