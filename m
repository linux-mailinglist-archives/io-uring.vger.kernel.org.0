Return-Path: <io-uring+bounces-6032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E9FA1887B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 450EF188590D
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2025 23:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148AF383A2;
	Tue, 21 Jan 2025 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWzmCDy4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B584199223
	for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737502925; cv=none; b=Zg9dlH38sONy2FzrreaAcloqfyAQYVSypm6N/1V3fM+pc0D/IfKEZJxncwYP3sIUJ6v5WWXbHdUcZfHuYEMWeaHVhoYC1KkFhEp5h3xbgE0wjOa7X/ds4QMO5EBxAN8871AO/EL96iojcnULuEngnLXM8PwrobSMnqsoQbuW3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737502925; c=relaxed/simple;
	bh=RB0EEhxFcHSqE9n9ubeATcdWljl3Y/RC0IB623FZvKs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uokjRJJLLglg6d7+hRDyaCDz39wT+6C8CsoxksdeRtmn/jQ0HzxpbQ6/KT/ewMu8hM8fUHOPGtLA4q4gUdytXL5cgRhoSWnpXbHYY1YRZii7HkCsdkJmNAjydjmX9/TVIvsJG9aYaXuuwhSOCRcRreJey2l1MSxqqb300KbX5Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XWzmCDy4; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d9f0ab2313so3986a12.0
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2025 15:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737502921; x=1738107721; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RB0EEhxFcHSqE9n9ubeATcdWljl3Y/RC0IB623FZvKs=;
        b=XWzmCDy4dK+3VOU2ApOERqdw6xvoDTOoiQXnmKJFY/F40DTkBaJXDycAh6jm5jkPoV
         FZzN2M0fGdMpbLQLOtIMXMS6imdotUKklpxj+SzErgD4GAjpMZPz1TlGCeb+JPNwZIsX
         JO0Udsp/Gr+0wODq3xkKNjxXlxjLXGqCwaOLjgrHYScxhYvUfNKszoSJ6H4oEK7pQzjO
         a7s5YzrvfIOWbM50bRNGGXkBwT6OVgzoZ7e9YxTdLoiD1QdAkf6CBM52BCRn1h/2BLVq
         zdinLc4bJnLkRYXD0q1i9p6uZKxNm7bDBkxd16cUTYnfwDPxzHwlCqQFJCzlLxzQ+z3f
         tzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737502921; x=1738107721;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RB0EEhxFcHSqE9n9ubeATcdWljl3Y/RC0IB623FZvKs=;
        b=Nn1/Up7UN20SQDFjHBt5bPipIKML0mbf48gPG1Wull9CU5EXwoaOQopwBkRCsU91zj
         onIwkcEM3SmnX49/BbCaRSJtX/StmXgzKlL0W3suwj5+N175a3mxKij+po3ZmtZ9v35I
         pz0p3QK8l69Q9bDBjXyiQ97EjgpxE9JHMiWZHVt0noHF+jYMOjpNBrvLNLpHs0AjqzJz
         b49lQwoU8gv/GGy7Y7gIlvrNs1ur0uMjH2tBpKqE0Y9S0CunXkfivp6PWMPxYqwSwB3S
         3C4rxIUfomyy8JxhBrHLlfmprxCIi6H2qd+lSBrmifGIBDdWBTEUWV73Dpn4btWhox3v
         URhg==
X-Gm-Message-State: AOJu0Yzov2mP08K60OC9ItkhbR9a8223uygASSic+tFjpNBNkHOnautb
	7Cw2WoSMFN0v6x7mHvUKXvxZ+ce0Dfoumf3GvbLxPh3ckn0y33YxDQby4oTXgk0KrDcdVMmCC1t
	h4W4hMibyCx+7+B34idPca6+AE6yV0UgaHgX5
X-Gm-Gg: ASbGncuu2gifXhu75hmVaD51GUn0Wd3evB08DK93U0ldHxasHf5MRLoFXdWsTdtvxk8
	mHd+tIT+0GVcQj71jNJXJE0PQ1JeiyyglEJ4lq75NhKmuSnCLCl2wcbqFQaSEPACqzcCYJ4Sx5s
	/hgWY=
X-Google-Smtp-Source: AGHT+IFRfy4ZgQ5LH5z87pT3O/1L+nNCWRupJsN3LS0Wao7jNmp4M+WeysxXBUtoG5XA5gN4UXBiVWCqoNrHc/UK6gs=
X-Received: by 2002:a50:9f8a:0:b0:5db:689c:cab9 with SMTP id
 4fb4d7f45d1cf-5dbf318a230mr40088a12.6.1737502921025; Tue, 21 Jan 2025
 15:42:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Wed, 22 Jan 2025 00:41:24 +0100
X-Gm-Features: AbW1kvYhrt1n3ghIrphCDnwtvWhd2iBqAtCqYWW-mM8hDx2HJoPHWnQdBzPcmns
Message-ID: <CAG48ez2k5+SpsvWm_Ryj8_F0vHZjYEgJLKa1M2pNpLEoj-0yRg@mail.gmail.com>
Subject: io_msg_remote_post() sets up dangling pointer (but it is never accessed)?
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

I think the following statement in io_msg_remote_post():

req->tctx = READ_ONCE(ctx->submitter_task->io_uring);

sets req->tctx to a pointer that may immediately become dangling if
the ctx->submitter_task concurrently goes through execve() including
the call path:

begin_new_exec -> io_uring_task_cancel -> __io_uring_cancel(true) ->
io_uring_cancel_generic(true, ...) -> __io_uring_free()

However, I can't find any codepath that can actually dereference the
req->tctx of such a ring message; and I did some quick test under
KASAN, and that also did not reveal any issue.

I think the current code is probably fine, but it would be nice if we
could avoid having a potentially dangling pointer here. Can we NULL
out the req->tctx in io_msg_remote_post(), or is that actually used
for some pointer comparison or such?

