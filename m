Return-Path: <io-uring+bounces-5624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE16F9FDC3F
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 21:58:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4069B3A161B
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD5D1990BB;
	Sat, 28 Dec 2024 20:57:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69825197A87
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 20:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735419474; cv=none; b=X70RmqkiLR4ciL5bpmakBf+4f925PgRLRZjqHWdbJIlxMixhktPNx0UQeHMAECn72jFgvOylec8Z+5Aryptq+2QOv9I0VSQUf3hhKCciOj2950VdFT6qCHOE/JI2+dAeCJGhbWedRw31bvwPnvpwI6hZ4s7Yct0kH7ITs7E9dbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735419474; c=relaxed/simple;
	bh=zJdD/Hlgm0Mo0Jn/353hQ1sZGVhsqxgZKb0UmG/2gxM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QGIW0CqbTJi6LmhJBvXhaMM9lTNB5t79jl/Dc2NJBN96U0Cc8tOQnZexWeQm9EF0SIKUsaLfnU0zLGr1WTVj3+Do/qCtXEe7lnVOhD02v+atBSXqomDDGK9FFTfn53KZE/bZnAM/RTriZluLJv6w9tXuvu3kwMGs9pgdv9ml6Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7e0d5899bso183374915ab.0
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 12:57:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735419472; x=1736024272;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/dbaQWcTz64med4ZDxAOY2XdL0mP5cmgRkLcZzXkQA=;
        b=XlrXsAgoXr9NT2UoUn8V6wDweJyt/4yJqG+0oqYyZ1FUvQoeF6yP11Z/yH75GOM+wx
         JzHwUC+PVLLNGndzPQIQrWnpFKWicJhjdAbRJO0qHCnTkWF9D3Mw8823wRYMkhZha6Xt
         qh/mZX4X5u+DDNwG5IQNY25NB0k8WdFVxrqsHbBjxkS0ZTVmy43xtOBdAZ+vQxDxHkPb
         fvZoThXUIBnxPsfAOkDaZJ7fXYkQ4GdhmUJ8AyUH5r5GRd97+0BdDHEmpI/Zsoa9yNfJ
         zRKvxyJqfLjgm/4TP2Ii8fjm7roYztRjXjNZXYaO2kNpZF3egPMyuq21aAHI6O6yK45V
         IjQw==
X-Forwarded-Encrypted: i=1; AJvYcCUQP1V+oSofxSYNRS25U6wInoeKFZiMIZFQ+bWJxh9x5/ikqmFKE3wgTW4XseJOTOFQATKAj3YxjA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkax6l+MP4X6QzLbD02kP6wC9TVvhiWM9ccHfbirQeAfp5XhNU
	A1yXwIOeEAyC+AV0WT5Epzn3AYkOv2gAiA/3Eg0g7A+IPoffsmgDGvcw0eM9TpKYTG8sd/YKhGD
	U/tNmBh9qMGASrbyZSKFVpwn2n72X4CYNMyBckJc6OMNFYpJINppDypM=
X-Google-Smtp-Source: AGHT+IHEwI8M2TnSsOC7e/5GzWkjMmwdkSKcGRp2HVkzZfIo+Tp8Ma7zB7VA+O0YYEsyT/XZZ+IKwPfuU4sySCU4nJtqcPd7yL4q
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e9:b0:3a3:4175:79da with SMTP id
 e9e14a558f8ab-3c2d2d5164bmr257871345ab.13.1735419472675; Sat, 28 Dec 2024
 12:57:52 -0800 (PST)
Date: Sat, 28 Dec 2024 12:57:52 -0800
In-Reply-To: <0ffbbde1-b5d8-4a53-91e3-80e16da18e28@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67706650.050a0220.226966.00b3.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
From: syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> Should be fixed in upstream for quite a while:
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe

