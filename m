Return-Path: <io-uring+bounces-13713-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Q5T0NNK/LGoqWAQAu9opvQ
	(envelope-from <io-uring+bounces-13713-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 04:26:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD9967D875
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 04:26:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=aAVONEal;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13713-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13713-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE35C3075C04
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 02:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6CD2D1913;
	Sat, 13 Jun 2026 02:26:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656C52459DC
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 02:26:21 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781317584; cv=pass; b=EEz3nkGYe2GeCDoOFtKZd6Hc+7ll25K1OOmhmYAQJ66+TYByWqbWnBL+2UmtZqroq49RhO3zD0PLs+yBkyPkEaC3z0PGhdasAXx5BHxhxXHFotuCphOIDSOhSOLDHQ/Zp9s33sdTSaYk8P14DCwGq1fWNSTXL7TuUc5CnkSzTvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781317584; c=relaxed/simple;
	bh=4HgnGwCDdRXZaNgAX4Z+MNzKzB4lsUNcY8mm8aCn6ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e5BEjg5ds/3rQjjNfOa8WOrZvS0KsmLA54EtCcHbOy1C2J68NPxRH+kQRuWfQCLehZjsQkT7wVVHWUzqW2m9sS/jaL54y8QSRzpi/nach2a0Z+druK1W6q5PlLz3L4RbfzGzGRFEcFbAtAL7rkbnASkw/a202wwQsrm2+LGS3QM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aAVONEal; arc=pass smtp.client-ip=209.85.210.51
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e6eec0d712so122385a34.2
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 19:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781317581; cv=none;
        d=google.com; s=arc-20240605;
        b=Ms0lPRQsTYoLT4W7yV2eCd10Q/ywefiK6bWPwiza05jkS8yQ3wibmqgVdOclPcNhbs
         6T/J4Ze1aQbzncUSQRfCTmW7BNGnWJasgWum44DGef3RYlpbjzJOwDGMbntTikcsm9Lx
         9gUvZo+oQ0bw5FF944ZY1QB3vlVonSUqGrM65cSu9u9cSx6+6FUYHPcsjNABTMFQojR7
         AvhQhwrw4RmLoqg42h0vlymazkkLEJVYu3n3bR6jklPeIRPY/YfhOI0vr8hBIv97LoWU
         GNumwgCYUdz27XEjinnzC6bsazYOez6WUEKSi+MhBSYAwtr4jBUA5CL6CmjuffaTQ8u5
         yw6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xk2V1zuWC6Clll8+6moIds6DdE9aQ2ALxl8292WzMio=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=AdjBxUU+PbDsjLGktMCxTiLXFCT8XNwKzf2cRFbJA0K1j7pOtlemTu1XOd1AQAFFAu
         bJMQSz7ajJcQ5+17xWlpX2jU+AnFMNcY6MS5VPVSQv/nhRNA62acfPH+gxzLbBXefEtB
         ttjoSZekbzWH/n4isKwEVM0NKFU9MHLtYEWtbqguXZQ5HGcnL/FQsY6QwlET0F6cE46u
         +7iy4WKWM9tpjCkNGoaO7u5BahbZv8QXG2GYtudM7btzznKOrr5aA/+D6ftyyaX2amiK
         k4ySv3rquXMU41jDGFEAKW4WF3JFMzOPJlSV0nCSPHvsLqghuo6JfNa6zIc+5e9M9TmR
         6e3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781317581; x=1781922381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xk2V1zuWC6Clll8+6moIds6DdE9aQ2ALxl8292WzMio=;
        b=aAVONEalXcfgaqtlUIUphfA5sxn2Wb3F/Iuc1ttuWOJTJ1Ygi9D7urJA1Cf56Fjf3E
         2FxAJMiNW2oywtUVmhDC2rNFcO6iJw3MAgsMtfPBGuNaeOSMocw8HclX4w3mQoB4LDLq
         tBXCp3gQCWJy9vHBWqoTGy/mmBpzRrcAALA+Mt4wviX/tPmQjmeW0miM1w7Z+o+4Do8R
         6EgoBqchwH6EowMejvV2KSYCYRNZMw988jzRPTfNvbju0T7GpAkh1HTvAvDjeC6ZtASU
         YYuYzq1tFPVUbUsyOoSFi+0impRDLNfsRDvE6RI7Jnp5eiIxSrXote9AZvY8sKEye9we
         SlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781317581; x=1781922381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xk2V1zuWC6Clll8+6moIds6DdE9aQ2ALxl8292WzMio=;
        b=PkQsqCtJ506A53To16r7j6BkbHPT7kyF2SH8Dc+Wfp/jobmWZlxTeBWq7PxX2YEpUj
         YjTpm3I5mtKpDFtw8u8hAfWccnxjIdkJ7luNaUunPOMSqWzYcQ0PkRmfTbRYpfmidoXX
         eJFKkK+q3uMxIuQHo6giHLntdu2o2DULVvnaw7ClITOEXhyiLmLw0MpdBd9GteTG0w20
         thRVpK2JK9DraAAEXAq4KUPc3+iQ4zw50fLbM2f4tAJARQHjugC5ml3OeMfA3KBbe+kI
         Jo5aamA71W2pQpXoH3vDJGwQkgIyAXtV8GzH4M4htDNRENRYnmDjBSOtgW7uMK0mhWJm
         Vjgg==
X-Gm-Message-State: AOJu0YyL5haQqhRI3MaMPd6VO2+7kQWLk4mfooLZrAkf8m+LsBK4IA7l
	1XciVBpsBN4+zSzjsV1EXImTehZ/dfqgnKFK6V2yXjum8H3x6z10ls3+eOwJTHwkUOlA543xF6O
	O3XKVU1o7qn3a6guPsXTe1/mj3AIPW3OuxiApVnToPKO7VCnW0dFPKEHAYg==
X-Gm-Gg: Acq92OHg7RKGtJmQRyutn574vSnERk7djSXNLCa0N/p0QYO3nnD8AIDLVVntdRzxCP9
	cAbnzrgYZn4vN2GQZ3tFE6fWjqXYWr6t65lumegtOEE1GcBW9q2Jr2VE7KHCafWXCBrT517Hdao
	/LrvdpbE3shtcrBVYWlOb1V/xaTUQzhIhjDJtnqayD2nPoYeAzhyBoY49LH8spBINPkydleRBnP
	6PhFJrwOcqW5pkl3LuZ1+8W4CcYmW2cSoPTGT/yo/zT1Pyryb6UMJnR614VtcSmeXVI4X+mj6S0
	qwKrh6sU
X-Received: by 2002:a05:6830:650f:b0:7db:e661:bb52 with SMTP id
 46e09a7af769-7e7847b3974mr2060706a34.4.1781317580899; Fri, 12 Jun 2026
 19:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com> <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk>
In-Reply-To: <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 12 Jun 2026 19:26:10 -0700
X-Gm-Features: AVVi8CcpbpfmDzHY7W4uFvt4oQBAzXkCF6ZqADeh88qAbtLrnHsp22-1ILVw608
Message-ID: <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[kernel.dk:server fail,vger.kernel.org:server fail,sea.lore.kernel.org:server fail,mail.gmail.com:server fail,purestorage.com:server fail];
	TAGGED_FROM(0.00)[bounces-13713-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,purestorage.com:dkim,purestorage.com:from_mime,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2CD9967D875

On Fri, Jun 12, 2026 at 12:37=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
> >> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req=
)
> >>                 return;
> >>         }
> >>
> >> +       /* task_work must only be added once */
> >> +       if (test_and_set_bit(0, &tctx->tw_pending))
> >> +               return;
> >
> > Is tw_pending necessary? How come the task_work_add() exclusivity
> > isn't already provided by the mpscq_push() check above?
>
> It is, because the transition from empty -> not-empty no longer works
> for that, as the mpscq emtpies one-by-one rather than with a delete-all
> kind of primitive.

Sorry, I'm still not following why the empty check doesn't suffice.
It's true that mpscq elements can be removed from the head one at a
time, but mpscq_push() will continue to return false until the
consumer pops all the elements and successfully sets tail back to
&stub. mpscq_push() will return true once when tail transitions away
from &stub, and then not again until the task work runs and sets tail
back to &stub.

Thanks,
Caleb

