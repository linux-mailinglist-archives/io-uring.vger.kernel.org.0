Return-Path: <io-uring+bounces-11968-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id BwgTKKG3emmo9gEAu9opvQ
	(envelope-from <io-uring+bounces-11968-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 02:28:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31856AABE3
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 02:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ABD5030333ED
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 01:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A9D379992;
	Thu, 29 Jan 2026 01:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFn7qH7S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A126379973
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 01:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649416; cv=pass; b=T+GJwHPjfJ9IBqtgzTMKTMV/HHEn4ccuERvz6/QQML6xxfKj3uDkWjy1dLJ/DZznPho01s7EH1K1rzDiZetaVKc6M4eEBjeRlXSL/vqlRtN2vVYXfYOKsJ2z9k+IWiFEHxoelvfK0R2WTZ2gYQ69vDT3z4w7lDappXSlEX83nT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649416; c=relaxed/simple;
	bh=Ha1tIN7hHGKpkhiGYJaEWRTlSqz76f1xHZV/A88CtXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E35Co3H5kGccizbErHNqdP1f4JWOXl5shAnEKjY7O+g7Kaeu35nIiqyvqA6R9LB4xQjQw9cTaXpV9X61/sHAPp1Uy6U1PpSV6s5Vne6wZaeeq0Q2tC+JIZVZgAMY1wdoFJurBZQQOJB/ih+ICmgCrjp1GbsFGV7nnDeCuUtoMjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFn7qH7S; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c6a822068eso67272885a.3
        for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 17:16:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769649414; cv=none;
        d=google.com; s=arc-20240605;
        b=G5qNvCVgJW4BNm/fzFgXrBSmnuP2WL4ozoHOkAj8Y4y20IPDnGmYRisrruRJH+2jg1
         N5xwrDuAENWXE/xLA+qWCufeQQMkKLSEjWqFeKHuy4wKANdueltkpFCox4EMOKDSJ+Ls
         DtZ2cHz+5itLcYQOQbcXFthC/dVcBDK34LL8HGXK6pbM7rjMzjj5rC44Yceb08C4gdDY
         W44+27rtBjiAGqUBR0p/fSCEX6NE9cu5eNqW8pwetKg3VDgO2i3CnnoKQsg8GeO6I0wb
         HvuWijYi2CzPTeBat+CB6ADdSSMX7zjFWkzIUH1DAlEggkvh9NL7cUXzf3VrNoOhJ5Yz
         MVxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=134hHTGFx4DsoZAW9zkpXmrMLO/ZOkI8ziAgMpQNXTI=;
        fh=mV+bdiyxdC28NMx5hVVeanFdc9u04LjcTSRvBGeJvcM=;
        b=eD+PLvd4UwqIw+2jsA3kzPQbSR6FfVbgBF4Wsknnwr1gALeMO7ISP4dLu4vsA9AZbt
         dcKmGsbvtlo3B3oRbbGAXUB7BEwPGtdN/jIu/xq/S8bR5Ne1brUDtPBJevVny7JpK9uy
         farHvO5qnolrmyjWcKDj2GOBsh1W7sTgc6GogHD64luLzxYiPzl4IR0pYzRH6/g3iAA3
         y4twOahVprTml/z8gUvHHkwlWzzLCzp+eHJG7S6mA/ouyZgeV8FZIYCOC9UB+Fw7P+Cv
         h5p0p552oxLQCHiIcwLJ+TFByPsfthcmPhb41B2r7WZVUV7aOANianc6czW0X1RJ9Bzv
         WEew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769649414; x=1770254214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=134hHTGFx4DsoZAW9zkpXmrMLO/ZOkI8ziAgMpQNXTI=;
        b=gFn7qH7S8g8q3qAzcDll3SRs5GXqLNC8fJJJuwZtapJCyQ74XpyHl23OsR6xVB8bK/
         cstmS041f0JrEUUMlkZ+2ezn1VdYyTWLTBM4j9zDnS6L0zpbUX4K0kmVxz1rmT3YxP+T
         OGcXXaRJxJ9ESMk1BPXwWwrNTOngVGiqCUh9XwZ7e9MX9k4fdfHVaO1JgXi+PkXJdQk+
         JpomBbC2gKHra2mtsUNKhWiy1Dm8fhIpvv8EEVo9tnDDDhhO/6aDvLlahhsiVRKuzi6c
         lAx9T/RKznSxC+IDDnYgmcMF9gqzNIKbsJMTHn3V155irWCN+cUMzRGLR37EHWJpec1v
         2Itw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649414; x=1770254214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=134hHTGFx4DsoZAW9zkpXmrMLO/ZOkI8ziAgMpQNXTI=;
        b=b42qkinciA/oSJWY7QF7SScncuh2EUbXR6PlgQ5OP9KWaacW/tzAUktcePuKvpNS57
         IqgwyC0U2ocZmflrZN0BEVO+dch6QjxxosyllfbRzaaOCp8aHM2qNrRzb3v/vDMHxWvg
         D4MASsla3/pAWgg/LNnjz1anKrn1g0qnUHaiYIHjm5eTpYPwUk03Kf3xTSzRGuLz7Hvx
         EHiGOFNdFfZ54bFemKj/rwqk0qDO6mL9AYtiNPV7soJ9oTtiLDOdKeX2RVDEun2DRVoK
         IBAc1TFutA6JFiCmMJcShvA/d/lHVmv1TzdWzw0DcqXw6rKqTeArJjDiwypYlCL81qg6
         vJXw==
X-Forwarded-Encrypted: i=1; AJvYcCVZrUqUKYa5eunV+X9bILrpODB7C6fZxDp491cOlSn5Cx/k5yhQx0MaIT+bmtNxeGXaaLvU+HBf/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj1beu9eO14UA28FtQuWMB0N7i3BQ2a+xs8vjMftyAB/X2PoId
	rg1fuc8Tzzq8hDMQHSlWuv4rbYQYZOgpUcDzfEpmFEioS29dccFLtDfTgLle41639O8M6C4JGc4
	vZfSmLy2ooYIVsO6hEiTRYv62VQnKBPg=
X-Gm-Gg: AZuq6aIn6zXwrPlP3IpLm6nd7Pl4pQn60oZfym39MS8sBK6fxKaQZmmg4ufxM/aH3aP
	7g9Via1ZdXnwTY8ZgADejoggc2UbtJITpeOw9McuSLYqCDz6qEgN44IHmoff3tv4vqq7VdQG8vq
	yE65uFS9gbEKO15b7Xb8fXGNrfn+wjhTA+LyB9+FB2yQ1Q1lAu6961Z+4PbR6ZPFAoVm3yNXnS/
	QSL4NMZPCy2n39bvptFaA43NjAfLuEuSXJu2ocJVl0qGokcTB1vGSB04f83lTAaYAHWuQ==
X-Received: by 2002:ac8:5dd1:0:b0:501:4e87:70b7 with SMTP id
 d75a77b69052e-5032f74b0f6mr93787571cf.1.1769649414123; Wed, 28 Jan 2026
 17:16:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-19-joannelkoong@gmail.com> <68b3ff9d-ebcf-45c9-a50a-b5a59d332f4c@ddn.com>
 <CAJnrk1bn6A2i4Kr-W=VTUVqeewhR-eVNZXoQtDi8v4=Qyme6DQ@mail.gmail.com> <be475a3b-fe3f-43b2-ace6-3a7158d4d96c@bsbernd.com>
In-Reply-To: <be475a3b-fe3f-43b2-ace6-3a7158d4d96c@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 28 Jan 2026 17:16:43 -0800
X-Gm-Features: AZwV_Qhx5ybxot0C94y6kD51M3S2Jxwo3z5pmQyFPryjEscwAW9LSyz9j8Fsg3w
Message-ID: <CAJnrk1bBQYW6rVXK=nHis+emO2v-rif-GnvXGbSaSk1if-fo9w@mail.gmail.com>
Subject: Re: [PATCH v4 18/25] fuse: support buffer copying for kernel addresses
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>, axboe@kernel.dk, miklos@szeredi.hu, 
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org, 
	asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11968-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[ddn.com,kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
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
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bsbernd.com:email,ddn.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 31856AABE3
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 1:14=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 1/28/26 01:23, Joanne Koong wrote:
> > On Tue, Jan 27, 2026 at 3:40=E2=80=AFPM Bernd Schubert <bschubert@ddn.c=
om> wrote:
> >>
> >> On 1/17/26 00:30, Joanne Koong wrote:
> >>> This is a preparatory patch needed to support kernel-managed ring
> >>> buffers in fuse-over-io-uring. For kernel-managed ring buffers, we ge=
t
> >>> the vmapped address of the buffer which we can directly use.
> >>>
> >>> Currently, buffer copying in fuse only supports extracting underlying
> >>> pages from an iov iter and kmapping them. This commit allows buffer
> >>> copying to work directly on a kaddr.
> >>>
> >>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>> ---
> >>>  fs/fuse/dev.c        | 23 +++++++++++++++++------
> >>>  fs/fuse/fuse_dev_i.h |  7 ++++++-
> >>>  2 files changed, 23 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> >>> index 6d59cbc877c6..ceb5d6a553c0 100644
> >>> --- a/fs/fuse/dev.c
> >>> +++ b/fs/fuse/dev.c
> >>> @@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, b=
ool write,
> >>>  /* Unmap and put previous page of userspace buffer */
> >>>  void fuse_copy_finish(struct fuse_copy_state *cs)
> >>>  {
> >>> +     if (cs->is_kaddr)
> >>> +             return;
> >>> +
> >>>       if (cs->currbuf) {
> >>>               struct pipe_buffer *buf =3D cs->currbuf;
> >>>
> >>> @@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state =
*cs)
> >>>       struct page *page;
> >>>       int err;
> >>>
> >>> +     if (cs->is_kaddr)
> >>> +             return 0;
> >>> +
> >>>       err =3D unlock_request(cs->req);
> >>>       if (err)
> >>>               return err;
> >>> @@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state =
*cs, void **val, unsigned *size)
> >>>  {
> >>>       unsigned ncpy =3D min(*size, cs->len);
> >>>       if (val) {
> >>> -             void *pgaddr =3D kmap_local_page(cs->pg);
> >>> -             void *buf =3D pgaddr + cs->offset;
> >>> +             void *pgaddr, *buf;
> >>> +             if (!cs->is_kaddr) {
> >>> +                     pgaddr =3D kmap_local_page(cs->pg);
> >>> +                     buf =3D pgaddr + cs->offset;
> >>> +             } else {
> >>> +                     buf =3D cs->kaddr + cs->offset;
> >>> +             }
> >>>
> >>>               if (cs->write)
> >>>                       memcpy(buf, *val, ncpy);
> >>>               else
> >>>                       memcpy(*val, buf, ncpy);
> >>> -
> >>> -             kunmap_local(pgaddr);
> >>> +             if (!cs->is_kaddr)
> >>> +                     kunmap_local(pgaddr);
> >>>               *val +=3D ncpy;
> >>>       }
> >>>       *size -=3D ncpy;
> >>> @@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_sta=
te *cs, struct folio **foliop,
> >>>       }
> >>>
> >>>       while (count) {
> >>> -             if (cs->write && cs->pipebufs && folio) {
> >>> +             if (cs->write && cs->pipebufs && folio && !cs->is_kaddr=
) {
> >>>                       /*
> >>>                        * Can't control lifetime of pipe buffers, so a=
lways
> >>>                        * copy user pages.
> >>> @@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_sta=
te *cs, struct folio **foliop,
> >>>                       } else {
> >>>                               return fuse_ref_folio(cs, folio, offset=
, count);
> >>>                       }
> >>> -             } else if (!cs->len) {
> >>> +             } else if (!cs->len && !cs->is_kaddr) {
> >>>                       if (cs->move_folios && folio &&
> >>>                           offset =3D=3D 0 && count =3D=3D size) {
> >>>                               err =3D fuse_try_move_folio(cs, foliop)=
;
> >>> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> >>> index 134bf44aff0d..aa1d25421054 100644
> >>> --- a/fs/fuse/fuse_dev_i.h
> >>> +++ b/fs/fuse/fuse_dev_i.h
> >>> @@ -28,12 +28,17 @@ struct fuse_copy_state {
> >>>       struct pipe_buffer *currbuf;
> >>>       struct pipe_inode_info *pipe;
> >>>       unsigned long nr_segs;
> >>> -     struct page *pg;
> >>> +     union {
> >>> +             struct page *pg;
> >>> +             void *kaddr;
> >>> +     };
> >>>       unsigned int len;
> >>>       unsigned int offset;
> >>>       bool write:1;
> >>>       bool move_folios:1;
> >>>       bool is_uring:1;
> >>> +     /* if set, use kaddr; otherwise use pg */
> >>> +     bool is_kaddr:1;
> >>>       struct {
> >>>               unsigned int copied_sz; /* copied size into the user bu=
ffer */
> >>>       } ring;
> >>
> >>
> >> I'm confused here, how cs->len will get initialized. So far that was
> >> done from fuse_copy_fill?
> >
> > With kaddrs, cs->len is initialized when the copy state is set up (in
> > setup_fuse_copy_state()) before we do any copying to/from the ring.
> > The changes for that are in the later patch that adds the ringbuffer
> > logic ("fuse: add io-uring kernel-managed buffer ring"). The kaddr and
> > len correspond to the address and length of the buffer that was
> > selected from the ring buffer (in fuse_uring_select_buffer()).
>
>
>
> Maybe we could add a sanity check into fuse_copy_do() or even into
> fuse_copy_fill in the cs->is_kaddr condition that cs->len is > 0?

I will add a WARN_ON for this in the next version. Thanks for reviewing thi=
s.

Thanks,
Joanne
>
> Otherwise looks good.
>
> Reviewed-by: Bernd Schubert <bernd@bsbernd.com>

