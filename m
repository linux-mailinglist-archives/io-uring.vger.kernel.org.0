Return-Path: <io-uring+bounces-9091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8C9B2D221
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 04:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2E7C1C22778
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 02:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A392270ED2;
	Wed, 20 Aug 2025 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9vtRJju"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E5271A7C;
	Wed, 20 Aug 2025 02:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755658636; cv=none; b=hWj+ngyDpnUjlw/KEFpo+i4LJE9A1j7nUBJAGagn6mE6oGpRLOjTrauc3lrhfnwiIf0TMqJLUlUo5RkPLDFPbjZeiLb2vBr1KDg+q4evCmR306WN37Z4lNJmpCiBZtx7hoCWW9RAS33CP2XBeJs14a+ykT6FtZGu/KYwU7wOWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755658636; c=relaxed/simple;
	bh=TorI9HaQqMckKV/lonwDU5tXE5tcRdrNnLoPTZjhML4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=gjgG8x/gVsSm1MWe5eNitBVyA6gA/Bgo0/ENWeWldOo3OZMe0EHxk2f4Z8NdQ0VMN8CHl43pihhTwhLMLwYVf7h1REcDv1bHY3e9oeJ6Zc22iYtyVuAHPEh0S/0wW0aF06WqP0Krs3ekQjH877SjX7AMtAytjN6oLsSY/s2qXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9vtRJju; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24456f3f669so5877675ad.1;
        Tue, 19 Aug 2025 19:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755658634; x=1756263434; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8a2tkZGLvlyHrPs7eC5kUrNp8IhnJHUld6MD5Lo4n8=;
        b=i9vtRJjuYpg+rQSVJQ3hmlkKHNTDxQEL/M2hL6aOo6FghzLpFle8EH1AIVqQ5utrSp
         7/8fzEwhBDXDsl9Fgp8gh0XhwWgwWFzUjJurAFQ5alhtNg/RneK/7rbNv92//LH+425x
         0F9kbMd3MWFlzIy3nrbRtw7RWa1PtjLkjXee/xltnwd3XNsjT7H+Ti1zzDAt1q1Co/IF
         sVecp/SAPa1Qah8zqUTC3pIYUTV7t7KswpDYcpnThmJG4owzNV6cnwpZdpWMjGtUmguz
         tmCJig72jcMxwD9RnY39Ri9M9AeAo8dV7b65qDiLQiHNfM2RUgEboqMgFvsZG6/RMwGo
         LpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755658634; x=1756263434;
        h=in-reply-to:references:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s8a2tkZGLvlyHrPs7eC5kUrNp8IhnJHUld6MD5Lo4n8=;
        b=aRo6XmZUWv12HeBEEXjy10FRjcCaqwjOO76s2d5X2zQlnqixgKKtnPDhgbmKnWspUe
         AIp5Aidq3XUYzLBgk4vSs7GASR7AEnBy5dqEUAlKr6Lgx2SGiguc5WBHUUiUL4GQacTx
         oGBBnbANF+31kI3Lu7pBTo3TFFVHcDAvAnBWWcFY1N5AAHMXNDzIPi9JKK/hE/UIez3Z
         fb5PL5UCmf6MKeG+QT5829i9xLvcLt0LRb3dWxG89eOgmwldIBtkWiTLl4I9hMyKV+TZ
         x89sShvPJd6gyKZHqpqgxBGshHAnmGUzXJyYqIIBYY70POmmddc/hN9B9J5p+mZBMGlI
         xk4w==
X-Forwarded-Encrypted: i=1; AJvYcCUNKpM7FyEdmseFsjgKbBEHqYVqphEQ13oUd3NtkKvcuDN16SdeXA4LKMnx40BMJLcDIN8a7W3UdgGDyBIpUg==@vger.kernel.org, AJvYcCWibeWJomO5id64903IeSI/FpdnlsAyR/EJFSDQxDr2IC8qhnTG3zoN3dfcVtpj/AJCw2wxojM7hxwd@vger.kernel.org, AJvYcCWiylICE1SpHd4womXwUOojK47IJiLnrKUsNe9bmR0WkqUmbKtSQNZ/pcrlXuvzAxtK0/lsvqA6Ng==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBiHNVKjr6DtMMtO6C82efAcu0Bah6FsUNy6Ghhz5gg8otJ/n8
	78NIgXHbezeKQhfUwZaYYp7Kv8a6Uum3EQxH3bZU1P2BUASRYT1F71Ow
X-Gm-Gg: ASbGnctBY+/NdlLt2qGnlTf3E8h+AFaSbX3rV6LIe/Y7RgQ63rW654tDgPDtRHyygmu
	aOaI4c7HgYUSfNdd9f5+yKvHd+TGnLFhV77SpfQTU+ScWENUe9IqulDkYbhEsKCqkxPcZ7zrLjv
	kuh3Ev2+edmOp6mkJjA5DX7e2zscInt2q+mQd51od3Mz2/f1lmrpj2w5O5TGjAMIP2AKqs59+wS
	rEhCQcc3Nr/m4RF+cf6+ejGONZ4jTxzb9DarLfBJB0z7hvg38hsMqE1HRyKHu1GwSdzkx7+FBWc
	8MG73QP8+nXmP9xu2AzXk+m3SSArMHTeWP7WLGDS+2PRp3KGUUHGA60OQX2no1aWHcO8All5IwS
	l049/+TT0jBu2LtsqEp/4he0U1ZzSTMGJtqrE4g==
X-Google-Smtp-Source: AGHT+IHnXxnjaFkiSlGZNXdRxM45b1ExmP16lr8KnCvDEkGp5nBzlbRBWIrVZyuM9uJ0VQmU/dIDVw==
X-Received: by 2002:a17:902:ea0a:b0:23f:c760:fe02 with SMTP id d9443c01a7336-245e094148emr57998035ad.9.1755658633810;
        Tue, 19 Aug 2025 19:57:13 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245f3cada79sm698575ad.48.2025.08.19.19.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 19:57:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 21:01:58 -0600
Message-Id: <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to,
 open_by_handle_at(2) to io_uring
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>, <amir73il@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk>
In-Reply-To: <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk>

On Tue Aug 19, 2025 at 9:11 AM MDT, Jens Axboe wrote:
> I'll take a look at this, but wanted to mention that I dabbled in this
> too a while ago, here's what I had:
>
> https://git.kernel.dk/cgit/linux/log/?h=3Dio_uring-handle

Thanks! That is helpful. Right away I see something you included that I
missed: requiring CONFIG_FHANDLE. Missing that would explain the build
failure emails I got on this series.

I'll include that in v2, when I get around to that--hopefully soon.

>
> Probably pretty incomplete, but I did try and handle some of the
> cases that won't block to avoid spurious -EAGAIN and io-wq usage.

So for the non-blocking case, what I am concerned about is code paths
like this:

do_handle_to_path()
  -> exportfs_decode_fh_raw()
    -> fh_to_dentry()
      -> xfs_fs_fh_to_dentry()
        ... -> xfs_iget()
      OR
      -> ext4_fh_to_dentry()
        ... -> ext4_iget()

Where there doesn't seem to be any existing way to tell the FS
implementation to give up and return -EAGAIN when appropriate. I wasn't
sure how to do that without modifying the signature of fh_to_dentry()
(and fh_to_parent()) which seems awfully invasive for this.

(Using a flag in task_struct to signify "don't block" was previously
discussed:
https://lore.kernel.org/io-uring/22630618-40fc-5668-078d-6cefcb2e4962@kerne=
l.dk/
and that could allow not needing to pass a flag via function argument,
but I agree with the conclusion in that email chain that it's an ugly
solution.)

Any thoughts on that? This seemed to me like there wasn't an obvious
easy solution, hence why I just didn't attempt it at all in v1.
Maybe I'm missing something, though.

Aside from fh_to_dentry(), there is I/O that may arise from
reconnecting the dentry, as Amir pointed out earlier (like in
reconnect_one()). Handling that would, I think, be simpler because it
would only require modifying the generic code under reconnect_path() and
not each filesystem implementation.

