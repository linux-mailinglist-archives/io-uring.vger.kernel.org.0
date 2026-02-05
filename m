Return-Path: <io-uring+bounces-12064-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKj/IQz+hGl47QMAu9opvQ
	(envelope-from <io-uring+bounces-12064-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 21:31:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAE7F72A6
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 21:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 549EC301B716
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 20:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63074290DBB;
	Thu,  5 Feb 2026 20:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7+vB0mE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145BC26B756
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 20:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770323463; cv=pass; b=nudVwpNate34UZuO/aipWyN+qdvtQRftQtdUDvyfB+2KsMpxprirHkhPfmI/vVJxV0F0l2tHr/F8OtXHDBNgeFmMYU7dQfnx5qwswp0T5wS5Khulg3QmJfA53l3jS3L5XkH4dofOA1OGMiAeqjQQZHNKLJhaHh5eTHuNG4JjD54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770323463; c=relaxed/simple;
	bh=gpu5Ho3szeRH1AdrKbXvhnoFA1prjEfwo7xkCapBcjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fEA58E64XEYnRDSdyFAODvJhQtlCKL8Oad+YyYA8fc+eNU0dwLZZIceg539Hf/sowzHt6xUSUcNMcmCI7W40xjyJHIQNF255QqjI9ZxzIDX/W3gu4T2u8j5D9XwArKqJCJphUGX6aTyKhNQSPcujS7HpxWoUr+Afa1ltf1XLlNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7+vB0mE; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50145d27b4cso16042421cf.2
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 12:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770323462; cv=none;
        d=google.com; s=arc-20240605;
        b=dsqo01V2QzvHjtpvW0K9AJYB6/EQLKhL08psYJQ14fxRoyu+XSOYNexQnxNEzhU2fw
         e7surNP+sA6P9aAuJfhhLtpK1C7DuMZXKTFnUTXM9iUpg0qMOnIJ5tidnuYakkayMBbP
         X7Dh4ldWbEkBkI7TL+6ppJiA1xbIhTq9SIK9oJxaVaX/mp0xJ4UccjXWLIwLZY/WwcFD
         i9K5prqW+0Nmt7FDsbOYmEUm2OAMz3SAUuooJ6lu0PI6K1KEc09oHnky9qNDL0zqDfrp
         Ke7TTloGthc3xPDTv+xG8hnhG0dFpRg1bBk0/GW1YY7MN1Q8P7VwX6eCtQCk4AQ3nfiY
         HwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dujC8EZ0g/eXilP7iS2dUm5q35I+VRrC70mkElRqhg4=;
        fh=e+JxOfHd6zXmWk6wC05guEMd+BSZZvuhM5tAJfpObJY=;
        b=g1svC/lNGTDoWTGoQbW9kEGao3mavRKEyy9gHSySj5/23XeZbyPgSQdyVfUpBMvWv7
         Gf72haadCCA3suudH0Sa2icPnGmtjSWYRQwowH8UlQtEpRJNlBuKbz+ALzicTBj+CpPz
         zDb0WkIFigF4lHpae2raVjy6mV7bbKBq5AqllgQ3BUK6w4JpXsYmgVVyhW2X6SmJCx9Z
         /crQcr+xU4IO4oYv0qU7UVCaNVkG8jifUE8BH7I1w2HULJ/X0EqIKWpADlFPJCdhNE+W
         2t060vDM/9p7+qQqRxrYBIo+MzQ5R9qXt4dxaiaFeNf/VWdI1mFOAUb0wRxk5ObFsmU6
         mJ/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770323462; x=1770928262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dujC8EZ0g/eXilP7iS2dUm5q35I+VRrC70mkElRqhg4=;
        b=f7+vB0mEYnUyMsMY+3dDA+xiUsfrPzSlESd/PfQvnNbRHalLfSRXUEQ6LLejmorCct
         rY6jWtkCahRnvOBqYYgy1wv+w3AnLy3BkB+ojsnq+hkyv1aYJJyoWEuWaMxFE6J1NsM6
         rbc/fYc7rE9p2ZUQzTPndGjLd0vmyE/Q90PQQcsLDqj3tHSIEVM+3Q+ir5a2/IjTfMSO
         e1qyL0t+Uw4iVwmVTPP5x+Yenf02rRHB5bB2guGoVvFcbGmUzF7xGv5O3S3GgaeYnfYl
         3ixQulMdYSmtsiDtPah+KcHUygPrKcdSzsIe9aLbTKrxr3GiikTOOxaBOWmXie7DfnJW
         O9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770323462; x=1770928262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dujC8EZ0g/eXilP7iS2dUm5q35I+VRrC70mkElRqhg4=;
        b=u/olf3qzqxRndgDRx2pa6tSKnZnYUZ9VHZ8pdpLSVxYjmDNndQ7S/WX0EG14la3kvs
         4GEB2Ss9Vfzmh9sAEtpUxoiwWDskuL76Xs+fyrfbKFgTNM6jljcx03elsqA62eG1q9J6
         b/etO8sglD7pIESYQ2Ee2SeXSAKyI0PU19EcBRsTCbLpyD2WmgDnGTiLrXWrHspEE7+8
         yIOQAFGKNTdH0ox6aQdSoWj3mMPL9+vbc6fs8Ewff0rWK7UdZ8jQ60t4/n+muPM0pBEQ
         wYjY8j2DxwrTMU+HSzYpbILulNKQahHaAZUOxV+z9wwsplXLBM3LLzainebmXKM1jLzf
         srgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPpIlY9B8k7jAdjpsvW0dGCooUs2QbcHoY9pZtYJLlfKgSdv0dRX7k8N3vmAAZU0VWu3rJSijjew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/HlEVbTH0nLG4xhFO3xVEcngDx/EsiHpCLJFpGtyXI1zB0sgV
	AbwsVI05My7HiKw/O6iSiIfJXv2O4WNEVYHWt08GYv+SQztPs0Ptn0XtqrrX6Az/2/dDUcpgGVj
	2P17TyinwaQaueuFhWZwO1hzHG+x4P6Q=
X-Gm-Gg: AZuq6aJbahl+sWwfU/1CG58EGEpTABPHy5kT9fDQb/OF+zrWWVBXi5iYiQT3MTYnrMn
	SI6F0DJGaXFRUnFdCOIJz+Z8rmXbCHbvNWN9mXsPB9GnPER6rYkHbHQbA7WWSijVGVGcwFnMnlV
	eS7XMNZztev5aiHhTEm1V+ebrvZ+9NPubC0XcmG1cSC2DyG0XdQB7jsoQGJaT2zscfkIK4Ls/1+
	JZQ0Hy5nanT0cc/bXe6OFLi7GrTgP9cMFwHX4wkRkYv/sJ/pqu8UMux9N26pPF/v0pTUQ==
X-Received: by 2002:ac8:5fd2:0:b0:4f3:530f:d752 with SMTP id
 d75a77b69052e-506399e3540mr5186681cf.81.1770323461651; Thu, 05 Feb 2026
 12:31:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-26-joannelkoong@gmail.com> <4b609081-89e9-41b7-bea2-b3fa4e8b9e3e@bsbernd.com>
In-Reply-To: <4b609081-89e9-41b7-bea2-b3fa4e8b9e3e@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Feb 2026 12:30:50 -0800
X-Gm-Features: AZwV_Qg8zfQkLEaRSDbkx58VruVjYpcaGPLQvXOo3VEGvGW0ck6ffCgQN_OrEKc
Message-ID: <CAJnrk1YLb-t3aqSG2LLu1c3AKiXr=guOVr_sLqSBSfk3-2s+rA@mail.gmail.com>
Subject: Re: [PATCH v4 25/25] docs: fuse: add io-uring bufring and zero-copy documentation
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com, 
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org, 
	asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12064-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bsbernd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: EBAE7F72A6
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 10:56=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 1/17/26 00:30, Joanne Koong wrote:
> > Add documentation for fuse over io-uring usage of kernel-managed
> > bufrings and zero-copy.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  .../filesystems/fuse/fuse-io-uring.rst        | 59 ++++++++++++++++++-
> >  1 file changed, 58 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/filesystems/fuse/fuse-io-uring.rst b/Documen=
tation/filesystems/fuse/fuse-io-uring.rst
> > index d73dd0dbd238..11c244b63d25 100644
> > --- a/Documentation/filesystems/fuse/fuse-io-uring.rst
> > +++ b/Documentation/filesystems/fuse/fuse-io-uring.rst
> > @@ -95,5 +95,62 @@ Sending requests with CQEs
> >   |    <fuse_unlink()                         |
> >   |  <sys_unlink()                            |
> >
> > +Kernel-managed buffer rings
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >
> > -
> > +Kernel-managed buffer rings have two main advantages:
> > +
> > +* eliminates the overhead of pinning/unpinning user pages and translat=
ing
> > +  virtual addresses for every server-kernel interaction
> > +* reduces buffer memory allocation requirements
> > +
> > +In order to use buffer rings, the server must preregister the followin=
g:
> > +
> > +* a fixed buffer at index 0. This is where the headers will reside
> > +* a kernel-managed buffer ring. This is where the payload will reside
>
> Would you mind to add the actual liburing call for this? I think it
> would be helpful for anyone who wants to implement it.

Good idea, I think what might be even more helpful is to refer them to
the libfuse lib/lowlevel_fuse.c file for reference on how to set this
up. Then they could just copy/paste the code directly from libfuse if
they're trying to do something similar. I'll add this in for the next
version.

Thanks,
Joanne

>
> > +
> > +At a high-level, this is how fuse uses buffer rings:

