Return-Path: <io-uring+bounces-4807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C18459D1DE7
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 03:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A5BF1F211AA
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E80F179A7;
	Tue, 19 Nov 2024 02:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARAvz6/U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3CB3FF1;
	Tue, 19 Nov 2024 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981758; cv=none; b=aJNSsWArrzp0F8rXSRFi0PqcrvwPPUINT+vNQhJW2LWBIwdcu74Pn/EMo46Qk8ME1x9JhsVdqrY5WriZ0UrsLo6j1pMiYGGDQ2WCD2YrRuf7cuS8FQouwhCqkYMJu7RLao6zKYd7HVYoezVhoFqYxVRCVVo/mQUA8+GL/I/GbSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981758; c=relaxed/simple;
	bh=IRTjbqzZKvhc+aYkEaVA4syPDyMZSzr+N955Ab3ijeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBLScwujD4hkoRjRn6wXph757EAn/AMwOxdpf5V8rejOkfE6mCQaBXr/rA88WXDwZk3pOFFPGb31J0VK60Nctp/f/hc1xPxlNZEvZJeAoqueZ8nEpkTmtULwI7gQBP5+Ksu7U8q6bAuzM4fFngfes1MCUXHZbWwbW5HOadBnQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ARAvz6/U; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-460c2418e37so30607071cf.0;
        Mon, 18 Nov 2024 18:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731981755; x=1732586555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTsX9FLKt1Yl9wgbTorRdkM0TWe8BdbNSz0bAqGWV6k=;
        b=ARAvz6/U/QQKxcxono4pBgHq6wPvE9adpEwutgaDpAKO0hkGN5FEWYJIiKWL+wUjoG
         uXPrOSsyzmHsm13AQVeSR3VNU0blrwD2C+ryXwXMY/Ah+5VWmZAWmr8zn697xjo/AQus
         ltROsPUAPXR1IHtX4AgmGczksxTUIV3MyBhK7rM0tXU1rXSjIoskBJjuKN0K0FPTy3z6
         M/gYIK45dJsOUdlqPCwlg/i0mRx6Aw/Yxf9eeYcAbOjTq4N+efrgEjNiz0iH7aiu2+Ny
         MrnB+mskAwrVoY3Rz+9iQ8rEjZMzHjeAkDBYy7Q34Jk4X6RNGIeyqjJaJ5AWrrX4oAHJ
         PbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731981755; x=1732586555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YTsX9FLKt1Yl9wgbTorRdkM0TWe8BdbNSz0bAqGWV6k=;
        b=D+5zvp+KtSGWbRPJq3XX+Oyv9eqnPE27MGY4f/9FIM6EfeP4u0qT0ztI1ZeTWzylS8
         Cgzr1EFsFWKauD7pT70HpiCMQDxNZl6NFdKKiCFjtFZ9XyayFr+7hVg+d2zVhiN/ommD
         M0+5fkYUsrZMab0TLKprpizWQjEfXGlufMWY4TpI+fW7QFMv96/BENlWKHD284PwhZ7F
         +K7B2WvQv78G9DutHkpgs+57onBPOWoK9MkbUtn6F6tUibuFswflz+kbMSfvV6tq8QEs
         Q4Vyn7+bviSjdY5GqqwlkkU2/h9PTsGYivsplQTn7aFQpDmF6NCuPyyyHJKCtMylu01q
         2HZA==
X-Forwarded-Encrypted: i=1; AJvYcCV5mmy7JOwEmcLedpiat8yRtDr6gIW2g+74DW1/VD0wgQd3v1vcfQHhiLGQKvadwgsh2AYOlNDQDQ==@vger.kernel.org, AJvYcCWQtjTT6dDgPJnbAFGWadXh28XrP0Zn4m5P0RHqSsOBdyvUeSlkxfP77LQ20sdJZdgW9fybFan63AMHzj2/lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfMg9eevVpKGSCK+0r36Pp5tDH6ItF/A14mkzm1Lw7bJlp1p0s
	wnQR7rZoUkhQm3ol5hb1I3MnI6iQRxQuN5MrbKhn8TO2nqy5Uy1No/zh4Dosfe63NbpAGWiFQnK
	8wOTTjGvI7zSA6nuyaBu1GkLX0ME=
X-Google-Smtp-Source: AGHT+IGe/EluwGH0TjXEtZ01gJK+1CVUJQAdbWQZSPXiQUm7SG5oRfWqv/JN8EeMCa8Py0Z21SSeiBYImSB6EEUhAes=
X-Received: by 2002:a05:622a:6119:b0:462:ae89:4695 with SMTP id
 d75a77b69052e-46363e2db8bmr194661971cf.30.1731981755166; Mon, 18 Nov 2024
 18:02:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
 <CAJnrk1YuoiWzq=ykn9wFKG3RZYdFm-AzSiXfoP=Js0S-P7eKZA@mail.gmail.com> <19af894d-d5ac-4fcf-8fa1-b387c354c669@fastmail.fm>
In-Reply-To: <19af894d-d5ac-4fcf-8fa1-b387c354c669@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 Nov 2024 18:02:24 -0800
Message-ID: <CAJnrk1a7jOtz_Noyw4mw9p4TqoUCJ-6hR9wJiQFER9w8g5mmzg@mail.gmail.com>
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 3:47=E2=80=AFPM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
> On 11/19/24 00:30, Joanne Koong wrote:
> > On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> When the fuse-server terminates while the fuse-client or kernel
> >> still has queued URING_CMDs, these commands retain references
> >> to the struct file used by the fuse connection. This prevents
> >> fuse_dev_release() from being invoked, resulting in a hung mount
> >> point.
> >>
> >> This patch addresses the issue by making queued URING_CMDs
> >> cancelable, allowing fuse_dev_release() to proceed as expected
> >> and preventing the mount point from hanging.
> >>
> >> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> >> ---
> >>  fs/fuse/dev_uring.c | 76 ++++++++++++++++++++++++++++++++++++++++++++=
++++-----
> >>  1 file changed, 70 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >> index 6af515458695ccb2e32cc8c62c45471e6710c15f..b465da41c42c47eaf69f09=
bab1423061bc8fcc68 100644
> >> --- a/fs/fuse/dev_uring.c
> >> +++ b/fs/fuse/dev_uring.c
> >> @@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
> >>
> >>  struct fuse_uring_cmd_pdu {
> >>         struct fuse_ring_ent *ring_ent;
> >> +       struct fuse_ring_queue *queue;
> >>  };
> >>
> >>  /*
> >> @@ -382,6 +383,61 @@ void fuse_uring_stop_queues(struct fuse_ring *rin=
g)
> >>         }
> >>  }
> >>
> >> +/*
> >> + * Handle IO_URING_F_CANCEL, typically should come on daemon terminat=
ion
> >> + */
> >> +static void fuse_uring_cancel(struct io_uring_cmd *cmd,
> >> +                             unsigned int issue_flags, struct fuse_co=
nn *fc)
> >> +{
> >> +       struct fuse_uring_cmd_pdu *pdu =3D (struct fuse_uring_cmd_pdu =
*)cmd->pdu;
> >> +       struct fuse_ring_queue *queue =3D pdu->queue;
> >> +       struct fuse_ring_ent *ent;
> >> +       bool found =3D false;
> >> +       bool need_cmd_done =3D false;
> >> +
> >> +       spin_lock(&queue->lock);
> >> +
> >> +       /* XXX: This is cumbersome for large queues. */
> >> +       list_for_each_entry(ent, &queue->ent_avail_queue, list) {
> >> +               if (pdu->ring_ent =3D=3D ent) {
> >> +                       found =3D true;
> >> +                       break;
> >> +               }
> >> +       }
> >
> > Do we have to check that the entry is on the ent_avail_queue, or can
> > we assume that if the ent->state is FRRS_WAIT, the only queue it'll be
> > on is the ent_avail_queue? I see only one case where this isn't true,
> > for teardown in fuse_uring_stop_list_entries() - if we had a
> > workaround for this, eg having some teardown state signifying that
> > io_uring_cmd_done() needs to be called on the cmd and clearing
> > FRRS_WAIT, then we could get rid of iteration through ent_avail_queue
> > for every cancelled cmd.
>
>
> I'm scared that we would run into races - I don't want to access memory
> pointed to by pdu->ring_ent, before I'm not sure it is on the list.

Oh, I was seeing that we mark the cmd as cancellable (eg in
fuse_uring_prepare_cancel()) only after the ring_ent is moved to the
ent_avail_queue (in fuse_uring_ent_avail()) and that this is done in
the scope of the queue->lock, so we would only call into
fuse_uring_cancel() when the ring_ent is on the list. Could there
still be a race condition here?

Alternatively, inspired by your "bool valid;" idea below, maybe
another solution would be having a bit in "struct fuse_ring_ent"
tracking if io_uring_cmd_done() needs to be called on it?

This is fairly unimportant though - this part could always be
optimized in a future patchset if you think it needs to be optimized,
but was just curious if these would work.


Thanks,
Joanne

> Remember the long discussion Miklos and I had about the tiny 'tag'
> variable and finding requests using existing hash lists [0] ?
> Personally I would prefer an array of
>
> struct queue_entries {
>         struct fuse_ring_ent *ring_ent;
>         bool valid;
> }
>
>
> in struct fuse_ring_queue {
>     ...
>     struct queue_entries *entries[]
> }
>
> And that array would only get freed on queue destruction. Besides
> avoiding hash lists, it would also allow to use 'valid' to know if
> we can access the ring_entry and then check the state.
>
> Thanks,
> Bernd
>
>
> [0] https://lore.kernel.org/linux-fsdevel/CAJfpegu_UQ1BNp0UDHeOZFWwUoXbJ_=
LP4W=3Do+UX6MB3DsJbH8g@mail.gmail.com/T/#t

