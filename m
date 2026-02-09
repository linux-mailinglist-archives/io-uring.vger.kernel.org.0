Return-Path: <io-uring+bounces-12108-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NuJKzUaimkjHAAAu9opvQ
	(envelope-from <io-uring+bounces-12108-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 18:32:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 104C4113128
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 18:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9703A301BF6F
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 17:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC834283FD9;
	Mon,  9 Feb 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSGFpZi0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870D1261B80
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770658319; cv=pass; b=nmxFRCvUhAcYVyeic0DmR11TC5tj6dEuKgb/eZqxFRC4SjCGIPHw0Ogz1X2GOCUmO1AHdOAeGdvBVcx1EmQqVZXN9UxR8vRMRhWqOv6tQg1UiBMDXc7rjhVjC68pabUvCjVDWyqxAspVC5ujWAtOZPwfGEuAG0mWJ3YKvS/ThPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770658319; c=relaxed/simple;
	bh=A7Bemy7E0jyiRqsRJXizeGyfe9brY6d0bZ1gI/sSMQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VUoc5DHMIY7oQtGQWiVbkyWQvfyOp4mG/yqfePcRUUTWF/qfGOUxqILdLDHRRW8n6tlpSFkfRJRDt/Crr5hpFTqGaUNZ/G8cQhrmSYHDvZ+msVLTAOP1Y4w61/RUR5ZnL2EDQIzclQL/4LvNZL+IJ5OYTswIi+3LadXFnGZ3dDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSGFpZi0; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50143fe869fso48784491cf.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 09:31:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770658318; cv=none;
        d=google.com; s=arc-20240605;
        b=NB22791S8GI/ub8Z325OSIquNoAYlTsTo3aQpqlUU9FH03rDBKBOAznwZ6kzcSCwZv
         r8Z9WWwV5wGx0+AalMTps5j9y5YnB93ikg+Pl775BgPVKE5tHdQrMQGftmskk6gQQKN2
         NydrO7AwNkgHzX5P1x+vbaHwLs69vmUAgmbYZeuB4q26LJpqA5nZ97cYlKhsKZTd5nSt
         fQpW83DrRh4lKeo+a64QVxVGvvxxo8UjL85NuaCN2Cpln0GdYOK28pBVjRaXBGfM+8D9
         IKkpBOBPay3EIS6S5IpIgKLxbKNapM5lSzZ22GfIgAZYDVZ6rrs+shVZ8b/Ifns6TMr3
         yosg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A7Bemy7E0jyiRqsRJXizeGyfe9brY6d0bZ1gI/sSMQs=;
        fh=4Daa5ZRaDIdKkcgbJpAkhSrVhY78ewlzGpBC0XXykZc=;
        b=KX3nLWWoYxWgTiV/HgbnBzxHRqoF40FPQkqyRZ5xRPj/B4W7ly3ZXkVXbe1eFjCRr2
         LIwugP9exAcW6wStiXoZWYE13DbAtwRpBf3Z34Ps61RyulDiSv7mqfDc2sWj3AJU1HRh
         LVw8ovnR/bDP7rPj9mHJClV6LeixooMlfzYFLNyeDakRppHjbFaEYrhO079d275VHnzb
         Eol1VnHXVydIR+oLp2BA18yL+8MA6EGZZ4hMq+CQMq/O2zm5rS83w7TnNbNEk/gFhwCR
         gdRQl7vMTHIES0nTVfcwjrDMR3Wd26geljro7jJncCRQ+zQW8lyfdOqo+JmXttNsnANd
         cdOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770658318; x=1771263118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7Bemy7E0jyiRqsRJXizeGyfe9brY6d0bZ1gI/sSMQs=;
        b=DSGFpZi06+Ifj8xMUmopTDeYKSp4ZfQrL7UDxzTGKNglm9L3ackg7CkUChFTLeaQGL
         zdOyVYzF51+OBuBVdqGf81qjBAHYVkIxtlxCUg8rjGG+eQ0Ypyb0qg3koteZz3wlHU+h
         Nq4yNoXOB5DCm1o/AGuqHNZ7tQNefgXDnDa48Zc6L01CWn9JVc8TU6r2E3rqYLBx6c5o
         DpH9iOHTS3YLRz2K+PmodEhUyZl5PxArn1P3eJZBL3LCf7ReqBAojesarOlXdljRm9yT
         n5C1rKtKwPDU73HSD+8ler1ipNOhYw+0pD5Dt2QV/P10+Wb/qs7IXFgXOu+3vEyAakhl
         4znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770658318; x=1771263118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A7Bemy7E0jyiRqsRJXizeGyfe9brY6d0bZ1gI/sSMQs=;
        b=NbmYI42XgtUwwZusWo/0Bk+xtb2GaAnNRWRgtH28VgaF8Y7SK8gOU9/h6TRhq5d3YE
         8TwF0MVktBg3hxDBu7yKXrVXHkd08QtvpHzkWpCawEERL974FBDTVrihVjIMf6VEmrsn
         9NQnZ7XvHauVEA625mWd+LpkfFFzx91Bs4zW1kHg7PxWtHE8rfKBdoqvGUqW4qfYz0z7
         Qb5DR+GFwO87uGnfsmCLKj3m+jAOfj7Mxe8/BncMX8moFtVr89zYyzpU7Fp/2swyFsI+
         aQhC42ih+ilt0hm7VNYmiOUWM9jerTcEnxqMbPkOLc2BzzQJNLNTbLJWDfsx8KYV+AKd
         vIQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWiUDQkkwort9lrIY0ekA0oXST5P3kYi35VDiQ/xT2PqI/J123drBfJYuqL7i0hM4tkNjLrdy/uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwB4C+gQ9HZyB3z15cMxLaQJ9kK5Uven55/cyvNOQ5WV0954h8
	y3K9aNQg+48jrcv6S1B2JMWPcVQ7huTPVXz7m0R8Li4/NgwwVZeCdDpy9I/0tbvVcJl+xvTETcZ
	h/nzNW8VB3StEWi5n55atbJNxP8Y5w8Y=
X-Gm-Gg: AZuq6aKlBt4r1pR+I5JcddyeatGJGwxyDhL/dFm8WEjPAwdEZMVfuIGXJ4HknN5NzOq
	pELhPbib/imZD//JkvQ3AzaWwq7VEbPyCklUhhVElrukOZfKpNTT6m8DLJGVtROS3lKzmXESsJw
	cyrqMxZAmDmzHTmGS6H7nuHMDcCgk7BSj4cONsq6l7S7so+/CJ5BMv/z5LQMiW5Xfnr5I1v6vqL
	qKwfnhLpLrot2dGjxyPwN9bYPGfqNrA84VlWKJKCQ3nIt86jbPrlW/X0Xt1qazsJ4JC8A==
X-Received: by 2002:ac8:7e82:0:b0:4ee:45e1:24e3 with SMTP id
 d75a77b69052e-5063999af40mr155510251cf.67.1770658318255; Mon, 09 Feb 2026
 09:31:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-4-joannelkoong@gmail.com>
 <20260206133950.3133771-1-safinaskar@gmail.com> <CAJnrk1YEw2CJb5Vv__BX7DaZXmZMfTsH3WYtQ2s4RGDWNRW4_A@mail.gmail.com>
 <CAPnZJGCPNHS=R9s2dW4ebA2vtW5AQOmX7RLUtEiC2QOHKUdBmQ@mail.gmail.com>
In-Reply-To: <CAPnZJGCPNHS=R9s2dW4ebA2vtW5AQOmX7RLUtEiC2QOHKUdBmQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 9 Feb 2026 09:31:47 -0800
X-Gm-Features: AZwV_QhnvPop5QG8SjbDcxI4POma1wqiv8UbGDbgwQQrh0tPm3hQ69v2uwM00-Y
Message-ID: <CAJnrk1Y_e1prLGX2Wo7VqRM8=upLqP29Cwv81J+bULRvCCbx_Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Askar Safin <safinaskar@gmail.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, bschubert@ddn.com, 
	csander@purestorage.com, io-uring@vger.kernel.org, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org, 
	xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12108-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,ddn.com,purestorage.com,vger.kernel.org,suse.de,szeredi.hu,infradead.org,samsung.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 104C4113128
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 8:13=E2=80=AFAM Askar Safin <safinaskar@gmail.com> w=
rote:
>
> On Sat, Feb 7, 2026 at 4:22=E2=80=AFAM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> > I don't think this is related to kmbufs. Zero-copying is done through
> > registered buffers (eg userspace registers sparse buffers for the ring
>
> Thank you for your answer.
>
> Please, don't CC me when sending future versions of this patchset.

For context, your email address was cc-ed because you had left a
comment [1] on v1 of this patchset series. I'll make sure to remove
you from the cc list going forward.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20251213075246.164290-1-safinaska=
r@gmail.com/

>
> --
> Askar Safin

