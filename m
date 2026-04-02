Return-Path: <io-uring+bounces-12934-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OI7EFR+RzmkbogYAu9opvQ
	(envelope-from <io-uring+bounces-12934-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 17:54:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8C638B818
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 17:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD133300D71A
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 15:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8222F2D5432;
	Thu,  2 Apr 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b="ldnRa4Fz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC5030F816
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775145224; cv=none; b=c1KgyIVltwrs4XQK76ZGIldNW0OUzp+TBR4qIaTzv3z2quLqpOAygNd6FmmI/hCwaI+7+nkeo7xSpCCAR3nbKWG+oD3jRgdNDZ0AJFjNxJMIuXNRuOBc0+OZCjwozRIbYIH8JyTSrgVu7fZhQfTJxjyuNz2A96rG6QxwXGLisvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775145224; c=relaxed/simple;
	bh=KYoX6gKN6gt3nY8hNo/FfNtKjn/EfpgeJwnbJ6NulPE=;
	h=From:Content-Type:Mime-Version:Subject:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=M/KvVvjYckHPCn18lS89O3Ue3CZmtWGu59CN4KFhqdHc+DsDjv7TcJ97uLnPi/JenmoTFB0Tl/+i4iZWaD45Sz3ixRB1Y4gsltDa3rDnQwSsIBSaAtI4ebLGhV5DDwxLbhcibb7xMtWc8/0baqLmQDi+GglcMPHuYsuBh+8WZg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries; spf=pass smtp.mailfrom=p2p.industries; dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b=ldnRa4Fz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=p2p.industries
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fb14227cso13997955e9.3
        for <io-uring@vger.kernel.org>; Thu, 02 Apr 2026 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=p2p.industries; s=google; t=1775145221; x=1775750021; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5SEopH7qoOVm2O4AeVWA5YO/SyHxUnzqAKH92QpDAU=;
        b=ldnRa4FzLKlCGCtxlZzrL4XkXisDYJzYd04thKOZLnRb78SaTFsialiV0v4tBZjdvP
         qlZBz8uAb1EPsil0UYunEw6WLQDFB3ORwma629u9dJntrCllkRcKaaxqnGzhSRFXmzZa
         xp10hYYXto9kHrkbubiEwdHAwVnuvKnFth+CsckWEkJ9fSxinn0P4K1UFcHL3RQbeUtQ
         INbaLq3k5ZgEQ+8hXkt5Z534eO8L8IMocB+zDCOW5ll1aiJj3Y6qq46hmfSrIe7geTns
         DUUWK7LX3OchCSLya27PCig5n3C8e4hA8M9z7OFe6id3sifj/gAvg7iBXUvguzNyhkEs
         X4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775145221; x=1775750021;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e5SEopH7qoOVm2O4AeVWA5YO/SyHxUnzqAKH92QpDAU=;
        b=Q+HZKQxnhYeh/nVKDNExqLwHUNB1tsNgyyaG+UGIwWCx1PowaoTt0bPYFB2ne34AZo
         5zG9a/HLdoBuOIFQnSjy95oNU52C0h/2oGeDZ2ASazvM8pPX/OPd09/f/n/pkDKO7VhN
         AWvfnotTNusvXgigazOR6PghcX177PhD/wzDRMaD+OW4plLv2kw45umAVLUmVtJdfCCV
         guOQFH9fzpf0JyO6gMAN7IvW+C7ggFN5ZGODYnLoXhmTJA88xeism1sPI+25fbXI6+Fq
         emEPId575Fssdg64XMzJHrOhHbXOB9IIhIBqu3Qx/m4yHB+ywsi1zlVjguD++lg1a4dS
         +YPw==
X-Forwarded-Encrypted: i=1; AJvYcCXXc62+KPVmaZgw7NmcAY03vd2i9lWv2sj3V9BJLN4YNBj/0DypzIfkJR6JGcG3f2JM/km8AUR80g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAj0mBq2aO9Cvt+Hqto/qHOwugRrWrYC9kOWp3GjcaQKGLoP3D
	5qSTtL4JFGmCQLpWU4Rlkwb6L/fHXVE/BIVrtDzZEBmjhGfUXlQr1LPqBCQeZVxC6X0=
X-Gm-Gg: ATEYQzx1jThwF7m472WlqnbVtrC61yNOSdYa9KbI4L9dif/G/vhYtbAQpCuWAQRkbjv
	LBpGXDmF1ZZT1+DLk5hFsTXYVjd3FHpeGQc9lwtSCQ92518yb1jVoiNr0s9TL70+AixE6Zn28WF
	ii5vhRZ2NQLvCK1WIZ0xSFla+uJEbJH0gcjbq0biCKeDfYl2cPXgQRKP6TygKEfZozsBSWvFLUu
	4DxOowvoatMFaQie99q+iBiVY6dZ5Zcpv4DB3Q1qa0m2GblI47MRki2/aTp7pBJWUXzzFB4opjd
	wcApxzrVSTe9DhdLFeCPK+Ah4QONcBmqjbvqsaYqE7g31nNLAR6S/XeE5ddQL7ewI5yV9TtCCko
	hQkrWFI+sj/UH1zaK4k//lVcwPqiEe/CcvLwOX5801GQHEihhHB6o7kxjVFvx6Y4W4bmYf3BKPb
	ReMVjc5zNC2wqfA6ziZN+ojYAfy7XXUaMtJRqYOf8WmkMHJAAwOGVOyU9OCXjKR80inAy4XAMFz
	n20vvmPqbRTLTp7Mi3jcVKQ
X-Received: by 2002:a05:600c:3e87:b0:486:fba7:b150 with SMTP id 5b1f17b1804b1-4888359cfc8mr148410665e9.15.1775145221141;
        Thu, 02 Apr 2026 08:53:41 -0700 (PDT)
Received: from smtpclient.apple (mob-194-230-144-149.cgn.sunrise.net. [194.230.144.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887eb5aff3sm285397555e9.15.2026.04.02.08.53.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2026 08:53:40 -0700 (PDT)
From: Hannes Furmans <hannes@p2p.industries>
X-Google-Original-From: Hannes Furmans <hannes@stillwind.ai>
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2] io_uring/net: don't check MSG_CTRUNC for
 IORING_OP_RECV
In-Reply-To: <20260227162730.79355-1-hannes@stillwind.ai>
Date: Thu, 2 Apr 2026 17:53:27 +0200
Cc: Stefan Metzmacher <metze@samba.org>,
 io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9651A09E-97B6-4EF2-806C-4EAAF96C9C93@stillwind.ai>
References: <20260226220310.758404-1-hannes@stillwind.ai>
 <20260227162730.79355-1-hannes@stillwind.ai>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3864.500.181)
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[p2p.industries,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[p2p.industries:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12934-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[p2p.industries:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hannes@p2p.industries,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,stillwind.ai:email,stillwind.ai:mid,p2p.industries:dkim]
X-Rspamd-Queue-Id: BD8C638B818
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Gentle ping on this. This is a one-line fix for a real bug where =
IORING_OP_RECV on kTLS sockets spuriously fails linked ops due to =
MSG_CTRUNC being sent by put_cmsg() when no cmsg buffer is provided.
Stefan indicated the approach looks correct. Would be great to get this =
into 7.0 if possible, as we=E2=80=99re in the RC window and this is a =
straightforward bug fix.

> On 27. Feb 2026, at 17:27, Hannes Furmans <hannes@stillwind.ai> wrote:
>=20
> IORING_OP_RECV sets up the msghdr with msg_control=3DNULL and
> msg_controllen=3D0, as it has no cmsg support. Any socket layer that
> calls put_cmsg() will find no buffer space and set MSG_CTRUNC in
> msg_flags. This is expected =E2=80=94 the caller didn't ask for =
control data.
>=20
> However, io_recv checks:
>=20
>    if ((flags & MSG_WAITALL) && (msg_flags & (MSG_TRUNC | =
MSG_CTRUNC)))
>        req_set_fail(req);
>=20
> This sets REQ_F_FAIL on a fully successful recv (ret >=3D min_ret) =
when
> MSG_CTRUNC is set, which causes io_disarm_next() to cancel all linked
> operations with -ECANCELED. The recv CQE shows the full requested byte
> count, yet linked operations are cancelled.
>=20
> This is triggered by kTLS, which calls put_cmsg(SOL_TLS,
> TLS_GET_RECORD_TYPE) for every record in tls_record_content_type()
> (tls_sw.c), but it affects any protocol that delivers cmsg data on
> the kernel side.
>=20
> The MSG_CTRUNC check was introduced by commit 0031275d119e ("io_uring:
> call req_set_fail_links() on short send[msg]()/recv[msg]() with
> MSG_WAITALL") whose commit message states "For IORING_OP_RECVMSG we
> also check for the MSG_TRUNC and MSG_CTRUNC flags", but the code
> applied the check to IORING_OP_RECV as well. MSG_CTRUNC is meaningful
> for IORING_OP_RECVMSG where the user provides a cmsg buffer =E2=80=94
> truncation there means lost metadata. It is meaningless for
> IORING_OP_RECV which never provides a cmsg buffer.
>=20
> Remove MSG_CTRUNC from the io_recv check. The io_recvmsg check is
> left unchanged as MSG_CTRUNC is meaningful there.
>=20
> Fixes: 0031275d119e ("io_uring: call req_set_fail_links() on short =
send[msg]()/recv[msg]() with MSG_WAITALL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hannes Furmans <hannes@stillwind.ai>
> ---
> v2: v1 incorrectly guarded req_set_fail() for all done_io > 0 cases.
>    Stefan Metzmacher correctly pointed out that short MSG_WAITALL
>    reads should still sever the link chain.
>=20
>    Root-caused via ftrace + msg_flags inspection on a real kTLS
>    connection (TLS 1.3, AES-128-GCM, S3 download):
>=20
>    ftrace shows io_uring_fail_link firing immediately after
>    io_uring_complete with result=3D67108864 (full 64MB), from io-wq:
>=20
>      iou-wrk-52242 io_uring_complete: req ..., result 67108864
>      iou-wrk-52242 io_uring_fail_link: opcode RECV, link ...
>=20
>    A debug recvmsg on the same kTLS socket shows:
>=20
>      recvmsg: ret=3D67108864 msg_flags=3D0x88 (MSG_EOR | MSG_CTRUNC)
>=20
>    MSG_CTRUNC is always set because kTLS calls put_cmsg() but
>    IORING_OP_RECV provides no cmsg buffer.
>=20
> io_uring/net.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 8576c6cb2236..8baaf74e8f8d 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1221,7 +1221,7 @@ int io_recv(struct io_kiocb *req, unsigned int =
issue_flags)
> if (ret =3D=3D -ERESTARTSYS)
> ret =3D -EINTR;
> req_set_fail(req);
> - } else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & =
(MSG_TRUNC | MSG_CTRUNC))) {
> + } else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & =
MSG_TRUNC)) {
> out_free:
> req_set_fail(req);
> }
> --=20
> 2.53.0
>=20


