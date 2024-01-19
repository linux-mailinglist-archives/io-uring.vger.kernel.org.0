Return-Path: <io-uring+bounces-430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 024BD832E0B
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 18:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 351191C23047
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 17:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6688D55C3D;
	Fri, 19 Jan 2024 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="b7VbVwa/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8DF55C39
	for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 17:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705684848; cv=none; b=Kkn1WbAm+/ksyLYziGKXHLP3O4KPEe8lTdWy7wi6GeE07ueOKZVn66MW+BMkTCVpRjshLiky268qkCnoiDckWJVI61qWuFsiIYThpoAF20/0MUkJFf3Mtss5kLl2MybQZWAZOTxiv3h0QNMFunmybCWaHcFcOVz2POx4NLsxmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705684848; c=relaxed/simple;
	bh=VMddoGlM3Hnbo2LIduvF3DDsuQMktZzY1ageAUl8Wa4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwydKPPNAMYscHbC7zhJE4woP9stjwuC/0+DHyT88xguw1vAXu67Mq+ysYRHRLIrAf/4GjLO6NbH5sW2D0xSFEPy2EpwJNwNTVf5h6BVS6LSXMeXRbFNSqY4B33NRaRrLKjNLsoHkSt/r1ueb//FH61TpZE3io3rz6XvNjc4J9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=b7VbVwa/; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc236729a2bso971160276.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 09:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1705684846; x=1706289646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yjjv0C0A4iL45ZfvIHG0YfKaYF+I6d2xy9d7YamhnKI=;
        b=b7VbVwa/ZdCJZshL6kvLWvqCxsgMnwrlPp34WXP1SA7DYh9mJKJOTP1JM2n7LsDE+2
         59MQWBhpNtf5kj3P50EpmNQqoypmTOv8rlkQ+F15ZP9hnE3H0TnH65fMxVSMbkCO8MMv
         BjTXGuSF142dDLpLuIKRpLzn8rN4tjQfgGdaM7HwwzW2kodxKhJDtlG8aMRDGWXW8NA5
         DGT0cjDnXUiX6/Hbd3VDNNKE8SCFYj5DJiXtaYEb5XCS5BLvc4uNlPkZIlORXeMQRMgr
         QIWGXXMQoPf7ashvj8irEfiPU1U1GQa+VqoRLxa9ilocUvLLZeUytVrMocX2dJGGb0k2
         6LXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705684846; x=1706289646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yjjv0C0A4iL45ZfvIHG0YfKaYF+I6d2xy9d7YamhnKI=;
        b=B6YJNe1tar1PHzXDLreyQtb7ePnqGNd36eerKdcW/RO2vTQn9GgaDUesrSidJaSTMt
         KGqzGIeLuoRkyREGojFvzxBZK7CFEYScIwe15jLO01/Ke8CgZHlu54Uprp+EOoSeqNFf
         lsprf2JegbexKcIg01ML/HZ+gw6Ji8aTOqvKETd7CkF1GdaMEQY7GmAG3vDWSSXSKzH7
         0AXlGcvk5ulaoZXpNi34D2/Wt2pQUomme81gAEMRuLPz+0WgoD2lpHHtCjBZfNjqEyjL
         bdqHa0gNFsh9NKK1p4p37QDII9VEDgXBR3TBy+WqdF+q7SvJJs28zFTYwqJcTcbJjBs+
         N7mg==
X-Gm-Message-State: AOJu0YwD+DxtpXnbbqVtlwYb0dRtCsl6nTxBviCcH4S8+M1VHmJRXWl4
	SpDUXNDv7sOjmQwnzDePo8mbxn5V3Clfx4Yoqrc5hvsOESv6c1vj6YhvaP5ALo+MGCf4x+jyS93
	TunIscaBCo9XNgJtWCyzJ+zEdwGf/9WFqfQJY
X-Google-Smtp-Source: AGHT+IFXg4d8WiKDyeEquwabFJzCscnCekukXwzURRpdmVpPNxI0W3nAiioWj7F7OwIHu/8oS2pKyFI3hK+ClGv0NhU=
X-Received: by 2002:a25:a101:0:b0:dbd:f4e7:5311 with SMTP id
 z1-20020a25a101000000b00dbdf4e75311mr200335ybh.0.1705684845715; Fri, 19 Jan
 2024 09:20:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
 <80b76dac-6406-48c5-aa31-87a2595a023f@kernel.dk>
In-Reply-To: <80b76dac-6406-48c5-aa31-87a2595a023f@kernel.dk>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 19 Jan 2024 12:20:34 -0500
Message-ID: <CAHC9VhQuM1+oYm-Y9ehfb6d7Yz2++pughEkUFNfFpsvinTGTpg@mail.gmail.com>
Subject: Re: IORING_OP_FIXED_FD_INSTALL and audit/LSM interactions
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org, 
	linux-security-module@vger.kernel.org, audit@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 19, 2024 at 12:02=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 1/19/24 9:33 AM, Paul Moore wrote:
> > Hello all,
> >
> > I just noticed the recent addition of IORING_OP_FIXED_FD_INSTALL and I
> > see that it is currently written to skip the io_uring auditing.
> > Assuming I'm understanding the patch correctly, and I'll admit that
> > I've only looked at it for a short time today, my gut feeling is that
> > we want to audit the FIXED_FD_INSTALL opcode as it could make a
> > previously io_uring-only fd generally accessible to userspace.
>
> We can certainly remove the audit skip, it was mostly done as we're
> calling into the security parts anyway later on. But it's not like doing
> the extra audit here would cause any concerns on the io_uring front.

Great.  Do you want to put a patch together for that, or should I?

> > I'm also trying to determine how worried we should be about
> > io_install_fixed_fd() potentially happening with the current task's
> > credentials overridden by the io_uring's personality.  Given that this
> > io_uring operation inserts a fd into the current process, I believe
> > that we should be checking to see if the current task's credentials,
> > and not the io_uring's credentials/personality, are allowed to receive
> > the fd in receive_fd()/security_file_receive().  I don't see an
> > obvious way to filter/block credential overrides on a per-opcode
> > basis, but if we don't want to add a mask for io_kiocb::flags in
> > io_issue_defs (or something similar), perhaps we can forcibly mask out
> > REQ_F_CREDS in io_install_fixed_fd_prep()?  I'm very interested to
> > hear what others think about this.
> >
> > Of course if I'm reading the commit or misunderstanding the
> > IORING_OP_FIXED_FD_INSTALL operation, corrections are welcome :)
>
> I think if there are concerns for that, the easiest solution would be to
> just fail IORING_OP_FIXED_INSTALL if REQ_F_CREDS is set. I don't really
> see a good way to have the security side know about the old creds, as
> the task itself is running with the assigned creds.

The more I've been thinking about it, yes, I believe there are
concerns around FIXED_FD_INSTALL and io_uring personalities for LSMs.
Assuming an io_uring with stored credentials for task A, yet
accessible via task B, task B could submit an IORING_OP_OPENAT command
to open a file using task A's creds and then FIXED_FD_INSTALL that fd
into its own (task B's) file descriptor table without a problem as the
installer's creds (the io_uring creds, or task A) match the file's
creds (also task A since the io_uring opened the file).  Following
code paths in task B that end up going through
security_file_permission() and similar hooks may very well end up
catching the mismatch between the file's creds and task B (depending
on the LSM), but arguably it is something that should have been caught
at receive_fd() time.

--
paul-moore.com

