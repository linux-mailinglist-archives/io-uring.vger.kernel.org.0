Return-Path: <io-uring+bounces-8195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4F1ACC840
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 732F53A4D39
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 13:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB99238C04;
	Tue,  3 Jun 2025 13:48:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0790E238177
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958495; cv=none; b=pChXrY6+G0B2V6CwYpL5G3LiDqY+3yVgm1FQqzTZpjMDLe6B82GFDfT2NeYP7ph9OLUhO1dgmEGKKZDo2+NogMSTfRUAvG6QCdO8XXwW9KT84YT7ipeAzQK8vLkQDdE67EZobfynLcRzWawCuYTcKWLrOmgWtFiW+3u47huROn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958495; c=relaxed/simple;
	bh=MpVYyNvNpYOTg4wdWRUA02Rja+rmN6akRw4SD6btFQY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=uftQx7X2fThucZO6/ClTUQ4AbvMhZiGDgPn6iS4aLudqKzJTKdkv0cHVx23wTb56ZsiIT+DahF5D70GRq2eJ4nW52rqXcoBmFfY9FppEfV0gOwKWDKRXAgrBoU+PMXIeM2/Z5YuO0Av5Zhh7+ev3V3BIKBMPAPdxNuUXaLHDz6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3dd74e0f5c7so38864625ab.0
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 06:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958493; x=1749563293;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vH5uXKxA+g9DhmzmYiLnVttaCFRgKDoDat39yDvMsMQ=;
        b=adbpLcG3kLKh7nYu/7dOZcxzcgMYf2y/c+SHHI9FxySTJYmiTrNWOM01mjIqiyPcZu
         t6zFRY8M7zHkxwdtfe2AkgY4F+EnTyeMRg0vZjMERLFO2fGQdIFkNL9OAykHKJ5ialBg
         Fz5OgMnthMqqQA9xJ37ZA81eDKEehUJgzOUgXrABAvObBHERKVGL9M4fxjbLjsP4OD3O
         /epR58pAmlLzvW1JuV2QgRVayz9UIVjptc8Le6fSMauys6ENCBjAkWXi4E5EefdWyM2i
         l+n+x0HhE6IsMpLZNJJ/8T+2Jymw8k1j5d76V5y3HY+/19FLkIu1RoSDScbFhss97/hf
         9pSw==
X-Forwarded-Encrypted: i=1; AJvYcCWJPTtaeGlIwSKh9nxq1zLvPiIV/YIpJapTWTGuLr4Qv8zqAeW7yL/sL7UxK49NXuzMZRR/FTUYGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq1sW8v+IRz9EUJ/+xkAVVI0Lp0a2uEPff+ZBRf2YS1QkgCAAh
	sWn5T7R4edUjW4tHzIwfPCjXlffoxlnSM38jyJyLLWkIde6A3wIhU9EQoWTRceO1ucz6jFzBI1O
	dHhD9/uy9BSAu84YdGxqfuKqhzhFswpQHPrqB3YL6XZPBRhpeetj3aMZ8YLA=
X-Google-Smtp-Source: AGHT+IHOhyZgUqNnAbrBIKAbrZjWoMYNhADJRRCcF1/lcRqFw6l0QC0rA/d2OnlIC7ZAjwvlDADFnXJ2Ed11DTS4/ux2LcRg1S65
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4509:20b0:3dd:a4f0:8339 with SMTP id
 e9e14a558f8ab-3dda4f08594mr87459005ab.8.1748958493078; Tue, 03 Jun 2025
 06:48:13 -0700 (PDT)
Date: Tue, 03 Jun 2025 06:48:13 -0700
In-Reply-To: <2dfb1e75-6a4a-4818-80b5-4519c0a06c4d@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683efd1d.a00a0220.d8eae.006f.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node (4)
From: syzbot <syzbot+818ea33e64f8caf968d1@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	krisman@suse.de, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test: git://git.kernel.dk/linux.git io_uring-6.16

This bug is already marked as invalid. No point in testing.

>
> -- 
> Jens Axboe
>

