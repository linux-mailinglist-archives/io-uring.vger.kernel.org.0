Return-Path: <io-uring+bounces-12065-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKVtCjUMhWmj7gMAu9opvQ
	(envelope-from <io-uring+bounces-12065-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 22:31:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B014F7ABE
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 22:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A91563029AC0
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 21:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321CE331A41;
	Thu,  5 Feb 2026 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyqUNvP4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A7C3314DF
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327009; cv=pass; b=Iwl3ciCi3bKUhvKAxsdK7zHcuZqtWGE3uRQt6lm55Y737PH8Vuw4bW5USMRwOcvQizSbjUd2iLY4EU77JKjaepaLnMoW9Teba2m+rSaG5FEoStwx1j/m8/NEG/8WC4FnI2fCbIjGCR1yKl0GM45FsbAvAC9TByCpUfrhKWnhhUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327009; c=relaxed/simple;
	bh=5syqFeVTZeelBNxzr2AfzGpCgjfqm8uz41noHMy7QO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DaNjlCMTjLbFdDlhmrMINSEmpHEJ2gBadOJma5L0sdGrpkIMqhUWD5X/HxjuPtZiCnYXpO+lqrSB7R1amUZamA7fARHonyRejgsHewocg46qlKXzbcpeAuMVB06udeCLMBgqnfGkKUH79JJL4Bj/SxwR3xUcqZErJyKS1jVQ8Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jyqUNvP4; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5033387c80aso34073451cf.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 13:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770327008; cv=none;
        d=google.com; s=arc-20240605;
        b=hVYPm/wldHw5qT+3dxiwSSHuy+02zv2YnwRJZ57NUj5VmDXyC9K0MI8R0b6H0Wv5NE
         BEYycVHsQXiJMJPJRi5GP822sXhPruyd9zEnGeVuYxNFw2acxgr4GrYeEz6QvWS6wThj
         QTRPY5kEDBFxmuP3d/2LuWnE2jzgiLyJEGS315F2oBsnrzSQIWYstsCTyI4ru3knuzxd
         FXI0r0N9RayGkG4+PHHYfl6Op9JNWgG0qrOArmsxeaYowM5NsPth0sVmLeXYCk1w/Pcu
         tihN2AQv6/3OMZmqri1qMItR9phd8oFnbg1lGlWsrZP+LxDaphRwOhnQFzLfPNyK6qKD
         I80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nfSA2ckH5O+n7A9lxwUGPJVdvjUm2j6EEjNSxNG8QCg=;
        fh=OQEQpvR2XuMdKhWbOSny3RfxjPXGcu9nhOjWzQwljXc=;
        b=QKWpyWM/jiwAUsQ0HRGJYYCkZF2n/KTVqy6SwkS3n2aHEPIy1RpsjR/wBlCKfIMDjI
         eCs/8evrhv+ca+GQLFrAmVG9A179BPdBnqRenN3w+3VLx2nAOzHDXnqhcOPSxla+RFe8
         nzzeZXYdIXXJl98B/FPHeb93OEzqBACWXG7JEoVwbG8KfGlgDQeutlyHteSWkVpMel9w
         BJvcw8p4q1qmW8oUEyLLmbBt8uHOG0SHkrH8Q6bwikiXp2hOtV4H//ph61Yj3rOE3JzZ
         N4t6ddNwuFMEAHokfqPmoCNIPLCMXIkF7dNWfTq+uSoK1CRp48rQP4GYA5TvqqsLAwhe
         Z2Og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770327008; x=1770931808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfSA2ckH5O+n7A9lxwUGPJVdvjUm2j6EEjNSxNG8QCg=;
        b=jyqUNvP4bmbHpgl2BiKhryong+ZN3uiWBHNauDlsdMi2ZWX/VDGkClH9wGdZUOc/VT
         4a1RZzpcLWH7yHJ2stYeBTNiYoj63Yqxe8maWEQFsXmEGFsFZgWJ3fWEUfjKUZ78L4Kt
         D/xHJi7lJmQTRBFgw3DR3vkljNV6UcG7JSAYKUVpVDI3AjidqN+QjJi8ZuZ7MlNBwCX2
         5LZ5gKqCqyTUIs7spl0dXHGzRTGKd4aI+6nqLqT+u1+A3KPQnRiUsDDlH5bDwNeT7sL9
         kC9wc0KZOxb8oIxo5/HUezq3WLXNXz27YAdc6U07/CgGyzmv6oCpldB5oNWvin43ZfrO
         wprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327008; x=1770931808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nfSA2ckH5O+n7A9lxwUGPJVdvjUm2j6EEjNSxNG8QCg=;
        b=AT5ZeOi7sD1PaiB+wZ81upGIoGcAePy7oy6WZL4uZQlO4/H28DHJJ/+S8sE2zBsfJ4
         hytFZWL9kvOjEk4e6lIqxWUWNceSXs+V8+Cf2bPDanSJYwkCp1hwWyA+v7Ml+ndodkV6
         Hur2VKZxi+mPO/8zczUQ9elm0lFoKuCORM4j1i9NL9TKz1EseA5ceBKqDL3DQ8R1/fC1
         0bclUWCkvQ0g8mBKrhOvrLZKZTeTbgqEvSipWu1KCL9ZllB4+xrhDbEiPoHElkrAfXBv
         RQttkyAm516oclJG2/JWK+zZcPwtmiDapn+HGx+pqaHai+p/A2nsjsZ1TpUrK+BJVk0Y
         03ew==
X-Forwarded-Encrypted: i=1; AJvYcCUkIDl2sYiIXmQoFlzBLWpvsFuA1DYX5qkzaF5ZxqOKNA4ouv8lp4fmjMnRDrbTNVwYSQMr8m0/7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxODJpHlL8kMTgnrmIpyuVsVdz9Ttta+fxsWFvoK9w0bXVY0bo1
	TnBPXgnrAK7ZBRJHOMIspoZyMiMCB9Eh2AOcJ1WveV6gGSX1XVs7iCi/7UC8UoeoeaM/4D3NiTt
	IV3NF4FqD3wQ4I91Akazfz0DgO9bnk5Q=
X-Gm-Gg: AZuq6aIti3m/HqKsvlB2+l4RiqudLa2xnnc5aLs8zBYS7Zy89CLrcTZAtSFptHLFPFw
	jgV9mRrzcKiqn/ZYGSnqtQ15bJ3Zwv4d5LTNfe1UO5v3+tgqy8sczgw48JnL8qWmzKTUjxlNeFa
	bM6xc/BcMAig4i5RQBJLzJ+v3XhlqY1ZG89Ml0uhjwrDxTSFQrCQ5bfnOm5aBr5CPAGoofLvMS7
	WYks7Sw6jKmYOoCwD4KJmb1CbAhGykrhKVz9aAtFM2XCjBikpPQj3yEPKenAZZs5dcIcqhLSsLS
	3F8m
X-Received: by 2002:ac8:7fce:0:b0:4ff:a8c1:b00e with SMTP id
 d75a77b69052e-5062aa05062mr62476101cf.2.1770327007755; Thu, 05 Feb 2026
 13:30:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-20-joannelkoong@gmail.com> <4e406b1f-723b-4dc7-8e50-1a5ef6ea11b3@bsbernd.com>
 <CAJnrk1YDa6=ygmaNhtoDudGdLKmWsP52+_aYNz3E_VNzQUVsDg@mail.gmail.com> <ffe1a340-4759-441b-b04d-2ae7732bbd35@ddn.com>
In-Reply-To: <ffe1a340-4759-441b-b04d-2ae7732bbd35@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Feb 2026 13:29:56 -0800
X-Gm-Features: AZwV_QiU22OVhIYbS8_Q-Dz_GLhUOnVqSGHXe9lvb3X9XrxGE8X8D3irl9OmmNY
Message-ID: <CAJnrk1bt8X2E6estPz-xUmUBeQ93rKOpY078kVQCMmjtiVA5eA@mail.gmail.com>
Subject: Re: [PATCH v3 19/25] fuse: add io-uring kernel-managed buffer ring
To: Bernd Schubert <bschubert@ddn.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, miklos@szeredi.hu, axboe@kernel.dk, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, csander@purestorage.com, 
	xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12065-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[bsbernd.com,szeredi.hu,kernel.dk,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 4B014F7ABE
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 12:49=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
>
>
> On 2/5/26 21:24, Joanne Koong wrote:
> > On Tue, Feb 3, 2026 at 3:58=E2=80=AFPM Bernd Schubert <bernd@bsbernd.co=
m> wrote:
> >>
> >>
> >>
> >> On 12/23/25 01:35, Joanne Koong wrote:
> >>> Add io-uring kernel-managed buffer ring capability for fuse daemons
> >>> communicating through the io-uring interface.
> >>>
> >>> This has two benefits:
> >>> a) eliminates the overhead of pinning/unpinning user pages and
> >>> translating virtual addresses for every server-kernel interaction
> >>>
> >>> b) reduces the amount of memory needed for the buffers per queue and
> >>> allows buffers to be reused across entries. Incremental buffer
> >>> consumption, when added, will allow a buffer to be used across multip=
le
> >>> requests.
> >>>
> >>> Buffer ring usage is set on a per-queue basis. In order to use this, =
the
> >>> daemon needs to have preregistered a kernel-managed buffer ring and a
> >>> fixed buffer at index 0 that will hold all the headers, and set the
> >>> "use_bufring" field during registration. The kernel-managed buffer ri=
ng
> >>> will be pinned for the lifetime of the connection.
> >>>
> >>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>> ---
> >>>  fs/fuse/dev_uring.c       | 423 ++++++++++++++++++++++++++++++++----=
--
> >>>  fs/fuse/dev_uring_i.h     |  30 ++-
> >>>  include/uapi/linux/fuse.h |  15 +-
> >>>  3 files changed, 399 insertions(+), 69 deletions(-)
> >>>
> >>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >>> @@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(str=
uct fuse_ring_ent *ent,
> >>>  }
> >>>
> >>>  /* Fetch the next fuse request if available */
> >>> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_e=
nt *ent)
> >>> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_e=
nt *ent,
> >>> +                                               unsigned int issue_fl=
ags)
> >>>       __must_hold(&queue->lock)
> >>>  {
> >>>       struct fuse_req *req;
> >>>       struct fuse_ring_queue *queue =3D ent->queue;
> >>>       struct list_head *req_queue =3D &queue->fuse_req_queue;
> >>> +     int err;
> >>>
> >>>       lockdep_assert_held(&queue->lock);
> >>>
> >>>       /* get and assign the next entry while it is still holding the =
lock */
> >>>       req =3D list_first_entry_or_null(req_queue, struct fuse_req, li=
st);
> >>> -     if (req)
> >>> -             fuse_uring_add_req_to_ring_ent(ent, req);
> >>> +     if (req) {
> >>> +             err =3D fuse_uring_next_req_update_buffer(ent, req, iss=
ue_flags);
> >>> +             if (!err) {
> >>> +                     fuse_uring_add_req_to_ring_ent(ent, req);
> >>> +                     return req;
> >>> +             }
> >>
> >> Hmm, who/what is going to handle the request if this fails? Let's say =
we
> >> have just one ring entry per queue and now it fails here - this ring
> >> entry will go into FRRS_AVAILABLE and nothing will pull from the queue
> >> anymore. I guess it _should_ not happen, some protection would be good=
.
> >> In order to handle it, at least one other ent needs to be in flight.
> >
> > If the queue only has one ring ent and this fails, the request gets
> > reassigned to the ent whenever ->send_req() is next triggered. I don't
> > think this is a new edge case introduced by kmbufs; in the existing
> > code, fuse_uring_commit_fetch() -> fuse_uring_get_next_fuse_req() ->
> > fuse_uring_send_next_to_ring() -> fuse_uring_prepare_send() could fail
> > if any of the copying fails, in which case we end up in the same
> > position of the ent getting assigned the next request whenever
> > ->send_req() is next triggered.
>
> I don't manage to check right now (need to solve another imbalance with
> reduced rings right now), but every failed copy is *supposed* to end up

Thanks for your work on the reduced rings, I'm looking forward to
seeing your patchset.

> in a request failure. Why should it block, if the copy failed?
> It would be a bug if it does not right now and should be solved.
>
> Regarding your copy, I don't think waiting for for the next ->send_req()
> is an option, it might be never.
> One solution might be a single entry in any of the queues or in a
> separate queue that doesn't have buf-rings - i.e. it can go slowly, but
> it must not block. Some wake-up task retry might also work, but would be
> timeout based.

Ah, so your concern is about the request taking too long to complete,
not about the ent not being available again to send requests. In the
existing code, yes if the next request can't be sent after a commit
then that next request is immediately terminated. For the kmbuf case,
the fuse_uring_next_req_update_buffer() call only fails if all the
buffers are currently being used. The request will be picked up when
the next buffer becomes available / is recycled back, which happens
when the request(s) sent out to the server completes and is committed,
if a ->send_req() hasn't already been triggered by then.

Thanks,
Joanne


>
>
> Thanks,
> Bernd
>

