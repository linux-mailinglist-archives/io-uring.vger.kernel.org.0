Return-Path: <io-uring+bounces-6039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE1FA1899B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 02:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 620F6163D6B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4684C9F;
	Wed, 22 Jan 2025 01:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuTIDFyd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4724315A;
	Wed, 22 Jan 2025 01:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737509869; cv=none; b=q21uyb7mhnxd0lcSy1P+UyRZkMGsHxMASrJMWbhb7CBWbGfMwcaNZ1eR1WSn0f6IncjSvSReEdaSAFX7swTR89iCMqsX9KPLkuIIgtVAwUVCQ24Fe20TvmK9m00O+xUww6V29785yOeW2aDZ/RLV2WtoltZ1KrfDj/jsFGWGQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737509869; c=relaxed/simple;
	bh=ijBgCnXP6XfghHIoBcu6fcXatbTuRqiF5wZxfYYPW+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QSxhl6HMU/DnxcsLKJbjqxXsOI+B+dSZRAX37OVbdny1SpkmWSODtjwfAD0vLHr7sJInhAxUdEMNUR8I4p3y6mVAo5hxrrZlo8MY9DEsVX7U+1KLMcwtP7NfTvhPNrTw+ZQWfgKZujlLvpabG4atgEeaF/tTY7oncWM27JGFy7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuTIDFyd; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-467a3f1e667so38587081cf.0;
        Tue, 21 Jan 2025 17:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737509867; x=1738114667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTzeSI7yleXf8qYiMIfn95qzeF+jMIAd/tmzeH52K4s=;
        b=LuTIDFydkcLTZ3TY95E6E0cQK/ycYYC2dTIOotCPlF5doiQ7ymhnM4bjXNNiy/iiHZ
         YTQrm8ODWk5/I6TRkPcSKHMP1PANoyGWxhOrVMKFCVWveEAuBCBNGE5hqlt0C/4lyOax
         eBKjqHpwuFsoMrG/ICYOUjaoc4L3A8H5cxVCVEWtEyLIIIvYZHJQJyfBFhG1x0NtNuCV
         pPl90PRrIKg1JTirJ59Jx55e0gHHdM+QrrieqqH/H7UYdLZDfWyUCHUPEoMmo6546szr
         ijl+DMIM+FjIN1jK00YbesDtYieBrVMISmEG9tIe3ifyuW9a5brDcU718YmiEqueOyoN
         cvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737509867; x=1738114667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTzeSI7yleXf8qYiMIfn95qzeF+jMIAd/tmzeH52K4s=;
        b=LLVz/e+LaMtAUjQACUGrDeR6DSId7YQg2GKvAE0lu/cd/iYPEu4ZzBQLzkAb0tcsg4
         /PrerS+e3zPGbOAjAlqKofC+QLFQbwnyNwd24KPCoW/mfXFE+VAsBvgzILaIaHnCAUqp
         3LBfUOizrCzMpgkmluT/pPUhmCoz22bOylI2FoqTF3DEJ4p3o/XjU1yFJ0rKqfL+Ngja
         IjlkAlU3wke4NLTqroZVvM1boRvq+AkVM0rOq4fNXVU0HXi9AFdQmNOThcZHaTlKYTA0
         pljY/k2MoK/j6mjDyC5vccBO2E9j/scJpG9b9Ae2J2hXxDDILT8Dvzh3+oveLTx68Fb0
         8+jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF+ALiD0+RZ44jVLJdKw7cmEmH2w702ZOOP2eUsTfAeDqhMvxaOeyJzl5lB78RN8roVeE8Tm0TwA==@vger.kernel.org, AJvYcCXtCQC4n9rl+I1z8hH+oyLyWmmGE1Eho5+GqppYCJv48yUd686QwWaf/bTTFWdmYUBMiF5wuu4K5IDmD+IICw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2/cuy2W2sZJYg7fPfFqccexcY/Nw6w2TcyD6oDpEwvGltCmP8
	l7vpqYEcECj90S559RE+bvb7KUIOf/Y23kUECEK76T3NHrgIen6mddQd8SYW9h3XQvXnY3t7Mpo
	h7UuBlw7tRVbgkP4OSLwn7xnfzZo=
X-Gm-Gg: ASbGncuj+CBnoJZTSD1ejgnvzQCqYoJnON4DEz9KnITnGIU4rf2/mqlANrwdRALc/Yu
	QAsDnHhl37C301Tp42U8p7+g1Gg+e7cVvWGaQhG7KVwZzCUR/uarw
X-Google-Smtp-Source: AGHT+IEkJNCrmlEG13jy4BmryZRTQGBPV1jIvtsJPeiRrekW2MfSR4nCE1A7MSHs5IBv6VATNiDVxPI9NngWXAJ5Rec=
X-Received: by 2002:a05:622a:3cb:b0:467:86fa:6b72 with SMTP id
 d75a77b69052e-46e12a5549bmr298772581cf.12.1737509866878; Tue, 21 Jan 2025
 17:37:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
 <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com> <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
 <605815bc-40ca-49c1-a727-a36f961b8ad6@bsbernd.com> <CAJnrk1bg_ZwuV1w8x6to50_LYk+o6=HAzC_eQ_U4QGLkyXVwsA@mail.gmail.com>
 <48989a7f-0536-496b-8880-71bfc5da5c19@bsbernd.com> <2ccdb79c-fb2a-46be-8e3d-ac92a19e32f1@bsbernd.com>
In-Reply-To: <2ccdb79c-fb2a-46be-8e3d-ac92a19e32f1@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 21 Jan 2025 17:37:36 -0800
X-Gm-Features: AbW1kvaG5tkzvEZXTDoqstyzd6yk3HTJN4vBWdAaEavn0t5OH5PaF31yOSd9A04
Message-ID: <CAJnrk1ZchvBpaith-ALN2jG=SQB1YELvdG-4cVJZR5uB3domtQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 4:55=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 1/22/25 01:49, Bernd Schubert wrote:
> >
> >
> > On 1/22/25 01:45, Joanne Koong wrote:
> >> On Tue, Jan 21, 2025 at 4:18=E2=80=AFPM Bernd Schubert <bernd@bsbernd.=
com> wrote:
> >>>
> >> ...
> >>>>>
> >>>>>>
> >>>>>>> +
> >>>>>>> +       err =3D fuse_ring_ent_set_commit(ring_ent);
> >>>>>>> +       if (err !=3D 0) {
> >>>>>>> +               pr_info_ratelimited("qid=3D%d commit_id %llu stat=
e %d",
> >>>>>>> +                                   queue->qid, commit_id, ring_e=
nt->state);
> >>>>>>> +               spin_unlock(&queue->lock);
> >>>>>>> +               return err;
> >>>>>>> +       }
> >>>>>>> +
> >>>>>>> +       ring_ent->cmd =3D cmd;
> >>>>>>> +       spin_unlock(&queue->lock);
> >>>>>>> +
> >>>>>>> +       /* without the queue lock, as other locks are taken */
> >>>>>>> +       fuse_uring_commit(ring_ent, issue_flags);
> >>>>>>> +
> >>>>>>> +       /*
> >>>>>>> +        * Fetching the next request is absolutely required as qu=
eued
> >>>>>>> +        * fuse requests would otherwise not get processed - comm=
itting
> >>>>>>> +        * and fetching is done in one step vs legacy fuse, which=
 has separated
> >>>>>>> +        * read (fetch request) and write (commit result).
> >>>>>>> +        */
> >>>>>>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
> >>>>>>
> >>>>>> If there's no request ready to read next, then no request will be
> >>>>>> fetched and this will return. However, as I understand it, once th=
e
> >>>>>> uring is registered, userspace should only be interacting with the
> >>>>>> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
> >>>>>> where no request was ready to read, it seems like userspace would =
have
> >>>>>> nothing to commit when it wants to fetch the next request?
> >>>>>
> >>>>> We have
> >>>>>
> >>>>> FUSE_IO_URING_CMD_REGISTER
> >>>>> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
> >>>>>
> >>>>>
> >>>>> After _CMD_REGISTER the corresponding ring-entry is ready to get fu=
se
> >>>>> requests and waiting. After it gets a request assigned and handles =
it
> >>>>> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possib=
ly
> >>>>> miss that _CMD_REGISTER will already have it waiting?
> >>>>>
> >>>>
> >>>> Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
> >>>> it seems possible that there is no fuse request waiting until a late=
r
> >>>> time? This is the scenario I'm envisioning:
> >>>> a) uring registers successfully and fetches request through _CMD_REG=
ISTER
> >>>> b) server replies to request and fetches new request through _COMMIT=
_AND_FETCH
> >>>> c) server replies to request, tries to fetch new request but no
> >>>> request is ready, through _COMMIT_AND_FETCH
> >>>>
> >>>> maybe I'm missing something in my reading of the code, but how will
> >>>> the server then fetch the next request once the request is ready? It
> >>>> will have to commit something in order to fetch it since there's onl=
y
> >>>> _COMMIT_AND_FETCH which requires a commit, no?
> >>>>
> >>>
> >>> The right name would be '_COMMIT_AND_FETCH_OR_WAIT'. Please see
> >>> fuse_uring_next_fuse_req().
> >>>
> >>> retry:
> >>>         spin_lock(&queue->lock);
> >>>         fuse_uring_ent_avail(ent, queue);           --> entry availab=
le
> >>>         has_next =3D fuse_uring_ent_assign_req(ent);
> >>>         spin_unlock(&queue->lock);
> >>>
> >>>         if (has_next) {
> >>>                 err =3D fuse_uring_send_next_to_ring(ent, issue_flags=
);
> >>>                 if (err)
> >>>                         goto retry;
> >>>         }
> >>>
> >>>
> >>> If there is no available request, the io-uring cmd stored in ent->cmd=
 is
> >>> just queued/available.
> >>
> >> Could you point me to where the wait happens?  I think that's the part
> >> I'm missing. In my reading of the code, if there's no available
> >> request (eg queue->fuse_req_queue is empty), then I see that has_next
> >> will return false and fuse_uring_next_fuse_req() /
> >> fuse_uring_commit_fetch() returns without having fetched anything.
> >> Where does the "if there is no available request, the io-uring cmd is
> >> just queued/available" happen?
> >>
> >
> > You need to read it the other way around, without "has_next" the
> > avail/queued entry is not removed from the list - it is available
> > whenever a new request comes in. Looks like we either need refactoring
> > or at least a comment.
>
> It also not the current task operation that waits - that happens in
> io-uring with 'io_uring_submit_and_wait' and wait-nr > 0. In fuse is is
> really just _not_ running io_uring_cmd_done() that make ent->cmd to be
> available.

Oh I see, the io_uring_cmd_done handles it internally. It's the
.send_req =3D fuse_uring_queue_fuse_req -> fuse_uring_send_req_in_task()
-> io_uring_cmd_done() that gets triggered and signals to userspace
that a fetch is ready when a new request is available later on. It
makes sense to me now, thanks.

>
> Does it help?
>
>
> Thanks,
> Bernd

