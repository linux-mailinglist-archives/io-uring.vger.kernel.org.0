Return-Path: <io-uring+bounces-12781-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGkxEWkpv2k6xAMAu9opvQ
	(envelope-from <io-uring+bounces-12781-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:27:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D88E82E7A72
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 997A63014BD2
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E9731197C;
	Sat, 21 Mar 2026 23:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lhnl9yn7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912BD30C360
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135632; cv=pass; b=lTIdfyhlmlOeSiIxdDqZlMLXd2FHZnCZ0b8df8ARQooHowifpz/81rPpO/XO6epTMyakAT+Osp0Vv1zT3Xd7ZU+UWyHiuRk78D5RDZirJ7v0aZWiV7/AbmwJtuUUtV4rknXmGAFmC7RDCI/a8mmseC5fgg+Xrx+P7RtdPr7er08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135632; c=relaxed/simple;
	bh=G8BytNw02W6vsycYkdOnMmOBMqHAcRd1M/AlrJVLpnM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ns4VBN1AjsQtd/PDgvB9nMLSnlk1//jCjgJwQIE/fMihsW6ctlcn+gyCFBzFpStwq0qnwoV0WLnnnZjtytbvCY9dnsbf3HWuf/wB4cNW7tpAWdvNk21A7JpiDoJl6tAfEk3b0AaHYfcuLZXbb+qohhDhLFA+cGUHgLyJ6rmb9W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lhnl9yn7; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-668abc98923so2964690a12.3
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774135629; cv=none;
        d=google.com; s=arc-20240605;
        b=YxmTBA2DI2gMxGoM8b+zoCagrt7OjqkIULAEbNqF3l4Vk0144CpQMhnYuRuiSUPhkc
         iZW/sJK+AnBUTn/DoTAep2q0HOdfdFQQj0aVFqYtsn7PWepzfJQuMLeKHi5Rpi50LeUf
         W0/5tPvkqK4HXV/B/wstoWn74Tl2k/LsCbf8Qyx5uG8ixWNGLdDZCVaP+THWQj/UZb/j
         6A4StocuyhjpaOac/Hsoe+ykbjWMWNhjSb9uF6SqsXTgQ+5Ti1xBY9lZ5+++jDqTKhki
         VqyOlh+XQ4D7FDLOVvrHQReY1YIIN2mNAawKJddwNWSDLVbIirfUqBJ82CEUZ6RkZAPs
         bj7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B3FrJdxRaBhBSTbUb3RLQ76YVu/ckuzSV9/oUaWJ78A=;
        fh=kxoLnxMJ06NPGl1FGw6SFecbTm3dkko16UHuQF8ejaw=;
        b=Dz+MN1aJF0shcCJoWeabXyX+iZOSlCHRsAKK4KxMmiVWqD77Wi9MoXAV16Mn/ZpY53
         haVdU3ynyCMp3rhJi0WskxIIUOWtD7NxW/V5gdrpXmsC3bA350ZpnNNLdUoURjiRBadW
         QMIfneutBrt+cnKtPs5lgXaxa5wGeCO43TeM6r2N2s6QgPus4h0aul037cuRK9gUwzuC
         qmwTL0NQ3uKMZxQstK7+z43iA7o2XgllOiYYtzK6WIJcmnACPNOmhv7X5GA2Y/I0uYwl
         puGS2ktQh+mtNfzakgnyfOaK44gPwwBpLFbQhgwS7e1MdYAfdIP4nDs2nYP9TQMGOhMy
         PuHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135629; x=1774740429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3FrJdxRaBhBSTbUb3RLQ76YVu/ckuzSV9/oUaWJ78A=;
        b=Lhnl9yn7RFiBaB92oY/yQtnVpTNuBjT7dq73zhdZp+KcEVVs735zKFM5hRMI4fSZwP
         /iPIJyeAsVMp4tuD7CDIYr+jsSyxE/0z9wF9NjjYfd7QS7LgDZUAP5WEL2ZCH+vJzNG0
         kHWTwt9z7uPBDTy0QsuP+lp5cz2/d53x7TSkSn5B8IkUZsJSEA0aUg/gTzk1hIjdxQWI
         d7J7+juQ9lUurGx3OalVd9reH/luQa+A6T7PoO2ipIPL2IBNi691UHXMZdwioPNKaLTP
         wWAIDo4FHuEbp2xsCtrK5//xhviV1SXSMgHgsiOJuujDNbqkeELvWL5hNmyy/CTGXPcC
         W2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135629; x=1774740429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B3FrJdxRaBhBSTbUb3RLQ76YVu/ckuzSV9/oUaWJ78A=;
        b=EyBLMJbLzoxbFgmEwutITNXwO9lvWsqKCYgRMlB1y0XXYcBXoFTwPmX0qTlJSUks9J
         h4JAKw3H2gnHmpU9L6+OO6ilHmmeg2+PSABeGqu/HyQpTcVgk/85AZyLKBVQeNrEgyXI
         wJD+110mlpYkwepd7JAy0mQq21tEtTp5sCokzyNkH8s4yuuWEc8r8+zyczth3sA+PLK8
         xwOPbYfKkY53g+zjItseCWYdLU/RqpJnudc4Rm3eaeB2tq6cmSol/rnXU2b9c/5jExR3
         TJTt9zRMPwI7oQpTQEwBRJEyi+ssv85FOMYi6aqyrIjtbBt2pPIo0TKNBYwhqKxDSaBC
         fvxA==
X-Gm-Message-State: AOJu0YwI69iGec42Jg1/s0OkRfLlwRYueZnfAf1Z6XDwfTFBrRsMBC7x
	qOFeIUEjW8wmhCehuDQEVD4AT2ARM+rCDrDeQoms+/dX4FY2dEk53oKubL/og71WbgiNp36sP3e
	Ym2aqdh4Etdu5sevUUa1Il0oYOFmc/dtJ1jv5CDU=
X-Gm-Gg: ATEYQzxjN2aHJLt4GVCiwSS5oWzXWP/VcQXCOAY5AxfEL2kMoR6uvuTVVEuh9P0wpSS
	mp4YdJVTZhCPDWmkcaiziyaGfoW4GteK/3fLS1Jg6aracupMrCbyFKjx5G87DpNeoRBGKek0CAV
	w3Ld7/GCDn87bm56QHwwSMwiRbEwPMiltUz0gBNsL+BGqvtrbh658IcnZk3ePnjHxTOMrpgr3Kg
	s1R441B9wuNm/DkiDTiyqO1e8hlotl07NTzTfOgLGwAQj65uMZF53JGKQmxpUej7P8HvjcnmgPB
	LfbPPV4=
X-Received: by 2002:a05:6402:2695:b0:668:2375:e359 with SMTP id
 4fb4d7f45d1cf-668c99307a7mr5325875a12.21.1774135628799; Sat, 21 Mar 2026
 16:27:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260320182341.780295-1-daniele.di.proietto@gmail.com>
 <20260320182341.780295-3-daniele.di.proietto@gmail.com> <ff60b19b-ecd8-44cd-b7d3-f7755fe49934@kernel.dk>
In-Reply-To: <ff60b19b-ecd8-44cd-b7d3-f7755fe49934@kernel.dk>
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
Date: Sat, 21 Mar 2026 23:26:57 +0000
X-Gm-Features: AaiRm51KiLQ5T1eFtmof4LzJCpvNt5gAu0JZkvsFm88l3tgew6rQn8VgZ79c2-U
Message-ID: <CAExiqTJ5JKOeb-9rKy15i4hQw341EvpSc0aQNt1iMxxurHbZVQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] io_uring: Add IORING_OP_DUP
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12781-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Queue-Id: D88E82E7A72
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 20, 2026 at 7:34=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/20/26 12:23 PM, Daniele Di Proietto wrote:
> > diff --git a/fs/file.c b/fs/file.c
> > index 384c83ce768d..64d712ef89b5 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -285,9 +285,8 @@ static int expand_fdtable(struct files_struct *file=
s, unsigned int nr)
> >   * Return <0 error code on error; 0 on success.
> >   * The files->file_lock should be held on entry, and will be held on e=
xit.
> >   */
> > -static int expand_files(struct files_struct *files, unsigned int nr)
> > -     __releases(files->file_lock)
> > -     __acquires(files->file_lock)
> > +int expand_files(struct files_struct *files, unsigned int nr)
> > +     __releases(files->file_lock) __acquires(files->file_lock)
> >  {
> >       struct fdtable *fdt;
> >       int error;
> > @@ -1291,13 +1290,33 @@ bool get_close_on_exec(unsigned int fd)
> >       return res;
> >  }
> >
> > -static int do_dup2(struct files_struct *files,
> > -     struct file *file, unsigned fd, unsigned flags)
> > -__releases(&files->file_lock)
> > +/**
> > + * do_replace_fd_locked() - Installs a file on a specific fd number.
> > + * @files: struct files_struct to install the file on.
> > + * @file: struct file to be installed.
> > + * @fd: number in the files table to replace
> > + * @flags: the O_* flags to apply to the new fd entry
> > + *
> > + * Installs a @file on the specific @fd number on the @files table.
> > + *
> > + * The caller must makes sure that @fd fits inside the @files table, l=
ikely via
> > + * expand_files().
> > + *
> > + * Requires holding @files->file_lock.
> > + *
> > + * This helper handles its own reference counting of the incoming
> > + * struct file.
> > + *
> > + * Returns a preexisting file in @fd, if any, NULL, if none or an erro=
r.
> > + */
> > +struct file *do_replace_fd_locked(struct files_struct *files, struct f=
ile *file,
> > +                               unsigned int fd, unsigned int flags)
> >  {
> >       struct file *tofree;
> >       struct fdtable *fdt;
> >
> > +     lockdep_assert_held(&files->file_lock);
> > +
> >       /*
> >        * dup2() is expected to close the file installed in the target f=
d slot
> >        * (if any). However, userspace hand-picking a fd may be racing a=
gainst
> > @@ -1328,26 +1347,19 @@ __releases(&files->file_lock)
> >       fd =3D array_index_nospec(fd, fdt->max_fds);
> >       tofree =3D rcu_dereference_raw(fdt->fd[fd]);
> >       if (!tofree && fd_is_open(fd, fdt))
> > -             goto Ebusy;
> > +             return ERR_PTR(-EBUSY);
> >       get_file(file);
> >       rcu_assign_pointer(fdt->fd[fd], file);
> >       __set_open_fd(fd, fdt, flags & O_CLOEXEC);
> > -     spin_unlock(&files->file_lock);
> > -
> > -     if (tofree)
> > -             filp_close(tofree, files);
> > -
> > -     return fd;
> >
> > -Ebusy:
> > -     spin_unlock(&files->file_lock);
> > -     return -EBUSY;
> > +     return tofree;
> >  }
> >
> >  int replace_fd(unsigned fd, struct file *file, unsigned flags)
> >  {
> > -     int err;
> >       struct files_struct *files =3D current->files;
> > +     struct file *tofree;
> > +     int err;
> >
> >       if (!file)
> >               return close_fd(fd);
> > @@ -1359,9 +1371,14 @@ int replace_fd(unsigned fd, struct file *file, u=
nsigned flags)
> >       err =3D expand_files(files, fd);
> >       if (unlikely(err < 0))
> >               goto out_unlock;
> > -     err =3D do_dup2(files, file, fd, flags);
> > -     if (err < 0)
> > -             return err;
> > +     tofree =3D do_replace_fd_locked(files, file, fd, flags);
> > +     spin_unlock(&files->file_lock);
> > +
> > +     if (IS_ERR(tofree))
> > +             return PTR_ERR(tofree);
> > +
> > +     if (tofree)
> > +             filp_close(tofree, files);
> >       return 0;
> >
> >  out_unlock:
> > @@ -1422,11 +1439,29 @@ int receive_fd_replace(int new_fd, struct file =
*file, unsigned int o_flags)
> >       return new_fd;
> >  }
> >
> > -static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags=
)
> > +static struct file *do_dup3(struct files_struct *files, unsigned int o=
ldfd,
> > +                         unsigned int newfd, int flags)
> > +     __releases(files->file_lock) __acquires(files->file_lock)
> >  {
> > -     int err =3D -EBADF;
> >       struct file *file;
> > +     int err =3D 0;
> > +
> > +     err =3D expand_files(files, newfd);
> > +     file =3D files_lookup_fd_locked(files, oldfd);
> > +     if (unlikely(!file))
> > +             return ERR_PTR(-EBADF);
> > +     if (err < 0) {
> > +             if (err =3D=3D -EMFILE)
> > +                     err =3D -EBADF;
> > +             return ERR_PTR(err);
> > +     }
> > +     return do_replace_fd_locked(files, file, newfd, flags);
> > +}
> > +
> > +static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags=
)
> > +{
> >       struct files_struct *files =3D current->files;
> > +     struct file *to_free;
> >
> >       if ((flags & ~O_CLOEXEC) !=3D 0)
> >               return -EINVAL;
> > @@ -1438,22 +1473,15 @@ static int ksys_dup3(unsigned int oldfd, unsign=
ed int newfd, int flags)
> >               return -EBADF;
> >
> >       spin_lock(&files->file_lock);
> > -     err =3D expand_files(files, newfd);
> > -     file =3D files_lookup_fd_locked(files, oldfd);
> > -     if (unlikely(!file))
> > -             goto Ebadf;
> > -     if (unlikely(err < 0)) {
> > -             if (err =3D=3D -EMFILE)
> > -                     goto Ebadf;
> > -             goto out_unlock;
> > -     }
> > -     return do_dup2(files, file, newfd, flags);
> > -
> > -Ebadf:
> > -     err =3D -EBADF;
> > -out_unlock:
> > +     to_free =3D do_dup3(files, oldfd, newfd, flags);
> >       spin_unlock(&files->file_lock);
> > -     return err;
> > +
> > +     if (IS_ERR(to_free))
> > +             return PTR_ERR(to_free);
> > +     if (to_free)
> > +             filp_close(to_free, files);
> > +
> > +     return newfd;
> >  }
> >
> >  SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, f=
lags)
> > diff --git a/fs/internal.h b/fs/internal.h
> > index cbc384a1aa09..c3d1eaf65328 100644
> > --- a/fs/internal.h
> > +++ b/fs/internal.h
> > @@ -197,6 +197,11 @@ extern struct file *do_file_open_root(const struct=
 path *,
> >  extern struct open_how build_open_how(int flags, umode_t mode);
> >  extern int build_open_flags(const struct open_how *how, struct open_fl=
ags *op);
> >  struct file *file_close_fd_locked(struct files_struct *files, unsigned=
 fd);
> > +struct file *do_replace_fd_locked(struct files_struct *files, struct f=
ile *file,
> > +                               unsigned int fd, unsigned int flags)
> > +     __must_hold(files->file_lock);
> > +int expand_files(struct files_struct *files, unsigned int nr)
> > +     __releases(files->file_lock) __acquires(files->file_lock);
> >
> >  int do_ftruncate(struct file *file, loff_t length, int small);
> >  int do_sys_ftruncate(unsigned int fd, loff_t length, int small);
>
> All of the above should be a separate prep patch, not part of the
> io_uring patch adding IORING_OP_DUP.

Done, thanks!

>
> > diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> > index c71242915dad..2658adbfd17a 100644
> > --- a/io_uring/openclose.c
> > +++ b/io_uring/openclose.c
> > @@ -446,3 +454,175 @@ int io_pipe(struct io_kiocb *req, unsigned int is=
sue_flags)
> >               fput(files[1]);
> >       return ret;
> >  }
> > +
> > +void io_dup_cleanup(struct io_kiocb *req)
> > +{
> > +     struct io_dup *id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +
> > +     if (id->rsrc_node)
> > +             io_put_rsrc_node(req->ctx, id->rsrc_node);
> > +}
>
> Probably doesn't hurt to be defensive and clear ->rsrc_node when put.

Done, thanks!

>
> > +int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > +{
> > +     struct io_dup *id;
> > +
> > +     if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->a=
ddr3)
> > +             return -EINVAL;
> > +
> > +     id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +     id->flags =3D READ_ONCE(sqe->dup_flags);
> > +     if (id->flags & ~(IORING_DUP_NO_CLOEXEC | IORING_DUP_OLD_FIXED |
> > +                       IORING_DUP_NEW_FIXED))
> > +             return -EINVAL;
>
> Would be cleaner with an IORING_DUP_FLAGS mask above io_dup_prep().

Done, thanks!

>
> > +static struct file *io_dup_get_old_file_fixed(struct io_kiocb *req,
> > +                                           unsigned int issue_flags,
> > +                                           unsigned int file_slot)
> > +{
> > +     struct io_dup *id =3D io_kiocb_to_cmd(req, struct io_dup);
> > +     struct file *file =3D NULL;
> > +
> > +     if (!id->rsrc_node)
> > +             id->rsrc_node =3D
> > +                     io_file_get_fixed_node(req, file_slot, issue_flag=
s);
>
> Just use the full line length, io_uring isn't a stickler on 80 chars and
> it'd read better as:

Done, thanks!

>
>         if (!id->rsrc_node)
>                 id->rsrc_node =3D io_file_get_fixed_node(req, file_slot, =
issue_flags);
>
> Need to check further, but I'm assuming the difference here is for retry
> where the node could already be assigned?

That's right

>
>
> > +static int io_dup_to_fd(struct io_kiocb *req, unsigned int issue_flags=
,
> > +                     bool old_fixed, int old_fd, int new_fd, int o_fla=
gs)
> > +{
> > +     struct file *old_file, *to_replace, *to_close =3D NULL;
> > +     bool non_block =3D issue_flags & IO_URING_F_NONBLOCK;
> > +     struct files_struct *files =3D current->files;
> > +     int ret;
> > +
> > +     if (new_fd >=3D rlimit(RLIMIT_NOFILE))
> > +             return -EBADF;
> > +
> > +     if (old_fixed)
> > +             old_file =3D io_dup_get_old_file_fixed(req, issue_flags, =
old_fd);
> > +
> > +     spin_lock(&files->file_lock);
>
> If you use:
>
>         guard(spinlock)(&files->file_lock);
>
> and move:
>
> > +
> > +     /* Do we need to expand? If so, be safe and punt to async */
> > +     if (new_fd >=3D files_fdtable(files)->max_fds && non_block)
> > +             goto out_again;
> > +     ret =3D expand_files(files, new_fd);
> > +     if (ret < 0)
> > +             goto out_unlock;
> > +
> > +     if (!old_fixed)
> > +             old_file =3D files_lookup_fd_locked(files, old_fd);
> > +
> > +     ret =3D -EBADF;
> > +     if (!old_file)
> > +             goto out_unlock;
> > +
> > +     to_replace =3D files_lookup_fd_locked(files, new_fd);
> > +     if (to_replace) {
> > +             if (io_is_uring_fops(to_replace))
> > +                     goto out_unlock;
> > +
> > +             /* if the file has a flush method, be safe and punt to as=
ync */
> > +             if (to_replace->f_op->flush && non_block)
> > +                     goto out_again;
> > +     }
> > +     to_close =3D do_replace_fd_locked(files, old_file, new_fd, o_flag=
s);
> > +     ret =3D new_fd;
>
> into a helper, all of this somewhat messy goto error_handling stuff can
> go away.

Neat!

I didn't move it into a separate helper, because it has to return three thi=
ngs:
* The completeness of the operation (IOU_COMPLETE or -EAGAIN)
* An eventual error
* The file to close

Using a guard in a block and another small helper I managed to avoid
the gotos, as suggested.

Thanks!

>
> --
> Jens Axboe

