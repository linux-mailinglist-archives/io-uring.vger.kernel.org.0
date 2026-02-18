Return-Path: <io-uring+bounces-12299-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNSNHJ0hlWkeLwIAu9opvQ
	(envelope-from <io-uring+bounces-12299-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:19:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8989152A99
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 03:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5EC923019827
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 02:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EDF285CB3;
	Wed, 18 Feb 2026 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DJQ5xm8e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC8E19D071
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 02:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771381146; cv=pass; b=fJc+Ldrk/tdCuvcKRoa+PhOf4HA6oRW852A2W5dnAAn+u15D5jVgaLHgXbvkSMD6n158cmxfX/gTO5aS1GTPghkTqaqlQharXESzFV4sy0uQqIxzUN2JLO5xuA+D1J0Xkc1DhLZ0gHN8zGFClJSB0aMGhyjNInEmdN22ZXTPGKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771381146; c=relaxed/simple;
	bh=5VqGDUr1P3SZrmiWbrP8ZLuuKs8NB8dr9t8gUzJsaTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oPv0J4a/O4bGicDWvEcqFs51c6kShAU9DjRznvZeBrIjmx8DkbRiw5RlD1tsdPbx92vmwbO4uz10ouwPbo4RV77MM49+2mKoavKctNLR+F4pDTkDh/KQ/NOcO2MyBbDdm4Uvz5thZ0Ft3fg+U41t056sDsIGkIRmO0mQ37oHzV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DJQ5xm8e; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f7baa467eso49183066b.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 18:19:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771381143; cv=none;
        d=google.com; s=arc-20240605;
        b=SSQaog1ptPN1sG0TWyoPyrWGNzaH2imJT412AwzEBXSy9XtkEehGBkb7sNqtKx+mnC
         QQPgUM7kgRDh8DuVppcLBHAr6Arc3ZIO1lDcq1B8wFFboPRy596T9REe2qfgaV/TDsJl
         a6D8ZzkUBzM8YSPKjASqutO+pXjN/6nYFDMwB9fV4SK/xAkcTFDsfTQXviWFoLs0VI/K
         ZU9ac6JQnGentyvHgLVTsb9HS2b8Qg6hqzlBdcuLPQOTjDVW7JRQNcFLUvWVH0sJzwlD
         0Qpb3OfMEeXvFXGBBpQOqM77v1p9WFyGhrOR7v6o7xHRtlAuTqEfrPH0LPjdH1ubuZvw
         tfJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NMHnTis2eTOTDVEZP9kQAwtC5xzV3oGmf4nIPo5Fpn8=;
        fh=03PJws7yvJpV7TLQCVorjRqmPTghH/okyAK5Ix3rkUo=;
        b=D2rNkVw+E/+8h9aoAxDhua9tmXD19bPP5vp4dD54ginXsjBkphKewN24GZhRMjdl3D
         FQWMAHhSylqwIlN8NzpfwuFa4qwwlB+Hhs9ni7ul+j7e0gkRgtwdnYrbaJ/guwCVRigk
         gxR8nen2rTxJ0Y7uwC/ovdsVLgIyCkq51GcmohZgRXrVE09K8++Psl7qatS/DLFi3Pl1
         1hJzBgagxiPSrlID+kNzEcg8NgDb8R0tiUMXtiCVfo5RGsx8m87i+bwpgh61iYPJtNe/
         Srhl+i83/8qaqfXLM+pCR615QwKsqxU3nuIghf8irXiOaxUjaSpGw8461oVpKC61ID5u
         /eWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771381143; x=1771985943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMHnTis2eTOTDVEZP9kQAwtC5xzV3oGmf4nIPo5Fpn8=;
        b=DJQ5xm8etQEGLBYr604Ymbcv4lXJCsDWi7g8tnx4tEWSeNdl4qv4lxiJmtbmPcQAFW
         nyKO2BBsg/SJQALvrHYffASowNCM3pMV+TdK06CzrCAhPFv9dGhSjZr9ks6eRquf2xhF
         y1fcE9/5af2h3U42WfyzUNzweF9aOho5wId4b9cpJO5to6eebC9870eR8Tgt9JoOcElm
         fC0CA+SCps/sAtVOUV5p0cKgLoVzCffGXurJFl/V1bj5awl6s5HugisSAe/kTHGZKWnC
         ZpSeqxf0L62UbJqOdxMsBlOhgvnfWAqshdBm20mWGgcWH/17vnyM5RuWueMhqR6eV6IO
         FHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771381143; x=1771985943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NMHnTis2eTOTDVEZP9kQAwtC5xzV3oGmf4nIPo5Fpn8=;
        b=YndWRPBZ36qd881F4vSeSSZ7ujNGGrKboliZx4IAbgfs5DoX9Grrpbywt4Ox2BbjOF
         vCXPJZ7pbz1uvTr3L/Tx32q4bA1jDOTcd9BY7dHNODJ246dK0Y15fqCIdR469arV9clL
         1PTv2Hwb95WPjTK+Niji0cmjTJ+0jQR9DmopZAZU/1Mrcy4N9tCE6xw4gdjEriENckJa
         hmU/OSqEwjxegRBLzL6eYcFLnmYf+hlwpZM8H6NMEpwPvEGyxeYgKJD7dvEoKb3VO6C6
         pmLXd9nfICiBThRagegve4dok8baHaJ4BTwJzN1ScZsQ1cLWoncz6IDoJ1gUlZxVG/fD
         6rzQ==
X-Gm-Message-State: AOJu0YwwjSVIvc8CiefdzxtFemObdW9GmTLYswZ3Ksiv6DDiSmVWiZ3R
	vgubyoE+tBTDh1GwqXA1mCW1U/gYCGQxOGwpCe7PpZjf3FItV8GFit37dT93C9x0BySt4BRqQ4m
	9e4kn6uXF1BVBffS+w04z1w4bFwjnrdj9cEcdzE3Bpg==
X-Gm-Gg: AZuq6aKRD0dqd3bYAWzLVRG3oEVc72ah3rm00xnExB0PrKq2PyIu7B3hnzj7DY3iKaH
	nSZaiNN0PhoXB282U+Hm24Q9yIaMmVHnIPgf119PjYEBwNuz8b0ZkI54EfvFZ2UKNZuLP0vs63/
	8HsU1XmW7M3hr8AIUKaq3ELaqFtohdD8GloPb8zA1A64gCw05MxqermhuREDfYC5UaY/gyHnAmM
	Bbpse/tQysV6e/pm1mw0xdU6KoqpiLkbOwi7bxdwabbB6TlyxuQrMtMk1MQLX3PnCpQ1fEtkV7q
	esdTZ877
X-Received: by 2002:a17:907:9719:b0:b88:4ff8:12fb with SMTP id
 a640c23a62f3a-b8fac870c29mr507705366b.0.1771381143250; Tue, 17 Feb 2026
 18:19:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260213032119.1125331-1-csander@purestorage.com> <20260213032119.1125331-3-csander@purestorage.com>
In-Reply-To: <20260213032119.1125331-3-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 17 Feb 2026 18:18:52 -0800
X-Gm-Features: AaiRm50dI3slBlu4uqxlVzOL72r3ApJKaSReOmdwRugNnG7zjKFlefXtw1cmx0U
Message-ID: <CADUfDZr+4hv-vm8my7kbKQG-2zoomG5a1y5Yt9fzxqbvSyPrSw@mail.gmail.com>
Subject: Re: [PATCH 2/3] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,purestorage.com:email,purestorage.com:dkim];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-12299-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+]
X-Rspamd-Queue-Id: C8989152A99
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 7:21=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> requests issued to it to support iopoll. This prevents, for example,
> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> zero-copy buffer registrations are performed using a uring_cmd. There's
> no technical reason why these non-iopoll uring_cmds can't be supported.
> They will either complete synchronously or via an external mechanism
> that calls io_uring_cmd_done(), so they don't need to be polled.
>
> Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
> even if their files don't implement ->uring_cmd_iopoll(). For these
> uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
> don't insert the request into iopoll_list, and take the
> io_req_complete_defer() or io_req_task_work_add() path in
> __io_uring_cmd_done() instead of setting the iopoll_completed flag. Also
> allow io_uring_cmd_mark_cancelable() to be called on these uring_cmds.
> Assert that io_uring_cmd_mark_cancelable() is only called on
> non-IORING_SETUP_IOPOLL io_urings or uring_cmds to files that don't
> implement ->uring_cmd_iopoll().
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c  |  4 +++-
>  io_uring/uring_cmd.c | 11 +++++------
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c45af82dda3d..4e68a5168894 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1417,11 +1417,13 @@ static int io_issue_sqe(struct io_kiocb *req, uns=
igned int issue_flags)
>
>         if (ret =3D=3D IOU_ISSUE_SKIP_COMPLETE) {
>                 ret =3D 0;
>
>                 /* If the op doesn't have a file, we're not polling for i=
t */
> -               if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopol=
l_queue)
> +               if ((req->ctx->flags & IORING_SETUP_IOPOLL) &&
> +                   def->iopoll_queue && (!io_is_uring_cmd(req) ||
> +                                         req->file->f_op->uring_cmd_iopo=
ll))
>                         io_iopoll_req_issued(req, issue_flags);
>         }
>         return ret;
>  }
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index ee7b49f47cb5..8df52e8f1c1b 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -108,12 +108,12 @@ void io_uring_cmd_mark_cancelable(struct io_uring_c=
md *cmd,
>          * Doing cancelations on IOPOLL requests are not supported. Both
>          * because they can't get canceled in the block stack, but also
>          * because iopoll completion data overlaps with the hash_node use=
d
>          * for tracking.
>          */
> -       if (ctx->flags & IORING_SETUP_IOPOLL)
> -               return;
> +       WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL &&
> +                    req->file->f_op->uring_cmd_iopoll);
>
>         if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
>                 cmd->flags |=3D IORING_URING_CMD_CANCELABLE;
>                 io_ring_submit_lock(ctx, issue_flags);
>                 hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cm=
d);
> @@ -165,11 +165,12 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucm=
d, s32 ret, u64 res2,
>                 if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
>                         req->cqe.flags |=3D IORING_CQE_F_32;
>                 io_req_set_cqe32_extra(req, res2, 0);
>         }
>         io_req_uring_cleanup(req, issue_flags);
> -       if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> +       if (req->ctx->flags & IORING_SETUP_IOPOLL &&
> +           req->file->f_op->uring_cmd_iopoll) {

I do worry that the pointer chasing here may be expensive, ->file and
->f_op could both be uncached. Would it make sense to add a flag to
req->flags to indicate whether a request should actually be IOPOLLed?

Thanks,
Caleb

>                 /* order with io_iopoll_req_issued() checking ->iopoll_co=
mplete */
>                 smp_store_release(&req->iopoll_completed, 1);
>         } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
>                 if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
>                         return;
> @@ -255,13 +256,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int=
 issue_flags)
>                 issue_flags |=3D IO_URING_F_SQE128;
>         if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
>                 issue_flags |=3D IO_URING_F_CQE32;
>         if (io_is_compat(ctx))
>                 issue_flags |=3D IO_URING_F_COMPAT;
> -       if (ctx->flags & IORING_SETUP_IOPOLL) {
> -               if (!file->f_op->uring_cmd_iopoll)
> -                       return -EOPNOTSUPP;
> +       if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iop=
oll) {
>                 issue_flags |=3D IO_URING_F_IOPOLL;
>                 req->iopoll_completed =3D 0;
>                 if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
>                         /* make sure every req only blocks once */
>                         req->flags &=3D ~REQ_F_IOPOLL_STATE;
> --
> 2.45.2
>

