Return-Path: <io-uring+bounces-12067-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FTkHGsXhWl48QMAu9opvQ
	(envelope-from <io-uring+bounces-12067-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 23:19:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86ECAF8066
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 23:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0A8BC3004433
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 22:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70956330305;
	Thu,  5 Feb 2026 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBRaT0of"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F282F28E3
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770329957; cv=pass; b=JXJJbAyl/1hPP+f30uJ/EEFjSc/w/plfhUvjh9Fh5u8mTA4I/mxVQRzSNjqKWjuM2tzjumT7HFpHLRXGeSGCiUnaIqhU4Dv2V+maHmXRIz9tN8b7JIBgCXb8sznTqVoI/mO/VNFg/30kU9NGNIqT2wgrLTy3A45kmD+DkGYJI0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770329957; c=relaxed/simple;
	bh=Z7ONyg2CgvdLnz40hiqFuWjOpiUHALN6dEh7n1vYNoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g6f6VjP9heehmZIAMfLGcaZhCPzTK27STfIR//dUAzAICXLi3+WHZrFmFz3jewYgc9TbE+U9FqUdPVIz+vJr8nXxMCtDGmnXCvTGz+T/FYvyXoeBCCTYkSN1ioU9FIN4mVIKioVM3/rMJaLBVo4Qg9NCNX6evhBTz+OjpAyDRGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FBRaT0of; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5032e951106so13068821cf.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 14:19:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770329956; cv=none;
        d=google.com; s=arc-20240605;
        b=Nk9sjdUUd+ozivGZvcGsbGHpCUfNYJ/7Oalar+2FgsY6NFTA5p+bf1cmZs02AJ4RWK
         0mC9qulI24Za9kZAOz2bIK3ThwIOLGwYU6eHX0PZ0MkHmzL73tX0E2qLUnL2TCHxiabp
         /C8ftjVe4EIVHlU7sX8r9dd/M0pd6KM46IbP4s/msjhkAWeW3scJXtOFfXG8yc4TZ5d9
         nj21z9VMb1KEjPbVtBF1lUd8EiY9UAGaW9Qim5X/fFZ2i4dFhA/XS6FSAonIkl0oq4Ek
         WkybrcguwPWhyItutnxF6fgNcca7QyL/uf3VyHLhNv2/QyCHAZ1cc2H+6awPSySc7U2b
         TZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hp5iztgw+vfIFDqZ1lpLokcscEjVTEfiMcHiTvs4M7c=;
        fh=Ru5tfP/2l3cHOEYqxWyyIyAKd0F2I+RfSO5+DDajFmc=;
        b=OFi0Jn//mA7MTcbjh+j4lAsPeJ4ZzACq6edRy9MUlAaCkR+n0oAUBzyhtnTTVoCYjb
         uyISxvhgrpE2KueX28t8JwIvhqE0y8igvlPbwBCWHPi3R5FW7kUSJKn1SgfS95i4ZFTe
         bpi/LS22kP8YU3Sx3EKIX1aexDj3Nw0K8oKIW8GZBQfVJwB7qesStesorxrSNFmy3pm/
         YpfsmSMgg76ZHbw718W6H476d+zFFeLrwrJ16J1C8W4F22iRFwVUh4c0/a7Fz6QpE2cs
         yjbWfmz8qEuTpsbc8YPAAcweVUtAk6lNJWewNXp/mGfvdITS+6PfUp1WNeFEV7/5M/HS
         frag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770329956; x=1770934756; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hp5iztgw+vfIFDqZ1lpLokcscEjVTEfiMcHiTvs4M7c=;
        b=FBRaT0ofjHa5WM9VybqXppi9AFBlXxusMEH8SNQdps1ObN6uLyvKoa5sYpHmwbI0yN
         pFfnF/bSYVmkYc8AJLWJE5TNgGMKBUEDkyrR2pLDA9NZ+08gFyVWc0PvCyP+mo1VXRvy
         fv02PwR/kxiOrOFIko1eh/VjRzGu11Jy7EKjJLBcrq25UvvVrm03CDCKBNK8OBBvd1Eq
         Pdb/UCeRzvsojtHpaJ/JqqL/9euvRr+ooszwYCHXGcndJssxjchPUdz8P7siWxEMOGYe
         5SeCzeIVvYu1jZanVZfcqtH6PGB90CMcThrctB1ngytgcXg7V/Vz+NWzW1+REbaB1Ohs
         kX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770329956; x=1770934756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hp5iztgw+vfIFDqZ1lpLokcscEjVTEfiMcHiTvs4M7c=;
        b=WJk6Tu4jgUK5Q0NAOmP7DpWJsqHINJIGUO15maobSTQqqfj4Mdm+Ayf8IWtIpS+TZ3
         MW48ZiniG58bcfZfN1HyPASEzRGy3BNugX3nHH8+vXCzvlmUUPJryR2wijylMFeOUDdS
         wGA9VWMzAuMah7rcuidCENglWwm0gXrQGgLNHwN+15OgVF9i6KUHhPFXFrH0yw1bLDXU
         d+p4NsTOAHsmKTeUZuMpg4Kh5Sn+gvGv86kfy62pazK3H2gDk4hNBPbmwk0UUJFf3np2
         U1yWGnrIOpjcAEf5RwoqFML9+QNS5cA02Kt2eJaZtQyC+fKuqAKcCCauH6y3owXyRg0x
         di2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUl8EAHY7VPwVpcAOuaFgJ25Lplzp02mpyEAnt/WacoPKbHymwcQdZFBpGwPg4efZFYmRaT2xinGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTYRqrxDXb0aY+fP1QEukZlJdxGhqOa1rmlhiGS/he3HBmDPvG
	1/iadut4JbfPBtURsQrjm5qGCCONQA9UugjZJ5mic8xjYivogYBK8N7QF990y9inEnuSH4r/Sgn
	PfUASZ66Qrov/+T/kD48xHn8R7d48y04=
X-Gm-Gg: AZuq6aKXnJglgSbc09B66FACBHDJBBYtnScHehfqxeBA0NiW/bQS0RdRE/Y8DK4rDPs
	VYQgtyM1CdlQY2NtzRJ2d1FKJZAlQMDI4VaQMk/Su6Zxo0hvWX3B4baNW/6zgBscUK5ZJrNj6Vx
	1Jq+RpaR1RMopjs6L3m6NvbSlMOStmxsQ9o0szshES8rB15dHfKmF30Rr5EDWtHZChW0sNdWnIY
	AwX6isaIGE+VPcBr52IfrZrzM3qSENjqmz0QG4H9MJKneXLSG4gKprtbTpADHMyyy9G6w==
X-Received: by 2002:a05:622a:199e:b0:502:9866:7547 with SMTP id
 d75a77b69052e-5063995046amr10174401cf.43.1770329955910; Thu, 05 Feb 2026
 14:19:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-20-joannelkoong@gmail.com> <4e406b1f-723b-4dc7-8e50-1a5ef6ea11b3@bsbernd.com>
 <CAJnrk1YDa6=ygmaNhtoDudGdLKmWsP52+_aYNz3E_VNzQUVsDg@mail.gmail.com>
 <ffe1a340-4759-441b-b04d-2ae7732bbd35@ddn.com> <CAJnrk1bt8X2E6estPz-xUmUBeQ93rKOpY078kVQCMmjtiVA5eA@mail.gmail.com>
 <4e9d0896-e887-47bc-bc82-cb7fe17ec64e@ddn.com>
In-Reply-To: <4e9d0896-e887-47bc-bc82-cb7fe17ec64e@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Feb 2026 14:19:05 -0800
X-Gm-Features: AZwV_QhawMA4jdhQIvBqjMfS8mjGoYm0i0VLzWowKjeEMBuplbeQJ7waNMM93uY
Message-ID: <CAJnrk1Z7gNunoYtQoJMrm+xFAwGPTZg0brYhdeLvZ0oBMxiwoA@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12067-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,ddn.com:email,mail.gmail.com:mid,bsbernd.com:email]
X-Rspamd-Queue-Id: 86ECAF8066
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 1:48=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
>
>
> On 2/5/26 22:29, Joanne Koong wrote:
> > On Thu, Feb 5, 2026 at 12:49=E2=80=AFPM Bernd Schubert <bschubert@ddn.c=
om> wrote:
> >>
> >>
> >>
> >> On 2/5/26 21:24, Joanne Koong wrote:
> >>> On Tue, Feb 3, 2026 at 3:58=E2=80=AFPM Bernd Schubert <bernd@bsbernd.=
com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 12/23/25 01:35, Joanne Koong wrote:
> >>>>> Add io-uring kernel-managed buffer ring capability for fuse daemons
> >>>>> communicating through the io-uring interface.
> >>>>>
> >>>>> This has two benefits:
> >>>>> a) eliminates the overhead of pinning/unpinning user pages and
> >>>>> translating virtual addresses for every server-kernel interaction
> >>>>>
> >>>>> b) reduces the amount of memory needed for the buffers per queue an=
d
> >>>>> allows buffers to be reused across entries. Incremental buffer
> >>>>> consumption, when added, will allow a buffer to be used across mult=
iple
> >>>>> requests.
> >>>>>
> >>>>> Buffer ring usage is set on a per-queue basis. In order to use this=
, the
> >>>>> daemon needs to have preregistered a kernel-managed buffer ring and=
 a
> >>>>> fixed buffer at index 0 that will hold all the headers, and set the
> >>>>> "use_bufring" field during registration. The kernel-managed buffer =
ring
> >>>>> will be pinned for the lifetime of the connection.
> >>>>>
> >>>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>>>> ---
> >>>>>  fs/fuse/dev_uring.c       | 423 ++++++++++++++++++++++++++++++++--=
----
> >>>>>  fs/fuse/dev_uring_i.h     |  30 ++-
> >>>>>  include/uapi/linux/fuse.h |  15 +-
> >>>>>  3 files changed, 399 insertions(+), 69 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >>>>> @@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(s=
truct fuse_ring_ent *ent,
> >>>>>  }
> >>>>>
> >>>>>  /* Fetch the next fuse request if available */
> >>>>> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring=
_ent *ent)
> >>>>> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring=
_ent *ent,
> >>>>> +                                               unsigned int issue_=
flags)
> >>>>>       __must_hold(&queue->lock)
> >>>>>  {
> >>>>>       struct fuse_req *req;
> >>>>>       struct fuse_ring_queue *queue =3D ent->queue;
> >>>>>       struct list_head *req_queue =3D &queue->fuse_req_queue;
> >>>>> +     int err;
> >>>>>
> >>>>>       lockdep_assert_held(&queue->lock);
> >>>>>
> >>>>>       /* get and assign the next entry while it is still holding th=
e lock */
> >>>>>       req =3D list_first_entry_or_null(req_queue, struct fuse_req, =
list);
> >>>>> -     if (req)
> >>>>> -             fuse_uring_add_req_to_ring_ent(ent, req);
> >>>>> +     if (req) {
> >>>>> +             err =3D fuse_uring_next_req_update_buffer(ent, req, i=
ssue_flags);
> >>>>> +             if (!err) {
> >>>>> +                     fuse_uring_add_req_to_ring_ent(ent, req);
> >>>>> +                     return req;
> >>>>> +             }
> >>>>
> >>>> Hmm, who/what is going to handle the request if this fails? Let's sa=
y we
> >>>> have just one ring entry per queue and now it fails here - this ring
> >>>> entry will go into FRRS_AVAILABLE and nothing will pull from the que=
ue
> >>>> anymore. I guess it _should_ not happen, some protection would be go=
od.
> >>>> In order to handle it, at least one other ent needs to be in flight.
> >>>
> >>> If the queue only has one ring ent and this fails, the request gets
> >>> reassigned to the ent whenever ->send_req() is next triggered. I don'=
t
> >>> think this is a new edge case introduced by kmbufs; in the existing
> >>> code, fuse_uring_commit_fetch() -> fuse_uring_get_next_fuse_req() ->
> >>> fuse_uring_send_next_to_ring() -> fuse_uring_prepare_send() could fai=
l
> >>> if any of the copying fails, in which case we end up in the same
> >>> position of the ent getting assigned the next request whenever
> >>> ->send_req() is next triggered.
> >>
> >> I don't manage to check right now (need to solve another imbalance wit=
h
> >> reduced rings right now), but every failed copy is *supposed* to end u=
p
> >
> > Thanks for your work on the reduced rings, I'm looking forward to
> > seeing your patchset.
> >
> >> in a request failure. Why should it block, if the copy failed?
> >> It would be a bug if it does not right now and should be solved.
> >>
> >> Regarding your copy, I don't think waiting for for the next ->send_req=
()
> >> is an option, it might be never.
> >> One solution might be a single entry in any of the queues or in a
> >> separate queue that doesn't have buf-rings - i.e. it can go slowly, bu=
t
> >> it must not block. Some wake-up task retry might also work, but would =
be
> >> timeout based.
> >
> > Ah, so your concern is about the request taking too long to complete,
> > not about the ent not being available again to send requests. In the
> > existing code, yes if the next request can't be sent after a commit
> > then that next request is immediately terminated. For the kmbuf case,
> > the fuse_uring_next_req_update_buffer() call only fails if all the
> > buffers are currently being used. The request will be picked up when
> > the next buffer becomes available / is recycled back, which happens
> > when the request(s) sent out to the server completes and is committed,
> > if a ->send_req() hasn't already been triggered by then.
>
>
> In the simple one ring entry example there wouldn't be another in-fly
> request - the request would basically hang forever, if some reasons the

If there's no in-flight request, then the buffer will always be
available since there's no other request using it. For the one
ring-entry example with 1 registered buffer in the bufring,

request A -> reserves buffer 1 -> request A gets sent to the server

request B gets enqueued -> no ent is available -> request is added to
the list for later servicing

server sends a reply for request A -> kernel processes the reply in
fuse_uring_commit_fetch() -> buffer 1 is recycled -> server gets the
next request (request B) -> server uses buffer 1 to service request B


> ring buffer is not available. It *shouldn't* happen, but what if for
> example the same buffer would be used for zery-copy another subsystem
> now consumes them? No idea if that could happen - with these buffers

The buffer is registered by libfuse for the fuse connection and can
*only* be used by that fuse connection. It cannot be used by another
subsystem.

> there an additional complexity, which I don't understand from fuse point
> of view. Let's just assume there would be some kind of ring buffer bug
> and requests would now hang - how would we debug this if it just hangs
> without any log or failure message?

The ring buffer can only run out of entries if there are in-flight
requests that are currently using all the buffers. Those requests will
complete and recycle back the buffer they used and fetch the next
request, which will use the buffer that was just recycled back.

Thanks,
Joanne
>
>
> Thanks,
> Bernd

