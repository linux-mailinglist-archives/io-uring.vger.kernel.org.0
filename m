Return-Path: <io-uring+bounces-12627-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AqOOBFnsGloigIAu9opvQ
	(envelope-from <io-uring+bounces-12627-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 19:46:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6926256A2B
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 19:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D5BFA303CB2D
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 18:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6173D34AF;
	Tue, 10 Mar 2026 18:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sxj2VBsy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D793D9DCE
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168178; cv=pass; b=dRgi+AWEFt+x3rRTjLYGDy+5qOvress/EazzcilthUik8YUrFyhEWvZtZOGvIiP06K2meGi4ElRNTGaHd1I4ae9PXQJCAnL21Ne0xp+MkRTSzCBp4y+2+aOnehlWDK0IVivp2uqDHcGpqzOCM9z9/8xfH8YDja7akqlf0oih+jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168178; c=relaxed/simple;
	bh=MGScO/Lm+dDtJR7p8NMhlWEqVvRMqLIcaA1iibCH6KM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D4XYXJVMR981V/Q9o1+aIA8WW9JjMevZW4EMUnRotU7iM3Oi6Q3Vlc8KzaSejOH5YEpDAsICUA5aO7ffNFNuC9TDdPBlwY2RizNH1OWbc08fcgieRDDJ6oktOSZCg/hIyf4l8rcmmu2l85EAtMkTmJscJ+Po3tbOKYtRt1vUS2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sxj2VBsy; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so5353050a12.0
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 11:42:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773168174; cv=none;
        d=google.com; s=arc-20240605;
        b=aGZdtIah2Y3DYrl8ORP8hU5KpS07Z5fVB4I6sB3icv2fb8G7QTA8GmJ079F9BLC3cW
         lHKkih+Tp8xTfCGLUhujC1uRkgXAYbR1egCr2ZjiXYgXy4l8AGQMubsCuX/m3rMIUa87
         XgCtP7eVmqBCvEBVESefnkHOG6Jy1V8frfzwjWthLCbo59apVmE7AcBgDMi5PHJHsQrl
         2n5M2rnqX0Jrl/R5U5iud6k4COOfJu2Qv0dxvN6dx/ZknZ/xt07vpB/qU1IcBw77fWBn
         7DX+HEDbxUSQLQ8DffJNfMxww8j8AKU0AJdYCGLejxqEU2KW84VF2YgR/qrWBQt4dTGu
         W3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0bbeXKCkxSbBEaua5IOsMyh+0uqfCFCDHQ99hR+ZfEM=;
        fh=DF2aWlwl5E2tjKYkhS6x/M8mY93vYNpd9U6WvLS3gEM=;
        b=hdGGzL6LiijNp0NF/OYhtw2InVaptC9MN2DJAEh/0lY18pdzFihG6jUD4hHRRZ09J6
         jBRnyxJEVhP1lGk0ZHTEo7ePmfMxb8xFpaBF38n0uuwlX0g39duUfLaTwat9Dao4waXs
         hogTITfzquZCPDT9VQRouWk4eJ/C6bjwGDJZwfVNI3jkoADdK3skxbhkEEeraPGazGJu
         sSMm4YmZWb1y4ZuaoTazfdUcuIRiRfwH/ZGCeKpgvWSzhvTreMpTNaP/Rjr+2568IK/h
         Zkrvt3aQXHgOtARZ48ymhaJKdcZEgA/Sn7ikKRH1ndIJbmcF1IoUXTLGTRAvTJW6OLH8
         DRFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773168174; x=1773772974; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0bbeXKCkxSbBEaua5IOsMyh+0uqfCFCDHQ99hR+ZfEM=;
        b=Sxj2VBsyBgDrHN5vvSG/J1L5jhJZKor2TPhiARqjovwBDrFCB4bzQnjDcTTjJV8nEf
         lRNzfxEGkP5tTJtIxuFD13wrjX9Ae4YjQ1xXZHpHDvvpz2yxAF3nkssjbMDezZKIRVTk
         Adm5puw+2xfvLNcMIqZlmouCQNM6KYBqxI0ONXTfIQw529sBApkMLTV1t9KLAlmPEhOb
         pbEEZytaH/gdKUkjsO/pf4vwHOTmGWTT5t93UdSUUKpj9dsAAey/mAOuWq0pec9nOrbH
         44q1RXVVOBEnPMkjbmnyxGAd0wzJRYkU5yuXMm3NXX9UqhUMFPAs47aEQRBJ6aYm3VTj
         ah0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168174; x=1773772974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0bbeXKCkxSbBEaua5IOsMyh+0uqfCFCDHQ99hR+ZfEM=;
        b=rxvtJ4PwtOfxwkSiXPC/5ZBjGGW6vplv1rwhu+SrWd0n3Mc3aCr7Qx2Bg7N3vMVBxR
         bKM++MxcdOkMzxBWZODBUysVZy97hMLh+gMLkG2gjZE2yIRfbBWUfS3FDc54dlJ5RV1h
         9hJh7gI2dWJCOocUYBwZbsUIruzlvche/sP0x7cvuAw+nQKlJjx+GtAZrEVEbxWjOTsa
         XYilxf00zjJImvSShhdhjKl+JK8AcJUULjzse97YlE+8NXt8kyrR2MceWgI5MDQ/qbqb
         kUhVlzkO4UDWhoXseK57RJGAcYj/S8Viu4IfYyCHuecScGYsUrV++r641dywEjRCNVXq
         RQzA==
X-Gm-Message-State: AOJu0YwNLVGhWfn+r+0CyodNYyesQX5opfSt92mMK4EDaBxY0ZyXL4yE
	WQy2oQNiyaZQYJcepGgx7W9lKx6T4u9Dty0VvpbBFme9+eyFmkZo1Wpgf8y+dsFi6C+oEMnNRSO
	TIbd8xhKrJaJ6WdpkbIzXg1sby+xhCKQrs3OiHqI=
X-Gm-Gg: ATEYQzwqDa7n3BIE8Zdiaf4Rab5NrLI/q3q8zfi1EHicyDZe8Uafuww6MQ4M7aO5a3O
	x2dolenmlFQE2sSQJlZIcLg3iSxPo1lsRf7+dKHlHCObV908ZLbRm3T7oGnmqdkX13SB37q5rw9
	j8XGrP6xDPkkmXyif/fnSK5ODNSOdWpm8aTtXLj0i97XE6ZW9HcBRtvoFsBc5XpKSyEksEl4HFG
	tl4d8VR2hIqq4sB3MyvAQK7lRZuk5WULQpZjyI2J9jGcq9wM/Dj6WRmrAoukEZ17FPTMM+o5M98
	/IcWSQ==
X-Received: by 2002:a05:6402:43c4:b0:662:b0cf:b998 with SMTP id
 4fb4d7f45d1cf-662b0cfbbbbmr2784167a12.27.1773168174022; Tue, 10 Mar 2026
 11:42:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310154933.2500971-1-daniele.di.proietto@gmail.com> <abBDc589oZdfR_aD@kbusch-mbp>
In-Reply-To: <abBDc589oZdfR_aD@kbusch-mbp>
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
Date: Tue, 10 Mar 2026 18:42:42 +0000
X-Gm-Features: AaiRm52n44-J5Mslef-NVptxh3vA-Ra8fyF_Iu54fXlE-H9P9lupN9TgnRK5DBk
Message-ID: <CAExiqTJg3on8e33E0jnAWhsewwNzPrVohRmdOjAEvFrArLcBPA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Add IORING_OP_DUP
To: Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6926256A2B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12627-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 10, 2026 at 4:14=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Mar 10, 2026 at 03:49:33PM +0000, Daniele Di Proietto wrote:
> > +int io_dup(struct io_kiocb *req, unsigned int issue_flags)
> > +{
> > +     struct io_dup *id;
> > +     int ret;
> > +
> > +     id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +     ret =3D replace_fd(id->new_fd, id->file, id->o_flags);
>
> It looks like there are a few conditions where replace_fd may block,
> so it may be a problem to call it from the uring enter context since it
> will block progress through the sq ring for subsequent commands.

You're right, thanks!

I can punt the request to io-wq if the file to be closed has a
->flush() method, as asked by Jens.

Any other conditions you're worried about? expand_files() might block
if another thread is trying to expand the file table concurrently, but
io_install_fixed_fd() has the same problem, right?

